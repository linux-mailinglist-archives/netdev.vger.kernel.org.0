Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4142C38BFF3
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 08:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhEUGsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 02:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbhEUGs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 02:48:28 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76C0C061763
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 23:46:51 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id h7so9251010qvs.12
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 23:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xkcqft7IFEvhd4rZvjQTycxIt/7SM6fwOYhfxgeUU/8=;
        b=xo/iAwYxJFXLPRSYNkmZEM2ANcZrrcj3GAONNgnSnSC638ALOC9rea3BwxJKqqKR6K
         Ihjuh9mP6DeDWgHlQnlSQbLRAIKzw2PQNax6T5QrU+BWLongmcDSf6GoT61qaIyD4nyF
         QarSQPEdt0v+Bd1scWWrQMa6o2mX/3lQkT3oUfH5AXBDXB7R6IqdQHgnjfvmIZd4zk2Y
         Ch9SKaPUM4gsnzec4VyjxS+MoVrMuCaC3qsBJFBlSGtrDcdIQTJu43Gc19+IBSjbgbLd
         1LLnm8ApGBusoVOotvcMbsvXR81pQpUlJoCyI+T18FDepApOAnA0GOkojSssaB3jLMHv
         n/tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xkcqft7IFEvhd4rZvjQTycxIt/7SM6fwOYhfxgeUU/8=;
        b=HVZBtNpetWzAsFxE/CrpjU2/tSxDY/ERea7M34UVKqOrrivuEl/bdItXGV0oktIwsG
         f/yZaFnhQ726UAktTNaXwYnYrkBVpLCxmmNpNW8znqMa62sVP9OU318F62aSxyGthxzA
         y8PotHo6q2nQJBdOMb3e4Xvil8xCtxs2Cqas0FoZVLkOLP9ON+l0fQG45DvRMr6MrF2O
         bqx/fYUtBz40Miq+KSDtp2Irs8Mq1IWAsqT1gUGi77VlD2yd8dGckUqsk6KBsU4KJ+2C
         L1THcE2gdsNMtPjGoaqkb2FjVGnxDL/V3brj+eVJw8+qxObkqQ/E1qqIikVzmBCi3+UY
         j8eQ==
X-Gm-Message-State: AOAM530HSK4C+88KWTWpRfmuBvY4UdNbwy+MbS8f5iQIQAHG0vpeJGkQ
        9bmBWbMSyHm+V4etzcNzl9BvgQ==
X-Google-Smtp-Source: ABdhPJxcICEBMFCt1GiRkk4SvPNNmZMH+gOwPEnggK6FMXD6xNVIjbAMGMBB3NFDHXiMip3sLjpz6w==
X-Received: by 2002:a0c:9c0f:: with SMTP id v15mr10879355qve.24.1621579610100;
        Thu, 20 May 2021 23:46:50 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id h3sm4202813qkk.82.2021.05.20.23.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 23:46:49 -0700 (PDT)
Date:   Fri, 21 May 2021 10:46:45 +0400
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next 02/11] bpfilter: Add logging facility
Message-ID: <20210521064645.xhligmlrremyva4q@amnesia>
References: <20210517225308.720677-1-me@ubique.spb.ru>
 <20210517225308.720677-3-me@ubique.spb.ru>
 <CAPhsuW4osuNOagPRwUB30tk3V=ECANktt9jzb+NK1mqOamouSQ@mail.gmail.com>
 <20210520070807.cpmloff4urdsifuy@amnesia>
 <681F9A5A-63F0-432A-B188-CF4FC11AF2A8@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <681F9A5A-63F0-432A-B188-CF4FC11AF2A8@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 04:35:45PM +0000, Song Liu wrote:
> 
> 
> > On May 20, 2021, at 12:08 AM, Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
> > 
> > On Wed, May 19, 2021 at 10:32:25AM -0700, Song Liu wrote:
> >> On Tue, May 18, 2021 at 11:05 PM Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
> >>> 
> >>> There are three logging levels for messages: FATAL, NOTICE and DEBUG.
> >>> When a message is logged with FATAL level it results in bpfilter
> >>> usermode helper termination.
> >> 
> >> Could you please explain why we choose to have 3 levels? Will we need
> >> more levels,
> >> like WARNING, ERROR, etc.?
> > 
> > 
> > I found that I need one level for development - to trace what
> > goes rignt and wrong. At the same time as those messages go to
> > dmesg this level is too verbose to be used under normal
> > circumstances. That is why another level is introduced. And the
> > last one exists to verify invariants or error condintions from
> > which there is no right way to recover and they result in
> > bpfilter termination.
> 
> /dev/kmsg supports specifying priority of the message. Like:
> 
>    echo '<4> This message have priority of 4' > /dev/kmsg
> 
> Therefore, with proper priority settings, we can have more levels safely.
> Does this make sense?

Yes, it makes.
BPFILTER_FATAL should be renamed to BPFILTER_EMERG to match
printk() counterpart. All bpfilter log levels should match
printk() levels. All bpfilter log messages should include log
level. And BPFILTER_DEBUG should be easily turned on/off during
compilation to enable tracing/debug.


> 
> Thanks,
> Song
> 
> [...]
> 

-- 

Dmitrii Banshchikov
