Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E145867FB
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 13:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiHALPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 07:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbiHALPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 07:15:06 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B162DA91
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 04:15:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kb/iTjD8kynhuzfVbr27H36CCI3wd3p7aeaQeuOdjQ84wsvdHDYnCrDN4ytdtF9IvIzRN2uk4DKQaNU8Bk8GfmBs753fcOcMIYtC2rt5xBoP5TYHW2RjKW9Sw4zmxWSIqZK1g6fej6HJyjxYBs7zsfORHPOzedLn5lEYUu4V9UhaZ0MReguF9QkzyibFnbe5gi62jMeepvOVIIxt+/h+y666Y2UA8e+ylHmcPXMoI+13PrTHm5s71KSQAzMSOdxzPOf1UWmO3VUq268wnGN6JC3z+ZrypQgMLgiUV8atA73L/2OkmfMcTKYG+JMNrWagZcaTPu+iu4oj+v3k9O/IDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ItKiXFBUuKNDTP+o63ji1DP5ne5ljP7egIEzyD+UGpY=;
 b=bLayR4/xPc+JneB0odQecToYI6zUPr8cbGVDMO4idEXPaJXxqJhIvWUF1mPhEkNI02XCkN6c/myn+todznQIeWmthp9v0Dvg6DyOYlKRrwgfy0/n7p762YwWUzRr3a8f7vt86PGvjA8hMaHNTX6nuRPrM2qeMRp0TzHwvRrDUCeagK976zXD39jkFIKqzXCH3DikjL+v+rcgqcSmNeuvkyMxNsxtku97ULkDq140zG2KpFIRIzSd1aJkkLDU+3Yz3CuaZN03MHSBzZQMri1b/dEdUlqXSIti8rqqC/UtP/Cc4KvRKkb4m5Ob5E8hCe8wIbzs6ixGz6uBxUwbKLw5uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ItKiXFBUuKNDTP+o63ji1DP5ne5ljP7egIEzyD+UGpY=;
 b=EeQFviQG7X9nKxbzD1yagxKQ1pYH+3xNyZ3igCmUB4x+DBKwm8K5BnjaT7GardwQ5uXPVJ0wA0uaNjRYVrqOTXsdSXBDf3pCWGTlrLeJ2EollB7EfOhbXZzCVRK9cB6trWRjpHoosC6OW7HDYr80pZSkILYYGo8fRgVyyeTo1axceAFHUWcaFfj7Vs0MJb9jcWJSFPvwgOsCBy9TYn912XyWoc3VOdmkDN4UAlhk0BUyV/o9UxfeNqNWLWCHEK4edG4CxhXsAnJzpvSd98+ZqyvvNJS/CIOotGjBFAve3++qKcXB0UsCj6OvqPpiyaRcg066zNqTM8wSUHM/ZyDJxQ==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by BY5PR12MB3651.namprd12.prod.outlook.com (2603:10b6:a03:1a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Mon, 1 Aug
 2022 11:15:02 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::4d13:3b9e:61ba:4510]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::4d13:3b9e:61ba:4510%6]) with mapi id 15.20.5482.011; Mon, 1 Aug 2022
 11:15:02 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     "dsahern@kernel.org" <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Raed Salem <raeds@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>
Subject: RE: [PATCH v1 3/3] macsec: add user manual description for extended
 packet number feature
Thread-Topic: [PATCH v1 3/3] macsec: add user manual description for extended
 packet number feature
Thread-Index: AQHYlSucXH4j9ZOrqE2iqGZ8wCAui62ZvWYAgABH/QA=
Date:   Mon, 1 Aug 2022 11:15:02 +0000
Message-ID: <IA1PR12MB6353B88D92C8EEFD8BFE7DE2AB9A9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20220711133853.19418-1-ehakim@nvidia.com>
 <20220711133853.19418-3-ehakim@nvidia.com>
 <IA1PR12MB6353120F51ED3E761DEBC86BAB9A9@IA1PR12MB6353.namprd12.prod.outlook.com>
