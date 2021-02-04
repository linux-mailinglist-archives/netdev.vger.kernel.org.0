Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD92330EABD
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 04:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbhBDDNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 22:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhBDDNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 22:13:30 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B88C061573;
        Wed,  3 Feb 2021 19:12:50 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id g3so1002312plp.2;
        Wed, 03 Feb 2021 19:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XhHDayQB6Bi+C4TWSaGKSP5yjJWA2Wx9lGm+oTkaXBI=;
        b=Byaxvcpx2bWRrGEFfGMPzkBMxleLp6Ax3eF10E0gLScSJsyRHkIAjznCnqUJuf7v8C
         7Ehkqhlyf3l8UTzVbqYFrt+5N/lpcAhquCKyTQyh9+FiddUIaheCKMKF1s2JRN+zAOyW
         hwU6HQZomBJCEvcljygZ+hL1gduNUgTx1P7d6ggzpWMwRQaf4UWr8Ky11LWrZEZ3bupt
         EYWBoVOwvx2ZU4ZuOl5rK3WLBZUWuO3MZfXZ7XZWUbdumWSSnRFo2BpO0jwUMv4Qcc8A
         h91SrwM55St47zQegY0pBP1LIG851eGxDMk2hzVENeOa9/9snA2W+ineygAk5nh+OfJT
         403A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XhHDayQB6Bi+C4TWSaGKSP5yjJWA2Wx9lGm+oTkaXBI=;
        b=ZlnkMlJoe++oeqdWarQoo5duPlOKUoR/BZWKo9N6tTrpCE6VQh6nFoL5ST872ojqc7
         k5H0oCVI/k41mY36sRMEyW9k4NTObOd7bPczlm1qVvqTOH/QnuA0zNpIgYhMgg6Meuww
         Nd6dcNcodpMVjnyx3yrD59UbzaAASUkC3Smme8asN9xusIQOHxMKpG2p+En6KN6PHXBm
         4qTy2mskOixenoPd54EHn66+Qb+jSN2bplwRjwuSoUSAsPs4oheFLli9KSTgwU8n+/zX
         AqzYk+oOTnVn1pXZnM3zTqcXIgD/UZbUYQHvsl5qj5KDN8JRp/BgneWocoyHtSX4GUDb
         Xq0w==
X-Gm-Message-State: AOAM533qxQIGIbbhFnT8K9EKJ26IgdbIyauJ4/fmutJ0PuRP5rabF+8h
        fcc8+b5f4ifHVslLFIEcP+c=
X-Google-Smtp-Source: ABdhPJxdfl+5Ppr1chsWLkRQlVmIlvcQKTrG9Jbx73KMHA5V8Q/2w6RuMK/RC2qtwbuRPTHFC1FxjQ==
X-Received: by 2002:a17:902:e80c:b029:de:a20b:7a9c with SMTP id u12-20020a170902e80cb02900dea20b7a9cmr6271591plg.12.1612408369905;
        Wed, 03 Feb 2021 19:12:49 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f22sm3988108pfk.179.2021.02.03.19.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 19:12:49 -0800 (PST)
Date:   Thu, 4 Feb 2021 11:12:36 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        bpf@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCHv17 bpf-next 0/6] xdp: add a new helper for dev map
 multicast support
Message-ID: <20210204031236.GC2900@Leo-laptop-t470s>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210125124516.3098129-1-liuhangbin@gmail.com>
 <20210204001458.GB2900@Leo-laptop-t470s>
 <601b61a0e4868_194420834@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <601b61a0e4868_194420834@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 06:53:20PM -0800, John Fastabend wrote:
> Hangbin Liu wrote:
> > Hi Daniel, Alexei,
> > 
> > It has been one week after Maciej, Toke, John's review/ack. What should
> > I do to make a progress for this patch set?
> > 
> 
> Patchwork is usually the first place to check:

Thanks John for the link.
> 
>  https://patchwork.kernel.org/project/netdevbpf/list/?series=421095&state=*

Before I sent the email I only checked link
https://patchwork.kernel.org/project/netdevbpf/list/ but can't find my patch.

How do you get the series number?

> 
> Looks like it was marked changed requested. After this its unlikely
> anyone will follow up on it, rightly so given the assumption another
> revision is coming.
> 
> In this case my guess is it was moved into changes requested because
> I asked for a change, but then after some discussion you convinced me
> the change was not in fact needed.
> 
> Alexei, Daniel can probably tell you if its easier to just send a v18
> or pull in the v17 assuming any final reviews don't kick anything
> else up.

OK, I will wait for Alexei, Daniel and see if I need to do a rebase.

Thanks
Hangbin
