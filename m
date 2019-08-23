Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E93119A420
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 02:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbfHWADE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 20:03:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54788 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727743AbfHWADD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 20:03:03 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7MNxMQU007796;
        Thu, 22 Aug 2019 17:02:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=tzDHFVj08kh2HrkxLT8sH97xFr1Rmz/csc2Wg01ze34=;
 b=cTdkVcG90CDtfDSxy0+FQpPTFvPrbAtLATxUqL2jGyu09FotDBiQt3PQqrvtNOV6XAjJ
 YNGv+iYSi4DHKq4IJTal76HA7BzGgUKP6HZwmeq8jW4kOlRhZWqtUUz7toA+9v2CxVoJ
 et/sGtkz3P08SS0U/Ne4JGTDTKpHL5cXNx8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uj1w98upp-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 22 Aug 2019 17:02:43 -0700
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 22 Aug 2019 17:02:42 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 22 Aug 2019 17:02:41 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 22 Aug 2019 17:02:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ngWGNmJI1Mh31b5i/gtLO/qXEGO3z94pIROoslHo+QenXncGTkhKCr0HRgaCVIkCgafevffgcuVrJLSPWVgedCNiWGFLUEw3ielGf0uatWRSoFC9oRi+s1QWGU0mCzp0IdQwve7Ob/CVc2LUVsPivDhNNjpwBVYlC0ntYxON+BghZID7xXdxUL96qsoPrycINUlF4dH76dCGxn32LvdcZgAp8BZo8BuavrxYfoDuSm+KF4spWT7kgQmcxGJAGHWYH1aiUCMGkC/qz+bSRWdqq36jjTyLB8FzZ6DK23/Wr9qTBxFhapW+U6cljy4si0iNL/r0GTdhZ9JM83gQdfSsvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tzDHFVj08kh2HrkxLT8sH97xFr1Rmz/csc2Wg01ze34=;
 b=nyvbL0g1uBjUfH+wyX1OELbJfn84snN7UxUCbpKxhXpEEgqVRVxsLzHb3LeDuKHi58kKsHz1irvMQvEf3nh1H0arRBtCZ//eWLsUxTzW1oZM0hrcLdIZRsBw+BnpOFkoutWRT+no77dSopr+GmozPbF6eEIlb9g2RYIlDwiHkZOX9mjpQVsmmDXukmpE3HYLPAHXQO229uQInmBVIkVKvr43jbAzOtydHgJmp5q82b6Wa7IPiBnWge1Sdy/u5oHByIJeXhQFnBhlK/jzzXbcWkkc1Razak/xArxkn/9O4XjADs7z60oBl7UOrnlftgjZYgHBMijtPmz8j5uf1KR3lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tzDHFVj08kh2HrkxLT8sH97xFr1Rmz/csc2Wg01ze34=;
 b=kF5zZPvGKE4QGa4BrcpbxzzdlfVr/OL8rSMdY+ahjUQahZGp4fgM5lY63z2y53h/3JzlQ7PW241lrwPNsUFk7DzQew4fXQFz9y/blZcN1FWzfVLDo27U2Tm0P/eVMzEHdXqDpVtsrz3hci/VLSyEoD+s3gleByFDvEmm3nixF/k=
Received: from CH2PR15MB3686.namprd15.prod.outlook.com (10.255.155.143) by
 CH2PR15MB3720.namprd15.prod.outlook.com (52.132.230.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Fri, 23 Aug 2019 00:02:40 +0000
Received: from CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::9d88:b74a:48ea:cf6c]) by CH2PR15MB3686.namprd15.prod.outlook.com
 ([fe80::9d88:b74a:48ea:cf6c%5]) with mapi id 15.20.2178.020; Fri, 23 Aug 2019
 00:02:40 +0000
From:   Ben Wei <benwei@fb.com>
To:     "sam@mendozajonas.com" <sam@mendozajonas.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        "Justin.Lee1@Dell.com" <Justin.Lee1@Dell.com>
CC:     Ben Wei <benwei@fb.com>
Subject: [PATCH] ncsi-netlink: support sending NC-SI commands over Netlink
 interface
Thread-Topic: [PATCH] ncsi-netlink: support sending NC-SI commands over
 Netlink interface
