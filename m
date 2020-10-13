Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E30628CF9B
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 15:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388131AbgJMNz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 09:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388109AbgJMNz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 09:55:58 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B02C0613D5
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 06:55:58 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id g4so21061145edk.0
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 06:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2DKMoCh7i0xXAWOnYeO6FL9jlempYdRNzXVQVsNyqDY=;
        b=fsKgrx1nEp+1zchBFjTXcKd5V+R173W0PhVeHFHzr9UIGmX3MklhJFXn4qfqDfr9Wj
         M1q9af5G/pwZETq9WS174yp7qv8oxPxJDa5PtmhUiDPn1MYom3w2nac2S9MYTO+rn1gM
         0+zDNYuAkmMqx0p0crmRnaFlMMNn0zlvO8I0gAmub3bgGzFzc8cUfeYIewe5hP+37f8D
         sDAzTfzD+/hytUKJl++0KWGnJFOLQr8YBmFtuOIvF311sMne2ArIczKOgqF6/6QXM0TJ
         O0drHevOIsrkeWKH1j5vXcCeQDElotKIrg/YMioV+/hZvXeEgJ6F8cO1eVJtOAF85FKA
         itSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2DKMoCh7i0xXAWOnYeO6FL9jlempYdRNzXVQVsNyqDY=;
        b=SFawrF5k4k0omkJmnlaPB5YaldPXwMwhizyr64jGnK//6p/4ALqhW+pKnGKGhZngVH
         5VzIrtyLMaJbfZxgf4CDs1SNultNw6Ip3o/xM5y1NLVsr2+ruzknKiLH11n+pCwRtnxi
         XpFLJgB3AJCOyd6zeSpe0EhQ3ZzEIbm8jZcHTCHBuiyxMWTIFKqDLBo47jjxBuT/e2fp
         KjbFFjmDcrMpbGnU3qSvWHDahGx+nlMxg7X487DAS1G+f4h00aFM5D3xiD+eRKTdjIAG
         AWmKe9Fa6csvIp2cStL//VWXoEEhTdlktsIxPE0cEKd3RbViJYKECikUY/7lejYK84Mw
         E9Bg==
X-Gm-Message-State: AOAM531fbolFu93VxWaepCywZfJ1Q4tzmNftZY5SoJE7JPvgRbMBTlJK
        e49CdxCLquI9jAtvtRG6LeVg9xHqiZMbVac9B+MUnWbhYcIk
X-Google-Smtp-Source: ABdhPJz4mWBTImguVLP1oOYwD74t1j+Rz05Yi+H2J8qQGgIbt2DJB2D6fzj+alkUR+BDXvSGkJshtQiiAMzkKwjckkw=
X-Received: by 2002:a17:906:c444:: with SMTP id ck4mr31616284ejb.398.1602597352084;
 Tue, 13 Oct 2020 06:55:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200930094934.32144-1-richard_c_haines@btinternet.com>
 <20200930094934.32144-4-richard_c_haines@btinternet.com> <20200930110153.GT3871@nataraja>
 <33cf57c9599842247c45c92aa22468ec89f7ba64.camel@btinternet.com>
 <20200930133847.GD238904@nataraja> <CAHC9VhT5HahBhow0RzWHs1yAh5qQw2dZ-3vgJv5GuyFWrXau1A@mail.gmail.com>
 <20201012093851.GF947663@nataraja>
In-Reply-To: <20201012093851.GF947663@nataraja>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 13 Oct 2020 09:55:40 -0400
Message-ID: <CAHC9VhTrSBsm-qVh95J2SzUq5=_pESwTUBRmVSjXOoyG+97jYA@mail.gmail.com>
Subject: Re: [PATCH 3/3] selinux: Add SELinux GTP support
To:     Harald Welte <laforge@gnumonks.org>
Cc:     pablo@netfilter.org,
        Richard Haines <richard_c_haines@btinternet.com>,
        selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 5:40 AM Harald Welte <laforge@gnumonks.org> wrote:
>
> Hi Paul,
>
> On Sun, Oct 11, 2020 at 10:09:11PM -0400, Paul Moore wrote:
> > Harald, Pablo - I know you both suggested taking a slow iterative
> > approach to merging functionality, perhaps you could also help those
> > of us on the SELinux side better understand some of the common GTP use
> > cases?
>
> There really only is one use case for this code:  The GGSN or P-GW function
> in the 3GPP network architecture ...
>
> Hope this helps,
>         Harald

It does, thank you.

It looks like this patchset is not really a candidate for merging in
its current form, but I didn't want to lose this information (both the
patches and Harald's comments) so I created a GH issue to track this
at the URL below.

* https://github.com/SELinuxProject/selinux-kernel/issues/54

-- 
paul moore
www.paul-moore.com
