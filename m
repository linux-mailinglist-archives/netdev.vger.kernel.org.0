Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBF48A4D57
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 04:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbfIBCr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 22:47:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28414 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728926AbfIBCr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 22:47:26 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x822ieuI003096;
        Sun, 1 Sep 2019 19:47:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=SpeeiTT1702e+gajS4S7QkWKldtV+AL7UZ+seQ+Evzg=;
 b=HIlqEoTdLWuEN6psaHSinTfJXvjEpiuF80EX90K7CX68VPNoxgwwOlJQCMx3IEPLX0Fi
 nPKMHzcNgwBVv3B00URrl/fVRlowdJHPujlaqLR40ter/XDGctj0BYbuOQ/RT2yiWzbD
 IC8ZJwlv8PpM+G3+5ksxV7VnWEWt0s98JUI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uqpdj5f1j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 01 Sep 2019 19:47:09 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 1 Sep 2019 19:47:07 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sun, 1 Sep 2019 19:47:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ISrnsDt5zM93XB1BRu+5LEaQ6+CHfWpxnRtoMGSDVZtHuzEVqe6xVlEBHikPhQ6UOexnd/oGoYQrC/M5AYB0x4IXhKEqmQcnnQKKaI/7eq2HVRaUm99a131oA4ib9/vb3gQt/vPWQqQHEj4fITzw7yfnQq5rfFzdou6TFGfD+7VvDw47dO4xydxfM9jt5MYIwGubVJBtzgdB8E8ENK2q31+bizeMfRoXDKsGSkui8o6T5iTLks06DoI2N/e5h8eGdfBGy3D5ZFP5dx+QD6S1D6cHZ0wZTPCWASehzqy5mc6KbM7Jr2o5nfNmgzB77i9z6XgVkhN1qVuKHEwDHtbvCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpeeiTT1702e+gajS4S7QkWKldtV+AL7UZ+seQ+Evzg=;
 b=XjL815FhWpO7EKCJFXskRObLiv1FU/ivBY2pLS6HyArD+9At3IiYs0xYEH+MfVD6t5sh7q4vX49QZyaj815uXxxuLj759AB2ptAZD5dtv7Wu6ovSEryI3QSY4N8N/wEkU98ct3Nt4oXxpDjPJl4Wglr/Mjm3Q/6oqPqQN3NAcH8+j4E9cIr218s8e9JYHOAv+IR5vA3mBdr0TsE/GEyPcuevnZZezpdUaHIe80SPvOvYT1j+P4+R5EsoZ2T7vx1HX7sQuUlsxbH0SEwtt0FRjfpMygQfvBs05NMTvj23op/UVe5Mwj0AskIT/qxsX0Z1fLBfgOgnXRTJ+Qy0riUkWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpeeiTT1702e+gajS4S7QkWKldtV+AL7UZ+seQ+Evzg=;
 b=aa5Lpbq5OSokIvtG1UDgeIbQfnbnFctGO2uTWG/rF0Hc6CesYdgKzjl3uI8VjRPpO7/DiLMY2aowI4jYpEtn/Z40l5o9b0WAOzwzHJzgDjhrgyS+QbJK9LZxf5Goye/oa6QCHVNW0gtGn9kzeI6snkQxqgE5KfG2aZpMGyYASis=
Received: from CH2PR15MB3686.namprd15.prod.outlook.com (10.255.155.143) by
 CH2PR15MB3621.namprd15.prod.outlook.com (52.132.228.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Mon, 2 Sep 2019 02:46:52 +0000
Received: from CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::49a8:bb4e:fcce:aee7]) by CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::49a8:bb4e:fcce:aee7%4]) with mapi id 15.20.2220.021; Mon, 2 Sep 2019
 02:46:52 +0000
From:   Ben Wei <benwei@fb.com>
To:     Ben Wei <benwei@fb.com>, David Miller <davem@davemloft.net>,
        "sam@mendozajonas.com" <sam@mendozajonas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
CC:     Ben Wei <benwei@fb.com>
Subject: [PATCH net-next] net/ncsi: support unaligned payload size in NC-SI
 cmd handler
Thread-Topic: [PATCH net-next] net/ncsi: support unaligned payload size in
 NC-SI cmd handler
