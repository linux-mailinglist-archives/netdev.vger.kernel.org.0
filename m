Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7882B68CE32
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 05:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjBGEcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 23:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBGEcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 23:32:10 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01olkn2077.outbound.protection.outlook.com [40.92.52.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A73B465;
        Mon,  6 Feb 2023 20:32:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTRiiHjk+K+WdLzrMxwB0y11h12jfq0BckIR7/vXZmu8Vv96B10YcvjSo1SqCkwtT9EVeGiBAToBFuhqvt20qZT1IREcpoc6sG1uMXXICPbNiRa/Pw0JnNdLalc6JIkRsFnM7OMKP2CWfyL26sPIUqDRGqKWaAQgN3y2KCWG7aJbv2j5iDw5XpzXYq3oY2BZ4l219ShIM9/ciNGSWuD3jUkapox1OYW4uloYM/jmokLiaekfjaUgekRHwHHuipn5aBLdNz1IyYzNv6C/kwT7LzGMMK4ViRPWYmpEYmEmlsUfd9N1gFC2fH/i7Id3bvZjEv9176Xg0EdDczhxCbehzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9rs15PDpFPmOMMPPs3y92Pypuix4CHbghkoxhxJecY=;
 b=nTrVkn+SZJN/LgGNBHWm0uk8QUo+CDvZXLFAFkHbwxb+svhZPje0CxPLtd2uL2hCZwUseHopG5kbKwYQboaQ+9axz+qonT0A6zPPsLmka5lzoJL518X41PFWp7BRfXoAyarUaxvQ5rgEIOGw5HXwznffsfPu2bA6fov8ON+bmvZZgCJ8mzKj70XbhGGLH6LRM0hPcRCJ35XQ8z/6iDaQIMRXqz6D4fcUbAK/dEUbmICSGVT6LpApwuht6fWEz/eWUtsQcdfA1CuiLwopjyok40vyBog5r/Gbw/kY4iEEPksZ9E1b47jz/TThacha+vaUxEmZBgUBbZ+k7xbqetRTFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9rs15PDpFPmOMMPPs3y92Pypuix4CHbghkoxhxJecY=;
 b=oIXLqekJ071yCXQ01gLBdtsAMVm1lL0tytRd4Mq0ayY6tFZ9/qzRBYqp5x0UAuIh9+rKDWkfNt0BLM+6JE64QNcBwpIQC6SmeLb0MLKTrGufiKtvdCEjWGn8XqmcYP/27VPjSTD6GfYNRmcs6vyHyD/6YNibPdT30Ogzd4hC4z0Ym41ZeCTr1MbUWmLDqY/qnIKJVfTmaywGNuP/3yS0klMchFE77z2flNrzfIQPBo5A0DN2K11+RxyftGLVEGXMXJHppTioFTxOIU6xemV58gYQ6WEWZGanICFbld8i/hwTbYR7tK1rz83uy2Prr5vVZzWp4xNhA6qDOIiOywszHQ==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by OS3P286MB2043.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:192::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Tue, 7 Feb
 2023 04:32:04 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%3]) with mapi id 15.20.6064.035; Tue, 7 Feb 2023
 04:32:04 +0000
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
To:     netdev@vger.kernel.org
Cc:     Eddy Tao <taoyuan_eddy@hotmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1 1/1] net: openvswitch: remove unnecessary vlan init in key_extract
Date:   Tue,  7 Feb 2023 12:31:33 +0800
Message-ID: <OS3P286MB229551D6705894E6578778DCF5DB9@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [GpvWe1xCXoRdhdfZZX5NnNjoC/rH3H7R]
X-ClientProxiedBy: SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27)
 To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <20230207043133.1405976-1-taoyuan_eddy@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|OS3P286MB2043:EE_
