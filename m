Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63BAA6B7F5
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 10:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfGQIPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 04:15:08 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45906 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfGQIPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 04:15:07 -0400
Received: by mail-pg1-f194.google.com with SMTP id o13so10761114pgp.12
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 01:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/f7OgW0o9ZNPt/YPHVcf8OqBFwXKG1xblF9Y+OGzR2k=;
        b=sl76CQFtTSyOEUptCth+jHwbMqlZmCIAocfmi0GCg+JJXWyhblEVpA2LXBPnuKd3ay
         8nobOMYKh5otbxtdX3YNfmnKOeno4Ghi3VtlQ+Sh7sMHvb2gub4hQuu+m5rnzcwgf4jg
         Hv06Kxh5DjiVaGX3sqyMbOwiK9DNVgQQuX+Ak/IR8xafBC0k8Kxbfvr6JRExUVZ81lbQ
         pfyNhfLDli3+ak7+l29GxDmLl1SAKj0e1iEnSbcN7jw08+H7e6B6yBD5WAXdWRTe71/s
         mToP0O/aoAyYNCf1qq+4q5xIT4z29Wh+e0Ezt9LZjSzIgd7xJL7Nd00q0vB4RAW7K1xp
         9xlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/f7OgW0o9ZNPt/YPHVcf8OqBFwXKG1xblF9Y+OGzR2k=;
        b=FTj7/QbFaaXYB7P/Cu/9mXCPP80D462018sRdv0JHpWzhvOW7Ly9p3zojy45stku96
         u64W34UpksnndOi3C1Xr3HBb36LD75r9/UtECtdn+mjkOws0wXfBKzpNw9oIF9phWBE6
         Vzru6hHTf6YnZn2pTr/2x/tw74Kt6OPe4zP0CKqyldYUfrhKHqzga628p8Wq4W5gFFIa
         KxOHM24/eq9VhDP5QZDC0GFUDyoyww8RXHL4xJw2y23dAe2vNrhmmj1TZu9MsAsE6adj
         vimyXnKUA4ivftbF56iWjKZfwf1uOXuCJ5TgJiOKatQa3GeWdGeTEigXFjKHsTtA3PU6
         U8hA==
X-Gm-Message-State: APjAAAVxvcGuTQg9Xhm2DEYIMNvM72qt3GmYh6bHb0lt6oh25/sQBsas
        cJnCZKz6txCdd4G0juU1dPn15nNNh2S30A==
X-Google-Smtp-Source: APXvYqzgdiIVllIB6gK3z9eWoDbarHp7QJmWt/6467XBsUeepEGOHlQwrRVdLlQz0IiaL2qSMN0sWA==
X-Received: by 2002:a65:518a:: with SMTP id h10mr39032287pgq.117.1563351307012;
        Wed, 17 Jul 2019 01:15:07 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li1433-81.members.linode.com. [45.33.106.81])
        by smtp.gmail.com with ESMTPSA id a6sm21429043pjs.31.2019.07.17.01.15.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Jul 2019 01:15:06 -0700 (PDT)
Date:   Wed, 17 Jul 2019 16:14:56 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Russell King <linux@armlinux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Justin He <Justin.He@arm.com>
Subject: Re: [PATCH 0/2] arm/arm64: Add support for function error injection
Message-ID: <20190717081456.GB20476@leoy-ThinkPad-X240s>
References: <20190716111301.1855-1-leo.yan@linaro.org>
 <20190717165222.62e02b99ebc16e23c3b81de2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717165222.62e02b99ebc16e23c3b81de2@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 04:52:22PM +0900, Masami Hiramatsu wrote:
> On Tue, 16 Jul 2019 19:12:59 +0800
> Leo Yan <leo.yan@linaro.org> wrote:
> 
> > This small patch set is to add support for function error injection;
> > this can be used to eanble more advanced debugging feature, e.g.
> > CONFIG_BPF_KPROBE_OVERRIDE.
> > 
> > I only tested the first patch on arm64 platform Juno-r2 with below
> > steps; the second patch is for arm arch, but I absent the platform
> > for the testing so only pass compilation.
> > 
> > - Enable kernel configuration:
> >   CONFIG_BPF_KPROBE_OVERRIDE
> >   CONFIG_BTRFS_FS
> >   CONFIG_BPF_EVENTS=y
> >   CONFIG_KPROBES=y
> >   CONFIG_KPROBE_EVENTS=y
> >   CONFIG_BPF_KPROBE_OVERRIDE=y
> > - Build samples/bpf on Juno-r2 board with Debian rootFS:
> >   # cd $kernel
> >   # make headers_install
> >   # make samples/bpf/ LLC=llc-7 CLANG=clang-7
> > - Run the sample tracex7:
> >   # ./tracex7 /dev/sdb1
> >   [ 1975.211781] BTRFS error (device (efault)): open_ctree failed
> >   mount: /mnt/linux-kernel/linux-cs-dev/samples/bpf/tmpmnt: mount(2) system call failed: Cannot allocate memory.
> 
> This series looks good to me from the view point of override usage :)
> 
> Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
> 
> For this series.
> 
> Thank you,

Thank you for reviewing, Masami.

> > 
> > 
> > Leo Yan (2):
> >   arm64: Add support for function error injection
> >   arm: Add support for function error injection
> > 
> >  arch/arm/Kconfig                         |  1 +
> >  arch/arm/include/asm/error-injection.h   | 13 +++++++++++++
> >  arch/arm/include/asm/ptrace.h            |  5 +++++
> >  arch/arm/lib/Makefile                    |  2 ++
> >  arch/arm/lib/error-inject.c              | 19 +++++++++++++++++++
> >  arch/arm64/Kconfig                       |  1 +
> >  arch/arm64/include/asm/error-injection.h | 13 +++++++++++++
> >  arch/arm64/include/asm/ptrace.h          |  5 +++++
> >  arch/arm64/lib/Makefile                  |  2 ++
> >  arch/arm64/lib/error-inject.c            | 19 +++++++++++++++++++
> >  10 files changed, 80 insertions(+)
> >  create mode 100644 arch/arm/include/asm/error-injection.h
> >  create mode 100644 arch/arm/lib/error-inject.c
> >  create mode 100644 arch/arm64/include/asm/error-injection.h
> >  create mode 100644 arch/arm64/lib/error-inject.c
> > 
> > -- 
> > 2.17.1
> > 
> 
> 
> -- 
> Masami Hiramatsu <mhiramat@kernel.org>
