Return-Path: <netdev+bounces-8118-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EABB8722CAE
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:32:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61FF31C20D08
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C02379DE;
	Mon,  5 Jun 2023 16:32:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568812DBA0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 16:32:38 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2064.outbound.protection.outlook.com [40.107.102.64])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF71E67;
	Mon,  5 Jun 2023 09:32:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKwz00kMJ/i3D3qzJMo/SOYsCIEJH7/e7nj2VNh9dq5IfTIqTzepkn0VdLhnMWuyB/GudzF1YaDZdaWj0X9AoY8kfOT8AUvMZ1QDglLiE2jck5hCr6Q+IbyOZtVOBa+WEWP5J4dyG2An2XS0Q9i9gthU/gaLIE8ED+WF+5b7fWB8LiDFbN0DafOjSaMUE1aJIUvvcXTvru62ukaUayP6o214KBRbNtBs/oq+zLEMWTadC73btrM2kLf25CbAMdTKwqltHje82lB0fbEz38zh3sufivRVBwV6auzxusAKdBHLY5VUy1mB0ki28c+5aIpsMTCelZY8uhHHw70SkXn7Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yzt+/tl5O1l1cAu+cqjmVlijERW7+ZDx+Y5/BBy/lVk=;
 b=TqGdr304FYMHigiZ87JmrM8TDn+s7EeJBKvCxrsyVNYJ3iaifPBocWvaIjKV1ByX38gsYZMDhmUkf314Nx2HfxtcYwyw4ngb4dJ3oN+r4aedGwQMKsUyIcRB/tdEBLECrkzOAqCLp7FbUNa5ESGxqnCu5CbnBzi29zo9mHX8oQDw86B+fjNmkf0jm3NPmKtslMVgDxx4PKHpewXNRlrlK49Lf1j1GizzCYvpy3718zMVAjdy7NZ2fDMu4yINReUir44AIPoaeHqitQBNEAoMdEHcYNZd7EVsNuVoTlaKi3CebxsuvCcSJKLPvk9BAfftc9dwusVbdsLisuXWPwMCsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ooma.com; dmarc=pass action=none header.from=ooma.com;
 dkim=pass header.d=ooma.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ooma.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yzt+/tl5O1l1cAu+cqjmVlijERW7+ZDx+Y5/BBy/lVk=;
 b=cznH4WaiwTfk/v1nlPUkEpvbbnWsC5xf0x5nq+WYOtfCNxp4UEEvuH616pRzkitHmKp9ihKqJi1Hg2W10uID4Ka6CfyCbxnkOhLaZw5OOFC/4BhZcqVZxNqri8efonYcWb+puV3PeJL9G7meKGJKjWDX+1w9iX3nRG8tWlwEMAU=
Received: from BYAPR14MB2918.namprd14.prod.outlook.com (2603:10b6:a03:153::10)
 by DM6PR14MB4028.namprd14.prod.outlook.com (2603:10b6:5:210::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 16:32:03 +0000
Received: from BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::6e6d:b407:35b1:c64]) by BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::6e6d:b407:35b1:c64%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 16:32:03 +0000
From: Michal Smulski <michal.smulski@ooma.com>
To: Andrew Lunn <andrew@lunn.ch>, "msmulski2@gmail.com" <msmulski2@gmail.com>
CC: "f.fainelli@gmail.com" <f.fainelli@gmail.com>, "olteanv@gmail.com"
	<olteanv@gmail.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"linux@armlinux.org.uk" <linux@armlinux.org.uk>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "kabel@kernel.org" <kabel@kernel.org>,
	"ioana.ciornei@nxp.com" <ioana.ciornei@nxp.com>
