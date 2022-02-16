Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A91E64B9292
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 21:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbiBPUm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 15:42:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbiBPUm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 15:42:58 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7D41EC048;
        Wed, 16 Feb 2022 12:42:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RIn7ZdU99y7wSX3h4hhIQ1H3AYWia+mO6Q08dRq69qdmdSfstL7LPZ9rVg7WOYK/JfwHsQqYC7xTOKyOHaVTnX/EuTrY3RX84HyKLop8/LPIh9Fgbg14Kc1kn3JSFc7ZhMB6ZZ4BSB/RemvmIpT8EV9ycxAGlyJDJOxq3KEb0yhCAe2zVfVUF06283Gf8aYV4iwqjgNDFPFtZtwr0uiJH3cPQehsnD4S7tvLyg7EBrbBHHlnJEAqP6dQwGpceH9AED3YxZsdvd3VMlZQAJ0Y3y96CewJYapfi3Ln7/lG0tYMo0zy00xoceY4T3/Tm4pD3LHrwT4KY3GAeCcki+SkPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RDbS/Eyd0+RjLgUJGbTt2MS9LxzJFzkpeYYI6XDKs10=;
 b=ldC7kXq62nQXuVuUARz1sJzV8/LFD7rv18t5IP9QW653shHW69q/aL+hXcE3/kphPcYwsQDucTy96jtDtwbaAeBy4xp+d+k/BfCjI7Bcu0ZQBgBImcU6sPQkzRfF1VMww1Uly0c2yv/DKL6Il00tcJJP/NBCqf9MgicOaFGoOoXpG/Jsd8/Sb+FRSo9WtXDqhvQEAgDRt8iHaJ4qJH/D9DyrnkZ2fGekR+reRlBMmSQ1PREhTGW+/QZhEbGmzFGIDHTmdiqw7dwV/8paB3mpjPo6oF+ZbOvOSMdY/IsDpn9xlCIBTS/B4AM/47A/lT1C4RnY+87envmRgocCGgJaTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RDbS/Eyd0+RjLgUJGbTt2MS9LxzJFzkpeYYI6XDKs10=;
 b=VxB4uhsk0JdYnKtWbhLyPIQJVo559DZ2YpOhN68v60i6vI+AHY4HjtMKFg6vrf2Gfn2nLM9eqZOdBUzM1Ex4DezKLlyXN/tMc6PFQG2YP/NvsgtaFQ8CBuwFggiwaN7b/QDkOi3SJXX11GA23j/EHNMFu1jU6UBp86c4+nEw18Y=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB7633.eurprd04.prod.outlook.com (2603:10a6:20b:2d9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 20:42:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 20:42:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH net-next 0/5] Remove BRENTRY checks from switchdev drivers
Thread-Topic: [PATCH net-next 0/5] Remove BRENTRY checks from switchdev
 drivers
Thread-Index: AQHYI1T5z2hUlFM0f0KoUMqxlaaUJayWoBaAgAAEugA=
Date:   Wed, 16 Feb 2022 20:42:41 +0000
Message-ID: <20220216204240.n3j47i3o45h44tvp@skbuf>
References: <20220216164752.2794456-1-vladimir.oltean@nxp.com>
 <0d56eb36-8b4f-ff00-da76-f4dd97bbeb5c@nvidia.com>