X-MS-Office365-Filtering-Correlation-Id: eb3e6fab-9242-4136-902f-08db08c4437d
X-MS-Exchange-SLBlob-MailProps: C/ir7cSdGlv/EVvTBxMgR0dPX0q274mQCwSNZn7AKXSEGVhUH68lR0iMN8xEJgGyhIDldCR0XDiagCmsqshoahGg0m+dxnAoXbQ41DokWycUYIoBe999ohuqwQKmQ1bWknQFhDSmPl6mpL1Z3gRTdAclw0j32vYnWU5zHUlI6s14IB2poqROw4OJzJi8vIKx+gIf+QBxCEoFygzF+HBBkxslG6UqYjVCSIWvIT1z/UHtPgYT2QaxCM/D7JjYCil2+f5g8ixpyjDIDKu95tPqKTtU44/FtRUz/hoidx9Ip+MHwYxvqVz2eZnqeW74aUrL6XaJ/tbp1T1BrKRTALdvt7U1Y9Yph0L3hKMavnCOQGmna7lCAYLU5jlZ8qgQhO28IVXKx7cGiLcc/mpLu05PD0+uJfkd4xUeTxaGw1ycx4yoEyLFNv1X3B1qHYDOKKYXTQFc+tnMlC9y0wvakJKIgGVZ1+HiN9QgCbs4new4Y4ceY0c+nF2Mx4bKXdVTz6JDpRRVYSsfIC3+G7auS0ybp/Zb+510C4p7H38K/LutopnO0UayfA2PKl1nR7ZaZNRIWUZUPdceb1rfEqP7UqlgoidoAjRUYDSRGvCy8xHtSSFxbtlPVnIySImWWM5GvxBdfylp85V8johGXeWm4zRJCsgVzzWsmphDAPdb4wY/KRauT8ZqExhY43UYEojumU1F0KWUNXq922tBJ/uuQkeVUDAkMmlo2mtF/6bGzsKOBzX2L2eu4KJWE1a6pYQzYOvk
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cfyQLfaGytFlBEB4qX+lTz4s5YHGmL1ycYYCKu4WBJ9eCsmlZoJ0hOTnBkXgZHOu4WxtblAFZ9ofE0RFYlhHa+0G89xA5HvTsJz3vi/a+QZpPsyv1FwiPrG9b+Bq3AQ7PQZEzYM4XcSG56QiwcPgZjjTHV19S3aIk3ZTyDyJU5gSS7gwMLzBR88FOYfImScc+94gB96D5jXg8JlMz/D5n9HuqvGirMQEaSdUTMRaSLn6vHihMi3k2kWKQWWi6yV/FejHyqnQ4MO/7/6EUQPtbGLa1GFOoBnTE9tVgGgcZ76OdEMzU/ps/WwkWkAKnjBuKuUTv2SP+qCgOSrgFqEDzqs/3uhZYDGzj0awriRsY51OLelGjL8eda0WNvXdIX8AiFWV13HYTRo0FftD7ubVr4+cXcI2oBlZIxCfqLRp/ztlef0LnUfbt5OghgA/7kuS2PhYP9rOK9EM7AuIau6W6EnMQwrspg5Ncs41eqa3elvzxglXPkl4fJ9ZaeYMg9vhapFmZqqra7G7bfl7e1NSZVLxKSmDtAVmPqxeIMVjqzNZ5KEBvIYfQim74RtkOmqxiUTO0LDN8GCEDRCPnEAar1WIYwZsWn2mvNvESTSaS39ipHMaAyzDfD+U5EEVeIcOA5/lVcjD//FSGTliS0PBOA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k6M5kDkTR1zzf0fZFx/uKqzog2igV4JiKbHYolOft8YyQM8QSpftfJEIs/QB?=
 =?us-ascii?Q?ZzSbYWslZs+nHStN0mQJxPQIDGDdJ0p0U9+aJjRYVHUMN+RHeLhJ2y6Es3D7?=
 =?us-ascii?Q?AD67GgruN9faVnWVp3RW9XAfEsui3AX31EwqalZ8w3rbm9ROGwmZpFJ3hDTc?=
 =?us-ascii?Q?oMxnFLD3R/CFgUZvbpqT0bi0Uu0hWD9UY4mdElwkAVls0kHxGplKPy4vh/90?=
 =?us-ascii?Q?KO9RAUReIXEfHcxS3zf8xc0UZthXCOaCxzdEAAFsxwHhe/W8+NMTUQuGXFaA?=
 =?us-ascii?Q?0mM/3W6508Kc3IkkuG4C/1/To5LWkikFIZfh+SFHz4R2rhV9lvC23/mCU9T8?=
 =?us-ascii?Q?qN6773o5Uhv5HCd7Yz5nuTDMNFfEQxPcb7/ME/OCPGxie2XkrQdatKAS7pbV?=
 =?us-ascii?Q?qlfZ4bXBDwhmEmpw2/Lznuja2AmbG4lQjK0o8AXRKGgCdrHbYWBtV25ZVK6Z?=
 =?us-ascii?Q?ii43K2xfp8WNgQEhgyIY9iS6wxReK4XhStQwz5w7aqpBMb28UeiCObyYiZBL?=
 =?us-ascii?Q?kwmkj4ppsxEp7lZzzlDCPU10HAsiekJHOaKT4goBvzOWFFSx/ZZkninTQGG4?=
 =?us-ascii?Q?EdF/YbkWM8iLh4gwqrTX/qsQBnZFtEnUJOC+eQNgt2fbo1p+ABzuTjcwCo26?=
 =?us-ascii?Q?MoBVN21xyJL1+ZkEjZAGBPKeA2Vk5BWTWqVABVhjHzUs6eeBl0Se2maLBMfa?=
 =?us-ascii?Q?Ut6QqA/0/lGhmAD2ShCOKd9NqGlXnDsL7kOxMfrwcigyaR2WHvsd5FeZSXpu?=
 =?us-ascii?Q?Gt9vNCE5bbKzPOlaLTI0702xVSNcgB6U1HVTVZw8uUwNkHQvHaQwiOZP5jus?=
 =?us-ascii?Q?N0E4bSy5LZk0aFnoWvNHu/qNeO0zDrCwXQCtKohmSV2FsHrIBIRjQFk3Y48n?=
 =?us-ascii?Q?xQGayOS7I4eaPUbUIMyqPp/2Bqi1GscmImwjG/mztmPtWpD7Ztq7B6Kfm3SO?=
 =?us-ascii?Q?659+y6I8kJbimgSzi071AnWfC+t4mRX6mMx1dVFCLCAtXf8I6QuzeF7c4asV?=
 =?us-ascii?Q?kaloL+BarD+bP+5zyV+cUIY2MrVW8p2V3z6s2490tfZK+uy3ILMRN8Veyc4I?=
 =?us-ascii?Q?sHzHlTK9dovsnf1prBVqbtGVdMGc/K7JQVpmOR644g5eIYtxy/MSJ23QyDvm?=
 =?us-ascii?Q?uZ//M7xW/z1637KwteiBTU00XyPuFuCU2mluRkRwrNXlFcgOc9JQ7iiXqXwT?=
 =?us-ascii?Q?dB3MeQfIS5F8g96cmw/zVhAH4QhFxfog49YUaZodSCCPDDQ81HtPqs09slzq?=
 =?us-ascii?Q?eCGTsvHdkhZNrok1pl1cyYUJGIXC7Zl61XNx2/aAOg=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: eb3e6fab-9242-4136-902f-08db08c4437d
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 04:32:04.6502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3P286MB2043
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Redefine clear_vlan to initialize one struct vlan_head
Define   clear_vlans to initialize key.eth.vlan and key.eth.cvlan
Calls the revised functions accurately

