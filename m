Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69BF760FA4B
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235728AbiJ0OVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235761AbiJ0OVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:21:30 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80044.outbound.protection.outlook.com [40.107.8.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEA37AB17;
        Thu, 27 Oct 2022 07:21:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z78fDubS1/EmrNjw0bjYEiBEoo4n1Zw9H4sDCYU1bl4TaiBf8+wB2hWouX1lfNonPKC735CG+Z4evUKCacthDM8gGkTCU9ffwmFkVBFfk7hnetX8feq35djz5DO0rNn8pcCLcX3aioWhdap/R63IH5+043nSlMEOA3NjGK2Xu7lXITUeN2PHWfe51kuk2053unfatdsCmJ8w8gJoEJl3xS6HeK+dEJqz/H41WgBqaQAl6UpJuoEDNGCb1ThPU8WOCWpEi35PRiZEi7KJpXvd3I9YYGPGZd3mtxGklxlKXd0RVaiVJwD4zdx5G1nTLeuekl5ldusLlnjpFt80Pn+dMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=829ejEegCvD/88YxKfzolYcMuywLK9jRkMDeKj+i86M=;
 b=NHbhIE+JRQQc+s/vy11PsxNrSjBVqq5sTIAhEeUHWPdbNCwfDKas7U9Ds20hkkBXApnZVIvGJalgQlCANHJjLOxF4HkBW1hAvIJmHt7Bd7TSjKBZKb4lcGbxqLQMQA9wEf9E1GerNRWaNetxOxA0Xd6eijbJU8Rqc9Tn+H3BLl03XEPijbgOV1EajisRchHMUviObG1kba9RzAKi8AfYr4nCS0RMOIHbr7laBMH4/4BGuVFbPISpPAaVQi78jiOihM2HBVF60gxsWgwgE8whnIJSdz0+A2544ASC/CmNrriaz+xPbLA4hbHqLbdJ5N/NC2wPFdoVEdUNw0RDIRCNpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=829ejEegCvD/88YxKfzolYcMuywLK9jRkMDeKj+i86M=;
 b=CQba3ivcSkhjPvl9dCWVUI/Z6FXKlRFa/JBa2fnMXZBdRRXyi9BVCEOy7HnDe7uE3ER6INTn9fYjhfw0oij3+Dvn9Sqsv+yEKLanD0FzvJcFAXZ9OgnnP2fFgqcdB4HQAplXQolFbGgqdrYglm85saaeXH5VPpSmyw4v6+L+KGU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS4PR04MB9314.eurprd04.prod.outlook.com (2603:10a6:20b:4e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Thu, 27 Oct
 2022 14:21:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035%6]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 14:21:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net] net: enetc: survive memory pressure without
 crashing
Thread-Topic: [PATCH v2 net] net: enetc: survive memory pressure without
 crashing
Thread-Index: AQHY6TRiZQ8LCqV8m0qJGRg70aV0FK4h0giAgAB6WYA=
Date:   Thu, 27 Oct 2022 14:21:26 +0000
Message-ID: <20221027142125.k27ns6yan4rmxmwo@skbuf>
References: <20221026121330.2042989-1-vladimir.oltean@nxp.com>
 <AM9PR04MB8397AB65FDF4990B9E941F2E96339@AM9PR04MB8397.eurprd04.prod.outlook.com>
