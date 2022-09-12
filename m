Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4A35B621C
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 22:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiILUXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 16:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiILUXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 16:23:32 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00078.outbound.protection.outlook.com [40.107.0.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55786491D2;
        Mon, 12 Sep 2022 13:23:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZC0AzoiAkd6a7VmgRWeU4oJH54avM7mZeuYf3C6GP85gftblY7ijtsLxXK2UYQSG4Piw1WF4NY5xi49//CP0rzs/SbnEkwKhbNOXOEZgXh4bFzeje6A20ryGSuetJTNOV0/ByNEAvTSkpkZtCc0iGWOJWeAV6Wkhu/n84SzqNEkHiMyCW1W/Lt50pTD2TG4WWbxSd3TYS52ca7pfPYreK0ujPVW1ao7rHgz5BgAfEdDJF5Hh0vlBZRhXNghBNVb2shINzerq98GG1IKh86Zmac1ddxkHAmr8RZQ6uARj8vWK4/8SiQaatBgHXfOBnX+WzSn/FhmV9Qtz3VnNwB5Gzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EcRKqGlKLNr8RUSSWRHvReO5yggjP1O+qPpyFvYe0Mg=;
 b=fjwxEBPxooHneLijqMCIGfxQhNk5zEKSFV3aY96FfOuZh2qvVYqd5e7LfiXSkuN1TS+hFR0T3K7ipcID4V2aGYvdiPsMRT45QNlKzKnSbBRZgCehYQdwLoDg86L1OVac5PEzJ4suizf+MQKo0ZHfXDdTvKEih1gpBpNPo6urqwxF5LtN/vz0cHpMPwdFBDnV3Nag6Pb98Ex1oxpVt5Nwo+ngkftJGrBMBDZ/CHHf4Un+bZI7fn1gXt4kDnhIBvcYN/S2OJO6+AYO5N5tc33Yc08JXOhET3AgRJQSKCdWhmkUlLpSCGba0/ZNIY5XGHBOihJ0tVziutHxmG48gAQ6fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EcRKqGlKLNr8RUSSWRHvReO5yggjP1O+qPpyFvYe0Mg=;
 b=FaJ4aXfyjq2Wym0XkhuUHvVMiKP+WbwFzwbMU2LFb5QdbSdl50OSxOoRzWdZ4seB+hShRh4KB4efxeA4veHNRR5x5RfZlbkoLc+VRFZQtToRuSz9CFpzEi1sTURamv8TeoJy9nIgX+dcSt3ipJnfZDIs2pEa4HWx79BuUXAKk5k=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8092.eurprd04.prod.outlook.com (2603:10a6:10:24f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 20:23:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 20:23:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [RFC v1 net-next 7/8] mfd: ocelot: add regmaps for ocelot_ext
Thread-Topic: [RFC v1 net-next 7/8] mfd: ocelot: add regmaps for ocelot_ext
Thread-Index: AQHYxhmBZYjSTVdDzkG5f4rICTpo5g==
Date:   Mon, 12 Sep 2022 20:23:21 +0000
Message-ID: <20220912202321.5yqmmf2j7gcljg4j@skbuf>
References: <20220911200244.549029-8-colin.foster@in-advantage.com>
 <20220911200244.549029-8-colin.foster@in-advantage.com>
 <20220912170808.y4l4u2el7dozpx4j@skbuf>
 <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-8-colin.foster@in-advantage.com>
 <20220911200244.549029-8-colin.foster@in-advantage.com>
 <20220912170808.y4l4u2el7dozpx4j@skbuf> <Yx+CzUCbNgAjDK5l@colin-ia-desktop>
 <Yx+CzUCbNgAjDK5l@colin-ia-desktop>
In-Reply-To: <Yx+CzUCbNgAjDK5l@colin-ia-desktop>
 <Yx+CzUCbNgAjDK5l@colin-ia-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DB9PR04MB8092:EE_
x-ms-office365-filtering-correlation-id: 5d059e17-6e38-42c6-f868-08da94fca33e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dP+7VM+zT8b69JhCTz1uqfmODcULrxZAUsyZ8UKAfDICy2gPnmZDyPOirUenQvqY0FsTOggixHXqYQU/gZZO61dACURRLzV/HLOsBzR+s7sCk+Qdk8D4/3EKwaCfJQ+WmWyX90SK2SA0SKQ4dfoAn8jU9KGjVmymAitro8MXm9XD3UXUBoEWSV9avyzLAIiZs7oCbtmuZvzSsu7sg4iAficQqBS4K0N34MhRVMSgKFvtSfky8avJDrTH0u2EwUK/UH1429ToMo7gmUCfWVDBYavTDwAP7fZC9TkZIgik+qv/hnf2h5ps0zhX+Udy0iuphobdhjE2nbcEq+IYkbVw5XZmGH9+kQqDHw4uXuPDn91KmZpNu2O0lKGAhZb4pelm4gay5ut3P9OHuI9XE6epS7op1vzfRzEjvU6RIBOHxZ0HpCy/3kZVBqcKH4a7ftT5+Wf+AJfuhNVH7iiMN22Zr8GYUXCWo6UuxPp1tTCz7m2of9fz+J/4gK6UNvDF+kO0A4UoJ4EVqFE+JtCRBBO+65bxOoWYU/AQvzpRe9iFqYoMRMUCP60aIllaQZla9T4sqmxPBDImzx7bYvuLN7XuMutnkM8rjgQ6HFUt/rTBCor/h264xDi1Uzuxaz5zHbSNXyfdNA+GVNJsZJA8T4llLG4lFC2lEWBj2UdXr7TEOi0Dk9UI7rBsB+Mb6SIR4Lzdtkj9awbbOjmLPScS/dm5Rr6IFjWuVGQ9b7faZmoYBDk2GSsuXKfgGKd9QNYyIyWebvVbMaCbEDODT/imvPcBGQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(39860400002)(376002)(366004)(136003)(346002)(451199015)(33716001)(54906003)(6916009)(5660300002)(8936002)(6486002)(316002)(7416002)(71200400001)(41300700001)(478600001)(122000001)(38070700005)(6512007)(186003)(86362001)(66946007)(4326008)(66446008)(76116006)(91956017)(64756008)(8676002)(66476007)(26005)(2906002)(9686003)(66556008)(83380400001)(1076003)(38100700002)(44832011)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uFIKYBJ7dy3C5QWnyn5HZtv+UyynzZ/bq4+fgi/xOfS5bVJcIa3bjfnDWiBu?=
 =?us-ascii?Q?Qnvv/O/F+PoXDWt3NJn1UTP81QZOJ8AgenworVaWZYrGGSSg+VRpI2yZqyvF?=
 =?us-ascii?Q?FOF8zELXbRPtyo4KiKyVp6gj92Fq3Nak+uHDYqhIggOsNi26/YuKc7IeHqZL?=
 =?us-ascii?Q?8kcp0pCxTXwuACGOuABMcuZr1+6fwRX6ftNAeizIE453hd+IDxjeJb3xFKj9?=
 =?us-ascii?Q?WDSJsZ9sJKdglvP/c/lTATwMbXlOPaWyom6Ok0nPwdNT/S9PRy6LxJt6mDtP?=
 =?us-ascii?Q?MtIRoikzZSRERb9ZzbHcnUNHo1F4zUkdlW+PtuaK/b/MUFyXRiypMCmf0aXK?=
 =?us-ascii?Q?yzNtbPkVK7qggnReglmIwroF0rV46TUpEWXC6mU6DBk9CVd6b4Gxd+aqfdiH?=
 =?us-ascii?Q?ro6be4T5VYKtDNYAcg3DA5HHxdnaax8WUPUxRZYbKZScDccoteb+ljH0TVnc?=
 =?us-ascii?Q?swFM2K5vEJdGSYPEi+MWu3uaghTYyRdRqwhO+NXXVzQUg4tmIaRObub8SZpB?=
 =?us-ascii?Q?GIlKjHXcaZ8xOxNpOcfFyca1q53locdOaMQ6SHY4us7G7tvjKlJ5JESAy6Mz?=
 =?us-ascii?Q?1IvDeJt9YDbWFH1KlhUD+6vsFKplHeSjgz6YRiLFUq3njpHw6aWbI2vD9A0X?=
 =?us-ascii?Q?vRJDMiYPBjXpsZ0wLBMOAJqvjfW01LCtP2pBW8lDM3NH9U8wOxfkdpSINWB3?=
 =?us-ascii?Q?4hydtb9ebjBuy4u9easO9Fc9MHEYy6qQpDrtVarPJp/jsmuf9xJ3EF4OLu7p?=
 =?us-ascii?Q?E+KI8FUq1MI9As+hBIzHOz+XktQRP6qb8VVocTAKe8Thmsqey8HH+xkZzhht?=
 =?us-ascii?Q?Eq3S8bgC37fOaTe+5qYkSWcQVj60tZfgYReH7AwWpOxq9MNaZKtgSAzI2aDR?=
 =?us-ascii?Q?keq5i92mCJOthGZokAdHPUHmQqr2aKNiztliFJXjHRRRjbqGX4fGu7/ze1yQ?=
 =?us-ascii?Q?3i8m1pO/GabCiMmNyDdCPyUtwqBl2qyv2BzwogzuvXL5etJxDKwjKiaL+6Ol?=
 =?us-ascii?Q?KIsjDLETynvA7E9eb39IuONwZ7awdQtWe9IXWV9End+m4nn/MtnLIPMF87iV?=
 =?us-ascii?Q?Tbx6PcTmYnin3UGp87jKjVLKOa3Ly5edIz03ZfFNO/+OwlAOZxe6EHbEmiw2?=
 =?us-ascii?Q?qFbOwHhpFvN4G24SSkW8Ojh/qk9M9geFEuHml76ZHPoG3+03Q9LiG0aKqNmy?=
 =?us-ascii?Q?6lQnXrJY1BRRGGxRXOgdkr4dOJ0f8y73wGnAmuQzWSQlyHmdFWkH2FoLth3x?=
 =?us-ascii?Q?lSBP98ACQd5REYguvYkKNATLCYC/MXKhw8a68zyLAeAIrcCD5kA9sDKVEYA9?=
 =?us-ascii?Q?tlspsG6dtsrJMtxXZ4V9VWdNg4yA8H7P0NqhW8ThW+G6F9RnCByWhh3tTypD?=
 =?us-ascii?Q?/abhC4+BjlQVq0McMgztoC3fGd9iKk4Ni6Z6axiJwFEDeDqDT6NHG/8JKmL7?=
 =?us-ascii?Q?aQGFoSi6L5ccFnP43IYdMyUZ3mwyOX8yNGftcLiNam+EyrWbD4gP2d0Mydp0?=
 =?us-ascii?Q?Vs0fwo8EMkqYYrw1oK0f1XUzTbloZH7EW874kRgxuwkfMnHLHVNhi9vQo722?=
 =?us-ascii?Q?bqxKacasy2+rpSsxWMpF3HVdgYf760YyLEwPVNzlH1TRxlb0yWZ1w1XUNB4F?=
 =?us-ascii?Q?4w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7551AEC9F015F2479A37EAEE40CBA572@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d059e17-6e38-42c6-f868-08da94fca33e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 20:23:21.7672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AXUd4uYI6ViBOjgIfUHxX702fIGVFq26+ShFZw1uHzMJvJeG9wAvuHeN8msGF0lLJAh5D8MEvE3l1pj8v25ovQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8092
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 12:04:45PM -0700, Colin Foster wrote:
> That is exactly right. The ocelot_ext version of init_regmap() now uses
> dev_get_regmap() which only cares about the name and essentially drops
> the rest of the information. Previous versions hooked into the
> ocelot-core / ocelot-spi MFD system to request that a new regmap be
> created (with start and end being honored.) A benefit of this design is
> that any regmaps that are named the same are automatically shared. A
> drawback (or maybe a benefit?) is that the users have no control over
> ranges / flags.
>=20
> I think if this goes the way of index-based that'll work. I'm happy to
> revert my previous change (sorry it snuck in) but it seems like there'll
> still have to be some trickery... For reference:
>=20
> enum ocelot_target {
> 	ANA =3D 1,
> 	QS,
> 	QSYS,
> 	REW,
> 	SYS,
> 	S0,
> 	S1,
> 	S2,
> 	HSIO,
> 	PTP,
> 	FDMA,
> 	GCB,
> 	DEV_GMII,
> 	TARGET_MAX,
> };
>=20
> mfd_add_devices will probably need to add a zero-size resource for HSIO,
> PTP, FDMA, and anything else that might come along in the future. At
> this point, regmap_from_mfd(PTP) might have to look like (pseudocode):
>=20
> struct regmap *ocelot_ext_regmap_from_mfd(struct ocelot *ocelot, int inde=
x)
> {
>     return ocelot_regmap_from_resource_optional(pdev, index-1, config);
>=20
>     /* Note this essentially expands to:
>      * res =3D platform_get_resource(pdev, IORESOURCE_REG, index-1);
>      * return dev_get_regmap(pdev->dev.parent, res->name);
>      *
>      * This essentially throws away everything that my current
>      * implementation does, except for the IORESOURCE_REG flag
>      */
> }
>=20
> Then drivers/net/dsa/felix.c felix_init_structs() would have two loops
> (again, just as an example)
>=20
> for (i =3D ANA; i < TARGET_MAX; i++) {
>     if (felix->info->regmap_from_mfd)
>         target =3D felix->info->regmap_from_mfd(ocelot, i);
>     else {
>         /* existing logic back to ocelot_regmap_init() */
>     }
> }
>=20
> for (port =3D 0; port < num_phys_ports; port++) {
>     ...
>     if (felix->info->regmap_from_mfd)
>         target =3D felix->info->regmap_from_mfd(ocelot, TARGET_MAX + port=
);
>     else {
>         /* existing logic back to ocelot_regmap_init() */
>     }
> }
>=20
> And lastly, ocelot_core_init() in drivers/mfd/ocelot-core.c would need a
> mechanism to say "don't add a regmap for cell->resources[PTP], even
> though that resource exists" because... well I suppose it is only in
> drivers/net/ethernet/mscc/ocelot_vsc7514.c for now, but the existance of
> those regmaps invokes different behavior. For instance:
>=20
> 	if (ocelot->targets[FDMA])
> 		ocelot_fdma_init(pdev, ocelot);
>=20
> I'm not sure whether this last point will have an effect on felix.c in
> the end. My current patch set of adding the SERDES ports uses the
> existance of targets[HSIO] to invoke ocelot_pll5_init() similar to the
> ocelot_vsc7514.c FDMA / PTP conditionals, but I'd understand if that
> gets rejected outright. That's for another day.
>=20
>=20
>=20
> I'm happy to make these changes if you see them valid. I saw the fact
> that dev_get_regmap(dev->parent, res->name) could be used directly in
> ocelot_ext_regmap_init() as an elegant solution to felix / ocelot-lib /
> ocelot-core, but I recognize that the subtle "throw away the
> IORESOURCE_MEM flag and res->{start,end} information" isn't ideal.

Thinking some more about it, there will have to be even more trickery.
Say you solve the problem for the global targets, but then what do you
do for the port targets, how do you reference those by index?
TARGET_MAX + port? Hmm, that isn't great either.

What if we meet half way, and you just get the resources from the
platform device by name, instead of by index? You'd have to modify the
regmap creation procedure to look at a predefined array of strings,
containing names of all targets that are mandatory (a la mscc_ocelot_probe)=
,
and match those
(a) iteration over target_io_res and strcmp(), in the case of vsc9959
    and vsc9953
(b) dev_get_regmap() in the case of ocelot_ext

This way there's still no direct communication between ocelot-mfd and
DSA, and I have the feeling that the problems we both mention are
solved. Hope I'm not missing something.=
