Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2701D3E45A4
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 14:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234346AbhHIMdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 08:33:04 -0400
Received: from mail-eopbgr10084.outbound.protection.outlook.com ([40.107.1.84]:34379
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233528AbhHIMdD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 08:33:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FW1Vo4lDl6tfgeS+g8njXW6UqPYO983J4RrWLjVdpw26fwQmVd/x2+dRhlOf1rLDHqu3XaMva07uZQ5WEGK97DHKxFANPvR2gFE1dzdyEhXXipus3w4rJUp3hgUYvWIiTY+teVRladzeopMhupBb58mmmjtoCmNYphAwq4J4nz7HbGrQOqk1MT9n3ivfgdZNMfn4Jzohz7YvMZP+U/w41qI5f4ozxhqJr9MHjpnwpEHLWuaw8Pw6INmObOXipojpAgk5WzPDskFdBCAwscSeiBeH1xn66CQMihIsOPuvmOiOPwRFKFo9zPLeqgXGS7+1Obhx7RCuzRoasVoyeoGkDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BNwtyyTsqJMA6wQJqf2EhbzDNo9/il/W7vMrwloXBNo=;
 b=c0eoPLPbTmW+7QuUPeb7mzwdpEPhUuMEmIU1uGenzxfJFAxNm5Xp5LEAsZwtxK1o5ZWu9ewHoYEvuOets2mwzZj/f9SF6TFUqzhpfu0qO/asdfzLx7JzWKu9/dWt0SnkczXNrbaJdggUDh2T4KTZcMnzzpy5DxS4D5ACvU+Qa7C4Uk7SLzj5rXWwN2KiO1meKbsClGfEKJglD+GL1DNpfMfMHRWRuy93H6L/LD/3/9Jbl/8usJqT0SI/nj5Bc+k0p9edf+s4cFjRqDYGtMXwmQgs5VglodTO334PMTSAku3bSI6/JLbT28C5RYL5Gabc8XoSpDNMrIFNh986VLhVuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BNwtyyTsqJMA6wQJqf2EhbzDNo9/il/W7vMrwloXBNo=;
 b=FobI3sqmZnhbqmKNJCLdJjRcUOkDqtdASa5Q4qTfAwAffpLG4eTgbrJ6ltcYnfoPamT4zI/KEPJyCAIiPaTjS0B4QjKjiz3a/BRanlBnwnpAdKsPFnwQTedpwVamaOFtLq/MnG9lC4mDnzBbbIMXfM+03Bv0JP3/yXE3h4qwgEg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6511.eurprd04.prod.outlook.com (2603:10a6:803:11f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Mon, 9 Aug
 2021 12:32:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 12:32:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>, Roopa Prabhu <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com" 
        <syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com>
Subject: Re: [PATCH net] net: bridge: validate the NUD_PERMANENT bit when
 adding an extern_learn FDB entry
Thread-Topic: [PATCH net] net: bridge: validate the NUD_PERMANENT bit when
 adding an extern_learn FDB entry
Thread-Index: AQHXhyttiQTxBmfp1EqsG/8ivlTylqtrInkAgAAEdgA=
Date:   Mon, 9 Aug 2021 12:32:39 +0000
Message-ID: <20210809123238.pi26xjxraaczemne@skbuf>
References: <20210801231730.7493-1-vladimir.oltean@nxp.com>
 <YREcqAdU+6IpT0+w@shredder>
In-Reply-To: <YREcqAdU+6IpT0+w@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 657f58dd-3f92-46de-6b22-08d95b31c6a8
x-ms-traffictypediagnostic: VE1PR04MB6511:
x-microsoft-antispam-prvs: <VE1PR04MB65118B76D1230C2690A7C0BEE0F69@VE1PR04MB6511.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:632;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TwkdodKMZj1Ny77t6T6DybtT3YPxngoydAKt9AhtklC8Fqzblc4MJ9XVGz+nssi6d3zSu5iboWTVhOUt9JlW7v5bJlIi9adMBeCQnNdGEA8+QGL1ZGgyAroGE1LjCxJ9zGFqPHe6oAjuPzQDO0t90vGPHcUx5i+GhnyJKhKNzJgoWeVeMhObg8U5W4IXhZFhJaojf1pzQZ8jrxE+jPzyjccPv7SXtH44Zl+JhNKXjMslm/eUQ6rD6h3szxfRQ5YOpUqAT4UuGZ937+hYvqOBECjlAOZcEDg78ZOMxpLcTY6FkGvI3J64a8D0rSBPG91V/ijs/+Pd1IeEEb1ziQsOQcqtV5J28hDOgqPz5TOLouT3u9CICuHl6RPUWSUu9p4EzQ4fGNxsjwZNk7/Fqrd2o+lYB8XNqEkx6AnsML85SX+qzxEe5tTr+teKFdfdKf2drQl9oDH89dqKlSuNOZjQL/T3vBbZMDoC5ONUOy5BP08Qx3Ilhd2oB9SwKA/4Zosa3UxwT5/r9YDYcYNhbLcSAfaDI0qB1nlbtmoXYeg20kh+9lk7iDvNe2pnjYv/xNZEGqq84g92Lw0o+mUqs28waqMZ/s8/U62rAYtNtQ+jlmqPyNsBXBOmX4tdLBw5EXRlA2CKUPfQJlCTw6TI/s+zyViN6JPVOQyaM1fAAW+HlCmg6sLByl54Bz20jMuHY9yfLcna9iwHQ4PFcCcBtlswBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(33716001)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(1076003)(8936002)(26005)(5660300002)(6512007)(44832011)(4744005)(6506007)(86362001)(9686003)(8676002)(2906002)(6486002)(71200400001)(38100700002)(186003)(7416002)(83380400001)(508600001)(15650500001)(316002)(4326008)(54906003)(6916009)(38070700005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Uc11O+kjVpTDW+e37l8+xT7wrAAuLuX3ip+e2agKbyHzRif0Zv++fzRWpKZq?=
 =?us-ascii?Q?V+XFxA1t5VxGtNctOpBCfO8kFS6lEfO1471mwFH+BKhZ/jjoGgFlsWFSoIr7?=
 =?us-ascii?Q?2108jN8kSZ9B+XUsYW+/rjeGlQ/FBJqoMX5COt/mDRa4witj53D6/lyqlT5r?=
 =?us-ascii?Q?gq/q7pb0zKey1uQtkyUfXb6J6f7h32p9iOaZED/fc0FJzCXiCWLWhQMEPHAZ?=
 =?us-ascii?Q?Ox8xURbYlbqGUPxMTGzgVVJPxmDm2LX4EXVcyN9mPQMfS1urL3hIlMPWGXwN?=
 =?us-ascii?Q?+E3YEF/CiW23kaMot5P9JJFxJjccO/Jl43zXnIZdOA+/Z758DHqe+CWi82dk?=
 =?us-ascii?Q?I/FDOJVpiMdm30Z9r2KgBI4+kcsTeLEKEZk8ioOPvbP3a7raJbAxP9RNzDSj?=
 =?us-ascii?Q?QvkpSWG3AwF9/wXyIPD84EcO2LAKgLBOUwD5igh1iX0bPb0Fwh9fWipf1Sjp?=
 =?us-ascii?Q?tpK142R3TLi8rDQJG64cltNHyLoI9gVVveoHaXoaryl9u8zw1Z86IWoscIJG?=
 =?us-ascii?Q?pODgauLaBqsFVzS8HdhhGK1CiaMSNEDrAUdzUDjrLVATOKILKUwThhDEWL6M?=
 =?us-ascii?Q?7S746nnWh3z18hlAlPMTl1Za55Y42w8UmXhT3CVfamkQIJ7E4zCv2wDVWgcJ?=
 =?us-ascii?Q?gIMpezIlXZm+Yd15hE2e0qDvhDNVpzONhmm6AHB9RWp2sg62QCsPtkHEjUVl?=
 =?us-ascii?Q?hLorrHFewArh1QZZw3VdktrHO2e2r97fRHZGT0Jfap22QS4Dwb5ayOEdkAMf?=
 =?us-ascii?Q?o1GqCOQ6nZ9OWy+hTzNEXc2xo2suK143Hd9ivuXZB+SWO6ZHkiJbIB6y7182?=
 =?us-ascii?Q?85XhCn/ggEThOn86Ox3ZrufHqgCuLvbVfJYuIKrc1+asNGsWN4r7G1rxnip+?=
 =?us-ascii?Q?QvV62m0a5rDQHKuwVj9zKt35X+bALot0Sqsp7qNyuxoDxDiKuqPuNmlNfIA4?=
 =?us-ascii?Q?+HfLsknD84gKggPETXZwt+7RP85JMW+kMcWYJeUav7LvBegIIx52LvZ8HjHU?=
 =?us-ascii?Q?uqtmBzT5Ygp0N6CGdymgrwljrwOMQpxWIsGV8tyq+5Xc9J2INIGP0cLF8Hor?=
 =?us-ascii?Q?TJkgvuW8yQLkuNf3f/dFiI7+nFcWM51Hl1J8hSiYJ0aIEiI9fLYJXkevOftR?=
 =?us-ascii?Q?yz0ejK9FHIcOwp/1KitQ/4sIKMy+3xZNXQdjpZFqoniDcgeoza0OFaRq90ZN?=
 =?us-ascii?Q?dPnB7fnsNe53sRAwkDj8bIGupCJqs29+r1RC6M8+6uQkKffbariqdqpUJqyo?=
 =?us-ascii?Q?sPt9GL+UmhxWUcse0IyPHsxPOPX1mQ2cpcZI+91ubXzj18vO2k+dg/p1jI7D?=
 =?us-ascii?Q?ds9HJl2yIaysZRV/nSYA7nt9?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D3D05FF3A807554085480A6B8D572C04@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 657f58dd-3f92-46de-6b22-08d95b31c6a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2021 12:32:39.2937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FqfEBvUOAXzVGsLH1x2zqANYeXVdJzdjFoGYIici37nJQah+7wX1TxM5AxL94ZFj6BKeLHsevpnhJzZCNVJyfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 03:16:40PM +0300, Ido Schimmel wrote:
> On Mon, Aug 02, 2021 at 02:17:30AM +0300, Vladimir Oltean wrote:
> > diff --git a/net/bridge/br.c b/net/bridge/br.c
> > index ef743f94254d..bbab9984f24e 100644
> > --- a/net/bridge/br.c
> > +++ b/net/bridge/br.c
> > @@ -166,7 +166,8 @@ static int br_switchdev_event(struct notifier_block=
 *unused,
> >  	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
> >  		fdb_info =3D ptr;
> >  		err =3D br_fdb_external_learn_add(br, p, fdb_info->addr,
> > -						fdb_info->vid, false);
> > +						fdb_info->vid,
> > +						fdb_info->is_local, false);
>=20
> When 'is_local' was added in commit 2c4eca3ef716 ("net: bridge:
> switchdev: include local flag in FDB notifications") it was not
> initialized in all the call sites that emit
> 'SWITCHDEV_FDB_ADD_TO_BRIDGE' notification, so it can contain garbage.

Thanks for the report, I'll send a patch which adds a:

	memset(&info, 0, sizeof(info));

to all SWITCHDEV_FDB_*_TO_BRIDGE call sites.=
