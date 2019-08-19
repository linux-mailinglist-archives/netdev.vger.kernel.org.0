Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3CE91C12
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 06:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfHSEd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 00:33:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59192 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbfHSEd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 00:33:58 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7J4WRUe020760;
        Sun, 18 Aug 2019 21:33:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=R09CL+VDzv4Xv7/rzxRA2l0a7YteNog9MKNDLucbhaU=;
 b=OOWV6Zfng3roDjiR+tVgJD1Xn7pdhhxGb0sZPrV//2DD/4aTr1HO1Xz9Mf+3tNDszEyJ
 8ICVXH6d4d1i6biFCOKDrm0kF8ao6oAbF7ffqdLuaBHWFOgLmT+lS5SQKGM4a6uWl3/Z
 mE2qyxT7JK28FCLNetkelMUa2RNH/Vnhmeg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uf1g0akaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 18 Aug 2019 21:33:43 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 18 Aug 2019 21:33:42 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 18 Aug 2019 21:33:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DR8eDsxalU7y0TQLQeOTaJ6J/8K24qqry35qbIiGAxBZ37YDcrUrE72zmnZ0v1Luq0MNwKHdOOF6hBtp5LZfA/rGFg2+os2dgofcYSI0Y3KytX3ln7mHMrrPxlCXDfroUTjxbz9mVVNh1uCtupkXsEOnQTKTIvNMzrVfmO0RHsn9GHLvPiArU/wtfSWwWiLTX6lMxDdg6ObEitHnLwXQVFgKj8pnwT6JglzM0V59Cka4j1ZMtz7kKmvjokXwjaiERK1P3bx8794NkqpB0jdaf5VWooZXuiAx4CE3HaVmvtlAPdy7euBtvs94t3CunLUca+aZrQIxDCPXKSc1iiEfhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R09CL+VDzv4Xv7/rzxRA2l0a7YteNog9MKNDLucbhaU=;
 b=VdXVz+FlTs+RIV88N5SyWYcz3wFovuRafsBF/smgB8B8gfiLiudtbMLL5SumshnKliQxlBJxzwTdUNECqm9zYOdmfwNbwXQui15sur9oLevZAiKvLs2YgYfqDDvqIPIBvzEl6LMDva3NnWunn3syuvD8Cm8tX536TK5CL23A4AQWMYv/0L3jvXYbRYtt/WqHU0J5p2EQlodKu4ehYFU5ll/zmquxUzP4UlLuZOEuwv1Wz6psjsaP8fhhZHZcPMlsmeVBlt6phR0osVfxcnA1TzG9vSDQ94+xZj+ChQMCC9Mnsv+cic11LxLpkV4X9nXAAbDILn1ASkKVwKSKS/VSlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R09CL+VDzv4Xv7/rzxRA2l0a7YteNog9MKNDLucbhaU=;
 b=YtZ7mlM5zGFlInair+G2kAm36JkasUSvOzcyJF9JnGVEA+bReA2Ng8Wfh8j9k6qNCw0X+vc6USq6HyUkBgpdixi+7Dqifo7pOnTnp0lw6ezbd3FLcchEpvIk2aw/Bxvb+pb/O3W0M2sJgDgwvDbK5/cp1BZPejpYHUW56pvqhi0=
Received: from CH2PR15MB3686.namprd15.prod.outlook.com (10.255.155.143) by
 CH2PR15MB3608.namprd15.prod.outlook.com (52.132.228.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Mon, 19 Aug 2019 04:33:41 +0000
Received: from CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::9d88:b74a:48ea:cf6c]) by CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::9d88:b74a:48ea:cf6c%5]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 04:33:41 +0000
From:   Ben Wei <benwei@fb.com>
To:     Ben Wei <benwei@fb.com>
CC:     "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        "Samuel Mendoza-Jonas" <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Wei <benwei@fb.com>
Subject: [PATCH] net/ncsi: add control packet payload to NC-SI commands from
 netlink
Thread-Topic: [PATCH] net/ncsi: add control packet payload to NC-SI commands
 from netlink
