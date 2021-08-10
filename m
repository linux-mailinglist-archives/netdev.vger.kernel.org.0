Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3D83E5875
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 12:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239872AbhHJKjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 06:39:06 -0400
Received: from mail-eopbgr70084.outbound.protection.outlook.com ([40.107.7.84]:21377
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238566AbhHJKjG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 06:39:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LE7dtP0dgU6Y5Vjjn7D5yny3JoxV8YqPICjFBDI6wpQU578T0g+ErVS2EsKDACJjPSffQv4yrJdbMHBTljQcGzwt1+tsZ7rKSrCM6CXAERE60ePnjZKQrE2Bx0EguHDNWYQp7tqj/3shkBUp3aLfqeB0eKZNQQudlYWNwKJ1nuV8slhjfhkqSAWBKUBT+ga4qCdmPjF0rtp9CIozCKynlKXGu6sUU7vLs0LhNAxhJDL7eoP/UbAEyL+NGw80m/Wp2tNnKz6ZOcJET/jqUi9YauyYK58dp1F1xPK0iuEQPSwBCIyGYbH0thVsw4+8F7aNvwk3ByUjP6qvPWubkOVwfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NGtLr/xfPNKdQQi8cLqJEqaFspc5r8oK4Wf/m2YcrSs=;
 b=eXHMlBQ1lcZztGV6EJYntS86be75d96GSjndlq0PLBsJBMmeyMIZg6dtdkN17PMhrBCudVWSlJ+7vFmnorOKNo7LNzxEiykhfCdTBMsP+XSI8WLjsleE4ANn3NHftjlwEamyvcnoPHx/VW576YVHDxlCBXICBuRajxbJikDSl1rbllhz+hPOKsHu4NDB+994kaEU/I+GidhtZCugvVlAacMcMhlycoV3z8DZfTe/0lQuLl7Md75OrT9KOF99Qssg+iQhqOtFSAlcdMckJ1BH9LOS0eKhz+s14rKfiPvpJIoE6CNEe+FHlw4/0S5kuOVf2cqKTK07rSJFj9/FurDXcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NGtLr/xfPNKdQQi8cLqJEqaFspc5r8oK4Wf/m2YcrSs=;
 b=e/+Yej2JBJhFXCj1lt1W23NhlW5Gjs7ZnubKiV3TX38M8EVVKYFuqRpKlEaFiel8ITTh9kDuV3zHdukJJrv8aSN6WrFtiyABG4pboYxT/YhIcWBRKTPFkoKqjUpItceUhYC0g+0zibXEue14MUtEOTJFcIDcKwCsIVU/mRqe9SU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6941.eurprd04.prod.outlook.com (2603:10a6:803:12e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Tue, 10 Aug
 2021 10:38:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 10:38:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     Ido Schimmel <idosch@idosch.org>,
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
Thread-Index: AQHXhyttiQTxBmfp1EqsG/8ivlTylqtrInkAgAA/5YCAAPY2AIAAOLAAgAABsgCAAAZ3AA==
Date:   Tue, 10 Aug 2021 10:38:41 +0000
Message-ID: <20210810103840.oequsjeg5be2jkkz@skbuf>
References: <20210801231730.7493-1-vladimir.oltean@nxp.com>
 <YREcqAdU+6IpT0+w@shredder> <20210809160521.audhnv7o2tugwtmp@skbuf>
 <YRIgynudgTsOpe5q@shredder> <20210810100928.uk7dfstrnts2may4@skbuf>
 <c6d91ec7-6081-85d0-9bc8-569838d8f9a4@nvidia.com>
In-Reply-To: <c6d91ec7-6081-85d0-9bc8-569838d8f9a4@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41f3906f-3300-43dc-bdb0-08d95beb0596
x-ms-traffictypediagnostic: VI1PR04MB6941:
x-microsoft-antispam-prvs: <VI1PR04MB6941F4469EB63FF87A509F80E0F79@VI1PR04MB6941.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WpUp3VgIL6Pv1CBKoSDDLMQ3K5nwcQq1GLsJIITtfG2wIDpHqu+7K2xLGT1TDhChe5xS/L2R8nh/kF1L87QtTUAMsklm/TGtZobP3ipXg/vI4u1R764TotiqgyN2lslxXN1MDyokw1Vgnwh2ztkgzLEuveeVwzHngVvjq6dhGVi4uP2gc9toQB71Oycch2PpntDvPFo3abZZ3nvLVKrArhBMfrYMNwt6/R3+pn9S6wg2GAfyFTMOM3hj6/8kJw0mmMiS9by29QPu7lVf3iNoJnpUBbtcdrqcp7a82faB9wgoJRT0VP5973We2R4WEuXWuISuwp0pYN6NK82cFXqXYROQYJuBHR4RHGiaBXzzsroeJ1MCv4OaRPJ4Jevh6veO2uUlxReQec/BDa+9DGC9Vj8j/sHVMa+uR777FI1DRw6a2JQtC7DuomXExlRYmIaHkHAOYV8rorpjsbdhakYmmYSlHDEWFjR58lpv9KV5aWEYRg9sbBBneaeqHxBJPhctDc/3W8ZLSHr7Fv0ovS4/NnDC5QAQj/kaOYEvJEgmtQ8Zd4eWjohUrDAtmACGEf43Q+lO5zwSOwuGhNeezeJsfIHXZGgUJoJz9e2y0+24WCNRvxyj3YUl9pNUf6yGfWyXiJgF8MZcHDulA+PAMOzULRkdQgo7ip7LKGxZ/3O6glGCiUuEgRJKmyAuiBUV5af3+8FQ8GOn+Oig4XIN3jnZfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(396003)(346002)(136003)(376002)(39860400002)(33716001)(1076003)(8936002)(66946007)(66476007)(66556008)(64756008)(66446008)(76116006)(91956017)(26005)(5660300002)(6512007)(2906002)(6506007)(44832011)(8676002)(86362001)(9686003)(53546011)(6486002)(15650500001)(38100700002)(71200400001)(7416002)(83380400001)(186003)(478600001)(38070700005)(122000001)(316002)(4326008)(54906003)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fykUcsB8WDbsy8XiDk6/W6L4N4oY5m8ELKGTc/VCZihH2ozyLvWi6rblfFsH?=
 =?us-ascii?Q?Aq2dGXQJqREnCi/SN0SXrDvS14GIfFi4cnfbcfwIUvsczYtSNwRoZ17x9pa5?=
 =?us-ascii?Q?kzZ6+lrp1mCknPfk0hSW+nTyjF3E6d/NosWw3SKjUwdwBX68CfYmD2ENQjyr?=
 =?us-ascii?Q?Za2ADwC8J2KOx4hdR2uHNASRFH+XQlzaLQfzh05SOR7KE8eq1uCk7QXP0Bqt?=
 =?us-ascii?Q?hBMthjwWx4P0CcH/sMCsfjZsxRHv2WUatnE9EmLq/EnAG1CCZjkT4sV0Gs8Z?=
 =?us-ascii?Q?NPAt/tMLFhLWe46TWDm0fXZf5WiCH35A0BKiKECbF9BVSM3dkmXDYXUaDK3/?=
 =?us-ascii?Q?cQwvSXbLmsnESBg5lMZtuvKX01JxnhP+OpZ+RcA+EqHFIODp+rfMBSb9mL2d?=
 =?us-ascii?Q?YuO0GKpRWJzvckrFgtcNWItFkB26DcUd4hTCknLV97QWakVdGekX9jXtpPK4?=
 =?us-ascii?Q?KoT3PDMTHmwwP2I67mcNTQ4vWKfUi8OuyLxfYKhdJjzZ6v9diDQOUGdKSm25?=
 =?us-ascii?Q?6wAAtGzVBvCmgUb1t80AVMC9VTx8eIs5esVgVtXYWkUO6v5wtNe4uLjcL04B?=
 =?us-ascii?Q?oXIkr4ZSQKGBq5AHPvGlCIbHx+RxSnbpGrjQXV6w8wBflSNbDRcylQFWBHa4?=
 =?us-ascii?Q?g6tRkmYdAZ5w00VdhYjD+4JDMCWsNh5feqck8ZSBhp5M+XHonRiLt3U1Rcmc?=
 =?us-ascii?Q?a/HRORVhy938GVR/Hjq9xyHn0OasK+NHdwZZcdN/eWauw9OP4xYaGiqqs/un?=
 =?us-ascii?Q?MQgH9nTlGVSMkG8WwhUepV2vcILtz/0XphJH1Chre0ysXKVzwx3YBwKOtR+c?=
 =?us-ascii?Q?SAESxbpZHc4ctZhJ1fBfJxrTO9a8yuHWpSzkur4DxBrEUpyHAxF6N6bM/kTq?=
 =?us-ascii?Q?wOfCwltbADNNIlTq6gJXm2hwZ+vdiefRjI+yJE+pRxbVDceVn/cDJgFfomAl?=
 =?us-ascii?Q?snHasRYuwjLFjvkPQ5UfbaR8h7nndm/WeUrbknWxB68TgvF9QGr/3gQOrPqi?=
 =?us-ascii?Q?eHmCuSvHPjOQgZq2yvewO+KSPM1vj0+zmdXm/JJR76FR8ApWkZtuzKGAhFbf?=
 =?us-ascii?Q?B7T/Ty4tm+q5BCWmkz8eDtUb+4GPbOuXn4rU9R5eSaaUrWMlg2ssl3O59Tzj?=
 =?us-ascii?Q?l/rAK1CnIyLWj88u6Y9ucmwp6ssaTVvhWLbUXbHbeweLBz9kd3GOz/AcjyUd?=
 =?us-ascii?Q?O2L/yOdO1E4SXbs/RfimF9hB+Lqosean8zjbcTay0RKZpzEGIBvh61uYgZb1?=
 =?us-ascii?Q?BKZQYHUbfpjHrVtb7dI6K20phjEQ1Kah4TFyAkGgY7alN9BAFRg0QhKZU+sB?=
 =?us-ascii?Q?mZ1V1mpqsInixIyYUOMBCe+/vIw0nmJttuf/h1Kf5Jrb7w=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B667A00E33403142807AD892B5C49EC8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41f3906f-3300-43dc-bdb0-08d95beb0596
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 10:38:41.7423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wxvLyYGlVkwANcsG66M7l3/GAISYblApcPk87Solgv1DhcVhIrFYrarB4Sy6r8Y1PKyhB7rLIjvbFI+nEmEi9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 01:15:32PM +0300, Nikolay Aleksandrov wrote:
> On 10/08/2021 13:09, Vladimir Oltean wrote:
> > On Tue, Aug 10, 2021 at 09:46:34AM +0300, Ido Schimmel wrote:
> >> On Mon, Aug 09, 2021 at 04:05:22PM +0000, Vladimir Oltean wrote:
> >>> On Mon, Aug 09, 2021 at 03:16:40PM +0300, Ido Schimmel wrote:
> >>>> I have at least once selftest where I forgot the 'static' keyword:
> >>>>
> >>>> bridge fdb add de:ad:be:ef:13:37 dev $swp1 master extern_learn vlan =
1
> >>>>
> >>>> This patch breaks the test when run against both the kernel and hard=
ware
> >>>> data paths. I don't mind patching these tests, but we might get more
> >>>> reports in the future.
> >>>
> >>> Is it the 'static' keyword that you forgot, or 'dynamic'? The
> >>> tools/testing/selftests/net/forwarding/bridge_vlan_aware.sh selftest
> >>> looks to me like it's testing the behavior of an FDB entry which shou=
ld
> >>> roam, and which without the extern_learn flag would be ageable.
> >>
> >> static - no aging, no roaming
> >> dynamic - aging, roaming
> >> extern_learn - no aging, roaming
> >>
> >> So these combinations do not make any sense and the kernel will ignore
> >> static/dynamic when extern_learn is specified. It's needed to work
> >> around iproute2 behavior of "assume permanent"
> >=20
> > Since NTF_EXT_LEARNED is part of ndm->ndm_flags and NUD_REACHABLE/NUD_N=
OARP
> > are part of ndm->ndm_state, it is not at all clear to me that 'extern_l=
earn'
> > belongs to the same class of bridge neighbor attributes as 'static'/'dy=
namic',
> > and that it is invalid to have the full degree of freedom. If it isn't,
> > shouldn't the kernel validate that, instead of just ignoring the ndm->n=
dm_state?
> > If it's too late to validate, shouldn't we at least document somewhere
> > that the ndm_state is ignored in the presence of ndm_flags & NTF_EXT_LE=
ARNED?
> > It is user API after all, easter eggs like this aren't very enjoyable.
> >=20
>=20
> It's too late unfortunately, ignoring other flags in that case has been t=
he standard
> behaviour for a long time (it has never made sense to specify flags for e=
xtern_learn
> entries). I'll send a separate patch that adds a comment to document it o=
r if you have
> another thing in mind feel free to send a patch.

No, I don't have anything else in mind, but since the topic is the same
as the "net: bridge: fix flags interpretation for extern learn fdb entries"
patch you already sent, you could as well just send a v2 for that and
add an extra phrase in a comment somewhere near a NTF_EXT_LEARNED uapi
definition, or perhaps extend this comment right here:

/* NUD_NOARP & NUD_PERMANENT are pseudostates, they never change
   and make no address resolution or NUD.
   NUD_PERMANENT also cannot be deleted by garbage collectors.
 */=
