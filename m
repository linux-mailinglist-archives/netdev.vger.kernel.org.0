Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78DFF586576
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 09:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiHAHB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 03:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiHAHBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 03:01:40 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20610.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::610])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653BA2AE10
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 00:01:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PHkVpXKnMZxun8663ds8AmIVRXse1lZuilwU7JrhcAVPbamhpglUzJa9NvlBznq6yndetW8j1gThyouI29ToNTMc9rU5N3l5Sb6vhphOcyVnkJ9CXoPOWQ/si/H6cstJJ3LIRSjIaK8BOkg5sNaCenYtBIofo5Gn+OPU2A0e6mm95UKe+bYoAofkKbacUgbZcmd9R9dTetnij2UuRw0MQdAsGSdaj+zITLYEuxINLwJWjO0AMLSxI/cp0LpqSyLGQxtV0vxgfdG8c9VQdIF5W7+rxO00d2kHig24yz8XVqPCrsFBgTEt0FkbF+X5wgBb4cCf8kcvtRS17QpYc/yqkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ApDsqSgmprih4vZkM57NP8gjKlJlKYA+0f0JWxLrzZk=;
 b=OQrvHFS6z0gTa78lv9Eadv3Rj43x3CCMQYRql9/6QY3EOZxIvMk+ROeS8HEGMq6pmLl0JF8EedSgh3anRWn3ghGs92hwGsfDfneP3b9ONOKkg0pSuEYLTGMLIQ+lDfIONc7PBCakVhRvD2hfkHQaFQmoXjg6KE/ifCnpQ298wrujXBtQJCgPKJRSgfctUH+MtlUFzKuCNH34bHbmRWgHqDXsuD5Jc57un35BRv8dNVRdA9BdV6MHg9w3syJ/FRCj33Dx4rrXx/BZPzlq4M5zJbeXtdcqFIOnWwMxaNzuAqUtaV2exFDYgVUOKSmzo+hhBfg/DFZUMAcQyLSYHkJVKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ApDsqSgmprih4vZkM57NP8gjKlJlKYA+0f0JWxLrzZk=;
 b=HalBvzhaOhTgJ1a10M/kQRdoGcZGuYe4fxIpCLwdd+UlMYUXVkbVgpnH3J/aUy2eYX4B9QVxiVqSEyrJFt/APgD8E2Yfg8ZoxgYwbWC7mKPwOAQGaiccMj2ajYLO37X1fPkB7180ESsEMxLcOgDVIoKcQmgTf16ySfH6zooeSypc8KdBOoBjL6xi/p/Rbvrs3+hBtTY5AvxOl4UOXYSuW9fA5RlWkSdPvLFDb89XRf27ZQxA9+4PsqijKh8o81JEbjKw05rEshOPeo7jJLxQliQ0HSnIrOkE0/U09guuUel4oeCbJQVt7WNscWvJjn2GazYFyuGaRmfe0hhLSzLcEA==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by MWHPR1201MB0093.namprd12.prod.outlook.com (2603:10b6:301:54::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.13; Mon, 1 Aug
 2022 06:58:28 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::4d13:3b9e:61ba:4510]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::4d13:3b9e:61ba:4510%6]) with mapi id 15.20.5482.011; Mon, 1 Aug 2022
 06:58:28 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     "dsahern@kernel.org" <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Raed Salem <raeds@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: RE: [PATCH v1 3/3] macsec: add user manual description for extended
 packet number feature
Thread-Topic: [PATCH v1 3/3] macsec: add user manual description for extended
 packet number feature
Thread-Index: AQHYlSucXH4j9ZOrqE2iqGZ8wCAui62ZvWYA
Date:   Mon, 1 Aug 2022 06:58:28 +0000
Message-ID: <IA1PR12MB6353120F51ED3E761DEBC86BAB9A9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20220711133853.19418-1-ehakim@nvidia.com>
 <20220711133853.19418-3-ehakim@nvidia.com>
