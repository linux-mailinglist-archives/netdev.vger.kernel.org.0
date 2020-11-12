Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247F62B0883
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgKLPhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:37:10 -0500
Received: from mailout08.rmx.de ([94.199.90.85]:38525 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728233AbgKLPhJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 10:37:09 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 4CX5Lp1ZwpzMs7Q;
        Thu, 12 Nov 2020 16:37:06 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CX5LY3q46z2xKF;
        Thu, 12 Nov 2020 16:36:53 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.59) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 12 Nov
 2020 16:35:51 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        "Rob Herring" <robh+dt@kernel.org>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Christian Eggers <ceggers@arri.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2 00/11] net: dsa: microchip: PTP support for KSZ956x
Date:   Thu, 12 Nov 2020 16:35:26 +0100
Message-ID: <20201112153537.22383-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.59]
X-RMX-ID: 20201112-163653-4CX5LY3q46z2xKF-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is only little documentation for PTP available on the data sheet
[1] (more or less only the register reference). Questions to the
Microchip support were seldom answered comprehensively or in reasonable
time. So this is more or less the result of reverse engineering.

[1]
http://ww1.microchip.com/downloads/en/DeviceDoc/KSZ9563R-Data-Sheet-DS00002419D.pdf

Changes from RFC --> v2
------------------------
I think that all open questions regarding the RFC version could be solved.
dts: referenced to dsa.yaml
dts: changed node name to "switch" in example
dts: changed "ports" subnode to "ethernet-ports"
ksz_common: support "ethernet-ports" subnode
tag_ksz: fix usage of correction field (32 bit ns + 16 bit sub-ns)
tag_ksz: use cached PTP header from device's .port_txtstamp function
tag_ksz: refactored ksz9477_tstamp_to_clock()
tag_ksz: pdelay_req: only subtract 2 bit seconds from the correction field
tag_ksz: pdelay_resp: don't move (negative) correction to the egress tail tag
ptp_classify: add ptp_onestep_p2p_move_t2_to_correction helper
ksz9477_ptp: removed E2E support (as suggested by Vladimir)
ksz9477_ptp: removed master/slave sysfs attributes (nacked by Richard)
ksz9477_ptp: refactored ksz9477_ptp_port_txtstamp
ksz9477_ptp: removed "pulse" attribute
kconfig: depend on PTP_1588_CLOCK (instead of "imply")


