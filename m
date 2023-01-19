Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA386740B5
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjASSRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjASSRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:17:32 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2064.outbound.protection.outlook.com [40.107.20.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AFC90B34;
        Thu, 19 Jan 2023 10:17:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PeFhUrTfneRLQvpFdDiB4j8/X/Qz2f8guUhpBdP2tWgslVIsqslm3Ob38YOPquEbXetV/k/xYMteDgJVdBICqEI7QjlMXVxgincta+rCasBjd+GSWutCqV/aiFgXKA1F3XuZTBfe9soQAP7oGVJ5iv54xJa3jHkTB0NkXRdM1GYsLbjGBj7++8MZYTu9XdDLynmHMmKRe9Y/bcqx8hD/Ise2xMLp8ejNWfvRMCI/ENM/cZ1hgzuAZBJLiFjX5GJe57YCPiqi9uzx23rtygdeVg6LboUvnoNSv/LGu6tyqiYhrYTpy/jlFNiQD6Y8gV7/bhmweti11+i0MXFTU5SHBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aEVl2ufVawUydVYbUZ+sgwj2Rvs3WHM6JEC5034CSkk=;
 b=W82Hk4OEQCnleoHuU8hcX3kayVQ8Mnu5ELNV27oDupUXBajtwldMUrxhvU/v41EEF3pdoQBijranUfsIRM4m0/K0d7UyaCe8XdoSAgM9Q8TlrMazGhV+B81IQyXttoqASs/rstyh7USwzcmkdM6ZoO9xtItuCVJD80HNmLG6FvL5L8s9XXKqneXjITq/h+oFecqATqmm5+sZfsPHNlqaf/+TscvbTjqP5/IQEPQQ1QoTAAdYPh6GhzpK/TKLbNc122eJvDz14rF24OVtASsbRtc6+6CPKeyQYR9+0rejgCvvTjC8flAMHyRg1p/7Nqn9DcPL0Nl8ietDl2EZazDm5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aEVl2ufVawUydVYbUZ+sgwj2Rvs3WHM6JEC5034CSkk=;
 b=jKf4g3l890+xd2SSdhugHDlcGE7eXWLfvaZnAYS/jAWY8rD+b24lpXaYcrOHzswdLEgfN4PVpBa/RpCWIswhnKvuxFtnJLziErKst8zh99ez1eBhRdR9uWYdJA6QQ2T8MPXoepQoVcuZwB0hRh4pGLKz+czxoEKx5UIuNvBvf+nFLMVx78egZNpX2le5qw2D65qH0tfqoVPy4n/svKTqkTjZCW+Vs2ZQXnyfMKdMc6899Km00bA0txaJb24yhyal3F1s87rKMeWve6hdxBqVdITLklMkDqIcgfVltbt6CGPGHlxaNNebUmHFdzenGJRJHpahRZHV7iFV2SnpAO9IHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DU0PR03MB9077.eurprd03.prod.outlook.com (2603:10a6:10:464::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Thu, 19 Jan
 2023 18:17:24 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::6b03:ac16:24b5:9166]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::6b03:ac16:24b5:9166%2]) with mapi id 15.20.5986.023; Thu, 19 Jan 2023
 18:17:23 +0000
Message-ID: <7c990cea-16a7-14c6-3328-632c14df0388@seco.com>
Date:   Thu, 19 Jan 2023 13:17:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v5 0/4] phy: aquantia: Determine rate adaptation
 support from registers
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20230103220511.3378316-1-sean.anderson@seco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR02CA0006.namprd02.prod.outlook.com
 (2603:10b6:208:fc::19) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DU0PR03MB9077:EE_
