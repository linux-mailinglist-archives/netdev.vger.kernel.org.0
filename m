Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5F93566D1
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 10:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240999AbhDGI27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 04:28:59 -0400
Received: from mail-bn8nam12on2105.outbound.protection.outlook.com ([40.107.237.105]:56480
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234447AbhDGI26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 04:28:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zl3qaj7Sn+TgfViXQm3B8RCUqcFMLSVGK6vtF4NTaBv2lETP7MkYQQNQgsCLUmzDuuGWbiFXBru1kwKlov6bp3R6T62lKbnMOoRIpVLAf9UkcM9FNo7LznYalbOh+4oxpNif7Gb50ODhai4Jdc+lRoIvBKBvqN8QI9pWsP63TgBcq/GXZ+UoKDKfvIYSpsjTxc7vISwCvbKbXg4QWlhIkASopLPDptSt++ES0U8/ROg2N0jmFbD4Y1jLfJz2hT3P79s8jSy1x4Vz+wgLiE3MnIKp+VQTwWVOygHNWUMZAtUuKF5PpDiAokeNrIi2fTHDk4RPtpGRy1Xcb0bpdCo7cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzONKBdbZvsVdpBYbAr42LBqFEVdcF+Pi5VnajmdEck=;
 b=hICUKL1ugJ8/NXmYHhx4T+V7qYama6ijsnELblkXPdcg0UBK+aiFLamIuOMu77sbVWxPeggqQshKotKAlT05Pi0uU/AyARoH72tbrCeGqpGZPRZ8s60CVs/wY9uoc9rVXvy03rNeWzoERNyCHp1O77NrSmsKZGUAhffSZkvecedwqH9Lvk89gjn7ABJ3JHLx2l5LQqk/6uLNhEMHK6QMXQRPB5uT1H3JZx5qfBsp3aS+7S3aSTZH2fNyyT+Udq/dipp2iFiNBkkpvkUc+ZukRcgf9zgsRQ0REao+kjIXu+P1sNDcGQR1HRU27Pnsr006Ml5G2Bj1RWfOK1IMHDzrdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzONKBdbZvsVdpBYbAr42LBqFEVdcF+Pi5VnajmdEck=;
 b=NP0/rcgLBw2iW7toUy+RCUGNp5ktXc7xLMF5gfP2BdKryoxQx9t0T+OV/Mc7OZUJs468V0F3ppydo3dZoc8d7KP5hTsyviOv9FCBdbbaJ2xTvI2kvg2gw3Vg0K41YxNn7twLT/HX/SItjV6YZX91WhA4de4WUdNwttrzw1WCtLw=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MW2PR2101MB0972.namprd21.prod.outlook.com
 (2603:10b6:302:4::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.4; Wed, 7 Apr
 2021 08:28:47 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%6]) with mapi id 15.20.4042.006; Wed, 7 Apr 2021
 08:28:46 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXK0pqK9CYzM87fki9gwnmLmNhk6qoPxRQgAB2ooCAAAEm0A==
Date:   Wed, 7 Apr 2021 08:28:45 +0000
Message-ID: <MW2PR2101MB08923F19D070996429979E38BF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210406232321.12104-1-decui@microsoft.com>
 <YG0F4HkslqZHtBya@lunn.ch>
 <MW2PR2101MB089237C8CCFFF0C352CA658ABF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <YG1qF8lULn8lLJa/@unreal>
