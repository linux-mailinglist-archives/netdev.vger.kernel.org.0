Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9259A2A1CF4
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 10:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgKAJgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 04:36:22 -0500
Received: from mailout07.rmx.de ([94.199.90.95]:59121 "EHLO mailout07.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbgKAJgV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 04:36:21 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout07.rmx.de (Postfix) with ESMTPS id 4CP9sX50P3zBvB8;
        Sun,  1 Nov 2020 10:36:16 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CP9sJ0FQgz2TRlS;
        Sun,  1 Nov 2020 10:36:04 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.14) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Sun, 1 Nov
 2020 10:35:02 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add hardware time stamping support
Date:   Sun, 1 Nov 2020 10:35:01 +0100
Message-ID: <4928494.XgmExmOR0V@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201030182447.2day7x3vad7xgcah@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de> <1680734.pGj3N1mgWS@n95hx1g2> <20201030182447.2day7x3vad7xgcah@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.14]
X-RMX-ID: 20201101-103604-4CP9sJ0FQgz2TRlS-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Friday, 30 October 2020, 19:24:47 CET, Vladimir Oltean wrote:
> On Thu, Oct 22, 2020 at 12:17:48PM +0200, Christian Eggers wrote:
> > I tried to study the effect of setting the ocmode bit on the KSZ either to
> > master or to slave. The main visible change is, that some PTP message
> > types
> > are be filtered out on RX:
> > - in "master" mode, "Sync" messages from other nodes will not be received
> > (but everything else like "Announce" seem to work)
> > - in "slave" mode, "Delay_Req" messages from other nodes will not be
> > received
> Could you dump the contents of your REG_PTP_MSG_CONF2 register?
runtime register value is 0x1004 (matches default value from the data sheet).
The Linux driver doesn't touch this register. Below is a dump of all PTP
related (global) registers.

regards
Christian

    KSZ9563 (Ethernet switch)

      Global

        IEEE 1588 PTP
        CLKCTRL      0002      SWFA         enabled        CLKSADJ        NOP              PTPSD        subtract
                               CLKREAD      NOP            CLKWRITE       NOP              CLKCADJ      disabled
                               EN           enabled        RESET          normal
        RTCCP        0002      PHASE        16ns
        RTCNS        17D72FF0  NANOSECONDS    399978480
        RTCS         00000023  SECONDS               35
        RTCSUBNS     00000000  RATEDIR      subtract       TEMPADJ        permanent
                               SUBNS                  0
        RTCTMPADJ    00000000  CYCLES                 0
        MSGCFG1      007D      MODEEN       enabled        IEEE802.3      enabled          UDPv4        enabled
                               UDPv6        enabled        TCMODE         P2P              OCMODE       slave
        MSGCFG2      1004      UNICASTEN    both           ALTMASTER      disabled         PRIOTX       event only
                               CHKSYNFU     disabled       CHKDLY         disabled         CHKPDLY      disabled
                               DROP         disabled       CHKDOM         disabled         IPv4CHKSUM   calc
        DOMVER       0200      VERSION      2              DOMAIN            0
        UNITIDX      00000000  GPIO_IDX     GPIO_1         TS_IDX         Unit 0           TRIG_IDX     Unit 0




