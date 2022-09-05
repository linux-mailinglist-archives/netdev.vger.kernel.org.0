Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1976E5ADA69
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 22:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbiIEUwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 16:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiIEUwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 16:52:33 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70050.outbound.protection.outlook.com [40.107.7.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E804E633;
        Mon,  5 Sep 2022 13:52:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BkcSvSs1xRORlFKIYdtqKXjZ9ZMytlTZenOxU7DBLchJpy0sSnz4Tq8pF03X276owTVfAN9DzeXGYgyqIjVjlsCXyc1GE6tN6q5ahPlVp5gooUza+mpsKGFg8/Hmp2UvhPenZmwYotxy383jGkzNrHPjonCd4aP5CQfOPn7eyTak+PYLWXUkE4EaFU+ErL91fGezqhwoNgzgNPdLWDQC5P1fEsIrehhC5dRVKvylMgT8bLVhnwSF7J3WJ6q28YH/0BQjSvK4VQGKoA+hQfBaA69gYXRlqJdC+qedW9IHKrdIg6EaT5kryTnUe3K7fP72MszsGPhUPfdb6VlPgzlV7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VmsJoXRKUWQasDhqjwoySuToSCG7nZiaO2Qo/egp4G0=;
 b=iGAeyWfMebUgn38ehOe2uDILKTcMYS+IMyGg+orDSo9AwevR19eA5DVC8CukxibeXlQpKP60AEfBmUMCyz7bakcJ68H6fotQPe4Ajq+Sl5BP5GlUT7PxlER/TST3Tmwv7qBF+m3u/x47/MGh4VlxX5+k9vlAEVHL/rZyVnoEZJw8jTt8OZfkWIARXiy4yWvr4fB5qhBTjzSYqVL0b94Fo0U3EV9nIheR9PG6zFAQ85CfhSt0UUkBqaWcaxpmjRmd8ZogBoCiqUAJEvfe1nDYVfo5kGr25HrU9pmrKtm47LL0o7yLfeDLb+ztup8N4WyLt6ATB9DP5IPhNBCThX04zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VmsJoXRKUWQasDhqjwoySuToSCG7nZiaO2Qo/egp4G0=;
 b=iGGRnrzu4gLnojNq8cqrTfheiTvgqDDMwr0Xs4hgcUfk9I6MxGAF41nc64yDp5eNvlUI0/ul59l3NiUWwNvPKTd3WPjJrEJGP9nuZY9Q1t2Fu6zXQKr4UtXDtugOjXGhglvlhZDGpblhxiPBJz1Y830qsHfddDPlO8dc5JbbTts=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4378.eurprd04.prod.outlook.com (2603:10a6:5:30::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Mon, 5 Sep
 2022 20:52:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Mon, 5 Sep 2022
 20:52:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Hongbo Wang <hongbo.wang@nxp.com>
CC:     Andrew Lunn <andrew@lunn.ch>, Hongjun Chen <hongjun.chen@nxp.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Walle <michael@walle.cc>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: Re: [PATCH v1] arm64: dts: fsl: ls1028a-rdb: Add dts file to choose
 swp5 as dsa master
Thread-Topic: [PATCH v1] arm64: dts: fsl: ls1028a-rdb: Add dts file to choose
 swp5 as dsa master
Thread-Index: AQHYwWloKW9cDE/UY0+p0/SQtViTdQ==
Date:   Mon, 5 Sep 2022 20:52:27 +0000
Message-ID: <20220905205226.hwrnjx6qnrkdjw76@skbuf>
References: <20210813030155.23097-1-hongbo.wang@nxp.com>
 <YRZvItRlSpF2Xf+S@lunn.ch>
 <VI1PR04MB56773CC01AB86A8AA1A33F9AE1FA9@VI1PR04MB5677.eurprd04.prod.outlook.com>
 <20210813140745.fwjkmixzgvikvffz@skbuf>
 <VI1PR04MB56777E60653203A471B9864EE1FD9@VI1PR04MB5677.eurprd04.prod.outlook.com>
 <20210816174803.k53gqgw45hda7zh2@skbuf>
 <VI1PR04MB5677BA91547DC2228F615CEFE1FE9@VI1PR04MB5677.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB5677BA91547DC2228F615CEFE1FE9@VI1PR04MB5677.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3aabef84-bd1d-44a6-7c02-08da8f808afa
x-ms-traffictypediagnostic: DB7PR04MB4378:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zdWeFLd3spvQCANAKGaMyL33n12T4pE3if9uhl6epnAWTf7DT4aVAanjRr+ug+sukB0ApXBMSnC7tuWUjcFK5gL8ucS74QdARl02UF6QQhSdrH4wu2sVk9ipQrs7eL5WaO1sDaZYPZdo17/4q8n7RaUp9iWWwz/R2dwquc8su+uKkU5OlNQ1QEzDcIEp8sZuU0bT4bf2FaUAtDjjs1Aulh8/IakmJW1T+j1mYDdK9AE7JBrEKz8ipI+cqAvdV89XtQdm75s5T9vRCioPNf+1Cvm9Y3adHj1Pqd7WJZFLFyBgIxEmZlxRLFMEfEFQNisjtuBLOVBW7i7mFsgkuGgPF3oyEmCKSoG3Yu9AL7Vg1z8IIVs1+xMjBSnYImr9R0+xoffuYWQQ7vlZr6N/T5SvkuBqQ58xgVAaPAcOY/lGJX8MhzZ8ALqrvzUCiEVJZ6FE1bDmyOZoUAtjrbrfvG1Yx+C+CZw2uvsb6uO7CWENMeRE9O747T/MDnsUuBN7M4Q1RMqvZse1IngtXxYzmvDEswAGGR4M9jpMf1rtc70KfYoq2xFszI+Iji9IT3Ixxuk9GqOwtJQQBtemD2Xrl6XbsA4RqlHTkH5lKJHu5SsHpsMaWvJLagC50lZLFdNyGNCCkg+sOUzAAm3nu7jcYUrQVf4TQUNwfFK3bX9aMChi1Zu5uAU1bN+98GV83U8YQHuFQvjYQx49ga7kiuP3pK+pNWBM5UpH4eoHaSpvIBsnaFLdF9zXpIwKdOWE6GQsb14RvVLxV+dU6651ZXmV18I3Q9yZuU2JJbnTnubUOQi2VB7Q23PHUekXWFXNrTYmMz3WYt0qr991okHR5OAVzQH6FA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(136003)(376002)(346002)(366004)(396003)(38070700005)(8936002)(6862004)(54906003)(6636002)(316002)(76116006)(86362001)(966005)(6486002)(478600001)(66946007)(66556008)(66446008)(83380400001)(64756008)(66476007)(8676002)(4326008)(6506007)(2906002)(6512007)(26005)(186003)(9686003)(7416002)(122000001)(41300700001)(38100700002)(1076003)(5660300002)(33716001)(44832011)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?owtm7P1dG4UBrhRR/vIf/f3V0J9cLDlIFBZaR+Or+2t2+0iE3virZx8PzHYH?=
 =?us-ascii?Q?q3iEb0ejgRRwXpQbki5G0a7GUElKKA/SJve9zUzywWUtYQ5XXbIoFWrI4pt6?=
 =?us-ascii?Q?EG1+hyZN6qA5n05jrM7a5WsWzmt6Ss5wCYiV+dehIf/f2mbGqXA8iN3pC+OG?=
 =?us-ascii?Q?0hUmsyCezxBR6usRK9ZOAZ4tf8WHmzPeVMUQSMFREKjqMU9PmmRkeCWmxtsB?=
 =?us-ascii?Q?pcyyEU3i567pjYXAkWEfZeSaRs1mHJUR9xUrF6lUnzP9GzCNrA2uzDJkMdVI?=
 =?us-ascii?Q?jl6XOYe2HxONm8uUtraRjj3gZ97TC1e4zTYthPDSwwq6Po+kgeLcozRifexL?=
 =?us-ascii?Q?Pdcijgq9ySsb5FLkpdElenxIEYjCf+L6qioFjqjt47I/CeHR0Ct7+ALJCOEi?=
 =?us-ascii?Q?nP43wSLRjK78thrN+JG+goFz7Sb3wAUHmlP5k2JDNm4gG6i9NfQSwNR3wxIx?=
 =?us-ascii?Q?6ojpw1MahnBc1Kyn/i0Qzem1Z8nemBNmi3ahRdTDLkrBVIPbercobFWKAuTd?=
 =?us-ascii?Q?dCWJZcXhZ8IjU5fJXmRYCTNJH+XiHPqKRlIR6wdynVfdPuBnfeSPLtLqmWgv?=
 =?us-ascii?Q?H+XTlnhSVc5n8LW/zUFYNi3s63S8R8SZtR42oZtN/xK1IKjmfi5Mk8yJ2Q01?=
 =?us-ascii?Q?IPaqCPChra+J4GvXBmkqWAbHzO57KKvdHMOKWovKlVapPwdZzRyJmVgozjaG?=
 =?us-ascii?Q?PFDT1VciapHwe3z8kNx/XPEVDrkSZlJul/HhCQrdg2O8XImSoJxqSV2jdFdP?=
 =?us-ascii?Q?mfTTvQFbALZWekNY7TzEMUAvkwC5ZeCRS2qxCuztmBRRiilT3S7VwX3PGCr+?=
 =?us-ascii?Q?kLuKALBVgfmpHrAs0jI8S0b1QOaKNMdaZ/YxoY78LE6N07oNP4P2CQ24eCE+?=
 =?us-ascii?Q?YZBPllcIXtDjzkpvHp8tEYAXMZr34VEP2/WjY4GkPbIOcgIuCJiDM1TVbkUx?=
 =?us-ascii?Q?dSVA3N4EKlntUjAl95UjlknHRWNC8K6ap1bNEXG+Mc2CIfiqZOp4LnOl002m?=
 =?us-ascii?Q?lLXzR3kTHIslScaC/ldWi8Z6Gt7I45t2whJAC6eJ+ZMPJ9WnKqeWJ0o7zw+3?=
 =?us-ascii?Q?TyK1cadt6FJNZsuXWF4yflXwabGpaikmBI1QenbF/bq/p00izieP27+vFvC4?=
 =?us-ascii?Q?lFabckTITODhgvvEncbJ1T7caS8Kyep7uZuRev/ijPWy5qS/CAjB2BNsB4AK?=
 =?us-ascii?Q?cbh4EeFCPckk6tUFYSx+RX+40+17/V/LxOeo5RIcRP4U22YgdVDxm36JKHIE?=
 =?us-ascii?Q?Qi5R5VN7CHLH/mvBXjFWsM0OtIzVXmi3VrcICey+OFdgSpTkb/fjNH3zsHTo?=
 =?us-ascii?Q?/PL9tCIC4MaailoS6RjlTbAwmZpHAdpgptMWiMCO+MmoHHAvJrsQEPqXrTv/?=
 =?us-ascii?Q?yuFqJSJCujJ+w7Elo+kt4mmM0eRKCme5lqBs+Q+I0Dur0jZwzY6MDs0+x0LM?=
 =?us-ascii?Q?Z46n+uBa5oZTnr1yO1F14V/VFQrhyVTOROGsspicHkbfXgyzMFuKJjg3WzvQ?=
 =?us-ascii?Q?iVeidI8NeYa6NGqOsJlWb29Dx67ciW5KnfF4DTKQ4hf10hpINtNuyLz01Nmm?=
 =?us-ascii?Q?gvogWDrsoj5+mg6IxLc6U8v0nW+JPTVyxUzrh/WDL7AazP3l7aHiJZ/SQnZC?=
 =?us-ascii?Q?GA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0C0A912967F37F47813983FCA495E747@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aabef84-bd1d-44a6-7c02-08da8f808afa
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2022 20:52:27.5978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mADYoS/snccJ6XsOFQYxEGhRyiLtaMrU4nWh+AMcUZjGzo714XUUq7+y/0SyhhZ52XM2rGkVvaJ/hVXn7PLKUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4378
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 02:59:07AM +0000, Hongbo Wang wrote:
> > On Mon, Aug 16, 2021 at 06:03:52AM +0000, Hongbo Wang wrote:
> > > > I was going to suggest as an alternative to define a device tree
> > > > overlay file with the changes in the CPU port assignment, instead o=
f
> > > > defining a wholly new DTS for the LS1028A reference design board.
> > > > But I am pretty sure that it is not possible to specify a
> > > > /delete-property/ inside a device tree overlay file, so that won't =
actually work.
> > >
> > > hi Vladimir,
> > >
> > >   if don't specify "/delete-property/" in this dts file, the
> > > corresponding dtb will not work well, so I add it to delete 'ethernet=
' property
> > > from mscc_felix_port4 explicitly.
> >
> > Judging by the reply, I am not actually sure you've understood what has=
 been
> > said.
> >
> > I said:
> >
> > There is an option to create a device tree overlay:
> >
> > https://www.kernel.org/doc/html/latest/devicetree/overlay-notes.html
> >
> > We use these for the riser cards on the LS1028A-QDS boards.
> >
> > https://source.codeaurora.org/external/qoriq/qoriq-components/linux/tre=
e/ar
> > ch/arm64/boot/dts/freescale/fsl-ls1028a-qds-13bb.dts?h=3DLSDK-20.12-V5.=
4
> >
> > They are included as usual in a U-Boot ITB file:
> >
> > / {
> >       images {
> >               /* Base DTB */
> >               ls1028aqds-dtb {
> >                       description =3D "ls1028aqds-dtb";
> >                       data =3D /incbin/("arch/arm64/boot/dts/freescale/=
fsl-ls1028a-qds.dtb");
> >                       type =3D "flat_dt";
> >                       arch =3D "arm64";
> >                       os =3D "linux";
> >                       compression =3D "none";
> >                       load =3D <0x90000000>;
> >                       hash@1 {
> >                               algo =3D "crc32";
> >                       };
> >               };
> >               /* Overlay */
> >               fdt@ls1028aqds-13bb {
> >                       description =3D "ls1028aqds-13bb";
> >                       data =3D /incbin/("arch/arm64/boot/dts/freescale/=
fsl-ls1028a-qds-13bb.dtb");
> >                       type =3D "flat_dt";
> >                       arch =3D "arm64";
> >                       load =3D <0x90010000>;
> >               };
> >       };
> > };
> >
> > In U-Boot, you apply the overlay as following:
> >
> > tftp $kernel_addr_r boot.itb && bootm
> > $kernel_addr_r#ls1028aqds#ls1028aqds-13bb
> >
> > It would have been nice to have a similar device tree overlay that chan=
ges the
> > DSA master from eno2 to eno3, and for that overlay to be able to be app=
lied
> > (or not) from U-Boot.
> >
> > But it's _not_ possible, because you cannot put the /delete-property/ (=
that you
> > need to have) in the .dtbo file. Or if you put it, it will not delete t=
he property
> > from the base dtb.
> >
> > That's all I said.
>=20
> thanks for the detailed explanation,
> I have got your point.
>=20
> thanks,
> hongbo

I'm replying to a very old topic here, but I don't think this made too
much progress (NXP still carries a downstream fsl-ls1028a-rdb-dsa-swp5-eno3=
.dts,
for a use case which is valid: using one of the 2 internal Ethernet
ports between the switch and the SoC as a plain data port, rather than a
CPU port).

I've found what I think is a satisfactory solution for myself. Rather
than carrying an entirely new device tree just to move around the DSA
master from &enetc_port2 to &enetc_port3, I'm building upon the changes
for multiple CPU ports which Shawn has accepted now.
https://lore.kernel.org/linux-arm-kernel/20220831160124.914453-1-olteanv@gm=
ail.com/

With that patch set, what Hongbo tried to add here simply becomes:

&mscc_felix_port4 {
	/delete-property/ ethernet;
};

I've already expressed discontent with the fact that it isn't possible
to move just this action to a device tree overlay and apply it to
whatever LS1028A based board, not just the RDB. However, I found that it
is possible to do this instead, just from within the U-Boot shell:

fdt addr $fdt_addr_r
fdt rm /soc/pcie@1f0000000/ethernet-switch@0,5/ports/port@4 ethernet
...
bootm $kernel_addr_r - $fdt_addr_r

which is even more convenient, because this way, the board device trees
now don't even need to be compiled with the dtc "-@" option (to include
the __symbols__ node required for dtb overlays).

It's likely that some of the people copied here do fancier tricks with
dynamic editing of the FDT already, on a day by day basis. In that case,
what can I say, have a good rest of the day ;)=
