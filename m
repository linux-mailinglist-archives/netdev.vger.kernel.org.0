Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C517A5B04B9
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 15:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiIGNHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 09:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiIGNHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 09:07:37 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80052.outbound.protection.outlook.com [40.107.8.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CD97A77F;
        Wed,  7 Sep 2022 06:07:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MH01MFBWvRSG4Cr62pZ3HtBgGBvHTg1KWj96Fth6IOjDIXSFx0+anT9YKXiik0oTJqFhKCCsChEzDWdaDOm4dn6Vq7uFETqR39G8VhQiLnuoPGOO7iURVn9pkDzTYq36pA9ejEbkR13ksx4MOQV2pzogRY/smDUE3/TXfoxR5QP55iX/c4pTrZ//tQLRPSmI+xFusyE8Lx2fICIGof+xqfLhxUwEPn7rz+W2F32D2xLnJcoVWMyiwJqapP+nR7lIc8jZDFEK6E1StkTUAK7AgRiQxkZaHJJrvfw9pRoNtzCmhiRsYzBRstain5g/oVcPbVxKBrGpz7eEoPSfOhPgHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s34KHKknZTa+rkIpTlVInSTNphNzELlWBVbzHrk/JQk=;
 b=nFW91C//B2gDRJcFZ+qXsC0kFiPdDCPY/nR9Y1Wjal/he/NWlLKrWw2YDZTdeUmu+FbAYr3SI1ZHSLyDh5Vk5fSWrWmimvQ9t5dtLVfvcZfuQ33s+FwpMzZzSwtERV2CGBX8mJcJT7uj3AsgYXQtiDsL2sKtxC7MV7SZP2+SskprAOgpuPXSE+PC8q690Bc4fLAGRYO809/ReNQe2FhRCAHvYxtmmVvr4TF6g+/RfIN6Ep2jN09gbfEiLV0Hd+yENLfx/8N6WMRGqx+NEAGd4uK5luuuvBL1oiU7TO8NCjKbzsVRr0gbxHPPJBrxzKEaHQyETHNjjf2gGNYEVt9/Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s34KHKknZTa+rkIpTlVInSTNphNzELlWBVbzHrk/JQk=;
 b=blV95CgzL3G75lAceV7wH4nwBzw9ZD2DnWm1SbYCkwkJsMhtzXpG33PY0B4dnIIXMrazTU317yS4WDack2teiQ3P9u4rwrWWEfWM1hBO1AzpcBeJaqeSLVo6zobvWYuoprE54fRW7vo1nsMLnxcwSL3fZquVpCIWBRiIGNcJwaI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8591.eurprd04.prod.outlook.com (2603:10a6:102:21a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 7 Sep
 2022 13:07:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Wed, 7 Sep 2022
 13:07:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Leo Li <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH devicetree] arm64: dts: ls1028a-rdb: add more ethernet
 aliases
Thread-Topic: [PATCH devicetree] arm64: dts: ls1028a-rdb: add more ethernet
 aliases
Thread-Index: AQHYwW37dzULUFcX/0OQXQkpZmzQZq3RZ7aAgAAbB4CAAIrBAIAAIAOAgAF/HICAAEYXgA==
Date:   Wed, 7 Sep 2022 13:07:30 +0000
Message-ID: <20220907130729.whphxfmcp7odwkkf@skbuf>
References: <20220905212458.1549179-1-vladimir.oltean@nxp.com>
 <d00682d7e7aec2f979236338e7b3a688@walle.cc>
 <20220905235413.6nfqi6vsp7iv32q3@skbuf>
 <0c1b726c6791cc97f9ba15f923264630@walle.cc>
 <20220906100525.mhjomm6f2y4lr3lw@skbuf>
 <eaa92fcc134df14714f9d14635e551a1@walle.cc>
In-Reply-To: <eaa92fcc134df14714f9d14635e551a1@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72a976aa-e163-4770-e278-08da90d1ebc9
x-ms-traffictypediagnostic: PAXPR04MB8591:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: naHCSRfzgGkG0sI1j+ME/OHRU72oWsh79lU46NDHvydYxGrupNWVCkdt1JBOIfofSF+RZDdPP5JijdbfcLLrNyJo/MEs6OWm44/WwOOIcXNdsx+afNgJr2tBrPZrmNQlPXWE326fmWBecnNBO3C9kGAosjPw2+bez8klZiPqxPZF4P4GgNYFOQnXbkxvzdf//kH+j9wb0Um1ffGtUKMRPRL4ZHpmy5MkVs52zwk6+YtGL1qFlnxlPWmQsZh/I4iIdnTCZ5qIk4b2ym/vaZu468zAZMPZRlrrhQcZVMLSsaBW5TUeA1fYVK8GvTpnuD387MdKIBioSKXbfgoMDplWwLKbNWV8RShQ/RlCzvhbVdWRnKzL9UEy6BZ67eNaZc84HB2Ac5MmUeZA50xKifQdmyZVgWqKc99bphXBSqfrmwayowHu4J0bVrFNr0EynJPSzXMyHhGRIyJHXEpmnZeF4ERdnttKSM5pOLMH+n+u7ymyO5+Y6QdUDZRKM3sl+F9VwoALQzpGRG3PEeO6aH2paWR6s5tNVndKZkkJjBj3AkuLexlyvSYK7nXyxe5Ndc6RDvsqmNqFKmM1vKtyqW74AqxnzFf77W0x0gB2yNhCHLVz2EwL3Zg/Xo+lzutDHMN1XxJ0Ry8L/Grr2oriYSzfk9cOPmcUW6A9PHVZfKPBLdtEM+4/R0SI4CFTHVSTbQ2Y7HykTikYSAO5B9QgI/NPVt1YxlyrBhT1vqYPkuccf0RQlbtAGbb0ve9+dBOO7/bCPSzo8yfmY+RbmLsG9uJ/Bw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(376002)(396003)(366004)(346002)(136003)(5660300002)(41300700001)(8936002)(26005)(6512007)(9686003)(2906002)(86362001)(6506007)(38100700002)(44832011)(33716001)(122000001)(38070700005)(1076003)(66946007)(186003)(6916009)(66476007)(66556008)(54906003)(66446008)(478600001)(76116006)(64756008)(6486002)(8676002)(71200400001)(316002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zbACn1u7tP2Zb4OLExanIm+JMPFjDftiDLlDgufSNJFrnrKiRBx3tEpKtmFK?=
 =?us-ascii?Q?P8XR160Uvoy5E8a2NPGtJ3vB3vYzc4b00LdJEI9tyTVrLs+0AObcfJE4y4Pl?=
 =?us-ascii?Q?3AQOOx5r/F1MeNdOG9sWQEltu2jtYdDvLAhS6SzzJFpDUzmRai0x9NQ4oMkm?=
 =?us-ascii?Q?SuKdjtBYPQ0zyP8jI7rCzVJMnD924EfH0FVt5poCtrdnu4rR/fbNbIg/dHJe?=
 =?us-ascii?Q?lzi7nlL+JqqjmjUurIem+VuqineENa++FAT34f2qHL18LLE7juyCUDIXSVXS?=
 =?us-ascii?Q?QPrOUpeDaOYXaGNiq7KIPNAGOhNZGFjvTewQKwHb5OYpHhhA5cKnbNXvM4Vk?=
 =?us-ascii?Q?2s1cm3pLIg4bAK7Pc0yXJHN6xLOIftEU3HK3R20+c05PbwR8x2H3e47FCBwz?=
 =?us-ascii?Q?keo8h/bgFlJpdlrT8cKoJOyWBewNjlsLgmdlXOXz98mJ+gKVSolMtp3IZn6W?=
 =?us-ascii?Q?v7D3n3Z3eJi+MQnVJWh4tC9qxNnv+qf92FuNJ/FuyPFGQ8rF0hmGLcb+azVJ?=
 =?us-ascii?Q?+2B+Uj3kaWIMNr+PjHD+ZCOvDc8HHEz6uopORRHVfonQCNZMTz3chvwettF9?=
 =?us-ascii?Q?mNx9DuPjO2IU+aitq2Uzw375cwdbKLiMKDRdkaiSNTyhF32SyA0DtA+f/vRC?=
 =?us-ascii?Q?ZKy7WleTT/ycrylXlcxgF8JRRN/hmTyTUWGCFX6iD68E50ro/1y6Tdy9DpK1?=
 =?us-ascii?Q?a49yovH5IUDP7sDYm4gnd2YxhAplGF/nbjURmsYa5ecnADXLhpNNHqZc719a?=
 =?us-ascii?Q?7tyWpNrnqm59DoNlA/BA05Cp9bZVsbXDHLN2cnIijOnr2LkrEMvGQ++v7Bqx?=
 =?us-ascii?Q?qm+LPYGAwZmmpD1IVRk0iTPBjn1thgy2tZFJG+aMR4KmIy0HkqGq7PH+OzSF?=
 =?us-ascii?Q?4VvWWtI0+PYMjKH/JnRNMJ1kd8rPGvX2ZLqk4rf8/6vXPgg1bZ1XN2MrH+qf?=
 =?us-ascii?Q?ewVpJyM6NnjU2wlcN1YBIPdyBKdAzfFQbbo2L6yjGMSXUtrpGYZ1s45idA8q?=
 =?us-ascii?Q?XijeMEGnvTrG7+CHAzhhl1MsCur3mJ4mHcyG3qrbgYih1mhcHBxtpV8LcKIl?=
 =?us-ascii?Q?/No+tggq0YRClo/7aCHTQfZRWzM67/pz3asaIfxnMVwY7ybsmAMNG3ylCT4q?=
 =?us-ascii?Q?4qqUtvzAiAVa4J2U55cafLafBJ6SKpGnSNCjYThmDVXFDE9VykgUOwmmJTLN?=
 =?us-ascii?Q?ZsF9MWdEc3C3gi43q542wDysJoHVr8+mzhpEYc82NOU4a680ueWpyxI+XHKQ?=
 =?us-ascii?Q?8UeoCrHw/EZbAvj+V1mrMHmBg0hOgvoNnkaJfHc0XZgyhhnoQs+wQ6szSeKs?=
 =?us-ascii?Q?RhoyqG+SIR6O5kVOvdhuo+k371At2D0RPWkpv3LzMlUA7nU+9wR34nJqyWm9?=
 =?us-ascii?Q?HmldffrXFvz28//VVBrQGBUAChCliiKvzw4184b56oAReeul6262qAnsA6So?=
 =?us-ascii?Q?joL3knxBQaL4rI4ggxFVgQ4RVzY6E5KVGDFTomg/tzwh87ydjhZ61X9SCPba?=
 =?us-ascii?Q?sNdCKZ64hJbUY/vFl+AuLfpN4A/jIsbbmWuOSltcK7TdbjacTL7dZt7zbzgj?=
 =?us-ascii?Q?zStb58C2gmzfRMwd23uPWTEnFtqyRJhkOb4iPZuBDBZaHPVk4OFIW3rr90f6?=
 =?us-ascii?Q?mQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7EEC1B2F9B173543B697EE41C70DE22C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72a976aa-e163-4770-e278-08da90d1ebc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 13:07:30.4631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LV/sABZvX0Rx2xGzF0NUcK8VYFSE25JEEV9pOl7LjZXe2k1UTMcdPqHQUTHn/fky25YKsdCX+2+FqXcz25jtRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8591
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 10:56:37AM +0200, Michael Walle wrote:
> > > I think we are on the same track here. I was ignoring any VFs for now=
.
> > > So I guess, what I'm still missing here is why enet#2 and enet#3 (or
> > > even swp4 and swp5) would need a non-random MAC address. Except from
> > > your example above. Considering the usecase where swp0..3 is one brid=
ge
> > > with eno2 and eno3 being the CPU ports. Then I'd only need a unique
> > > MAC address for eno0, eno1 and swp0, correct?
> >=20
> > Don't say "unique MAC address for swp0", since swp0's MAC address is no=
t
> > unique, you probably mean to say "a MAC address which will be shared by
> > swp0-swp3".
>=20
> That I actually don't understand. I have the following addresses after
> booting:
>=20
> # ip link
> ..
> 4: gbe0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP gro=
up
> default qlen 1000
>     link/ether 00:a0:a5:5c:6b:62 brd ff:ff:ff:ff:ff:ff
>     inet 172.16.1.2/24 scope global gbe0
>        valid_lft forever preferred_lft forever
>     inet6 fe80::2a0:a5ff:fe5c:6b62/64 scope link
>        valid_lft forever preferred_lft forever
> 5: gbe1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group defau=
lt
> qlen 1000
>     link/ether 00:a0:a5:5c:6b:63 brd ff:ff:ff:ff:ff:ff
> 6: eno2: <BROADCAST,MULTICAST> mtu 1504 qdisc noop state DOWN group defau=
lt
> qlen 1000
>     link/ether 8e:6c:20:8a:ab:52 brd ff:ff:ff:ff:ff:ff
> 7: eno3: <BROADCAST,MULTICAST> mtu 1504 qdisc noop state DOWN group defau=
lt
> qlen 1000
>     link/ether c6:fd:b1:88:3c:36 brd ff:ff:ff:ff:ff:ff
> 8: swp0@eno2: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN
> group default qlen 1000
>     link/ether 00:a0:a5:5c:6b:66 brd ff:ff:ff:ff:ff:ff
> 9: swp1@eno2: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN
> group default qlen 1000
>     link/ether 00:a0:a5:5c:6b:67 brd ff:ff:ff:ff:ff:ff
> 10: swp2@eno2: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOW=
N
> group default qlen 1000
>     link/ether 00:a0:a5:5c:6b:68 brd ff:ff:ff:ff:ff:ff
> 11: swp3@eno2: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOW=
N
> group default qlen 1000
>     link/ether 00:a0:a5:5c:6b:69 brd ff:ff:ff:ff:ff:ff
>=20
> gbe0 is eno0 and gbe1 is eno1. So in my case they are unique.
>=20
> When adding all the ports to a bridge, the bridge gets the lowest MAC.
>=20
> # ip link add name br0 type bridge
> # ip link set swp0 master br0
> # ip link set swp1 master br0
> # ip link set swp2 master br0
> # ip link set swp3 master br0
>=20
> 12: br0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAUL=
T
> group default qlen 1000
>     link/ether 00:a0:a5:5c:6b:66 brd ff:ff:ff:ff:ff:ff
>=20
> Is that what you mean with "a MAC address which will be shared by
> swp0-swp3"?

No, what I'm trying is only to reformulate what you've said, "Then I'd
only need a unique MAC address for eno0, eno1 and swp0". My understanding
of what you mean by "unique address for swp0" is that the addresses for
swp1-swp3 don't matter (hence they can be set to the same address as swp0)
since there will be a bridge that serves as the IP termination point,
with its own MAC address, inherited from the first bridge port, swp0.
But this makes it improper to call it a "unique address for swp0".=
