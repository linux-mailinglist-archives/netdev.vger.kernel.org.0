Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D8E3B94A6
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 18:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhGAQ2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 12:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbhGAQ2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 12:28:49 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FD3C061762;
        Thu,  1 Jul 2021 09:26:18 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id s19so6960479ilj.1;
        Thu, 01 Jul 2021 09:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=2XdotHd/9Rh+BK080jiiJOcyvm9QE25ghUxjFU5Oqes=;
        b=vJW/sAkOCdqpQ/P8b8laZirQ+Hocgjyr25TnK08SYVLhB2jQ7/6pCsVYGud8ot2VG3
         Q4sXnzUzzrvrKpUq72jCT4SxUs0wMwYDM/gZke/7+UejTNFy0LjA6HU6wMJy5CH/84vh
         OswxV/dO6KpnCMbhnPfx1zvzdvQEiTYDmnR+csBtTdsII0LhJTHIJlyblB142Ouyn+eq
         HV/YSX9qpphSoeJjlqQJGJmsAGIIG7VEOXdZtmTEg0NiU68jZnJFlodkm7/4ChYycSTj
         BMiIwqiIXlNv15F5A8XJpnPi06gC6tMgvWvWH97Wc1t/reA63wR/XDXUhRBa5Kc3BHyG
         nhBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=2XdotHd/9Rh+BK080jiiJOcyvm9QE25ghUxjFU5Oqes=;
        b=XCK+Axg67xby4vCWF7K03z70Xx5W2pIrj0l/UTb0TrvbAL6oo1mIi5s8zZ+CpYOn7v
         dyoydMcfBNC8Nlr2maShSoSquDcNEPwTzv9ry+z8CRd7WnCUKTZ/SPMCExQVHcHmUBV9
         Qc1SyePt1waYsI1PUSzjPvupuoaE8fCgTLbSPxrF6Mr3lX+WjH6U8YHSQJuaK4tFGo/u
         pEt3nhrDdaaSJA2QILLxUzy8KXcMmTckNG5X60c+5RDwRO+W8Jh+ztzjKtidmaBQmpfx
         Qzup50uzhsCeeDgb/5D1fQz6xhNGY2qxHYa/qG1BE8dpOLqGmZrWk/2Ld1rbKcDvdMZJ
         L0Sw==
X-Gm-Message-State: AOAM5311LlnBIo13rvEcfcq1ULgxwyH4n2yz4Qub3WumKsEQYxSCJQ+k
        cJJheDJa3SM5FADGTQfiYX0=
X-Google-Smtp-Source: ABdhPJwJIgpDOEQ5GhWIVardLzgHkCSkA2L+LOW2yL7j/HnvWhEYfjJfwdCrYhRLqX+YoYX5K73EIQ==
X-Received: by 2002:a92:a304:: with SMTP id a4mr161073ili.197.1625156777970;
        Thu, 01 Jul 2021 09:26:17 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id e14sm201023ilc.47.2021.07.01.09.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 09:26:17 -0700 (PDT)
Date:   Thu, 01 Jul 2021 09:26:07 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60ddec9f5abd6_3fe24208c3@john-XPS-13-9370.notmuch>
In-Reply-To: <877diarpsz.fsf@cloudflare.com>
References: <20210701061656.34150-1-xiyou.wangcong@gmail.com>
 <877diarpsz.fsf@cloudflare.com>
Subject: Re: [Patch bpf v2] skmsg: check sk_rcvbuf limit before queuing to
 ingress_skb
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Thu, Jul 01, 2021 at 08:16 AM CEST, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Jiang observed OOM frequently when testing our AF_UNIX/UDP
> > proxy. This is due to the fact that we do not actually limit
> > the socket memory before queueing skb to ingress_skb. We
> > charge the skb memory later when handling the psock backlog,
> > but it is not limited either.
> >
> > This patch adds checks for sk->sk_rcvbuf right before queuing
> > to ingress_skb and drops packets if this limit exceeds. This
> > is very similar to UDP receive path. Ideally we should set the
> > skb owner before this check too, but it is hard to make TCP
> > happy about sk_forward_alloc.
> >
> > Reported-by: Jiang Wang <jiang.wang@bytedance.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> 
> Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
> 
> By saying that it is hard to make TCP happy about sk_forward_alloc, I'm
> guessing you're referring to problems described in 144748eb0c44 ("bpf,
> sockmap: Fix incorrect fwd_alloc accounting") [1]?

I have a couple fixes on my stack here I'm testing that clean up
the tear down logic. Once thats in place maybe its as simple
as adding the owner_r bits and calling the destructor to ensure
memory accounting happens earlier so these ingress_skb packets
are accounted for.

I'll flush those out today, maybe it will be clear then.

> 
> Thanks for the fix.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=144748eb0c445091466c9b741ebd0bfcc5914f3d
> 
> [...]


