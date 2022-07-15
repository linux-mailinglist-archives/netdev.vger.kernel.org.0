Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1404C576468
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 17:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbiGOP0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 11:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbiGOP0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 11:26:44 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2061.outbound.protection.outlook.com [40.107.21.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38F040BED
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 08:26:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZG+jwcdWvnqu4BJEhiTmKK+VWIt80+vHYxf9l/p55t+w8lJ00R5jZblnCc03MSqQl+eZsRSwqUIl7Llanoy3n9miGV1eX9ujD8HKitDMEl1s6qFp1jbUJH2234h5rXBHghroQa4c92vAAeaieeeF04Sc+2iFbILUJK8SOzfzJ3sg3xQJM79EUcmeNHFEN9lqDo1QvY8I9gvcLYy8JXXGTP1YFurNiioNpchN/8d9jGeFWW5KqQILuVVvR9CWMmlbnvK9LcvtXvr2RavctxTm6dz3581Q36D2dmAskuiNC8kTt7WHobGGIIT9DSJ96xnvtiKGoHuzYqNQRVVJsvcV0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ilw9PgevoDSTS/FEWSu+H+ajt/EisN4uFuh3Tp5kyBs=;
 b=fGYmBTws96DxsWH33YINFb/U8f5MYKZeewSMLCotJQpMfcXJ43ZyXSGcmF0SdILvdX+YmJuFo/KqTB0Lo17b1XVlHWImwIlK8r8HlipZZ7FHxOEGEdABttBfde8J5Q7Btwg1Pum3A1qR54bAyqScdqiB+gj+8UH4adBvRe5wL9UYcmdGu1BAlvk/FuahZChdTwvBlVqHXLs0lrfi6STwUw2AiZKsdvc43cgmbaqXQwlXMYi081xtv4KNp+TlrjTQ7o/FxL5PplI5O661HTl3JRUc5TZpYmthRxv+NP/UTIqTLSaeDVqGblbza3LKVSAYtxt4YZJpIMz+sehQY5pEDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ilw9PgevoDSTS/FEWSu+H+ajt/EisN4uFuh3Tp5kyBs=;
 b=mp4hOkmtYCRmbm0SokPCC58yE/KVbLIzF64cSCB0CdUjiLooBCO0+cnuBG5ypZZ2WPrebXHopFhN4VtwLMhxpV2GViLcLo9ORpSdqdN+FCpcc85weulqE6lS2JMBYw2P72IDV9G4AxDJuK1JuhHJ4H4WpfV4v1jAZYwNjCcsAZQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4369.eurprd04.prod.outlook.com (2603:10a6:208:6f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Fri, 15 Jul
 2022 15:26:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 15:26:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Arun.Ramadoss@microchip.com" <Arun.Ramadoss@microchip.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "linux@rempel-privat.de" <linux@rempel-privat.de>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hauke@hauke-m.de" <hauke@hauke-m.de>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woojung.Huh@microchip.com" <Woojung.Huh@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Topic: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Index: AQHYkJUlP4ikIJ+Lb0SIV36lnP8Hwa1xiwcAgAADgwCAADWXAIABvT8AgADAlYCAACQfAIAArH+AgAiqFACAAEpcAIABMN2AgABlhQA=
Date:   Fri, 15 Jul 2022 15:26:40 +0000
Message-ID: <20220715152640.srkhncx3cqfcn2vc@skbuf>
References: <CAFBinCC6qzJamGp=kNbvd8VBbMY2aqSj_uCEOLiUTdbnwxouxg@mail.gmail.com>
 <20220706164552.odxhoyupwbmgvtv3@skbuf>
 <CAFBinCBnYD59W3C+u_B6Y2GtLY1yS17711HAf049mstMF9_5eg@mail.gmail.com>
 <20220707223116.xc2ua4sznjhe6yqz@skbuf>
 <CAFBinCB74dYJOni8-vZ+hNH6Q6E4rmr5EHR_o5KQSGogJzBhFA@mail.gmail.com>
 <20220708120950.54ga22nvy3ge5lio@skbuf>
 <CAFBinCCnn-DTBYh-vBGpGBCfnsQ-kSGPM2brwpN3G4RZQKO-Ug@mail.gmail.com>
 <f19a09b67d503fa149bd5a607a7fc880a980dccb.camel@microchip.com>
 <20220714151210.himfkljfrho57v6e@skbuf>
 <3527f7f04f97ff21f6243e14a97b342004600c06.camel@microchip.com>
In-Reply-To: <3527f7f04f97ff21f6243e14a97b342004600c06.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4eac5262-aa5e-408a-5956-08da66766ace
x-ms-traffictypediagnostic: AM0PR04MB4369:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YWrDxeFwmXYMh1xassy9J4+GwUdInftAK7br/ba4v2DTgUNHZz+4WIaG8OgF+wMOqARN7oNw9xcTqvx2gZ0fareBzdJu7CM4UKZRQ5L4dMCc+yjs9QYL5+J4w2f+HKy0EmKzdG1ZS+djwRzz3/8ZbjyEflM9Dt0DlY9gR3JXckb+q1YW0auBpWtEQ9jm497kbsAk7yodOx+EPwaEY67tLkkBET7/RFujfBrCFZwesDp73T042AOlxmGSNwx2C9NnD3FlweorCowzRmLoq2GWiU5rNxo0d/BOGzIJBL3mbcYf0mcVPJXXof07As/LbAm4CeEpsSWPrK3sNqj/KdeKTPevGTxZ+PZcQ8v0ezvorNc1s7o8wUxthAITsXJnwZ9zuI4QcSXmMC3+6iawtURktNTHXewCDOYRb8C1R4wVZ9m6PVdZvFmWUaiae8NV4/c9bS4J3sCc9jTuleM52/ZT6XrYZmojmxRxNMPh7m1dLnw9pJ6DNUs4sGNlYfl1TVDmqJ76J0xb2Egg6ZImBHX35PvuefQCQblz+5yGEcdeVGI8pEAuRCQHZldfeujdQ7MJkjiGINWgJUxdxptGKXvWzVKDAfZq1bY+Loh7Qu6fYIOGKlouDZoGH6PKND7eO8j2HjGNjvhTsFl82InxU30iETq14/g1knppbAF7sqlB2NPyfwsb5AReP3GlcuTYWTPkYgy0mknWYpsknSMSFmT/PEDxtgCszjkFHTdQW/9ebLPsWvLP+UvQT4X6ITDWfWj0u/AtOjAmiLb7r7nYEz4ejXHtL/a3JwiYn90v2JFwz1cqEp2m807ssOEYKiA6hPH0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(33716001)(186003)(26005)(2906002)(1076003)(6506007)(6512007)(9686003)(38100700002)(86362001)(38070700005)(122000001)(83380400001)(7416002)(8676002)(71200400001)(4326008)(64756008)(66556008)(66476007)(66946007)(66446008)(5660300002)(478600001)(44832011)(76116006)(316002)(8936002)(91956017)(6916009)(6486002)(54906003)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1iWafE/5mgwyyvrEqMbIWL+oswa3Yew1vqtqq+du23fsxpKrxIw9fwewsuum?=
 =?us-ascii?Q?B/XxmvbZH0/Mp+R8ab7yv+e++ybU2+8R1ZBWyW9qsKskCJemE/rxUjIx+ogM?=
 =?us-ascii?Q?jiRxmgAJsTAiSp+PRLUeWZxQZJJW6EZiYcVlG8pfks+kZKeXe0SQ5wFifJVV?=
 =?us-ascii?Q?5K49DTCCCgCRpJOqwEccX7+p118Gc/ocQuWRd0cfc/X9O/nKZLGQYncBLf3w?=
 =?us-ascii?Q?3c93wJxOkrbOAOeSPL1VNzaXP2GACSjISMV0ZFWUPpsfBo5WI74f+m6LyQHn?=
 =?us-ascii?Q?iF/pZ0LC4CduVGcLIcNE35Eer6lUlwlrktkjK5xv/YTSqrZelKh3L0z3MqPZ?=
 =?us-ascii?Q?rrLI+sJojTN0wT6DBHGlFm9B9JZER46PAYUTsXwPbHpmk7gdyjlqPPPe0U6H?=
 =?us-ascii?Q?2C1iI9UvXeK5aDbZagKwbOY4tBhmxtvAHIDoFEQspp6s1uWWFlIRBnqA1nmu?=
 =?us-ascii?Q?V1Dw9rkrnAPctcjuC8tEh696vE3iQxmhEv4dYoyVYcYjELUuQefkQbOVOpuC?=
 =?us-ascii?Q?1taYFt+RT1ZNdk/3KSYjUi7Jh44gGmII1PnzPlw8e8VyjDM3l1HpfBJQCouY?=
 =?us-ascii?Q?TMXKWTN6GMTJwlPVDw3nG3JbZMJZoKmUBDyC+F3vYjYR14LBC1T9KX1S7xCy?=
 =?us-ascii?Q?nLdbbFggZkkZZJeL/2zEgeM1XkoEzXvEo5xIIKpfScxqxwAPrcTlHnowMhNG?=
 =?us-ascii?Q?QFTjw6348UCCyf585jvxWgw/yXNrRz/O+UOK2y+JDzRxm/iyBo2Er9+AweXZ?=
 =?us-ascii?Q?AXOMvttEKMnAwHwFnF5OHOMsXIX99q93JZvhHW4ehYGNA57dsWiphBITf8nI?=
 =?us-ascii?Q?lbFoNdIaXdtDmrUn3xqgSUC5qtKmwWBZuvIjbkXfMqS2gzSLZONpBss4irUH?=
 =?us-ascii?Q?RwuVl61BRQv7T7QcVuTk4G6eJ7ZxwqRHgah18QXx9wx6uMf2Js1GKshYvkK5?=
 =?us-ascii?Q?laLs9NEKPxgiTHvl0ZwoQcy8C9hgjski1Y/boleznLIV/p5axFLS3jqxgv3x?=
 =?us-ascii?Q?R9eVMUD9zdmKFPEtUpiRk8KIhbfFTaRt++sD8/0T3Xth6jq+6rkrWiYCuq2T?=
 =?us-ascii?Q?boSpeWkQW54gjoC43bE2oKjeOjK7Mf47Y1UiU7C7rseqe6rpmq0wnFmgiFBr?=
 =?us-ascii?Q?QY5KEOJuV0sMXJRN46M7MibXBleevl6Z1mMyhHzgWndQKZe7w6C73MhM9uRq?=
 =?us-ascii?Q?AljQHk4zmDEFS0EmplEJiaJzdAkkQXgQyeGRDBgIjj35uyZxblWt6Qu+LClr?=
 =?us-ascii?Q?VEAPA9g56fe1cMCfLJC3e739k5pBRYXE/TC6rAIwRJ4uOilFpdAw5/9b/cGi?=
 =?us-ascii?Q?36JLrR6JzucgSs1QjvYtt/9sAc66Z1MXyNOrVdrxLEDfKf1/5ZgE3IE9KwHe?=
 =?us-ascii?Q?LSoByM2DOQanWx7f82hMpbFn/8HvpsFZQffpB4qAT4rKKb9lTpEo2SiW+rz/?=
 =?us-ascii?Q?rzGOzcEYOr0nw/jzB9iCt70HZl4jmVKbNRUr4ENoLW2AfaVSgEMCsQkmizYa?=
 =?us-ascii?Q?9mW1n3aDFe6JLPzXkKdzawaDpX1Wu/InadJmXLrR9qCy/ubqk4i5bi27p98i?=
 =?us-ascii?Q?FGaW5sJKeriURS8G5GWrdRNm3JEU2HWEm0NfOyDfo34RM/s8MTSMGNJ429mQ?=
 =?us-ascii?Q?jw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7335E1423689734ABD0E93A42E83668F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eac5262-aa5e-408a-5956-08da66766ace
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2022 15:26:40.9960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jveS727J4GRu50+Lii/2BtKbc4viKbOpiH/9qPMr2vhItC75gD8uct0hd79PXxO4/7rPIrFcVlomGyplc5rEOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4369
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 09:23:19AM +0000, Arun.Ramadoss@microchip.com wrote=
:
> Hi Vladimir,
>=20
> We tried the following test
>=20
> ip link set dev br0 type bridge vlan_filtering 0
>=20
> ip link set lan1 master br0
> ip link set lan2 master br0
>=20
> bridge vlan add vid 10 dev lan1 pvid untagged
>=20
> =3D=3D>
> Packet transmitted from Host1 with vid 5 is not received by the Host2=20
> Packet transmitted from Host1 with vid 10 is not received by the Host2
> =3D=3D>=20
>=20
> bridge vlan add vid 10 dev lan2 pvid untagged
>=20
> =3D=3D>
> Packet transmitted from Host1 with vid 5 is received by the Host2=20
> Pa
> cket transmitted from Host1 with vid 10 is received by the Host2
> =3D=3D>=20
>=20
> bridge vlan del vid 10 dev lan2
>=20
> =3D=3D>
> Packet transmitted from Host1 with vid 5 is not received by the Host2=20
> Packet transmitted from Host1 with vid 10 is not received by the Host2
> =3D=3D>=20
>=20
> Tried this test before and after applying this patch series. And got
> the same result.
>=20
> In summary, packets are dropped when pvid is added to vlan unaware
> bridge. Let me know if anything need to performed on this.

I'm not surprised that forwarding is broken after removing
"ds->configure_vlan_while_not_filtering =3D false", but I'm surprised that
it's broken even without the change. That suggests that either the flag
wasn't effective in the first place, or that the breakage is caused by
other code paths (not sure which).

Do you get the "skipping configuration of VLAN" warning extack when you
run the "bridge vlan add" command without the patches here? Does
ksz_port_vlan_add() get called at all with VID 10?=