Subject: RE: [PATCH net-next v7 0/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Thread-Topic: [PATCH net-next v7 0/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Thread-Index: AQHZl3AvqqiF1PFvr0iVWOgBaC61PK98J1QAgAA+mnA=
Date: Mon, 5 Jun 2023 16:32:03 +0000
Message-ID:
 <BYAPR14MB2918D3EBDA5120130D12BAB2E34DA@BYAPR14MB2918.namprd14.prod.outlook.com>
References: <20230605053954.4051-1-msmulski2@gmail.com>
 <b38bd01c-dbaa-440d-93ae-b1b772f8e8e1@lunn.ch>
In-Reply-To: <b38bd01c-dbaa-440d-93ae-b1b772f8e8e1@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ooma.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR14MB2918:EE_|DM6PR14MB4028:EE_
x-ms-office365-filtering-correlation-id: dfdc1caa-b01e-4934-38a7-08db65e26502
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 3L3CB4T+sL+l9Tj18HY+nMurGUrPcvJZHIzIzQ3Lzr38mmnWpUWOKfNOHaIqyddpLwwyybXGjMaaSSvnU14RTMnlB+2tdq8ihzhLIVPnlLoD4nze3kx4eczP//Rp6pl9SejBVVSo2PwvHeTnJtnqnuDjAJPgLaXhbDCayKLC26JRQdLl7Yguk3vzd9/lIPkN46sob4DF1OX7KGCu8uoidxv7A40PHYzRzjAvp3p0oiklsYgfQI+oFhEWJu1JSyH0Dg2obsbOMpbMFGJ4B4qSKL36A4j5c0uN+RVTmR3BvzD8SG5/lF4SlM60cmgO2oJgMJrdim2c8wO0WM7LoHVHVupmD2UDsn6HX6R8158NcrSN1Dx+AEuP/rjhxr6+354A9+XICnVDkF5hVt39/nblsXzPXUP7pja6aCAv9YifnIVyFiUi0tJirJ1cjcN+zjVRe4q5Ht2TmIIP3jZ91OKSLWI8MXuxwD6RLz85s+ggOIvdNDNGnESo83FoRFsc41kZjoydfEvQvSx9ZEFUaQDOIUk7BCPGAgHB9mZ9oO6k/yfddy5vF7ZcoD7Fk3AuLJADijoDn/ScNgm61a8knlNY3XGLULzPtJ65yGlfiFPai4yGDbR65nclHC6uaGxjF+XDhlKFwhWAy94SKsB5WVnaLg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR14MB2918.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(136003)(366004)(39850400004)(451199021)(41300700001)(316002)(7416002)(110136005)(54906003)(44832011)(122000001)(52536014)(5660300002)(2906002)(64756008)(66446008)(4326008)(66946007)(66556008)(66476007)(76116006)(8676002)(8936002)(478600001)(71200400001)(38070700005)(7696005)(86362001)(186003)(38100700002)(55016003)(53546011)(9686003)(33656002)(26005)(6506007)(83380400001)(138113003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?mCiH2NYR3ypdZbwedM3w1DrbL9w9FfcXivC1a/t3rbJBo+BQpvoPA6PLb2r/?=
 =?us-ascii?Q?/XDUOHvdXnLJEPGnopb7r8zuIGHWwEGBAvZvnVu3zxl8O/k2FhgUC2w9MSf4?=
 =?us-ascii?Q?txO8pbO5a+wR4DfxdGH3SVgO+0J3fBO9LiElGCal5e2HRxitTenNgXBYDDOL?=
 =?us-ascii?Q?9CWd0qXF+S1wQEP9/9VfCfI7GDGUn69eSMk6I0uvmbTYVFnnIyk8FoRM2C6M?=
 =?us-ascii?Q?idOt6BupOI09pjeGZX+iDRKVSWE/0ecalRTm6qKpVEswNNWGaQCY/gQPhrvU?=
 =?us-ascii?Q?uZ8wswHF4C3Iwq2uUQe9gsLbi7xd3YoX7bzBiDgFep6ex/k7rfz6CXz6ml4/?=
 =?us-ascii?Q?376OyhOzgz5eQZVybE61RhcD6WXOmMYzBpRSwTl7sjTA5CYlENGetva13//T?=
 =?us-ascii?Q?a+AY2pwLnTV2q0d/u1S3f2DNjf0xwJxY1UIVQvvAPlA8XR5Oa+i52Pix+qyR?=
 =?us-ascii?Q?lD+7wU4yvuW5Ngbk6OqcbACUPV2geUd2n2mytH5Ci2Ay5wC9BHAFBLknF5Np?=
 =?us-ascii?Q?zcDdljzIsNvrmeuYhQ1ikoOKbYYJCWSkW6R3ApjuD9we3b3U9t/n+AwZkMO3?=
 =?us-ascii?Q?8twDondeNuSz3Sgu/zZA7Rda1m7uJKTpvyrmJSq1Zq3/PPz6CF+Otgea1jMw?=
 =?us-ascii?Q?25L4u3hKleqIG8niQsntzodfQN85xVI9YOZ8oy6HceaR+E3Dvs1/u0pIR2+g?=
 =?us-ascii?Q?qFi01D+71+avm4nOXIoKRcO4l2tJTaxspZPJ1UxnW9riYg2tChDVFiA6JPv1?=
 =?us-ascii?Q?fR2CdrA0pcQD952GEK3zDjFzeVOZmlW6+3MhFhWg9CNyq5jUW2vQ9jVLW8A5?=
 =?us-ascii?Q?Hh05jssV+o4dJMfP86F6gQZ8SSM8dIxm2R3PEWdbrplsvv+IWoxaGsRK4zqE?=
 =?us-ascii?Q?gftg2+W/GmcOW+FFmhzoo8Cm+gvBWLNGmM2JgC4qp0TSNb1hGfTzlYoIWXB9?=
 =?us-ascii?Q?/Nruj7ztSP+6PWlAmj4OiuLootjha/weAsGmBrpyB4OnyJRocxhzUft7Fc+F?=
 =?us-ascii?Q?kVXlnPikhqK7OLLljsM3C1t5xY7+Rv1+3/gh/gBe1XDb9J7d5Fuc/YqwtCqg?=
 =?us-ascii?Q?gA587Psqo+NaacnPqBMp/cV9utr4To+fmC3qXgcI9rC+u7F+4MQCl5bhAGVL?=
 =?us-ascii?Q?ZwGVrG5cYBFRmf1QReDJxte6XwSsfrcjE2Lc+jsS4W7g0QP4Ettm+UFmJhkr?=
 =?us-ascii?Q?gvJowuUOyowtsnqTgXgfIKaQvNgRlAPdK/Ji3o+TU2GbjUeu41uiiJ79lMeJ?=
 =?us-ascii?Q?T0eqhIgaUhrMiW17/vKCUTQtx0RxlJNmHIeboZO7763aT8e5kDE+VsB61Efh?=
 =?us-ascii?Q?Y8Pss8v6x8xxKmEGNwbkuippXet2sJPwLsUUmJQgeuYFDK1e8vJlgF3JFHb3?=
 =?us-ascii?Q?stOqYuXalnk6yU5Wey5JncfTEq1jPM+0qlnx7DuZqt1C9h1Hr1YXD24lYBSC?=
 =?us-ascii?Q?Dti8/7X3u6IV4Z5q+bm+PLqM05Gr1p1SDWKhz3UL6ttavG7MzRYAUm56OW7Q?=
 =?us-ascii?Q?EMOuq2ZhbIQND4Edlbsqnh3w8dAO1Z+ssuXOhBFA0oTrHsyU6p+IZCV8Ya4I?=
 =?us-ascii?Q?ZrQ1SFd8PioL4EuBsgqNz5KrN4QQvD4nunZc8Dxn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ooma.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR14MB2918.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfdc1caa-b01e-4934-38a7-08db65e26502
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 16:32:03.4484
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2d44ad66-e31e-435e-aaf4-fc407c81e93b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7iFWE8bgcnh5CkvtvdjIFhUADa7w8AV1gLRPm/45tr9ohBKHgOliXBZOjOgXqX9EZd8pyGcJlMyd8f3Apv3ULA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR14MB4028
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Andrew,

I will remove this line and resend v7. This was a mistake on my part. Howev=
er, could you clarify on what is the best way to let reviewers know what ch=
anged between different version of the same patch? It seemed to me that cha=
nglist should not be part of the git commit message and hence I decided to =
add 'cover-letter' email for each new version of the patch so that it would=
 not be part of the applied patch to net-next git repo (but it would also b=
e easy to match changelist email with patch email to people reviewing lates=
t patch)

Thank you,
Michal

-----Original Message-----
From: Andrew Lunn <andrew@lunn.ch>=20
Sent: Monday, June 5, 2023 5:42 AM
To: msmulski2@gmail.com
Cc: f.fainelli@gmail.com; olteanv@gmail.com; davem@davemloft.net; edumazet@=
google.com; kuba@kernel.org; pabeni@redhat.com; linux@armlinux.org.uk; netd=
ev@vger.kernel.org; linux-kernel@vger.kernel.org; simon.horman@corigine.com=
; kabel@kernel.org; ioana.ciornei@nxp.com; Michal Smulski <michal.smulski@o=
oma.com>
Subject: Re: [PATCH net-next v7 0/1] net: dsa: mv88e6xxx: implement USXGMII=
 mode for mv88e6393x

CAUTION: This email is originated from outside of the organization. Do not =
click links or open attachments unless you recognize the sender and know th=
e content is safe.


On Sun, Jun 04, 2023 at 10:39:53PM -0700, msmulski2@gmail.com wrote:
> From: Michal Smulski <michal.smulski@ooma.com>
>
> Changelist:
> * do not enable USXGMII for 6361 chips
> * track state->an_complete with state->link
>
> *** BLURB HERE ***

Hi Michal

Please remember to remove the *** BLURB HERE ***. What often happens is tha=
t a branch is created for a patchset, and then the branch is merged and the=
 content of patch 0/X is used as the merge commit message. So this can end =
up in the git history.

For a single patch, you are not required to have a patch 0/X.

         Andrew

