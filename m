Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40E01CBBAD
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 02:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728509AbgEIANt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 20:13:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43848 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728399AbgEIANr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 20:13:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588983225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZhMKYaxcr11NMRkCgTBjG7GpLbTFZxzwIgvmF68ljDw=;
        b=PMmpUnF/5nAGHGSZ28ucusY6lujjlsQXxhc4i7P8WfFQWoK0N80Ukk/BkQQx58+vSHyd5i
        dY9JvQWV8xVqumB+SHJq8VkpAIHED0XkHWldL4x9Aoi+bSaGBJaEhn0tydw5/DtctcuANg
        LnhOXTu1fIeOpAtOufmYw1b7QXoAMiA=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-s1vXl_9_OKC4lIECgfz_aA-1; Fri, 08 May 2020 20:13:34 -0400
X-MC-Unique: s1vXl_9_OKC4lIECgfz_aA-1
Received: by mail-ej1-f70.google.com with SMTP id x16so1334799eje.22
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 17:13:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZhMKYaxcr11NMRkCgTBjG7GpLbTFZxzwIgvmF68ljDw=;
        b=KFmY49MpcseHDDu44goBZ855sSOVcdTIFmLp/mTnh76CTPiadGbqYcZfV57rtSdvF5
         VdGwhpgiU6olCcBCP3gi5bz/gVSBORLUzjd83ErgBIxmWEo+5w23xIiYmZMDww/CqjEw
         gy+yYaKNJEwwOI/O1+OxRB0U+6Cbpe7XXUXLVwaDxL7KbvJyBzbjBowgsHfd1KTblbmL
         vuuc09stvVYXcj5Co72nSu6ueRpyVWxYMdMkd8aaLwRxcTkJlUp+/YbZX4T7pacBXxMN
         zgBi/tICpbgvQZ1SiaIAY/kB3X8n7clTK8KBnx1zzr/gfzcJkBL28WDZ0WYP2Q3E9kTc
         gYAQ==
X-Gm-Message-State: AGi0PuYf4bo/gW9JP+E6JlTY2+7VKM+UZryr9m2BYCwCPkNvfxBVPYVH
        8SpQQnvG6g1jRrwSbQUFuSK89eQfApuQsPMTmFd7786e8w+wToyBK3aRCUUwv3V07vrWDH8/tgE
        DbXx/BsvGzNFqMRSDEmDDoZDW8dYQ83CR
X-Received: by 2002:a17:906:328c:: with SMTP id 12mr3850933ejw.69.1588983213652;
        Fri, 08 May 2020 17:13:33 -0700 (PDT)
X-Google-Smtp-Source: APiQypJqN+TFhvtZqdkdpPo6lJw1R9Pu/We69ZDkgECDwa6VM+i564ZjE0uPtDGVAOi0WNgy1fVhvrOMu14Ja9Aja74=
X-Received: by 2002:a17:906:328c:: with SMTP id 12mr3850919ejw.69.1588983213332;
 Fri, 08 May 2020 17:13:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
 <20190524100554.8606-4-maxime.chevallier@bootlin.com> <CAGnkfhzsx_uEPkZQC-_-_NamTigD8J0WgcDioqMLSHVFa3V6GQ@mail.gmail.com>
 <20200423170003.GT25745@shell.armlinux.org.uk>
