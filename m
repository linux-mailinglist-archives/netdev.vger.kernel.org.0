Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4DABEA3F1
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 20:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfJ3TRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 15:17:37 -0400
Received: from mail-eopbgr20076.outbound.protection.outlook.com ([40.107.2.76]:46756
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726634AbfJ3TRg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 15:17:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUfh2EP5LMSuB97hOvEC3RtD4FYyBUASzn+tysvusGl77z3333ruyyBVL7EJCXqugIGZ2JGP5o0W6xVWNUj8arPFMuxAwvRUpOM9iqPNZZ0fPRAqorbneIMsxozu2CXIfim3sCC1nbf6rOklh5yOox5mXhomg6qXPQh9orG/Rcplyzx0wL62j3mEBQXv2ygXftW+DK5g0JDX/8X8sxrv9v4y6XzmtfqlluPgtxpbJmKNx3rjESjaP6Zz3AHQT08Jokduj8eMbnmqLmLJxJohOewGAAqaF/buNdCb3k3/TGqZY6sKoUBxgnKjoZMQNDaFDT09qIEli7dXtRlVguB6sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsRq35wOKzSCQJXicXSeG9LgN+tLrzBA/2cLQSgtyWc=;
 b=Iv81VGptOCynONRwRxyEO5YCoi0M84a4h8l8zZMHejdLlrdVBWZqb/TCldHp0PB2/QXEDsiEc0/fStTEiW45PNWuTtWlY2HVImlskAj8E/S50EkPDFBDrYzn5AeWS3RvuL9i2GqdZUfZ8WgSW4zil5FKdb5dy4r7RMDVdAtiUVjw/4jQPM/H0pMeEJosoQTTidiDgQkMD3SbXXtZdkfuMfaw5SUBvWeKQsM4y83mNtJH6thmLlFJTx4r/bfrVeCZr51c237tEiWnA1SBHyEi+0u7/t9SGgWV51pR+10BecQXDd69fYmc4oLm44pqyC7eZ2rJUGXNsyqBh5lnCFiY3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsRq35wOKzSCQJXicXSeG9LgN+tLrzBA/2cLQSgtyWc=;
 b=eeNqAi2Lq3zxq3SeLphbK9Cf6WBZbA/4mY7GPAcC05eTvFfGuTfmALMCR1jCcOTZUcE6kr1b2kWfi5tnaiBgp5PhFIiy5DaBDthSw3Cf2M/Eg/D4OQ1Cl5q0q3B7pXiZkbvGMVVNzgr3aVXbL5+v3nzU9w0J5Kdkk6e49XUe7dg=
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com (10.171.189.29) by
 AM4PR05MB3412.eurprd05.prod.outlook.com (10.171.188.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.17; Wed, 30 Oct 2019 19:17:31 +0000
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc]) by AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc%4]) with mapi id 15.20.2408.016; Wed, 30 Oct 2019
 19:17:31 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH 1/3] ip: Allow query link with extended vf properties
