Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB3E622515
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 09:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiKIIJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 03:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKIIJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 03:09:24 -0500
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20085.outbound.protection.outlook.com [40.107.2.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223401902F;
        Wed,  9 Nov 2022 00:09:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BDcYZRubiZafMQyzFsVWWm64+lZjQLMftt5YNdWZtCEAX0RSTMSVyp/1Wt8QMFc8bA4wrDytmUlMwIlxAtLoSynVGSAUN67jkODH9fwN6pUGgjoNRrqatQMM9aueRxMZixjsF0zU6+pOWNEghkual7fMVxFMLj115BcshDC7ITNFtvXGC/m7OfaqnapKNe9dSM9abfWFKwfepITkCmzF+5x1LMeb7qhm8z79dDalGgOoKI8zKbg1DJlq0mNWv4G30oiKVWXdV5ng/GXGuSC/IOMtRG9aNG+GD5EtyjJhMIUHQRHOk195ICzhLLhX10yVYt2aRDqy5rDk/7ieOW7uMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mCpcBICFN67qWF9yMDqfNKOhH1ks0lVWx6S11f6CAxM=;
 b=Ux4Mns/0+8hXek8GDmrL0ZjzECmUhInkGVJ8I0SUMGL8Lj19EuS3TapyoyYulcVwUZlPSIt1WeE469KbD/5p2ICcYCjtctuC9EZ23EgJj3VAsKOTQBfKBvuM/ooBAxCcknVf7of9Y2SirQhG2NSBdP0Bm3BJz6zWwzttOGsZySw5mOhaq/kjnt/z/TCiDy3fNVCizaXOcj+joivoYI80bGw04AiZ6B3St/+ukQb4ag1Sb2kjhDI7zpJ0CadkCU/MMoSZglOsgVf700Loba7WXPBmBM5OvIrAmzb5aJ73OyO/EjDkN/Qa5OkKMZy+OMK7+M2XcEy2dJURF6C7JyBSag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mCpcBICFN67qWF9yMDqfNKOhH1ks0lVWx6S11f6CAxM=;
 b=bdhTRp/3IsB0jJXretSMNduehOWa6vD/opULhtrwQA3TDa02FeTNuwsMjkpumjV1suqJri3buE4+vN4ZwDLgXeW/pjTTnuPtpeJpLqE9iJChgbborqhEHsPu7ZszPLLBd6iID35rw+OKhk5kcRMAJe9HvgP2L8bmJn5Ke5Uc2iLhJW7EKNV/aAJIbsbeHhAlECcxKPbr1BuKtBSMpUZiYcvdRZKpULzBrJKYajNEXvXkPnb4i7neuTG/izAXO12OtiBpqnapRbv/1Y6MckZcFdGDryb9tBwdVs4lWN94kltBTgXjzImrWR0BcZ+Z9DVkOpxIdvz72tp2ZsEEUh95JQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com (2603:10a6:803:4::13)
 by AM9PR04MB8323.eurprd04.prod.outlook.com (2603:10a6:20b:3e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Wed, 9 Nov
 2022 08:09:19 +0000
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::b7c1:3e11:9b46:28c9]) by VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::b7c1:3e11:9b46:28c9%4]) with mapi id 15.20.5791.025; Wed, 9 Nov 2022
 08:09:19 +0000
Date:   Wed, 9 Nov 2022 16:09:01 +0800
From:   Chester Lin <clin@suse.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Rob Herring <robh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>, netdev@vger.kernel.org,
        s32@nxp.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <mbrugger@suse.com>,
        Chester Lin <clin@suse.com>
Subject: Re: [PATCH 2/5] dt-bindings: net: add schema for NXP S32CC dwmac
 glue driver
Message-ID: <Y2tgHYT+rV1+fxTm@linux-8mug>
References: <20221031101052.14956-1-clin@suse.com>
 <20221031101052.14956-3-clin@suse.com>
 <20221102155515.GA3959603-robh@kernel.org>
 <2a7ebef4-77cc-1c26-ec6d-86db5ee5a94b@suse.de>
 <Y2Q7KtYkvpRz76tn@lunn.ch>
 <Y2T5/w8CvZH5ZlE2@linux-8mug>
 <Y2UT4yIqk0pV6FHA@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2UT4yIqk0pV6FHA@lunn.ch>
