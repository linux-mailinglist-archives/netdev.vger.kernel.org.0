Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7680598975
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344662AbiHRQ6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345149AbiHRQ6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:58:02 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on0625.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0c::625])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625CFC9903;
        Thu, 18 Aug 2022 09:58:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IRG8mzadKP3A4BWNRUOwku6T6r4EdptSFYVKAE/bDw+dkCrlmnL4A025yZqcBmUnFawWsIP3roP2y9G06Rd7Xo1g4H3mwIZ83OH5ibHWwIrnzdcc+R84KDYx8nc3XOLw0fu9Juxa6Cxg5O9KPMcHmcut1I4N9bic1xYm5hdaXd1+l0o07ckKbSWr7Rad/FSlIR4CVs50Ic2KlBinFYKtLn5FjPkZCoMuTxg8abM9Tm9xiYb5CZOBas673I/hwlmQN3dZmHC4sBUwGwoTp5pXpZCBdjXLc8HwcBImdTfqhdczpf6zY5AiEIC7PQDpjzG7mnCDaDHjrirj0HUblRk/Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7pMpc7AfiSFaIrgx4OqiWGyBefWXz1du7GvXSATMRoc=;
 b=K9GdVdZXtxvxGcUQtNWAg651kBni5m/0DJ3xeHujB3EpHxvSkFRHXkxSp/op6maqVmCnBjD/ec0Yg5LsIZ+4fGjclTA8ucPqOSOw64CZC8S1UhbpGtk7nTjb1mXJ//Y2tC5pfFqBc6y7EzVWMvsh8Dva85LElBwWdysvWtIcqagNFmucWwPaGvMlPH66BRtP9R0Eic8RBK7HAZ2J0BQw5fxYVq0IL8Wou3nIl09xwHMbC/F3vs0S486VsPnZoTOKDQg5wNoDnfyYcabGNxqqccUIlqAJE3GTnZ6sO5Usya3LOjOy4efSRWCenMsScxvskdrYUQ9kOd8KIKeh79Cpug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7pMpc7AfiSFaIrgx4OqiWGyBefWXz1du7GvXSATMRoc=;
 b=PJmtrlSsfZ+0ydIIOb/V4Zfcyt50lc7TKPf4/LjSahBCxlw5uIV/cqN6NG2ZGA5vmzAmdTrpvjCnOkeUiBzxrLR5zOIP3O0xn6sHtX5qnpudj2/t/7LMaiDHCuDO9stBWVVj7t/HvqDd8FCzFlMY911pW+MPCOE4MHwLC+38EAHzXhXpy4z0AtmeEk/MYDISJhj7oY9KxIN7XQRnwrbD6NCoKGSFFEN4NVgSllqGOUD3T0aWnNpefjRmRDHNoBmThfK0p3XEbAv2ZilPbSMfsfjJgTelQDtEV1O/9tFKT0IX7AW23UMEqtKroDmMyUsHvEatf8ZH05uUmdYIg8SBLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7603.eurprd03.prod.outlook.com (2603:10a6:20b:34e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Thu, 18 Aug
 2022 16:57:57 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:57:57 +0000
Subject: Re: [PATCH v3 02/11] net: phy: Add 1000BASE-KX interface mode
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20220725153730.2604096-1-sean.anderson@seco.com>
 <20220725153730.2604096-3-sean.anderson@seco.com>
 <20220818165303.zzp57kd7wfjyytza@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <8a7ee3c9-3bf9-cfd1-67ab-bb11c1a0c82a@seco.com>
Date:   Thu, 18 Aug 2022 12:57:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220818165303.zzp57kd7wfjyytza@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0071.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54389a27-ac02-4aca-ecc9-08da813accab
X-MS-TrafficTypeDiagnostic: AS8PR03MB7603:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mUhTfh3GfCHPBMd7DtDzp+FGEzyVasjtHVgfqQYxuKzPV+3Kkpm/ZgN7mSWFKQc8SpnqxE5568E/xh9c9Acn3Ag8N6M3lHeZsaeHGCXTFBsW6l0QmUekO14E23SGHUtadrJkcZ4ibk3xqEQmaDMD7/pYcxkTwxZVOIfNWrz5eDXbgSTUS4i26ygeHS3QGNm6a4PuVAlcleobNVgNqVAlPL8j6jwKq2mvDeTIlV5AyOpb+0j2OySnf8luhK69i+uNXSoW6+22B+lxVWwlBaXbkGwPMXl3jjcoZGLKMXwzvwFSoe6hqiCzMyLzCRjbWkxhjzXHOkWYBEg4gZK4A84Rna+7nlKYbLG+UyHQwwxA2RWbz+9mxPxo+8cqu4SSgAVH+ztFkK/RmB0GJygkEwughbw2V3X4mQMKtEjkbZmx9qbqhFvOqgzDdH32N30d3kR58YSN0I5ojG7MjB3f+gkRxQ9fzBDxytMLsgkvlELHPQ9BpcJMkYjbJTD3OHuUUSYVTxKpLia9cDWawuo9smKjo5rR/R6oeqP8wioDP41v9QtthZsHPMj6vrPk9TVLY0ga2a7fkOX57EuaN79RlPsAg4T9KhegQFl9fe2dS5oLPFB5kcdZ9HfX6+4l27Mz06U2aJBmGAnpaXNpXJGnA+vl9fD4EvywwHH9JX4JgcyD4h2IUcbZxQrIs+j+71aoAF9lbdlChAosSInz24fI99+hopR50g5yy+OMuc1p5CdiV1DK6s5nyMws7Hl+05K6a4k5BcptL/DqKALk11Ao3Zost30RAzuCwyH1N/RIXp4XJxUmOxFrFbmJSWEJkhUYGhZt3MmRWy/biQTMMxdL4hhxEjasLGEWgcIEINnTjbPQSjE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(346002)(136003)(396003)(366004)(376002)(41300700001)(966005)(6486002)(6506007)(5660300002)(53546011)(7416002)(52116002)(186003)(478600001)(44832011)(2906002)(6666004)(4744005)(2616005)(86362001)(6512007)(31696002)(26005)(8936002)(316002)(54906003)(31686004)(66476007)(6916009)(36756003)(66556008)(66946007)(8676002)(38100700002)(4326008)(38350700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXcrelkrdjhOaElxRFNMelhMeHM1Ly9kL0hYOUNaZHNZeTc0RXhPMTlodjVq?=
 =?utf-8?B?c1RSMFRYQTBnMDhhdWtnRURoT3VEYXBFbEZxVmpjSkJscEpZbUs0VHgwKy9r?=
 =?utf-8?B?eDl4ZnRjUFFwS2NrNklkUU5lMllsWk5mR21YeCtPMGZkM01hMGlEcTRSNUNP?=
 =?utf-8?B?aENGQ3IvU29OcDZlV00xMXBXQzFRQVhOZzJSem9ZNEdqSUNLckJGSHFjWkd1?=
 =?utf-8?B?bVZuVEIxQXFWNlIyM29rWmZ4ZkpiYnRZL0EyQTZQbktQeFZQWkhocGJDOGZj?=
 =?utf-8?B?OURuNmpvNVRRckE0YjJjTHpjRFJMOVN1ZGtzTW41MGs0QXFPdGtsWk5DRysw?=
 =?utf-8?B?R2duQ2RUdWNzUkZMTlFjeXVMbDFub3VvUkRQUmFZRlBUTlJvQktLYTVjQTYz?=
 =?utf-8?B?VjFhRDBrTkZPSmlUQWpKUTdxbWpCcDhhd1NMajNFYnFvR3MwSFJyM3MrcjhE?=
 =?utf-8?B?clNFbG1jSG45bm1uc081OG1vSUpGUlpkc052NEtRZXczSlpoNXRGOHIzZmov?=
 =?utf-8?B?Y015VkU5dUN4Y2VMRTlEYS8zNTg5R0V3V1BUMTA3SlhBa1pWYmpZS3hveUpB?=
 =?utf-8?B?WEtlWlpQbGJsWVF6TWdjM2Z3SkQ5SzRLQVcvTTM5WStUMXI0ajNWY0lCYzFa?=
 =?utf-8?B?MzJxcnB1RExOMVg5M2tmeTh2YVNZVkN1UjJaYjdVd0hGVWNiMmpaZkJXcWpC?=
 =?utf-8?B?dEsxamY1NHZ3NlpFWFNJOFN3SjJldUM1Kys5enUvMGNkN2s0akdpR2VlMTI5?=
 =?utf-8?B?VmF6U2NEdk5MT21MaWJaT283ZkJrV0JCV2N3VnI4dkpsc2Z1WjRQcjV5Q0lm?=
 =?utf-8?B?NDhGeFp5OHdvazE5Tk1nOTZnZXh1N2U1aEhKL3lOaldCRWlsQzVqdnRTSmJx?=
 =?utf-8?B?VzNXblBPUHVMTFlWOUtFaCsrb1l6Y202T1lFdVM2QU1HNW9CblU1KzI5UEVJ?=
 =?utf-8?B?b2pLTlk5dGQwcjVQYStsN29JMWNGOU03SEJtYXB1YmFPN0JBZFQ5NG9QZ3JV?=
 =?utf-8?B?eDZYVUZxdDVpakE2c3NvQmtJUnVuWE8wamtZQzNXQjNrNkszQWlpMER4Zis1?=
 =?utf-8?B?MmJadVhjeXdsNzdCMDE3K3F3aE9OTmhxcVJkVC9HMzBaNEpWQUgvSkFoeTFM?=
 =?utf-8?B?Mm5oOUNWU3k4ZWRkUkJ6Nm10WGpxU0JmRnVJeDdoLzIxWkhqd0hvM1d3MXFs?=
 =?utf-8?B?TUZ3NG1VYTNvdCtzbEwzSnVHd2NiTEZETGMvMlN4cW9uNmcyaDZsVzdkMHFq?=
 =?utf-8?B?SGUyekRmRWZtMDZkYTR3M295ZG0xQ2RsZ1dxUUNWQUVhb05zQ0lRREFHUVJL?=
 =?utf-8?B?ZzlMSmtPa1lDMXlSS21XcHU4RWRVNmdyV09Wd3dUelpDMmFMRkxSa3ZZZDVi?=
 =?utf-8?B?anBMczFHNUtTR3o1VWRqNGtockU4NVQvdmRFSGM4aWVobWc2TzZSQTA4bzRV?=
 =?utf-8?B?WWlycWk1K1k2MDVNTUNWNTdqVGs4cUZFVTdoR2pxQTJHclhJZWFlbFh4S0F3?=
 =?utf-8?B?aXFyRlNiQzh4cnBOQVFicUFSa2dCN1VINGdscE90eFdITmxIT043NzU4dndk?=
 =?utf-8?B?ZGNid1NWTmhCaG5ZYUUxcmpKMm5aVVpxMVBCTlMzbnQzd1paM0paUFpRY1Nq?=
 =?utf-8?B?NkYwNDYrQ0lqSnZxNXpvdlpsRzlIQ3RvSTRkMlpzNzM3ZUlyb1QvZ1g4Mmlt?=
 =?utf-8?B?Vk5UQ2E5djQvTFF0M0NqVldpb3hOKytHSk5JaFIvRHNETU01VWZLRm02RTk0?=
 =?utf-8?B?Rjk2S0w4M01jdERSRWNpYzMrbXZoQ3NzMTN5b0o5RUZvQTVjUzJKTmdqR1F6?=
 =?utf-8?B?MzZrcHlHdW1VSGwwcDBXVXhoT01PbkJTZEdwNnRRc0F2R0c0U3YxdlU1M3U5?=
 =?utf-8?B?eXJRS3ZIWE1IdnkvbWxQTGhvWUZUcEk1NXZyajNCT1ZaTTZTOXV2OTdnN2to?=
 =?utf-8?B?SUFLYVB0VjVMTXdtT0hxc2N2K3BoZCtPRFpFNWhIa1ZBd2lqaTFwUzZjOWxa?=
 =?utf-8?B?UGI2dm9NeEw4a25IRVJ2Y25uYXUvV1RPc1dDTmM5dlZzV2F6NXFsQmFjREVj?=
 =?utf-8?B?YmlxUEFUek9xMFdFVlhZMm55UnBjT21FRUM4b0JVUm54aklCOHNnY0hHV3Ry?=
 =?utf-8?B?OHpLU1A3Q3VZdkI5ajFNdE1FYWVlcWhxV0NxN1NadW9rZ3pzNGNESWJndG5H?=
 =?utf-8?B?NHc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54389a27-ac02-4aca-ecc9-08da813accab
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:57:56.9189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +qnh1V8L0XtT2eg1/lANBTu3FOrulo1qpHc6+bXq4/elrGSRDqeKU3o2kEjfEMBuM/Ee0UKFAmhf8AmlzYS5wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7603
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/22 12:53 PM, Vladimir Oltean wrote:
> On Mon, Jul 25, 2022 at 11:37:20AM -0400, Sean Anderson wrote:
>> Add 1000BASE-KX interface mode. This 1G backplane ethernet as described in
>> clause 70. Clause 73 autonegotiation is mandatory, and only full duplex
>> operation is supported.
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
> 
> What does 1000BASE-KX have to do with anything?
> 

It doesn't, really. This should have been part of [1], but it looks like I
put it in the wrong series.

--Sean

[1] https://lore.kernel.org/linux-phy/20220804220602.477589-1-sean.anderson@seco.com/
