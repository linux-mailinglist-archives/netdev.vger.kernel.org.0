Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871653E5801
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 12:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239740AbhHJKJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 06:09:54 -0400
Received: from mail-db8eur05on2065.outbound.protection.outlook.com ([40.107.20.65]:54753
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239738AbhHJKJx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 06:09:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O00QV8mHjQYPdOytF0L4vFPW3QTjwIZff7+aFS2IOmElLBkU3Z9DGS7N57A7s8Sv28Mto3VKkqrN45g6sLJNzIGtszThY80hPqAjR75T0geMlY/5SnoFgriIa0mWYLo33WqO7SPWj24Xw/e2mXBdbZ3F8YlEkRr7RCykN9N6NKjsVbUCh7dInDaDh4N4XXzzKVVAx47iFheV/tagzli3nYzlhkLherzWXqAPspD33KZM1w9Zfxx7z9AGoYFC4leiYYxWAx+dSk5gyz4UPZ+FbsktIBv7uLmLL2tCC5EMr5nFBP90wiTym07lp6I90n1Lkt8Usve4vv6+2cQTKT6/XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XcYlSFKFIgpm8tcAstvWlJ5bLgqUHukHY6Vh4zxSntM=;
 b=ioU+ZWYDop4Wfidb4OB+8dV91olnNPBB8OnuimDTV2TT448LyY+hjGRiYgRomvIDvdYXsKzaN80glYGBxTVECCJNgGh+BCuwW0AyBOi5Cj1hdIFx0QaqwBkDw9SbAHl5Zsr3dWzUGB3eDXmQTRK2PeneE5BrYduf2WoWL36kFXrgZfCh4mRiiBBUUhDhGemSvxS+ZmLzkWkzdteIuyS74Rft+I2QPXs8sdL7cKBZNRRqyNlQkyMIdMv/oO+DNJ2+x05HTm9NcZQ4PGxKZ6heJhJfyGLNcLWnOlxb85WHDEliulY8jfHEBBulP3SI07jSx4EtgH9LK/aUU6Qt9dyDQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XcYlSFKFIgpm8tcAstvWlJ5bLgqUHukHY6Vh4zxSntM=;
 b=LDiwurYDNvT1uBMVk+m8OU3Crao2sfd10bs1dvKwBVW53bNy3dduaVq9Fyy7GM/6vhfEHcB95Hu5PBhOJ4JhZamDE/EcW+WYzWxTpvjqQWbZLPtATG23DstTqxaqSaOkEcljs0KmVMVl2lqigVehf+Y85ePzoR1rZIwcdr49np0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7471.eurprd04.prod.outlook.com (2603:10a6:800:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Tue, 10 Aug
 2021 10:09:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 10:09:29 +0000
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
Thread-Index: AQHXhyttiQTxBmfp1EqsG/8ivlTylqtrInkAgAA/5YCAAPY2AIAAOLAA
Date:   Tue, 10 Aug 2021 10:09:29 +0000
Message-ID: <20210810100928.uk7dfstrnts2may4@skbuf>
References: <20210801231730.7493-1-vladimir.oltean@nxp.com>
 <YREcqAdU+6IpT0+w@shredder> <20210809160521.audhnv7o2tugwtmp@skbuf>
 <YRIgynudgTsOpe5q@shredder>
In-Reply-To: <YRIgynudgTsOpe5q@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37d1dba3-76da-4fa3-8b5e-08d95be6f127
x-ms-traffictypediagnostic: VE1PR04MB7471:
x-microsoft-antispam-prvs: <VE1PR04MB74714F70BD09F766F45844E0E0F79@VE1PR04MB7471.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z3OovRDqWDNQQ9RrGv10MGXbxvNLcOIc8IgiibF8Mc1VKoqC3T66aw8zNHc7eOu5/Hq09pIlhNBDndkK/OsIh1+4VPS12VjlRLIbAn6tzXGZL63XRmHePqplOdGbG3ZSAOZkG3KZGGenjjkjha2RuT9e2FbGI/mJfRoZ2JhpdzVvF9gpYA6Xh6CLRx4b518l+Qllh78Xz/9gH6Jxzf8+mWZ9T7VT9yIC0f7iaH7sHtiP/OUj4cLWHkWlHB/Gk8jkiG/slkZdKcegdssVR7O9zR9MF5yDkWhk0Vhh4Tgnre3gVsfUsufdWGfGUsMwYm9Amuc30ySUwA/ZMDPmFNwqvkIdnvFyyzIfTSyvHmppojtXxzP0Ui2yP1Q0zme0dCsn7sRJ//V6wHFOTeh9/IELbEg84UnAv5PkRUYOVgXDzvP6iFgKZRm5N8AIO6nhCiDnDSOvIj/cThuS6FlLEV72G4HXVf05PydeYKrJ1u2Z7+KV9YYy9O639WKnC8NuEvk2qDfifXDxhkOdY1KUZQ1xrjDUU7r977VzsIUsDeevSHWFmM2fPteurxf1Ec4ouU2i/mK2Z5M4R++4piFDDw6JHPnfdWkHMnjA+hRW8ih7qxzNqOumLrA+v0RyLTP+FOw3L/3vY3muGzxpQBldttOj+AqPz1EZpPRuNtHALiLk8Fu5HTVBcN1gZIdmELV50RhKWMD1Y7JvuDFhjnL2SKy7FA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(8676002)(76116006)(54906003)(316002)(186003)(5660300002)(64756008)(91956017)(38100700002)(33716001)(66446008)(6506007)(6512007)(7416002)(4326008)(66556008)(8936002)(122000001)(66476007)(66946007)(44832011)(6916009)(71200400001)(83380400001)(9686003)(6486002)(2906002)(478600001)(38070700005)(1076003)(15650500001)(86362001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9/VIlkxu9qgtkAtQpTRmN5VWRthO2mX6gr87DCBtFDb8duPvufA7yV27qqPK?=
 =?us-ascii?Q?To/BWq+HNWitWGFS1jU9uRIJ72VQbiLiRnnOpprHc6iti6AcDlCA9e4VUabb?=
 =?us-ascii?Q?+j1up6wOW9GtL99k03sWKEEr99YzeHgKoELmb/PgQ6nFn4IlOKVrv/76c/Jy?=
 =?us-ascii?Q?0hFPPCyuUY/GqtGjdbPsowQzbHBTUf4ZsINLnJtAPxSEk6TN6XvoJNjkxaS6?=
 =?us-ascii?Q?fXshwDThmKpnIni7eXNXALB1I0Jb2OdmdqrcXl+N0tDxrR5XmLfiljU9fjZW?=
 =?us-ascii?Q?t3rCuX9jKnzZxKWoFKl0DIeJOPxURzIiOT9YCaBw1eScHYDr0ESaEou+dsAp?=
 =?us-ascii?Q?R5R2bwTjGWLS0nezJTE9ypcmTOnWSNuhAbZ0emxpcSrYHYWXw56TkSHqiAjB?=
 =?us-ascii?Q?gn9bdwRLWFCOiROWm1zOmQMgTNfN7t2C2sGi/yJVvBuV1StAO1K5cCM4cPZq?=
 =?us-ascii?Q?ELZ10+puMFBZFXEUTZEomg050fP9eTT8gO0tdk5y9KFby4Qb5jxTNg4eWcx2?=
 =?us-ascii?Q?9q/qGWJNizIZgq7dFb2CAldq0cccVButIguGxjul8/qlcaLOR6vKUXaqgkcU?=
 =?us-ascii?Q?C88uq3sVE64+AF3jUhR/tYehWm+sHo0qPN8ses5wzMfwKZqdqlpXhf496Utd?=
 =?us-ascii?Q?R4UqkeTD0lFu53Q13tlKyJyK+EHwiKlVLNxaVNARdfWXELPIHwzrTyp70X6Q?=
 =?us-ascii?Q?H0w9txGbPwyKmSeWF7QNqLFN7VJPJDz+wmkqDrlYvc9MUswMn3M+RsSuKOxU?=
 =?us-ascii?Q?Q9fa+UYYb+O631ZYgGaFQyGHUqM+X4xyOPn463hPK0J6hjAssF8tQuQ8Mmu2?=
 =?us-ascii?Q?DvbmXaA0i3YuYy/+a8JbLOnfhLy+xXfAttFzVfldc2VXApLrrvEjNpI2wPuK?=
 =?us-ascii?Q?7Xqa8692sW0eo8ZkyNdbFuqRBAv4SD9N/UEv2sZRX/9svKgVAQ0p6BQcUJfB?=
 =?us-ascii?Q?au3lx/+08cJ7eqRkYMO93fMEz1dgvLjUMRL/ATe1h+kaGaovwnefsgxwcUgE?=
 =?us-ascii?Q?IC1HxPE7hjyL7nmiXcJUOCcwIpmvCh8X+V0oMY9FJN03CdVexAGsA1nE9GM+?=
 =?us-ascii?Q?nOWpuc822hPISK9vkyTEYEaQaibnCipR4C5ElrcQfSWwukXbdGJmPAykSfmO?=
 =?us-ascii?Q?hsCBy45keXvnXoRRGyotdtaLj4kfZNQk88H7ngFgWnknoCmB8fjrUQ6Ij01C?=
 =?us-ascii?Q?Ifp0R25hbtG0MCpd7AfiLLsH1FCRXq7xxj+3vTCnoBhR6+bTHQWnXT/IqMKI?=
 =?us-ascii?Q?nqyCWgxRd3m4Mx2i9OIWOLxU1fzBo32z49Zz7/uI50eNwxyfZ78rhAM/HX+c?=
 =?us-ascii?Q?P1C3G1Tzw0mRCx/FvmBqD7JR?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CE3ADE0C5E28374FA60AE0C4B933989B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37d1dba3-76da-4fa3-8b5e-08d95be6f127
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 10:09:29.5102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NrOpFY7m6chsWp1ruVhqA1poSZc7H8RhpXIkSMLVA9cTrFxo98VkecVUvPuCjc3WS+zl+DIkcb/Jk3mEDzIYAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7471
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 09:46:34AM +0300, Ido Schimmel wrote:
> On Mon, Aug 09, 2021 at 04:05:22PM +0000, Vladimir Oltean wrote:
> > On Mon, Aug 09, 2021 at 03:16:40PM +0300, Ido Schimmel wrote:
> > > I have at least once selftest where I forgot the 'static' keyword:
> > >
> > > bridge fdb add de:ad:be:ef:13:37 dev $swp1 master extern_learn vlan 1
> > >
> > > This patch breaks the test when run against both the kernel and hardw=
are
> > > data paths. I don't mind patching these tests, but we might get more
> > > reports in the future.
> >=20
> > Is it the 'static' keyword that you forgot, or 'dynamic'? The
> > tools/testing/selftests/net/forwarding/bridge_vlan_aware.sh selftest
> > looks to me like it's testing the behavior of an FDB entry which should
> > roam, and which without the extern_learn flag would be ageable.
>=20
> static - no aging, no roaming
> dynamic - aging, roaming
> extern_learn - no aging, roaming
>=20
> So these combinations do not make any sense and the kernel will ignore
> static/dynamic when extern_learn is specified. It's needed to work
> around iproute2 behavior of "assume permanent"

Since NTF_EXT_LEARNED is part of ndm->ndm_flags and NUD_REACHABLE/NUD_NOARP
are part of ndm->ndm_state, it is not at all clear to me that 'extern_learn=
'
belongs to the same class of bridge neighbor attributes as 'static'/'dynami=
c',
and that it is invalid to have the full degree of freedom. If it isn't,
shouldn't the kernel validate that, instead of just ignoring the ndm->ndm_s=
tate?
If it's too late to validate, shouldn't we at least document somewhere
that the ndm_state is ignored in the presence of ndm_flags & NTF_EXT_LEARNE=
D?
It is user API after all, easter eggs like this aren't very enjoyable.=
