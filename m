Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD9D411FB94
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 22:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfLOV4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 16:56:37 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37149 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbfLOV4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 16:56:37 -0500
Received: by mail-ed1-f68.google.com with SMTP id cy15so3457123edb.4
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 13:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hmyEH8CT1hUNd2zzk5cv5R4mBc/mmHBJV5/0o14KKzk=;
        b=t1qFAKoID9ZGuCjgYmhBR1DT8wsJRwjjPffJZ3aEOqW67nUjV6yperym+qdfNqOw9/
         tLiVN5z0DJiDXVmv4UBQfjiukybs/vhVh/7c6/J08aDVXdSEqaSZHbUyk309VeTbdoya
         qP4TBEXBLfwHRKczeoScH80hDcZ0zIeL7Pz0kVewWMcum+8+ohMlKwegZkv2+bYABUyO
         wadaM6JqODq2mkzxRORXOpYsccGregPARsxLnmLTjUOQimuUhNcMaSK1U1M7SILnjkR+
         MsSswhgq3GNPOXNC8vnf3YjTF+ItKlXmeOhMYwk/grVO/+uTtdiEPOq9Qoml8A9hq8tk
         hzBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hmyEH8CT1hUNd2zzk5cv5R4mBc/mmHBJV5/0o14KKzk=;
        b=KJxreGiZyWekEjYBXHK2IpCM0x1UZ6cBh/ZOF0ZuJE6TD+NrA5hdDau0LxJf8gWPAp
         gzkyUf3w1+TIvc2m2shsbVjbR+5OdG9Tju0M/f1jneJnmjX+NpPYbsGRy/6ML0Cdm/n5
         5fUv49bDz4EYR4z7oggidjEC+xyzgL+VkNjeWnAv+8QjGr77umZ8AdTQLYF/aJSgcMGC
         qGvZDteWYiULyC2fd2kRYqaRJP5QJZkbyQkL4obbJ5JEAfomcBUN1/4x1BXSRMY3Urxm
         jLdDZPmyaozECjxEt5cRuDFbnZbqQYeU7YCAXoc5z62gHdGXRCECzKVeM58PulGQEodI
         DD0w==
X-Gm-Message-State: APjAAAV9A2gr+3xw7oPuJsr0r5LjseG5DQzEbOS51c5xBBVL+q8/P2gE
        kaOdksiFULAcVwxKE4vMdpvC2b/nSYYZ5Q6eaMA=
X-Google-Smtp-Source: APXvYqwY+qo8cWzZnWKUz1MGRNY5Vz0/c+tjZvNkHulp6xMt529+f7kf69iTnVywNHPJVkx8r5PIbuk4lWgx1fNqMO4=
X-Received: by 2002:a17:907:11cc:: with SMTP id va12mr30056548ejb.164.1576446995333;
 Sun, 15 Dec 2019 13:56:35 -0800 (PST)
MIME-Version: 1.0
References: <20191212171125.9933-1-olteanv@gmail.com> <CAK8P3a1PBa0bcfmPnVGry-6GUQ0WTLJ36MAE89QWXzbnuEf_XQ@mail.gmail.com>
 <CAK8P3a0EM0MOsgdCVHS7gPxLk2nvP4Xqs4_tmtPM4Da=M5ZUQA@mail.gmail.com>
In-Reply-To: <CAK8P3a0EM0MOsgdCVHS7gPxLk2nvP4Xqs4_tmtPM4Da=M5ZUQA@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 15 Dec 2019 23:56:24 +0200
Message-ID: <CA+h21hpLsSHV9M82xxktA83B=dR4rpirnT5-5jAR2eux27n1nw@mail.gmail.com>
Subject: Re: [PATCH] net: mscc: ocelot: hide MSCC_OCELOT_SWITCH and move
 outside NET_VENDOR_MICROSEMI
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     David Miller <davem@davemloft.net>,
        Mao Wenan <maowenan@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        yangbo lu <yangbo.lu@nxp.com>,
        Networking <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Dec 2019 at 22:49, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Sat, Dec 14, 2019 at 4:16 PM Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > On Thu, Dec 12, 2019 at 6:11 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > NET_DSA_MSCC_FELIX and MSCC_OCELOT_SWITCH_OCELOT are 2 different drivers
> > > that use the same core operations, compiled under MSCC_OCELOT_SWITCH.
> >
> > > Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
> > > Reported-by: Arnd Bergmann <arnd@arndb.de>
> > > Reported-by: Mao Wenan <maowenan@huawei.com>
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > I did some more build testing and ran into another issue now that
> > MSCC_OCELOT_SWITCH_OCELOT can be built without
> > CONFIG_SWITCHDEV:
>
> And another one when CONFIG_NET_VENDOR_MICROSEMI is disabled:
>
> ERROR: "ocelot_fdb_dump" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
> ERROR: "ocelot_regfields_init" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
> ERROR: "ocelot_regmap_init" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
> ERROR: "ocelot_init" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
> ERROR: "ocelot_fdb_del" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
> ERROR: "__ocelot_write_ix" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
> ERROR: "ocelot_bridge_stp_state_set"
> [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
> ERROR: "ocelot_port_vlan_filtering"
> [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
> ERROR: "ocelot_get_ethtool_stats"
> [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
> ERROR: "ocelot_port_enable" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
> ERROR: "ocelot_vlan_del" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
> ERROR: "ocelot_deinit" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
> ERROR: "ocelot_init_port" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
> ERROR: "ocelot_fdb_add" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
>
> This fixes it:
>
> diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
> index f8f38dcb5f8a..83351228734a 100644
> --- a/drivers/net/ethernet/Makefile
> +++ b/drivers/net/ethernet/Makefile
> @@ -55,7 +55,7 @@ obj-$(CONFIG_NET_VENDOR_MEDIATEK) += mediatek/
>  obj-$(CONFIG_NET_VENDOR_MELLANOX) += mellanox/
>  obj-$(CONFIG_NET_VENDOR_MICREL) += micrel/
>  obj-$(CONFIG_NET_VENDOR_MICROCHIP) += microchip/
> -obj-$(CONFIG_NET_VENDOR_MICROSEMI) += mscc/
> +obj-y += mscc/

Thanks Arnd. This is getting out of hand. I'll just opt for the simple
solution and make it depend on NET_VENDOR_MICROSEMI.

>  obj-$(CONFIG_NET_VENDOR_MOXART) += moxa/
>  obj-$(CONFIG_NET_VENDOR_MYRI) += myricom/
>  obj-$(CONFIG_FEALNX) += fealnx.o
>
>         Arnd