In-Reply-To: <0d56eb36-8b4f-ff00-da76-f4dd97bbeb5c@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5a3654e-4121-47da-68d5-08d9f18ce079
x-ms-traffictypediagnostic: AM9PR04MB7633:EE_
x-microsoft-antispam-prvs: <AM9PR04MB763385906D8AB3CDC2CA98FEE0359@AM9PR04MB7633.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u9LRor40MAJuxagDbDN+Wv7CRNT9EaNNHUSZAxZmUf0yqsMHSRgUdeUXpIM4L2aV2Ud7IGIlEhOFPKQtAGg42sewahgIUEWPuCv17szKtmZKFhikZ32wS+uO/yZOtoxSH4inAxnIqZ7DFSE6WXEZLF/i8wRkzRUbgkBDHpiFByBroZrA/9sFWSqrkfi9LyVJKif7ojBLOfNE70CVR+7JegkmBm/s9QRpATb26pGDrpbIXlrxkqAr5O1mN5tlEv5J/Cm6XFWnNzepfSlH1SoY+vA6EA44YpCYfZom4XB23fnvOxjmVD9xnicIMS6GLpMm5nA47xp8XAjfHIc3oyogKBYCwtRhF2yrU2b/DTx+miFSVcIrPMyotID2eOcH2UgiwNqTC2O+DZxcOUgQRRtV7jEZMOKIlCySqwlTanORcpxAUTadNbfaGeNq0pfR5A6UygFremupcCgSwu8KwNOXey+/py6MgVofPtZO+cYgdIaOBa5DC8BOM0tcvEdsxEz9qez8iW5zpU/dCDKdr8yrlwgBK+3xWcxg35OnEp1yPnVRGXN3DkcBxdbLT7kkqi/Q9QaunKDoAHg2HjHBk1YkIPIhUNEUkZVnjDjyBb15q14gYA4UppgqKSfHHTP3EbXTYUbnLOvywRPmoRJCiXYUQY5e+RyLqL8gEY1JBcol1Z5+FESCujpdAXWwRH53+4oTQ5nBtNMOYG0c3N5SfF7hx8J8mcwJxU2IkxVTDXcbeiTQNhdmkXYM1HBcfRoT+zj8Dk+Wo2sQV5sXgvjcHLi1ATViIJ1jLSxRuHmEab3z6Jj7y4d4yPQOwIkKhKaYlA6lhySHgtp/tqIpS+xn9M5iPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6512007)(26005)(6506007)(9686003)(508600001)(1076003)(186003)(966005)(64756008)(91956017)(2906002)(66946007)(66556008)(76116006)(66476007)(66446008)(53546011)(86362001)(4326008)(8676002)(6486002)(122000001)(38100700002)(316002)(6916009)(33716001)(54906003)(8936002)(5660300002)(83380400001)(44832011)(7416002)(38070700005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1ltjTYLAfVjmy1yucBD/1iVue/FjRvlBG30ygzSdHTtSILD58AXvKiBrrMD5?=
 =?us-ascii?Q?3ylPt4/lJoYFX5RGzXa1CgpbdxuDQ7DntQNFOfcjMUzcLrW67kWrzwHJI82A?=
 =?us-ascii?Q?u6NgJ1EXcajqzVHP3nAkXN/6IxsCz+hdPgV5nTruA7ReardRD6i5C2rFoeif?=
 =?us-ascii?Q?oGVGt7ClhATTYUL6o0QABRhg0p2xIoHJsXypewc2Jen6his/Cl9bANEYOgAD?=
 =?us-ascii?Q?Uk3mIlpZyKyTvCjQJ38fnHuBWa7IAXGm9Bvx/4Sr8kd8B++GcX2+QQbslZt7?=
 =?us-ascii?Q?4BC6+oGQCW8GOk22vHlL7vhHVvexKERcwH+S0/jjKGFbDpKHprL04y/zcsH6?=
 =?us-ascii?Q?Z/YUcx9BssWeZoEQ+eWK3wKaVMf5ogztE+ok9XpjbI+sgKZCIltWuR6v00Jt?=
 =?us-ascii?Q?o7Q+6XkLNrS2AtrE8g36BMmA6nSMXEfgi0Cu+k6vxLmUjw4e/q9CV8ZtBrD7?=
 =?us-ascii?Q?QPcRn+Cmj7OhZIEKRQLE0drZeCBVR1VGBHaKwaf/Qk72iJ7nVgN36TTPjIFI?=
 =?us-ascii?Q?+MFvSQTP6awPucfkemIqY+IbVjmUTKYzvitfcQXdW44MAspy2drQTiD9yWt1?=
 =?us-ascii?Q?wGwbcazoka/pFtUMx2sxHg0i1yebnacZyrxNnwpQz7+3aMBH0ZPIH8E0FITZ?=
 =?us-ascii?Q?bLzuhupA02TeRWr7OcbsAHIwkqY7QaJM8EOl4bZfGOd27TbV/7/yQu1P/mgx?=
 =?us-ascii?Q?5ivS4LeLRBOyJi7IHdXw0DlEG96EXOXaU0kfDiVzl9DxlzClvpzpbGOa7d0n?=
 =?us-ascii?Q?D06pVmg4MHooYNBDbFyQTL3S1g6Eomx91s5dQnrHlrVoav/V+4rGZNeObVdO?=
 =?us-ascii?Q?m5zVFhsFnfy0oPWYz05dqM8Ue1+OI8wLUW3J7N/QWUBBJCyppX/ROXU/+ZYb?=
 =?us-ascii?Q?mRpygv/amA7O0EBxhRfucEiaC7SucBURmGUC/HgeyttpeE9RI1n70iHrGS/b?=
 =?us-ascii?Q?X2EG069SDOk/qo0EO5HsrXLiBLrtXTuA5e0TeHinw2f05UoVPhER+uZkaXYY?=
 =?us-ascii?Q?Wg7z9Lm/c5hDgvZanhvU3BWdQUauIUyyOClqhgrbu3r2s0Ay6OKsuIBaPF90?=
 =?us-ascii?Q?pSnF9k/hG49zNLmVCmrhvq5PciWs3pdHiUqzRjHrvWcW9LwSbT+KzdwygSW9?=
 =?us-ascii?Q?6Pd38nBOww/eE29YFj6h190jRm4aiIx9G9CqT7LaOTgFCtGYq8RmWiAjX8BB?=
 =?us-ascii?Q?a6xCLjtxleqVKy0ApWZGsbtUyz+DHFuxZAngabX6AFsd1pcEfcGjxbTFNFPE?=
 =?us-ascii?Q?eowUuIDiWS9QmtQ4+bGDQoOKCapeFO2B9hk7MyUlZpawJtQtze3X0aEslMO1?=
 =?us-ascii?Q?99ShvtQ6gMzqB2lDesJYhqkteazqBwVsRPh99nC+iJAOzD/GxA1bRuHXSi37?=
 =?us-ascii?Q?3OXrfnqZDqKmBCBh2p1+xm7RugOyHi1UFC9lXFg9r5H2zJQxp+84aln3MGeF?=
 =?us-ascii?Q?PsyK6DHTsRgCDfN4jvrGMUwBI4HQlkfuIflyJRxNxcuJ23m+p+k3oOlDi/at?=
 =?us-ascii?Q?Gn6w3qWQCszOr+ee75KK4s7mm0Avx5mCM1rLh0k0TqyTp1906uime0ldOVRJ?=
 =?us-ascii?Q?/pejTsTi4qXYGUa6tnQPRR99GheDfltzVIJ6d01djUDlFLAQ1Ekmc5LBy8We?=
 =?us-ascii?Q?uwl/qjZXwLCtUr0y1XiWfK0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <423D73BDFC84664CA6E06E636A68C613@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a3654e-4121-47da-68d5-08d9f18ce079
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2022 20:42:41.1998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1bWJDtjQZUIoN/r3dvkDS4NWQQnuHF7iGo0ELbKs7nhO986n9iKhsqzP3Lgh3gPXysT5To/IUDnOjZMpTV3Mmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7633
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 10:25:45PM +0200, Nikolay Aleksandrov wrote:
> On 16/02/2022 18:47, Vladimir Oltean wrote:
> > As discussed here:
> > https://patchwork.kernel.org/project/netdevbpf/patch/20220214233111.158=
6715-2-vladimir.oltean@nxp.com/#24738869
> >=20
> > no switchdev driver makes use of VLAN port objects that lack the
> > BRIDGE_VLAN_INFO_BRENTRY flag. Notifying them in the first place rather
> > seems like an omission of commit 9c86ce2c1ae3 ("net: bridge: Notify
> > about bridge VLANs").
> >=20
> > Since commit 3116ad0696dd ("net: bridge: vlan: don't notify to switchde=
v
> > master VLANs without BRENTRY flag") that was just merged, the bridge no
> > longer notifies switchdev upon creation of these VLANs, so we can remov=
e
> > the checks from drivers.
> >=20
> > Vladimir Oltean (5):
> >   mlxsw: spectrum: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
> >   net: lan966x: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
> >   net: sparx5: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
> >   net: ti: am65-cpsw-nuss: remove guards against
> >     !BRIDGE_VLAN_INFO_BRENTRY
> >   net: ti: cpsw: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
> >=20
> >  drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c  |  4 +---
> >  .../net/ethernet/mellanox/mlxsw/spectrum_switchdev.c |  3 +--
> >  .../ethernet/microchip/lan966x/lan966x_switchdev.c   | 12 ------------
> >  .../net/ethernet/microchip/sparx5/sparx5_switchdev.c | 10 ++++------
> >  drivers/net/ethernet/ti/am65-cpsw-switchdev.c        |  4 ----
> >  drivers/net/ethernet/ti/cpsw_switchdev.c             |  4 ----
> >  6 files changed, 6 insertions(+), 31 deletions(-)
>=20
> Notifications for placeholders shouldn't have been sent in the first plac=
e.
> Noone outside the bridge should access a vlan without brentry flag.
>=20
> For the set:
>=20
> Reviewed-by: Nikolay Aleksandrov <nikolay@nvidia.com>

Thanks for reviewing, I didn't copy you because I didn't want to spam
your inbox even more...=