X-MS-Office365-Filtering-Correlation-Id: a4ea509d-2637-49a2-e793-08dafa496985
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KHIhR5N5eiIY/l9Ik717RpbHL1a7RTn3sJzS2NQ+mNdWBwmYBF8y+nozgxIkcWrqlwsDyTq6cj8DHHz2WX8H/lmVRxSEyZrO3Dhy/hOeFRN3NZEcG1DK1PRXBOanB9PiuhmY/82p+hXQT1UekVniqcUvwbwvyv3x/uPCjHRayoe3S6w6cd0ZVpvvb+fEmty40pAvNyDGvLOmyt8tdo/kU0BULkOoJJqq71okeyVA3ZodcD+kQphNtkheV843eytoMuThiFOK6TBT9twrUh6ON2R/YQWeb/srY6gQi3uOAWlHgsEpVBBn09MSr8F/N+JhVHYrKHbCs1OQcGNDMvTVSQDblG2+mNnnvPB4dH/ClVC2IBYvZ6tviGj5Cm9j+tlm92g0TC/oSr9Cf1nE522CnBp6Xrp9V5yfnyH0y3CTLDpfJGkbIQjqLVCVuLS85TyVb0qxeWVmHtCFJ7KG2huVbF0iGVv0YBOhxKjJzTqPScHVpsViOE/XFnKrhQHUDzD49g05zkHDZvPSpZd2c63JaaSwFdEgx+g6O+XLqssumPpL+3tZS+dMhllqmtQtwH610F1K3naQUoXmtN4VT+7GkH3jaj4CZg68eNNbEZUJ8Vus4p4XMbktVrodgmg5yimyJqyu96rInepjO+e8DXB1SYxji8stoXfW7Z5zXNnkDnTSqeulSM+8GtYSdjl0DfO7mM95NADPEC/RDueyxrTsCvGWn2mXHBr7tauvW/y2uNAIhJiT77jx+vB+uD1Y22Y5qjXeFjDDQ757VCbKP4auVkRxqI0ukJlGmbrthe0H+XY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(376002)(396003)(39850400004)(136003)(451199015)(86362001)(31696002)(6506007)(53546011)(966005)(52116002)(6486002)(36756003)(478600001)(8936002)(5660300002)(316002)(38100700002)(66946007)(66476007)(4326008)(66556008)(7416002)(38350700002)(8676002)(26005)(41300700001)(6512007)(186003)(2906002)(83380400001)(110136005)(44832011)(54906003)(2616005)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEd5THZ2MEphVFcyVjZhbU1vMit0bE4wYWZLQkZqaGplWGdwWS82VE1wM1hY?=
 =?utf-8?B?WWU3ZjhWdXVJejVBdEN0NHhwMURIdkdMNzk5S3VReVdodHZKYWJrOGE0a1Fk?=
 =?utf-8?B?aXRiWW9DaVovdXEyL1ZidmsrWmlNSjZYNmJCdFNCbFBKbjNlSStJV0tQT241?=
 =?utf-8?B?akdKc25GL2xMQ0lKa1NRZnVOTnRVcEt1MFJsMXFVc2k0ajhQWkd1L0QrQUhN?=
 =?utf-8?B?Z1JiU2ZBQzlWVGE2NkpvR2FNc3F2MkdySTh3aWpYd2hNMUdmN2hyTFIrazV2?=
 =?utf-8?B?MFQ5Lzl4SFdEalk2TXN1K2RCZkpVNlFEMERzZE8zRDlTQXdKMXBNMFNRN3FQ?=
 =?utf-8?B?NGt1djdYZnhkOGJnTlJuTnNOQmxTbEo0cmZ4L1JFU1hiODlOY2xsK2F6QXE4?=
 =?utf-8?B?R2taeS9wdzFvNGZNb2djV01mSUZmU2pGQklqcFFnY3lkU0hZT09jMXBaTWJV?=
 =?utf-8?B?NW1LOHFYdXBWODNGakQ5d1pCTjdRdlQxM0lsRHkvTUtrMmxjOGUvVTZ2VW53?=
 =?utf-8?B?MzFWb2RMQndjYVNURzBVeDBlenlQK2d6TDlhd0YvMGJsQVlHMUJDZ1BnMHBD?=
 =?utf-8?B?b0Q2M2R5ZTluU0JYeFNVZDlUZXVpZk8vSnRQaUVBV2E0dmRaTjIyb2FTU2V0?=
 =?utf-8?B?UjdMZFhYNzRselJtbmNEYW9FcFBPWGZOQXhwSk9yVGdUY2Nnc0NCWVlyN3ZG?=
 =?utf-8?B?V2hGaHd5eDZ3U1JRREJ1MlVPS0NiWEZWdkVhN3RLWDZyTFgzZDVUL3o3YTBJ?=
 =?utf-8?B?YzJYTEptcmk2NERoUVVtUi9XL1pOY0htR3cwVG5wT3RBT3pvL09mY05Od1NK?=
 =?utf-8?B?R2JnbHdXWVVPZjQ5SlBBcFVKcEJsQnJBeFhYeldDUks2NnNkdlBJZnkvb3Rw?=
 =?utf-8?B?MlRZRFk1TlpRZ2MvVTJCa3NGMUkyWm9nVHZselh0RzlOcnl3a3ZzMHpqVFpP?=
 =?utf-8?B?MndZWG0vQXhhcEF0SFYxU0EzT1BuUWtqL0FzcGF5K1dSWnhPRjlqWlViTlBZ?=
 =?utf-8?B?K3FReS9CMlZtSFdrN0U3Y3c0cDRPa3paZ0RqVW1ub2VFMnZaTTdGTktDbVp3?=
 =?utf-8?B?S2NJdWRFQ2E4WlJJQ05CZnFwVThEemFBbFBNM2k5MDlZdnB2M1RmeHpWUC9j?=
 =?utf-8?B?bzhyRTV4L3hVaXlFK0hkaDRycnRFa2dTZHFSVVg1R2dqS0NBMkhTTXBOcG5a?=
 =?utf-8?B?UGxjZTBNMGdGcGhzUFU0NEFxMTlCb1psUXo3WWRSRHZXMDR2b1U1TlFNaVFx?=
 =?utf-8?B?UVl1SUx4QnFuc0Q3N014R3pyZU12RWJobURod2E4MVdpRjBGM2hQcVU5N2xp?=
 =?utf-8?B?ZGpnc2Z2RUZidTJ5QU9tNThLdWcxQXdTcFIyaVBXb01rUlVxOWp3OGFEbi9B?=
 =?utf-8?B?M2NrREpUUUlydG5aTDBVOXlPcDN6SDBQTFFQc1lkRXd0ckFWNVRva3NTcEtC?=
 =?utf-8?B?NkFQbVVwWFdmcjFMZms2eDZuZkxiOTArYWhBKzlsY0tXcFJkZWYxcWYxMjJB?=
 =?utf-8?B?VWNGWmc3QnRYclo0VWIzeXBFM25iSlRvTFdzajd6Z2ZtQnNZZTI1ZDdRWVJ5?=
 =?utf-8?B?a3IxUFZscm9HQzJOblpjVFpDZVIveDNRM1BmcHBERmNiZUEwQ1dGQU9Weks4?=
 =?utf-8?B?WkxmZFhrZkY1NFJacWd0c0d6VmcrRUF4ZFFpNUppTHMwK3Uva3JVWEN6bEl0?=
 =?utf-8?B?R1FyVndWaEtRNWVKaUpLcTNOUTFwSGczb1pkMkZkbG5nZnVRSVM4SHhMUFZV?=
 =?utf-8?B?SlVWTHc5M0lTUVFURFprY0pXUzRzVFNnMUtIKzVIdTNkeE9JWG9RSDA0aUJ3?=
 =?utf-8?B?RHpSUE1xc1gwQVh1ekNITHhvUFJPMXZUcnhtODhTZGNMWDFBdC9OT0VTZ0xH?=
 =?utf-8?B?U0JXU3BKcDg5NDJHdElqVWxrZHRBMG00YVBGMUpYSzRhanNhRjFuZHJCT3Bh?=
 =?utf-8?B?SzUySG9pTVd3U3JVRjZ2a2RWK1l6anF6NWY3WWNUVWJ6Skt4UWY5dW9jNzZp?=
 =?utf-8?B?M0c5NEZpa2VBZG9lcHlxY0o5T3VodDZLWnRGcHBvbmZuWmI5ZjBYMEEzVEV2?=
 =?utf-8?B?ODZMek1OazU0aXVLM3hUSWM3b1FyVnRsaDd2L2t0NG5xQ1crKytOT1RmVDRH?=
 =?utf-8?B?cDBVK0ZOeWtxSXBkalNDck1acHRydWllNGNhOHJyZTB2QW1XVGhSZE9LSUY4?=
 =?utf-8?B?aUE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ea509d-2637-49a2-e793-08dafa496985
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 18:17:23.8161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z9LkqcQPJ0vHGTVlcoBal1HGIFYp7RZ4rEy1YHKpz9EkiIIf2SPLDBz/u26pR/V1w0DyuvUUfm0Y6XQTsxHBsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB9077
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/3/23 17:05, Sean Anderson wrote:
> This attempts to address the problems first reported in [1]. Tim has an
> Aquantia phy where the firmware is set up to use "5G XFI" (underclocked
> 10GBASE-R) when rate adapting lower speeds. This results in us
> advertising that we support lower speeds and then failing to bring the
> link up. To avoid this, determine whether to enable rate adaptation
> based on what's programmed by the firmware. This is "the worst choice"
> [2], but we can't really do better until we have more insight into
> what the firmware is doing. At the very least, we can prevent bad
> firmware from causing us to advertise the wrong modes.
> 
> Past submissions may be found at [3, 4].
> 
> [1] https://lore.kernel.org/netdev/CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com/
> [2] https://lore.kernel.org/netdev/20221118171643.vu6uxbnmog4sna65@skbuf/
> [3] https://lore.kernel.org/netdev/20221114210740.3332937-1-sean.anderson@seco.com/
> [4] https://lore.kernel.org/netdev/20221128195409.100873-1-sean.anderson@seco.com/
> 
> Changes in v5:
> - Add missing PMA/PMD speed bits
> - Don't handle PHY_INTERFACE_MODE_NA, and simplify logic
> 
> Changes in v4:
> - Reorganize MDIO defines
> - Fix kerneldoc using - instead of : for parameters
> 
> Changes in v3:
> - Update speed register bits
> - Fix incorrect bits for PMA/PMD speed
> 
> Changes in v2:
> - Move/rename phylink_interface_max_speed
> - Rework to just validate things instead of modifying registers
> 
> Sean Anderson (4):
>   net: phy: Move/rename phylink_interface_max_speed
>   phy: mdio: Reorganize defines
>   net: mdio: Update speed register bits
>   phy: aquantia: Determine rate adaptation support from registers
> 
>  drivers/net/phy/aquantia_main.c | 136 ++++++++++++++++++++++++++++++--
>  drivers/net/phy/phy-core.c      |  70 ++++++++++++++++
>  drivers/net/phy/phylink.c       |  75 +-----------------
>  include/linux/phy.h             |   1 +
>  include/uapi/linux/mdio.h       | 118 ++++++++++++++++++---------
>  5 files changed, 282 insertions(+), 118 deletions(-)
> 

Although there was a lot of discussion about the final patch, I think the
first 3 are good changes. Can we apply them as-is? Should I resubmit?

--Sean
