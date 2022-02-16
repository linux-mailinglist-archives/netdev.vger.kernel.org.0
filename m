Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76944B8676
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 12:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbiBPLJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 06:09:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiBPLJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 06:09:00 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2053.outbound.protection.outlook.com [40.107.22.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD7385665
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 03:08:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQ0MMzJgbdv8clBBO8gzTgcag0TQIErN5WBcmtg8wjZfXjIXiEGNeZ/OLCNrndYa5T0dfm0vjB1l69uScAShotljuhawLLh+3Iny8CxfFDEQej17fG2vuOJWdL9/amxJHZKMLz1BYFCAuT8HM1TWQYZ9SptbruAEcVg2y56HYByr8eG22dISPWaM9L03oYBdC7M3/Wuzl/eBsPoRSTaBoKh2vv8wAEYKTfsMgBknUO7zFl9IC3MI12mVv4KhV/c0EDfML91pCo0ocD1085TpC0feHou6d86rgXQGVoBSgs0nnmNyqMQGjgPYEteQDbR1P87faOOi/1j1/tdiDKeTIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HOt7X6eaGpIjz1GokRl8jYEqpddLQ9INS22VQeVhodI=;
 b=gp2hny2zNz03U45NLqNzqc1lJ0C/vmBtskYq7tqJhHXDe9VyHrlr754Rncv/FytU2O50WXYHSckLXDzY2nWqW9LtzXpS/l88UwQAAc1uEBMaVN9THVlBiWw62NS0uQ45PTex6iCmbJh+DJ/ekdnpDvOMa37uRQbxyP1v/YSPnhV1HaKNsY+B9fJpFhsdlM2qyKfZ1dJIpJUEuqwoUjmEcPGqBqfX3xZkaPtvm9ri5GCzuj9alxcK+CLT+k+to5eDmY6t0+cYMquObRSsqzJwkxEs088otEiRi52U14Cmf3oKe4ZUCfEdEGCwYMckaierguBgnZFR3BSYmJTh/IwzqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HOt7X6eaGpIjz1GokRl8jYEqpddLQ9INS22VQeVhodI=;
 b=pLjftCn1hsWZKbXQPsDdPvC4CDjepEPWUI6L266jcC7FXTUD4SZyIa6fxjpGN5Y3aQTr9I25+VHA7UTAFIpUu9dZ5p680ZsSL5DuIuEiCqmjqfuhsHCrNBH61iv367bBq5jwP5FQkatEX8xbyBQbBkZabD9g1yYTLNF78nIO0zw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by GV1PR04MB9215.eurprd04.prod.outlook.com (2603:10a6:150:2a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 16 Feb
 2022 11:08:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 11:08:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v3 net-next 03/11] net: bridge: vlan: make
 __vlan_add_flags react only to PVID and UNTAGGED
Thread-Topic: [PATCH v3 net-next 03/11] net: bridge: vlan: make
 __vlan_add_flags react only to PVID and UNTAGGED
Thread-Index: AQHYIo3QKMNWibr7wU2VlIdM+ujENqyWBKoAgAABW4A=
Date:   Wed, 16 Feb 2022 11:08:45 +0000
Message-ID: <20220216110845.4vu2bcsuez5jhvn6@skbuf>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
 <20220215170218.2032432-4-vladimir.oltean@nxp.com>
 <79237e2d-e1d2-c6cd-975d-b28f064a2c20@nvidia.com>
In-Reply-To: <79237e2d-e1d2-c6cd-975d-b28f064a2c20@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c589d408-466e-476b-dd3a-08d9f13cb36c
x-ms-traffictypediagnostic: GV1PR04MB9215:EE_
x-microsoft-antispam-prvs: <GV1PR04MB9215D2BCACD18314784060A0E0359@GV1PR04MB9215.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:785;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TyNv0UhFZe9E3b8BgFLKjuDAco+hGv1Pw1VXghofJZCfB2NjWcHF0s10pFpF1QA6GEHez5HF3H3QIRhUMo+CepW1n7j1E/4Pd1dgVkqwzd6DbaUEp+yPI+5W7psSKtaKCF3Ir0i8FTExHAocNN6Z14hhbNPMdD5LgxLv7KBvY8x9apo8zVFJp/baqxCbHzskdr6T5bY73CUUMYnacNG1BYEsFxqvcp7xe5kVaMswH+RdVYmQdVQwwS/sjBrgG/3f+WPbLYwNX/DCdWdiWnJUoIdx0D55GO95lIjFv1CiiIEgP75Ra9dANVqzGgaknp2uB4+6CPeMP+fihYl6Y87xqjmnwo2S/PJHqj0w5Cp/JDBtmY6GZEXZP28MvmfdSg9qxbZKX9btXKvj344fHsT52UygOV3qWoO0OqQP/g/RTJUTZz71pqhUTMf8cIPS5MVMEi7K7/UCwTyEwLjBPe88QNUmXO3fuY5OHvPUu3JqYSxEjg5xM80xOzNcmQwwshKQlv33Dgwo2DWJp7iblzss6aqCRDcZpR4ICtVWCfAhpm9zTjP+GIrLmW4RMj1jlVne1lQaGvWVWekEpPkJChfkrGI4EXik3ZA8POLcFB3JCV4dP5O5KiGLEKRsc3Podj9ES+elAtKfUOeIxNngDurpINbS0IzNhWDO0PWXy6bgMWgO3VGtMBwq1Umf97/fvYZchjfpnJnLx34cAQw30lmjsQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(316002)(64756008)(2906002)(54906003)(66446008)(8676002)(33716001)(66476007)(66556008)(8936002)(91956017)(4326008)(6916009)(86362001)(66946007)(76116006)(186003)(7416002)(1076003)(26005)(5660300002)(6486002)(122000001)(38070700005)(38100700002)(44832011)(6506007)(6512007)(9686003)(508600001)(71200400001)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2RhALXKuVIazblfDioDdbsNTwoGLTYHvtOx44jfyFtz2CN8boOS5RIRzA1m5?=
 =?us-ascii?Q?+oizJf6y5moTYGLNHq7t7Av+h3RlwDskmSzEdRRuJLenkw9lvq/yrOfd5/l/?=
 =?us-ascii?Q?ZBSP7AgeZmZN0UK1MqmJaVRPsFvzINIG88tvwKSjjw6nHCVMnyvkSsag2v0Y?=
 =?us-ascii?Q?bQqROnv9opEGns6e/ExY4CPE24Oq01XL3swLQEbaAXi04GmwPV6tR+9kAw2r?=
 =?us-ascii?Q?S++aK8TpxWuTD2cayjIAhCqaa2zlmSXNdqUkJQbwwjLMlTgJkldwcp3HSrs9?=
 =?us-ascii?Q?Y5l4wOaD5+E6a5O6Si6UwkZmX3P/D7tTDu0Shu0xwOyDMVc6l0GEnLMC0RjR?=
 =?us-ascii?Q?8IrwMWhDkGVrkoHUXJsbvu/JNIZ3Xcc1wo1Zwx/DB28BkcvAhgZg3f3puugH?=
 =?us-ascii?Q?MZRq1+327cfg3wni7bF7EOMqZXEw/9wLnDTg22xC4pQr7iUKZbrWXgTm3aNM?=
 =?us-ascii?Q?C5wXOQXFZ3sUoQHlxJBFS8QP4PB4pJ9DOcwI0JDscrD47aQ3mf5VjgX3sH79?=
 =?us-ascii?Q?xiDxdxg30JKHNJTI22DSffpddRJ13pEWwzjkheYVV5r+H5kid4u6mzE8YhLv?=
 =?us-ascii?Q?mLAAlBjqkoYXr/9/TjIWaN9HAp6JszMHrQSOhOFcEDCv7abDuwuvuI1ir4dC?=
 =?us-ascii?Q?6Zo94eME5IyyxDLKtN4WRflNn/DgbshZ56WAfkjGzFZyIXD8JIy0Qp2U3ype?=
 =?us-ascii?Q?NJa6FaLoBZPhAwKa9VgyJZ2BcFWJg1/KCRmbBcQWpp378YurN6ojjT68RUB4?=
 =?us-ascii?Q?irTbAvhQ0hDRxq3cq3bMvXAwG4Jcm9VOcSlSRZ26w2kLjVSW9ZIth/ii+Tht?=
 =?us-ascii?Q?lCT1QzzAvjb6opNLTZx74jXq3egoDBaK2b18izgjvH0wVLLNfBvL+OnvJ3Nf?=
 =?us-ascii?Q?wjOzwSJhVRngxWe1uss9Oas40vip6pZOiwWYXas0vhuqU0IvJuOTjMmZWU5X?=
 =?us-ascii?Q?JPro9BwqwE51wmeU5f9MRBqUSwynLRx3eRPcMx87OF3auOuygzYC9t1zgUDd?=
 =?us-ascii?Q?Twl3IAcxTG5PFxoO6G9O/I0r3r9TTto+yLGI/3AYpcDv+d2dt4qg2PmstNGM?=
 =?us-ascii?Q?cy29ZDOenB5HZ+sMESm7HCHo/av9XqVOblE51Kdb6g+YsxsQoIhIgt1Rkpsp?=
 =?us-ascii?Q?euYrJaeoGQLD/Du2TseL5nLqMmA/EQKFROFQ1jwOzKwCiYCjUuwb2AH0r9tF?=
 =?us-ascii?Q?n7dafz7y8mcdryUaP/1/4OzOFyKivvvtUthnMvNUGM1oCE9nAMmbn00tbS2j?=
 =?us-ascii?Q?F3eTZHY5BWCe0yaTdyJ0ltYZBLJ87sDFqkUmgOBuKYpSi4Uqbhfwlyucz31u?=
 =?us-ascii?Q?y07Cui6hHNjS+LM+5MCg50MZboFJkcCS/ymb+0Zf8qC2/yfOpAym2lSK8FKj?=
 =?us-ascii?Q?zclwls/s9pn6Qq0otTj10zPl0KTrP8Z4+7AuDHpkY7TkeNcZean8bfmg4U/t?=
 =?us-ascii?Q?5GXH+xvGkx5SKV1cfFAhEkD2owyLfxxnB945asVJnjTugGepAZ1dTeQjLzcF?=
 =?us-ascii?Q?g39VxT0MZf5dcZVet82fqSRi7p+2a2CKeLXfBOEM1njfGaa2RDYRAxccOw0c?=
 =?us-ascii?Q?YbI23+N9Uin27RnUr1Qmmb4qIwcx5B0t0K6lKj87BfYf6WL5uPoSTqIv0Vb+?=
 =?us-ascii?Q?aODexeCXl+HK3tY2l2SUbBbM9V8fN7wYqTBPkEIylole?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6361B42A92BEBD458FA404AFEEE60F56@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c589d408-466e-476b-dd3a-08d9f13cb36c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2022 11:08:45.9598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IN65Kc1Ygjmo76IX4FVKmNqPKslOo/k8SYBJI07R5y2q4LiiDI9wT0Q8YB8XX1yiBLOn9ko3WUV80WRq3Eq+FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9215
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 01:03:54PM +0200, Nikolay Aleksandrov wrote:
> This patch is unnecessary and can be dropped given the next one.

Not unnecessary, it reduces the complexity of the next change and makes
for a cleaner transformation of __vlan_add_flags(), one that doesn't
affect its commit behavior. The behavior change will matter for patch 4.=
