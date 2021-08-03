Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91D83DED3F
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbhHCL6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:58:33 -0400
Received: from mail-eopbgr20088.outbound.protection.outlook.com ([40.107.2.88]:54302
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234653AbhHCL6d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:58:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AvplURoHH7daTY3nFl9h4pIa8NLNH+sIl15MlrsIh6wlAIC9hR/Or1cH+Ay3vPc3W4c0deGpaHVMvWwz0YwPuhocXgJlDwE0EmYei2KCO3Z4yUZ8y7SEwU1XEUGAVYkUOAL6SAcq1Moxe+XM9xggL71WOde0X13z3j4mXCOzjQAxkiWHtABgpMenQDFzRb4yBvwlRPyE0jsD7n8F6AjuQRI/I3afzedVATllTlM71C2cAPciap6FbuYnsZb3GITddh2f5QL8VdaPaXIkFGDw/j8NPo5hyVsna6MtWoB8gJND3I2Onff8B9wOWK1gxZIX3qpcntqZaltmk+/wrDG+iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CiJnYcGXLbn/zEuU/Es7bEP2T+SkLIXc2TxgAHOdKkk=;
 b=YgAH+gPMRAcGloPDX5UPYzM4NjBySB7F2vS5o0BRsqzvVU6gpjgVGSeNDGLP+FlTg96COC6889eGMJCartuV20CS/jEJxuDsZ1llO643EPDA4eXH1c7Y9EUgMR6eeiV2VhwpmD/1XsPGHYZentNqPLYVMR1MKXNfP+88b1olQ9/0kFICvpowDxzJiKD6ddzHSZu/XbDWNHRX47e9KnB5pxFCqlcAIEqKzFU4BjFAQtyVB/AjR7wDvI4tiBzgrIxp5JSCFqGQISVP2LeBQabqULVh5o1aAvFALJ1lqbEH9+x1uRAjMNsPlkeA9v2GCz9PfMvDKMBvFCpw5Kdts1nFZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CiJnYcGXLbn/zEuU/Es7bEP2T+SkLIXc2TxgAHOdKkk=;
 b=pDb22WcajFx5EEx8ZxsYL2WLx06nGChNIriXVfaDphPJAy8/qQh8cm6UQFGKPcOKRoXyFj1PgxRTjrp5WNzLpAUvObogqYoiMG4AfZJwzmFAG782r3/W51tZ7u/bNfG1UAoeA4pfmDRZ8f+8gPEeLa9dpT6g6gxbOtCjSGDApDs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6639.eurprd04.prod.outlook.com (2603:10a6:803:129::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Tue, 3 Aug
 2021 11:58:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 11:58:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
CC:     Arnd Bergmann <arnd@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: [PATCH net-next] net: build all switchdev drivers as modules when
 the bridge is a module
Thread-Topic: [PATCH net-next] net: build all switchdev drivers as modules
 when the bridge is a module
Thread-Index: AQHXgioq0gDh5K0XJ0K/Ku0/ydsvOKtgVkmAgAFX/wCAAAsWgA==
Date:   Tue, 3 Aug 2021 11:58:19 +0000
Message-ID: <20210803115819.sdtdqhmfk5k4olip@skbuf>
References: <20210726142536.1223744-1-vladimir.oltean@nxp.com>
 <CAK8P3a2HGm7MyUc3N1Vjdb2inS6D3E3HDq4bNTOBaHZQCP9kwA@mail.gmail.com>
 <eab61b8f-fc54-ea63-ad31-73fb13026b1f@ti.com>
In-Reply-To: <eab61b8f-fc54-ea63-ad31-73fb13026b1f@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: ti.com; dkim=none (message not signed)
 header.d=none;ti.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a3e4f3c-b30b-42a1-a282-08d95675fcc7
x-ms-traffictypediagnostic: VE1PR04MB6639:
x-microsoft-antispam-prvs: <VE1PR04MB6639BC288F2196A6DF1BA247E0F09@VE1PR04MB6639.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ouVUNv0irAPNlTktBRsUHdENkIFdTRqyBahpTpd4F9caHXD2yOnQ1hkpvzlaArnlWLrg3NhudEYBQGUkpTO1VkAIQZExLX4UYW+0c1wcSPNOdGvxY9YypTm6WhpD2F5NJPPA18sKTud9YmtEMfLNS5USDWaU7jD4/jh7TQCEeeIntGxg7ADEwY7okwDSbiCgsDsHiihnuGJG/bRpILRfxPgoDDrJaEbqabZ7kaHyI7tW2Vul9QJ6VMb8U/0QHZ6G2KaAA1ETUlwjxTFXqcepKIfj/OlSLHuR1v0LdRVBDhQvbZESV8lqDDDHwl+wO4jHtHywNQuZprlfYtyYma/hhiSqB6Z+ARqyCOPhHk3p+gA3wgtQj7jnI22ldCDhMuUnfyDzuGnbnBxvnUUf1YWXdjJrBCbpdHGBzzKuX6MITO/pd8WEMRtrMvkk+RO2j4ZxgxaPop7/Ijn6qR7l2/VGugq+2L7N+lGg9neCwygwFIDCsyYeFZs9cYUrBkDPx2oH4OptzQKysMGhr71MOs4t2gvmeqOtAk2QiUFx6r8yiijWFs3UN5zfxBX9Nm5uH3q6jcPrQCzdPKbWS50/ikLntletqKZMazd4qi+MBXT6hbNxxDxs0mdmU2wvLVqkPYgywKtt/LcvPpY9oudU/b4i8Bz3AfUc98PdoUmhEqEF8AygzztRYFM6zpMPWVNHGiM++eBliesHwX+F6cO1K7bnMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(39860400002)(376002)(366004)(136003)(396003)(83380400001)(44832011)(2906002)(6916009)(66946007)(86362001)(8936002)(1076003)(478600001)(7416002)(38100700002)(122000001)(91956017)(76116006)(38070700005)(71200400001)(186003)(26005)(8676002)(6486002)(33716001)(9686003)(5660300002)(54906003)(64756008)(66476007)(66556008)(4326008)(6506007)(66446008)(316002)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CmLJIjnwc2/Mt3Ntfhr6Fa/W6aNSPvqnBjukPOsv18IzGbZMOEU+f82oYhwR?=
 =?us-ascii?Q?9cWUb9Pv/DjHotF2YtIMp8Q0FCs0RU1B458JXjeaObE8F2iMiyQoACfS/0sj?=
 =?us-ascii?Q?WntKzt+bWXkCHCSdbI6IhYP3U/70Hk0VHw//tGN4zZkIzGR2E7CAava1eL/Q?=
 =?us-ascii?Q?K1bN0sFXLjY/FvZllnJSfPMfmSFLnyPv99Qd229T0nNA09nYPQjxQLjeCxoh?=
 =?us-ascii?Q?oHvfhkmbIetJmH+kLHgerL7Ne1oiMZoZ0VgRf2Sc1bUAjzEA4koYYbMyMk4B?=
 =?us-ascii?Q?WDdSKoVsMdVg4r6kGvKauU2RNvID7OZRfkg426ujuTIrP6oQ4ZhVTF32I+x/?=
 =?us-ascii?Q?/XqMj595PyAm+iJgrlzb/w/DVU93DcjYZd6FYGuNaHOeJGVaJNpGcZaOCPs9?=
 =?us-ascii?Q?fIhwkT814fyenVi1Br+2lrKZ7tVYA/Qqyin6+Ijnkyn2KYFDw6he7voJbw2m?=
 =?us-ascii?Q?xBB+30g3CQO/PZrxOLAUjGIquyHMfRdODrhRMOMaOr79hibhunhpxcmGJXul?=
 =?us-ascii?Q?EU14ku1YoWzXXXduwGqnJAVVLi5QyzQ1ZiVAa7nwNYtP4beV07CWf+n6pN9R?=
 =?us-ascii?Q?8LwofZM+Ijp34XtOtsthZg8YmL4zO13yCCOLv/d9Wud1fFgry0sMN0R0/tf1?=
 =?us-ascii?Q?T9c6qZWWl3HdFVqqRxtHxd0qvVTw5VuRW+tZFBXM3Nq06njJnPLof+u7xasg?=
 =?us-ascii?Q?vyqZiha97krT5mEl0gE3iKS0YRlPAbSN5g+95zyWopd5/MHcgGZNnFaGjJwb?=
 =?us-ascii?Q?8q8RULij7CMsK8mxdR5PqZ97SzPB6AEaKHXSOoYDYOqPzx4e8Cl9a7+rvBzf?=
 =?us-ascii?Q?Elqpt0rt7jqY0FUPgO7WuMnzALsXBbr3Ywu5g719WUgqIuPIdnmGazMWcrMb?=
 =?us-ascii?Q?GUGoh/9PkeAFhZ3bQbJ68L22r83ymLaegikKi6hWatOzRaChkuMAAm9jFGIu?=
 =?us-ascii?Q?IGGLl3s+ENYb6JSYvOARruy8HRprhKMu4MrcFWjEFzxqYMRaxvUKYxPcvkoC?=
 =?us-ascii?Q?BUPd1RajjFUn6cxUQKA8KO6HJaeij2qHGFzXrnNqLNSD7/267q6r8viAuN1G?=
 =?us-ascii?Q?1zbB4A03Lvtdc9GFCvijPPh1hLnqNf3IQ6VHJEpuYS/SVMRs9p28du2dM4S1?=
 =?us-ascii?Q?SawtE34F1VlTrQ04h697+qyBOdZL6ZH+nT1SjO8iCqzvAnLsCGc++a8PQCa2?=
 =?us-ascii?Q?tTzXiXFSKL79YStSnlorxpk+NXM3cuTT9RTwQV45pG37O+VvrV4V8Xqvel6a?=
 =?us-ascii?Q?5dIS+0+OejRs+cYBPT4d5Fr2hYHpct+dO/Kht6O46FaLlrFtO8mViiBcUj7m?=
 =?us-ascii?Q?zF59Dgud8N477Za6ZYkVkYOb?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <76F6D1F3502670489D84A5E531642FEC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a3e4f3c-b30b-42a1-a282-08d95675fcc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2021 11:58:20.0330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qo1Zl2O+NUWi1SNVmdZY13ZgSBYLwdKCFKIIqfNzFM5oidaHcxbyk17Z3XZebYD5QJlhf2lCVP1Qg3bfFeanYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6639
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 02:18:38PM +0300, Grygorii Strashko wrote:
> In my opinion, the problem is a bit bigger here than just fixing the buil=
d :(
>=20
> In case, of ^cpsw the switchdev mode is kinda optional and in many cases
> (especially for testing purposes, NFS) the multi-mac mode is still prefer=
able mode.
>=20
> There were no such tight dependency between switchdev drivers and bridge =
core before and switchdev serviced as
> independent, notification based layer between them, so ^cpsw still can be=
 "Y" and bridge can be "M".
> Now for mostly every kernel build configuration the CONFIG_BRIDGE will ne=
ed to be set as "Y", or we will have
> to update drivers to support build with BRIDGE=3Dn and maintain separate =
builds for networking vs non-networking testing.
> But is this enough? Wouldn't it cause 'chain reaction' required to add mo=
re and more "Y" options (like CONFIG_VLAN_8021Q)?
>=20
> PS. Just to be sure we on the same page - ARM builds will be forced (with=
 this patch) to have CONFIG_TI_CPSW_SWITCHDEV=3Dm
> and so all our automation testing will just fail with omap2plus_defconfig=
.

I didn't realize it is such a big use case to have the bridge built as
module and cpsw as built-in. I will send a patch that converts the
switchdev_bridge_port_{,un}offload functions to simply emit a blocking
switchdev notifier which the bridge processes (a la SWITCHDEV_FDB_ADD_TO_BR=
IDGE),
therefore making switchdev and the bridge loosely coupled in order to
keep your setup the way it was before.=
