Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6A2433AF5
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhJSPqj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 Oct 2021 11:46:39 -0400
Received: from mail-ua1-f52.google.com ([209.85.222.52]:41664 "EHLO
        mail-ua1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhJSPqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 11:46:38 -0400
Received: by mail-ua1-f52.google.com with SMTP id r17so719800uaf.8;
        Tue, 19 Oct 2021 08:44:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9w5fIXPKZDwgNRvWZmViM/LTuF4pitICETDWQBsQoxE=;
        b=zJaLIpQVq5PNsQr6ThMp/e/wH44DqhYvzXFNSJ+FzCT0Oj+aWbN5Ao9w1HexoiyFgh
         6gE3hiEE5E/BK1WK6npBBMGnUt8cznZTJAPvCPun4zmDP+lYYISbqYdxWzBNfqN1vcYO
         VJmwvCxAAfestQbJ1AQC4bNEJZN/E3K0QkAvRS3g1zMmLsoBUCWaSaYbaC65y743Q138
         0EOPVM6K+zBeA1n7YsziTPNX3RekEkojraRTT9PpPpXqW1nbdiNg4k9+08kAW6/U6lKQ
         kJ0MXITArT950bfT4sTc/EyOZ3p0wYBwiSANvui+yluZxe8d9x8q0N1gbPy7kpTySruj
         qcqw==
X-Gm-Message-State: AOAM530KRZCbRMO1iVkjyBxQAWAt51gzjeEoNJfRAWYlwtvT8Geb3Uy+
        g7R5ypWqoWvv+AXRCNYL2fDilyDnX/nxvg==
X-Google-Smtp-Source: ABdhPJw9lSClfyrM7lkEuXmMCQMbHkibSFtLsa6t4mCA/jh7tV4tgsBE1m2wqxll+RO4e+sT3gy9zQ==
X-Received: by 2002:a05:6102:418b:: with SMTP id cd11mr34408351vsb.36.1634658264955;
        Tue, 19 Oct 2021 08:44:24 -0700 (PDT)
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com. [209.85.222.49])
        by smtp.gmail.com with ESMTPSA id j133sm11443852vke.47.2021.10.19.08.44.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 08:44:24 -0700 (PDT)
Received: by mail-ua1-f49.google.com with SMTP id e10so764803uab.3;
        Tue, 19 Oct 2021 08:44:24 -0700 (PDT)
X-Received: by 2002:a67:d583:: with SMTP id m3mr36244153vsj.41.1634658259759;
 Tue, 19 Oct 2021 08:44:19 -0700 (PDT)
MIME-Version: 1.0
References: <20211019145719.122751-1-kory.maincent@bootlin.com>
 <CAMuHMdWghZ7HM5RRFRsZu8P_ikna0QWoRfCKeym61N-Lv-v4Xw@mail.gmail.com> <20211019173520.0154a8cb@kmaincent-XPS-13-7390>
In-Reply-To: <20211019173520.0154a8cb@kmaincent-XPS-13-7390>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 19 Oct 2021 17:44:08 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXWhK_kEKFuXFUO45w6UaA1KL6F8RX4gwkavBMXQZ4mAw@mail.gmail.com>
Message-ID: <CAMuHMdXWhK_kEKFuXFUO45w6UaA1KL6F8RX4gwkavBMXQZ4mAw@mail.gmail.com>
Subject: Re: [PATCH] net: renesas: Fix rgmii-id delays
To:     =?UTF-8?Q?K=C3=B6ry_Maincent?= <kory.maincent@bootlin.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Köry,

On Tue, Oct 19, 2021 at 5:35 PM Köry Maincent <kory.maincent@bootlin.com> wrote:
> On Tue, 19 Oct 2021 17:13:52 +0200
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > The ravb MAC is adding RX delay if RGMII_RXID is selected and TX delay
> > > if RGMII_TXID but that behavior is wrong.
> > > Indeed according to the ethernet.txt documentation the ravb configuration
> > > should be inverted:
> > >   * "rgmii-rxid" (RGMII with internal RX delay provided by the PHY, the MAC
> > >      should not add an RX delay in this case)
> > >   * "rgmii-txid" (RGMII with internal TX delay provided by the PHY, the MAC
> > >      should not add an TX delay in this case)
> > >
> > > This patch inverts the behavior, i.e adds TX delay when RGMII_RXID is
> > > selected and RX delay when RGMII_TXID is selected.
> > >
> > > Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
> >
> > Does this fix an actual problem for you?
>
> In fact, this fix a problem for an older 4.14 Kernel on my current project.
> I wanted to push my fix in the mainline kernel also, but as you say below, now
> this code is legacy.
> Does it matter to fix legacy code?

I don't think so.  If you're stuck on v4.14, you may want to backport
commit a6f51f2efa742df0 ("ravb: Add support for explicit internal
clock delay configuration").  However, you have to be careful, as
it interacts with related changes to PHY drivers, as explained in
that commit.

> > Note that in accordance with the comment above, the code section
> > below is only present to support old DTBs.  Contemporary DTBs rely
> > on the now mandatory "rx-internal-delay-ps" and "tx-internal-delay-ps"
> > properties instead.
> > Hence changing this code has no effect on DTS files as supplied with
> > the kernel, but may have ill effects on DTB files in the field, which
> > rely on the current behavior.
>
> When people update the kernel version don't they update also the devicetree?

I hope they do ;-)
But we do our best to preserve backwards-compatibility with old DTBS.
If you change behavior of v4.14, it may actually introduce
backwards-incompatibility we're not aware of, as the behavior you
started to rely on never existed in mainline.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
