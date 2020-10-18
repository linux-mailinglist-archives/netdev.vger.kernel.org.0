Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078F8291522
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 02:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440001AbgJRAYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 20:24:05 -0400
Received: from mail-eopbgr50082.outbound.protection.outlook.com ([40.107.5.82]:24652
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439985AbgJRAYF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 20:24:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bqhUIQ8vF+hdRj76NNUpuaiO2VZWgiMlTYLTGmW+JBWEtczrBurkD5ByK2jEuWsV7pmBkQg2+0v5T0nMo3rKEK27zeiUT+v22aDT0YWeR0NsIxPEQfMN67sMkgx8485NjzbiUu7KH8XdimxTsbBRumX+2N5GDQloTy8JDFva9PYmNpvgOyq8GqnsVfLZzEfW7HoZ8Pw3WnsXWigFWw4X/UbATfyZ4KRJBLoiHKh7J2jcdRyHpZnQKECsdqwV328OB8NAbrxrKRfDAqSXiGe8vwmP2AGEw5FLqu42uRO/INOE/79IRVr66ip1j3AUILi+dyfoUAqcyVsRyP6/d1uDdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tuXZJ+L715O6tmq0LVtZzKLFq96OgL4X3rcAuWB9urg=;
 b=JjjcfW55n3bYrHGooF6nExKejsNUPFrrPIGlR5XBEMoT+6j/0BXRfJl4NYlFv0jmMBpGHbseYD4hZTV5to9rR/QHxyvQkv1gO6jG07Cs0CM4fFRG/Q5FSoKOn2e2zjvf9XyjsGaaRiG6e4nERzT6gWbXwGgVv0QJ1A5GNq0Jdec4GheZivtAWL/GevBI3W0cmCDQviU2F9SkUMTQsElg5nE2efycXxRj9GhMGwHfE41vjeQ2EPuAMhrNL/WdMM22sVCuyKLucIYZXgtu7MAhO3ie/oIdXYwKeBgP/LcR+pToo/bdHsgMVXnyGnKY838MdRt6ASBUK+OSQ/xPt4re4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tuXZJ+L715O6tmq0LVtZzKLFq96OgL4X3rcAuWB9urg=;
 b=iCNyjxCbP+X0SVFoQLE0vaJBWdEmVV6DH2DYf9msm3B+XTe5lTpWt20npg5QAOEJ76sH1DCIfW1DCT7DUI3lAjljZE8po8gBkvi+vFNyKjO13oSpobSw+/v/tNomiSPKz+jJBtY6RGel5HGAPILOR35pSA+GKgpLqEeaPipcwSk=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6703.eurprd04.prod.outlook.com (2603:10a6:803:129::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Sun, 18 Oct
 2020 00:23:56 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sun, 18 Oct 2020
 00:23:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
Thread-Topic: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
Thread-Index: AQHWpM2VvXEF3YqeV0mNLAH0H5Z1UKmcbU2AgAATBIA=
Date:   Sun, 18 Oct 2020 00:23:55 +0000
Message-ID: <20201018002355.brjei6qfupdxlvtm@skbuf>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-2-vladimir.oltean@nxp.com>
 <20201017231551.GX456889@lunn.ch>
In-Reply-To: <20201017231551.GX456889@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 79e6b3de-8141-4c72-cb58-08d872fc19ad
x-ms-traffictypediagnostic: VE1PR04MB6703:
x-microsoft-antispam-prvs: <VE1PR04MB67035D7740102556D9FE977DE0010@VE1PR04MB6703.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E1FTtfESpDGuLX3XYcI89ro3GgnXu/gVEIjZYeaTuDUvLa8F0DaWvh+O9tzauNWaTiGm6IYSIlu7dTxrpQ4q3i9r28gvZ8HhVsmKh2/TDFjvDeSYfQWYmtOe9c7MuLBzWGp8wbIw5lCm69rSVIVck0/l/w8romm5BLTMyi29nTlJ2phnH2v1Cduk7UC25+/7gFIwPvoruOY+hi3srA19wk+7ZT+AbRADnLWlw/m52n9QEN0jutL9vCoJA/g8r7G+IfscmxOt1+Np5Ejy1FtXHhyajdlO7rMyfiHA82Yr8rIKP/sJJUO29/yQ7Y9GXGsC34VJPeLpe4UtcEc1w9PIhA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(39850400004)(376002)(366004)(396003)(136003)(76116006)(33716001)(6916009)(91956017)(478600001)(316002)(71200400001)(86362001)(8936002)(6512007)(1076003)(5660300002)(9686003)(6506007)(54906003)(2906002)(26005)(4326008)(66556008)(64756008)(186003)(66446008)(66476007)(66946007)(44832011)(8676002)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: wVdLWTW9UrY402CoRVdNtfq0fepMIZxw0nybfOVO5M1KHMZHw+JemGVgH2LtggMftm2HjQjpFUOtA+llqpVShxPsWDcTjm1L8PBpoeuT1TCLNAHtLXZFDxKqhdSucNulb3gxeZZk+pMohPa52JvpFgjQpoeqc7q9t0Xz/AilRPl4tUOQTZZ/Wpvq37fj1NrG0JrSNbLk8aJAcwFTxkfSxsSDwlrf4+Bb8Dj8+KFeTBrf5ni6RjjprexCJEgupS0KYCro1kYllHOVWkLHGXafjWl54yc2V4+6NALiLfzBaBTI0D6DaCRlzhUE1/U39ifSb/3LSCak/qDaRuSBojD2TGV2OHKhFC05rfiTbhkocOiJQBZIf3rDJPbUVVzqfSprzbwszMFdPm2uyqm2QpnHHLkVFpeG3ERRDHzlyhjDyYsnG6Lyvhw6zeYny2vrPaz4/ibZpDg/fW6+iusMyeTvnHd1ytZIJW9NqHijEBCulpm3Ab/OxVL6P22ldH3I4yM7L6Av+CfVTva7eNperENCbke7u/qJ3qeUGYzJe+OdBM3xoAV7Ch2EbhjycXlHWJr/A+fQuOQudmxVIyqUSLlOeIzNn4VWBPORQ9PVueYHjb+29BtSec8CniCnWU/iy8EPzFGtbF/FZysQZI3XCkkjXA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <326AEA3FE568B9408C105848680F3A8B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79e6b3de-8141-4c72-cb58-08d872fc19ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2020 00:23:55.9371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: buCZGLQidjzW+g4rY/sHtUlBUfRp8o3W5FYZDGel+haM8OmJo1Dh+qm1LgkTRp6qHXqk37ZlnPN6/fFqslkIxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6703
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 01:15:51AM +0200, Andrew Lunn wrote:
> > +/* Driver statistics, other than those in struct rtnl_link_stats64.
> > + * These are collected per-CPU and aggregated by ethtool.
> > + */
> > +struct dsa_slave_stats {
> > +	__u64			tx_reallocs;
> > +	struct u64_stats_sync	syncp;
> > +} __aligned(1 * sizeof(u64));
>=20
> The convention seems to be to use a prefix of pcpu_,
> e.g. pcpu_sw_netstats, pcpu_lstats.

I find the "pcpu_sw_netstats" to be long and useless. I can easily see
it's percpu based on its usage, I don't need to have it in its name.

> Also, why __u64? Neither pcpu_sw_netstats nor pcpu_lstats use __u64.

Ok, I'll confess I stole the beginning from the dpaa2-eth driver prior
to commit d70446ee1f40 ("dpaa2-eth: send a scatter-gather FD instead of
realloc-ing"), since I knew it used to implement this counter. Then I
combined with what was already there for the standard statistics in DSA.

But to be honest, what I dislike a little bit is that we have 2
structures now. For example, netronome nfp has created one struct
nfp_repr_pcpu_stats that holds everything, even if it duplicates some
counters found elsewhere. But I think that's a bit easier to digest from
a maintainability point of view, what do you think?=
