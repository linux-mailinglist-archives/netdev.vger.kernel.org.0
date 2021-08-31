Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687B53FC55A
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 12:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240832AbhHaKAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 06:00:13 -0400
Received: from mail-eopbgr70051.outbound.protection.outlook.com ([40.107.7.51]:30444
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240576AbhHaKAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 06:00:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=acsjCnkBDbU69u7CHB5X603eD1R6Ci7TVyHwJyfPor3Qjr2gdyfTVkr9zjhfDhD1dtgYw8RILwer0zM9fFAezIt7wvdhRJLd7PKCfN43iSX/3TALr/078Z1GDt0YuszN/y+jGPuoFqrwqN3Hdnyoj4DEwtgJ7LsPZ96XzN2lATGRNlNvdRfkRYJCdUzCcvchT9mcOZyAbDq9O++qmgd2tI3E61H6yYhOXe+5Is8Gi7H8wo9ko37g8e+rg2+ZIUYM+fQEwDzhMaNkIHFr5b2StmMrr7Saf2mTU2VOz6vvnsLJ1XBF8AvVo16rW3Ap7fc/yJqTKbGc2YGHZZXXZPXysA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=af/KmIpgC+9Azc4TOpAjMs/JwLmN6A/g8pjVs0HSZd0=;
 b=Bb5duFK2t3PX8egp0Dw8K1VzbPnRB4BzRcF8QfIazawHepLloOwzI9bc1caIYc403PDwPXY50di5ZkBWsCJM7xBwFzge0Foh4uYf0zZYwJV3oEqDy44y002ipzJcePaDSwpWKXOYuqRrMhMDb0dty0QyX+MZKq0jjpVqlRlfM0g8L2l4mPsgHOyC3ITOa8ZGpyI+m6hJ/ElJ51RKeZQXWH4F8tuyPElnis+wasRaWYKxFtCjddH1qhPvdlQDl2dssE0r6e0ptgqbKg9j4RMKSO+mAw5sT5Qam4xgNQcDyHWUzk+DChZswUFqae1C1R7u+v0TI7wlaVNWsf4eZBWz8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=af/KmIpgC+9Azc4TOpAjMs/JwLmN6A/g8pjVs0HSZd0=;
 b=GEHMsj95BggGu+7yHkzfNXLj54Mv1RFJE9gfkK8v0Kl2WLfGQnHwWZGMq7JfLVf9x8yhDTCwmqG1TK0IT3E/hLkblollBHtFm8hVOSZBKSTV8XpSLG9BYH6baStC/d13CULZsWBWsvDy+v7FHMYkBqYfMJsMTGMT01sjj0F13pg=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB7PR04MB5497.eurprd04.prod.outlook.com (2603:10a6:10:8a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Tue, 31 Aug
 2021 09:59:12 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::7c1f:f1c4:3d81:13fc]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::7c1f:f1c4:3d81:13fc%7]) with mapi id 15.20.4478.017; Tue, 31 Aug 2021
 09:59:12 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: RE: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Topic: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Index: AQHXnhk3XLn1mK+aKEKIkxNIly6FZauNPsGAgAADucCAAAqfgIAAAG6ggAAFpICAAALSAIAAA8DQ
Date:   Tue, 31 Aug 2021 09:59:11 +0000
Message-ID: <DB8PR04MB57855C49E4564A8B79C991C3F0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20210831034536.17497-1-xiaoliang.yang_1@nxp.com>
 <20210831034536.17497-6-xiaoliang.yang_1@nxp.com>
 <20210831075450.u7smg5bibz3vvw4q@skbuf>
 <DB8PR04MB5785D9E678164B7CFE2A38CCF0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210831084610.gadyyrkm4fwzf6hp@skbuf>
 <DB8PR04MB5785E37A5054FC94E4D6E7B5F0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210831090754.3z7ihy3iqn6ixyhh@skbuf>
 <20210831091759.dacg377d7jsiuylp@skbuf>
