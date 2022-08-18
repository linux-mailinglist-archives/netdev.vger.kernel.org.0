Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9496D598760
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344248AbiHRPV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241485AbiHRPVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:21:23 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2078.outbound.protection.outlook.com [40.107.20.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491FE7268D;
        Thu, 18 Aug 2022 08:21:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXWf3ceyfvmouUa3XawFukJy7bpkFgVK3wAVtYYYVFk2PcgZ37YCbTg39ydFuQlfuPQmMdxUNmbGwPLEIFRzW6P0RfBzYtr85tRaTfYsyZFqQ5VQWch/J6AF8tQqdjISF/Rftc9JPPvpmLT844Tn3OIP/PQSXiXQzWhqKXDgLH3O8g0fSBAacMRd735ad/NWT0iLwGi9EEvK8uYKNMkCqxa0/ivaxbs2fmiufXLOhNDack7mOP6Km4noTKlZuSjc+Sr5CSr8z2N7DLZF49LmRN2rn3wMAONRSvbpNEwVjuvF0XA2h0MQWIU0mtlH+pl7F9sbDt8R/GvZB89TKQ8/vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jytnf0FOsZMz6rb+lR1xq2SeS1KuH/duhqpdzBlCdNw=;
 b=F3zWZ0bCVvOHMUGjZ3fNT4LBAxPH+VqNZJ/RT4vI+771/Fzp5sHpjv+3K/7S3IdvCS7YJPBwfpOyOl9pRfD/D1pGbbEo4/rHTCLVvf5DfYPxU3uqoLHnW5cPiEDgx5ZgtCjyABrzxL0UcGiHL74SBl5ua8akj0gen5jwW8y+At+M+tDCwV3PmE5I+A626hgFbV1D/Funx2b7NUUS/PTbrqolMRrHQstkZY4bVBg/8PDjOm1AVX8dwO7VjVfp8iyq81LG/lCR/d9RZPO4UN9g9DaEMJ5KHkVRkECUd3uYg7KUrAmONU6RJhQdCMNq3yJc4j/rkBcn0U3Tf+CFF1o1Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jytnf0FOsZMz6rb+lR1xq2SeS1KuH/duhqpdzBlCdNw=;
 b=BMKIrZWz0w90xmFKamNSLzlyZLtJ5kNVEzgHgHbTSCxWnLC9kYtmm0JouUjquVbtYyPtdXVW/5r9bwi4au1qHmoWFzbltjleu9jugdQwvpI/WhM/DdHFvOsuMHgf0njkj5zaqo4p0qsS8MPvc0EhbuDvTROQ/94UYBMogxscuYpCQFW5IWkDq2DqQ4gSsuPrdbokSCwNbXuHrqFWLplVwTHbMQXma11eIHHb5p2ejKpjnxN/DzTP5fNx06U/lca4eALdh2ASbHoIDIHFY0TQFaclMxzSPwANp/8FMb4N1HxySC/iDjVmRsrplTQZd1bjGWiKvIG+yDgeW06cMgRD6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by PAXPR03MB7965.eurprd03.prod.outlook.com (2603:10a6:102:218::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 15:21:18 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::fd39:2209:b2dd:5f0a]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::fd39:2209:b2dd:5f0a%6]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 15:21:18 +0000
Subject: Re: [PATCH v3 00/11] net: phy: Add support for rate adaptation
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Bhadram Varka <vbhadram@nvidia.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-doc@vger.kernel.org
References: <20220725153730.2604096-1-sean.anderson@seco.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <f6707ee4-b735-52ad-4f02-be2f58eb3f9b@seco.com>
Date:   Thu, 18 Aug 2022 11:21:10 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220725153730.2604096-1-sean.anderson@seco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR08CA0020.namprd08.prod.outlook.com
 (2603:10b6:610:33::25) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f35228d-6988-44a5-cd3d-08da812d4c82