Thread-Index: AdVhOKsnD7LLLBrzTcm5Yllqe1NFWA==
Date:   Mon, 2 Sep 2019 02:46:52 +0000
Message-ID: <CH2PR15MB368619179F403EAE47FD61F7A3BE0@CH2PR15MB3686.namprd15.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:180::4d27]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd3c89c4-5b02-4256-bf1c-08d72f4fcf5e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR15MB3621;
x-ms-traffictypediagnostic: CH2PR15MB3621:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR15MB362195FE41D0BDD126A7F2EAA3BE0@CH2PR15MB3621.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(366004)(376002)(39860400002)(136003)(189003)(199004)(76116006)(102836004)(110136005)(14444005)(5660300002)(86362001)(33656002)(81156014)(2906002)(316002)(81166006)(7696005)(6436002)(4326008)(8936002)(66446008)(66556008)(64756008)(478600001)(66946007)(66476007)(186003)(486006)(53936002)(6506007)(52536014)(14454004)(2201001)(71200400001)(9686003)(25786009)(256004)(55016002)(6116002)(74316002)(71190400001)(2501003)(476003)(305945005)(99286004)(7736002)(46003)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR15MB3621;H:CH2PR15MB3686.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hZAuAbsgn/eL6gEkX6X/aVCyKq+ptKfqlWc3MhHl8PFQl6hTEIZxwn4mrx/C6t9D5M7Yde1Sc0p5n01kDBE8E7z5nCqvr7TJMsr+j8ne2j6ZODs9M25PscJ0gai0H9suRoviEuUq1mmpG3/H0uzaSxAC4yFK2Wx9KJ1bkoYmJTrL7WQW4HJ0QU/jQTZWqHXm2+rV2wsOXE116JySeFqNiJL918cekVqcbvWDh6ue594jPeWR96ZdlLEBmC45lELcY5yWD9MYDWhlRnwdhmFoBLSwChwHnmqF+8pxDnVeuZpdNVrBUvmQ033c2DEQkeABGRygl0VJaQ98drent/ucXxTYW152kOE7UR5UdeU7gPmiT5xcCtAVQ0yQFi1z/cndmsxemYZVT255+kCgvabEnB0UXzU14ptyUU/MGSXKlcI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bd3c89c4-5b02-4256-bf1c-08d72f4fcf5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 02:46:52.2650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UqJ5y4lANzTqIxV1oP8uZoAdpf3p2HPpNhaiA39vxQXeEbT7wmpInIPguXzxNFTE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3621
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-02_01:2019-08-29,2019-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=909 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909020030
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update NC-SI command handler (both standard and OEM) to take into
account of payload paddings in allocating skb (in case of payload
size is not 32-bit aligned).

The checksum field follows payload field, without taking payload
padding into account can cause checksum being truncated, leading to
dropped packets.

Signed-off-by: Ben Wei <benwei@fb.com>
---
 net/ncsi/ncsi-cmd.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
index 0187e65176c0..42636ed3cf3a 100644
--- a/net/ncsi/ncsi-cmd.c
+++ b/net/ncsi/ncsi-cmd.c
@@ -213,17 +213,22 @@ static int ncsi_cmd_handler_oem(struct sk_buff *skb,
 {
 	struct ncsi_cmd_oem_pkt *cmd;
 	unsigned int len;
+	/* NC-SI spec requires payload to be padded with 0
+	 * to 32-bit boundary before the checksum field.
+	 * Ensure the padding bytes are accounted for in
+	 * skb allocation
+	 */
+	unsigned short payload =3D ALIGN(nca->payload, 4);
=20
 	len =3D sizeof(struct ncsi_cmd_pkt_hdr) + 4;
-	if (nca->payload < 26)
+	if (payload < 26)
 		len +=3D 26;
 	else
-		len +=3D nca->payload;
+		len +=3D payload;
=20
 	cmd =3D skb_put_zero(skb, len);
 	memcpy(&cmd->mfr_id, nca->data, nca->payload);
 	ncsi_cmd_build_header(&cmd->cmd.common, nca);
-
 	return 0;
 }
=20
@@ -272,6 +277,7 @@ static struct ncsi_request *ncsi_alloc_command(struct n=
csi_cmd_arg *nca)
 	struct net_device *dev =3D nd->dev;
 	int hlen =3D LL_RESERVED_SPACE(dev);
 	int tlen =3D dev->needed_tailroom;
+	int payload;
 	int len =3D hlen + tlen;
 	struct sk_buff *skb;
 	struct ncsi_request *nr;
@@ -281,14 +287,17 @@ static struct ncsi_request *ncsi_alloc_command(struct=
 ncsi_cmd_arg *nca)
 		return NULL;
=20
 	/* NCSI command packet has 16-bytes header, payload, 4 bytes checksum.
+	 * Payload needs padding so that the checksum field follwoing payload is
+	 * aligned to 32bit boundary.
 	 * The packet needs padding if its payload is less than 26 bytes to
 	 * meet 64 bytes minimal ethernet frame length.
 	 */
 	len +=3D sizeof(struct ncsi_cmd_pkt_hdr) + 4;
-	if (nca->payload < 26)
+	payload =3D ALIGN(nca->payload, 4);
+	if (payload < 26)
 		len +=3D 26;
 	else
-		len +=3D nca->payload;
+		len +=3D payload;
=20
 	/* Allocate skb */
 	skb =3D alloc_skb(len, GFP_ATOMIC);
--=20
2.17.1

