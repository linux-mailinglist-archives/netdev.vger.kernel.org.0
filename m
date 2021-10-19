Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2947D433F92
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 22:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbhJSUIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 16:08:09 -0400
Received: from mail-ua1-f52.google.com ([209.85.222.52]:46691 "EHLO
        mail-ua1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbhJSUIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 16:08:07 -0400
Received: by mail-ua1-f52.google.com with SMTP id u5so2259400uao.13;
        Tue, 19 Oct 2021 13:05:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OJuwtmxpS0dVu0QSLCNxBq3CqaxqLtoYSRoUqyl67fo=;
        b=tmeSgCmhPYAoqDRCUb0cP6zJf5uQzfIsxq5XnA1y13HfLdVXlVu+B+Yqxce8I3YGM3
         VLTamKipmNeL6jpLeRmNjVOWc7vz4lVmk7mNmftpSgHhADlbH72tjGg9PohEbNgk+Jh1
         WYHXGPN3JAMrrRRcGsLiGInwh5X4M97JI8mui93+k7DCDm1NgfVCUoEl4gvwjM9fr0YE
         h2I8vEUKeCg9BY2x3vaFJK29rfDtzRmKHg6GVLYo1A4HGR3dk3G+qcvvzm53dfDNfocp
         PO7RMTNoKExDqEgROkqGPt9QLACv351qRDjtBQpymDrMzOrTskV4FMe06X0Z4E4vy+Mx
         5s5Q==
X-Gm-Message-State: AOAM531ak48J1ZnGp+xRn78CWjBoEjPAOfexuwC8G4dpLAiKROwNTXW8
        RQg3EsKo0cO1AT5sjXi4x4nrwOB8iO9epg==
X-Google-Smtp-Source: ABdhPJw4/OCO2/ispicPxfOr398MXzMCD6fLq8Ou6i83NEIvD6trXJ7x7tJqWvmkHbaBV/R1jhHQqQ==
X-Received: by 2002:a67:e04c:: with SMTP id n12mr38271362vsl.9.1634673953781;
        Tue, 19 Oct 2021 13:05:53 -0700 (PDT)
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com. [209.85.222.43])
        by smtp.gmail.com with ESMTPSA id z4sm11913049vsk.15.2021.10.19.13.05.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 13:05:53 -0700 (PDT)
Received: by mail-ua1-f43.google.com with SMTP id h19so2335631uax.5;
        Tue, 19 Oct 2021 13:05:52 -0700 (PDT)
X-Received: by 2002:a67:d111:: with SMTP id u17mr38534586vsi.37.1634673952603;
 Tue, 19 Oct 2021 13:05:52 -0700 (PDT)
MIME-Version: 1.0
References: <20211019145719.122751-1-kory.maincent@bootlin.com>
 <CAMuHMdWghZ7HM5RRFRsZu8P_ikna0QWoRfCKeym61N-Lv-v4Xw@mail.gmail.com>
 <20211019173520.0154a8cb@kmaincent-XPS-13-7390> <YW7nPfzjstmeoMbf@lunn.ch> <20211019175746.11b388ce@windsurf>
In-Reply-To: <20211019175746.11b388ce@windsurf>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 19 Oct 2021 22:05:41 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXiMhpU0vDV3KaOg4DY59cszAtoG1sDOgnTRY6C6cyitQ@mail.gmail.com>
Message-ID: <CAMuHMdXiMhpU0vDV3KaOg4DY59cszAtoG1sDOgnTRY6C6cyitQ@mail.gmail.com>
Subject: Re: [PATCH] net: renesas: Fix rgmii-id delays
To:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?Q?K=C3=B6ry_Maincent?= <kory.maincent@bootlin.com>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thomas,

On Tue, Oct 19, 2021 at 5:57 PM Thomas Petazzoni
<thomas.petazzoni@bootlin.com> wrote:
> On Tue, 19 Oct 2021 17:41:49 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> > > When people update the kernel version don't they update also the devicetree?
> >
> > DT is ABI. Driver writers should not break old blobs running on new
> > kernels. Often the DT blob is updated with the kernel, but it is not
> > required. It could be stored in a hard to reach place, shared with
> > u-boot etc.
>
> Right, but conversely if someone reads the DT bindings that exists
> today, specifies phy-mode = "rgmii-rxid" or phy-mmode = "rmgii-txid",

Today == v5.10-rc1 and later?

> this person will get incorrect behavior. Sure a behavior that is
> backward compatible with older DTs, but a terribly wrong one when you
> write a new DT and read the DT binding documentation. This is exactly
> the problem that happened to us.

If you write a new DT, you read the DT binding documentation, and
"make dtbs_check" will inform you politely if you use the legacy/wrong
DT (i.e. lacking "[rt]x-internal-delay-ps")?

> I know that those properties are considered obsolete, but even though
> they are considered as such, they are still supported, but for this
> particular MAC driver, with an inverted meaning compared to what the DT
> binding documentation says.
>
> What wins: DT ABI backward compatibility, or correctness of the DT
> binding ? :-)

Both ;-)

The current driver is backwards-compatible with the legacy/wrong DTB.
The current DT bindings (as of v5.10-rc1), using "[rt]x-internal-delay-ps"
are correct.
Or am I missing something here?

BTW, it's still not clear to me why the inversion would be needed.
Cfr. Andrew's comment:

| So with rgmii-rxid, what is actually passed to the PHY? Is your
| problem you get twice the delay in one direction, and no delay in the
| other?

We know the ravb driver misbehaved in the past by applying the
rgmii-*id values to the MAC, while they are meant for the PHY, thus
causing bad interaction with PHY drivers.  But that was fixed
by commit 9b23203c32ee02cd ("ravb: Mask PHY mode to avoid inserting
delays twice") and a6f51f2efa742df0 ("ravb: Add support for explicit
internal clock delay configuration").

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
