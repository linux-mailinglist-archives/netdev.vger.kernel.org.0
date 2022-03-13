Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2224D75BA
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 15:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbiCMOLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 10:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbiCMOLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 10:11:42 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60060.outbound.protection.outlook.com [40.107.6.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C5820180;
        Sun, 13 Mar 2022 07:10:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebcbX0BrGFIxuNfs4T1QoJkIF9WlsoOAjS2FoVv/Q02eDMjHItIE54jb+cHg3a2+taWHYzbj+f5143V3/08buehkMOd3DOmgyHGX0Gfa50iBHB3m50lNDFW4zdS44OQQP7186jNys+nApN+Qskop4twBhIabGWG1vTu0qi4tm6yQzkTFlqTMyJP9mHlish6y7WQKvPaFeaEqpPINMdAgUEdty0GQnU+txGVFrzAUtXoXZuT/aWLnAoRlbGywW0BiGkOloLQynGRUrIIzUUn70Cmyf67qsVWFv+zhqj3wIQiIREiH/ZSCD8Rp5U/ppGJvinV0+ebr/CGDylKzk1vmFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YOrCtu0lm6NSrpTVmoxR9SUjOLd6W5nov57+lGk/sIY=;
 b=X1wYuXRA/g4gmoVsd4Q83V0DIXPyQv+UP/N38dr6vvogzGDUNpTWJyEe2y84HJCtX9qAfBLppnDILA00qRtqpY8XbcKzA2GjJsZjAqUhkbTvvk9i694FBpWRnjg5iLe2A6E75+nMr2zfaJw14QwBldX7T806pitplfzFgVWQyMEE7VoRPcFhLhrzgzmwCd6TfkR9WH3Fzk77/OB0p4hf2nIFuTrvizqf8+Mi0O/5954PGmwJdJ8K8q4j8x+fNvwtm/MMkCo8r0jvRBrK2LXXeFYHZfIdr1Mq9PQpJIo/omcHH/fPz2Qycqand0M53GQwu7QLNC8pPTnFpQhoYiEI9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOrCtu0lm6NSrpTVmoxR9SUjOLd6W5nov57+lGk/sIY=;
 b=MaLK6LS4iBEEZDj7KgWcutHhL8TeMarYjTEHSOKrMLGtnhSTNeoYcFCyjP/Dnd+GwTkfqfiILTOrQBeQdnQC7X71TbJn82jhtcCC3TOVB4K2zt1X9ik1TQs93dTVHmujNUe0w0a81YMiMDQemAIgDwcuZLiY8Rr17alJsoXVYPU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3648.eurprd04.prod.outlook.com (2603:10a6:803:1d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Sun, 13 Mar
 2022 14:10:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5061.026; Sun, 13 Mar 2022
 14:10:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Daniel Suchy <danny@danysek.cz>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "rafael.richter@gin.de" <rafael.richter@gin.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: patch problem - mv88e6xxx: flush switchdev FDB workqueue
Thread-Topic: patch problem - mv88e6xxx: flush switchdev FDB workqueue
Thread-Index: AQHYNuMUe6nsPJS+gkWlndMnOWNLUqy9WmoA
Date:   Sun, 13 Mar 2022 14:10:31 +0000
Message-ID: <20220313141030.ztwhuhfwxjfzi5nb@skbuf>
References: <ccf51795-5821-203d-348e-295aabbdc735@danysek.cz>
In-Reply-To: <ccf51795-5821-203d-348e-295aabbdc735@danysek.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c97111d-fbc1-4646-b4d4-08da04fb3beb
x-ms-traffictypediagnostic: VI1PR0402MB3648:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB3648FD2E2F1F54940D9EF616E00E9@VI1PR0402MB3648.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7OZWIoJS8qZU4JhNXP8wcUqjb0zJAavULkM8oXShj5XYHkCq6y2v3oXfG3dot5GchdYe7gULkMKBazp4gUHVMJUYFmxdOnR+nnc021GNK13fP2alEd3gh7c64N5kANk5TJEuRWAj0OH2wDX3ovPeCU1sJ3vBglzcn2TBKeTCqxyLDxxVuhaJxsaesCIKk0QQCimA/tKgONmfGXwy3zFhiJ2GXnfhgbGxbQqM60voyusXViXwYw97erFY1rdeE5M+FZbu80WY6tqlxOgK/YlSPlD5c0tHSE3WCV4vOhfbuotJhbmOlOXtyGtl278hv8kUrn+PLWRd8SOgiXJ7eYuePpOjltZTu0z9zRcjA33m0vhQJ0+0StFE0nUZSCaT2RDRj5jTGs/K7aiZGEUJC0vx2ZQ3E4W6TvcPxJPC+UpJYpRj38KoiA+73A22MzifrLOdeG7fA1jHtmBSSLJ7QEx1pUaqR1TqfoQ7wR7i07urCkN+jwZxNZB5KY8tiTdZYGtj4wY3Qywh0/JS3UAqP5jS3LWPHd0rT7cSTYdlmaxAevEMxvakqpjbi6ScJcLv8uAA2n8ZY3ZzvJA7/ttMO3flY8B7HOeyQFFMnA+/vtXughydo0pp58+XFkuYTt8zKdSSnrBK744xvtf6QKziBnqOBACvz9nxddOF09hqPfPItWLdg9ZUg794WAazSh0FcfwzJ42gSXZqJ0bWDiLczXCp36kh6L6+ny18jlWlI7M4NoIXew+d7AfDOtSxCQRGUdzsaIQl9u1J4SjcEC+YE5vtbhWiCVnhqCGcjXZ99dUdJcw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(2906002)(54906003)(6916009)(6506007)(6512007)(316002)(8936002)(44832011)(83380400001)(5660300002)(33716001)(26005)(66556008)(91956017)(64756008)(66476007)(66446008)(76116006)(66946007)(86362001)(186003)(1076003)(122000001)(6486002)(508600001)(966005)(38070700005)(9686003)(38100700002)(71200400001)(8676002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n//vC5XKCVceMePwBtId0mEa+fq8iAKpIO6P5hxAAC1dv8bfBZaJfN/XYfHW?=
 =?us-ascii?Q?Ey3wxY7d+qexnZCyz/Zap8imfqGPMYL4cJjSXkXaMyQlBjCM5qU0bQW7Lt2A?=
 =?us-ascii?Q?ORa+fyMPkVb+oO2jlt9gqEJcv5dRuDqcqU3mVBBzp7eg/trNgAY42mHIpNh1?=
 =?us-ascii?Q?QPacJtVJYJFmBnwFLCvPxpLzfsWXeg7BfQuZEBCcMiKQDjhHaXcGP+eGzK1a?=
 =?us-ascii?Q?q1MxcUZYqJ2rGfJPVzCco3EcRpykXoMk+4YygKNYaT9vWGVuND3QdU3c8hO/?=
 =?us-ascii?Q?ZoA786gsdKEpYTu8V82bg/b0FY75vlOH0uCP6lXoqVsPdrmmwDbGBzitVkjJ?=
 =?us-ascii?Q?vS4dzLZN/MDz8Are0hQOYTAWUGI97aeNi8g4aEPDowiRt/d9iJJo7FZb0xnf?=
 =?us-ascii?Q?y0GZ2Cvw2C1wtklKcdnFawCgxoYlPGH1QEgCmK7aBYF2iGamYdnEc9VSYXsy?=
 =?us-ascii?Q?T5XtkwRB5Arr/7aqo7jMiykLMvYfFIK5DRxkK7bzSK9i2HW20dg2T7tAzm9I?=
 =?us-ascii?Q?b4sqx/eCgvI8mv0wmwQfpS/xwSbQUbRQCKTGeR21xDzqdKBLlCS63xv3QYaH?=
 =?us-ascii?Q?Vn8PeoJTQOZ99Dc/RIydDip/RKLftkqK0UBNlOBomW8tnOd+ZXj7OSqXjbog?=
 =?us-ascii?Q?3bCLuGg7D1MQlt/rZGG5eDsjYmEJlgfqUZr+O8Kp7isxMBnW9LzWfZg9pJXk?=
 =?us-ascii?Q?3waiFO+pUSlZFivrbS8y0fuiFmNMaUeJatqBHK+Ho59Oqb5XuFpmisZTrV2f?=
 =?us-ascii?Q?KSCtZbGnu7WstWi9G2CVgnG1vad4P0VJNxsYRIGS5S32bwbolEtJtwvndzr7?=
 =?us-ascii?Q?wVhm6yv8FFbonJXO5BJWNRz6ncfXnHG4AD+UkwmmPIo5C/gS3ffbFCnRV+iA?=
 =?us-ascii?Q?8Owtmy+xx73EgaXZCuYGayimmD0ZOz7yXdM52ueWE6sQSu1rbJjYZ58Bo4k3?=
 =?us-ascii?Q?P9ABg3XXLN38VKIS+UvhwJ6YlfhA0N+OXDpqbVTImaykDUJlzJBVv//ummP/?=
 =?us-ascii?Q?AYZydCCBCwWJ5oTkzuMTmk+4IyKeaxwKmsUJUjeZblBkVWDaiLJRM9vKxcpu?=
 =?us-ascii?Q?NT87p92gfqHHuL/35b8cnMJWOWnsRM0FKU5iQVGXqu5qqkW6giVRbogy04BZ?=
 =?us-ascii?Q?CbL4NO7QVNnawk0VcDGG+HBZLgOP23dEvEbyFH9o30okPmZ7Hj2auz45+ZPz?=
 =?us-ascii?Q?IMgNQCUT9XvjP7zuAZF934dqWUVqNcj51QiFdAPFtwIP8s3USBaGesjJQXp/?=
 =?us-ascii?Q?1+mhMfBkTVs5/at7xa8BmTDbTQvYmadZ3w+seWeglWvs9slyVHiwuJevO7CE?=
 =?us-ascii?Q?9FhIsxYknWjxbFa94KStOvRvG3HW0gPi3wTpCu6+4d+wo0CWWl9MI4Ln87wx?=
 =?us-ascii?Q?HhmvijaA/7K3jp02ipNUn7CBpd4Y1kQplFcX7TQGIHs33RtZPIbEd3D/WsXl?=
 =?us-ascii?Q?yr2d7JEx8eJY61fX5Vl2Qe/nGHdkeCNTKUFfvC1UQy4v43g+ZenBPg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B8543E06734BEB49ACD8CE8595C9207E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c97111d-fbc1-4646-b4d4-08da04fb3beb
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2022 14:10:31.2764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: upUdbolUT3VdDxODG/NfkvStyeX2OfYIK2rvd8pfgezU+Fmz5+MlPVhW1dNyY02hK4Kz+H45OCwMsOZLGCbK7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3648
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Sun, Mar 13, 2022 at 03:03:07PM +0100, Daniel Suchy wrote:
> Hello,
>=20
> I noticed boot problems on my Turris Omnia (with Marvell 88E6176 switch
> chip) after "net: dsa: mv88e6xxx: flush switchdev FDB workqueue before
> removing VLAN" commit https://git.kernel.org/pub/scm/linux/kernel/git/sta=
ble/linux.git/commit/?id=3D2566a89b9e163b2fcd104d6005e0149f197b8a48
>=20
> Within logs I catched hung kernel tasks (see below), at least first is
> related to DSA subsystem.
>=20
> When I revert this patch, everything works as expected and without any
> issues.
>=20
> In my setup, I have few vlans on affected switch (i'm using ifupdown2 v3.=
0
> with iproute2 5.16 for configuration).
>=20
> It seems your this patch introduces some new problem (at least for 5.15
> kernels). I suggest revert this patch.
>=20
> - Daniel

Oh wow, I'm terribly sorry. Yes, this patch shouldn't have been
backported to kernel 5.15 and below, but I guess I missed the
backport notification email and forgot to tell Greg about this.
Patch "net: dsa: mv88e6xxx: flush switchdev FDB workqueue before
removing VLAN" needs to be immediately reverted from these trees.

Greg, to avoid this from happening in the future, would something like
this work? Is this parsed in some way?

Depends-on: 0faf890fc519 ("net: dsa: drop rtnl_lock from dsa_slave_switchde=
v_event_work") # which first appeared in v5.16=
