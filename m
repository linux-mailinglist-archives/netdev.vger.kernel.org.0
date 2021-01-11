Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98252F1F94
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403861AbhAKTep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:34:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390813AbhAKTeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 14:34:44 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4FAC061794;
        Mon, 11 Jan 2021 11:34:04 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id x15so341238ilq.1;
        Mon, 11 Jan 2021 11:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5n87tlf//wbzIK0eFiapoMfQ9AN1g8d2FAoAK9a2vxY=;
        b=Rq4NY83BuV9gdq7ymDniXgE3trbn7AuWPX5XYRuawZOf3jkN7iziyclvuU/QMCUHPU
         rmMU25jDfrKvPW4ayQTUxpimEJ9WzdPmc245vbt2wq69TSazRKSNXyLQqNADZOWd3xX/
         +9IKJ92XGDBm8QOYOb84gmTJh5ufYhJHY+PNmZMmdZi4u+4naJWNhVj8pQoB2k+aDf3s
         wpiwxCk5b5dn7Mij0UywlCyVmBt/t71Dg90yxMnh32+PaYrcklD79sFo7axxUwaG08l/
         w3X57MW4x9e5qBqVCgzbziPqgge1KEYgiMnnuYUzAlNeN/+/DyCVPfMH8pd/MYgouQja
         4XYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5n87tlf//wbzIK0eFiapoMfQ9AN1g8d2FAoAK9a2vxY=;
        b=SZRKpB4Ji+xtK5M3qTyanfb8moB3Z2HmD4gHaHw3Stf1lgn10htTJ94l35hSoBhrlI
         N/q9Usv1NA0g0nIjxWHMmU0LqlnXmMQPYDzNOWnrNMHmEcvhvKvvVUYUDefBnayIdPHe
         PssmUwOuEOzmv0c5NKydSRQviWEcdRBkC9OOLSABuKOMksmtvB4mRKahvg0MduJa6Eec
         03kjC0OoKzHhLNDfnmxGsXMFYu8RZLd+/2iym5phXNPhCb8QFJ8uwkqtSnQsoqZsbUAD
         2FtoRlsCIqWH1afSsSL9M4fmhts5X93IfljJX8eS3EUHJlu63VAwt+sFEGoBbOEW4E6B
         q7OQ==
X-Gm-Message-State: AOAM532wQTwuF9cmXotDlXxsnVR9tj06n7XDeHK9yh+4D+exzqGeY6dz
        669rQz/wc42Tsng8bgE11+M=
X-Google-Smtp-Source: ABdhPJxT+GymjMQRiWHQH2hZ/KGPHBJNpw1mPTlAxAfe8CDKz5S50mJKepd4An2jXnXrmp51GhmhlQ==
X-Received: by 2002:a92:418d:: with SMTP id o135mr649615ila.213.1610393643713;
        Mon, 11 Jan 2021 11:34:03 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id 17sm360669ilt.15.2021.01.11.11.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 11:34:02 -0800 (PST)
Date:   Mon, 11 Jan 2021 12:34:00 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Michal Marek <michal.lkml@markovi.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] bpf: Hoise pahole version checks into Kconfig
Message-ID: <20210111193400.GA1343746@ubuntu-m3-large-x86>
References: <20210111180609.713998-1-natechancellor@gmail.com>
 <CAK7LNAQ=38BUi-EG5v2UiuAF-BOsVe5BTd-=jVYHHHPD7ikS5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNAQ=38BUi-EG5v2UiuAF-BOsVe5BTd-=jVYHHHPD7ikS5A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 04:19:01AM +0900, Masahiro Yamada wrote:
> On Tue, Jan 12, 2021 at 3:06 AM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > After commit da5fb18225b4 ("bpf: Support pre-2.25-binutils objcopy for
> > vmlinux BTF"), having CONFIG_DEBUG_INFO_BTF enabled but lacking a valid
> > copy of pahole results in a kernel that will fully compile but fail to
> > link. The user then has to either install pahole or disable
> > CONFIG_DEBUG_INFO_BTF and rebuild the kernel but only after their build
> > has failed, which could have been a significant amount of time depending
> > on the hardware.
> >
> > Avoid a poor user experience and require pahole to be installed with an
> > appropriate version to select and use CONFIG_DEBUG_INFO_BTF, which is
> > standard for options that require a specific tools version.
> >
> > Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> 
> 
> 
> I am not sure if this is the right direction.
> 
> 
> I used to believe moving any tool test to the Kconfig
> was the right thing to do.
> 
> For example, I tried to move the libelf test to Kconfig,
> and make STACK_VALIDATION depend on it.
> 
> https://patchwork.kernel.org/project/linux-kbuild/patch/1531186516-15764-1-git-send-email-yamada.masahiro@socionext.com/
> 
> It was rejected.
> 
> 
> In my understanding, it is good to test target toolchains
> in Kconfig (e.g. cc-option, ld-option, etc).
> 
> As for host tools, in contrast, it is better to _intentionally_
> break the build in order to let users know that something needed is missing.
> Then, they will install necessary tools or libraries.
> It is just a one-time setup, in most cases,
> just running 'apt install' or 'dnf install'.
> 
> 
> 
> Recently, a similar thing happened to GCC_PLUGINS
> https://patchwork.kernel.org/project/linux-kbuild/patch/20201203125700.161354-1-masahiroy@kernel.org/#23855673
> 
> 
> 
> 
> Following this pattern, if a new pahole is not installed,
> it might be better to break the build instead of hiding
> the CONFIG option.
> 
> In my case, it is just a matter of 'apt install pahole'.
> On some distributions, the bundled pahole is not new enough,
> and people may end up with building pahole from the source code.

This is fair enough. However, I think that parts of this patch could
still be salvaged into something that fits this by making it so that if
pahole is not installed (CONFIG_PAHOLE_VERSION=0) or too old, the build
errors at the beginning, rather at the end. I am not sure where the best
place to put that check would be though.

Cheers,
Nathan
