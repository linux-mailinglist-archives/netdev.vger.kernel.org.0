Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36F0357742
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 23:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbhDGWAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:00:05 -0400
Received: from mail-mw2nam08on2110.outbound.protection.outlook.com ([40.107.101.110]:6433
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229778AbhDGWAE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 18:00:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZItI1la2nfWqs1xlCErXBEYtc3K4jPi/te3YTcZDFaZPQ9Cb1R6y335jG8cm2qsBbuSySCKT4bqz9XNTY4Z//wzb1j2QzTrPKNHm0Wv6f40Owm3rFyFFwp9Yl8l0xu723ssRkMnyQnXLmyx6XGeF6Fh9wFRql7xi7KEXR0icO7XjtApEnOvlnx69eyy1xbJ/8VP/hJn6oDRcag5ejlYwAeM9WBERmczvoyzIDscwQ0i/UrFE/TFA4hwGj0h7sHjbg6PCLqqAzgNtSBmKMs+WTY+d1ZWnuZFweAXXi5+VyUvEarfk0w9fWgOSAK9RbYH6CgskqeVEvYQZErp7iHwDyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l2eYyYfoKTdC5nfVmlYbyhjnfCiwgal09SnPz1y/Qnk=;
 b=eGX2AS1NFrrPCKzF0PGF+MlvROezfMrgGO3ylMTpNTvJZ1nW4NZ1gUwkU0X3MC11RrLOeupVDITTe5cc4G++9DiCyovN+kIEGy8rFstyuMp8R9ANg92Tk5HZriU4i8RY/nchY1jC1XsoklQ7o08gGv8CZ0H0/8pPvqUOpKukCZbYZiS6oeXpCm+WGgdlY2DTEwStUI+1Z2pctklJ5CL7fH4XUDHpbyHv8r1tZ9xI7MiNKanJrTljdzjJMjukhcy93WEkVAtDFPchgBuaz8pvUbsRyrwMbpjbxXKxDmgZU/3shFDJ8DDghTlfKdoEONAV4Kt6gUY9E//Oi0fgWPZdTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l2eYyYfoKTdC5nfVmlYbyhjnfCiwgal09SnPz1y/Qnk=;
 b=WF3FpCeWVqldnpVF5YTeIzwF6dSxM1uIzdZVNibcvCrLIPbhOYye1JaKkOpG0z2xNq0yueAiSl++FsrYzoJq9drM+PfH2DzBqjT7XMMN0A/6FZX4efDOG8/ESNJmHbxztmK5bFysUGe0mMBQavU37LB6zuqAAtfnbGw6+EnIxxo=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MWHPR21MB0510.namprd21.prod.outlook.com
 (2603:10b6:300:df::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.4; Wed, 7 Apr
 2021 21:59:53 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%6]) with mapi id 15.20.4042.006; Wed, 7 Apr 2021
 21:59:53 +0000
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
Thread-Index: AQHXK0pqK9CYzM87fki9gwnmLmNhk6qoPxRQgAB2ooCAAAEm0IAAShIAgACZjzA=
Date:   Wed, 7 Apr 2021 21:59:52 +0000
Message-ID: <MW2PR2101MB0892AC106C360F2A209560A8BF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210406232321.12104-1-decui@microsoft.com>
 <YG0F4HkslqZHtBya@lunn.ch>
 <MW2PR2101MB089237C8CCFFF0C352CA658ABF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <YG1qF8lULn8lLJa/@unreal>
 <MW2PR2101MB08923F19D070996429979E38BF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <YG2pMD9eIHsRetDJ@unreal>
