Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116E1575178
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 17:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiGNPMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 11:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiGNPMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 11:12:15 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140045.outbound.protection.outlook.com [40.107.14.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642E054C87
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 08:12:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GDHAyc1F717LOkm4gRRmrKdsgqsZ6kSjd5TB+V9SZ4U9txex3R9TQm3owP4Z2umxK78ZQfJ28YqSQEtqCE8eEEgDfA9Oyh4sfx+BYuvtpR7MvSz81hQXqrmIJItsnNpjop6QS98U92NoTM9X6DkBKncMzKl8Og8npIokBR17DfGWYe3fgkpmZzO3E1rQ/oUq94iNUVLPO9xxVPaS9QFPET2hNJzXTE8S83ur1VjZs45ux3D6FZuaQ0/b/Xe5XUTXS2eFEp4zoZzVTnfVh646ENt4d32ZoDO1k3dPiJspX5WjiE8VXbfXMNBEz8qZwZyZgtKGvJps4b2680iciF1VdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZGQxIoVUcUzow3qXSARbnUHOH7ZYk/s6zWNCDB5FKE=;
 b=RhFLK8W2c+NBokIrAK1FSIEUBPyOtEv2epmQbcxcZunLEdI1cteU4Gh9ViGgcKPGzOWBm3uOGsv/7g5oBMVdzcaMa7cNEbRSNLR2o+YFeg9JNVpLFLa3PTWSTdpjC1ja8lLAbcbjHByvp0Opz2XumNTPhig+BO/ZwElKV0yVRIrIG3oBtzLMrt6GoKG4SBrXGY7UfN2g5AhkJ0im1H965o7FWywSEnbJ1PZsZ73ef1PZbUzlU7ftZrbi4Z46x/yVXFrI/BPTz1mPSOM2o+8GPVQS9mQ3G2tfox3dE4eya0RhVN/lWOxVqKEsO8Dy4XjTr71TJvXOzj8yJrUeir0EcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZGQxIoVUcUzow3qXSARbnUHOH7ZYk/s6zWNCDB5FKE=;
 b=TMjAVf+XwbSq8CQqdiOub/kozemH6q1M9756O5s/O3cAzA/2a5JqK1emOL378vlZpwHdl3qEofq69MgU729vN0RHJ8vXadXwjdpzR0cD8G9WtchJkMh8JOIH+HhTYXRdSmdMXuYBFjGsV12fYgXajvfELG2AdpVxwbPA9KMq7ZI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR0402MB3393.eurprd04.prod.outlook.com (2603:10a6:208:21::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Thu, 14 Jul
 2022 15:12:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5417.026; Thu, 14 Jul 2022
 15:12:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Arun.Ramadoss@microchip.com" <Arun.Ramadoss@microchip.com>
CC:     "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "linux@rempel-privat.de" <linux@rempel-privat.de>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hauke@hauke-m.de" <hauke@hauke-m.de>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woojung.Huh@microchip.com" <Woojung.Huh@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Topic: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Index: AQHYkJUlP4ikIJ+Lb0SIV36lnP8Hwa1xiwcAgAADgwCAADWXAIABvT8AgADAlYCAACQfAIAArH+AgAiqFACAAEpcAA==
Date:   Thu, 14 Jul 2022 15:12:10 +0000
Message-ID: <20220714151210.himfkljfrho57v6e@skbuf>
References: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
 <20220705173114.2004386-4-vladimir.oltean@nxp.com>
 <CAFBinCC6qzJamGp=kNbvd8VBbMY2aqSj_uCEOLiUTdbnwxouxg@mail.gmail.com>
 <20220706164552.odxhoyupwbmgvtv3@skbuf>
 <CAFBinCBnYD59W3C+u_B6Y2GtLY1yS17711HAf049mstMF9_5eg@mail.gmail.com>
 <20220707223116.xc2ua4sznjhe6yqz@skbuf>
 <CAFBinCB74dYJOni8-vZ+hNH6Q6E4rmr5EHR_o5KQSGogJzBhFA@mail.gmail.com>
 <20220708120950.54ga22nvy3ge5lio@skbuf>
 <CAFBinCCnn-DTBYh-vBGpGBCfnsQ-kSGPM2brwpN3G4RZQKO-Ug@mail.gmail.com>
 <f19a09b67d503fa149bd5a607a7fc880a980dccb.camel@microchip.com>
In-Reply-To: <f19a09b67d503fa149bd5a607a7fc880a980dccb.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a336bb63-a097-467f-6fca-08da65ab39c7
x-ms-traffictypediagnostic: AM0PR0402MB3393:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /ilN4bxGYFmKhdqZcD1RCnsvJ7pJYW2XYGlKTred0QGpZcxAeUxpqpOwkS3eOOBL101QNllm/SExZn4bSNU12YAIZ6m+BXoegbGomu6A3dAJMOvLovXI2jHXODqZf0JOFnBTLymgFCn8kDF9mxSJGHjwtgoO9rZogevrO76OpUALF1e7mnG/wehX6OgQy+ssxyL99NF+JmvkqtdbR/WJ+1GABTlUAiPUznhSjEJQOfaFtA3bioHPgG+/cGgC5QpBJhz+pzYIRGEgM2Ssr5t5ldtuAMaGLDYeKL6oP1uTcCO5prkf2jQpghT74VVAmcYl8GbsIxMtsEtKux+wG3XzPhrTNuP/gfMzRlDgTmIuVPaojohVoBf2fqyanFUYhP9RR9eziLtP/o5RhdFsRMMusETvVPwFDRS8i10F7Re01KTzb/UCTNqaX8v4vYLnxOai73CUB22OiCIf9yDIRiCnCA40/2KqpCK1FyeScYgxatvlzJL6N8AozT1Q0jaLkq56eB0ckeu3Cc9eIe9PmV/m82FNDliu41FjjaIpMdWGK37MXzSQXiap7qri2kd7TpC3AmDBxc/Bk+MV6wxsQVdxL2hXPhkkhaMsWXsUR85YMcxWmCfWsD/m7ikvd5vTt1YO3leewWL+xy1bUnllNYwc628Ya0icdOhPdHGsQOJMcQxRE+yFibnw0yjQSXbtXgBVDkrZ8iOrkJOa+XvgMZLdmVQwmnlixmNW2Wq72m9MrmA7XBsypdUZ8xpW+WPZvx38xx/VciwMRlzQwJFX5TLanJR5S0Oy4Csi75HrhJPmzsY1yV2DqNDCZF2NzuoSwi7o4KyhNRHY/PTTVRAvHf0EoTRPLgJxpmtr+x4mpSo50jrmzrjLSnTq7i5CvZMp68kl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(39860400002)(136003)(346002)(396003)(366004)(966005)(38070700005)(54906003)(6486002)(478600001)(122000001)(6916009)(6506007)(2906002)(83380400001)(41300700001)(8676002)(7416002)(91956017)(186003)(5660300002)(26005)(44832011)(8936002)(1076003)(66556008)(4326008)(64756008)(66946007)(76116006)(86362001)(66446008)(66476007)(9686003)(6512007)(38100700002)(71200400001)(316002)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MOo/9gLKm4O+Tw2T/eYhv2WVKGzpSY4/koEVtczaN6+8DF/18MbKV7shhzGX?=
 =?us-ascii?Q?vWkV5J/y0g75hipXkqdaEJUK7/wWw045OE/fdBJ8aQah60ScGaqis6X8T4hc?=
 =?us-ascii?Q?1g/Im3rATc6SDxe1s3yFDUnGEhkhBroTaUBXipIxI1OGnCVtazn+kfsy8+Wj?=
 =?us-ascii?Q?Gi81DHbDBw1K9WmIeXPwV44Vwheg7/czSv+OkSHU2JUtg6WE/uF00B6HOeNP?=
 =?us-ascii?Q?dXGL8wCbiXx8rOic/XMX8TGdmKsaufV6c4nzTM21/L8gEYi5XYiQAuCzeFv0?=
 =?us-ascii?Q?tYveNMLXB65406+O230FwoaVPRowROOTnlySSRgGDpVRdXpywBbDhp5OIB+l?=
 =?us-ascii?Q?X3RGv0K917zXkcoQObNZ3XLpxBNbljZ2YHsCMnUSJDt3SnywstKzqlGwOpIJ?=
 =?us-ascii?Q?OZvCncrdUIbS5ymbGVP9574Xddt9ZP7AaQ1gvP2XVVYVTo1kKdOENVFe+jiA?=
 =?us-ascii?Q?RcvjDN1Tr6jDEsH9r1pzO0u/6JyOa9pFmxqL4M2J3reQZxSRDuZwWpQbSc57?=
 =?us-ascii?Q?ST1ffJX9vXtfF+cnjhbK5MyHBdqUMkDd5QB+z7WbIWFbjQJdYsY8KX9B9un6?=
 =?us-ascii?Q?zq0PwGkTnAaqF4ZwFlCg9w3GaLNhJ2I3/4KY82AvYs0ozYKY6okV3AKT56ba?=
 =?us-ascii?Q?L6bONc7oO9S3VP81s3K/PO/hJvRFxtlMUWYI4fPfyMvmVfEtl8VF/lPWi+Bp?=
 =?us-ascii?Q?KACDHAkBjSHMsLSaEoFINUWdZqe57tqBzj1ecRaoV+/rfcotYmLr3VAbydu4?=
 =?us-ascii?Q?2mBchPVgtBQjs24b5dF6VKJTV+yc/3qdeow2RuG1X6SYr6nqImYLw/3qM6I4?=
 =?us-ascii?Q?h/uuAo272eW/V2aAy6YiUqmXtPfVO2gcZRUwA2E9GqCK/O8pQQ4P7A/SKpJE?=
 =?us-ascii?Q?eLP9iM6pjodF8WsYkYa4yUpfIdpRWn7O7t9qRs5keuSA3/zgtdqPUK7VZAhK?=
 =?us-ascii?Q?ZhF0MCuV7Y3bXriz7NTyRBsNNdQzPcUha/DSVyCVn9QavDwySdw8H68A46B2?=
 =?us-ascii?Q?qTqWFIJp/MnrlcQMNARyqDXLx1NbmokeGWNKLFB42EfjNRejGHZwNUXZUVcW?=
 =?us-ascii?Q?T0aqst0J7MSJdDLbW6xyMQw/QLm2kgb7jQD0nlifJsjaZKwntGiIeERY1rOH?=
 =?us-ascii?Q?PnBW9CA0xFWB1HaTM74qTDdSbY5FomwBWEzcaFeUcxWFpxo5NILN0APvhYvG?=
 =?us-ascii?Q?wZ8awNDgNCOfxlMhJQXxStFZcdvrbDq7vTry6xkRhm0vrBG0tRYTsmVznES1?=
 =?us-ascii?Q?1t2eiCYFA3q+l9WmWyB6/OUdTXAXeMBgB9UhUaYKSUycUpuqXdeUpQ3/R6Lv?=
 =?us-ascii?Q?p5DBRjOIdZSTClPAv+29U2XU65Ci0BiTr0nWmYA+ACeTPcQVoA8RHL1e1JGZ?=
 =?us-ascii?Q?enFewjWdA6QF3hE9BvRY0lLeKu+1dffkRUTH5fFuL/+XEAsMThx3IgUIlCbj?=
 =?us-ascii?Q?VhkutDufMP5qLFJ8a1o0f4Mc23etlMJbxfSf2NQp8ZfdidimmhqvUfroyl9P?=
 =?us-ascii?Q?MZNE9K2ihVzKosim1zwGVcMPWmNQ3eGcXG9dxeYRH2jWB5jRsBFdkx+e7vNb?=
 =?us-ascii?Q?rKO3fZe98ErD3s2V5SY3hHpc/Wo7FWvMsdDKejgUj4626sN+/wqWfaP4Nq5s?=
 =?us-ascii?Q?Wg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0FB9540E967E724A8EF7A72E121245A6@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a336bb63-a097-467f-6fca-08da65ab39c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2022 15:12:10.9218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9zmLBLuwFos+Ke2IxtpkfxhVSEG+RA/HOTN6gg128zLyI9ssaPVB7eMc9+JJvJA0p6JB9Yl3yeK/E0K/HbELCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3393
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arun,

On Thu, Jul 14, 2022 at 10:46:02AM +0000, Arun.Ramadoss@microchip.com wrote=
:
> Hi Vladimir,
> We couldn't able to setup the selftests and failed during installation
> of packages. In the mean time, We tried the following things
>=20
> Setup - Host1 --> lan1 --> lan2 --> Host2. Packet transmitted from
> Host1 and received by Host2.
>=20
> Scenario-1: Vlan aware system and both lan1 & lan2 are in same vid
> ip link set dev br0 type bridge vlan_filtering 1
> bridge vlan add dev lan2 vid 10 pvid untagged
> bridge vlan add dev lan1 vid 10 pvid untagged
>=20
> Packet transmitted from Host1 with vid 10 is received by the Host2.
> Packet transmitted from Host1 with vid 5 is not received by the Host2.
>=20
> Scenario-2: Vlan unaware system=20
> ip link set dev br0 type bridge vlan_filtering 0
>=20
> Now, irrespective of the vid, the packets are received by Host2
> Packet transmitted from Host1 with vid 10 is received by the Host2.
> Packet transmitted from Host1 with vid 5 is  received by the Host2.
>=20
> Whether the above approach is correct or do we need to test anything
> further.
>=20
> Thanks
> Arun=20

The above is correct to the extent that it is a valid configuration,
but isn't what my pvid_change() selftest was intended to capture.

The pvid_change() selftest from patch 1/3
https://patchwork.kernel.org/project/netdevbpf/patch/20220705173114.2004386=
-2-vladimir.oltean@nxp.com/
checks that VLAN-unaware forwarding still takes place after this array
of operations:

ip link add br0 type bridge vlan_filtering 0 # notice the 0 instead of 1
ip link set $swp1 master br0
ip link set $swp2 master br0
bridge vlan add vid 3 dev $swp1 pvid untagged # notice how VID 3 is absent =
on $swp2

If you let me know if this works, I can continue and resend this patch
set while you figure out the kselftest setup issues.=
