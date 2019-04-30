Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12288FD88
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 18:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfD3QLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 12:11:13 -0400
Received: from mailout41.telekom.de ([194.25.225.151]:22680 "EHLO
        mailout41.telekom.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfD3QLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 12:11:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=telekom.de; i=@telekom.de; q=dns/txt; s=dtag1;
  t=1556640669; x=1588176669;
  h=from:to:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=nNGJksfgPzq1eiU7BNq2eRK5vZkuCuj50LaIRo5DvDo=;
  b=rVevHVSm4dsfk1C/X9efVoypdXcXHigYXQi+ZnR/wNwmJk+v2VGj58QC
   k8rho5S3WzkdlKLZm2zgPXCwlFLmOIn5qgQhT226VXrKgPpYjg6vPqBNn
   jiiXn7vgnBNnRuEjLfMee/Kn7yeAQBTzXsqst6nnvrfgaGxIxKFajQ6me
   iL74aV5YBzEZcsOb2R2FEkOr0YBZnzvjvLxteURO5tUbLdNALR18A0/z/
   Dyb/13XxPqnituPXblaYlvc68G7A1FI29HkWhVvKZr9YYGeUTW9SXjEiq
   yAeh8XrkphCKSf6GXDTxT/n24uKDgBJ6Ib2npc07S2koPnCHnkro6L+3P
   Q==;
Received: from qdec94.de.t-internal.com ([10.171.255.41])
  by MAILOUT41.dmznet.de.t-internal.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Apr 2019 18:11:07 +0200
X-IronPort-AV: E=Sophos;i="5.60,414,1549926000"; 
   d="scan'208";a="414704685"
X-MGA-submission: =?us-ascii?q?MDFiAJjJFDX6sGvbJn5Lx03X2T8L+hOgwP8SG2?=
 =?us-ascii?q?/FtY0ZH9OJSgInBfFROwowGyguN6js3v4OQKq2VXM6Jq0IkNuqqWbyYJ?=
 =?us-ascii?q?pjSysJ/cJHJkQtWX9rFKQ5RWi6O7qG5lASHqsPs88Z8ruuNDG93PvJR3?=
 =?us-ascii?q?I/D1nvhYHGuUfFRbssawepKQ=3D=3D?=
Received: from he105712.emea1.cds.t-internal.com ([10.169.118.43])
  by QDEC97.de.t-internal.com with ESMTP/TLS/AES256-SHA; 30 Apr 2019 18:11:08 +0200
Received: from HE105664.EMEA1.cds.t-internal.com (10.169.118.61) by
 HE105712.emea1.cds.t-internal.com (10.169.118.43) with Microsoft SMTP Server
 (TLS) id 15.0.1473.3; Tue, 30 Apr 2019 18:11:07 +0200
Received: from HE106564.emea1.cds.t-internal.com (10.171.40.16) by
 HE105664.EMEA1.cds.t-internal.com (10.169.118.61) with Microsoft SMTP Server
 (TLS) id 15.0.1473.3 via Frontend Transport; Tue, 30 Apr 2019 18:11:07 +0200
Received: from GER01-LEJ-obe.outbound.protection.outlook.de (51.5.80.21) by
 O365mail01.telekom.de (172.30.0.234) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 30 Apr 2019 18:11:03 +0200
Received: from FRAPR01MB1170.DEUPRD01.PROD.OUTLOOK.DE (10.158.133.21) by
 FRAPR01MB1172.DEUPRD01.PROD.OUTLOOK.DE (10.158.133.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.14; Tue, 30 Apr 2019 16:11:07 +0000
Received: from FRAPR01MB1170.DEUPRD01.PROD.OUTLOOK.DE
 ([fe80::7438:29f7:9dc5:6f7f]) by FRAPR01MB1170.DEUPRD01.PROD.OUTLOOK.DE
 ([fe80::7438:29f7:9dc5:6f7f%6]) with mapi id 15.20.1835.018; Tue, 30 Apr 2019
 16:11:07 +0000
From:   <Markus.Amend@telekom.de>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <dccp@vger.kernel.org>
Subject: [PATCH v3] net: dccp: Checksum verification enhancement
Thread-Topic: [PATCH v3] net: dccp: Checksum verification enhancement
Thread-Index: AdT/bWC4cN8MoIp5SSiDAcCedYQ21w==
Date:   Tue, 30 Apr 2019 16:11:07 +0000
Message-ID: <FRAPR01MB11707401056D4D6C95D8C615FA3A0@FRAPR01MB1170.DEUPRD01.PROD.OUTLOOK.DE>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Markus.Amend@telekom.de; 
x-originating-ip: [212.201.104.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c5e5a8d-c99e-4ef4-d3fb-08d6cd8673d5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:FRAPR01MB1172;
x-ms-traffictypediagnostic: FRAPR01MB1172:
x-microsoft-antispam-prvs: <FRAPR01MB1172D4F8652BFA47B7AA81D3FA3A0@FRAPR01MB1172.DEUPRD01.PROD.OUTLOOK.DE>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(136003)(396003)(376002)(39860400002)(189003)(199004)(8936002)(316002)(256004)(14444005)(450100002)(7696005)(110136005)(68736007)(81166006)(81156014)(9686003)(2201001)(33656002)(66946007)(52396003)(66066001)(86362001)(55016002)(8676002)(7736002)(53936002)(73956011)(66476007)(5660300002)(66446008)(66556008)(64756008)(76116006)(305945005)(15650500001)(75402003)(72206003)(2501003)(71190400001)(486006)(71200400001)(478600001)(26005)(186003)(74482002)(102836004)(2906002)(3846002)(14454004)(476003)(6116002)(97736004);DIR:OUT;SFP:1101;SCL:1;SRVR:FRAPR01MB1172;H:FRAPR01MB1170.DEUPRD01.PROD.OUTLOOK.DE;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: telekom.de does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4g6ZWfj1WgR+EPkV65AV2Ks2dEnM+LsydvLxUy8YxAOXDoD7/nDODV5eKfXcNti03Cmg+1YZaEO3XTQQrO5tbmgEPaq1+Gsjr9txpbMVjAlOIn4QpyuOyeZDXO/DE22qeZBFPXWFdojAjcRla9b8W180I/IQNADo5Ncy47/aTa/JzOLfXGngfiofe7u6ot4IbA550AZPoZz3oHJ7z1hoYdDzSG6ocDKvtVjp+/Gz9bqvEZ6YmmNCPn9dVrHcFlt1orQryyVmDEjfQ+bUZ35i1jOl32egmLE/czdac/jOxcApZGEWeMXEDodanHNShvBZzJKxhDw9MKDnRmXRwaeA+YMDnTTg91Qsz228YDEe7yKbOAyeLCnnakL18GZw1l52VCx0jdSLVUVeNFT9IXEhNaMmBqBdncgjmxbMuq8d3pQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c5e5a8d-c99e-4ef4-d3fb-08d6cd8673d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 16:11:07.1178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bde4dffc-4b60-4cf6-8b04-a5eeb25f5c4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRAPR01MB1172
X-OriginatorOrg: telekom.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current patch modifies the checksum verification of a received DCCP
packet, by adding the function __skb_checksum_validate into the
dccp_vX_rcv routine. The purpose of the modification is to allow the
verification of the skb->ip_summed flags during the checksum validation
process (for checksum offload purposes). As __skb_checksum_validate
covers the functionalities of skb_checksum and dccp_vX_csum_finish they
are needless and therefore removed.

Signed-off-by: Nathalie Romo Moreno <natha.ro.moreno@gmail.com>
Signed-off-by: Markus Amend <markus.amend@telekom.de>
---
 net/dccp/ipv4.c | 6 ++----
 net/dccp/ipv6.c | 6 +++---
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 26a21d97b6b0..ca4eb93e4663 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -762,9 +762,6 @@ int dccp_invalid_packet(struct sk_buff *skb)
 		return 1;
 	}
=20
-	/* If header checksum is incorrect, drop packet and return.
-	 * (This step is completed in the AF-dependent functions.) */
-	skb->csum =3D skb_checksum(skb, 0, cscov, 0);
=20
 	return 0;
 }
@@ -786,7 +783,8 @@ static int dccp_v4_rcv(struct sk_buff *skb)
=20
 	iph =3D ip_hdr(skb);
 	/* Step 1: If header checksum is incorrect, drop packet and return */
-	if (dccp_v4_csum_finish(skb, iph->saddr, iph->daddr)) {
+	if (__skb_checksum_validate(skb, IPPROTO_DCCP,
+				    true, false, 0, inet_compute_pseudo)) {
 		DCCP_WARN("dropped packet with invalid checksum\n");
 		goto discard_it;
 	}
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index d5740bad5b18..22df24fecfe7 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -694,9 +694,9 @@ static int dccp_v6_rcv(struct sk_buff *skb)
 	if (dccp_invalid_packet(skb))
 		goto discard_it;
=20
-	/* Step 1: If header checksum is incorrect, drop packet and return. */
-	if (dccp_v6_csum_finish(skb, &ipv6_hdr(skb)->saddr,
-				     &ipv6_hdr(skb)->daddr)) {
+	/* Step 1: If header checksum is incorrect, drop packet and return */
+	if (__skb_checksum_validate(skb, IPPROTO_DCCP,
+				    true, false, 0, ip6_compute_pseudo)) {
 		DCCP_WARN("dropped packet with invalid checksum\n");
 		goto discard_it;
 	}
--=20
2.20.1

