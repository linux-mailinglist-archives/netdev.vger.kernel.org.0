Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F933DDFCE
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 21:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhHBTFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 15:05:13 -0400
Received: from mail-eopbgr140083.outbound.protection.outlook.com ([40.107.14.83]:5461
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229835AbhHBTFM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 15:05:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mi2E77XImTrvzCrjo2dunsHE2ztk6PaLOzhjXWhG4F8+payuF3XYKLtvzysJ1nwm45ExUfVARDNunCqD9yJCD7rcXVZ3XgvvB+g6d7cqyxxVGpXdUwqLqJ5mxFldNI5tehvccpBGgf1PAN3FcI8RiV3zvqg21FQ0/duwpI2OJCjc8iM1BoawQRvSqAC5nWbQfQyVhYV3lhMqpg06mMaTFt/dQPN8gM3tl9zzI/4G+Lpox8+cFDDlOW3ldF2xPc/SD0l3kQh0sYcXozJwi12ZL+fhPbhQ68H515ognSHBZc6+YHtRVoqcFzgoLmnz+Lbhkyfr0u3Hpkb6vySkUVor/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gvUzEh0sZr5frDn//sFmV/VLJ3hd8wE70p1INLwE7ng=;
 b=BxGts7NXu/m1N1dOVQtVfrQ/iiQTAnoceA9eaCOctzM/JASl+QGf2pWkVmrvmsH+6KXcHH22NrW1EwDYjGgMcy32LO0mQelihgw6eXNv+KaOkZWmfIQedH/N0XhNdKhy/L5GNzUwBjLBXLVmgu1i4kCb+0IerJYpS6sGxUmCYph3Kt8YJQ7aXCzg4L3AOE0hynXILuJq8H+6NyDkXB/QwG8riN0a62yreBSTUcXh4SSZ2KzintXdi+hCJTMEFvj+QvzwxIV9WYNKZhbQbz1zKVYO6jirDT4FVekdQlTk9YK+IdsEdqZ6M2OSjEihel9yEXahD6i0oSM7Kf7UnLJqCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gvUzEh0sZr5frDn//sFmV/VLJ3hd8wE70p1INLwE7ng=;
 b=pRtfBuoh+o7NK/Sy1RkmzzFnLFW83vyw9MC/svLqFzkAs0lKnKWxKrjUA24srOAAFUh0MUleY9y/BlACKtUPNNjOv32m1QUpJoF4o2q0Bv4df9/upOsxQ625mL+IqQ8CNimTa+/f3W4SoglROto5qXpnOI36eWoDillw++XmqlY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5293.eurprd04.prod.outlook.com (2603:10a6:803:5f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Mon, 2 Aug
 2021 19:05:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 19:05:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Arnd Bergmann <arnd@kernel.org>
CC:     Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>
Subject: Re: [PATCH] switchdev: add Kconfig dependencies for bridge
Thread-Topic: [PATCH] switchdev: add Kconfig dependencies for bridge
Thread-Index: AQHXh61yQBka7eM/OUS0Ww/tlViNv6tgZe6AgAAjW4CAAAnwgA==
Date:   Mon, 2 Aug 2021 19:05:00 +0000
Message-ID: <20210802190459.ruhfa23xcoqg2vj6@skbuf>
References: <20210802144813.1152762-1-arnd@kernel.org>
 <20210802162250.GA12345@corigine.com>
 <CAK8P3a0R1wvqNE=tGAZt0GPTZFQVw=0Y3AX0WCK4hMWewBc2qA@mail.gmail.com>
In-Reply-To: <CAK8P3a0R1wvqNE=tGAZt0GPTZFQVw=0Y3AX0WCK4hMWewBc2qA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77466d56-7698-4188-ce24-08d955e86d83
x-ms-traffictypediagnostic: VI1PR04MB5293:
x-microsoft-antispam-prvs: <VI1PR04MB529360D1DF455FE3C8AC6D54E0EF9@VI1PR04MB5293.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2xP8IirKSBC4bz5y/kzThNNjHbq7TOl4Aiex886XaZ2MFtiwct/BZ42VfEmbbmJggpzA3jysZuNzEn6UWekTm19u4g0p5raV0YAttVM0OoS0gFmsQfTTvwFKJHyf4kh2gUynnWsTytMinoR0i7Df/TTONS2cn6nRWfl5Ecp9d63kHpOgX165+Twzzn6dhvDaGjAQSiuJoL3DcqboSyy87y67UYdbT/CCRD7a0lvNNRllWwwNRjwKgJcJTziTU7e8FJUf4L68PiGZlCHoljmttHyvlcSu6xxcj8/inDYng7XrdgijaDi8SBoCK0kO7vaZhmDD4vwVBzGxECLxkm2aoZKmyfARDcqotidqVrA5MZQT39rXQI/i05cLFh52AL9fDDInO7fNyO2YjlhWSB5xY1fuV3vemi7q7A/N/5suyk22avJ6Kj8PFiBC1GXDHRCjLldvHp3fb49Fkki6R0KSqaK3w+F1WAGooaei3VKliW+kUcKVhWkYZ6LooNdye8CbERGI1fz7j+2EoHE0otg48ySXSIpfy9/vrWwbVzCXbH2aH+VymhNoTU8zKL3D3wc6A/ClvdlIHsm76cReW0MVIdi0amcKnQob/j4omafYmswgUK06PGdRFzmdHfxrVwScErYYamxMFWLaA/r67lQt0H+ZOfug/qsyFZ/3H8H6tI0T+gqtFCHttEV3oE1EoOmwpkgoqDLGJn3LyA/AibPqyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39860400002)(346002)(396003)(376002)(136003)(366004)(6486002)(26005)(8936002)(6506007)(186003)(316002)(33716001)(2906002)(54906003)(66556008)(64756008)(86362001)(1076003)(66946007)(7416002)(44832011)(66446008)(122000001)(83380400001)(6512007)(66476007)(9686003)(71200400001)(38100700002)(76116006)(478600001)(6916009)(91956017)(4326008)(8676002)(558084003)(38070700005)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?K4lIhwr3R3Fe+Tvdf6wBqsLrVKGQ0mxAxLiVGnFwsJPChg7yWYEugvltOxJp?=
 =?us-ascii?Q?3FUGyMjvsbYig84rSSTzSHm0GWK0/xhkb6/6QJEUtdd/7U0tAxvUJVqHqHlZ?=
 =?us-ascii?Q?BhrSojI4ODeBoqN5nmHTv+h3ncCx7mqFIMYg+dkZAckm/KF28Pb/bvYB3zKK?=
 =?us-ascii?Q?06/bGt/m7s8gSf1wfMp+8rLsqQ6aXapBCsnHGmTWGik21WRP1QSsvwHL9wYZ?=
 =?us-ascii?Q?hK6fY7h8CXUoc2KzJmIx8GM8V6jlrw37ojcuJkSVo5oGydu4UVD5DSaVW1l5?=
 =?us-ascii?Q?BWGCSBLJ8JTlzYG3yCYVnRMkkjvGAkpy5Ri1aWb/vGKzdj2ck/TtC8nmCWbz?=
 =?us-ascii?Q?gBq4UU4nw4+aRm1dpSQxJcloLll4xxJNhJVJsd9leuazxVL9gc3BOHI/ChKW?=
 =?us-ascii?Q?VHOYHgE/h6sK54k/4nRuNySMK/zB/wtL//vjb3Dfv5NWh6LhH6yC85+yI8Mi?=
 =?us-ascii?Q?eGPIumbSy7DN/oHlLO9ke65FdmruC3lmgl/htSMTQovJWoHf2LN9dXbBqsEE?=
 =?us-ascii?Q?k0gqvp1vUXWlfCVa2skANovonv7pFrfxBx9DlylSZsqEasM1HSTivYxmL934?=
 =?us-ascii?Q?8IeemUahAsmhvsB638rv4BiDUL/4uInZ8eEYi33zDvtzRvgSrLTTN5glUMdO?=
 =?us-ascii?Q?YDmR2DGTU009DzOV48cQOGn1Fn8RGK0X02j/kOb7OIjA+y4xM94i4e9Eec+q?=
 =?us-ascii?Q?uqGKRs/ilCtygrWdY246pOjtrcPoR88I8nvCtPDCNhQaM+IC7xCsKqUFgp9B?=
 =?us-ascii?Q?XYgKbLq5XaV0P/Vv1rIy2whBA7TY5BDsgQyzqJ/h8b/aK9IjCWhht/lb6mo0?=
 =?us-ascii?Q?OVyKnheoKFppmwcLtVrTRkY076J/sq0Jefz1/by9hqg+OrY/uIYzZyUtSUKh?=
 =?us-ascii?Q?ehG7EOOT/VOmX9xaYOzPKOvKcHCnmUeAnXA7j5PoX4V1XyWqMH4quJQrHY9+?=
 =?us-ascii?Q?CI3N2yhr/M/8oQ94bxh8kAnzAmqvKL/Is5uv8DNcj7ITnkiFFH5xPe5xi5IL?=
 =?us-ascii?Q?1MFJDnzZpEO6R8irnhKPBp8jjcPDxZl2wm+H64yG9i9X8kn5A2Raq8aUn6oD?=
 =?us-ascii?Q?gsLrbAS9DpGyHZqPOgD6DW5Rd4MNHVo7ZCoiwCoQgUcPQOXXCczBD7jylFQt?=
 =?us-ascii?Q?ai7I8E3gLjpsqzDA/OuuLO22uDY89xkgIjFUfT+3fmOikzGWo87G+qEOu5a3?=
 =?us-ascii?Q?LsxW48mu7Qd/wSEcITGYw6SbBKhlG3LHlTkHhHq7dyuPFzchpb1fKI6WfPke?=
 =?us-ascii?Q?iVQeEUNRZN4t2B6Paq9+fw0mNkMZtCvZcCc4b8xfEKmyZgJhx9MMniV9D/dN?=
 =?us-ascii?Q?8HZv1OhDluvX7Ylm3Ih4xnxt?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <01489F5268A86B43A3E39A9E6C0765F1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77466d56-7698-4188-ce24-08d955e86d83
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 19:05:00.6634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +ZCCE4UwwTeaNdMzT05ol2hezbkBKujAgrcFJcM62da04cS0w5uqyik0yDBBrQuJAC13nzLKb+vukrdFJg7hbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5293
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 08:29:25PM +0200, Arnd Bergmann wrote:
> If this looks correct to you, I can submit it as a standalone patch.

I think it's easiest I just ask you to provide a .config that triggers
actual build failures and we can go from there.=
