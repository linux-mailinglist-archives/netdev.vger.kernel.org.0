Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251052C0D61
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 15:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389131AbgKWOUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 09:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388810AbgKWOUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 09:20:08 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DCBAC0613CF;
        Mon, 23 Nov 2020 06:20:06 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id t33so16099316ybd.0;
        Mon, 23 Nov 2020 06:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WUYMqcUnfpAQa1YuH9tQ3ze5bp2bxaoGLXc9Sg/470Y=;
        b=b0LkeT2q71Z3peIccxL7MkU5QadaCN3igdEC89IE4ykmdOxIlhuoo/0+H7pQCoNmlh
         0UX19Z7soasUpz2fDZHX56luUWrH4GLKAJ9K28HwPu9km7qlcvasqfBffaQW+LtXvh6a
         fVP4J8wQFxbi1QWFB10Wsq9dLONxRShLcqQtcaktrZCy3tSRV5R4FOw2MSdgwNuCxNwd
         cKQMyE/jYgmlc9Qm972BZKz9xJaasT5iW6gpZgai8YpCh1sxJNgZFzlfCpv21Fvd7rwb
         akOsznbnFT4mJT95mXFDUPnplTdAJirWAcm8YfzHFRAfOGn9Vk91PuRcq7JipLelDPMB
         VWgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WUYMqcUnfpAQa1YuH9tQ3ze5bp2bxaoGLXc9Sg/470Y=;
        b=k/qgZ8Z9bBqeNograULAsVmY6QgH/o27YDc4TQqwadJEFPSHfj8njq8ybzc5p5uAqz
         G2SF1GHjXgxVX+FODMOQfjlRZXXNW8F8Ux14RKIUmWQY2couN16YR3yqVIzbwT4iX+yY
         VYevTNouvCvLvx1xngkvK6RPKneGbHmGKG5FWBekf4NZ/3kPDSYqCl0zGT3EJ0yk0X4t
         kU+csohpniyEyWF3yBeZ4aH/Tq8NjSKFDNPVh4gegMfVdeoJsrqFPE3o5GJQHSG5qjFd
         /s6X6u/SLjhTMvHx9dFj3eBhExXvELYjltJz7wnCgTa8WRq49qIZaylj2t5HkrN/zQMT
         LOBg==
X-Gm-Message-State: AOAM533+WIFD/5i1qM3ecRgslbKC6w7KewwGOZRW9A2m2jL8dzVHgZRd
        FqTd3sI8v3im//r2zntxY7nbBjfQQlZgP2y43RA=
X-Google-Smtp-Source: ABdhPJyiJqjBIpEzWlk5pyqpoGG3+KpoWdKnlyza2YA6ODhXnRhATytwh5Bq+iGOzNqc5gs+zuqHC8iB1cjfDTXU/ik=
X-Received: by 2002:a25:bcc7:: with SMTP id l7mr32380985ybm.115.1606141205830;
 Mon, 23 Nov 2020 06:20:05 -0800 (PST)
MIME-Version: 1.0
References: <cover.1605896059.git.gustavoars@kernel.org> <20201120105344.4345c14e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <202011201129.B13FDB3C@keescook> <20201120115142.292999b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <202011220816.8B6591A@keescook> <9b57fd4914b46f38d54087d75e072d6e947cb56d.camel@HansenPartnership.com>
 <CANiq72nZrHWTA4_Msg6MP9snTyenC6-eGfD27CyfNSu7QoVZbw@mail.gmail.com> <1c7d7fde126bc0acf825766de64bf2f9b888f216.camel@HansenPartnership.com>
In-Reply-To: <1c7d7fde126bc0acf825766de64bf2f9b888f216.camel@HansenPartnership.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Mon, 23 Nov 2020 15:19:55 +0100
Message-ID: <CANiq72m22Jb5_+62NnwX8xds2iUdWDMAqD8PZw9cuxdHd95W0A@mail.gmail.com>
Subject: Re: [PATCH 000/141] Fix fall-through warnings for Clang
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org, amd-gfx@lists.freedesktop.org,
        bridge@lists.linux-foundation.org, ceph-devel@vger.kernel.org,
        cluster-devel@redhat.com, coreteam@netfilter.org,
        devel@driverdev.osuosl.org, dm-devel@redhat.com,
        drbd-dev@lists.linbit.com, dri-devel@lists.freedesktop.org,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        intel-gfx@lists.freedesktop.org, intel-wired-lan@lists.osuosl.org,
        keyrings@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-acpi@vger.kernel.org, linux-afs@lists.infradead.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net,
        linux-block@vger.kernel.org, linux-can@vger.kernel.org,
        linux-cifs@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-decnet-user@lists.sourceforge.net,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-fbdev@vger.kernel.org, linux-geode@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-i3c@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input <linux-input@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
        linux-mtd@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, nouveau@lists.freedesktop.org,
        op-tee@lists.trustedfirmware.org, oss-drivers@netronome.com,
        patches@opensource.cirrus.com, rds-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org, samba-technical@lists.samba.org,
        selinux@vger.kernel.org, target-devel@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        usb-storage@lists.one-eyed-alien.net,
        virtualization@lists.linux-foundation.org,
        wcn36xx@lists.infradead.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        xen-devel@lists.xenproject.org, linux-hardening@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>, Joe Perches <joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 22, 2020 at 11:36 PM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> Well, it seems to be three years of someone's time plus the maintainer
> review time and series disruption of nearly a thousand patches.  Let's
> be conservative and assume the producer worked about 30% on the series
> and it takes about 5-10 minutes per patch to review, merge and for
> others to rework existing series.  So let's say it's cost a person year
> of a relatively junior engineer producing the patches and say 100h of
> review and application time.  The latter is likely the big ticket item
> because it's what we have in least supply in the kernel (even though
> it's 20x vs the producer time).

How are you arriving at such numbers? It is a total of ~200 trivial lines.

> It's not about the risk of the changes it's about the cost of
> implementing them.  Even if you discount the producer time (which
> someone gets to pay for, and if I were the engineering manager, I'd be
> unhappy about), the review/merge/rework time is pretty significant in
> exchange for six minor bug fixes.  Fine, when a new compiler warning
> comes along it's certainly reasonable to see if we can benefit from it
> and the fact that the compiler people think it's worthwhile is enough
> evidence to assume this initially.  But at some point you have to ask
> whether that assumption is supported by the evidence we've accumulated
> over the time we've been using it.  And if the evidence doesn't support
> it perhaps it is time to stop the experiment.

Maintainers routinely review 1-line trivial patches, not to mention
internal API changes, etc.

If some company does not want to pay for that, that's fine, but they
don't get to be maintainers and claim `Supported`.

Cheers,
Miguel