Thread-Index: AdVWRzWK9Wcjcdd/SW6uTu9wV1cgUQ==
Date:   Mon, 19 Aug 2019 04:33:41 +0000
Message-ID: <CH2PR15MB368691D280F882864A6D356DA3A80@CH2PR15MB3686.namprd15.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [99.73.36.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 491dd55a-a63a-46e8-2d47-08d7245e698e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR15MB3608;
x-ms-traffictypediagnostic: CH2PR15MB3608:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR15MB36085CA8F3831E4E663ED142A3A80@CH2PR15MB3608.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:457;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(136003)(396003)(376002)(366004)(189003)(199004)(316002)(14444005)(7696005)(99286004)(478600001)(2906002)(66066001)(71200400001)(86362001)(14454004)(54906003)(3846002)(71190400001)(6200100001)(8936002)(6436002)(76116006)(6116002)(66946007)(5660300002)(33656002)(81166006)(8676002)(74316002)(7736002)(186003)(102836004)(26005)(9686003)(55016002)(53936002)(486006)(6506007)(476003)(256004)(4326008)(25786009)(6862004)(305945005)(81156014)(66446008)(64756008)(66556008)(66476007)(52536014);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR15MB3608;H:CH2PR15MB3686.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bFLF23k3GuKwiUl1VWXFj74+Jus85Dv5xPidT+fZtlP4wc6AMpIfpjWrlToUiI0kL54CXx+nJzgT0+LuHASbKB87BAodlJNERZt6QsQ83G0ZaDQQ8sewhVMF2h4AF85jUs6eopDiGSfwmTYDlHKbutnY8sy67k83OEd66ED5PV5hi1wrjfFacgosCP/o8ooNgofZgazvOE8D/MAlYzQ0BDnYUyA3xTa7CA9ux0W4KlstsvhYLM9zI6ZKa0bTbHzfLTEqvu0SW5K5WJnueLXtmG6IU9/ao+7wGKWqosdAMQZWP1E26GhlKQfrU3NBYsWZTAvwu7YoLourB6vkpBVVa1g0spyJWLdItFRVdYpt8qIEkSfWgD5RImlfIPHWCBR67ySNsJXAbDTZjx0XPIQJST50fHNE8a6ibuc/IS4frrM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 491dd55a-a63a-46e8-2d47-08d7245e698e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 04:33:41.1456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aqGFMprVWhlP9ybhUd+iI/LYh9gdIP2VnQnfBXcduEpFI/3pPnNTGrBEXidMCGTN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3608
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-19_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=907 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908190051
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for NCSI_CMD_SEND_CMD netlink command to load packe=
t data payload (up to 16 bytes) to standard NC-SI commands.

Packet data will be loaded from NCSI_ATTR_DATA attribute similar to NC-SI O=
EM commands

Signed-off-by: Ben Wei <benwei@fb.com>
---
 net/ncsi/internal.h     | 7 ++++---
 net/ncsi/ncsi-netlink.c | 9 +++++++++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h index 0b3f0673e1a2..=
4ff442faf5dc 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -328,9 +328,10 @@ struct ncsi_cmd_arg {
 	unsigned short       payload;     /* Command packet payload length */
 	unsigned int         req_flags;   /* NCSI request properties       */
 	union {
-		unsigned char  bytes[16]; /* Command packet specific data  */
-		unsigned short words[8];
-		unsigned int   dwords[4];
+#define NCSI_MAX_DATA_BYTES 16
+		unsigned char  bytes[NCSI_MAX_DATA_BYTES]; /* Command packet specific da=
ta  */
+		unsigned short words[NCSI_MAX_DATA_BYTES / sizeof(unsigned short)];
+		unsigned int   dwords[NCSI_MAX_DATA_BYTES / sizeof(unsigned int)];
 	};
 	unsigned char        *data;       /* NCSI OEM data                 */
 	struct genl_info     *info;       /* Netlink information           */
diff --git a/net/ncsi/ncsi-netlink.c b/net/ncsi/ncsi-netlink.c index 8b386d=
766e7d..7d2a43f30eb1 100644
--- a/net/ncsi/ncsi-netlink.c
+++ b/net/ncsi/ncsi-netlink.c
@@ -459,6 +459,15 @@ static int ncsi_send_cmd_nl(struct sk_buff *msg, struc=
t genl_info *info)
 	nca.payload =3D ntohs(hdr->length);
 	nca.data =3D data + sizeof(*hdr);
=20
+	if (nca.payload <=3D NCSI_MAX_DATA_BYTES) {
+		memcpy(nca.bytes, nca.data, nca.payload);
+	} else {
+		netdev_info(ndp->ndev.dev, "NCSI:payload size %u exceeds max %u\n",
+			    nca.payload, NCSI_MAX_DATA_BYTES);
+		ret =3D -EINVAL;
+		goto out_netlink;
+	}
+
 	ret =3D ncsi_xmit_cmd(&nca);
 out_netlink:
 	if (ret !=3D 0) {
--
2.17.1

