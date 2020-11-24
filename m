Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E562C3480
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 00:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732730AbgKXXQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 18:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732568AbgKXXQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 18:16:06 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA23C0613D6;
        Tue, 24 Nov 2020 15:16:05 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id d9so1044435qke.8;
        Tue, 24 Nov 2020 15:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jbdr1BEjJUZERXYDOU4Gv/mlbgAbUhdHLiICpsfXV1E=;
        b=l+vUmSI7i0l7fGuVwLPE5fOuxSSHusFrOEG0e9vJ5rcmJlRUOrCYTNMgOLszTPHVi8
         kkm8fDq5tpugZyKejz3uk0cqdmJQS1mRaMRBkOrvbAyI5fs/P/fRtiJLDz+N02sHzTn9
         5/inSz1Fbn+KfojwxtYTlcXPJfmsrqKqTBJHlwr9t4EjDd547DXA4VcN7evdsnVsuQ6p
         BBfcG3FVJZcSml9If1GSG7EsdjE7zI8hFJDY7AHsK/qRYVzYo+XeozyqqdAfx+vCyNIu
         chiyZGm6NoHt+eS3/xbHVpbDRehhnbGG6wOdrUeu9OVynRP4/UUYeZuXMpT7icG9n0vb
         4oYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jbdr1BEjJUZERXYDOU4Gv/mlbgAbUhdHLiICpsfXV1E=;
        b=lGxD+AO9Nt5RWTiUaNZ3nVX/cc00oVL/4cRagJbcpoK2zQUtc+Uryf2wVhH/gbwTjZ
         h0cFnOEmPgl+Wpr0jIyynL5M9LYUq89uy6uyCha+tbEO/AnIQcauCGqvegZBmcWsKqHS
         kRxhEFIdgmRR7ePxM7GD7I02bxt4A1ua/yfjHqOgXN7a3tYxqBlqMKsSeQ12Vjpt3Tfy
         KHvrVeZ9OsMEx/86dV5OA7hfqNdK3MmLCTeZb5lsHmNal/RsWxiFozp2WAIxqGEWMXzk
         jzL9nqHngOC/DpGh/Zo7uhnA9jYYK6NNTrimLl8ZYIrbf3r+YMVZwq3GwM5fv8ZNI9w2
         LsFw==
X-Gm-Message-State: AOAM530miFMuN0ApWHzqgCYSqXOCtnUVKs6LuJ8zi2LA+UD/1kUMzlFl
        nGvGnVrBZa1jX8BhgCkikif6yU5i4IkQbYlsmhw=
X-Google-Smtp-Source: ABdhPJzk8nFL+kqPtl4RF6lmqD43KwMnT4A8Oapd7ArTtvgjfEhtR30+WEgNSraaEzhK8tG/u1tJxvxiaOrV9LODN+o=
X-Received: by 2002:a25:61c5:: with SMTP id v188mr748702ybb.422.1606259765056;
 Tue, 24 Nov 2020 15:16:05 -0800 (PST)
MIME-Version: 1.0
References: <202011201129.B13FDB3C@keescook> <20201120115142.292999b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <202011220816.8B6591A@keescook> <9b57fd4914b46f38d54087d75e072d6e947cb56d.camel@HansenPartnership.com>
 <ca071decb87cc7e905411423c05a48f9fd2f58d7.camel@perches.com>
 <0147972a72bc13f3629de8a32dee6f1f308994b5.camel@HansenPartnership.com>
 <d8d1e9add08cdd4158405e77762d4946037208f8.camel@perches.com>
 <dbd2cb703ed9eefa7dde9281ea26ab0f7acc8afe.camel@HansenPartnership.com>
 <20201123130348.GA3119@embeddedor> <8f5611bb015e044fa1c0a48147293923c2d904e4.camel@HansenPartnership.com>
 <202011241327.BB28F12F6@keescook> <alpine.LNX.2.23.453.2011250859290.15@nippy.intranet>
In-Reply-To: <alpine.LNX.2.23.453.2011250859290.15@nippy.intranet>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Wed, 25 Nov 2020 00:15:54 +0100
Message-ID: <CANiq72nUt57u5DG9rH=DB0DzQH7U6-QbG-2Ou+PyCY=p=_Ggag@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH 000/141] Fix fall-through warnings for Clang
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     Kees Cook <keescook@chromium.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Joe Perches <joe@perches.com>,
        Jakub Kicinski <kuba@kernel.org>, alsa-devel@alsa-project.org,
        linux-atm-general@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        linux-ide@vger.kernel.org, dm-devel@redhat.com,
        keyrings@vger.kernel.org, linux-mtd@lists.infradead.org,
        GR-everest-linux-l2@marvell.com, wcn36xx@lists.infradead.org,
        samba-technical@lists.samba.org, linux-i3c@lists.infradead.org,
        linux1394-devel@lists.sourceforge.net,
        linux-afs@lists.infradead.org,
        usb-storage@lists.one-eyed-alien.net, drbd-dev@lists.linbit.com,
        devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org,
        rds-devel@oss.oracle.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org,
        oss-drivers@netronome.com, bridge@lists.linux-foundation.org,
        linux-security-module@vger.kernel.org,
        amd-gfx@lists.freedesktop.org,
        linux-stm32@st-md-mailman.stormreply.com, cluster-devel@redhat.com,
        linux-acpi@vger.kernel.org, coreteam@netfilter.org,
        intel-wired-lan@lists.osuosl.org,
        linux-input <linux-input@vger.kernel.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        tipc-discussion@lists.sourceforge.net,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-watchdog@vger.kernel.org, selinux@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-geode@lists.infradead.org, linux-can@vger.kernel.org,
        linux-block@vger.kernel.org, linux-gpio@vger.kernel.org,
        op-tee@lists.trustedfirmware.org,
        linux-mediatek@lists.infradead.org, xen-devel@lists.xenproject.org,
        nouveau@lists.freedesktop.org, linux-hams@vger.kernel.org,
        ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-hwmon@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-nfs@vger.kernel.org, GR-Linux-NIC-Dev@marvell.com,
        Linux-MM <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-decnet-user@lists.sourceforge.net, linux-mmc@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-usb@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        patches@opensource.cirrus.com, linux-integrity@vger.kernel.org,
        target-devel@vger.kernel.org, linux-hardening@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 11:24 PM Finn Thain <fthain@telegraphics.com.au> wrote:
>
> These statements are not "missing" unless you presume that code written
> before the latest de facto language spec was written should somehow be
> held to that spec.

There is no "language spec" the kernel adheres to. Even if it did,
kernel code is not frozen. If an improvement is found, it should be
applied.

> If the 'fallthrough' statement is not part of the latest draft spec then
> we should ask why not before we embrace it. Being that the kernel still
> prefers -std=gnu89 you might want to consider what has prevented
> -std=gnu99 or -std=gnu2x etc.

The C standard has nothing to do with this. We use compiler extensions
of several kinds, for many years. Even discounting those extensions,
the kernel is not even conforming to C due to e.g. strict aliasing. I
am not sure what you are trying to argue here.

But, since you insist: yes, the `fallthrough` attribute is in the
current C2x draft.

Cheers,
Miguel
