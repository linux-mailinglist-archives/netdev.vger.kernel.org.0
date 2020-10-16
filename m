Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48272908C0
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 17:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410380AbgJPPoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 11:44:39 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:13582 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408685AbgJPPoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 11:44:39 -0400
X-Greylist: delayed 2946 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Oct 2020 11:44:38 EDT
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 09GEpkYe010529
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 15:54:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=to : from : subject :
 message-id : date : mime-version : content-type :
 content-transfer-encoding; s=jan2016.eng;
 bh=l9JhK1EGNePbhS3jag/fArtMYNMN0/hBp5pJxkbnisc=;
 b=ElPE4rsDaLJkLXtk2uCfnD/vrVzsNo28KZxHT8Dnv+N7z3nFAFxg2brmkqCvoYUwdZzY
 InnM54i45L+dps/XI5oeQuUo5cBdnu4og9dFwjJLSOUt98DDv7RSAItkLY8wI/t1/Bz+
 Ex2ipH8XMWoouaH5bk35KvIQL2ewFcocVzxYddsop1tZBd5HrXZNd/P+dImkxlcp/u2i
 GOTUiVkfSfbiZQSusROAetq2aepfDTOsA/1BrCU5YzJHvESpVA+lUTgrr45O06vvWJHl
 ppWhfdrHFCoFXU3vow3OHgYf88RcNp5zucUsqoQNBKZXPdNPO78gGnLXF4h+tXVG/kJu 1w== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by m0050095.ppops.net-00190b01. with ESMTP id 3434x6k73p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 15:54:32 +0100
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 09GEoVWn001620
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 10:54:30 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint6.akamai.com with ESMTP id 34389xwp9a-1
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 10:54:30 -0400
Received: from [0.0.0.0] (stag-ssh-gw01.bos01.corp.akamai.com [172.27.113.23])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id 95D103D39E
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 14:54:30 +0000 (GMT)
To:     netdev@vger.kernel.org
From:   Jeff Dike <jdike@akamai.com>
Subject: [RFC] Exempt multicast address from five-second neighbor lifetime
Message-ID: <0d7a29d2-499f-70ab-ee6f-ced4c9305181@akamai.com>
Date:   Fri, 16 Oct 2020 10:54:30 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-16_07:2020-10-16,2020-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=943 adultscore=0
 bulkscore=0 phishscore=0 mlxscore=0 suspectscore=1 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010160113
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-16_07:2020-10-16,2020-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=1
 adultscore=0 clxscore=1011 impostorscore=0 malwarescore=0 mlxlogscore=882
 mlxscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010160113
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.61)
 smtp.mailfrom=jdike@akamai.com smtp.helo=prod-mail-ppoint6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 58956317c8de guarantees arp table entries a five-second lifetime.  We have some apps which make heavy use of multicast, and these can cause the table to overflow by filling it with multicast addresses which can't be GC-ed until their five seconds are up.
This patch allows multicast addresses to be thrown out before they've lived out their five seconds.

Signed-off-by: Jeff Dike <jdike@akamai.com>

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 81ee17594c32..22ced1381ede 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -204,6 +204,7 @@ struct neigh_table {
 	int			(*pconstructor)(struct pneigh_entry *);
 	void			(*pdestructor)(struct pneigh_entry *);
 	void			(*proxy_redo)(struct sk_buff *skb);
+	int			(*is_multicast)(const void *pkey);
 	bool			(*allow_add)(const struct net_device *dev,
 					     struct netlink_ext_ack *extack);
 	char			*id;
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 8e39e28b0a8d..9500d28a43b0 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -235,6 +235,8 @@ static int neigh_forced_gc(struct neigh_table *tbl)
 
 			write_lock(&n->lock);
 			if ((n->nud_state == NUD_FAILED) ||
+			    (tbl->is_multicast &&
+			     tbl->is_multicast(n->primary_key)) ||
 			    time_after(tref, n->updated))
 				remove = true;
 			write_unlock(&n->lock);
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 687971d83b4e..110d6d408edc 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -79,6 +79,7 @@
 #include <linux/socket.h>
 #include <linux/sockios.h>
 #include <linux/errno.h>
+#define __UAPI_DEF_IN_CLASS 1
 #include <linux/in.h>
 #include <linux/mm.h>
 #include <linux/inet.h>
@@ -125,6 +126,7 @@ static int arp_constructor(struct neighbour *neigh);
 static void arp_solicit(struct neighbour *neigh, struct sk_buff *skb);
 static void arp_error_report(struct neighbour *neigh, struct sk_buff *skb);
 static void parp_redo(struct sk_buff *skb);
+static int arp_is_multicast(const void *pkey);
 
 static const struct neigh_ops arp_generic_ops = {
 	.family =		AF_INET,
@@ -156,6 +158,7 @@ struct neigh_table arp_tbl = {
 	.key_eq		= arp_key_eq,
 	.constructor	= arp_constructor,
 	.proxy_redo	= parp_redo,
+	.is_multicast   = arp_is_multicast,
 	.id		= "arp_cache",
 	.parms		= {
 		.tbl			= &arp_tbl,
@@ -928,6 +931,10 @@ static void parp_redo(struct sk_buff *skb)
 	arp_process(dev_net(skb->dev), NULL, skb);
 }
 
+static int arp_is_multicast(const void *pkey)
+{
+	return IN_MULTICAST(htonl(*((u32 *) pkey)));
+}
 
 /*
  *	Receive an arp request from the device layer.
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 27f29b957ee7..b42c9314cc4e 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -81,6 +81,7 @@ static void ndisc_error_report(struct neighbour *neigh, struct sk_buff *skb);
 static int pndisc_constructor(struct pneigh_entry *n);
 static void pndisc_destructor(struct pneigh_entry *n);
 static void pndisc_redo(struct sk_buff *skb);
+static int ndisc_is_multicast(const void *pkey);
 
 static const struct neigh_ops ndisc_generic_ops = {
 	.family =		AF_INET6,
@@ -115,6 +116,7 @@ struct neigh_table nd_tbl = {
 	.pconstructor =	pndisc_constructor,
 	.pdestructor =	pndisc_destructor,
 	.proxy_redo =	pndisc_redo,
+	.is_multicast = ndisc_is_multicast,
 	.allow_add  =   ndisc_allow_add,
 	.id =		"ndisc_cache",
 	.parms = {
@@ -1706,6 +1708,11 @@ static void pndisc_redo(struct sk_buff *skb)
 	kfree_skb(skb);
 }
 
+static int ndisc_is_multicast(const void *pkey)
+{
+	return (((struct in6_addr *) pkey)->in6_u.u6_addr8[0] & 0xf0) == 0xf0;
+}
+
 static bool ndisc_suppress_frag_ndisc(struct sk_buff *skb)
 {
 	struct inet6_dev *idev = __in6_dev_get(skb->dev);