X-MS-TrafficTypeDiagnostic: PAXPR03MB7965:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CE5VdzQXoYn1yoZNmkDCQZ2zR7UYxvpEOAYEzQkROhIl89IP/WSKCkn3sqUYIsoGwWAcSiH/iNJVEZOwEA9mxIFR3DuHgZrd1MzNBG8DsdgLR/JZD2s/ltBYwya9ovMuRFjV2KIIEJD5TaP3B1X9uufecdfq2oK2Sr+ePaP/1MEJ+PJDWj7wOcpwtP4tYVtHkm13PvYrJcADHUjQLqkfR7wOnk+7aoENoPTjPOZZ2iiRTYU1nOBFNw0aHntEgnoRm8SfdSpxQNg2L67YZMzHE8mNcWe8RFZebmvaTiFZj6YLYB7xKpFXkMeKYWumh1LG30ZCc0Ph0q2WPrP6qWITjiDYS/NiJ/b8ah97l3uNFo9GZtH2LQ5PEWA4nSnIRyap3RnEXwoLmT1H9P8Q2ikeEaJAMtAL8ZbkmNOOJFw2lyObMLkPxRYld03xdzRPhI2D//aGEtSKrUhOBc3lKW/zxpBoPuul1wqw4I4G430YPscdVPge3PAcgKaP4iIzjBewI3Pj//gW7l5UWCFlCT6r62XZopZY4b0GVZmx4w33fEs2CsgzuV9NEAi1BEaIiqp9Pj2R+banCrPCKeVVqMFQpyop2mceNErpt9qBCJmR0NF+FOxixTpZXAx2AoA/lHPF0orsSwO5M3p/KH54l7h3/xj8RSarX4YKDZ5nJ15uTWdbecoaSOOx4CYfJpenvI6QNM0eqFZlk6+ZhYC04RDiH/FJ7lFwO0O9prBSfs2/FXYvcGG4OXptqksAal8BFAeNLmwXxp0CZeYS3/FtYB9rZKlX0gRLTxJPWAsLJZR6iBG9yijE5siAQXom/qvaN3C2pRnSzBvgxk7nTtLhuF0ABYEjV0VtkfvOSKeKgpbQiQ4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(346002)(39850400004)(396003)(376002)(31686004)(316002)(186003)(36756003)(54906003)(110136005)(83380400001)(38350700002)(38100700002)(2616005)(6506007)(52116002)(53546011)(4326008)(66946007)(66476007)(66556008)(8676002)(31696002)(2906002)(966005)(6486002)(86362001)(6512007)(26005)(41300700001)(478600001)(6666004)(8936002)(44832011)(5660300002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3NjQTVoQTQvOElkaUlnVHdpOTRmTFI3ZUhJU2JjeE5sZit4MkVrYXo5dnRD?=
 =?utf-8?B?TitVMjB3Zm0zUEczZGhGcEFRNmd6ZS80RHZ5TWNrUXR5OUdVbEFrZ21jU2tq?=
 =?utf-8?B?QmxVY0xZc0lNNDkybDRISFRvQzhWZEFIaFQrYWRsVFhLcDFlUTdaMEt1aWVi?=
 =?utf-8?B?bE5SQW1KV2hnWUQ1eW5aNG5Dbm82VVpyWmFDc1JjbE5qWTlqckN0enpaemdk?=
 =?utf-8?B?S3p2T0RoUFVlS3VYcm9INlhPcEZFQ0E3WkJLaHJPRXRWRU42MWhuTVJ5bVBa?=
 =?utf-8?B?cTZtVWpMSXpsclU1Nlh6VlBsdzQ4NVZNVDJtWUdHRTNGbkFOc3NQTi9KQjF4?=
 =?utf-8?B?b2pGTC95RCtxS1NxTmE2b2JHRFJZYkx6ZGp5aFZRNmdHY01jbXljRFhzWTJT?=
 =?utf-8?B?Q1hyV2hKV04zb0FzVXhkSGRKMDJCcjlMaGIxNHh6aTFDMGtOZHlWOWhBQUxp?=
 =?utf-8?B?T2JkL0djR2JHUmZiRk1kTjIwc2J1djhkRlpnR0svVzQxKzJZTFZ5d041L0sr?=
 =?utf-8?B?OW9FY2FsZVNHbEUvMHpyc0s1cHBTajErdER5cEY4Qjc4bHdpdmxncFYyZEVL?=
 =?utf-8?B?VnpmRDNLbm1Jb2E4TjlZR25qeUx2UVprT0pEeEhqQVJxaDZ3aUM1UFB6cUZY?=
 =?utf-8?B?dHNWZ0dvV3JYUzNGdGY2ZnpFUXFJNGpaNUtHMmNKUytNcGlTMkZvYVljL3Jr?=
 =?utf-8?B?T0ZyQ2VnaXRjZ2tHZDlLYTNBS3B1ZkFxaEprWGkzRHRueENzbDlOcHJNNVhL?=
 =?utf-8?B?YUJEM3ErVGlwYmVQUTBtRDNKNWtIUjUrUm5rY0xoL0Yxd1I4Q25FNll2NFBE?=
 =?utf-8?B?bk5ET1FaUnl6bnZoK2VQZ1RmcytVQ0Q1RjRQYkcyS3ZsNzFGdWEvZTRYWEIz?=
 =?utf-8?B?MXBJenphMkFMak56VFhZNjZiUGpwY1Z0M01HRG1wb3VOcEpYL1FwUzdHdkp1?=
 =?utf-8?B?eXJiclhjUU00TkoyaDRCMVAvYVJURi9hMk90QVlXOEFTVFVpTzlEQXk0d2Nm?=
 =?utf-8?B?TXRpT0paazlTL1FCOVZKcnUzQU9oSkY5TFFWVWFTVEw2NWlIaHIzYmFTVkln?=
 =?utf-8?B?NW9ib0hjNnN1NEQ3VWwyVVgvTkNzdXROK3ZXbFhNUjg0dStjUXFyUU05aDdt?=
 =?utf-8?B?eGF5N1VSSFhxeEgzZFEra3Jhd0NuRDRldUV5bmw4U29vb3ZoRXdNWDFwQXNG?=
 =?utf-8?B?cnZBL2FuZEhidkNaaEFnS1hDcURONTZqcS9qVzQ2SFZXaG5LTlgxK3JiQVRk?=
 =?utf-8?B?TDB5a0VqZ2plcFZabGhBQmhQL1NTclNJcXNQTDdmSTI4ZXlWQm4ycHE4QWtJ?=
 =?utf-8?B?czNyenp0eGZVZEhFdThRVkt3L2ZQazJkeG9zemVpYWdIcVdJSFVFYXM2a2tB?=
 =?utf-8?B?VVpRU1U1Y0NMYUF4dXNnMW5sTDh6SThOQ2g0Q1dYWmlMN3E3dlNjcW1BOFRo?=
 =?utf-8?B?eUlvejNqcW5HcWZhdWpUVWJnam5tRUVyUGJDZysrNVpGWURDSUxES3c2dnpH?=
 =?utf-8?B?b2E1dk9sRC9wMkRwWUNOY1p1RFVBVU10QSt1eTFSMHRTTkREMnh6THJlQlM2?=
 =?utf-8?B?VmlLL2hLU1hscVpCTGY2ME13NkpsamN5SUp0Sjh6RWhUd2w5dnVXU05wKzMy?=
 =?utf-8?B?RlRMZThNNUhwdEYwaHFUQ1FRQjd4SUcybm9hblhDb3BiTGRKbjVmbnJjZ2Ir?=
 =?utf-8?B?WnNvanFJeVRWbFVoQkd2cHBMcVp5V0lYc1JMbXl6S2VPb2dseDFyVENyV2Fn?=
 =?utf-8?B?UzAwZ1V6Yy9qajlhUDdiZHRkS2ZlNm1Ta3c0TCt2d08yWVJ3UFgxbjJpVFRN?=
 =?utf-8?B?WmRNVUJZK3RtZ2hCVG5paWpuNERwd2xYV01FZmJTQmFkZ3ljZlB1UWcreFNC?=
 =?utf-8?B?ZVFPSnFJQlUwT0tjcVBFTUlsK0JpWUtpWmNVQnNoRUJqSjBtSllhbitnU244?=
 =?utf-8?B?amhBSUxDb3VBa2M2Ty9seXlRd3FITFVwU3dEa2h1S25takNnZit4UlovT0RK?=
 =?utf-8?B?V2lOY0ZsS3ZERkFrbTVEbGVJNTA4NVhDd3htMnVQamRGbnZjTjNJVTRUL2RK?=
 =?utf-8?B?MEtTUG5veCt5d1lUd0RBUldaRVRQMDArQzkrV0YwMHhXeXBqN1ovaGIwODZV?=
 =?utf-8?B?NFJVS2RVSElsZHdacXh0WWk2eXdGK2lkaVFCZEQvMWowTkFwc3hZU2F6Q0xL?=
 =?utf-8?B?Nnc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f35228d-6988-44a5-cd3d-08da812d4c82
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 15:21:18.5842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wmUZPAdZgo8HeQ366f4L1Gm+CZgKBYr9QJ9ElV9xW5gA3FqQJFUUGK7OodbQ73IFNcypHa/9HvDEMqx1g4OO1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7965
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/25/22 11:37 AM, Sean Anderson wrote:
> This adds support for phy rate adaptation: when a phy adapts between
> differing phy interface and link speeds. It was originally submitted as
> part of [1], which is considered "v1" of this series.
> 
> We need support for rate adaptation for two reasons. First, the phy
> consumer needs to know if the phy will perform rate adaptation in order to
> program the correct advertising. An unaware consumer will only program
> support for link modes at the phy interface mode's native speed. This
> will cause autonegotiation to fail if the link partner only advertises
> support for lower speed link modes. Second, to reduce packet loss it may
> be desirable to throttle packet throughput.
> 
> There have been several past discussions [2-4] around adding rate
> adaptation support. One point is that we must be certain that rate
> adaptation is possible before enabling it. It is the opinion of some
> developers that it is the responsibility of the system integrator or end
> user to set the link settings appropriately for rate adaptation. In
> particular, it was argued that (due to differing firmware) it might not
> be clear if a particular phy has rate adaptation enabled. Additionally,
> upper-layer protocols must already be tolerant of packet loss caused by
> differing rates. Packet loss may happen anyway, such as if a faster link
> is used with a slower switch or repeater. So adjusting pause settings
> for rate adaptation is not strictly necessary.
> 
> I believe that our current approach is limiting, especially when
> considering that rate adaptation (in two forms) has made it into IEEE
> standards. In general, when we have appropriate information we should
> set sensible defaults. To consider use a contrasting example, we enable
> pause frames by default for link partners which autonegotiate for them.
> When it's the phy itself generating these frames, we don't even have to
> autonegotiate to know that we should enable pause frames.
> 
> Our current approach also encourages workarounds, such as commit
> 73a21fa817f0 ("dpaa_eth: support all modes with rate adapting PHYs").
> These workarounds are fine for phylib drivers, but phylink drivers cannot
> use this approach (since there is no direct access to the phy).
> 
> Although in earlier versions of this series, userspace could disable
> rate adaptation, now it is only possible to determine the current rate
> adaptation type. Disabling or otherwise configuring rate adaptation has
> been left for future work. However, because currently only
> RATE_ADAPT_PAUSE is implemented, it is possible to disable rate
> adaptation by modifying the advertisement appropriately.
> 
> [1] https://lore.kernel.org/netdev/20220715215954.1449214-1-sean.anderson@seco.com/T/#t
> [2] https://lore.kernel.org/netdev/1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com/
> [3] https://lore.kernel.org/netdev/1580137671-22081-1-git-send-email-madalin.bucur@oss.nxp.com/
> [4] https://lore.kernel.org/netdev/20200116181933.32765-1-olteanv@gmail.com/
> 
> Changes in v3:
> - Document MAC_(A)SYM_PAUSE
> - Add some helpers for working with mac caps
> - Modify link settings directly in phylink_link_up, instead of doing
>   things more indirectly via link_*.
> - Add phylink_cap_from_speed_duplex to look up the mac capability
>   corresponding to the interface's speed.
> - Include RATE_ADAPT_CRS; it's a few lines and it doesn't hurt.
> - Move unused defines to next commit (where they will be used)
> - Remove "Support differing link/interface speed/duplex". It has been
>   rendered unnecessary due to simplification of the rate adaptation
>   patches. Thanks Russell!
> - Rewrite cover letter to better reflect the opinions of the developers
>   involved
> 
> Changes in v2:
> - Use int/defines instead of enum to allow for use in ioctls/netlink
> - Add locking to phy_get_rate_adaptation
> - Add (read-only) ethtool support for rate adaptation
> - Move part of commit message to cover letter, as it gives a good
>   overview of the whole series, and allows this patch to focus more on
>   the specifics.
> - Use the phy's rate adaptation setting to determine whether to use its
>   link speed/duplex or the MAC's speed/duplex with MLO_AN_INBAND.
> - Always use the rate adaptation setting to determine the interface
>   speed/duplex (instead of sometimes using the interface mode).
> - Determine the interface speed and max mac speed directly instead of
>   guessing based on the caps.
> - Add comments clarifying the register defines
> - Reorder variables in aqr107_read_rate
> 
> Sean Anderson (11):
>   net: dpaa: Fix <1G ethernet on LS1046ARDB
>   net: phy: Add 1000BASE-KX interface mode
>   net: phylink: Document MAC_(A)SYM_PAUSE
>   net: phylink: Export phylink_caps_to_linkmodes
>   net: phylink: Generate caps and convert to linkmodes separately
>   net: phylink: Add some helpers for working with mac caps
>   net: phy: Add support for rate adaptation
>   net: phylink: Adjust link settings based on rate adaptation
>   net: phylink: Adjust advertisement based on rate adaptation
>   net: phy: aquantia: Add some additional phy interfaces
>   net: phy: aquantia: Add support for rate adaptation
> 
>  Documentation/networking/ethtool-netlink.rst  |   2 +
>  .../net/ethernet/freescale/dpaa/dpaa_eth.c    |   6 +-
>  drivers/net/phy/aquantia_main.c               |  68 +++-
>  drivers/net/phy/phy-core.c                    |  15 +
>  drivers/net/phy/phy.c                         |  28 ++
>  drivers/net/phy/phylink.c                     | 302 ++++++++++++++++--
>  include/linux/phy.h                           |  26 +-
>  include/linux/phylink.h                       |  29 +-
>  include/uapi/linux/ethtool.h                  |  18 +-
>  include/uapi/linux/ethtool_netlink.h          |   1 +
>  net/ethtool/ioctl.c                           |   1 +
>  net/ethtool/linkmodes.c                       |   5 +
>  12 files changed, 466 insertions(+), 35 deletions(-)
> 

ping?

Are there any comments on this series other than about the tags for patch 6?

--Sean