In-Reply-To: <IA1PR12MB6353120F51ED3E761DEBC86BAB9A9@IA1PR12MB6353.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07910105-201d-41e7-6ccd-08da73af1488
x-ms-traffictypediagnostic: BY5PR12MB3651:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6qYk68S8K6bX4jcfOLJG9kKpip1x+XhQeyjSS/kF637LJKbe1mABpU42u6RdaPaGleIKfhbPOfnctxElh7GzExWo+blLK0uLhvTuWuX7LFEk4l7catcEd3+vb8THDeiUjSMZuhrkxVEDvb3+pP5R+aMr5EHEyoj8PwOrIUUgMEn6QT+sY2Liqznhr7eQMoUiFLHcLWCxWAagEo1xI2WxRXvY+/SEcZwYF2cdr58qJocT0U1NwzWvQQuXKtFiN17t/gUGJzG2FKUxZOBabyreV72Tq5Nd62O29iUg05bdaPURkReaRpn0lGYRU+bDBSoTvc7qvb50DtWtr/IkNCNzQzjagUQCXv2kVH9NlZGtkCyEGSe3i1SgNakGxL+ZnTB6jRt0DHIixdz1AK475azcwRKQjAbFzPeUP58rnlNbrp/0bcIE+5JBPC2mtC8EKF63beAS3jj0rXEEW4ZvuUs8cX1LCqD7NASAtKlcviv1P8pyMPHV2pF5eqDqo3Nq87rfbM1TCUhKs8c37xRLom6G0q6TvMAODyawC8czjkkxibSOIUVuaUYoBKDrfOUSi/sGraeIHXTV8JOJp38BO/aZvm67Arah3Auna2GhUNv4SlCJxTvmsz3586r7prQKOJnE6wdY2iFA8RZfwxA+RsV0f9RSOnZS0iXee1Yv76EWPnG6r5C+S4joMiglaathoWbVp+4nWxLB2bpO/zIY1QGweUgwImnsKBkqYVKu2ND1SqYrgFiQlEckGLe0bMXPOxnAMUfMnQeb1I1Wc62HCEyGi2jRLbRNGEOWfHdcezXl7rQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(136003)(366004)(396003)(376002)(86362001)(71200400001)(66446008)(41300700001)(2906002)(55016003)(33656002)(478600001)(66476007)(66946007)(76116006)(66556008)(316002)(54906003)(64756008)(110136005)(186003)(38070700005)(122000001)(2940100002)(9686003)(83380400001)(6506007)(53546011)(7696005)(26005)(52536014)(5660300002)(8936002)(4326008)(8676002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BhKdlvGCIlgNxrtSHpNu0ku1TrbqnUsQGWVsR3sN8V+U5oBAbkPxRze3ga5d?=
 =?us-ascii?Q?mbNTq6Il8CiqyAImX2NWAlMl3emB8uIuuqUIQeIVfloF32UnR3XaLrgJ7WfS?=
 =?us-ascii?Q?11KmCgZMi5P7L5OAnRudm14blpwgCu2GZ6usO+uN6qDA+wV+705b7nqb927k?=
 =?us-ascii?Q?sFDhMnE4aLmMlTIq3YxG8x5f1wftTXMOQ4wXVbj8vMLQE2HpmNwi/BOaWECU?=
 =?us-ascii?Q?Ew+0foRQe44QZUBF4J93QdZOwDvrSr9SlL49VLTJNa+yVHIf+RvFXPdfsV1U?=
 =?us-ascii?Q?5mRYhtjPeS0gaFWgcJDC2kIcHBHgCJ5AgRwS4dE+C5o8z83Uwhkjyimj55WL?=
 =?us-ascii?Q?zvI+JdOnyX2NcbOI9ACARz1UiEVZZrZTXHSPX4uLJv7PZYpsGUPxrQ2GvDt7?=
 =?us-ascii?Q?kajmOQtRCwjkcqiZSNzL5M2faym4vylq8mVmzuNFqaWn/JU8G7c4ff6n/c2M?=
 =?us-ascii?Q?uiuTH7RFdJKaz/IoOJA2N1xx+yxiZB5npLnCrKzVI0u5JN7VcYlLeMKNXOMf?=
 =?us-ascii?Q?yX2UtKUSVpXjFOmr6JebHUpVslH+o4exdLQCZjL3r8GWnP1e5KhJbf2NduMp?=
 =?us-ascii?Q?Ur7vXbcnatK633M7d2azmIBerE14Av7SjbfEwSYdkmblg8zR5dOpoZJcNAoF?=
 =?us-ascii?Q?FAzooL1PKup2Vt+62/x1yxtNUUx/LbOdq3EaXUJgOyqzdcE0r8qdaPsQ7sVp?=
 =?us-ascii?Q?E/izrErjw/EDZD+dkuPuNzeIKAkTPM0MoTCa7MdXsQ7zTyhueeyX17N09Djw?=
 =?us-ascii?Q?n+ps+D2xoROmqwE8vmUNo4hcGdkFGnpnGGUl9fFtxZ+WkpVuo/2Q5pW9sT41?=
 =?us-ascii?Q?3pQ8RmkNfUQRlDhrL9TEPHm9V07Ala7MylryM8S34igw+8PtbI3M6l/nAJFK?=
 =?us-ascii?Q?/yfUBKtHMXcH/BucFgPY1tamEZ6oBBVo0OGX03ePnKYSOBCr/86BIyoB+r2T?=
 =?us-ascii?Q?DS1uYij7GcpBTX4oATVIOsx+YOaXOEu/H6JRi1G5i1To/4IKZok8e8bauaBU?=
 =?us-ascii?Q?LSNpuYxEd8Ak20YcI348xH6ES0ZDxLa0t3VRdXENJEA2b4z7b+X7SudNB8ag?=
 =?us-ascii?Q?5ak+W/qUbCHSVM8zG7qklgHDlcNWc+BPi1JQdJpiMmH6LTCCLAYeS4VKVIEg?=
 =?us-ascii?Q?aTl2WX0bCvj8OPEIuKMCylA1E+DnuayjOW4P3z39ojMn6z2BYkzF0S6ertZL?=
 =?us-ascii?Q?jLgxcjIBMUaysMCQx384e9HvwJRAPw2QqrxyXHMqrxEuw/V6Z2F6w7GoYWJv?=
 =?us-ascii?Q?NRKYxG4cl9ifD80NK1uwoG1uuqLX94ot4MWiFaXdVDvgvHwWo/kumUQdocGW?=
 =?us-ascii?Q?vVX+SiMDMwq18B8r2IBnPohd8EiI3gUq5O2I3DBTNspy9E9c4kiuqzQ0dkhc?=
 =?us-ascii?Q?DgFFXuEal0qj4Sbwqj9+w29UMK5uGVevbDa0p9xTq4bBmv8FIZhbsG6L3hkk?=
 =?us-ascii?Q?emwTnlNVXiiN6sRaFmpluHk79rcIcjy7ZBLbq4HZFAlpnrVlYum2IdSnqHwi?=
 =?us-ascii?Q?wOUV+7V5LfcFSQQJbwo57m0lkRDu6hBP+cNPBq/as0gwR1hzXtiXlanelXbW?=
 =?us-ascii?Q?PCw8Dvy7O86AOyzM8OU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07910105-201d-41e7-6ccd-08da73af1488
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 11:15:02.6677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OUWZRlkC1+1u8qHLx0MQXEatNZfGCDQ71RtrNpjXHLxdC9A7eNxW0JmXxaV/qHjjTGwepeX9Gj8dQBJqvKoQdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3651
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


-----Original Message-----
From: Emeel Hakim=20
Sent: Monday, August 1, 2022 9:58 AM
To: dsahern@kernel.org; netdev@vger.kernel.org
Cc: Raed Salem <raeds@nvidia.com>; Tariq Toukan <tariqt@nvidia.com>
Subject: RE: [PATCH v1 3/3] macsec: add user manual description for extende=
d packet number feature

Hi,
a kind reminder ,
also is there anything missing from my side?

Thanks,
Emeel

-----Original Message-----
From: Emeel Hakim <ehakim@nvidia.com>
Sent: Monday, July 11, 2022 4:39 PM
To: dsahern@kernel.org; netdev@vger.kernel.org
Cc: Raed Salem <raeds@nvidia.com>; Tariq Toukan <tariqt@nvidia.com>; Emeel =
Hakim <ehakim@nvidia.com>
Subject: [PATCH v1 3/3] macsec: add user manual description for extended pa=
cket number feature

From: Emeel Hakim <ehakim@nvidia.com>

Update the user manual describing how to use extended packet number (XPN) f=
eature for macsec. As part of configuring XPN, providing ssci and salt is r=
equired hence update user manual on  how to provide the above as part of th=
e ip macsec command.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 man/man8/ip-macsec.8 | 52 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/man/man8/ip-macsec.8 b/man/man8/ip-macsec.8 index bb816157..67=
bb2c23 100644
--- a/man/man8/ip-macsec.8
+++ b/man/man8/ip-macsec.8
@@ -24,6 +24,8 @@ ip-macsec \- MACsec device configuration  .BR validate " =
{ " strict " | " check " | " disabled " } ] ["
 .BI encodingsa " SA"
 ] [
+.BI flag " FLAG"
+] [
 .BR offload " { " off " | " phy " | " mac " }"
 ]
