Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D955F4C50C7
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 22:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbiBYVg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 16:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiBYVgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 16:36:55 -0500
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50055.outbound.protection.outlook.com [40.107.5.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5C521132D
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 13:36:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMej/JNvppMju1RuvB0psciEMeghgifSStOLGmQjMmQgR8vEe+ME/dZO8wI2Ssxt7tsnpJXtJpILXiO+8rZUPiE8UVHHPo0IPbLyMPRCKnLMFPpw3V64a5AabXNa4wBUeDktGqykYmqKHynFnWeolx9SWPSBGcFOhWLlO3Fj/G9ujz56r4KOdq0xbFDBEBvl40BZpSFsYdMxdl4nLCRV52GmmcYCLpG2tOiPrEdzjEEfrUQo5cbp9sA7L3vgovH/AqnYo+1DJ3v8VZuVKXEEurtf8q2N61Aa63N8JWW0S6YMWdexAxUq8vUhs4sxFGPrXjwOUWcj+Ta57ZQjBHa6Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ni8hCjmcNCYC3rejWKftMHI3uex+YLN4trYAbhJIKyk=;
 b=TbntrYOvULrODtVE4amrw9uCBce6SbvWrkFKy5FlKsGGhI3fdjtB1a9P85HJTBQt9KPQ4rWz51YLGTkN2qAihRG5gTdmM9fxVAztsEze1DBF6GsPYL1OJDnQlYaXpFvPQO/SFnS8YAdIMaHLjpnQNvahkHXOowzTihADZUAmCcy2nRXhGZfoE6u1qMXn0FF6++4l7Z5XjaXUM0Pia1TekDoVm9i1iVQh/01KUJu/JC5PZnXbY3wzfitj9ASVF46kR6jSAVXZQwS0K45GCHaLEUkRP+cpzMKIgGas0Xn2epJM00HNV0YbYGCQCF7gwnlBujyP14soZ5JlXNXWrB2g/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ni8hCjmcNCYC3rejWKftMHI3uex+YLN4trYAbhJIKyk=;
 b=nsnSyKCv+mjU1Htqvk22K71JzLKuBMPlz4vNEtu9piWMvxvM7O1pQVcxnRheMduDbppMNlbc8TWB0QEYK0t6G1it3JW411Ot6zzjESmQlkAZolHgKklTvkecjnnATR52Ul0xo1fsy9b4wthIT7oCUZCKRQr3ncWoh4Mq36UOhjQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Fri, 25 Feb
 2022 21:36:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 25 Feb 2022
 21:36:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2] dcb: fix broken "show default-prio"
Thread-Topic: [PATCH iproute2] dcb: fix broken "show default-prio"
Thread-Index: AQHYKmr2C031ApnS7EOHZQ84Pej0qqyki+kAgAA9HQCAAAGWAA==
Date:   Fri, 25 Feb 2022 21:36:18 +0000
Message-ID: <20220225213618.wkoch6zbxqhtqotq@skbuf>
References: <20220225171258.931054-1-vladimir.oltean@nxp.com>
 <20220225095154.7232777b@hermes.local> <87sfs6d434.fsf@nvidia.com>