Thread-Index: AdVZRhK7FBH7PA61Tj6DiPuS9P29Hg==
Date:   Fri, 23 Aug 2019 00:02:40 +0000
Message-ID: <CH2PR15MB36860EECD2EA6D63BEA70110A3A40@CH2PR15MB3686.namprd15.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::c865]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: acb92059-a415-4234-b4b8-08d7275d36fe
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CH2PR15MB3720;
x-ms-traffictypediagnostic: CH2PR15MB3720:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR15MB372055C6705F3647C3E39287A3A40@CH2PR15MB3720.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:826;
x-forefront-prvs: 0138CD935C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(376002)(136003)(39860400002)(346002)(199004)(189003)(6436002)(2501003)(478600001)(46003)(486006)(476003)(7696005)(99286004)(186003)(102836004)(6506007)(305945005)(14454004)(81156014)(81166006)(8676002)(53936002)(8936002)(55016002)(6116002)(71190400001)(52536014)(86362001)(71200400001)(2201001)(25786009)(4326008)(256004)(33656002)(2906002)(7736002)(66946007)(9686003)(76116006)(316002)(110136005)(74316002)(66556008)(5660300002)(66446008)(66476007)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR15MB3720;H:CH2PR15MB3686.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Eu6VmD346+1D85WqCCaIZkYizYusQKO+k/JH+E1BB0QqBw+d8Ygn/DUIy7jgtLqZCZ7A9Ku6ZqwlA3S4IbaSM2bjN6KMNGcj06+07NNscDG14+SHQqZ2OL6bc3eHQ+h9lQly1M2h8zVMySk2Y7/DcfAeHNkmc3S4XHwYWZGUqw2gOHM0jPiUAf+rTbKDxRTG5Y5wyUkk1dwi8oqlMpj78lPyDBh6X4RMDsOSoykhsLyilT8CKG/eFZkZdNskxiyuXE872A6pl8siXl+SHHPLWZFOejxYmRLr/umLfzZwgNCsVh7cktcIWv3WPMzcjUQVJppVuPrS5EoSFxTnZX1Vw4jc/PijuBaeX5LZELdcgqhWfwkJFII2ALyClD9bvRwlIDylil7ggX2Z2Guc1Mynq5zO5EQPeTsHjWbWUUmCMm8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: acb92059-a415-4234-b4b8-08d7275d36fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2019 00:02:40.3448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3nolW2HRqzZMOvcGV8fHfv/d+WTkinfJ2CUNH2GL38iGwPrzY+oUzYkLRWVk+Lnu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3720
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-22_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908220207
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends ncsi-netlink command line utility to send NC-SI command =
to kernel driver=20
via NCSI_CMD_SEND_CMD command.

New command line option -o (opcode) is used to specify NC-SI command and op=
tional payload.

For example, to send "Get Parameter" command

  ncsi-netlink -l 2 -c 0 -p0 -o 0x17

To configure AEN

  ncsi-netlink -l 2 -c 0 -p0 -o 8 0 0 0 0 0 0 0 7

Signed-off-by: Ben Wei <benwei@fb.com>
---
 ncsi-netlink.c | 162 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 157 insertions(+), 5 deletions(-)

diff --git a/ncsi-netlink.c b/ncsi-netlink.c index c46ae76..a06e30e 100644
--- a/ncsi-netlink.c
+++ b/ncsi-netlink.c
@@ -11,10 +11,22 @@
 #include <linux/ncsi.h>
 //#include "ncsi.h"
=20
+struct ncsi_pkt_hdr {
+	unsigned char mc_id;        /* Management controller ID */
+	unsigned char revision;     /* NCSI version - 0x01      */
+	unsigned char reserved;     /* Reserved                 */
+	unsigned char id;           /* Packet sequence number   */
+	unsigned char type;         /* Packet type              */
+	unsigned char channel;      /* Network controller ID    */
+	__be16        length;       /* Payload length           */
+	__be32        reserved1[2]; /* Reserved                 */
+};
+
 struct ncsi_msg {
 	struct nl_sock	*sk;
 	struct nl_msg	*msg;
 	struct nlmsghdr	*hdr;
+	int ret;
 };
=20
 static void free_ncsi_msg(struct ncsi_msg *msg) @@ -69,6 +81,7 @@ int setu=