X-ClientProxiedBy: TYWPR01CA0017.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::22) To VI1PR0402MB3439.eurprd04.prod.outlook.com
 (2603:10a6:803:4::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3439:EE_|AM9PR04MB8323:EE_
X-MS-Office365-Filtering-Correlation-Id: 26108198-e30e-407f-48b3-08dac229b3df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z7RS3Xvv6qDJrBc691bmIO9RzeKDsEjwLzwNZfvF6919wEkT4639NRSGWphJdHlYocjpFX7C9CqfDt6AulrI//k4Kzg6w21D5NY0uVyuEZh28ADcGaA9G+nlYzPs+5uIG8j4APCqWjLzIzgmRxGj6t1+tuQpGJba74yCXGzv6OMMmbSqOfBueAniSlbg5SWpdpDunmC/xygYviQEIBkyc8GW2HpB7Vqjc4yZLjQqamT2zH3w2hSjt6u/Qql1ntxZNWPTFPvlJLqiEr5c2uwH8pBCyCq6rsmAF9k/+GPQpvWx/uk1fTkWnu2HpPWaICvBFKMq9Ayl+1C3txUx7Tv7eqyu4YNl/u6Ds+/HYlGpBiKPpQYGiI2ICXlbpwoPfrfG/fQZ6irOPP+5xkT9dRqspJ54n2sjWZ2M5apfW5Px6jw+OWJIL/JU+2PtYz58JN6vD6hv0G6T+ScAjXJpZEtz376s6jtfITBPN2knYUhKMcIVzBHR7cj/MqobKqJnvVIexLo9PgfKec4uvX8KyeZfmBytmAhZBH3dppQ+3+GH7yCkuaeXuz00xCggh5+vKaGQTYUcFVxU9XklP73ttap3Ma1V9lWFNBrDVrRiu5yEC2NvKRJ7j8Qd5IB6p6mKBd5gkX1r5uBPPxFgIxSZu/kGC0cVfVoL0CTJ2aqrOO7PcpdA+iOSsAS36gxAI4tYg7exBgO6VzQNn30CD9MaItTpBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3439.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(39860400002)(346002)(366004)(376002)(136003)(451199015)(6486002)(478600001)(6916009)(33716001)(107886003)(54906003)(6666004)(6506007)(316002)(4326008)(8676002)(66476007)(66946007)(66556008)(26005)(38100700002)(9686003)(86362001)(6512007)(8936002)(5660300002)(7416002)(186003)(83380400001)(41300700001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3DuYdI/+KOdCNk7DNgMxL4a33ZRhtfGkgdMX4aVPIFf0+M3f1TGjkjeYuBhv?=
 =?us-ascii?Q?JlKm8wrgeq7HoTOeL+im2G/pGLNn+H9i0/bP8ux/NwrE4K8IU69SL7AfXUV8?=
 =?us-ascii?Q?qJT0UGm3WOAo/d3oo9G2/PweVjUzOXpJIj9M6YiCU3CzXrIzUkGSrZn8JY3v?=
 =?us-ascii?Q?z4qvheJFunQl+SoMVzEmnaLBYgSAruppswHv2OJIG0pVf950oLpwoT28jjfu?=
 =?us-ascii?Q?U1s/XQ0GbrJIimMBek6mwCRNWJN/5ftinD/HOHVzXC79Fm7JKDS0xLweiilP?=
 =?us-ascii?Q?gcFYIOn+QVfc1nkLqa+dzFg2Iwsm0oEVJav2bI+mj8W7QRjyQm5MKDPu5+jx?=
 =?us-ascii?Q?rZohgaeuw3K2NUgAQEnqnVnMPOKj+4ZBsPJYrMye2IbNUCbRudIeoAn9j+Sz?=
 =?us-ascii?Q?ulrMtxFJdORuKr05kofamZbQD7TkNP3ax0R2e8dzbytwE1QyZ83DPq5BXUco?=
 =?us-ascii?Q?MPnjGZlLr1LfSt16vtUg+nidMTw1Y12tKblLUeGiCY/PKeMnGIeKr/qe5IPF?=
 =?us-ascii?Q?MiZlah8lfd2zIt/E0H9JVPunCI60EAy5lVuPgl0yRo23W3UwrxAUsGLLBWEp?=
 =?us-ascii?Q?Yt9PxygmyjuUpCS5XlvMQZ9McfsIQ0s4sF2POrURUagsL1JPixonBht6XfvX?=
 =?us-ascii?Q?OJwmwzzh18iFuJQN0Z50FVvwP/TEYDimg60PCbMwOq6OBgPTSG6eILagnrMi?=
 =?us-ascii?Q?x0TNF6UQaJsyXT/XsyNmrrTipqojNNgGCgbLghhsWO/XCJL5l0rZ9yJRaC/p?=
 =?us-ascii?Q?Q43tGhZX5VA6WVg2U7KcAb1gzEhNNTcphNm90FDgXy5PsjQL9AgjdZaRyWr1?=
 =?us-ascii?Q?hMW55Hm2tpMzz0Sl/4aL5u209PnYErvt0dJIgj1c/Zt25ZpgSop9rht2G1eF?=
 =?us-ascii?Q?HE9MDBSu06ugotiajSTzZsRjjP1+n0mCjl/8d5Zx8QXWx/y1srpopDbh13Xa?=
 =?us-ascii?Q?wQPSCauW7t3IL/S6RxJKfsUwmZAI52bmXbxOmFifng4EJSf23QoBneaEEoTu?=
 =?us-ascii?Q?FFIQkVQ6U23TfQt2yYSW4KAySATMxyZ0Ac3ScLinMSgebLSXv7B6V70oOn5t?=
 =?us-ascii?Q?Ko3fWoARZln4RN2m74SCfAQSg3lUJCA2KvtOsztjI8IPMmtMNLlJuXq8tK9B?=
 =?us-ascii?Q?gAM20vQRskhM7N2dzoSayHswj6T4YfSu8ruCzpZflmD1OMOuMfF3UO//7BDa?=
 =?us-ascii?Q?wswR8GZRAK2AlyAi5RwWyEkRbuQiEeNFewIgk/3IMz0RA6KaAHSCVYwcWUet?=
 =?us-ascii?Q?B3CUn9nRzYLoShA77ycV39+nEfdWf8WwSSMmr8HYPXT4AFj2s+ZNIlVH+h8O?=
 =?us-ascii?Q?HiA97exo0sYWzFbiqG1qDlm04eTQiQnADWz/fB1eoRqqL5nlwJFOFbofIgea?=
 =?us-ascii?Q?zPbVEAzwF0bqlcXWKJj8TrHpw+RI0Sydpf9mhyrjdl7vgXmFriM6D0cjIbAm?=
 =?us-ascii?Q?LoEGXvT+XevYJIJ7C6EMySdZpAad9tkXTTfihYvepn4mRHVV0skllRkbNKOY?=
 =?us-ascii?Q?rNGOS76vo3UCTU4da10OR1lWvTAeJFkFb89Keg5Tqein1Z/As3HTbwPN1pgZ?=
 =?us-ascii?Q?VzOwXWxkcCqb7QXVbR4=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26108198-e30e-407f-48b3-08dac229b3df
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3439.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 08:09:19.6048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bRyAJlfA4bgzJC37PO+ctqunKmphpaC8JyjEncIx3QGMVZgvpU1eNBSkjsOE2VaB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8323
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, Nov 04, 2022 at 02:30:11PM +0100, Andrew Lunn wrote:
> > Here I just focus on GMAC since there are other LAN interfaces that S32 family
> > uses [e.g. PFE]. According to the public GMACSUBSYS ref manual rev2[1] provided
> > on NXP website, theoretically GMAC can run SGMII in 1000Mbps and 2500Mbps so I
> > assume that supporting 1000BASE-X could be achievable. I'm not sure if any S32
> > board variant might have SFP ports but RJ-45 [1000BASE-T] should be the major
> > type used on S32G-EVB and S32G-RDB2.
> 
> SGMII at 2500Mbps does not exist. Lots of people get this wrong. It
> will be 2500Base-X.
> 

Thanks for your correction.

> Does the clock need to change in order to support 2500Base-X? If i

Since I'm not a hardware designer from NXP and I can't find any board that
S32G2 CPUs could integrate SFP, so I am not able to tell how the clock could
be configured while supporting 2500Base-X.

> understand you correctly, Linux does not control the clocks, and so
> cannot change the clocks? So that probably means you cannot actually

To be more precise, the SCMI clock protocol in ATF [ARM Trusted Firmware]
doesn't design any interface to get/set parents of a clock so that re-parenting
clocks via the SCMI clk driver [clk-scmi.c] in Linux Kernel is impossible
for this case. That means, if any board design allows run-time swap on different
phys, the dedicated clks which represent each phy-mode are required in order
to trigger clock re-parenting in ATF since different phy connections would
need different clock sources.

> support 2500Base-X? Once you have Linux actually controlling the
> hardware, you can then make use of an SFP or a copper PHY which
> supports 2.5G. The PHY will swap its host side between SGMII and
> 2500Base-X depending on what the line side negotiates, 1000Base-T or
> 2500Base-T. The MAC driver then needs to change its configuration to
> suite.
> 
> 	Andrew
