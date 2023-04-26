Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215896EF702
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 17:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241098AbjDZPBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 11:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240905AbjDZPBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 11:01:10 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2096.outbound.protection.outlook.com [40.107.92.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D3319BF;
        Wed, 26 Apr 2023 08:01:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDnzmEpWSSk2qHqZPKaDI29AavAzApjw5qbbnkFRl3WVH/G84Vy2hElPASzFwaPSulYP0NpV9q+LK9BnuvFnfoe9r/bwVckTeZeuq3QhXaH7LZ4t5lTxvZPr2YTA5ui7D7Gezy/5Vmil08zBMX2eB9KxJaWYarfAuuP7UjR7sTcYaZX5D29TlAW15s+q3H8HTTPkfIvfYIkfXKhcEtnZq5qd0XYBdwaEWLznUo3v8Vx6siZxyjGMfUzKeJ5YXRxad8wh8eZdbJKVgPRSl5wjoU+5dai+FrEcPJmW6CKGPCR4Hk7V+6YPdGa3sOIEdMWHUEDSncaWU4LxgkOwT0JO5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZ0IAAgHv+vPO1aVMNqUvoysAnTPAbJVHrBQtH567Io=;
 b=QD4qfyaSI9gtuvu4UKgmstzWk71deQY8j/f27Z1evupi3yqqsMN1rxsVI1fPbTG/1m2yOSxbeUQcMGpEJM3ovRg0oWBxb0/gTxUgZr+BlJo7oQzNdEkImk1PAI4B67g/K6rjQMpVruoICsHh9cjoAjLHFr56rZqpAN+soBp/JkcK4uoMgZx1Xz6Z2TvpWLAsE53oOr+J05byFLLsDb1I8dNpv4ZtEOHIJb7PB087809csLCNJ29N33WTCLlGT7D6bc9DepadvSjsA5nTmpNHS6snfOZJY969+5F8qH9Td0XLZhq3oiSp3k+UZGgWeYflg97SvMoh1NxEMmmFRjCx2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZ0IAAgHv+vPO1aVMNqUvoysAnTPAbJVHrBQtH567Io=;
 b=k53aog4k4k/v6ELG49pNeh8T95v3/qZG/K6BP5Ml7r19wyEWGTF/atlxpPzw4nSuCulk6URc5d+eGAmntyS9xpPFR/rRCkqEGjIrikUuJDbumRZiiZQ7LLAscUNvvX3wDktMWsEB3MmoNXK9QD/Ca5yEBnVNhiiCyuC9g9+RR/E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5493.namprd13.prod.outlook.com (2603:10b6:510:142::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 26 Apr
 2023 15:01:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6319.033; Wed, 26 Apr 2023
 15:01:05 +0000
Date:   Wed, 26 Apr 2023 17:00:57 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Harini Katakam <harini.katakam@amd.com>
Cc:     robh+dt@kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, vladimir.oltean@nxp.com,
        wsa+renesas@sang-engineering.com,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        harinikatakamlinux@gmail.com, michal.simek@amd.com,
        radhey.shyam.pandey@amd.com
Subject: Re: [PATCH net-next v2 3/3] phy: mscc: Add support for VSC8531_02
 with RGMII tuning
Message-ID: <ZEk8qU6QYI3xDGzd@corigine.com>
References: <20230426104313.28950-1-harini.katakam@amd.com>
 <20230426104313.28950-4-harini.katakam@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426104313.28950-4-harini.katakam@amd.com>
X-ClientProxiedBy: AM3PR05CA0131.eurprd05.prod.outlook.com
 (2603:10a6:207:2::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5493:EE_
X-MS-Office365-Filtering-Correlation-Id: 096d83bd-0569-4892-51d2-08db46670ed8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZNcwnoLu3eFeP7yUqY8/PixnkMTXw6tObwoZCjsauyA637ZKFBt6EhJakIENTqx+jS/vBXs0kkLDEDVkJGY8vZ7jW7xjcwg1g9yiyzV/iR5MrMQv4TAhjDHXRmq1Mu7h8LU0OFRn0MbLQEpArIxoH3WWtPvGqS+3euHCutRrjoPxM8zQLoqaJoUbizBTpo7PnFHRQjBzLx0mzzLWDGBZD8px77sWAoyN/WFxjYGb3EFbff9kYrUKeqjnDon3xTYL5w+wrQTLhAuVeVxjBEy8cctvCZb8sfx62EyGA38xprstpIy4NjsqFtDlxuEcO88X8fC0OGo+idKEXtTYrVEGAXWB6axi/aj7pPR2cMCwAmBZxPP7sW8Goo1+LqryERNj3oxdg4WVsL6KKpsG7PARdz51l+9LM/a037Gkoh58X7GG2vy+JnfvQH9kbgVAE2ACuDmXsRm3Z89/V71A42PKzMOfQbLxQit3y7mPLtoIAiUeQYlVGdwcR2EpisjYyNFhfZYiuUCtNWZrd3LqfVdrgdz+UyHf8/auYh9JAjmswDC0JwWfeTrQEE2+dT3PDk7u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(376002)(346002)(366004)(136003)(451199021)(44832011)(6512007)(4744005)(186003)(6506007)(316002)(36756003)(66556008)(66946007)(6666004)(6916009)(66476007)(478600001)(41300700001)(8676002)(4326008)(8936002)(5660300002)(7416002)(6486002)(38100700002)(2906002)(2616005)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?umB47U20eEpUfGhMWq79ldEgRRx3ruQsiblryBt4K0iqkTuW1uS90bLiXGgw?=
 =?us-ascii?Q?o7XRryeso7zyDNtyh5JF461L9Eah22rVqDp6QNg21Jrpkshr4NKskFXk1ykg?=
 =?us-ascii?Q?y4v6kfrb0QBQw5DD7uX75fR/hwt+nOdzONSt5eRQheeQKDaTrr0+Ak2YcyAl?=
 =?us-ascii?Q?FkbnEFdQb1JW3cOvuMjzQuB50SARgXfLMtz1MeS/G/38/zpTXI3tZePdDbMy?=
 =?us-ascii?Q?wS1K8hnRuTqlasNFVcILg+7Vv87qjkvDo5hz8TnMd4M7DL5O9CUILtNb35kA?=
 =?us-ascii?Q?wpYRrwy1XuYLRMRLK4YsLTr+FAXB+c6yxcBdKBl7eW12aO89MjmsexNUq1KM?=
 =?us-ascii?Q?Q3rTiPnp5r6bsLPfRefnJ32z/lqihGDYEeO8zaGjangtWpCVlry23xEPtRWU?=
 =?us-ascii?Q?NdFPMHGSiFPXqaBQSePKiKuWQxp1KtEsDH8l7fN2mI4B0hBRVecPIBT1zYgk?=
 =?us-ascii?Q?uZg8wEr1yFCtx0uDxaSdYGGdZ9bteMUHXndmQkr1OtUtiSf4tcoXAyOW/59c?=
 =?us-ascii?Q?ZBwKvES1b0J9ZYhzRQzVhmwVNeoaQxPlr7Ep/MDBDskwmqHjmIJnpRjlyknt?=
 =?us-ascii?Q?pe/d3amsN03t07LcQjnfLgG8uk5vybsNh28lbzLkq+nSFzdhxsKhR88kA3Y8?=
 =?us-ascii?Q?89CplJEoLmMGFzOwOqhxz1C7KjlMv3TuuBWtMe2mqS+6n7lpV1gTxkR2YtBm?=
 =?us-ascii?Q?kAPUU0U+lOjDABEGt2cvwvY26ri3AFEIo9opQkEGJ66cdhs8DxM8F7Kfz6pc?=
 =?us-ascii?Q?WP6vGT5nAT5C1Ks8gpd6QZpVvNPbrRLSsWW3TwouzHCyfXPWylcZvJp4SGJL?=
 =?us-ascii?Q?V562woZH8mxgiULmzn2mOmr2tCGUffpdvf9v5ipDKGFB9oZI1zxCRNU7DtC5?=
 =?us-ascii?Q?NcdZNS8nktUnULUcSVrCbo3Rg//mi6B5Dffodo4V65HaFvGKV+D1xTq+Y1q2?=
 =?us-ascii?Q?ar0+mvWz5UGnAxIyGCd4dUqEP925T7YBNF9/e4hUhCyEq9GckH0Yxpn8/WHH?=
 =?us-ascii?Q?AELE0KsVnBy9S5IBGKd0ZUx8Q7z9avIzAOi6l8PuZfb+2hDJI224nscTQ40y?=
 =?us-ascii?Q?uktoKDPnQMEnLSfCz5lDrRNXdofC+1N7Glvwn9p9KQBvuzN9Z0FhgzIS9cMI?=
 =?us-ascii?Q?RZYk/10zYdOCrfospUrV2siBmZetWUkSsSXKujjDmU7YRIzAYkI0O9imatCU?=
 =?us-ascii?Q?xnQnRQBOclsMCoTLYpQ5K+uIBzFzJKKCKd1IJHqztBgtvRhQ+qd/Xb63zcYx?=
 =?us-ascii?Q?jwRw0yEVgAOb8XEXW2hBj4eGV5LoNy+t9s5BskiKuABMc3CvVBqYo1jX/3Jl?=
 =?us-ascii?Q?uijHdfOQvTGUM8vqOaKndIKMxMePtUAFdrtE0x6mC9YctZdolJo+lQUmA6Ym?=
 =?us-ascii?Q?F4i57w4zQ/3BXqK22VQYQfdsWBXjJbusGy/3xYM8slmAfnGoHv3+CmlOCSYp?=
 =?us-ascii?Q?w5Nq8TUcZjKKmnfRfkGk7BnYZInerwUjm06jQudHldKGREEWe9d5rpzmSpfQ?=
 =?us-ascii?Q?SYnchyP1JmVHi2HaOk1RmGgi94U0Og3DQtg+gIfJTMtZ7hoplCxv7cfARCH4?=
 =?us-ascii?Q?kfFO1gQAmJaPAJ7SK3xJivavMtpy5iRzZ97ezUAB1vGvNSVykMgTTE2xOxfE?=
 =?us-ascii?Q?h2tAYaHGNSDJpRAlbFn0RCl7m+4SSTLTWrCHM3x5QK6C9LtFOVBadI5Ji+AV?=
 =?us-ascii?Q?I7I7rA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 096d83bd-0569-4892-51d2-08db46670ed8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 15:01:04.9845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rNX2qwGg0G6twJjXcUPJt14P+1ln6FSDBupO/1R52edHg3Lz/3Pb/dig9CIDSN3lGYDEhPSu4bgdBZ1+V/OWqP6rrnsWc5sqddwCncJxgUo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5493
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 04:13:13PM +0530, Harini Katakam wrote:
> From: Harini Katakam <harini.katakam@xilinx.com>
> 
> Add support for VSC8531_02 (Rev 2) device.
> Add support for optional RGMII RX and TX delay tuning via devicetree.
> The hierarchy is:
> - Retain the defaul 0.2ns delay when RGMII tuning is not set.

nit: s/defaul/default/

...