In-Reply-To: <YG1qF8lULn8lLJa/@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=07a90c26-a81b-48ba-804e-5977e3c9b7aa;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-07T08:19:25Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:b462:5488:6830:14b3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec09893d-5b69-48a6-6511-08d8f99f29aa
x-ms-traffictypediagnostic: MW2PR2101MB0972:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR2101MB0972003944C34D6972F0F949BF759@MW2PR2101MB0972.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uMS1fIasYGaHIAYBqERvqXFp6IJkHbfkbpLlRKNoquHVx+e/ZKlqPx8EBEgcEWXr+2vZDtCopUEDgRQRGchDVm+GDnxl/HIqkQBXb7aBzBDd1e6qEaZ0jKSC9s1shBrvRoKgHmI9GK7/8ayG+mURLBrMGvbFomj8BfvECbP5xJ+Yh5jBujp7EplG0ZhXn3qbFXbNxI5uyeu5pRzrUNbTKnai55+vBqvd0NxFZ8+1UyZzzkPhfIfgHTgCBZZOHaUOW3W85QahhdOTZpcl4VwA05x447FNjScmRGbmk+OevbDKrrJcs+X6044mU409RUNpuXwQeKOJssdRuqC2el7UiTW2euRbg2ezw3ta9qkEjOOQLYNRU5r5588L8XVm8NO3TG3UPt8MGOp2tmGu/u4mEurZslHtUGNWX6IQfFD2cPBwYCb8uVecayfHndn/cSJd387xaVfocS2T1Kx9K1nTCtNs34gZySJ65LESXdVjoz1AUj20gADZ7/AVykv5zY5R+AddXvEVnwvh3pSlSW7vGEP74zmJUkGyYsNhyseT6mlA+u/hrMEhyOBl2k6fiMpqBZTkbMUOiA6CoegygTofJQAhr+/HuCd6cZbVSQHnKcBKYoOiJ/qP7TSDkr8DfFSWn6O6vrBC+d3/nSBR/JMIfRKjF0muR8LKhtg96GMkVMI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(47530400004)(2906002)(4326008)(10290500003)(76116006)(7696005)(33656002)(64756008)(66556008)(55016002)(66476007)(186003)(8676002)(478600001)(9686003)(66446008)(8990500004)(66946007)(52536014)(6506007)(54906003)(82950400001)(6916009)(82960400001)(71200400001)(86362001)(83380400001)(5660300002)(316002)(8936002)(38100700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?niyuz1XXAnaEW8E7XmYI0CKfeeknwmLAklLd3ea3TY/jVe7JQWWaxxn5PLJS?=
 =?us-ascii?Q?gJUaSeoIYsLbajnQA7JH3adAY2IPX6DejT/SB0YU43d637DXkG8ABY9J3Jcp?=
 =?us-ascii?Q?A9CcOHMDnwoUH0X59r+JHJzw4VRQBXpjiaqurPaDiGr8ySvNQXvtR73kz9XF?=
 =?us-ascii?Q?V0kAPRERnipBsy2oNnd9y/WoTowdikxdasHt5pjErSBX9cs9ezC5jEdigVkc?=
 =?us-ascii?Q?sThZ64B5JTfwlRxDSC/0Cu3iATKuu8DqLJiTL0bY+tVAFx4HDctLdd+hfOez?=
 =?us-ascii?Q?zi4ug8xz3ZSiZmwQC+hIMlgZoSXTlH1SXzZxth0EvRKCLLEp7pO8xqv9HMR6?=
 =?us-ascii?Q?+IjPFW7YbYY2HRYOAH6Cgk+R6K4waiqTg71E09DW9/H7UDFbWhHLSs+qUuVX?=
 =?us-ascii?Q?01ThnkxJjzqCzW7mEyp6/s9sPyYuAiD9h4twn8df6JJWDOyuTASamDkgprjW?=
 =?us-ascii?Q?V5FKUp4mHnOq01L4UKPJ9+iPKT2mFhhST+FIw4f4lbaMDFimrmx7TnmhUCB0?=
 =?us-ascii?Q?wEizRfN5HtBP3I+RKP1u52JM3H3mFsLiLnR3Dm5NT6kwIMo+XjE2WFGeY+0D?=
 =?us-ascii?Q?4WoYwzg4yFGPbeIiHfGDuJ4B2cju2r4/4QvMVgOjWuSeUKoMvmyPhqJorW6S?=
 =?us-ascii?Q?eL/HsXAHhIvSKggLpHU2/Q9Z7UycfVxpM393eHrIN6BD0UwBk3R9DNrfG4x/?=
 =?us-ascii?Q?zKk2zNCtUg0memydhwc5t3BzTz310C+QVZlhRowkLN/gYxcPMisyUzTZTuTd?=
 =?us-ascii?Q?RH/1gd0kvYLS/qXR1VoA2Cx3zWbD6AFjsjg7DxxwlkzmLD1ye6r8SxwnjIbo?=
 =?us-ascii?Q?POUtimtOuCwGPy+Kekm8ZIXx+Kq3u24B6DCYKsTRIGFUAGJsBerqjG0ELWG/?=
 =?us-ascii?Q?aG4srVd4sJpsZ3ipnLMa62xlBX6P9v18qNdbTdZ6ioWh+n6a5V+sMBJFSN+C?=
 =?us-ascii?Q?BO0VEDuw+hocaY0PvxT8wMD5QPeecv7l0eD4EF8Lqy65tOK+ob8yC2x55f8+?=
 =?us-ascii?Q?bErMjB8xrg/CzYQTpAkZx6TMPeHOf6V4xubAzYer/CVIuZ/h0rXrc8rXnhjf?=
 =?us-ascii?Q?LEgjTZl+XFLdtAxlUOPTcrVAHK7z6VmYzivOi00PJcVwe3MARr350r1E+LNY?=
 =?us-ascii?Q?Rm380BhM/bDU5K21wWTjlM+UqYgle1/AlGd743TYQuSYJKhfln2vSJO4WVxL?=
 =?us-ascii?Q?WrWLTGKBu7Cgr9n25Rg5ie09rUDGKs5lQ0RJzV4P+PIGVZlw7MDKUAZor4zj?=
 =?us-ascii?Q?xm18jkRvEFaRuZuOCpefx42m+FlPR5NJOaptWKB5qJedYeHhLuZM9bPNwQ+H?=
 =?us-ascii?Q?vX92rhBiIv6MnYX+s/0lD5+x6I5gwQvKB5uwq5gEOE+KjmIn28n5B6kJeyLa?=
 =?us-ascii?Q?SPSI7CInlTe6lRunOi50UgAc5bEz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec09893d-5b69-48a6-6511-08d8f99f29aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2021 08:28:46.0078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CPoKtaATFhSztTqc6AnogFqn0OpzvGRUF2fpcGRi1waY9JifoYCc3ypiKLPQS5aUvGueZC/b5l7YihxQ1OXzkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0972
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Leon Romanovsky <leon@kernel.org>
> Sent: Wednesday, April 7, 2021 1:15 AM
> > ...
> > int gdma_test_eq(struct gdma_context *gc, struct gdma_queue *eq)
> > {
> >         struct gdma_generate_test_event_req req =3D { 0 };
> >         struct gdma_general_resp resp =3D { 0 };
>=20
> BTW, you don't need to write { 0 }, the {} is enough.
=20
Thanks for the suggestion! I'll use {0} in v2.=20

BTW, looks like both are widely used in the kernel. Maybe someone
should update scripts/checkpatch.pl to add a warning agaist { 0 } in
new code, if {0} is preferred. :-)

dexuan@localhost:~/linux$ grep "=3D { 0 };" kernel/ -nr | wc -l
4
dexuan@localhost:~/linux$  grep "=3D {0};" kernel/ -nr | wc -l
4

dexuan@localhost:~/linux$ grep "=3D { 0 };" Documentation/  -nr
Documentation/networking/page_pool.rst:117:    struct page_pool_params pp_p=
arams =3D { 0 };

dexuan@localhost:~/linux$ grep "=3D { 0 };" drivers/ -nr | wc -l
1085
dexuan@localhost:~/linux$ grep "=3D {0};" drivers/ -nr | wc -l
1321

dexuan@localhost:~/linux$ grep "=3D { 0 };" drivers/net/ -nr | wc -l
408
dexuan@localhost:~/linux$  grep "=3D {0};" drivers/net/ -nr | wc -l
708
