Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93A96F2584
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 19:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjD2Rm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 13:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjD2Rm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 13:42:27 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2047.outbound.protection.outlook.com [40.107.22.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8341BCF
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 10:42:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fBel3BlvmHkzw5Yg8xBU+WcP2QwFjQtw+QwAIwbuQO5WVc5VwswSo/4E6tlLVmBLHQmyZW7nd6egYFhs6k3LwcQXFUP6aVSpdecp1Ixi+934IWWXMtkUgqthdLgIfKmOJf3Fc8y2VkcrJkGLCK3ev45pOkT+PFAX1RI2c4FU3TlPI2q9R42JBK56mAGuQbe3pfQAaMBkmRYlNjZNejrw/ZWTsaWtMuwqGnbXk47gIVjCbVRNc88qetT9a03Afcs9j3M6ne6JcjmMVDMWTjYc5ObBHqa/C+6EcH+1/eYcNUX9DRTHZnMQiIwCjMFFGLvGPifXioO+hmfMYJlr8ug9aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2GI9Lfk4y4Ie5r7SUZo5+/Oibs6jRFf/t+71cJ6Bks4=;
 b=Hb2o3hwk6COB75fpsxWxh6CmSEAjQ+CkLlR1m8nn5o0YZRucIxG0dHLB2lBHIk6XIMA+Y2efMJ/0aynDBJzZqNauuogLZbu9CRHtBaEU7Hp+fYYsidKY+Bcp6OKU2pLLzCmMdYBsIy8r8fcaMwcctAUELPWvRDP8iYe2wSV/d9oC5SUF5yDZ1RlSXrAEDFx1P6EpxFyVXONscEQ8Hmvrs1Pu74QLv66cdalOqv4F4UvElwKb1aJcwBzgcmTRJLqyUN4eeKm22Qlmx6nIqvVeVqCj+ojLtRNJhry9R02YzPSuTf+57cX/23XOSEzgpMrBaWrF1kLkUzWPB4NAs/NKZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2GI9Lfk4y4Ie5r7SUZo5+/Oibs6jRFf/t+71cJ6Bks4=;
 b=dhGmand4ukewK/WsdvBcW+tYtUI7hdFtb3EmZbF8HM3HQIpz0P4g0zIdgNQZC1qQPTzWlJppFsFkMTbMJg6wo0K2SNebR+Qdw4Y9glU1i2+u0co7PaRLMgWeOp5crhrtpSVkEjQ365Bngy0uddXGj9pM9P8NgctOhgYkCliG+BE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8192.eurprd04.prod.outlook.com (2603:10a6:102:1cd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.26; Sat, 29 Apr
 2023 17:42:21 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6340.025; Sat, 29 Apr 2023
 17:42:21 +0000
Date:   Sat, 29 Apr 2023 20:42:17 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com,
        thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 3/5] dt-bindings: net: phy: add timestamp
 preferred choice property
Message-ID: <20230429174217.rawjgcxuyqs4agcf@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-4-kory.maincent@bootlin.com>
 <20230412131421.3xeeahzp6dj46jit@skbuf>
 <20230412154446.23bf09cf@kmaincent-XPS-13-7390>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230412154446.23bf09cf@kmaincent-XPS-13-7390>
X-ClientProxiedBy: VI1PR06CA0173.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::30) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8192:EE_
X-MS-Office365-Filtering-Correlation-Id: 09fe1256-afce-4644-5904-08db48d91561
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yFD78/20ukmP9yYPk0n8BY00CeA3vRrns4Hpnx+19DAix9N3n+Pnceh/JlyB0agPEQSj1SQKjiR8mv3yOHE3SOVQr2yLwu1NRXmklNA0oXh41AbiIxI2/dTlH/0lJXXf/CiKHR7+/kO847EMfTLxouIfoslbz6S0dNpcoTTYIHfhtksX6VHJujKzWmMxqKRiQJV/TGOBaCM/P8WwigSCBJNaP7I8fzv05xSUf9dc/FUkKIV6QNAQ0StiANSH6o00r0LzLx20hM0MTETSdRA7hLcexcyLIUBIaLxFPrq5KX6JmopEIhdTih4TIDI0fJiNJgYenx0Boi+xFmcs6+ij0CuzEdFnlYVmMkeLtQWgtZV2qV9dyNo3jdT1A/v6PgnRne/T5jV06LpUGrhUs1xDspe/wwsjIt49nl5KeGbw1TRNugHb4fwdgB+GMSXfo/3UDTAtVGE5wNtlU5zc9o+v/VSmu1ZyP7BJlLYjxH7k0QklpeT8jxsJTxjRj78OinphatpNNYfLIpVKZiUX0uHyVoV1kkeU8lpCdG0r+189rQls2TyI8QubQM4XYrWeL5xX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(136003)(346002)(396003)(376002)(39860400002)(451199021)(478600001)(186003)(4326008)(6916009)(66946007)(66556008)(66476007)(6486002)(6666004)(26005)(1076003)(6506007)(6512007)(9686003)(316002)(44832011)(7416002)(5660300002)(8936002)(8676002)(41300700001)(2906002)(4744005)(38100700002)(33716001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?JBLrdOQIk1poRRsgRuA2yEEGYVh4lHmA1OTay/K3kPsK284vzI6vtQ8Mg1?=
 =?iso-8859-1?Q?IqsORpdRVrtcUNHWJavGXgEygtUIO7yBCTa8t98TveT9eZcnVpb6isMucq?=
 =?iso-8859-1?Q?Gn3ixKfbpC9civOOkKUohN+GSJ8FNF7vZyd4dt/YlLtPga+Fikcnk/swlH?=
 =?iso-8859-1?Q?iHt+56WXuQYQg081ipOhQe1kGyaNbLLI9yDoJ+/I/yOKvBK57xax6tWhPx?=
 =?iso-8859-1?Q?FVH/zy3gBj8DS9B0cOPFm293J3bbR/2e2AEmN4VHt84jJuVurIZpX2o7Bf?=
 =?iso-8859-1?Q?XwCw6TYK3vl1rO4nLz+zbn+JVFeVwfVHX0VPxygwTJFG7dToC2RZaF8mxh?=
 =?iso-8859-1?Q?ZKTNoaRtu1N7EA1XuUzuHiGpicQ29jgIGVP+qmA3kK9eTm9TpgwR4+T6SM?=
 =?iso-8859-1?Q?BlBXFtrRQyu732d60xKWE1zHHV9HlTR0uxsKSgMUJ5uMfu+SE6Ayzo9oCD?=
 =?iso-8859-1?Q?nALgNlPQJfSeoFzOdhSYrZlTxkxMnPoovXsT764E3YDzRG/O+DDt5jAnZg?=
 =?iso-8859-1?Q?lwN2k3Wn3bz4ASviXAPOBRDQ35be6r9ofOERcwXBSpAWpcbipMnuSXtNDF?=
 =?iso-8859-1?Q?d6IOiMkgc8hIB09l6w5Mb7BxxTzFp9tzxCUuFm0lg9qKkS12IpSkQE57I/?=
 =?iso-8859-1?Q?g9ysaRVwovwB7eT0aCvNcQRZk/jlfWtXj8jzloIFywU9FzUYHrEECeRvQV?=
 =?iso-8859-1?Q?bexV2lKg1xQKo1IgmWujUKPRi+RLoy8dVcHODNgI/KC3Tqy19qRFp/GVLy?=
 =?iso-8859-1?Q?yTtR7a6zuelfBF+ucz1I20IZy1/kianPWgyBiEiizRbcZbUOsy5WKYp2Rz?=
 =?iso-8859-1?Q?NwAyydVrQH0r+hX9RqVEPrXvDzZ6hMSFgliPRVsHA5Qb10AxE0fzkcWjwU?=
 =?iso-8859-1?Q?iWGxD41rjyUdiXgeoTOTGK26mVua+JBrwiEk8OP5j3aLAr2xTs4KjUxtGl?=
 =?iso-8859-1?Q?pIT/tQbCvtlCgY1O6XiVD9/jrfp/Gj9D60gaAkoDRhB3dFYcyMTMK2pg7z?=
 =?iso-8859-1?Q?2Y28ONJF2c0tjlN84Dlbc0zHvjt/cA4Q5RHi08920wRI7BFJBkklsLIrao?=
 =?iso-8859-1?Q?ZpKxtNj7KOSsV9zX3T9Nw3ycDMujKunDpnGm1ub8HUUxQUppj48yIq+8EJ?=
 =?iso-8859-1?Q?zl8N/5GTsaBp00Y1ahZxgXogtPPsJGAVeLTKBCM3YbeLG/i/dVBcvNi/TW?=
 =?iso-8859-1?Q?/R1Mmm/0JnA8lIZs6WED5F8YBl7xgzuymqF9CMcW496IsVLZ+edJ/xvAo8?=
 =?iso-8859-1?Q?CerFkfBi0dP+gDSVH445YQRO+4QFazEjHQmYaIM3yiPPlZUgsPC+y0bRFf?=
 =?iso-8859-1?Q?Xe9U2wMmw6PU/WyfhVIHfDY7zHsfcVe7wJmXX3CP9WXswcZcyl0KAixMMg?=
 =?iso-8859-1?Q?zuGH3su5BamE8MTb9JIeznUdmtQMs1eb69MCrdKJQMBpamL9gIGq5ptNxU?=
 =?iso-8859-1?Q?qPFVX2ZhBVvWstRHcorGnwihrcd1841Ca0LR9tzpchQPPJmQAyQ2EE926Y?=
 =?iso-8859-1?Q?52mbZrPi3BKYq4DTcF7bXovEuhnffeV2HEcp89CB4eztMTGZpyFH2WzdvZ?=
 =?iso-8859-1?Q?FXHPOzQO0v5Y+0j4eglVg2LYN4U5yNG8RbaBtmNveoVHGad+/jIksKK41E?=
 =?iso-8859-1?Q?ocwBQKvxLjhnZQ6t71tT3aaxCz4DFz8yaD+PHZY7XD17smS1RzP9jm4g?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09fe1256-afce-4644-5904-08db48d91561
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2023 17:42:20.8716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D1Hod94e2utChsz2EG8E1mV8ZfAn9TrL9CDVxi5gOKB5iOO+GHcJLSI3i7dnZTgM8/SI+wYhhTwq7k/PfOxWZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8192
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 03:44:46PM +0200, Köry Maincent wrote:
> On Wed, 12 Apr 2023 16:14:21 +0300 Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> > Do we need this device tree functionality?
> 
> I would say so. Expected as I wrote the patch. ;)
> 
> My point was that the new behavior to MAC as default timestamping does not fit
> all the case, especially when a board is designed with PHY like the TI PHYTER
> which is a far better timestamping choice (according to Richard). The user
> doesn't need to know this, he wants to have the better time stamp selected by
> default without any investigation. That's why having devicetree property for
> that could be useful.

The TI PHYTER is the "NatSemi DP83640" entry in the whitelist for PHYs
that still use their timestamping by default. Can you please come up
with an example which is actually useful?