In-Reply-To: <20210831091759.dacg377d7jsiuylp@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3cfda187-7a61-497b-2278-08d96c65fbc5
x-ms-traffictypediagnostic: DB7PR04MB5497:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5497002E91669E2A3ED8AFE6F0CC9@DB7PR04MB5497.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SLotPWqUe/qk6H4IZNe/sSeaGo05tUAsja5TSPqSu7q1WnV1V1ieDtk/lHQH1VWLxjnn30RuhShDO4qf1yDISvJfqMpLij84ck40ifg84+ETAnM+u09N97vuO5E2oCvw9xX8xYLQTG3wJy/wBOndZa/etgM7h1p7rH7RAaMZHPyOIFdgdaGrHQko09jkWRFbnOc1h0xqkPCtj+IOVmcIumhR41WluZ6UlyU8FkUx+Uj2ZAAHSjMqe7mr7OaT58FWdpruZKDpp6nIYtoejzhpxiiv7rWq01DkLDDsu/nkIrssGW0BU5rWXCczPmRgFkqNynnKAWrfFw8/0PzbCJvrNZAgu0eNnIIZ6CwxHqtNjI5/oQq5mOuM9BiDfP54v/gOrNTOnRyPT6vlQ7kHfTHkgY8xxJApSUnOiVGgky2vuOPPawKGotwyCldPU+YFY2PtZ8VtuPp061Mlq4hTevzWakDcG5ajEXooX8Ji8jTonxajj/O9c3f6CjVZiAsQxtTL1qnBtGSPT1V3i0aHHSUZMJwNPNVR9hAOwpM2HFsC0o3DRtc+lUuuqLgdrTgSFUVEXjeemBCUReqG5qbexuB7P/o63wMGWZ3drNxz/89VEOCgeqFrZ444kv0EcUrQ0SWDkW6FxdGgna5bgdfplg1+MtioeZBXT8Zh7FEspuHPaUCg9XGCVIWI85ZbK2Y53y4TOTRyNou0W8Mk6r07nivVKuX9dK3qbu360ESuxn8WTfnV2et1oJpVQZqGozPqqWqVlyPnZz1ReLx99Ei4aS499mG6kE1hQkvSdOotFyhmQhw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(86362001)(6636002)(52536014)(66946007)(2906002)(6506007)(122000001)(478600001)(66476007)(64756008)(8936002)(316002)(6862004)(76116006)(7416002)(186003)(54906003)(8676002)(55016002)(5660300002)(966005)(26005)(38100700002)(66446008)(71200400001)(38070700005)(83380400001)(7696005)(9686003)(66556008)(33656002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lIr7wS9nQHZ1GGv6qrbVN9MgeJHz5AkGOHavuf7db18pZhbRa7VP1hXljd9X?=
 =?us-ascii?Q?/Ps4j1nPZ+iMoX2ZZSWR38kNuX4dcrV1HCt/502KjoW+9H1Mz9zdhneY8KAK?=
 =?us-ascii?Q?wHBz+4a/n0V5xoagrY+duQ510QLll92HhkGDhcC/L/j2GjCvo6DQg7fmxdMX?=
 =?us-ascii?Q?TpkTCF5i9iLzCJJlUyxau9AhzRNpRvsNa64/YeEx0AldrO8VGFrlDCpHOeW7?=
 =?us-ascii?Q?sb5clV2i0mPrRoJWOBxMoa/425jAlHoMKySFnedLfNs62zvf/GN1GRrkEsbP?=
 =?us-ascii?Q?5cca3Wulqt7U5pRhAL4kiUKf9pQm4jBwoaZEaZJ5a84mqZoorhiLlRYaiE8j?=
 =?us-ascii?Q?SIDpdfiVnWAO0+lrVhMTDkYjPjYTVigxC2gmEw821E1XaG9bOS9piOQuYif3?=
 =?us-ascii?Q?wZqJKH4499PHZJhrZGFydL0MYFrSW2mwGAMGq7aiLsFNCeUnHMvTkKlZfSEe?=
 =?us-ascii?Q?sz/RXEEGFGMUfrELXg24UqOfiWgSVzzpf1FKG3M14jEzvBJUbJSIhC9iU8jq?=
 =?us-ascii?Q?zpisd8h5ZWAkYOVF6fZtSGQnzDwVyIULmDmxeVYORWEvBbcJjxnkqziMqOd5?=
 =?us-ascii?Q?MaEJdv893+GvCFu6e/OtT4HOaCS72p9jvN9eZ89KwISEtYE2hCtLb+Ve2r8g?=
 =?us-ascii?Q?4iDTa/uk3IckP0s9/LzYFSMoTR5glBd+pebCuB0Z+bva6hzRF3EN25Y8SF/H?=
 =?us-ascii?Q?gyWungWPFVCDJDW0u8sOPH9AIS6H1c3L3KXsyQYjzYD1ZqGFwVFhjHHLup3C?=
 =?us-ascii?Q?lxSRzUjW9oH7eo3D4mPKN2qS3M2p2fHXL3bQwaie1OvdqOhv6YolE3D/Kt3H?=
 =?us-ascii?Q?2xTaDi785nJbhq0ySIvWc+WFw5jVAd7izA8YvpI0t96TkG1dE8gBBtkol+LV?=
 =?us-ascii?Q?NF5crQQdY84ICsH9bVU3tgShVZ3/RKp1fM1OgAp7NUSXE9Q0284vUi3Hb/uw?=
 =?us-ascii?Q?s/uqb2BRrk3PnkW7Jmlzgdai+HQ5fJaEnlSYj6wntcljscUwHa1yHNPSUX3i?=
 =?us-ascii?Q?Kqq4whCDMJVl67fGdp2uzEtvRBZVbVzE+C7RhAMnadDo0ECK02S/++ipazIy?=
 =?us-ascii?Q?u1FH4PIS19aTb2gs9odmDanW/86XZabnFO9pQALiuAQ0ejwo+IthH9peCdAO?=
 =?us-ascii?Q?CxkYPpheGQhH48OlVIhSeJ+mmCu7823lY39llsbRnW/AkM+qm+g2ai8wOgHI?=
 =?us-ascii?Q?8Vm3CRZ8gg1gRUOiwu/fp6Vw5TFA5ENKjctRH1TkKNbNybuyFCvZ0u81LWzZ?=
 =?us-ascii?Q?lhNAEO8PPEBQ55lhym//Jcq5GPL0Ios5tqbmJUCv/8Ja4k4x3szY1iAV+XR1?=
 =?us-ascii?Q?J48fXgVts9J6iK4c+hYbC75V?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cfda187-7a61-497b-2278-08d96c65fbc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 09:59:11.9943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KS2ugObG2LCS+DNqvSC6dOxxLq0EAW3v1kH/W5Aj+6pHmK5vhQYIynTGAi+27/napf6aTxHc+jZqml3kBU/YRB2bCWdie9+bEG7LBsZB+OM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5497
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Tue, Aug 31, 2021 at 17:18:00PM +0300, Vladimir Oltean wrote:
> > > > I think in previous versions you were automatically installing a
> > > > static MAC table entry when one was not present (either it was
> > > > absent, or the entry was dynamically learned). Why did that change?
> > >
> > > The PSFP gate and police action are set on ingress port, and "
> > > tc-filter" has no parameter to set the forward port for the filtered
> > > stream. And I also think that adding a FDB mac entry in tc-filter
> > > command is not good.
> >
> > Fair enough, but if that's what you want, we'll need to think a lot
> > harder about how this needs to be modeled.
> >
> > Would you not have to protect against a 'bridge fdb del' erasing your
> > MAC table entry after you've set up the TSN stream on it?
> >
> > Right now, DSA does not even call the driver's .port_fdb_del method
> > from atomic context, just from deferred work context. So even if you
> > wanted to complain and say "cannot remove FDB entry until SFID stops
> > pointing at it", that would not be possible with today's code structure=
.
> >
> > And what would you do if the bridge wants to delete the FDB entry
> > irrevocably, like when the user wants to delete the bridge in its
> > entirety? You would still remain with filters in tc which are not
> > backed by any MAC table entry.
> >
> > Hmm..
> > Either the TSN standards for PSFP and FRER are meant to be implemented
> > within the bridge driver itself, and not as part of tc, or the
> > Microchip implementation is very weird for wiring them into the bridge =
MAC
> table.
> >
> > Microchip people, any comments?
>=20
> In sja1105's implementation of PSFP (which is not standard-compliant as i=
t is
> based on TTEthernet, but makes more sense anyway), the Virtual Links (SFI=
Ds
> here) are not based on the FDB table, but match only on the given source =
port.
> They behave much more like ACL entries.
> The way I've modeled them in Linux was to force the user to offload multi=
ple
> actions for the same tc-filter, both a redirect action and a police/gate =
action.
> https://www.kernel.org/doc/html/latest/networking/dsa/sja1105.html#time-b
> ased-ingress-policing
>=20
> I'm not saying this helps you, I'm just saying maybe the Microchip
> implementation is strange, but then again, I might be looking the wrong w=
ay
> at it.

Yes, Using redirect action can give PSFP filter a forward port to add MAC t=
able entry. But it also has the issue that when using "bridge fdb del" to d=
elete the MAC entry will cause the tc-filter rule not working.
