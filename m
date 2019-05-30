Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98B542F73C
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 07:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfE3Fsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 01:48:39 -0400
Received: from mail-eopbgr50077.outbound.protection.outlook.com ([40.107.5.77]:60241
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727242AbfE3Fsg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 01:48:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/FuvyBRpeIo2yTVDQ/NigGWEqkAbadsop4QyhfV3Do=;
 b=BDvnh9DUW5ONvMTiIHWSJJ5/qN6zPFTLHW0p6MkcOQGQ9GiSJ5Oz+GppZ1flo15kmYmxPql8RBEA28pfed7B+GNBxqKmrdUFhkjaHx5nlQq8GS20Pf2VitoFBBFGp9Lhr1lG1gaTE/wFn8aK5Yn+LwI024Nx0IsYQdJumU9il/U=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB2878.eurprd04.prod.outlook.com (10.175.23.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Thu, 30 May 2019 05:48:33 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1922.019; Thu, 30 May 2019
 05:48:33 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: Add error path handling in
 dsa_tree_setup()
Thread-Topic: [PATCH net-next] net: dsa: Add error path handling in
 dsa_tree_setup()
Thread-Index: AQHVFmuzmvZLNZ7YR0Kmx1UF9mLUGA==
Date:   Thu, 30 May 2019 05:48:33 +0000
Message-ID: <VI1PR0402MB2800E8561AC18A2B4418BE3FE0180@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1559167943-26631-1-git-send-email-ioana.ciornei@nxp.com>
 <20190529231753.GE18059@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [86.121.27.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27abd1a1-fe16-40d7-615a-08d6e4c27387
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0402MB2878;
x-ms-traffictypediagnostic: VI1PR0402MB2878:
x-microsoft-antispam-prvs: <VI1PR0402MB287827FB3EAC97D380D2B496E0180@VI1PR0402MB2878.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(346002)(376002)(366004)(396003)(199004)(189003)(53936002)(6116002)(52536014)(229853002)(68736007)(6436002)(6916009)(66066001)(9686003)(7416002)(86362001)(3846002)(25786009)(2906002)(55016002)(6506007)(7736002)(74316002)(6246003)(71200400001)(4326008)(71190400001)(316002)(256004)(99286004)(33656002)(8676002)(8936002)(54906003)(73956011)(76116006)(7696005)(5660300002)(305945005)(76176011)(186003)(102836004)(53546011)(26005)(81166006)(66476007)(478600001)(66556008)(14454004)(446003)(66946007)(81156014)(44832011)(486006)(66446008)(64756008)(476003)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2878;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aV77V7J8LeMOic7UE4YWXwqtBEnN2LURVa+PUJJ3sYGVkxyowOPYpWOGYcfljIw6aEJTeuQ/rEUQojEdX5eif4PJNbc4rERxc5ptMtSzPQ/Ih3aF0TkmRy5yi87JzmISgLrdUCYtY0LkASZVaIYENCR3GUfHQs7JCfNtEghelRKLylLR81IYv3iRarCb0CYq23OabcvfF++9IrYWmP8YwcOUWXkTJBfNqOohsINkYS8fAUZ78d4TnHSxPBaSis+KqnLqADG8Vr7c338bHxmIgM6iUi4acUoKVu+4u1H7y8hMuc7aGp3Kcy2+lJgxn3Ne9SQVlTze4WkQLynS+UNUoc2GFtTorcMRmP8FsI/mm3abNpVAszbN73IaXba320EU4wQb1Kfj66TE4SbOeqPhXyRZkWO/Y9kc41veJm1iWfM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27abd1a1-fe16-40d7-615a-08d6e4c27387
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 05:48:33.1163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2878
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/19 2:17 AM, Andrew Lunn wrote:=0A=
>> @@ -423,18 +434,41 @@ static int dsa_tree_setup_switches(struct dsa_swit=
ch_tree *dst)=0A=
>>   =0A=
>>   		err =3D dsa_switch_setup(ds);=0A=
>>   		if (err)=0A=
>> -			return err;=0A=
>> +			goto setup_switch_err;=0A=
> =0A=
> Minor nit pick.=0A=
> =0A=
> All the other labels you add are err_*. This one is *_err.  A quick=0A=
> look at dsa2.c, there is one label already in the file=0A=
> =0A=
> out_put_node:=0A=
> =0A=
> which has no prefix or postfix.=0A=
> =0A=
> So maybe drop err_ and _err ?=0A=
=0A=
Sure, no problem. I'll send a v2.=0A=
=0A=
--=0A=
Ioana=0A=
=0A=
> =0A=
>     Andrew=0A=
> =0A=
=0A=