In-Reply-To: <YG2pMD9eIHsRetDJ@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4f2a6277-7d0a-4b65-a483-9086d5b5f8c6;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-07T21:54:08Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:c866:4eae:6a31:e8a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d11d7052-9dd8-4aab-19e2-08d8fa107915
x-ms-traffictypediagnostic: MWHPR21MB0510:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB05100CEB280542D309977A4BBF759@MWHPR21MB0510.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +QQvJ3FpWAvuhHpGW1zEtALNy609LRLojtJU0FCXXoFbwHMVr3bo2X63m/ysCQfvDX2Z+490azaGp46uEJcsA0QeA0lmDCYnOmljeP1947FIcjdo3TIYwl1hkbcCA08O74uSoOfIrptKTwCp92ZGSzRF2q+sVPF09B8e8jQjjOvgB0Xt5WwHby99orJS/c/djJF+/RhxtCQMl21d2avlKtCWdtIxAT9leUg7TgmAOTfo/rfdOx8zEOuiS3pAmUd+wsnILGBI+xwafZsdE4HoUYNwAI/7GJmvyoKgN0tCS8xJ/Q4B2AdoBM+HQCA0UiOAk06CgBvyFv4biAT0FY73tl/yg7dFoQCXdK0Ho6qMkh46UcGEvPy7TcD8dGJGc6dnn5Ail6+RXjUxiKVKUDli6zUfkx21c6Ch1LwqaiLQNMPec0UYzsV6sbN1ZI88bo+sRw4jiDdOofub36NLmWTkOLmdMallnt3vnvRunfEKw7rJ3+/YF5qt44FRS4NzVP2S4Vun9AIbNbO0/6f/+KCgVLQg3NQ7DHgq1Sd8D56SdyrSzX+6fC+O819nRt50I4abkhGwYst3FIUDThIgE9g6ZXErDiLGV9zPFqamKmKtuHO7AxGAAoikdf9voHj4yNVKaBDT5lw4b7fKBZZ8iKmiRLVO/9pP0YvklrBKJNzsJPE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(47530400004)(52536014)(10290500003)(86362001)(54906003)(71200400001)(4744005)(2906002)(316002)(76116006)(66476007)(66556008)(64756008)(66446008)(478600001)(55016002)(9686003)(66946007)(4326008)(38100700001)(82950400001)(82960400001)(7696005)(8990500004)(33656002)(6506007)(8936002)(6916009)(186003)(8676002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4yauLVAjp26DpqaIRE0gYfWaQCNpODWXRKwX9YOA0sPZDxHw/kAdSeJr9l36?=
 =?us-ascii?Q?5X/q3zDJQdXfCYJ+ex9o1MpksqwfOtxGsHNorpTOoDW0U8BpClQk81uDSy2G?=
 =?us-ascii?Q?8NIevgQarzuxCB/KKBdhEo4Bk1yojcVDjqNOXVHdf/J9vEmWhx55JfwVsb4G?=
 =?us-ascii?Q?mlzooAS07P/p1Ju7cA7rK1iC15mF24334gvr4sV52RHjhvxv0f+/WzXgNDtE?=
 =?us-ascii?Q?uoQQ9tjgSBS7FnB1tZKMx+uAO58BjUZbeIthm1d6f2lcZqDhoYkH6XQAlO/C?=
 =?us-ascii?Q?ws/77D+46mKqIRyB2aUj5PkCtjndRngk4Q3omYKTw7Z/c+Sb3DB51lkyG/bA?=
 =?us-ascii?Q?aH+8HGgEbqS5oyYORfv5RFCnC5rb36TN6sAQtfhoSsMYH+EOq5Nxg5oJZL+s?=
 =?us-ascii?Q?VgWJh/CH3iI8Y9MARdi0yFAvaU4IchAItmn6wWKMBTvyzehDAdKutVV6t2Hs?=
 =?us-ascii?Q?ZwyF35EFKtaxmkDrqZDN25MVGWMn9aXYrgQjOPnEk4QnfELEs6IOqbfZ7SXl?=
 =?us-ascii?Q?oTWxnTEDc6XLPAAPTOMw0/74QS0naHCg8aPvJ5Zye5S5HR0yuk/kngTkcIh+?=
 =?us-ascii?Q?lkIY3+xJ21SeXjkS2m0n2DOXYSvWNh4HnIlm5o88W+LVpvPUPmqd3XOQsmXS?=
 =?us-ascii?Q?2p8bBoBqDWLnshXbWRgD0e1bz8YHsRPVQw2FQLHhs+TYh09J81EC/8FbFbqR?=
 =?us-ascii?Q?4IpwZd+sOOQcRBOflMu+uUlEZUbGdAbglSnC8kI0AsCgbsMBfa1LuCIstYd7?=
 =?us-ascii?Q?GLO015brvMnXeL3EoLoR5g0xO0cFttn4g/QFho22BKBcxkZqGf/gNMfs9ucN?=
 =?us-ascii?Q?q2Pe4hGcvvvbLmNkINe1EwK5UkKD6wmrlBEFqZDhEj4uuGmIVDHneL4kwtYR?=
 =?us-ascii?Q?spQ/MpQVS+qYtIql9nOKSSpbhHiH60xCbAdVI701c8BZNauITEwab6JocUyJ?=
 =?us-ascii?Q?uplGV3nec+up0Zbk17OoRcIk/qZ3WtW8SUbrZ8AdGuioly68P41Y/xl/mwYM?=
 =?us-ascii?Q?jlxKxwfFQyAhcXvkkbaa79PvZNeGdcC545W66UEC/4M0gVeKM2lGpQlZ8eaK?=
 =?us-ascii?Q?vLme1XvhaqTAC8FQ+jN5MvzSKivr2/8o/TlHUSP4jDiwnreCNfZCJ0ax0d5s?=
 =?us-ascii?Q?qGICUS51DuWowtlU01fjif+aAV/5bwi3HrXGhglGP9Uc72jA6NY7XqXM+7nV?=
 =?us-ascii?Q?9QJErpM3ARv8rFUL+qdNY5YnA+4FXwYYQl0gCpbTF/2Nn7DDoBaTSHQhkkfJ?=
 =?us-ascii?Q?kFHsRLDlM4ZNsSpeg7f6XSBB62bjOIrHF37WTvyJrRxeHN6ypd745dFiVt7B?=
 =?us-ascii?Q?80Z0OiZW35sucZoUDOx6u5EzmLOwNWk/OxGUQoomKNLkA8U0deg4A/WWP93s?=
 =?us-ascii?Q?P0B7A4kD7hhdj85hC9IiqUfRLmLN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d11d7052-9dd8-4aab-19e2-08d8fa107915
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2021 21:59:52.8743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ef8plOUjW6e5xfTk5bWlvR74xCLq4YgjqlTwGICGGRUKZ+oO7uCK+bFp4SJAN/T+vftUBwB8IQsIXn/4bldTkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0510
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Leon Romanovsky <leon@kernel.org>
> Sent: Wednesday, April 7, 2021 5:45 AM
> > >
> > > BTW, you don't need to write { 0 }, the {} is enough.
> >
> > Thanks for the suggestion! I'll use {0} in v2.
>=20
> You missed the point, "{ 0 }" change to be "{}" without 0.

Got it. Will make the suggested change.

FWIW, {0} and { 0 } are still widely used, but it looks like
{} is indeed more preferred:

$ grep "=3D {};" drivers/net/  -nr  | wc -l
829

$ grep "=3D {0};" drivers/net/  -nr  | wc -l
708

$ grep "=3D {};" kernel/  -nr  | wc -l
29

$ grep "=3D {0};" kernel/  -nr  | wc -l
4
