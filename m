Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48534416358
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 18:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242091AbhIWQbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 12:31:20 -0400
Received: from mail-eopbgr1410102.outbound.protection.outlook.com ([40.107.141.102]:23018
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233964AbhIWQbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 12:31:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oI40dCIFRCBWSajPAplAbi6bnaPD12y3w5PmN+3mjJFbBhJ5kRdOcdMRERxPT69Juk9etnfy56x2nL101VU+vuVGd5mtBeneD97kNQnzRDP8tpVOjHdh1l05kJGG6Dn0Pb6kYiNxsbm5z1Eqt+lNyFc9htsPa3F1+utNDkxTi2RlwULZjFQ7Q2fZdu3sRSuxV/i7KD0DleeNwcX5ryzB7wAhcs71MGlm4z3Z62vnw+Ro6IYXGfAwTxxbaWq+MSVN19iGvitjMkqxsKFcAIiKRMDK6XQb4rNUylJhmpN7GSYmsdCacup25nnftOvk99HSR9RMMD1zDRm6DkSWwGrxjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=BOVosPK/xg9lksnfuaDME8IiEFZpUITAi+u6hGMxSmQ=;
 b=Njf5P0mvn73TPsr75cQqdoC8lBin4BLVc745nfIHX1Ix9eJ0Pnh2KCaQmMP4D2nCW5gPprZ2PnC5vs/+4a319EU3RN0UsXx1o48pk9sUqz102+/H5W7Tp6sZzNUTTR/pues4r9N+xLW2i9krc7qXDazCyO/5Xv8eAalk93N917tx4nnt2/ma+um4ID3DjLfwhRHkE3Ok4qLtr+uCV35MvPy5zi5ToMyiPk5XH63oWpUmwe23BoYpoA9qUpJWFXNLAiM7olVi4oHTWKSv18IjGaxP7q/ywd5UZK9rPErQh9kOsPLedqWCsL7aYT5lIkK/PsoZo+NS3jDVcxqdNiIOSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOVosPK/xg9lksnfuaDME8IiEFZpUITAi+u6hGMxSmQ=;
 b=QsbYq+hVZK9kPDZAnj3b2c4M+gt9s+voYu1wNEjhEburuWhPz3aP1/9iK6Ulm8JYYXpkMN2e8WVupevlOnFA7a8HFhUr76wzEAGJdplfpt8ZEdkiX9v5euYpepWF/Ctn9tIOJ//vH24ADGn8LhfIiEZ5bF/dOgsSbSQyRN8b94M=
Received: from TYCPR01MB6608.jpnprd01.prod.outlook.com (2603:1096:400:ae::14)
 by TYAPR01MB2589.jpnprd01.prod.outlook.com (2603:1096:404:8e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Thu, 23 Sep
 2021 16:29:44 +0000
Received: from TYCPR01MB6608.jpnprd01.prod.outlook.com
 ([fe80::e551:f847:27da:4929]) by TYCPR01MB6608.jpnprd01.prod.outlook.com
 ([fe80::e551:f847:27da:4929%4]) with mapi id 15.20.4523.022; Thu, 23 Sep 2021
 16:29:44 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>
Subject: RE: [PATCH net-next] ptp: clockmatrix: use rsmu driver to access
 i2c/spi bus
Thread-Topic: [PATCH net-next] ptp: clockmatrix: use rsmu driver to access
 i2c/spi bus
Thread-Index: AQHXr7nQycIf/kQI20iun4+FyujEaquxwHAAgAAQGjA=
Date:   Thu, 23 Sep 2021 16:29:44 +0000
Message-ID: <TYCPR01MB66084980E50015D3C3F1F43CBAA39@TYCPR01MB6608.jpnprd01.prod.outlook.com>
References: <1632319034-3515-1-git-send-email-min.li.xe@renesas.com>
 <20210923083032.093c3859@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210923083032.093c3859@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8423c096-539b-49f6-4637-08d97eaf59ee
x-ms-traffictypediagnostic: TYAPR01MB2589:
x-microsoft-antispam-prvs: <TYAPR01MB25897D412AE1C3C8D48DD570BAA39@TYAPR01MB2589.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ovqBFHwXxFrAQIY06/QqO8lDmSl0qt+iw3fpOm57mXP728zzdP6EMAGgutbTH+AXiVL6VDy6uRl8WU5hAOepVTdf1pHkfZCxzz2wyzXdBWkLu56hCnYsFhKJ4L3HUT6fQVVgqkFKjep2OUojRJmObuda3XaebXMjRa93/uiHYeyXtFirVuryHZ3fOA38blBcvplYTTv6ZCU2uKBXEFgY9lQwX7Ym841CF5rtV8ioz8rSYO1XBoFQN5bfSYfhBSEHJwDyIZRhZYqpCWIqbhiXPCLldmERmCT+leBkdlcdLxc1D0YoxzfQ7OWKoQ55UqXtjDbR2sLpEvmqfPnKDJwx3dFaeawO6N/hZx0PM06Ov/up/KhESrAqbrJBWKCgkxDWRC9bNYjTLSEd04k/5orbTutdWd2zvxHU6achWEAmKN6shJoPjrMS0GDIKS/PjNggox7AqPlID47l4ygJg5BJNVh7ZkeNadnKis6mTSF+l9sT5xlE1rgqQwHuv2Wak8P1QYtYZSEdN1qp2RZyXb6dX/46rLpiHVGmNjWQguU6oq/c2ycHmhi2ZIU9dsk45WT7EOqEFtrUKigGWntYwNwuN/DKeBBnjp7v9vdH5lXwmZbV6o6BldAywMP4vf1cfWEaWcAMjn+hlxUeYrPV/+Tp70eVlDoTMFWnK0SRlfpu8RZEleRbx9R2IH/bLYN95373vs6JFqb6NMzZ1bQ0s0gCjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6608.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(55016002)(83380400001)(38070700005)(9686003)(8936002)(86362001)(64756008)(38100700002)(5660300002)(2906002)(186003)(8676002)(6506007)(7696005)(71200400001)(316002)(122000001)(33656002)(76116006)(53546011)(66476007)(52536014)(66946007)(6916009)(54906003)(66446008)(4744005)(26005)(66556008)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?poeAD/BiqcDYErj2Vby/+wvBMl3CQvrQZBpLSTKa4dsxaF0+obUwlT1HWN2T?=
 =?us-ascii?Q?C3EwvGRdjrUy3kZ/+oHL7mrrLGoCPcw5PGKDZFo0QwcbpupYm43QDoK23bZA?=
 =?us-ascii?Q?/Rn66T9tuoACuVqTZzD4BnUGy85MV4J3HfNvQhmk/OVExU85SUBlXE5bziNc?=
 =?us-ascii?Q?uqXXQqg0uiXolBruplRddnZWy/0hIrKw6M0zRJC3OvWI8CWR9yAe3leuSMXw?=
 =?us-ascii?Q?fv2mGfmsrthoxiRwjcNUvEhdglEbJXkruL8mbSJNKWUxfPC4qdtQy54+iEKg?=
 =?us-ascii?Q?jMIBmpin/SfCFoKiqtnx54h+sLWl3RM1wXZoEFd+QKa/iuol0jL85sTbFN4V?=
 =?us-ascii?Q?Od07CPgGZON+Hm9GUq2A1pKYfji+rfXkKNhqJI4UJWiwyiuIEw+k1h1fIeF4?=
 =?us-ascii?Q?DEsTclDGQYAxVK11Bs7i6/YFWH+Ic533W5X3NBTX2Ml2avPcfHWuQ7YJGblC?=
 =?us-ascii?Q?E1cYI2b6PDNiDrTGDJetAWJ2DgJAAGOlYuVlHyhDjDFKcj+w+nExACqv5/us?=
 =?us-ascii?Q?cCXNAs0gVn/UsjrxorZvzKClgbXI6RrIYhUH9UNaU1a3V8meiQXS00+21G7d?=
 =?us-ascii?Q?ykEEAvCXl8V6jmYFOQPpRY4xFkz+CnN84/+xAvqWVWMpwJBTDlpjwG/yy2r5?=
 =?us-ascii?Q?sZpwxM85gjnovhX1Ivt3BDLUeTmNQttUAl9yfXXYgIFteoawVVYEDISPqwya?=
 =?us-ascii?Q?Y3disKyJInc4POsrltyN251FBIRfc9mLf2N7g32vjwcrgv5aFrVUzY+sLky8?=
 =?us-ascii?Q?NOx1eYsQxN3ICbOh3yGaVfgT8LRr6q2aia7nULXfKlY2+8NFeOwQ4HzhmJJt?=
 =?us-ascii?Q?F8gWFFZpCTQAWMZlQftPjz9leZUT3O662/rKPsm5lI+vPfVPz7Ur3KTG65H0?=
 =?us-ascii?Q?B1qVr1jpKcktBmtnVaw1lZZIgzo6IDHMLsFZ7woKUPquS24bzgtJWDxvj3pp?=
 =?us-ascii?Q?49EDH+6ZWZ8ZT2xldMpE9n/qz7ROSGONrNOup/V8g3+/7e6mEvvYvUA+Dfmm?=
 =?us-ascii?Q?Jt996KMro8sb+mWUvQReiL+gmaIDAjl1fdyN5MJ6t/VqPhcG2a7H/dLSg9Mt?=
 =?us-ascii?Q?0B32ejNeHIyEaTcMZI1fjKJN7UyDryqJngnY9Dphj6PX986vJp5X6+pptZLi?=
 =?us-ascii?Q?fBX3qDtDmQ0kPUYByxE0YcmC9X2TbAL3TTMyazHCNLDm1DvOhSMDoZ/qNjre?=
 =?us-ascii?Q?ehcLKZQAU3FuAQTc6H6ADhknOLMZc+4VK27gHrEFnINsqoDyFPlqkgJeDL1P?=
 =?us-ascii?Q?gUddzjMZzBZQ0mIkVL9hPDh36fXns8aehpLieypEX6SVlr9xImofwKncbR6Q?=
 =?us-ascii?Q?/JNzCMuSF/tFL2IsK7lpN9lK?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB6608.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8423c096-539b-49f6-4637-08d97eaf59ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 16:29:44.1505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uxiOp040DqMcTBQxCJVNUNRPUtG5MLvvF6ofzjzSocwCDSGP8qWS7IqyiRFmObB/taqf+7g263IuZWbkkKKIcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2589
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: September 23, 2021 11:31 AM
> To: Min Li <min.li.xe@renesas.com>
> Cc: richardcochran@gmail.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; lee.jones@linaro.org
> Subject: Re: [PATCH net-next] ptp: clockmatrix: use rsmu driver to access
> i2c/spi bus
>=20
> On Wed, 22 Sep 2021 09:57:14 -0400 min.li.xe@renesas.com wrote:
> > From: Min Li <min.li.xe@renesas.com>
> >
> > rsmu (Renesas Synchronization Management Unit ) driver is located in
> > drivers/mfd and responsible for creating multiple devices including
> > clockmatrix phc, which will then use the exposed regmap and mutex
> > handle to access i2c/spi bus.
>=20
> Does not build on 32 bit. You need to use division helpers.

Hi Jakub

I did build it through 32 bit arm and didn't get the problem.

make ARCH=3Darm CROSS_COMPILE=3Darm-linux-gnueabi-

Thanks

Min