In-Reply-To: <20200423170003.GT25745@shell.armlinux.org.uk>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Sat, 9 May 2020 02:12:57 +0200
Message-ID: <CAGnkfhwOavaeUjcm4_+TG-xLxQA519o+fR8hxBCCfSy3qpcYhQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts to handle
 RSS tables
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        Nadav Haklai <nadavh@marvell.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 7:00 PM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Tue, Apr 14, 2020 at 01:43:02AM +0200, Matteo Croce wrote:
> > On Tue, Apr 14, 2020 at 1:21 AM Maxime Chevallier
> > <maxime.chevallier@bootlin.com> wrote:
> > >
> > > The PPv2 controller has 8 RSS tables that are shared across all ports on
> > > a given PPv2 instance. The previous implementation allocated one table
> > > per port, leaving others unused.
> > >
> > > By using RSS contexts, we can make use of multiple RSS tables per
> > > port, one being the default table (always id 0), the other ones being
> > > used as destinations for flow steering, in the same way as rx rings.
> > >
> > > This commit introduces RSS contexts management in the PPv2 driver. We
> > > always reserve one table per port, allocated when the port is probed.
> > >
> > > The global table list is stored in the struct mvpp2, as it's a global
> > > resource. Each port then maintains a list of indices in that global
> > > table, that way each port can have it's own numbering scheme starting
> > > from 0.
> > >
> > > One limitation that seems unavoidable is that the hashing parameters are
> > > shared across all RSS contexts for a given port. Hashing parameters for
> > > ctx 0 will be applied to all contexts.
> > >
> > > Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> >
> > Hi all,
> >
> > I noticed that enabling rxhash blocks the RX on my Macchiatobin. It
> > works fine with the 10G ports (the RX rate goes 4x up) but it
> > completely kills the gigabit interface.
> >
> > # 10G port
> > root@macchiatobin:~# iperf3 -c 192.168.0.2
> > Connecting to host 192.168.0.2, port 5201
> > [  5] local 192.168.0.1 port 42394 connected to 192.168.0.2 port 5201
> > [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> > [  5]   0.00-1.00   sec   941 MBytes  7.89 Gbits/sec  4030    250 KBytes
> > [  5]   1.00-2.00   sec   933 MBytes  7.82 Gbits/sec  4393    240 KBytes
> > root@macchiatobin:~# ethtool -K eth0 rxhash on
> > root@macchiatobin:~# iperf3 -c 192.168.0.2
> > Connecting to host 192.168.0.2, port 5201
> > [  5] local 192.168.0.1 port 42398 connected to 192.168.0.2 port 5201
> > [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> > [  5]   0.00-1.00   sec   860 MBytes  7.21 Gbits/sec  428    410 KBytes
> > [  5]   1.00-2.00   sec   859 MBytes  7.20 Gbits/sec  185    563 KBytes
> >
> > # gigabit port
> > root@macchiatobin:~# iperf3 -c turbo
> > Connecting to host turbo, port 5201
> > [  5] local 192.168.85.42 port 45144 connected to 192.168.85.6 port 5201
> > [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> > [  5]   0.00-1.00   sec   113 MBytes   948 Mbits/sec    0    407 KBytes
> > [  5]   1.00-2.00   sec   112 MBytes   942 Mbits/sec    0    428 KBytes
> > root@macchiatobin:~# ethtool -K eth2 rxhash on
> > root@macchiatobin:~# iperf3 -c turbo
> > iperf3: error - unable to connect to server: Resource temporarily unavailable
> >
> > I've bisected and it seems that this commit causes the issue. I tried
> > to revert it on nex-next as a second test, but the code has changed a
> > lot much since, generating too much conflicts.
> > Can you have a look into this?
>
> This behaviour on eth2 is confirmed here on v5.6.  Turning on rxhash
> appears to prevent eth2 working.
>
> Maxime, please look into this regression, thanks.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
>

Hi,

What do you think about temporarily disabling it like this?

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5775,7 +5775,8 @@ static int mvpp2_port_probe(struct platform_device *pdev,
                            NETIF_F_HW_VLAN_CTAG_FILTER;

        if (mvpp22_rss_is_supported()) {
-               dev->hw_features |= NETIF_F_RXHASH;
+               if (port->phy_interface != PHY_INTERFACE_MODE_SGMII)
+                       dev->hw_features |= NETIF_F_RXHASH;
                dev->features |= NETIF_F_NTUPLE;
        }


David, is this "workaround" too bad to get accepted?

Bye,

--
Matteo Croce
per aspera ad upstream