Reasoning:

For vlan packet, current code calls clear_vlan unnecessarily,
since parse_vlan sets key->eth.vlan and key->eth.cvlan correctly.
Only special case where return value <=0 needs inialization
certail key.eth.vlan or key.eth.cvlan specifically.

For none-vlan case, parse_vlan returns on the first parse_vlan_tag
which returns 0, in this case, calls clear_vlan

For MAC_PROTO_NONE, logic is intact after this revision

Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>
---
 net/openvswitch/flow.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index e20d1a973417..30a90597cab6 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -480,12 +480,16 @@ static int parse_vlan_tag(struct sk_buff *skb, struct vlan_head *key_vh,
 	return 1;
 }
 
-static void clear_vlan(struct sw_flow_key *key)
+static inline void clear_vlan(struct vlan_head *vlan)
 {
-	key->eth.vlan.tci = 0;
-	key->eth.vlan.tpid = 0;
-	key->eth.cvlan.tci = 0;
-	key->eth.cvlan.tpid = 0;
+	vlan->tci = 0;
+	vlan->tpid = 0;
+}
+
+static inline void clear_vlans(struct sw_flow_key *key)
+{
+	clear_vlan(&key->eth.vlan);
+	clear_vlan(&key->eth.cvlan);
 }
 
 static int parse_vlan(struct sk_buff *skb, struct sw_flow_key *key)
@@ -498,14 +502,18 @@ static int parse_vlan(struct sk_buff *skb, struct sw_flow_key *key)
 	} else {
 		/* Parse outer vlan tag in the non-accelerated case. */
 		res = parse_vlan_tag(skb, &key->eth.vlan, true);
-		if (res <= 0)
+		if (res <= 0) {
+			clear_vlans(key);
 			return res;
+		}
 	}
 
 	/* Parse inner vlan tag. */
 	res = parse_vlan_tag(skb, &key->eth.cvlan, false);
-	if (res <= 0)
+	if (res <= 0) {
+		clear_vlan(&key->eth.cvlan);
 		return res;
+	}
 
 	return 0;
 }
@@ -918,8 +926,8 @@ static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
 	skb_reset_mac_header(skb);
 
 	/* Link layer. */
-	clear_vlan(key);
 	if (ovs_key_mac_proto(key) == MAC_PROTO_NONE) {
+		clear_vlans(key);
 		if (unlikely(eth_type_vlan(skb->protocol)))
 			return -EINVAL;
 
-- 
2.27.0