In-Reply-To: <87sfs6d434.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: accba3b2-680b-4306-7453-08d9f8a6dc0d
x-ms-traffictypediagnostic: AM0PR04MB5650:EE_
x-microsoft-antispam-prvs: <AM0PR04MB56502D4A6C6C5EED75254CD3E03E9@AM0PR04MB5650.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E+xj2effJYdgPbHXPzJqi2WYtArxAsHJbV0R20h6b9upoRU+RJlFMpdjeVMMEt4r0RMF71K9eQmr0HcB5PXVlPqQGzDAmiysanLMAW4GTs+0K/8kuq5ZRarUGm16gdUS7bksC70XXuwiTy1NiBh2Wr2cNLVe1YDp3qVgGB5puFIgyTBje7OqW+j/0AcD+S2vRk8RGXTHUMax+pUGdXt/i68oakw68JD9Z2xPbytoGjWsS11ZD7L5u/sVCgJsoSSf+a8YyNTM1LyT3DBGMXa7jkJF0s+JnmnZSwP9m9iSeKGYH1IhJPN2xEWm6QqxhcM5iad9Hsr1YPysGlnF9sIbdD5DDimcmfEakdOoeQF1XCl0bsGzdS1O7YmoTGkkvxUF9a6fFvwywaC66czdIumK0svGAZNNXUjPOSzI+D+s5obQlRrvXrIrshgRLhRklk+rfqyQmk+TH8kezeEmr7o8YcB2ipsp2v1l3zirL8WBI9dXQ23yl4dSzAHF9ystiy/rvEIfmz2paZjftj8r7Nc4SOfD29AyGv+XOrXuIX1l1NYYKVV/j66kJDqi2h6eDcwzlS7z/fF7L+i9X0GrdUo8wFL9aN4jNeZ7GdunnWDRQOTL5ntLBK+HkgK/46HWvemDqxCYfylGH4JuCNCLzhNNwReb7j3NnKQYe6IQ2gZNrG1u4j1GNQpC7rSuxAw8PcvoQFR/RAIuKEhONZo5dA7bdOIIlaELpDmjzcIsyaiaGe3qbwIh6e7vVC5mNlZYIep86OG/Lt1nztQQrvv3laiV7TACgDdDfvXgITINaT73IZI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(33716001)(26005)(186003)(38100700002)(122000001)(38070700005)(86362001)(83380400001)(76116006)(66946007)(64756008)(66556008)(66476007)(66446008)(508600001)(8676002)(4326008)(71200400001)(2906002)(316002)(6486002)(6916009)(54906003)(966005)(6512007)(9686003)(4744005)(5660300002)(8936002)(1076003)(6506007)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yvWgSg4eWy0xuybgeX6ypZV76a72fyrM2/DEciHxOCke3mxscETXq4w3tIJp?=
 =?us-ascii?Q?62msZn3RV7mJSZfgmJRV+OoUhmotPtTaBN4U9cyjrOAMJ7EuD4pWu4KAKHjH?=
 =?us-ascii?Q?YVPRMWehnFanWa/K5Ho9b8nuMkMClhG4q/Upx2I3Pa0PbWrSu/3gqZ4Rw66V?=
 =?us-ascii?Q?A/n8xHlGIFvWA0G8bz068wALOetSYYFATgU98OaiOaYiQdAa31JnyA9xMMrD?=
 =?us-ascii?Q?+1yb7GuL3uYn296122nGwVXn+fMmfcvja735JwvOO79nU8WOqhjMSEEOgcWz?=
 =?us-ascii?Q?yvzD48ewQRtsIyTYilzlacjgog8S9P7WT53gj8APVaHfzn80KqvITlcAQNLQ?=
 =?us-ascii?Q?r/98bzoOYwImE6sRKTi8xFvTyy4RMoHsKKzdMDyLccCMTxkx1h2kdQdSHIoG?=
 =?us-ascii?Q?//ADL3fqlcjHQ0x+2yadblMJLWAUCunZv7wd2To21Rj1yrSKR90RRf1yX8ET?=
 =?us-ascii?Q?JlLI2RNad0Q9iEt2x5CODKnm/BA9nMp5gt0SR2y6qStdC3+SiZ5Ry7uaHRAA?=
 =?us-ascii?Q?9xrG86Z3e60I8MzGTxsDQgquRj1ledGjcAySzGQ0TzPEfYTSTX8LfveLKrQ3?=
 =?us-ascii?Q?ISAn79lbyv0DdhbtTvqtOIRJ91dG94GNAjUM2xIYkQhCxvkMMOnfBjOf3gn3?=
 =?us-ascii?Q?oSvKfc88uLk8J1baZqk3xbHiWp/J2P5MNXyc65ZI2Zm8mD107oNKUeP807yO?=
 =?us-ascii?Q?YhPuVPbROjaM8An/8DB+j0EP24hPr9S35N43RoTYhxX529XO6yx87SrF++SB?=
 =?us-ascii?Q?bXqsKeMMPnjN9H8Cgp+d5OaTcsXdApd0sQsGKOdZMfmreQjdrUqAjDDdOZYh?=
 =?us-ascii?Q?GLJ8pPHfHeeZixQ4isR3Ku6cP9jlxm4K1bZ5+/oqZT+/d50SIyD9nNN1tx8s?=
 =?us-ascii?Q?+imppT3hOW/O6fPFb9rhv36QrRvScrmRtXaAPvUECY+/sGy8r+uSwSYvimeR?=
 =?us-ascii?Q?CbCBg00S1OW134PfUGfDxN1Xs2qctD1mjwfj47iGDMnJ9u7Uxi72pRhFVxpC?=
 =?us-ascii?Q?ydr/tpbCfSus5oP2PE1bNgRrNxKESkXM7dj0mfx+vp4oTDsTUMx939bvKpZq?=
 =?us-ascii?Q?AwSRhA3JyY4pc98SeZCwp8dtlZpgpQRxToSpWy48zm5gkABpC4xIDxBSf6nd?=
 =?us-ascii?Q?Se9swuPdRdJA3BL13/ksGiT4tm4SkDLb8/DuvZ4goFadaDPRPQR1JJyFBud7?=
 =?us-ascii?Q?XR8dvZqMgU+YrXeqxfeR9CtM76pfcYCbAS2Gx+AZn7IBj0fYIwc2kWWZFPJ2?=
 =?us-ascii?Q?etOjWE47P9mSjLjgyf+q9knZam/owvmw5Ld0iVjGRJwaBGcPRFW/SJa55sfH?=
 =?us-ascii?Q?n3LLJuWub5bkjgzS0Awt1DknRPhZnGLfQWIDgVMDyYgcXICUDsyV+YQLU+1A?=
 =?us-ascii?Q?Zi1r30U+hqgTODCQYDcl8OcPsBwmiVaKcM5VijX5r2MqRPOdMySnlmN8dNV9?=
 =?us-ascii?Q?8kIwI41EmY8pkDGICF1AFTG0AS8TZk7x8p5cBbHrS7fSP0On6SPIn+Y66CaC?=
 =?us-ascii?Q?b9PHG6I15pFElSim3UHUst5Y9Y4hJt8rAmuTiWNNmot2wT6NocHe7z/l9M5w?=
 =?us-ascii?Q?omhvDgazEgwgLgFnE3QtQvdXV3U1UjM0pjCH1llo/gp46m1DMbT3AM0cg36/?=
 =?us-ascii?Q?19MQ5t6B4eXZSu3dKCagWpc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0B24DF81D3E47544A2C7E3FD72B11D3C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: accba3b2-680b-4306-7453-08d9f8a6dc0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2022 21:36:18.8827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IeZ3+uCGpxsr+yPOwfSOOxli3HcRl6QrZA3n0U4xLjajA/mz8PJYUoIC3JsqVbR4eKCGAYxw0mak7xncjxLX+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5650
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 10:30:38PM +0100, Petr Machata wrote:
>=20
> Stephen Hemminger <stephen@networkplumber.org> writes:
>=20
> > On Fri, 25 Feb 2022 19:12:58 +0200
> > Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> >
> >> diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
> >> index 6bd64bbed0cc..c135e73acb76 100644
> >> --- a/dcb/dcb_app.c
> >> +++ b/dcb/dcb_app.c
> >> @@ -646,6 +646,8 @@ static int dcb_cmd_app_show(struct dcb *dcb, const=
 char *dev, int argc, char **a
> >>  		if (matches(*argv, "help") =3D=3D 0) {
> >>  			dcb_app_help_show_flush();
> >>  			goto out;
> >> +		} else if (matches(*argv, "default-prio") =3D=3D 0) {
> >> +			dcb_app_print_default_prio(&tab);
> >>  		} else if (matches(*argv, "ethtype-prio") =3D=3D 0) {
> >>  			dcb_app_print_ethtype_prio(&tab);
> >>  		} else if (matches(*argv, "dscp-prio") =3D=3D 0) {
>=20
> A fix along these lines got merged recently:
>=20
>     https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?=
id=3D924f6b4a5d2b

Ah, ok, I was on iproute2-next, this makes sense. Sorry.=
