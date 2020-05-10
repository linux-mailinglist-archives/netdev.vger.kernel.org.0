Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2421CC5E3
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 03:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgEJBEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 21:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728597AbgEJBEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 21:04:46 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A43C061A0C;
        Sat,  9 May 2020 18:04:45 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id s9so4475447lfp.1;
        Sat, 09 May 2020 18:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f9OMJ4QqO80W6llrJvtktoKcBibXIt97DfEYZTwrp+I=;
        b=JfRiwM+DA54Yb3KW3YcaBNYYA7zjOFzPII3+AfFCs++UpE3u0ni3a57OSI8UoUa/py
         y2tfRxfw/u71ojnNnOIebELUbuUCbUv9qunoV4ZgfKU0i/PnvHQH4+OC3NJdLUeD08a3
         qm9KDZrT7kmvFHsjY7UN4lZXE2RHgK1n8acbF3JeFOtfkcXUYlOBNFRNgtK6RcYD9dhY
         UwIwUHgv+vKGXDMpyjv6kI/Gewuqx8eJrMz7KZ9Jr3PF8/P7XpulWDcAj1uioZzpKQ0O
         MblxCAHuXLpCTtvtwMh2xM3o25n6Z0ZA12Ul+jyPjYjVBwdhnrVcM8f3lgb5NOGJvPFK
         kB0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f9OMJ4QqO80W6llrJvtktoKcBibXIt97DfEYZTwrp+I=;
        b=tE9vt3ERSFXB48/TTkwzXqdMb65+mKm5zLG/GHuxCjvFj2haGCk9ElfhxkRiSHY9Bz
         9KWxayMI2F05PR9pr9am/A7JcH4CFvfQLQQeTtaBz1HD9i1njJJC6ivDdeLSbh23mWrQ
         j0KdStMf417fB74P0u0M86CdxfzX3L+rfCy0QKy8NEkGF/GPISu7Wng6wOx4fRGCdC1e
         8mRu/DVwuoW+nw9bn4K6l2pkmyGny/3iRubwORSn8HTl9O+DVIp/vLgkpNB56GRI2JCh
         y2K0Q6wfJSHHWm/LQcVxtZjqfYlVxZ1P58rsHwsTT17H3D4loh8j06jZQXDkGHftWENP
         +TAQ==
X-Gm-Message-State: AOAM533HBJm44FfvB3SrV3WDof3PkmNsTzTDYMW1+6+u8DYwzlG4hizR
        0myQOwLdbwvc6I2+iWgm4FEtOwwgb74tnhDTE+k=
X-Google-Smtp-Source: ABdhPJyPxH8lACy7OQ9qPIfDShUjzuMcC8PErrHH9XH7PduJIqq/pVypBNAIZ9nYVSnE9O+0PX86JvGv8hSHbUBAPC8=
X-Received: by 2002:ac2:442f:: with SMTP id w15mr6381987lfl.73.1589072684189;
 Sat, 09 May 2020 18:04:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200509073915.860588-1-masahiroy@kernel.org>
In-Reply-To: <20200509073915.860588-1-masahiroy@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 9 May 2020 18:04:32 -0700
Message-ID: <CAADnVQJvJWwziwDj0ZgPc02iHNNk8EJetDqNZ6SoWq045C-gXQ@mail.gmail.com>
Subject: Re: [PATCH] bpfilter: check if $(CC) can static link in Kconfig
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 9, 2020 at 12:40 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> On Fedora, linking static libraries requires the glibc-static RPM
> package, which is not part of the glibc-devel package.
>
> CONFIG_CC_CAN_LINK does not check the capability of static linking,
> so you can enable CONFIG_BPFILTER_UMH, then fail to build.
>
>   HOSTLD  net/bpfilter/bpfilter_umh
> /usr/bin/ld: cannot find -lc
> collect2: error: ld returned 1 exit status
>
> Add CONFIG_CC_CAN_LINK_STATIC, and make CONFIG_BPFILTER_UMH depend
> on it.
>
> Reported-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

Thanks!
Acked-by: Alexei Starovoitov <ast@kernel.org>
