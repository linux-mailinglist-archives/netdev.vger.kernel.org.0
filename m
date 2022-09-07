Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B635B0B71
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 19:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiIGR0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 13:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiIGR0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 13:26:18 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2043.outbound.protection.outlook.com [40.107.21.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761BE90C56
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 10:26:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JttnKbf3VuLMi70aphOkzfGxhSPwkP2UDXZEJd0vooVEPmZ/+b9wN7esLlUq+nbEq2nJdhpMIrY16cDHvkYVMjw8uclEHDiq/PPxz2Z43x87ketnbUpmPzz3tSvrois36CLjC6oV+prQ/aOqkD5HvL+3Tr+9bR26Gj3BZqYcUxaC/PdChtL+tUPRyfXx1MmxJ6vdDvFewGSifMqduOeQvYKflNbSGNf/Trth0iQH7Kd8uEizCH5KWIEW8r2YmATiSRSC2TFaVV1yPLbIKzEl6Kido6DMS37W/0b+Yl4RNonc8Jn/fHJ0bEEy+veDqZJ/mXkgouJBpxc55hvJ1s32Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jsSGrOklr90y/rmZKOcpcdV99ToH34E1qCTDn2pDpng=;
 b=FbrMaUzTA6fbxDqXN4YCuRGvvkD1ybLGRAyFTdBu7QBhJstAJGvw/9pBz541hTTDTP3dZjSHr5xBe0Co8eSvNdkKcb+hCp7pWboE69SDmpgdlYIRTgAd9CrIJp7CWqWWukp3WjbX2MCvBqdfh5nBggGTZF4HNqp2XWTUmf1djUGcTOi/m69vp4Q3+k3c7QPtli6UymSbjRHgTklWiKrRo9rfNm8SZngpA096YWEGdh24/GgI4XkxmhoAuFcmze0uvOf3Ohbfn9/loPGH7G3a+9o0uKrXOkGlz9tR6CsPDIMvKZzYxgois4C1yq+3sJV8J/TIlkoAngwU2OlYFof1Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jsSGrOklr90y/rmZKOcpcdV99ToH34E1qCTDn2pDpng=;
 b=jE5opc+e3LtrZIHArSnFkTPx6s6mLr90U4wmcBL/l9xqk4Nfr/pxC94Xd2Xpmgmv+4qsRlbWeHoKIldGKDmizCtu8COJEgAinJmX4NrQNaZdEZzXhlUNCzeoUwvfpgA+ZSNp08atMwRqNfoqSPgtpGlXBA3+vjQCSEBbL5et4wg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6354.eurprd04.prod.outlook.com (2603:10a6:208:178::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 7 Sep
 2022 17:26:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Wed, 7 Sep 2022
 17:26:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Daniel.Machon@microchip.com" <Daniel.Machon@microchip.com>
CC:     "Allan.Nielsen@microchip.com" <Allan.Nielsen@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Thread-Topic: Basic PCP/DEI-based queue classification
Thread-Index: AQHYs6to3s1IQsOvq0mxCyeVWfydNK22C7sAgAPQsYCAAOG8gIAC9iEAgAAg5QCAAItKAIAAGesAgABY2ICABr5YAIAGp+0AgAeuXgCAAG6mgA==
Date:   Wed, 7 Sep 2022 17:26:14 +0000
Message-ID: <20220907172613.mufgnw3k5rt745ir@skbuf>
References: <YwKeVQWtVM9WC9Za@DEN-LT-70577> <87v8qklbly.fsf@nvidia.com>
 <YwXXqB64QLDuKObh@DEN-LT-70577> <87pmgpki9v.fsf@nvidia.com>
 <YwZoGJXgx/t/Qxam@DEN-LT-70577> <87k06xjplj.fsf@nvidia.com>
 <20220824175453.0bc82031@kernel.org>
 <20220829075342.5ztd5hf4sznl7req@lx-anielsen>
 <20220902133218.bgfd2uaelvn6dsfa@skbuf> <Yxh3ZOvfESYT36UN@DEN-LT-70577>
In-Reply-To: <Yxh3ZOvfESYT36UN@DEN-LT-70577>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 821c2983-ffd6-4ea8-535a-08da90f610c9
x-ms-traffictypediagnostic: AM0PR04MB6354:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pYFPiiWmUEP7fD7UzN7tdi67dkTn8q6Nm+R577Fs2DIFQuQs+CXVTFbu4WpA0AnPVX5J4RKV3ENPqT6313GLh+EoFU9jbgYtx+wirWYtOeuzUt0t1EJBlA9EspQufMb0knPaGR98XkvcNVJihZn9gpUhaHKMFLPzHfxB8xtWzPB+/2jtmAWiVVARkEfNgCCHhYVjTZfoi2ZOcwiGEkCEPXPzR8apSic+5BZwRY2eW6nLbpR4KMu3oAwotCuaM4SywMZYEtaHkOr6Rsg7iJd09hx86ACIK3b2OFjNBNQa0YUcCnoCfK5M9wF3IuuFVOcvFUfaR81iZSxU+j8oA16A7E61wItpN1KYgaOf4Yn2VLanQqZJoXYmkwHrGSQ5TdwToNUuMfCHX7JTBEy9C/0hXMkqjH2EYVJs0fyez6jh9vEq35ll19vYNE6oVY9FUCJeahMCuVHNX+u34Z4wO7ULqs72+JCDL/ARPJvxZpLd5vA2d0hG4gbWsDvF3Q/sedYWwBgp9uk7FtLE07JwrDEHBJLccVd00zWmjsWzezbSBjlN+zNW3fWXlRScd4O2qIWK2rjoM42E4Xw/CqyMn8OXwY3N/qAiWRz71CIwoBJexM4j8uJw0Dt7Jmwf0+PyG30VHhz3T5tvz0ADDAkRHFFTU/SYdE9jHsD0LPY22X0cDe/oF3hDXJjqURDerwwf3kXBrZyL7Ij8YTm+DpDa/dqosZ6Rx7NWPZzSD1OFjCbUV0k74zle4pn9tmn6oNryQFYEFUwUj6Tq4epRXxlf5D++Jg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(38070700005)(122000001)(38100700002)(316002)(6916009)(54906003)(71200400001)(5660300002)(44832011)(8936002)(76116006)(8676002)(4326008)(2906002)(66946007)(66556008)(66476007)(66446008)(64756008)(186003)(41300700001)(1076003)(478600001)(6486002)(6506007)(33716001)(9686003)(6512007)(86362001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yiEagCmY4PNLFKIRPpyTqKfgYe7eQ+FXzvDWJRJtawMz6X1e/940fQXVb/8j?=
 =?us-ascii?Q?1XmmcYVq88/o5+HGVq37/14E8LfLwMoczBLfOejJMeIydRbM6uwXoKVYKDRZ?=
 =?us-ascii?Q?/RHQ1SgQSRkZdWfoH+WR3iM8+GSx3pKamoOK355tX0ROMGnXXN50tfDhdSRv?=
 =?us-ascii?Q?24+Rg/kHWZXtKfrWUCRwb7N7/ZkI/TV+7j1kaKcYxz2U2B7/F+QzfyPnlc6G?=
 =?us-ascii?Q?GetIQsjpHlWvtEfQQSgHGcTk0dCwx+xJqFz9KQVEXONPANm5/riEZhJUxFMe?=
 =?us-ascii?Q?Mt78rLQQgvVmusrIpVf0nSPV6DS6NvlASiAJv32sYz+JyAg/GBr7C+OW9XKY?=
 =?us-ascii?Q?K/YDJvM4Pvz3tNq3iXN0cHx1jHyNTEdc7u164hr8UwDqRsDAM94xJuuifEdT?=
 =?us-ascii?Q?f+gDFGTSxLbkxgMPkwRnNucc2/JMLm3urwpG3oCmbATBV8G41DgLmILOaxrk?=
 =?us-ascii?Q?ox/+pp03qufHEK8We//mavWi3CgRyaahvEN+s3kubW8R6mCmEyNoAS7AFF2h?=
 =?us-ascii?Q?s4ej2IKaqJVpnWun8vUGXgPCpmbZnRUTXPc4MRgv++kxcQPDda4HcCTGqtwi?=
 =?us-ascii?Q?+rWlTAgEUqYu5mYGQ6Z96uV1P790hacHKYTd1ROWgOQqChTmP+8jEvSmy4e/?=
 =?us-ascii?Q?rsKnFwHFEIPTohs/a7Q8Hl2oMM/p7f3OtMfkMs/m2+2mqE6Our699U68MLDg?=
 =?us-ascii?Q?AceYKpRLT8dFkd/hyu/pIvOrNMc7eKKIlPltLuiMmz28y/2XR9QOGL2dfxW6?=
 =?us-ascii?Q?sPomy1hllc6XkIj5we5q/y8SxqKLS+jmsdtuyxqOGQX7YYst/G6CgpTmnSsq?=
 =?us-ascii?Q?FtRqnp6Xpgv8BsrR0BvBV8RwtlIYIgGEUuT3tl3rr1ZoI4wUDDYiSTwSReGJ?=
 =?us-ascii?Q?YN73J/d1UVoI33QL/AKMVrBBMOSkiDUH/9Pm+8T01J5SVvIgdFFTlm6WRttV?=
 =?us-ascii?Q?1JTvuXIBkA1pTFPiF6z2S3UqIHal0PNfgQl0BQJYwIjfHehY+IN9b/guoaEG?=
 =?us-ascii?Q?gRRZbcKV+E1VmdQnYF3x30Cq2sjiXBOW0lhQXeIBVsH/g6SL48BqLRZtrkzB?=
 =?us-ascii?Q?huXXoKmbLLPcncMFbE4cOnpmSratl0xhr4aHbX465bqaf3o1nrVMC/dbVwr/?=
 =?us-ascii?Q?qUMm8qqKgylyh+0ishcha4R0JRgv3oTkc6651UTKXHbRMdbbO8zmVF10T/cd?=
 =?us-ascii?Q?Jz8FeKM46pnoOPLi4yOY1bfPK5B68fiDxb29MuGdJtO6Q1BRnZAF24keRZO/?=
 =?us-ascii?Q?ZXHTg5/qDMqJOxarGJTvmqkpxSpmwWB5z9Ml5UkXViTtxukPssGgSYNn+ExO?=
 =?us-ascii?Q?syK8Z4EbPANqy+PUltqXJWaxBUDpPcau9V2zW5n1npcsXS22L/VEbhJOiucj?=
 =?us-ascii?Q?zV9dIcumBnDa8NZT2touOXbj152i+82pgKi2q3mzLHiFNswkrQIzDSsaCMwH?=
 =?us-ascii?Q?sH4OyhYNVIly6+b7c4kmin2dC5K4KBEXLHXYD29eifU6e8fxRLksgwUIESqq?=
 =?us-ascii?Q?lSIonLrbRP1vbLikC1BTtQ6jGxUF29eUIQQ80Gj9Wnug6vvhvJ2kDoLc1BrU?=
 =?us-ascii?Q?gJep5yVw3Al7o0SFMDruXSs9240RxH1XSRzoiWoVgO5haHD00Tgz48YoRfFz?=
 =?us-ascii?Q?5g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <46905A3E3DF6284E924F885C5EBBCB31@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 821c2983-ffd6-4ea8-535a-08da90f610c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 17:26:14.3705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ytH3jm1uz+ZgWLEouIeky99ugen3f3uSfBUkvmiHipUCVsVZ4QBfpFELberUhUCR3fRHN1eB/CQK1p6HyOc05g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6354
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 10:41:10AM +0000, Daniel.Machon@microchip.com wrote=
:
> > Regarding the topic at hand, and the apparent lack of PCP-based
> > prioritization in the software data path. VLAN devices have an
> > ingress-qos-map and an egress-qos-map. How would prioritization done vi=
a
> > dcbnl interact with those (who would take precedence)?
>=20
> Hi Vladimir,
>=20
> They shouldn't interact (at least this is my understanding).=20
>=20
> The ingress and egress maps are for vlan interfaces, and dcb operates
> on physical interfaces (dcbx too). You cannot use dcbnl to do
> prioritization for vlan interfaces.
>=20
> Anyway, I think much of the stuff in DCB is for hw offload only, incl. th=
e
> topic at hand. Is the APP table even consulted by the sw stack at all - I
> dont think so (apart from drivers).

Not directly, but at least ocelot (or in fact felix) does set
skb->priority based on the QoS class from the Extraction Frame Header.
So the stack does end up consulting and meaningfully using something
that was set based on the dcbnl APP table.

In this sense, for ocelot, there is a real overlap between skb->priority
being initially set based on ocelot_xfh_get_qos_class(), and later being
overwritten based on the QoS maps of a VLAN interface.

The problem with the ingress-qos-map and egress-qos-map from 802.1Q that
I see is that they allow for per-VID prioritization, which is way more
fine grained than what we need. This, plus the fact that bridge VLANs
don't have this setting, only termination (8021q) VLANs do. How about an
ingress-qos-map and an egress-qos-map per port rather than per VID,
potentially even a bridge_slave netlink attribute, offloadable through
switchdev? We could make the bridge input fast path alter skb->priority
for the VLAN-tagged code paths, and this could give us superior
semantics compared to putting this non-standardized knob in the hardware
only dcbnl.=
