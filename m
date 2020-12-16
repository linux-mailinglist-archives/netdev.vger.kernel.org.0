Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964DB2DC704
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388235AbgLPTYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:24:41 -0500
Received: from mail-eopbgr150053.outbound.protection.outlook.com ([40.107.15.53]:54689
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726793AbgLPTYl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 14:24:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7THJ0SkLq6jsWfH3PgTa/0hRAzviabsLa5v6VTukbuzpIiDunmuQMkZjDT3X5mvlMzweL8PD9EwneZQ3gTG54ZmHMJ0vt+DU3t4E9azxO8ypk/ZzSFejhsva9BgbBVuvuFM/D060Ap+uER77l3C0q54wj7MODXNBV4l5jxkdxArdhleNeVLx5UCtHzJ75kmDP86s8ZMoTdW1twmY27hSTQb4qLb7o8CbIDkxstwZ9zCGkMR+rSq81to02ZYBVqZVfsPGFVJx60K7aaFFdVEgiwnnXGHX07lKxuGcjOmviDm9an1lfn+8UVJzAWi9G4CeC5SWLHCLLlmbKOwvkuLzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXovhGZRmc82T2G0PGK9ztPAhwOy+aiSYmDKJMeWV1M=;
 b=Kg+WZc4NEEXmBg4xMtY85A+BJ5d8AiKhSq3ELpvwnKue+odo0if395ctNbE9suzhAzd1EkDyua7BwlnvJyFi0ZGTzUXQQympXwbBYmXCbcp6Pr0YO+sCNOEQMiImZhKZx86sI9J377iW8bef9BP8xF4KutB8u+h1BD91pt+9otOH30owJrUmBrURjxo4jnsIGe1LhMBHVJI/xeOnRLGZAKuIKGVSb10ygtX+BxwxDFc4q49GzI4uynw9Q6IH7rHmYmyRbeM0w6HBBbTvIXKAOCcgrchc1pZFOjKSont5uTfyLS73YVv5hGraJ2ROse1+hfXAcYSzcqc1yb9RLWgEwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXovhGZRmc82T2G0PGK9ztPAhwOy+aiSYmDKJMeWV1M=;
 b=TpkjjeTcM7OAEra/S5xxUbBn/yC4o4A+XWlZ4aRB8UlwUv4Lwc6ufJdwI1ESUy+WYbdLCdGkBAFUHngKoudvPkGPN8jOFVZ64sIWN+tLQeM8Hfu5pW4rVJT2ikmelKzy7WEGf1NZdyGtzW0r3t4dGpzDOFiQIni0NJhmJlG/fTQ=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Wed, 16 Dec
 2020 19:23:53 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 19:23:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>
Subject: Re: [PATCH net-next 2/4] enetc: don't use macro magic for the
 readx_poll_timeout() callback
Thread-Topic: [PATCH net-next 2/4] enetc: don't use macro magic for the
 readx_poll_timeout() callback
Thread-Index: AQHW0yhblkGDTU2usESJSSfLKz7Y86n6G6gA
Date:   Wed, 16 Dec 2020 19:23:53 +0000
Message-ID: <20201216192352.5kbjxyhpwgmubm76@skbuf>
References: <20201215212200.30915-1-michael@walle.cc>
 <20201215212200.30915-3-michael@walle.cc>
In-Reply-To: <20201215212200.30915-3-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e79a0923-ea5b-49eb-12dd-08d8a1f8202a
x-ms-traffictypediagnostic: VE1PR04MB6637:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB66376BEDD4053FB1DCC06262E0C50@VE1PR04MB6637.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2T2yFttM6VdmqlfZCTRaQVokbKIn2xyex7jHYYRtB2YB5Ox5kN5Uy9YMyw2mc9qJJTxuzMbyp8YI3ZJE9Fvb6OKVa5NwrqxnufwD3aRVSLYtAWwDZkGSDy1oTTisoyaSZVk0qjrME6RF0+abL4UxwO9ts6E5ZovJAcnPrBKuIjfm11UAisV/W8KzCicsBX8n67XALD9CmBPiCYPQm+rOzBSbzJifdGUPt/ButYtbspZgKe0ZDpXiua26BBrBlV7Q7UXFO3JTN2ioc21Lmawa4X7QhS8Lzh+kKIDHGG0lVnM7Nu1MDCZR73ly+5r9qzvBT5cdtGD/2MVyEsgFSA8whw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(376002)(346002)(39860400002)(136003)(366004)(91956017)(86362001)(1076003)(76116006)(4744005)(478600001)(54906003)(2906002)(186003)(71200400001)(26005)(4326008)(5660300002)(6506007)(6486002)(33716001)(6916009)(316002)(44832011)(6512007)(8936002)(9686003)(66476007)(64756008)(66446008)(66946007)(66556008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Y/GD5vf/IVQmzQciAzEof3RQVxZ4i8gwiEQ8beT9ugMbNefeMbo6tWmL+rvW?=
 =?us-ascii?Q?5fYKXOgHJjgP9Yui1YkjcA7O/1eOmojbNP2fLBkUXcFRTY0hsfffhmKTSO9N?=
 =?us-ascii?Q?uXys8mHa9Ut4HIDou/loOdk/PkjlPmAGCfmbGHOtEg3Kq1gr8DLWSnrUJHog?=
 =?us-ascii?Q?mRwc5kOBffInXw9Jdt2OM2h8jxoTTm8Sd0bYgTdHVOY8OE4+lfQ6XizZtaXX?=
 =?us-ascii?Q?ycCarxY15uxT0soimuMAHsVhUosvTRZsZjD1TcPaFyBsuazdCpxv1KQkj1kP?=
 =?us-ascii?Q?6PsJ9LTGIotp0T7Q9ExROOHZrM+qAOmR++1akLhxkEJ9htfYZtZxrMF8AgTk?=
 =?us-ascii?Q?pa5On1LPaqirvJQuMyVaqolTRrkKLVVedrWeBD0WEoQaD+siNevbb0yo0fc/?=
 =?us-ascii?Q?50MCjoSRqoWXcsX2FRgHABntFNjVW9CKFaOPyPAXDMDyq/D75GtO+XtFiD/h?=
 =?us-ascii?Q?v1aPkHRal1dLzDROUV1X0l0R9SzZE/6ndz+s4XuKX7Jn5vfMo6ny4sD1/flS?=
 =?us-ascii?Q?IEUzz01mcGnxXpEpXXrZ/RnKHmFdsrPSP7tssvHla70FcBp++eh9GKKgJCgm?=
 =?us-ascii?Q?x3Hze2Icw1y2DniMEJqr7z3SJBzhJNbT537mh2mj3gq81IEeImwzuGKusQEf?=
 =?us-ascii?Q?gyN6UhnnFyFEhkyMrSpO3WZWOg39AIQTzwyN8bDPDObvwG/anxTsRUPctP3F?=
 =?us-ascii?Q?5cIWaQIRxhKTWkuGHsU5lQXMhrz5SY+1cT/VDDYGAqK1i2Vl1rCbZ15+AvSb?=
 =?us-ascii?Q?MXXljCn8Fcz/M9IJoSlJsabuTW92oOjGyAcp0/zqgtJ8V+B5Kfo4J6GK+5b5?=
 =?us-ascii?Q?9QRQ6FmNxd6+oPhgYc4LNYG4LBG46J9Rc1eEE1kHVmppgRa3I79+Vf2fKGCi?=
 =?us-ascii?Q?0RC/9AhIdRjn23GQkzSTU5PGmUMoArKx4nA5v4xzf+zNMeaw7hB7oQIp2kGE?=
 =?us-ascii?Q?t8L8SA15IhcsqOG8RLP0fSeK16XV7HJBGZMw6/DwqJK+hz3wk0KTDpycOF6S?=
 =?us-ascii?Q?cDu/?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6C776EAD5DA8864692279F44EC1D5607@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e79a0923-ea5b-49eb-12dd-08d8a1f8202a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 19:23:53.5155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OdNfvulMPS8dEjNuBjgNOjypKe2cDUu+VY4VOO+Wy7PKiywwaEGfkHljItvL8ge84q9UAfjgVwvgNXo0wrpguQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 10:21:58PM +0100, Michael Walle wrote:
> The macro enetc_mdio_rd_reg() is just used in that particular case and
> has a hardcoded parameter name "mdio_priv". Define a specific function
> to use for readx_poll_timeout() instead. Also drop the TIMEOUT macro
> since it is used just once.
>=20
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
