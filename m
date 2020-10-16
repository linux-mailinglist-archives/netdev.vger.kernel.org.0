Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D877290A6D
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 19:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733160AbgJPRQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 13:16:57 -0400
Received: from mailout08.rmx.de ([94.199.90.85]:48128 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730958AbgJPRQ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 13:16:57 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 4CCXrN5QytzN1M8;
        Fri, 16 Oct 2020 19:16:52 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CCXqc07dDz2TTMX;
        Fri, 16 Oct 2020 19:16:12 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.12) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Fri, 16 Oct
 2020 19:16:11 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>
Subject: [PATCH net] net: dsa: tag_ksz: KSZ8795 and KSZ9477 also use tail tags
Date:   Fri, 16 Oct 2020 19:16:03 +0200
Message-ID: <20201016171603.10587-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.12]
X-RMX-ID: 20201016-191612-4CCXqc07dDz2TTMX-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Marvell 88E6060 uses tag_trailer.c and the KSZ8795, KSZ9477 and
KSZ9893 switches also use tail tags.

Fixes: 7a6ffe764be3 ("net: dsa: point out the tail taggers")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
On Friday, 16 October 2020, 18:56:51 CEST, Vladimir Oltean wrote:
> Hi Christian,
> 
> The idea is perfect but the commit isn't.
>  ...
> Now if you run
> "git show 7a6ffe764be35af0527d8cfd047945e8f8797ddf --pretty=fixes",
> you'll see:
> 
> Fixes: 7a6ffe764be3 ("net: dsa: point out the tail taggers")
thanks for pointing out how to use this feature. I did this manually up to now.

> Notice how there's no [net] tag?
> People complain when the format of the Fixes: tag is not standardized.
I added it manually because the commit ID is not from Linus' tree. Is there any
value using Fixes tags with id's from other trees?

regards
Christian

 net/dsa/tag_ksz.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 945a9bd5ba35..0a5aa982c60d 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -123,6 +123,7 @@ static const struct dsa_device_ops ksz8795_netdev_ops = {
 	.xmit	= ksz8795_xmit,
 	.rcv	= ksz8795_rcv,
 	.overhead = KSZ_INGRESS_TAG_LEN,
+	.tail_tag = true,
 };
 
 DSA_TAG_DRIVER(ksz8795_netdev_ops);
@@ -199,6 +200,7 @@ static const struct dsa_device_ops ksz9477_netdev_ops = {
 	.xmit	= ksz9477_xmit,
 	.rcv	= ksz9477_rcv,
 	.overhead = KSZ9477_INGRESS_TAG_LEN,
+	.tail_tag = true,
 };
 
 DSA_TAG_DRIVER(ksz9477_netdev_ops);
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