In-Reply-To: <20220711133853.19418-3-ehakim@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61e226f9-a51d-4175-9ac6-08da738b3ca9
x-ms-traffictypediagnostic: MWHPR1201MB0093:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M8TNL3AO7HGD2HqBPBhT2ZCWe3K9dGXJLwkjllz0QNOfSnZuvgD/y5wg2VJpo2v8JqJ1poIN/0ATipognhXxx0XsEaKcdksNMVwI5uAIj77W91guQTOQbHldYPz5tzhQhQ4Sss5Ngkszt345OmG1HeiHt8ss2/iqZx5/qbzRAYszobXgpo3neRvGfsSMdzgQVSZSSgt7lMxl73vV44LdaMHX80kGm7pdd9ktKzO/PTZxbDmRQb/eH6aFUDUdcLe7MfY3RYsxOnLRe31i5uaEJB71H+dSiMsJP4CkTFydvT2jeJZsIueUsy5ufKbzKlJFp37b6xNCWKhjPxs2gPnyt4qQsgdHAYtRimjazx69w6K8AwSYKKCQzVITOu2JjybXO2p9fJwEyPTPPJC5fgzBbk/ov4CWa/3nLxo6ExfTKvUjS0bX6Pupb4p/yzy11wJMJK9yH21+nRKfMkbLAv67RkGA69OULXCXCKGjcENqGzqhU4TzGpw0Pzd0JUXNv1TdRdmW4/8SEwrZpFs1ZW0aUCN/B0atfKS10cSWMrt6fNVcvsyJboJ+yEKQPzwdv/DM4Ww2wcth2DslDrt+3VZPOPBR3rsUe0iL3fwbgFdxhW9GCIXyZui1ysrxcn3ZB1u90SLAOZqirtPU4e7uyFk6UtTOW8u+XZ7jigH4eybTz6Bu6Uwvr3jYj/hXpPPaufF9CS2HT5YanET4nQ58S32mKim003U9Ac2n4PZTXT58EZOWNWtulm0vf1ixjH8AO9yRPDo8CAxG9uITBB1NYjpogZZxitDUTVbQNlxXNyAzk3E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(64756008)(66946007)(76116006)(2906002)(66556008)(66446008)(66476007)(83380400001)(8676002)(4326008)(38070700005)(122000001)(38100700002)(71200400001)(478600001)(54906003)(316002)(110136005)(107886003)(186003)(41300700001)(52536014)(9686003)(6506007)(26005)(5660300002)(8936002)(53546011)(7696005)(55016003)(86362001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YoV+0Tt2NEdDxyMMrHWs3lUTVKmxVkW15kpbRuFYMLLnjK/srqPKNn1utiJi?=
 =?us-ascii?Q?kfWbPhnDm0PpM81ejZ3r2MYilUaRhltPTY82O5OMae/gSqQCNeTIc/oEXKUD?=
 =?us-ascii?Q?kfzd8SXByc3w8tnOPVUsBOcLEk5dg3sijcLL+K17RI2sVsvJXEDiehIviW3n?=
 =?us-ascii?Q?om0v6Hw51Q4KyGRopsbh/jc2IyjrR+CGKLPZMSI840akPEY+Jpw67hjHBm18?=
 =?us-ascii?Q?GyCb4/L3aFmfSxRGmTmGPn5iOiHxEPPrUrb6GHRNaznjmrIv1lJF4OMxcIV9?=
 =?us-ascii?Q?deNeuGk3fEiW+4IDbP/NRk8dcxyeUON+rn6T7YieUA+RgHfDMKiKGoLZI2xR?=
 =?us-ascii?Q?u1jP6qvlcJtGgzmFVVPuSZO8+l/eGSPQ4eKRqiClBSFmhi4n9DyyYBnZw4Ww?=
 =?us-ascii?Q?eoMH0I61aK3pFAik8gX0Sh5ND7Lab6/9pkPm+EC2+Q0evJAzbIIoCFpvtop1?=
 =?us-ascii?Q?LlsZwHvafGXHeWlGBrIp7jE/gIwJbCTVkjsLbRAc1girZbf00d8KcwiRujjl?=
 =?us-ascii?Q?hSKX/DzbhdvFHuYmh04LLKFCoTJ1ldLSpGBISTiyM5iAgsgsdP6x9Su2O1dB?=
 =?us-ascii?Q?MHgwZGRNWHC39uow3dLidyzTj3gnQ0BN5jlhZZ+CZRuPLQaAgAaglSCPO64Y?=
 =?us-ascii?Q?1pOwPb+PJFkCY7ZsxOLBvjLxABWH8Wq5ZmzqyaE7lDZJFQtXnOmB48o0PjxO?=
 =?us-ascii?Q?I/8/AXsv0V4mcZ3dYhw8v2xclj1ZH1TmfU/pkweRWD5fC7acANifr/Ymc/ha?=
 =?us-ascii?Q?PGT2Xa//RVWSOxqhePGZf+kkUwe1IqD7OuBj5s5fJcJhygMpZx5Of2Rict9H?=
 =?us-ascii?Q?rJM2bmoioH183zxzo798X64mon4Xid33F0AciYvpzn1P7L44wLKiehopMmIx?=
 =?us-ascii?Q?8LD4ViOiA4YIqx1Ip3OH5GEFmd+TswJuRUIpEgY6krUxFc5FchIwGjSxH7RD?=
 =?us-ascii?Q?FhlY5B8lWEtAzfMdKfNuWVkIFr7f38Gx4TJ9CzFgDAUZM7187E4mbz7QALIu?=
 =?us-ascii?Q?+q7/HEPT19BDOuNOESvhaAbUHV2DrFIDnMPAHLnrOtuu9m6d9JcprKfMRIUq?=
 =?us-ascii?Q?1SFoV7L5X0dJFT68jPqZ860ToFpvI1MXSLRfFYyd1Li1PrHU0Pu04MPnSmx9?=
 =?us-ascii?Q?QU+tZCZ6Wc1nKGmen7hZ2Z3NOB34zcCtHMAyfiYFNP/sFP5JNjM7/nzQvzcI?=
 =?us-ascii?Q?4+xpFddFeUTOcaMGEwNfPVjUWwDZjD9YH5yj1rW9LgL1qlpngRnHAaYjztlM?=
 =?us-ascii?Q?GFaEfn54cu9TCqeIbnYzX/ypDR+nSQ8DXATOqQmfI1+KADdbCIwHGHwZIZ46?=
 =?us-ascii?Q?xKoXXSvmgHkW7GzS23+lKjURz6HQ4ntfiJAlJDlLMOpwuDLIiqo+M4QrhgRd?=
 =?us-ascii?Q?l9KUC2ke/z6/C/WzMro4wnsuz+leX/7hom9nQ9QxQBczcbmNRMDqOj2xUPOi?=
 =?us-ascii?Q?wZrgwpJYJh82dJNIcbRGLtr1oCOC1ioXQebr2BNrQDeJWWp5UCm4ZKkeqyNw?=
 =?us-ascii?Q?ftre7kNi4FUSEUXiMxJp6hD19k4Mxq6r9nAtec5G3CxmKHJzvkAVdpvX8nV5?=
 =?us-ascii?Q?uvblkw1gs+LImibybkc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61e226f9-a51d-4175-9ac6-08da738b3ca9
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 06:58:28.1431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mb0j7IOFfRV0FzRq9LgvWubgCVRYp1usRA+3zxf8lKgCrsSGbJ/++LY0oJ+hmfkLOP/EsEoE+fGfjrjuNBI4tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0093
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
a kind reminder ,
also is there anything missing from my side?

Thanks,
Emeel

-----Original Message-----
From: Emeel Hakim <ehakim@nvidia.com>=20
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
+number (offload is disabled by default) .nf # ip link add link eth0=20
+macsec0 type macsec port 11 encrypt on flag xpn .PP .SS Configure a=20
+secure association on that device .nf # ip macsec add macsec0 tx sa 0=20
+xpn 1024 salt 838383838383838383838383 on key 01=20
+81818181818181818181818181818181 .PP .SS Configure a receive channel=20
+.nf # ip macsec add macsec0 rx port 1234 address c6:19:52:8f:e6:a0 .PP=20
+.SS Configure a receive association .nf # ip macsec add macsec0 rx port=20
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