=20
@@ -64,8 +66,17 @@ ip-macsec \- MACsec device configuration  .IR OPTS " :=
=3D [ "
 .BR pn " { "
 .IR 1..2^32-1 " } ] ["
+.BR xpn " { "
+.IR 1..2^64-1 " } ] ["
+.B salt
+.IR <u94> " ] ["
+.B ssci
+.IR <u32> " ] ["
 .BR on " | " off " ]"
 .br
+.IR FLAG " :=3D "
+.BR xpn "
+.br
 .IR SCI " :=3D { "
 .B sci
 .IR <u64> " | "
@@ -116,6 +127,29 @@ type.
 .nf
 # ip link add link eth0 macsec0 type macsec port 11 encrypt on offload mac
=20
+.SH EXTENDED PACKET NUMBER EXAMPLES
+.PP
+.SS Create a MACsec device on link eth0 with enabled extended packet=20
+number (offload is disabled by default) .nf # ip link add link eth0
+macsec0 type macsec port 11 encrypt on flag xpn .PP .SS Configure a=20
+secure association on that device .nf # ip macsec add macsec0 tx sa 0=20
+xpn 1024 salt 838383838383838383838383 on key 01
+81818181818181818181818181818181 .PP .SS Configure a receive channel=20
+.nf # ip macsec add macsec0 rx port 1234 address c6:19:52:8f:e6:a0 .PP=20
+.SS Configure a receive association .nf # ip macsec add macsec0 rx port
+1234 address c6:19:52:8f:e6:a0 sa 0 xpn 1 salt 838383838383838383838383=20
+on key 00 82828282828282828282828282828282 .PP .SS Display MACsec=20
+configuration .nf # ip macsec show .PP
+
 .SH NOTES
 This tool can be used to configure the 802.1AE keys of the interface. Note=
 that 802.1AE uses GCM-AES  with a initialization vector (IV) derived from =
the packet number. The same key must not be used @@ -125,6 +159,24 @@ that =
reconfigures the keys. It is wrong to just configure the keys statically an=
  indefinitely. The suggested and standardized way for key management is 80=
2.1X-2010, which is implemented  by wpa_supplicant.
=20
+.SH EXTENDED PACKET NUMBER NOTES
+Passing flag
+.B xpn
+to
+.B ip link add
+command using the
+.I macsec
+type requires using the keyword
+.B 'xpn'
+instead of
+.B 'pn'
+in addition to providing a salt using the .B 'salt'
+keyword when using the
+.B ip macsec
+command.
+
+
 .SH SEE ALSO
 .br
 .BR ip-link (8)
--
2.26.3

