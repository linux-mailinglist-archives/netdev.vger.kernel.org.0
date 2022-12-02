Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29BE640E3F
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 20:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbiLBTPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 14:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbiLBTPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 14:15:42 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2082.outbound.protection.outlook.com [40.107.15.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6BBE465E;
        Fri,  2 Dec 2022 11:15:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1HAR/oF2d5MjEy5+zAyfq/c/sYOyhjle4HlRGxULWgHwGXQw9Iz626hBG8Pe2OfJxa6Rf955m/rbkj0SHVoM8NRLa2vJCgiK1RqeGecxsfWo88TBxas56jMidF/GVtFjvfGE9im4uObbMZb7gZsQqR4XV4ghFESRyKtqdcPqBk2w5aDANJex8Cr8ceLXt/5p6xpSeUr6MirxECcWr0TCIxrI2R/X7PVUMpAELpKK228JL0lPix5a7vSINIQb4PFc1r2wky8xDOS77/v0U1+YS78W5pyXg9uRlgvOO/JipQ9GLOeQYTATimCc6xdcfwMLQABKvQxP1qrv2qEeFNkwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YzDY2IyxIBt8EO0vv98v6NPvqQMfFWuvRKfmPgZZ+zM=;
 b=OM9skkq6KrVJCYJUMhpFpzc1vhx6RDY4hxPsXF/83wgsVAUSiQCxdYClc5PGf8o7k3cEm9KxtYK7YigSowKLJ1LawgxFqiYVfLcRvyXN5VMkLQtnicI/cViltcFj4myoD7RZzvrFVPGZHiEPUHedapRgRvUw72TOan1SiAxjFM20r6L/DSU2SLv9qz9uH7Dp0G7lY8w4fwypJ5IE/ahCdv0iTL533tCfVcWdmr5bzZ+WdUJ//xo1P2/ZrQzDJA4BCWA1or4YrAOuXfoBZMbJdgACE8LzK+wSbFeFDY3DBoiKCaR+TPM7fBvqUW/Gm11ZIKPqA22PGUNgVu8I/siRPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YzDY2IyxIBt8EO0vv98v6NPvqQMfFWuvRKfmPgZZ+zM=;
 b=j0XIelI+c0HJMFr/2W6zyGMTAdjxGQfWXsnbqPQP8p7I+J9EADG4NrKUUTMRcdw/jTZRCzuV074H7AjJs3M5UwbrDj5T67WFSUIokxewmp0+YySHxNqNcixUCQ/rJ9qvkaPdQ7qHKPpKGLEiMt1pbFm8hyOsq4q9EYTGfyFQEx3AasBn0z6BwuJXhexM203rT63xEKhAXvQ5WzHJOtaw2RB5SU0Q6JCJSofmnQ23gPltFFtSQazwyF3sPSZlPozx1ICAlXjoPhJe1OtWJglbuSLmNxifAza47dAvwhiz3yW2cDvaYQku3qRWJ6AuQSlVIN4RqtuVzL/+1ktNS9syzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AS4PR03MB8256.eurprd03.prod.outlook.com (2603:10a6:20b:4ff::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 19:15:39 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 19:15:39 +0000
Message-ID: <932147bc-c599-b5a0-5659-bc36d3581da7@seco.com>
Date:   Fri, 2 Dec 2022 14:15:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v3 2/3] net: mdio: Update speed register bits
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Tim Harvey <tharvey@gateworks.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
References: <20221202181719.1068869-1-sean.anderson@seco.com>
 <20221202181719.1068869-3-sean.anderson@seco.com>
 <Y4pLaQ4EB5jSuX5d@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <Y4pLaQ4EB5jSuX5d@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR10CA0016.namprd10.prod.outlook.com
 (2603:10b6:208:120::29) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AS4PR03MB8256:EE_
X-MS-Office365-Filtering-Correlation-Id: a0f68e82-7d71-4025-614f-08dad49997e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: saYrnKxybGTajlZ+gskyML09JY03MPB0Zkq6sAc0fY32jJugY5ORsafn0wc7+Uh7mHT+CPNnAWv6Ky9Qnbel2gsH8Z6fmaBmGOJe41pAlRBJ3/t+2b88wpIqSWiJvO9IJD/cMjy1omJLVJJn8k7Yd7RKgfWsGuceSU3+ms7mTzD1m5WpRwmYCWVAPkVUYJ4+pNpIZGDm3yqeOTccXwK6zDbM0G2QBqPb8pv2JRgNd6XxCvLBRal4bGgnrWZQYl3leKY4FTh4qmEdOgpR2Bls89pajxeeyaM/mq9U9pBqwNH+XrtxK/Tg9+Yl94ftC6lLnAclrHxRBFqOiXcJD6rOvk5MQbmEEkwEd5fDHcfs3X4HLwHXrHKiAlGB7wwFw8ISErqaI9U+gsndNLhocHrDqbCTha8gaKcQzQQmRWTgynouXoPlbhDx7NXvIMSaPDpYyrp20TfTgWDeZJ2fmSBLwmuQOhGbL7HNHPP7HFJ4+eF/PdzIdWwSE7fjFrbmkD5jEzjJZKtrhVc4/CFnDtoO2uMfUChzA03QvciGGY/q61cUyPByhsyPBPE0hCLIWjHEkKQL/gzuOVliO1zRI2Romm8DF2OYudO+VL5I3wqmvUwpeeW9fbW88LiRwNikz+TkAjUovK/Ra43FVfWRmGOxMyTzottOOGPtOPuQX4P/vhtRchKaBEbffECn5dI+Ek9deXcIL+AU4iKWU9HedRQP2fmxRgN3cxTaVPkLJPj7dQ7ZpVJQpAhAjaJyVErEz/Ab
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39850400004)(136003)(376002)(366004)(451199015)(2616005)(54906003)(44832011)(31686004)(6486002)(6916009)(316002)(36756003)(31696002)(86362001)(5660300002)(6506007)(6666004)(38350700002)(38100700002)(83380400001)(186003)(6512007)(26005)(52116002)(2906002)(53546011)(4744005)(15650500001)(8936002)(478600001)(66476007)(66556008)(66946007)(41300700001)(7416002)(8676002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXBGRSs3RUpzNWUwd3BmbnlUYmcwaUw3a0x4QlN1bXNWT2luZzRYWGkwUVpH?=
 =?utf-8?B?U0lHQTBEQ0JXMExTUTRYUTlHejd3WUQvbFhEcmhPOGtUY1MvTXlVenJ3TGFw?=
 =?utf-8?B?K09xOVhxUzNLS3E1a05IUGhkWEFhRFhtbW1VVzIwZXlxblV2UUljb3QwNGFo?=
 =?utf-8?B?bUo0ait6Q2NhRklkTkR1WEs3VnNFL1dMMTR5eXpUWWpEYWlJTjl6Q2loWjh6?=
 =?utf-8?B?TTZNVTdWZ2VUd2dUZGIwc0hpeVdKa2dYVGNDU3ZqOFRVd3VYMGhqb3ljTGRT?=
 =?utf-8?B?RGtOVlQ4UndsQWpZOXdGZjRoOWg5UEJmYWhDSG1CNG5ySE83U1ZlaVlqYkdG?=
 =?utf-8?B?NUdCMVB0VEpTY3hHN1VJbG5aVEVPUlZ0YmMvZmtzekhBUUdPYkI3TGdKcXZq?=
 =?utf-8?B?eWJTdHJVcm5WV0lqVDJzeVBUMEtwSnU2MlFlZ1ZwTk03aHp4d0ljNkdzdmhB?=
 =?utf-8?B?S0tuYnRaZ2Q5SHVrenN3bkhNRzdtTC9SYUJiMENvY3ZNMUxlZnpBbS83QkNm?=
 =?utf-8?B?SkdpY3AxcUtCT1g4M3pIZXJqeldyanFHUU1ndU1oRUFOa2tyTDA0Y0Z0Z3JD?=
 =?utf-8?B?Z0k1NGlrcTdYekZHaFRKOXg5cWkzY0I5MEZoaGQzeFIxTTNyYTQyUmkzZkc5?=
 =?utf-8?B?dnlVaEFuVjZqdGZKck9mUlg1SW1Ca2xScTNoZ1FXQzB1eXNlTFBqV3VlbTRm?=
 =?utf-8?B?QTRDSktDeURXbnFOOHdNVjdZZGpURVVrVWNCWmJmL0VLM3hSejJyNzhiblBX?=
 =?utf-8?B?WEFHOGNIQ0M5OFFiWGQzWlFVRURXS1pERXA2NTZWMEdKRkxQeTMzSjZSbzNs?=
 =?utf-8?B?MGRwNm9ZNVNQM3JiQlpoZlpnc21kQis2VDlXRVVVMTFuaURRR2p6bHpIVVhn?=
 =?utf-8?B?Wk1MMVYvNFVRVjRjTXdNTEZNTmw2RllGcGtaTTBhNWJ1OTRzeDRsWG45UUtT?=
 =?utf-8?B?TUZmenBPWTVtK0xPR2dvMUR3eURDMXArYnNEM2NFeU5TdVVBNXNldkdIQ1BU?=
 =?utf-8?B?NEdMV2Z4MHBvOWZiNFhMRmJCN3hBSWRsSVRvOEN2TDAwcTJuN1NxWHFpOXho?=
 =?utf-8?B?ZE5UMVJpMmd2VGNLSVM1bUNnYTJlenBOZmcvRFB6NmZCaHpIZzhHVExxa0Mr?=
 =?utf-8?B?VzdXK0llTTQvV3Z1UFZmQUs1NEhoTCs1ank0SHhLZlUzL3FUREtBYVRCeGZE?=
 =?utf-8?B?S0VSK3dYZC9kS0tyay9GMFI2MmJFYW1hdGhCVnNIL2pNWC9UdWhhamUyVU9i?=
 =?utf-8?B?a1N0UEVhd3VGRE1XWi9IRG1QbmF5REVLMWJVcE8yL0dhTU1rck1EWDBiSzhD?=
 =?utf-8?B?UnA3T3FMNE83TEdDR25NejlBa2oyMDZjaUFVcE1hSzRpczVrYmh6V3lHRjIv?=
 =?utf-8?B?Mit1bjBYZXl6bEREZm8xa0taYWR5NnY4RUNaYXliZUVINUpaa1RjeWpLV0F1?=
 =?utf-8?B?Q0I0REFwOEhCR1Nldmltb0VzMExaZzgrYjRVdFNlUmRaVi9zNUtPbEZMcXJn?=
 =?utf-8?B?Y0tsUktkbGJxYWsvdGFpU09FcjBRQU9nWjQ5cjVDMEFQUEdiMTd6eHNxMFFt?=
 =?utf-8?B?RURqdW9TWlF0MjlKc2xzdkpMVmtpOEg3QkxlcmdqTFlqQVJ5RjNQUkRZSXB0?=
 =?utf-8?B?ay9FYzEyMGlWVU5KRUZUdXUzRXdHUWhyc1hIbVAxYSs4U0p1VDVCZ2VEUS9u?=
 =?utf-8?B?V3FKWmNYWlhJeXl3VWU2WitLc0hzRkJWNjdQL3BNZDFDVTkrMnJLdENCYVRQ?=
 =?utf-8?B?KzExRitvTUVJWXBUbEFsaVF1bW91OGcxN0craEl3ZHg1K0kzdCtBUkNDUWYy?=
 =?utf-8?B?Q01xU0pReS9mWHRCS0NzbWh4cG1wbkZaMFNtS3YyY285ZUlHekY2V3Axd0I5?=
 =?utf-8?B?ZTYvTEYzZ2EwakNWTzBPNDhCclljbDlFM2xERjVNdTJMUG82Z243QUtKWTI4?=
 =?utf-8?B?Skd5b1hrRzdBdmRDd0k1VE54QVJuc0tDUC8wOEtUT1NFYURBc0k2eVB0ZjRS?=
 =?utf-8?B?MG1kWGhUTU1XNWUxNW0vbk5xNU1qbmtpMHV5b3VNSURweloyekF3Vm5STlJK?=
 =?utf-8?B?L2ZKbXp2Z0UvV3A4bkFiT3kxeTQxNVJ6cWlpb2pXSEhjOUV4eGlITEpoc0dh?=
 =?utf-8?B?S3F3UHF5b004UCttMmNiY0lzUWx0VUxXbmVLZzZBQ1VrZ3VvTlZhc3dwR3V2?=
 =?utf-8?B?eHc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0f68e82-7d71-4025-614f-08dad49997e6
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 19:15:38.9105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZEp4XkZ1XNRa3LSd/8oWCINDrQgJmTU8QBYtOSjy5AooxdKfyckKMxGwHJjPRgKaUUWy1pP6y3gmljFWTwuaTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR03MB8256
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/22 14:00, Russell King (Oracle) wrote:
> On Fri, Dec 02, 2022 at 01:17:17PM -0500, Sean Anderson wrote:
>> This updates the speed register bits to the 2018 revision of 802.3. It
>> also splits up the definitions to prevent confusion in casual observers.
> 
> Are you going to do it for the other registers so that there is
> consistency?
> 

I wasn't planning on it, but I can whip something up.

--Sean
