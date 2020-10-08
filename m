Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC09B28785F
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730123AbgJHPxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731484AbgJHPxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:53:25 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3EEC0613D2;
        Thu,  8 Oct 2020 08:53:25 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id o9so2948039plx.10;
        Thu, 08 Oct 2020 08:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wlK985XdNYgqlNz52vaAK41kNTmxDtYC00O6u3gRaPk=;
        b=ssdZbQtSHvhYXfJa5UbGBxuMH73O5Um20SnlG6GzvEPTwqCUVTx7Xg8iTm34OjUyKK
         C5OHJ6ihNhbgz14YxYqkmTLBi+oP2NDMUWPOTpJQxdpI6NRnmaKZ0j0zWvcfeElSupnp
         L4WHtwHPIhw9Oh4//yNb8JsNi8MbgG7lrQFTio4t+BRbbE7ffgJOcF0TzrBODYArlhLw
         r+w2YMMQvEu5c6qIC3TsUsdU1db5N1lLuOUKSZXPxIuaWxO9byp5OWNxyW01fD06K4qA
         1HNlDeKpZ2Sl2IOTvooP4fmrqJHmG+hjL4QkSoESjQi5Bza1L19SQlra9TkRDcpIrfdL
         LvDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wlK985XdNYgqlNz52vaAK41kNTmxDtYC00O6u3gRaPk=;
        b=ie7oAlveK/syht1az90EWm9ZbW9XvaPw8vdKh5WKckfOxYz6VG9YUW1mKLMeokR5pl
         pr3I4pS2L6Hk/7wSujN3xIuEBZyNjwdwPLS2xSBfT1V1tS4c/e8mHOI6z9n0YJw3xHKp
         +qo+Oub/izVhZ/hUWibpp1cyqshMm6NI5JlGCPse/k7Oj/Zd56MDlT9dBlgceDGQrGv7
         lqO8P8BXI+m5OurJo5/JLrmw8NCRqgEigxFhftgz7U3l41GdOGUyeb9Q5WruJhNDFvXl
         gIx+TybiwlX2rlQp60XO9vgaAyQzS1jrFQ7QAZ7qyZ92DUUoAyMK31pXRrrqMgKOrvCz
         xMNQ==
X-Gm-Message-State: AOAM531x41Dy2CJIs4GVqXA8ZRiTJzKgjCoqt2aXUg8XZpyMOBT+dHP4
        GPFDf5FZoZU0Qy3wWYS9dZk=
X-Google-Smtp-Source: ABdhPJxgUm5FI1mVxibLOb4K0sZvTzNXchAvwwXN8cZkd2w/HkuUXpWUvMMb7yyEPQHiRLTFPgXIQA==
X-Received: by 2002:a17:902:c697:b029:d3:df24:163e with SMTP id r23-20020a170902c697b02900d3df24163emr8159008plx.18.1602172405144;
        Thu, 08 Oct 2020 08:53:25 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:8fd0])
        by smtp.gmail.com with ESMTPSA id js21sm4104970pjb.14.2020.10.08.08.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:24 -0700 (PDT)
Date:   Thu, 8 Oct 2020 08:53:22 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 1/3] bpf: Propagate scalar ranges through
 register assignments.
Message-ID: <20201008155322.lggsfuuzeevtcqjy@ast-mbp>
References: <20201006200955.12350-1-alexei.starovoitov@gmail.com>
 <20201006200955.12350-2-alexei.starovoitov@gmail.com>
 <5f7e52ce81308_1a83120890@john-XPS-13-9370.notmuch>
 <5f7e556c1e610_1a831208d2@john-XPS-13-9370.notmuch>
 <20201008014553.tbw7gioqnsg6zowb@ast-mbp>
 <5f7f2dd685aa6_2007208e9@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f7f2dd685aa6_2007208e9@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 08:18:46AM -0700, John Fastabend wrote:
> > 
> > I couldn't think of any other case where scalar's ID has to be cleared.
> > Any kind of assignment and r0 return do it as well.
> 
> How about a zero extending move?
> 
>  r1 = r2 <- r1.id = r2.id
>  w1 = w1
> 
> that will narrow the bounds on r1 but r2 should not be narrowed? So
> we need to zero the r1.id I believe. But, I don't see where we
> would set r1.id = 0 in this case.

Excellent catch! Indeed. id should be cleared for 32-bit move.
Will fix.

> > 
> > Any other case you can think of ?
> 
> Still churning on the above zero extending move. Also I thought
> it was a bit odd that this wouldn't work,
> 
>  r1 = r2
>  r0 = r1
>  if r0 < 2 goto ...
> 
> then r0.id != r2.id because a new id is generated on the second
> mov there. I don't actually care that much because I can't recall
> seeing this pattern.

Right. Since it's easy to support this case I'll add it as well.
Though I also never seen llvm generate the code like this and I don't
think it will based on my understanding of regalloc.

> > I think some time in the past you've mentioned that you hit
> > exactly this greedy register alloc issue in your cilium programs.
> > Is it the case or am I misremembering?
> 
> Yes, I hit this a lot actually for whatever reason. Something
> about the code I write maybe. It also tends to be inside a loop
> so messing with volatiles doesn't help. End result is I get
> a handful of small asm blocks to force compiler into generating
> code the verifier doesn't trip up on. I was going to add I think
> the cover letter understates how much this should help.

Yeah. We also see such patterns only inside the loops with large
loop bodies, and especially in unrolled loops.
My understanding is that this is normal behavior of the greedy register
allocator that introduces register copy for the split ranges.
Yonghong sent me that link that explains algorithm in details:
http://llvm.org/devmtg/2018-04/slides/Yatsina-LLVM%20Greedy%20Register%20Allocator.pdf
The slide 137 and following slides explain exactly this scenario.

In other words there is no way to tell llvm 'not to do this',
so we have to improve the verifier smartness in such case.

I'll add these details to commit log.

> I still need to try some of Yonghong's latest patches maybe I'll
> push this patch on my stack as well and see how much asm I can
> delete.

The 2 out of 3 patches already landed. Please pull the latest llvm master.