In-Reply-To: <AM9PR04MB8397AB65FDF4990B9E941F2E96339@AM9PR04MB8397.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS4PR04MB9314:EE_
x-ms-office365-filtering-correlation-id: 47756865-710e-4393-f94f-08dab8268869
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OtMEkOLaFtaCSQjxsRI0eH88rE44briLcOKiYjTYr/58jldNtCXAyXre4E4chL4PG+nRLz24Hf+uiDDNDzpLgX7FYh2h7E4HQXXMEhMpNh9+j8da+h8PVFQSOh9T0pqO1LiFq5YLcIr5bf/wBnoFRop5Iu3r33WAZoCq25jK1fjRrHcctP4d752TGc/iip3TzSHt7KpoNLUNVmXSJWOLRXvofEwkTLSZor8jJ9+hYKe3QKRrrdm78m9eWBZ4GYvxV7HuafTs5A8BzjdEHA215q931WQva39vp/cgkrWc8vL+eLUFHp0gx47zn5wim+28Ozgkhr6225z2CleFhns0llGvUQvs34KV/a6cdcobfmZsGUCuSoo/VzDaStqzmXobPDRXyO/BLDMR45ffJ6w6YFnAV9YFk+DojZ1PQ8BsTMn22etPXe6NDGJF+FDMfS6TYAjeLXH+9APtbTLRcjvhdGv0k7S/ntzkjw+777Od2ajOm1RUmqUeNdmqm42K6DSoC9p5+mc6l9Cr/TYOKc1vI0OBC7jeUg6qIgJgLQiI7xpc0V7vOrxLZ/ckYTY7SHMghPZ0HQdLWhVTcZUoOYyw/RR5fLItINvhYRAYRHO1t4aHgbZktRj67IQ7TH3iOFteYFjKbj72IXoHon9/27FAVym4p6fUIgteo4yGM/LNhC1GlUgWh8k/MkdHNP33yeHHhMm2KyMg38uA9DwZmSnSuFxPwtwkQbEO0jr/gzIAxsPq7LaQ+tjHXIxwBMqxl96cf8PKVxWgxY5A+Lt2taqYsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199015)(41300700001)(71200400001)(64756008)(66946007)(316002)(66476007)(76116006)(66446008)(54906003)(4326008)(478600001)(6486002)(4744005)(8676002)(5660300002)(66556008)(44832011)(38070700005)(6862004)(2906002)(86362001)(33716001)(26005)(1076003)(122000001)(6506007)(38100700002)(186003)(9686003)(6636002)(6512007)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SELkCbGniCAcM9Lx1lRCZiOgGngPYn+wwY2MUM+Eg8TxcZfvAUpGU71kEBDB?=
 =?us-ascii?Q?ZInZcu6hG5HR+Owb900ml0SYx7m2cbEHjdDT0jjKEtbbHoFJJfoYjEcbrFJB?=
 =?us-ascii?Q?S1EyyPCOo53nEPMQJTc+zbDA3bpJvTpLFDustUZ1Qn1kKFMcCpdvLZe1Jpji?=
 =?us-ascii?Q?YysbCP3wxPn0Yn/2cC6ASk/nXv60b4ukOlq4hdYHP6x4P0y8XWUwaHs537/h?=
 =?us-ascii?Q?KxNOumAuO/ZsZJ7Ro4SNcyNVjTqi1pvhY01V756OYgqCSA6fkw0bCdZraW0t?=
 =?us-ascii?Q?3XI9ePrsiq1HsRosmeYHXyZa5m8fP10T2iNMpkhUWUSw2H+G591HXCt4Mu14?=
 =?us-ascii?Q?NNUujSOm4pW7XeEq8kbUayCL7lRWUSFLfJpQ09nNgiAlrPoG5QilSjfiD5+L?=
 =?us-ascii?Q?PB8mwmkwMs/zyQ7krs41fWcvJqWwSR24K9k5NCQ06l3z/WuCpy3XHDJBecSw?=
 =?us-ascii?Q?2EI2ivPDMKp/sgQBCUJxtZ9PlfS5ce6pqiNZfU9DRNrbrAIze/bzkJV/qiEY?=
 =?us-ascii?Q?wZQzIjDUOEmxouQLiAeiW76v6mM/6yrqT14OODvEJhzmE90UxJw9U2dokrni?=
 =?us-ascii?Q?kqHQD3l84XOnQWKOKwlpU04cZFEratzwATaz1sSEAwnc7BSgjJfWEQYsk3Ja?=
 =?us-ascii?Q?e5uGVhcUolrsG3R+RCSHnx5ZAC649rmkwZxYOEFK10YtK/wsaFd8q1IMO2Jg?=
 =?us-ascii?Q?Fl6I2SGFyaFzVQAjrd/sF3h71w9VchUKx/px4ESZCBtcHHZ3twyWaac1Ccsb?=
 =?us-ascii?Q?RCKNcRoa/4cwcQ8WqQcceDaWPvK8dsaNvc7BSgO8Ko7LC3Ij6JeLccD+f+O6?=
 =?us-ascii?Q?sLW3uic/GuKIa+igTK1nbslKmjT/bjgHnxdxlWA/rwJF6/QGZlslFQsk4EcX?=
 =?us-ascii?Q?m/Q2e7vVLaVRtw14jOr91jE0q2Cp3p7jlLR99nnVEFNtUEg6PTWHTS5Vh4pv?=
 =?us-ascii?Q?ukYinfQxNJ7ttX0IUThUq99J/lrPjYApGZApLG+4PyEz1ZqhM1eHIxlewmWO?=
 =?us-ascii?Q?D80d7MuJVUkgIA2OrRBWxlawm5Y/4DRek445cO0g4MXyrQVj0+vnwy0e1idK?=
 =?us-ascii?Q?SBkAV/WaRFqVV/apLh/SOOFK9L5ktcsSw/pv0xoFHKaMSBQNCimNpMru0hhU?=
 =?us-ascii?Q?MiLLRBdn2Ia97kIrQx5qipNFBYpLa0aZS/9ykrn8v9oviyDLZP7jfkuHKCQ4?=
 =?us-ascii?Q?fddbuyUyxWBFuGt4IBlDVoDMCsE/PhTKZFs/dj33zPIxPFHCIsrtEx5RaKTq?=
 =?us-ascii?Q?nMBrRuJ6sz1fpfMjwtH3XPy53JBxqXEcdjv1OQXicD5EVcw40GtyS2iVeYgi?=
 =?us-ascii?Q?S0GEoi8CuBikjjuiqTDB21HMrWAMeqJ1z3Tgr/NoaioT2pRqdDbuS5zUMpmD?=
 =?us-ascii?Q?vSQEFlbEB8zZnIaMQUcm4qKdask8D9gaYYpIs7J3wLgc9Zcvg5bTyO/RdVIV?=
 =?us-ascii?Q?tM6pBZIiC2su2RvaYuFTmRRLiROu6Osi5CEPdQiHo4Z5gDpwGLXrVmNvFwUt?=
 =?us-ascii?Q?FLrvkNw2WUp7RO91J4y/dtHgusDnnhFld4QmcA/fEz57f68rHS8Vkt4nZUxJ?=
 =?us-ascii?Q?o/WdS5+/fiJIuLWv6I4wJwnE+Jh+lOxzK+qXQBHrps/0yC2jHqTqh+FYr4H2?=
 =?us-ascii?Q?3g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <82BD10F6F066204B974DF37AB0D10706@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47756865-710e-4393-f94f-08dab8268869
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 14:21:26.3104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9O843OJKgE80S7L428b9pia3o9cV2YP+0ere1Yc5HpsOOJi+8BzNXG9ONFs9JgCTeE6lFtKs8HAREQ13v2Zt/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9314
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 07:03:31AM +0000, Claudiu Manoil wrote:
> How do you trigger this "extreme case of memory pressure" where no enetc =
buffer
> can be allocated? Do you simulate it?

As far as I understand, making dev_alloc_page() predictably fail in some
particular spot is hard and probabilistic (but possible given enough tries)=
.

The reason I stubled upon this particularly bad handling of low memory
in the enetc driver is because with AF_XDP zero-copy sockets, memory
for RX buffers comes directly from user space, which may simply opt to
not put any buffers in the fill queue (see "xdpsock --txonly" for
example).

The fix for the case where the buffers come from the kernel's page
allocator is simply analogous to that. It would be shady to add this
exact same patch only as part of the XSK work, when it's clear that
existing code suffers from this problem too, even if it's not easy to
trigger it.=
