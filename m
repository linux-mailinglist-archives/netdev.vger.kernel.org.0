Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3417243C88F
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 13:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234849AbhJ0LbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 07:31:11 -0400
Received: from mail-eopbgr40041.outbound.protection.outlook.com ([40.107.4.41]:52803
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237347AbhJ0LbK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 07:31:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKaMN1xnVRLzYipkGczYMBcvO6TYD2eIshAczVDFICGJMJYEc2cvgWaKrfyKJb2HC2CMQ50jxU94+c5g8ATU5jBqbfGlEukWo76QTNKkDyPFkPa/0TYgdwvmrLsiu8luciCPgQwMgIDYBv4DeiBNXgDBsKcavoKletpxYd4t2LuSSQws+hc0WNnaIj+zHP3m8QwFexLSgJfO0DH+u+Awm+JkZNHCxtig402xM/NsYX+sfIBiwzGzOTol9ewPvJJS4E5TNfJBb9kK9rkHN3HhE8vARyIzIbz9w7ZrziQbWdFqw8U8YAVFSo1q09cS/XP/LpGVVqK9FNeTYlRABIA1vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0gTFSP63IzepwdAGkJbCOQlUy0/EHksit1rYCY0S0Fk=;
 b=IbuCvVYESPMGZaR4J1AWNlfE3+MExY3rbIU8pCiwqT0rxgPSfDH6G0m+Hvju3WK1ZIX//bxExlq5eVb1fvrtwiOsirhyy3UoG1QXTu4eSHUMqlxnmQBGAdnRdX6hmURjguSTsiOJxaT2tch5fPAmwq77L1M7TkM9RzTN8EqAwUjQ5hZprqhMMBVpWPdg2klIDWiOgQDOzl5mKPaYdh2Yo942ZAqBUfgVyFwex+wIh81z/rNkqohYepPEmwCasASsEQ6dfFOaHE/yq7eHT1Dc0Oz7U6/VmwWq9e4P9xLGyEt/kYmZj98EL4ZIBDwGo1JcBEHw6NXQR0ZQNysgProdjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0gTFSP63IzepwdAGkJbCOQlUy0/EHksit1rYCY0S0Fk=;
 b=s1X2MZZprySMezWe/zPF5QAqkece9S3E/oEIbMsEgwxIhjY9HfKmob/ZdjXJP+V1es3u5+sa9wtaUvVrTvwgvOUV5FnQIRXOOxJ+YRmGR7UF/otWxbzI6swwso8BSgUFvBCxgaJn+DnrjFeaVqUW6bQFztQxrqJN3Xz6xfurlkA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 11:28:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 11:28:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 8/8] net: switchdev: merge
 switchdev_handle_fdb_{add,del}_to_device
Thread-Topic: [PATCH net-next 8/8] net: switchdev: merge
 switchdev_handle_fdb_{add,del}_to_device
Thread-Index: AQHXynW1BX32SPf49kqiuMDhuHPvJavmiUAAgAAtaIA=
Date:   Wed, 27 Oct 2021 11:28:40 +0000
Message-ID: <20211027112839.6izp7or7ivlt5bzn@skbuf>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
 <20211026142743.1298877-9-vladimir.oltean@nxp.com>
 <YXkR0NCj1OyEwycZ@shredder>
