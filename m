Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2AF4B11B4
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243636AbiBJPa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:30:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239644AbiBJPaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:30:55 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70055.outbound.protection.outlook.com [40.107.7.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26859DC1
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 07:30:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EnnrhCHd8uQfqZppRCYnp7uyL9AEvI0wmOUANbo+0/VxMmPtAOVkEpTX9mpxWXhcZwZAi4QOgEAvZUmD2nLd18jhv/FRjih0aExzYTd/tJ+yUZdSp4xBPhQ2oZu8xGkK784+NUPEil5/CDBmNNNlr2JYoqCzJatOKxSvfuaRRrFgMXqfz9yX5HZlB5pLnDGH+V/EpNoatQzkgQJ9oGkCxYo8xYlOyqOKIEp6/V5g5mCcqHIukfzB+wz/OhhU+qyyV2y/Git8+N8tDV4sYgH0x0iy8v+FLq9P2yEEuzTgdMSplrEgqaZ9887tAHPjumOpIlxh5yi7z7+nfpnGk4rr/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7wbH4awGMJot9JHYOjIOv/1TTQ+/JBAtHvVpjDuvz28=;
 b=fSeN6VeJmRe0YGHi/dJJz7Kx3Fr5Ha+QADAYrXLyILhM+WLq72MHp/h/iLMWiVUnA87W014nVzUOqB7eeR+VuMuIYlas9R8gWe0jk9H2fH16/KIXvbqZnewKrdzMlD1Wu60JQwiZE+PeD1MmPIJKKFTXgX3ED0kPq/Y9T5Z+yVvDpppIDnUeTK/RN1yVmJcuaSi8Um+QFQQ/hYUskQiHYd49vQvL4Sdb/AwbjJwqhQP9aEJuTVxLGFCN9Su+R4d9bwaFgpvBbH7+rwSYGWtR0sErI6F0A+PuNxD3O5AVh/jYpmPO1eM6ONvp5RonCJBGGPigyQHAYs8s9perTRcumw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wbH4awGMJot9JHYOjIOv/1TTQ+/JBAtHvVpjDuvz28=;
 b=K8Lv+A1PvBU+l3Vcn6y/PEOX9UUiw5fhMsZa+UR+847E36cXhCjU02eR3rlkYp0O5K/QQ4UyiGWBqmV8rpYozigLphkfBA8jMOwFGu1QaYF4gLiTqFwoGtDfaOEJT9YzJCse3GGDtmBTJzDFmkB+zxAETVj1ZQcF4QuEYVu3GOc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4730.eurprd04.prod.outlook.com (2603:10a6:10:1c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12; Thu, 10 Feb
 2022 15:30:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 15:30:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [RFC PATCH net-next 5/5] net: dsa: add explicit support for host
 bridge VLANs
Thread-Topic: [RFC PATCH net-next 5/5] net: dsa: add explicit support for host
 bridge VLANs
Thread-Index: AQHYHfxZ7OUNGWiSLUSVqwQMKllhOayM6miA
Date:   Thu, 10 Feb 2022 15:30:54 +0000
Message-ID: <20220210153053.53jwxh2ggtbccxo2@skbuf>
References: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
 <20220209213044.2353153-6-vladimir.oltean@nxp.com>
In-Reply-To: <20220209213044.2353153-6-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: acf08f0e-4b9e-4b86-61a1-08d9ecaa53a1
x-ms-traffictypediagnostic: DB7PR04MB4730:EE_
x-microsoft-antispam-prvs: <DB7PR04MB4730CD434964D6F219830758E02F9@DB7PR04MB4730.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: luzyRXWsX3Nqm7wPcsPBUN3zVpXDhUpRjxs4f8ix37aK8W+Dy36NpVFONpFiNs7wQqES4KAD3tnhN+/i7KXTcA50RG3lr7C+GZCC9ZeGVhFH5NK7kLirv/tnmBS+W124OafI3xzU+mmfbFNKZstVioxFsRvht/MlFJbyidboD2ABSsqrJGP8gaJ5OVYNFHBfjdXqsKpL8IHG13S35A3Ln/HS8b+S+pjYP6WagoZ6nJvlAxOSvafLUoyLIZGO4IScOV7wxDVtdysti+GD7X2eLFI8mmzyD5Dwtw1YO63rAXsU6aKsVd4TFWNda+Vg88EzxpYUotaG24Pw6zpwbgE3+ckPn4E2uwjbxLq5bx9GjEBszs6PwKs2+lIIXLUMmbPb+VIMa7DhDGvTiNiljYIDRhpc9hNMI6fflVvINAlxnLB0V71qGrGWbIpgeaCBlJV2SNBwHlJaX5sK/ro7I/zqNynhNrefi6yIRUOVLFsxY3+LnfzeEgVo7j9IPK2K3267Y+x8vHr4eel2khbzmra281i7Fv1LSRl0NpCs064RST6SE8P6G1TwECGGMdhTFlUzloskQT8vLboK5dx6QGxc+olVpP0V+aCtukFffXYBLGFjpe4zKXBR5FokKruTNffcaQpLnC7ZS8dkIrxYjpMo/iN9Yd6/IDbapZsarcn2+R43tlVdX6CXjLU4JGYwKYx2m1stwUbBvXlMk59axoVmRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(71200400001)(54906003)(316002)(91956017)(186003)(2906002)(6916009)(4744005)(26005)(1076003)(38070700005)(64756008)(66446008)(76116006)(66946007)(4326008)(8676002)(66556008)(66476007)(508600001)(9686003)(83380400001)(6512007)(8936002)(7416002)(44832011)(33716001)(6486002)(38100700002)(6506007)(86362001)(5660300002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7xam+1WuKtJeolqySqJv0Tp9w4b4PYXeN9m+KCFJQzAFai8u/dXPDFO+SJl9?=
 =?us-ascii?Q?VLut0vUGPdnutqhnHQEZ095BtR70kIT/RM02YhEMEFl3nFzwqZEkT9/po+GT?=
 =?us-ascii?Q?b+g0zn2rwJFd+5BkkXIMB2LId0lOUCg1sOuchIVKFeIA+z1u3cCBF5/UDz16?=
 =?us-ascii?Q?pb6vxXmTLkkp3EPwgYR34vpS4zikZD0az6+8m5TqjHgDbY86YlaXGWy+B9Y9?=
 =?us-ascii?Q?biU2RbN1xZjsMlNZ+LHj3j0lp8AVHf6yChsFytvO/WYOSfvw42Y4RsdR2fXl?=
 =?us-ascii?Q?OM0SGbDSkf/3olvWr8LfQxm/vs8nSOuceMX6LEPz2jGKs4R5mZU8xuO/f1Jc?=
 =?us-ascii?Q?EleQL3gbIDc5hKZqTi3bBHnsFbcXyMbmbzkoLI/oOAqDfwNt8iegg13wtLXN?=
 =?us-ascii?Q?3Nlynz63ETvMUNgznneKi40FRvLXGa3mOqlD0Mkuk2GrAde7pY8QkxRr2XRv?=
 =?us-ascii?Q?1Z8OrfjFP/FTweFZqLc16Ld+WNpahOHhym2hr+/vQTVIAZToxyLtJX5wdDuY?=
 =?us-ascii?Q?X8zBOMLWN6futVhChR9qMFrPiC0gkr97w/ZXBcNrQMx/lU2CPek++Czk//lt?=
 =?us-ascii?Q?U2ysaFGsdXjZ4JyvuXM+5YfhVfAtdpcBiCPzpF92sA4RBB5thO9A6SXdhoum?=
 =?us-ascii?Q?CHUprN/scciqAYTXrv93rItNpVFz3DY0iMQjeeKUa+oLl5FMLvr+CTBMlIww?=
 =?us-ascii?Q?8HTi5A6jWQ9hgcr8IJkVPFQz/R3UVV4aR4bm4qdA2KExM2ccoGbCu2BXmMz5?=
 =?us-ascii?Q?9hgUAonRvSvnYppAIFN1TnWuGS5v9iBrIdKO7yZNCWHC7NOSmD37NltdoP1X?=
 =?us-ascii?Q?y3remXHGLE5r3X/Ch/n4jrt5F3tSuwL5Fz/BFtxNtWfI8Fxdp0rbcmf2wZ4B?=
 =?us-ascii?Q?lZDM93V56ypg1Qh97v13z+V5SrFN8tjr7/XPKFN3XvGJ2CXlUIAp+F6yjMWM?=
 =?us-ascii?Q?lbCGvire+hSjrxixq8yGZhvmVoWc92g9ruaazqhskFihkV1vux6dkkapvHiW?=
 =?us-ascii?Q?n50MRNu6QNzVJVGeO716tuWWl6fHOKccdCHsYscOjaHiss/GeAlaC1zESHkF?=
 =?us-ascii?Q?GZz+mDlUVl2aVg3CAe2AiHR0VAEZ7mxOuHnIQ4CKVP1liPAOWJqm0KUsrzyk?=
 =?us-ascii?Q?NT/iDRulyCO8HbalYpS19pxJdErF3KRCaSmRGp72vQOSO1vkQcHBoA9QHEQ9?=
 =?us-ascii?Q?jOo4P16SakXbtPYsFWC5UX7v8/w+AoSo/sMBa4NXPLjuhlALrRxs9HAuYTPU?=
 =?us-ascii?Q?MR/EUbwWgx/vvH5YNJe2Gq1hf9/eYKoh2VB4kWCnJRafmVBrm5HOoVOIEoTk?=
 =?us-ascii?Q?E0wuGx7djqsA61eNmqvGcfpxpcoqEg7jwQW9nziPg/st+5biYH4jjpwwb5o+?=
 =?us-ascii?Q?yP6068skeJijbkRPlr82TkKRpQgY9TNeGvTzU9tTYu2Cb1Mp+VYeBzWwO6mS?=
 =?us-ascii?Q?BRI8fd8K4i5MyD0PftoSLMk06nS9yhCLpZosw5bGs/gS8/iL5iVTDOGNXJpG?=
 =?us-ascii?Q?XUNe66hc497YajIONw+PYKzhVGc830D4ns09DbpiqmbMSBukvWpZJLWNWo0e?=
 =?us-ascii?Q?a5obKtPrlSRSp6tuyr+NMSWNR8pFIWlaiFt8tizaeDbR4en5G7MqyFHhjTiG?=
 =?us-ascii?Q?1rbemMJSJ5gX5GpWmM6wXowS4/Fs99yj8cthNmAbb07K?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6E95DC6C3D03DC459D26B6CCF37D8DC8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acf08f0e-4b9e-4b86-61a1-08d9ecaa53a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 15:30:54.0379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: diEV5QB6/o5lcEFS01Hn4o2pgqk9m8mR5EDDfw9piP1XfAtH7NYHJ+EAv8HbgrXwXuSaE8+g6ZbpgCeG7t7n7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4730
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 11:30:43PM +0200, Vladimir Oltean wrote:
> - It is possible to artificially fill the VLAN table of a switch, by
>   walking through the entire VLAN space, adding and deleting them.
>   For each VLAN added on a user port, DSA will add it on shared ports
>   too, but for each VLAN deletion on a user port, it will remain
>   installed on shared ports, since DSA has no good indication of whether
>   the VLAN is still in use or not. If the hardware has a limited number
>   of VLAN table entries, this may uselessly consume that space.

There's another, more important angle to this which I forgot while I was
writing the commit message. If you don't have a way to delete VLANs on
CPU ports, you have no way of removing yourself from a VLAN with noisy
stations, once you've entered it. I'll make sure to update the commit
message for v2.=