Thread-Topic: [PATCH 1/3] ip: Allow query link with extended vf properties
Thread-Index: AQHVj1attkKfUOZHrUSeD+ZgSUqHRQ==
Date:   Wed, 30 Oct 2019 19:17:31 +0000
Message-ID: <1572463033-26368-2-git-send-email-lariel@mellanox.com>
References: <1572463033-26368-1-git-send-email-lariel@mellanox.com>
In-Reply-To: <1572463033-26368-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.188.199.18]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: AM0PR02CA0072.eurprd02.prod.outlook.com
 (2603:10a6:208:d2::49) To AM4PR05MB3313.eurprd05.prod.outlook.com
 (2603:10a6:205:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ab37890a-5bf3-4b3f-a753-08d75d6dcfa1
x-ms-traffictypediagnostic: AM4PR05MB3412:|AM4PR05MB3412:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB3412FF4A0ABC02DCCF10FE73BA600@AM4PR05MB3412.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(189003)(199004)(476003)(486006)(66946007)(66446008)(14444005)(66476007)(2616005)(6116002)(11346002)(3846002)(2906002)(71190400001)(66556008)(71200400001)(446003)(5660300002)(4720700003)(64756008)(256004)(8676002)(66066001)(86362001)(2501003)(81156014)(8936002)(478600001)(76176011)(102836004)(6486002)(26005)(50226002)(6506007)(386003)(6436002)(52116002)(7736002)(5640700003)(186003)(1730700003)(81166006)(305945005)(25786009)(54906003)(6916009)(316002)(14454004)(4326008)(107886003)(99286004)(2351001)(6512007)(36756003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3412;H:AM4PR05MB3313.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VSmH5Fht414kcUr8qN2QMyHtruCdL9WT+tz1EXrLk6lZBBs54nCKRIFGByLl8VrN6c8ByE5USfKp/iTGMntY+dDTM+Ep3dB3bAD0Xd2iL02qcaOAaIjWs1vx3/TWdAfE1IMx0Xgjy411i8C7PFy4p2MCfDgkK0K8mvwcl8ura/Jj0hSz+UqOWWrDX47fIvIVwUOo5Ke5qp/c158+QWPbhbi7gs1EVE5C4YicwCLzigWEvB7IrLaatnQpIWamTEYSYMKDNWQuj7eq2KEWs67skCVWAUWKd6KPuIsWm44fv4QyRrFZee6kAKkK3iks8EDrdmAMfQxrqBOgDfqcOeLQFy5Hp6mYO57Ucbnkis5Q1KTmCDYY6Q+m1Ck01AKp1qdBun7yiyHG1JdgqhuAG/1bhFjGvweJAisBNRD0zaAN1coCjw1j0kyqMTCzMq4FN6eN
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab37890a-5bf3-4b3f-a753-08d75d6dcfa1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 19:17:31.3969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ugDtIj9T9YMHchgqap7GJArya6K4/+cDhBy4sofPjFflfDbSCuP9pthPwUFIPIMiIb++8uEKuDH/VUYK+W44Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3412
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding vf num filter to ip link show command for querying
extended information of a specific vf.

When specifying a vf num, the kernel may return additional
vf information that takes up large amount of memory and
can't be included when querying the entire list of vfs
due to attribute size limitation.

The usage is:
ip link show dev <ifname> vf <vf_num>

Only the specified VF's information will be returned
and presented in this case.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
---
 include/uapi/linux/if_link.h   |  1 +
 include/uapi/linux/rtnetlink.h |  1 +
 ip/ip_common.h                 |  2 +-
 ip/ipaddress.c                 | 16 +++++++++++++++-
 ip/iplink.c                    |  6 ++++--
 man/man8/ip-link.8.in          | 13 ++++++++++++-
 6 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 1c49f43..d39017b 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -169,6 +169,7 @@ enum {
 	IFLA_MAX_MTU,
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
+	IFLA_VF_NUM,
 	__IFLA_MAX
 };
=20
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.=
h
index 4b93791..8fc7f5d 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -758,6 +758,7 @@ enum {
 #define RTEXT_FILTER_BRVLAN	(1 << 1)
 #define RTEXT_FILTER_BRVLAN_COMPRESSED	(1 << 2)
 #define	RTEXT_FILTER_SKIP_STATS	(1 << 3)
+#define	RTEXT_FILTER_VF_EXT	(1 << 4)
=20
 /* End of information exported to user level */
=20
diff --git a/ip/ip_common.h b/ip/ip_common.h
index cd916ec..4151232 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -83,7 +83,7 @@ int netns_identify_pid(const char *pidstr, char *name, in=
t len);
 int do_seg6(int argc, char **argv);
 int do_ipnh(int argc, char **argv);
=20
-int iplink_get(char *name, __u32 filt_mask);
+int iplink_get(char *name, __u32 filt_mask, int vf);
 int iplink_ifla_xstats(int argc, char **argv);
=20
 int ip_link_list(req_filter_fn_t filter_fn, struct nlmsg_chain *linfo);
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index bc8f5ba..0521fdc 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1874,9 +1874,11 @@ static int ipaddr_list_flush_or_save(int argc, char =
**argv, int action)
 {
 	struct nlmsg_chain linfo =3D { NULL, NULL};
 	struct nlmsg_chain _ainfo =3D { NULL, NULL}, *ainfo =3D &_ainfo;
+	int filter_mask =3D RTEXT_FILTER_VF;
 	struct nlmsg_list *l;
 	char *filter_dev =3D NULL;
 	int no_link =3D 0;
+	int vf =3D -1;
=20
 	ipaddr_reset_filter(oneline, 0);
 	filter.showqueue =3D 1;
@@ -1953,6 +1955,18 @@ static int ipaddr_list_flush_or_save(int argc, char =
**argv, int action)
 			} else {
 				filter.kind =3D *argv;
 			}
+		} else if (strcmp(*argv, "vf") =3D=3D 0) {
+			if (vf >=3D 0)
+				duparg2("vf", *argv);
+
+			if (!filter_dev)
+				missarg("dev");
+
+			NEXT_ARG();
+			if (get_integer(&vf,  *argv, 0))
+				invarg("Invalid \"vf\" value\n", *argv);
+			else
+				filter_mask =3D RTEXT_FILTER_VF_EXT;
 		} else {
 			if (strcmp(*argv, "dev") =3D=3D 0)
 				NEXT_ARG();
@@ -2006,7 +2020,7 @@ static int ipaddr_list_flush_or_save(int argc, char *=
*argv, int action)
 	 * the link device
 	 */
 	if (filter_dev && filter.group =3D=3D -1 && do_link =3D=3D 1) {
-		if (iplink_get(filter_dev, RTEXT_FILTER_VF) < 0) {
+		if (iplink_get(filter_dev, filter_mask, vf) < 0) {
 			perror("Cannot send link get request");
 			delete_json_obj();
 			exit(1);
diff --git a/ip/iplink.c b/ip/iplink.c
index 212a088..ef33232 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -107,7 +107,7 @@ void iplink_usage(void)
 		"			[ protodown { on | off } ]\n"
 		"			[ gso_max_size BYTES ] | [ gso_max_segs PACKETS ]\n"
 		"\n"
-		"	ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [ty=
pe TYPE]\n"
+		"	ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [ty=
pe TYPE] [vf VF_NUM]\n"
 		"\n"
 		"	ip link xstats type TYPE [ ARGS ]\n"
 		"\n"
@@ -1092,7 +1092,7 @@ static int iplink_modify(int cmd, unsigned int flags,=
 int argc, char **argv)
 	return 0;
 }
=20
-int iplink_get(char *name, __u32 filt_mask)
+int iplink_get(char *name, __u32 filt_mask, int vf)
 {
 	struct iplink_req req =3D {
 		.n.nlmsg_len =3D NLMSG_LENGTH(sizeof(struct ifinfomsg)),
@@ -1107,6 +1107,8 @@ int iplink_get(char *name, __u32 filt_mask)
 			  IFLA_IFNAME, name, strlen(name) + 1);
 	}
 	addattr32(&req.n, sizeof(req), IFLA_EXT_MASK, filt_mask);
+	if (filt_mask & RTEXT_FILTER_VF_EXT)
+		addattr32(&req.n, sizeof(req), IFLA_VF_NUM, vf);
=20
 	if (rtnl_talk(&rth, &req.n, &answer) < 0)
 		return -2;
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index a8ae72d..29744d4 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -176,7 +176,9 @@ ip-link \- network device configuration
 .B type
 .IR ETYPE " ] ["
 .B vrf
-.IR NAME " ]"
+.IR NAME " ] ["
+.B vf
+.IR NUM " ]"
=20
 .ti -8
 .B ip link xstats
@@ -2396,6 +2398,15 @@ interface list by comparing it with the relevant att=
ribute in case the kernel
 didn't filter already. Therefore any string is accepted, but may lead to e=
mpty
 output.
=20
+.TP
+.BI vf " NUM "
+.I NUM
+specifies a Virtual Function device to be configured.
+
+The associated PF device must be specified using the
+.B dev
+parameter.
+
 .SS  ip link xstats - display extended statistics
=20
 .TP
--=20
1.8.3.1

