Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142BB693331
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 20:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjBKTCY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 11 Feb 2023 14:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBKTCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 14:02:23 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2087.outbound.protection.outlook.com [40.107.249.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B964530E5;
        Sat, 11 Feb 2023 11:02:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCFPEZxAVJF6pQaaSAexr1nnrq1fXdHZpnsnRp+HeND5S9ll7bXKk0h6KX0nOwsMNEgSbm3B5rH/+IiIXODge34DQ43+FhmOyUX8Lf9/2yJOaAkz07K0spPbhM7Tf2GQwtH6b3ydyD7iszIWK+dZRPMSjtH7PAaDa7nU4jo6yWiXEZnIcfqLCPh0zkFlvwdPhG1RTT3/SymgTGPQMh5N8tbkjYL48NSss3WXu6K1n12gj4SUMFjp46XVZYYd3ohWA6F0k4ZbQxY4cTRci8tws162zRDvyWq1L4FHZbes/E+x7p1MFC59tqFAgnou9vu4Smjb4uZTnbFInU46L3v8Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJbnX4TeRlxTIlcfI4XS2zn0dkZIIquLuK4YVej9afg=;
 b=fnMqdZv4MSqYKyQb9wbP3R2VmZ9SIaGdgCThhVwKJQBEOhs7XudEOcdJTbJn1TC3fA/c8FXchB1yKA6/XhJ88nFGGGPVd413t5MO1qfAA55AnBUna+4X2JiMyBl1wl+jlsNOIP2lHvI9EGlQ8rbWE1jjhzf1KhwbMYYUXndEuA5MFJG5PXT4LX+omT+MhoVLCOKjnMx3hVgi4CNb4MmPVAaAM9A3e4EBw+Gu4RqT1MgTwbr9J0m+Zz86ffYNRHvy5SpznZaGqyw+3aLTDO1swo/pln2rSya24jS1WMbK/rtkp4tHp1hTCulnkiXUBmynY7Rv6JnX4OAO17kzwRs7yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=routerhints.com; dmarc=pass action=none
 header.from=routerhints.com; dkim=pass header.d=routerhints.com; arc=none
Received: from VE1PR04MB7454.eurprd04.prod.outlook.com (2603:10a6:800:1a8::7)
 by AM7PR04MB6839.eurprd04.prod.outlook.com (2603:10a6:20b:103::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Sat, 11 Feb
 2023 19:02:20 +0000
Received: from VE1PR04MB7454.eurprd04.prod.outlook.com
 ([fe80::e4a3:a727:5246:a5cd]) by VE1PR04MB7454.eurprd04.prod.outlook.com
 ([fe80::e4a3:a727:5246:a5cd%7]) with mapi id 15.20.6086.022; Sat, 11 Feb 2023
 19:02:20 +0000
From:   Richard van Schagen <richard@routerhints.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Frank Wunderlich <frank-w@public-files.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH net] net: dsa: mt7530: don't change PVC_EG_TAG when CPU
 port becomes VLAN-aware
Thread-Topic: [PATCH net] net: dsa: mt7530: don't change PVC_EG_TAG when CPU
 port becomes VLAN-aware
Thread-Index: AQHZPktX+C8b3oVL10yg7TqKJRr3Yw==
Date:   Sat, 11 Feb 2023 19:02:20 +0000
Message-ID: <F60ED8DB-C0DF-4C28-8D40-A91DE698C165@routerhints.com>
References: <20230205140713.1609281-1-vladimir.oltean@nxp.com>
 <1C64196D-371F-41AC-B357-41100DC66C2D@public-files.de>
 <20230211183143.2jb26kljgpwyc2jb@skbuf>
In-Reply-To: <20230211183143.2jb26kljgpwyc2jb@skbuf>
Accept-Language: nl-NL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=routerhints.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VE1PR04MB7454:EE_|AM7PR04MB6839:EE_
x-ms-office365-filtering-correlation-id: 075087a2-45ae-488b-e1e1-08db0c628093
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zAplOeC8wrzcFif7gBHxu93WUbUTkWu25wlW3pdMGeN5WkPRny2pOqu0XpXXbmjLQzpMbW5M/Q+jSK+sDTlWqmNW8GP7xEzovCMgQNZkTfRNLRBiXxvzweH4daRByqrMMbZgPgbF+CH2/tL6DvY6E2zMLtlkqgjs91qtqeoX/3/WQElshSzQIJ74W4xiG99UkoMNs56ZOCSdmGJjEPP+Yg0ZgwgokpggAz2Vojicm1+DGrdJNSqjMEGtsBihnu8iI0OJOsLY63yFC+tUdiAZRCHw3m65V2I+EgILRiJm3pMiAqhl519/eyQk7c2nG3+k/+x/ZzQBfQ6gCpzIgxQQ8/ljtj3benuAdn837KqLx5MC/3JhSINxdyjjidMN9ZggD6AVWjt3tvjxBJeLqQL35jgaF+PXH4XD+gkz40Fy/biHgopsBkGWfA/sHk8Nu6m9BMpCHcaf+czooDR/t6IUdpeCPIUzh0Ekt1S2lJuWUIrfEImiKG50h3jVA0Vw641/TqyxoE4sdDFIMerWRWiOCj5pW9Wg5NTxAkEWaaDq7kTD2hkKVi2PoEhdBm+XHYZtHuBK+NoTzrkOcuZuL8A6anm4wTwoZ2hZD1708IO07Kb4bbWdGDMm2cC+vE3IK/8VllNHlH1cb9twjjSppubt0K5HJD8fcJ4L9G44yEDL8/W6d/Vk8SqbJeY8pgwpZpVceH/GeMf+MV3IHXF8rlw9c4LXRvqE7wobgDxTE5MfC1l16fLk00rN4rO6eP9/teGUGH794WsERYo+5FMtn0DL/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7454.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(396003)(376002)(136003)(39830400003)(451199018)(66476007)(66446008)(8676002)(66556008)(64756008)(6916009)(4326008)(41300700001)(76116006)(66946007)(91956017)(36756003)(38070700005)(6512007)(6506007)(53546011)(186003)(316002)(2616005)(122000001)(8936002)(38100700002)(5660300002)(54906003)(6486002)(478600001)(33656002)(966005)(4744005)(7416002)(71200400001)(2906002)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GH/XS1UDkzlOh+TIr85v3GUugzkq1iIjFGYwe7zYpsdXNL834SvV+yho9Kpx?=
 =?us-ascii?Q?k8Okxx1c51Gv3yQx3RsCKzhx3U2lVg5ismH5JNs9LnAOr9UkTR5EqtGXALHi?=
 =?us-ascii?Q?UZchcohqKNIfyYKyNFvDaNoamCijm9tKGc3742kzC4NZKjHwAA1yqB9lHh/p?=
 =?us-ascii?Q?ML7EHR96F/js/ragZyYZpN8wq781A6KvtB7EAOY4ZWzlTJPKGV5x+sTaIRww?=
 =?us-ascii?Q?PD7LaeeFrlMDcw+OIkMZbG9/v6chY6gmbE7Lgd5xW9ZTxguBUPGdLZTmZ727?=
 =?us-ascii?Q?LMHctlZCizxhbFzc3ZrNzU59tJaDVzPnrWRU/rt1DsBfvVsyNTGM+kK+SHWq?=
 =?us-ascii?Q?gau1kqURVCtVb+m4osBiOpmSZ3wopOf7lIl5jGytf8a3VcQNkOoZRHRh75j3?=
 =?us-ascii?Q?BqahFn62FNPktSkKKft7PZDSlacPDpauRzXQiNzgCmODPNTVZB/90aypjae5?=
 =?us-ascii?Q?zI5jDCI49H2uCvjPJ+nfsUFobTPn6qyD0h9a1mbV3kQf8u7NZodRYV+RDjAj?=
 =?us-ascii?Q?KpF3SFuxs1mVFaMK5O0DYpx/K5NUxPOdYKsqUtliSlEu/bvV4qoAdLOpym6c?=
 =?us-ascii?Q?bh4aBXA+uNF3WhOit7bf4+ua8fAtPg+VGWfb1dr3UXu2YwUMJ96lc19jvGsk?=
 =?us-ascii?Q?+d96ZIHKefLUxVThhsGH/2v0LYhiYZnf95jD63im6ijGE0y0ZTpA8QKtA9tc?=
 =?us-ascii?Q?Pw9BBivh0xGTrZXl/3J3w/TJvs4TXkpmPdG2eIFzSYNbwci8+XRfpj1nq1Op?=
 =?us-ascii?Q?zQI1XCtlCHp0ce3Tag8JUST+GDsTBiK/f4mzf3gzj1AAMxJLfBMRwEMndmFt?=
 =?us-ascii?Q?hlilCEO8yPaeRqBIN9ifDPePKYfNZ0m+7ymJjr9zK5RloPS+g6HuCKBtb/hP?=
 =?us-ascii?Q?Z1rg3BU8E6sdxi+qmr6e8gFitNrB1fKWHpN/xSrjgUW+2OAseMKy3euXOlpB?=
 =?us-ascii?Q?RgYAAORwpgnAFrSnURfDIUBDO0IPBCfBG33KIb1rNc3RbZGlauqPS9vn3iqV?=
 =?us-ascii?Q?F0NHpzf81Bbz9kYnw+PgrQ8BGCcckk+H8tjlashk48VSHH8oMwvGuhrbqfoA?=
 =?us-ascii?Q?UY6rO/ps5pKWfJYkCiHZCUeKrmMzKdTXaE0ld79TwfYhaNN76Be7FzfsldHd?=
 =?us-ascii?Q?13VmpSNj/MDqSqCcfGEX5tdwyDxXjjbHSsD28mDfMGbQymATVzHOVOtlhNFs?=
 =?us-ascii?Q?XadU3QwFnR5DzxKHnBXebnpE1bAXLKKOFfK1i9XH4BNoZZs/9Qm8urjqUFXM?=
 =?us-ascii?Q?3DZECW/uEtwOr1OpmyW+oIxkg5KDBhvXDVpzP/BHRKbnN2INdL2KBjfPp0lj?=
 =?us-ascii?Q?h85oLnwix+Izr48P5RRemgpGsd5qJeT9YKd2do9XjWKrUl6Mty2XuDLbZRdL?=
 =?us-ascii?Q?7lgwp07ljctcvQTZuFOiZ7M1Fb0iwvt8ldN0Qt3BCIOQ22Pkkda3YhMLVu+0?=
 =?us-ascii?Q?XKo31DLWVyBOfLFMyA+DAQUflV+tqrWB2oI+Nd0J8csgxfxi5xEnguosYoQq?=
 =?us-ascii?Q?EHSbx6CfW3iaZGL7O9I/AL5ns/tdslZQy2PU3g6p74Vf+gH8hO0W6SzNH3Hb?=
 =?us-ascii?Q?ssX8fdXc9I7C47gm+1RMqZk+o282XPqjkOOGcmuXQEJwUrvRp7W4YxWdRqBW?=
 =?us-ascii?Q?NUeBzeGa8IWrrzTmRNAbuXzWMjZckDNg+tD6Wul5mhFGr/6NInQZ4PDMvaA9?=
 =?us-ascii?Q?cVp7wg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EE9E92790DE5E9418533758236EFF904@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: routerhints.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7454.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 075087a2-45ae-488b-e1e1-08db0c628093
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2023 19:02:20.5935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 28838f2d-4c9a-459e-ada0-2a4216caa4fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rdVAaBoDrp35L3ubshPkgK8Bt7hmrnY9gyf/pc3gvAMhH8dOlnuU6gwQu6RNmFVkw2J8UuVom6Egb8PEMPqgKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6839
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 11 Feb 2023, at 19:31, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> 
> On Sat, Feb 11, 2023 at 07:04:14PM +0100, Frank Wunderlich wrote:
>> Hi,
>> 
>> Can this be applied to next too?
>> 
>> It looks like discussion about different issues in mt7530 driver prevents it picking it up.
>> regards Frank
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=0b6d6425103a676e2b6a81f3fd35d7ea4f9b90ec

Sorry, that patch is wrong. In the shared tree with Arinc I have a different version. One without any need to set / change anything on the CPU port.

Let me check with Arinc before I send that one.

Richard
