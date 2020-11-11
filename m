Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB912AF176
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgKKNEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:04:16 -0500
Received: from mail-db8eur05on2057.outbound.protection.outlook.com ([40.107.20.57]:10560
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726318AbgKKNEK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 08:04:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lY4h90RDO77ugjVKnuo0V/iiiGOpFUfWR8av0Eo3U46YrsalestcVlX8bh1KcLIBmkEgFAQJNEk6o5rSj3+Rcll1ZnyW2u5tb54cvm6GG8V964eopb8U4DAllF/PiqaDBbnhbKKjjqaH/zQ/n90JWDdWfFWihowcaI/9eGllHql9HciXVjm51qux6CTWud0kxApUwVeruiHhiCFbRFFQ3MeHt1lH4uNONQ9vHWF4oxK9apkMrb+HjhYdCgZC9SGCmn7KdqIk5gaCBZ1TAOXdgxuidPRxgZ3wOlz0OQtiQJ5A/RfNk8c7kVvj+0OuZta9z+bd8WamSqNBW/YF/QGSHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CwM3XMDQI87HrkT7AXVdGI1yCuLlW7I9Ma29mRnm8hM=;
 b=IznBqu7gyuPF+GG0GLuwEJR3CmjxqZQS7Xg9MsyBUCvXUMPhBB4noGkWXc+SHUaKgzSQO5J5J1rejVcudmtWyGTHBnN1PAZOEmqiKqcwBTLsKVl+p06KbgVzrBDSwtKTc3OgvJcY7InAMqJ7XfazxDXmNtS1WD3gQ4iNjetzjPC+/fA3ah5G+0gpwEl5zv/g92kSd/JFIvJdD0/DkDFWCUknWch5j6Mai1dC3RI+IJj8WNlRnVY7RHkGUvM9DgfyApjPkhKloJ1ASIr9Kd+OQkE4P70oHqX6IEN/qtW20lJpXe6D/YrjI+SCFAwqvGFn7DAhw6aQPqdghMA+CtRhbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CwM3XMDQI87HrkT7AXVdGI1yCuLlW7I9Ma29mRnm8hM=;
 b=Ype8qIbtR33PJirqwOIDjM4WSR87UYtRsei60VP0tMnFv8i0Ze38X380ntcCjVi2Jq30EYLcj2TUy2VHbsKQAhXkG89kbDRLs4IsXefyOIQqUYwmRp6hUQfjDZp3xwYjkgnP6eADWpxibFCA3DjNuCFMhwxVkn2ISF5AF8l1+oo=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM9PR04MB7682.eurprd04.prod.outlook.com (2603:10a6:20b:2db::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Wed, 11 Nov
 2020 13:04:06 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 13:04:06 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [PATCH net-next] enetc: Workaround for MDIO register access issue
Thread-Topic: [PATCH net-next] enetc: Workaround for MDIO register access
 issue
Thread-Index: AQHWt3g5LdPswlGN4kqnYf25WlFReKnCQzOAgACjzdA=
Date:   Wed, 11 Nov 2020 13:04:06 +0000
Message-ID: <AM0PR04MB6754EF190F22161DAB544FB896E80@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20201110154304.30871-1-claudiu.manoil@nxp.com>
 <20201110191639.149e5a6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110191639.149e5a6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.27.120.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3ae7d657-0aa1-4a66-6791-08d886424569
x-ms-traffictypediagnostic: AM9PR04MB7682:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM9PR04MB7682746AF57F44EE2818ED7F96E80@AM9PR04MB7682.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ugLteafheBeSULTI3KTWamgtBRpksQ7V5SsTJa8E4gNrqrA67DA1tdcOc6hmxeaSHbU2qvzl5EFHli/O3X9M2t0wIh3iWwOiQ+P4GplhWlWdt3fdtnMKfM/+nW+7TUC6DpWRdObidG5ZHnJC4ULqE+Q1Ax9TVyqFZrL3iv4P/Xvziv4lnMTnUBx/G+xYxHpUkdRahP6mNL6FxU96jBzCNJGIWuc7Q6lIJBP65KKJfmKBvGpl5W6A4KeYr8zeC6LaskdKQvVqNq0lWNUWtkIfkfEkSWU4AO7XaVLtRt/Gg3tg1FtMufrkDXgDo49AeQd8Q+nX9esKjZFtB7E8Jq1L6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39850400004)(346002)(376002)(7696005)(558084003)(4326008)(86362001)(83380400001)(9686003)(316002)(8676002)(66446008)(64756008)(66556008)(6916009)(66946007)(33656002)(54906003)(478600001)(52536014)(186003)(76116006)(26005)(66476007)(44832011)(71200400001)(55016002)(6506007)(8936002)(2906002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ROb3dWgMgvqRlHINL/1j/L1Wt3AkJAXC4qK1TAGz7Bwjkiz54fS5rnJbHLrA9vU5pqppSaB3PKDsr1UgQ4FcgxWO2dZr+Q7XZmpd6GSB97WBKISFDBii1z6xm8s/DOp+qpDUj64OLzhklOFok2rhgdQ4vj84XSD5dHfAOY8uLE/k2vM7d9RqdGu09e4ZFbwLw0bWUjO8rxrjzpNn8Dm8wU2RctuvP9fP30BCMxQa27afxd7QUyr6u5pgM3kujVP8lvVnC9WYL4D67yeTUHp/2etYDD0mHHHAE09wkfbp5AgBoqI0x8tfTuacL+U0xw1icdUhvyzo7YvUyeoTVZuqAoPD2CsQdg6Fs+xNk0wGz4vgf6UgkPgyRUbbGP3A0gqQZdpvFTWv41clE+m6fIL35iJdEGXTl7zRmKYNFzeLs682AK7NYUmJ5SgFJMeNherpvqAsBmpcx5eHwHZ7fxLvqzjpkTPDxXzkzhDfpCUlaY7H3ct4NjDh5qW1S8ST9nUu/zrVFqZ1jyfOk8Is5Jt4R5cqfsWa7cSQM4CEq0zQBTr0Uoxp5Qg0taBu/+e9lKkTQmN+92hQX9kwSZfoteKpj2A4lFwJlppeqNSiMroOufH2+XieuRZw9tNpmdM6NwQNdxBg3A0Utn0prA/XinGAyA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ae7d657-0aa1-4a66-6791-08d886424569
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2020 13:04:06.2734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yNqNpO8MJP4xbcGbKOO0mnihMTP1DW2rpwO24L+AtbUGTvlGwl91HB+nOPYqHqK5MWIBPSj7T9kmRsI3cPvPTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7682
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Jakub Kicinski <kuba@kernel.org>
[...]
>
>Please check for new sparse warnings.

I see... __iomem missing. Thanks.