In-Reply-To: <YXkR0NCj1OyEwycZ@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8c0d540-3ecc-4335-3ca2-08d9993cecf0
x-ms-traffictypediagnostic: VI1PR04MB4222:
x-microsoft-antispam-prvs: <VI1PR04MB4222B2811A62C8185857F179E0859@VI1PR04MB4222.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:254;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZmO0oTM04shrpIzl4vKRdTuDUXzEKBH8V2pa9R6VwsGhVvEx4idJeA5tHZk/AR7EMMJqq6+cP7ddvwwusoxkD47apj8aA6O+oxCM5oA7dmxU0sY/I29mpVi++OhrgHx0cZIf0dMSyIuUU6CKfs3UQUakDbj0Lq7hOha3CXBZxBX/6Cq1ImSGeJ/AOCh6sTHkgpPGLgIo3YRwkchl3sISGk/U7AtcFHQmSg40IhbQOqJ8Gvxt5ZBvi1/fbx/jdxowez8c+Cu1KVs3yJZD0GRvIC7jYuSqsBSp/HFNrNNb7INP+GZunz2328jBDBd5lhXJN9AeOnQ6i+C8pcG4qxIhqsRExAa2ox51uq2ewr6AzcHicxKhkFZYBDTjA6/q/x4fGGysSomARW9xVuDzdZNoKPTyXOjs42nXxUBL/79VHrzMu/YtjUlMIsCodChie6CcgLaEvuCErNJm8nNQJL3Exrr8kWjesWirNS/iOzxF+eGYhetuPmi5DaKKsGvGdyeYE3zJ7ZKzbODawacC3Z88wD4TPYwBtiSZhLD4Gb/Lz2e9e+tmWt389FDc0Xt/16KKTY60NfY8yKMsHCzA3g9Mk4F0kji+JCVz5YZiPlqr9QpGFenY2/qg1uVMMGyhMcRc0yPN/0qLZ13tO0gaUUCpArx0GydZtZNfdLUMK4QQcq51YGPZ6wT54F7iC36tkakyc1gZwTM2RxaVyu0tznWG4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(71200400001)(1076003)(508600001)(76116006)(44832011)(2906002)(38070700005)(83380400001)(8676002)(5660300002)(6512007)(26005)(186003)(66476007)(54906003)(33716001)(86362001)(66946007)(7416002)(64756008)(38100700002)(9686003)(6506007)(6486002)(91956017)(316002)(6916009)(66446008)(122000001)(66556008)(8936002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?99VupypVXg7QOoZGC6Wb1hf+ndZuqELuFlolM3bDNgbN/unVtEdX/LhgNSpB?=
 =?us-ascii?Q?9XQntnwDBHPm1gE3v2oFtXOYjYovNXlw58cXotn6twi2bY5HMhJhWWGHv0al?=
 =?us-ascii?Q?x+UNj3SGlrafWk16USVWgv+V5Nn0RLfWpnJ8TIheavTkeLdfyQ64KKizbRK+?=
 =?us-ascii?Q?yOuT4XUxCeskLEZR69YUwQ8GdW2VBAytPghq1caBUs1nWLUEiFB1xK5PJwA9?=
 =?us-ascii?Q?ZmweRDHs5yh14RPgg4B8aG++l/ScT89wDLKWGUkpX1SDEfUesEj9HoPoo4Nm?=
 =?us-ascii?Q?vdvgWpc0ZINUuY5Bdh+hAjgSDaOwB3OojlEwjfMTspO7pnKr6Kan2VzyVTQx?=
 =?us-ascii?Q?T6bIfcvh/EjGrEEjXXocfR10GxjI/IUUEbil9cpCat52ItCFhSOheNGkuC+3?=
 =?us-ascii?Q?uHzptFOznfBqXW25AQHUvqjDTzXk08EzHbXeREWOczSRYYZfWEDz8qouyVNS?=
 =?us-ascii?Q?TxlGciZdQBeBW6chK8YQvqdKZL2WM78BzQyNjUxkPDulIvuoHSiAqMtc5etb?=
 =?us-ascii?Q?L33opj3YwpJuLhcUxROMz6juPxKtU5Bk6FoV8LF3tVKBFUlAQxHJdHhFZ9Az?=
 =?us-ascii?Q?wS2EKSNgAdI1VPCLEiCxeAx3Li79qa5FojBO+XTCNyZEIdRMR6Qu6CNJRjiW?=
 =?us-ascii?Q?fl1UhxxwLWOgotKc+XbevFbU9Q2B5NQQMi39fp7tysvXreG0UbHWsZ11T321?=
 =?us-ascii?Q?uBCefy24dAf+HSdoZlYmLwC16IFsR0F4HMySvofXSKFDJSNB/ifdMBQaJlQ9?=
 =?us-ascii?Q?svudFo6SrZ3ycLiDAXpP23pLPQ86iO0hSvr+HhNxd2wfOPv1u6bBbb0iV3J/?=
 =?us-ascii?Q?bGrahjfVGym1fzrlAvnA1lJLaJgvZYoT1pTiAX/CCYwQEU7sE3aVIsAPDoSt?=
 =?us-ascii?Q?LDoTuM99MYAdCsmjkpfyeA+WV7+UOlTyhpj1J3oM5fUEJtMkljSSP2hfluRc?=
 =?us-ascii?Q?PHTBf/UGdOt8LhLJn3o8ZEfQqhrCNg+Tb6X+2n3wqu3j4/EG89+8KL4KbuZw?=
 =?us-ascii?Q?X+9T0cE4z31Y07EJrYZZO5v6fpZqUFSEZ1fAtEEWF0rknvZcUdZGDcTnvSAX?=
 =?us-ascii?Q?RdOyQdnKDmA0AT71TrJOxQ6CcGvRCa2Po7mBAMBAulrjUh1UnNtneESV2D67?=
 =?us-ascii?Q?RNAxcWBC1NuZP1y1PvZ4b+fo5MmOzgN+/XLrTVgLxxb0ahrX2NePodoDko5c?=
 =?us-ascii?Q?Kz3ciQNnxMcVo1RwXc5kkxECUEiQErqrjVMHA8/5mVzMEUlyagp/cxonNvqQ?=
 =?us-ascii?Q?5j27oT9Np+pTeXSwUG28m1B8cxIxT98FC21dY6etnkQL3V4bGlN+XEOkmscx?=
 =?us-ascii?Q?nxfAaIozsJTkoCzGJKioeqy4AFrO3MQJG+X6+Y0hvVAhTA+bl2otS5aoqw6T?=
 =?us-ascii?Q?uUYb6R2eFsVVFPWBri9rSpCoLAYWCi7miE39xSX2TbpXk+I4pY50X7z+oiR5?=
 =?us-ascii?Q?4T8i5pxsmdw47MiRgOcHa0MDBJ/nZgbofrZjTIrZeO9U95bBN8unsQQYT9wV?=
 =?us-ascii?Q?juHywrocoDd2xhamL76ouwULzkZ/EN5etqMkPPXNgqpwSyHXyaVmSiqThK6j?=
 =?us-ascii?Q?C9PfXzeuj0LhzYjIOuwYfBEqjnogZcmbYFAmI1+6tYX1kG+mPXzkM6P5mbQ6?=
 =?us-ascii?Q?Z2RQm/ajYirejmNiOJn3E3k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <800639EB4FB3034BAE18110A2541509A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8c0d540-3ecc-4335-3ca2-08d9993cecf0
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 11:28:40.0631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w+9NkHjlhQPEJAVelgrHfhkmPL3wRNlb1GgIvH9kUVmhvaI05/rbApX9KvbiseVZAYGFfml1mReCEvzupA7eOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 11:46:08AM +0300, Ido Schimmel wrote:
> On Tue, Oct 26, 2021 at 05:27:43PM +0300, Vladimir Oltean wrote:
> > To reduce code churn, the same patch makes multiple changes, since they
> > all touch the same lines:
> >=20
> > 1. The implementations for these two are identical, just with different
> >    function pointers. Reduce duplications and name the function pointer=
s
> >    "mod_cb" instead of "add_cb" and "del_cb". Pass the event as argumen=
t.
> >=20
> > 2. Drop the "const" attribute from "orig_dev". If the driver needs to
> >    check whether orig_dev belongs to itself and then
> >    call_switchdev_notifiers(orig_dev, SWITCHDEV_FDB_OFFLOADED), it
> >    can't, because call_switchdev_notifiers takes a non-const struct
> >    net_device *.
>=20
> Regarding 2, I don't mind about the code change itself, but can you
> expand on the motivation? Is this required for a subsequent patchset you
> plan to submit?

Yes, I have a change that calls SWITCHDEV_FDB_OFFLOADED on the orig_dev
(which is always a bridge port, or the bridge itself) instead of the DSA
interface that may be beneath it.

If I understand correctly, the purpose of BR_FDB_OFFLOADED is simply to
show the user that it is offloaded, right?

Things get a little bit interesting when we sniff an FDB event on a
foreign interface that's in a bridge with us, which we trap to the CPU.
There we would be basically telling the user that the FDB entry towards,
say, an Intel card is offloaded, which is not wrong, because it kind of
is, being programmed to hardware, but it's also not "offloaded" in the
sense that there is a data path towards that port which bypasses the
CPU. But that is never the case anyway. When you have a bridge with
mixed hardware domains, then an "offloaded" FDB entry might not always
be offloaded, depending on the hardware domain of the source port.

> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>=