p_ncsi_message(struct ncsi_msg *msg, int cmd, int flags)
 		rc =3D -1;
 		goto out;
 	}
+	msg->ret =3D 1;
=20
 	return 0;
 out:
@@ -308,10 +321,132 @@ out:
 	return rc;
 }
=20
+static int send_cb(struct nl_msg *msg, void *arg) { #define=20
+ETHERNET_HEADER_SIZE 16
+
+	struct nlmsghdr *hdr =3D nlmsg_hdr(msg);
+	struct nlattr *tb[NCSI_ATTR_MAX + 1] =3D {0};
+	int rc, data_len, i;
+	char *data;
+	int *ret =3D arg;
+
+	static struct nla_policy ncsi_genl_policy[NCSI_ATTR_MAX + 1] =3D {
+		[NCSI_ATTR_IFINDEX] =3D		{ .type =3D NLA_U32 },
+		[NCSI_ATTR_PACKAGE_LIST] =3D	{ .type =3D NLA_NESTED },
+		[NCSI_ATTR_PACKAGE_ID] =3D	{ .type =3D NLA_U32 },
+		[NCSI_ATTR_CHANNEL_ID] =3D	{ .type =3D NLA_U32 },
+		[NCSI_ATTR_DATA] =3D		{ .type =3D NLA_BINARY  },
+		[NCSI_ATTR_MULTI_FLAG] =3D	{ .type =3D NLA_FLAG },
+		[NCSI_ATTR_PACKAGE_MASK] =3D	{ .type =3D NLA_U32 },
+		[NCSI_ATTR_CHANNEL_MASK] =3D	{ .type =3D NLA_U32 },
+	};
+
+
+	rc =3D genlmsg_parse(hdr, 0, tb, NCSI_ATTR_MAX, ncsi_genl_policy);
+	if (rc) {
+		fprintf(stderr, "Failed to parse ncsi cmd callback\n");
+		return rc;
+	}
+
+	data_len =3D nla_len(tb[NCSI_ATTR_DATA]) - ETHERNET_HEADER_SIZE;
+	data =3D nla_data(tb[NCSI_ATTR_DATA]) + ETHERNET_HEADER_SIZE;
+
+
+	printf("NC-SI Response Payload length =3D %d\n", data_len);
+	printf("Response Payload:\n");
+	for (i =3D 0; i < data_len; ++i) {
+		if (i && !(i%4))
+			printf("\n%d: ", 16+i);
+		printf("0x%02x ", *(data+i));
+	}
+	printf("\n");
+
+	// indicating call back has been completed
+	*ret =3D 0;
+	return 0;
+}
+
+static int run_command_send(int ifindex, int package, int channel,
+			uint8_t type, short payload_len, uint8_t *payload) {
+	struct ncsi_msg msg;
+	struct ncsi_pkt_hdr *hdr;
+	int rc;
+	uint8_t *pData, *pCtrlPktPayload;
+
+	// allocate a  contiguous buffer space to hold ncsi message
+	//  (header + Control Packet payload)
+	pData =3D calloc(1, sizeof(struct ncsi_pkt_hdr) + payload_len);
+	if (!pData) {
+		fprintf(stderr, "Failed to allocate buffer for ctrl pkt, %m\n");
+		goto out;
+	}
+	// prepare buffer to be copied to netlink msg
+	hdr =3D (void *)pData;
+	pCtrlPktPayload =3D pData + sizeof(struct ncsi_pkt_hdr);
+	memcpy(pCtrlPktPayload, payload, payload_len);
+
+	rc =3D setup_ncsi_message(&msg, NCSI_CMD_SEND_CMD, 0);
+	if (rc)
+		return -1;
+
+	printf("send cmd, ifindex %d, package %d, channel %d, type 0x%x\n",
+			ifindex, package, channel, type);
+
+	rc =3D nla_put_u32(msg.msg, NCSI_ATTR_IFINDEX, ifindex);
+	if (rc) {
+		fprintf(stderr, "Failed to add ifindex, %m\n");
+		goto out;
+	}
+
+	if (package >=3D 0) {
+		rc =3D nla_put_u32(msg.msg, NCSI_ATTR_PACKAGE_ID, package);
+		if (rc) {
+			fprintf(stderr, "Failed to add package id, %m\n");
+			goto out;
+		}
+	}
+
+	rc =3D nla_put_u32(msg.msg, NCSI_ATTR_CHANNEL_ID, channel);
+	if (rc)
+		fprintf(stderr, "Failed to add channel, %m\n");
+
+	hdr->type =3D type;   // NC-SI command
+	hdr->length =3D htons(payload_len);  // NC-SI command payload length
+	rc =3D nla_put(msg.msg, NCSI_ATTR_DATA,
+				sizeof(struct ncsi_pkt_hdr)+payload_len,
+				(void *)pData);
+	if (rc)
+		fprintf(stderr, "Failed to add netlink header, %m\n");
+
+	nl_socket_disable_seq_check(msg.sk);
+	rc =3D nl_socket_modify_cb(msg.sk, NL_CB_VALID, NL_CB_CUSTOM, send_cb,
+			&(msg.ret));
+
+	rc =3D nl_send_auto(msg.sk, msg.msg);
+	if (rc < 0) {
+		fprintf(stderr, "Failed to send message, %m\n");
+		goto out;
+	}
+
+	while (msg.ret =3D=3D 1) {
+		rc =3D nl_recvmsgs_default(msg.sk);
+		if (rc) {
+			fprintf(stderr, "Failed to rcv msg, rc=3D%d %m\n", rc);
+			goto out;
+		}
+	}
+
+out:
+	free_ncsi_msg(&msg);
+	return rc;
+}
+
 void usage(void)
 {
 	printf(	"ncsi-netlink: Send messages to the NCSI driver via Netlink\n"
-		"ncsi-netlink [-h] operation [-p PACKAGE] [-c CHANNEL] [-l IFINDEX]\n"
+		"ncsi-netlink [-h] operation [-p PACKAGE] [-c CHANNEL] [-l IFINDEX] [-o =
cmd [payload]]\n"
 		"\t--ifindex index      Specify the interface index\n"
 		"\t--package package    Package number\n"
 		"\t--channel channel    Channel number (aka. port number)\n"
@@ -326,7 +461,9 @@ void usage(void)
 int main(int argc, char *argv[])
 {
 	int rc, operation =3D -1;
-	int package, channel, ifindex;
+	int package, channel, ifindex, opcode;
+	uint8_t payload[2048] =3D {0};
+	short payload_length =3D 0, i =3D 0;
=20
 	static const struct option long_opts[] =3D {
 		{"channel",	required_argument, 	NULL, 'c'},
@@ -336,12 +473,12 @@ int main(int argc, char *argv[])
 		{"package",	required_argument, 	NULL, 'p'},
 		{"set",		no_argument, 		NULL, 's'},
 		{"clear",	no_argument, 		NULL, 'x'},
+		{"cmd",		required_argument,	NULL, 'o'},
 		{ NULL, 0, NULL, 0},
 	};
-	static const char short_opts[] =3D "c:hil:p:sx";
-
-	package =3D channel =3D ifindex =3D -1;
+	static const char short_opts[] =3D "c:hil:p:sxo:";
=20
+	package =3D channel =3D ifindex =3D opcode =3D -1;
 	while (true) {
 		int c =3D getopt_long(argc, argv, short_opts, long_opts, NULL);
=20
@@ -350,6 +487,17 @@ int main(int argc, char *argv[])
=20
 		errno =3D 0;
 		switch (c) {
+		case 'o':
+			opcode =3D strtoul(optarg, NULL, 0);
+			if (errno) {
+				fprintf(stderr, "Couldn't parse opcode, %m\n");
+				return -1;
+			}
+			operation =3D NCSI_CMD_SEND_CMD;
+			payload_length =3D argc - optind;
+			for (i =3D 0; i < payload_length; ++i)
+				payload[i] =3D (int)strtoul(argv[i + optind], NULL, 0);
+			break;
 		case 'c':
 			channel =3D strtoul(optarg, NULL, 0);
 			if (errno) {
@@ -408,6 +556,10 @@ int main(int argc, char *argv[])
 	case NCSI_CMD_CLEAR_INTERFACE:
 		rc =3D run_command_clear(ifindex);
 		break;
+	case NCSI_CMD_SEND_CMD:
+		rc =3D run_command_send(ifindex, package, channel,
+			opcode, payload_length, payload);
+		break;
 	default:
 		usage();
 		return -1;
--
2.17.1

