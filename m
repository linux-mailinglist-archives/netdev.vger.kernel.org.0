Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B56F59CA56
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 22:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbiHVUsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 16:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiHVUsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 16:48:03 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3AE558F0
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 13:48:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGDXF37m6fl8LQTu9OHPDZfuolFqLuvC8ikWqREoNdyvz3KZcQ9YxtDzXAkRkRUwOUoGA8g+QjsRmf7my7aWFJB8pham2vN6TC/MoVFNbtS7SPnPqV8foHFsgXa2NyLhmT4JtfjIQ6FyBVAZF39eZFt5eWZSvBvHMwLXJ1LCmvQXUno1PmG/gcMeTY3e6bWxjIm553vs5sjEPYCP1SoQynctDDw/uhVg+jY5yr6o7L5D2tycxYAYUGwdsFO+nocWe7216D8s6uN+IkYE7P1UzYmJkhzassBMGqsToaax/hKuK6uDYbXLgOgFa2UkNYs6bTWs7kOnV3GD4gZ4hSBliQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ApFtuSabAR2Wr3Kv7MSlVN+iRFHsFFKHlrMn0u5dDA=;
 b=RtleNxfMlUR9h0/PjJIksbagb0JU8AFnHoBkts7pyY7RwCHm/gvTzrxMwJfTt5lNldKOD7pe8H0X1gevpRjDWGthZtX6VklCdPcJU2fujBvoRGQ7kGml1XCtNmeqHtPeKMVZQDTTAuqEt3POvj6aNxMzT6FOZNTVfp92+2GEeJOh/lKtyFP8+PILyVy1TckLdogoaE3ZoDWtJ/IDce/fNhflotLIUJXFrvZaLTs+ws7rZ3jMtm7rKeaSK5muJ5DKkq3pDR4lI2Jw8wQlPyMm5C8qI1HQfHDMdF4fAF4CFv2MmAKdjYA8KiWNWhBMZqtYt+kxvKTLGdh2eXkSrBZ0eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ApFtuSabAR2Wr3Kv7MSlVN+iRFHsFFKHlrMn0u5dDA=;
 b=mwcuLeQhzYJ7isBfaIftJYrgixbCy7IoGsPRqHhtaBvnsyZfQw2RKL1grSu8CPgzgzYAZrAwk5ZwmQiqQYyHj1iFMGuA+ScgbW0UWOC4NtiZDrkExh0ORK6KvrifrMy4yRJJkPPjWBTZqo0Bq/W0onnjz03EHag4IxNiH+1A/qc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5221.namprd12.prod.outlook.com (2603:10b6:208:30b::9)
 by BN8PR12MB2851.namprd12.prod.outlook.com (2603:10b6:408:9f::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Mon, 22 Aug
 2022 20:47:58 +0000
Received: from BL1PR12MB5221.namprd12.prod.outlook.com
 ([fe80::219f:8080:9607:b847]) by BL1PR12MB5221.namprd12.prod.outlook.com
 ([fe80::219f:8080:9607:b847%6]) with mapi id 15.20.5546.023; Mon, 22 Aug 2022
 20:47:58 +0000
Message-ID: <bef7f3e7-3383-8ef0-73b4-156e1bc57d94@amd.com>
Date:   Mon, 22 Aug 2022 15:47:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next 14/14] ptp: xgbe: convert to .adjfine and
 adjust_by_scaled_ppm
Content-Language: en-US
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "Cui, Dexuan" <decui@microsoft.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Thampi, Vivek" <vithampi@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Cai Huoqing <cai.huoqing@linux.dev>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Arnd Bergmann <arnd@arndb.de>
References: <20220818222742.1070935-1-jacob.e.keller@intel.com>
 <20220818222742.1070935-15-jacob.e.keller@intel.com>
 <334dc732-5a94-678f-56e8-df2fa9ee1035@amd.com>
 <CO1PR11MB5089E76BE2538C85827C0386D66C9@CO1PR11MB5089.namprd11.prod.outlook.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CO1PR11MB5089E76BE2538C85827C0386D66C9@CO1PR11MB5089.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P221CA0020.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::7) To BL1PR12MB5221.namprd12.prod.outlook.com
 (2603:10b6:208:30b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f1dce89-01f7-4c66-6677-08da847f98b7
X-MS-TrafficTypeDiagnostic: BN8PR12MB2851:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9K7tof6ecA2KT/ciqmz/+L3QT9YxgAgzTermzqYCZHp1MUZM85j/7htUV5GRz6Z0EK62S3QAfegODXrppotcvWno17+YNkRVmn3jrBdMvO8HrWofNwvI0foHR6gAAEDP6oTwu6fo1vDVYuOOwZyP9kNM0xuC4STbtwvhMJzh317bnQKO8AHJIrhOwKJaeC1D4fclV1UHvEtiSFFX4X6R0pMwTS3hdj4AuvKqfx/8du7nwi8IGisIxdjX4bqGBrfBF4BQ4XCcRBs4VyoW+jrMfoP/CAZSQMLeNJheczwtRyfQO4G4m9QRn2onB6nYM1yqnt/vq+SeNcN/CKf43R5R1mb6/UQ2QkdWRxuWmIYsRAqsTM2AoDAHfA9bTc8pRX5UfuMA9LaKo55f4+kHAhcWad+pZKsMp5X17w7k093QWN3xHfxujMHZYFqqWRTHJVnFSNQc8ACnHbqBQ/iKczMwwGIy9WfZXKYDtNIUzJB2N+tCpPV2cCX+QjM/0sdjzSr10j8GwWvjP5ruBYK5ifSTtj5lOHKuKlmkZOfWuYqtV+Pv2p+ALxcdqhllaVJV3bSqDjz8VpmS9QkAcWHeYvdeRXh6JpluiCgH4boub0G5i0n4bGoJcbtD0Mx6rsXQ5mDrpiA6zwW/xv+s2DjKuZuxtuWvF2HzsCENYHoSSKzZd42xEaaXl59Z1bhOc5iFu7Di/3WCv/Xmc8jVuRI4BrDU4izV2CJ0ON8ZA3yog0YRjHuuSNM8qFo8LnSNjLfFNA8w+c5Vr2xs0LQSdex4ItZn19URzORNCvSaYnIR7UjEZL3DLno+n42zxYBUcWfjIdHm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5221.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(136003)(396003)(346002)(83380400001)(86362001)(31696002)(38100700002)(316002)(45080400002)(54906003)(110136005)(7416002)(7406005)(5660300002)(8936002)(66946007)(66556008)(66476007)(8676002)(2906002)(4326008)(2616005)(186003)(41300700001)(26005)(478600001)(6486002)(53546011)(6666004)(6512007)(6506007)(31686004)(36756003)(142923001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RG1Ta09lenhKbXBXaVlLR2RoU3JoYjNiUXZ3Vi9PR2JTYVJuL1d2NGFMMkhj?=
 =?utf-8?B?SGhPdHRCTERHNTRYU0IzQS8zVzVTRUhHSjhhWG0yN01CY29jSXFHOEZpdHhz?=
 =?utf-8?B?L2Y0b3dzRjZJYTV6SVlIL3g3VWVTTDgyYlpyYWFHRTd6cDFaZ09jLzJVWTRQ?=
 =?utf-8?B?SnZUd0tQd3NMbEx0VWtrVFZVdG5mSzRCTjkzamtPNjZPaDZ6MGdZT2NvMit5?=
 =?utf-8?B?ZlU0WWpYS3B6YlhoaGp5QzZTYTRvKzZZMEFzdWZhdEVTSWExcThtTW5EQm4z?=
 =?utf-8?B?cnJhNHVKMGpkSEdTR1Y2UElya2Rhb0E3U1FyQmxueENKQ2F3dWZwYUlBVHQ0?=
 =?utf-8?B?Q1ZTRU9uRVpqZG9qRGxuNU9Henp3U0JqT28rZU9Gb3lZdTIxbE9oZkdEL1lB?=
 =?utf-8?B?VHlESGEvZG9GY3VSYlZBUUlaUFZNLyt3enBIWU9Sd3B6WVFRaVd5MVM4bjVt?=
 =?utf-8?B?MzJWTUN3VEhsQndlbU9LN0pwMEsxcElGUmY3c2NlcklRK0ZNN2U1ODhZSWZy?=
 =?utf-8?B?cGZGOTNmbXQ0TXhrYlgySzg4dmgvYlBLRVp2Sk42b0F5N3gwSEJ0cXVRckpL?=
 =?utf-8?B?dXV4eUw0eHZ3dzRvTTdZVUxnUDF5cDdsa0k2czV3ZGRHMmI0T2djSGRaRXY4?=
 =?utf-8?B?N2trUTNEcngxZ2VHZGdOWW96WFJ3T2ZTNGUwM215ek9TV1ZpSXNJMW9HbmMx?=
 =?utf-8?B?VE9nRnEwdkR3UEpjd2pwMVdwRnI4Z2ZLRHE2REJMclJDYVpxWExCcmVOZ1Vx?=
 =?utf-8?B?Q1NQKzhOMEtvZ2Ywc3A3WGhpazJRNHJoa2VIa2psQU1zNi9IazE4dHNtRytF?=
 =?utf-8?B?TVhRZUlvb0NUMlVkMGxmWE40NnE4VzRIWStHcVFFU2xuaHJFTGNpYjFTa2Fr?=
 =?utf-8?B?L2ZidDZ3Yk1RSWtiVDBya3VqNm54ZzJpTFZQSW1zd0VVQ2ZvMEV2SHRuOGdC?=
 =?utf-8?B?dEFxN1UxcGxmR01EbC96bVJ5ZzlYVUR5K25BY3laZDRRNUUrUnFOSWVKcmZG?=
 =?utf-8?B?cG9IQVVrR0p2d1BLSllIWEJsOHdWbldHdEJqcUZLN2doNzltRDZhN1pJQ2Vr?=
 =?utf-8?B?amtpb2xoNW10aXhXdFRJeE1MN0FrOFRsbVJueDNMTzRGNnFBcWg2YkxXUm1u?=
 =?utf-8?B?ejljZ3d1WHRNSThLRmZwVjlEa2tLMEJyUTFqalNqSEEraDZkanhEeWg3TVNO?=
 =?utf-8?B?UDUvN2owZDFpMHkzWEQ0RnpGS1U0M2pyRFJHYm1kSm5MenVReTlIR0FvKzV4?=
 =?utf-8?B?WUorbENwSDFESk5LUlEzK3lsQzNGK2lYR2FlTUxiV0diMXNMYURnWks1ODc0?=
 =?utf-8?B?Q3pKNW90aEVqdjNNZUZlQy9mU0pXQ05IUm9Sc1luZjIzLzJYaVhWMzZ2RkdU?=
 =?utf-8?B?MGxCVGNaWGRzYUQ1ZE1zNVhLSW5GcGg2QkRLZHpxcTV6QzIyemdWQ2lZeENm?=
 =?utf-8?B?UVBjUnpaZ3ZQOG1tVzlkdm9mUXNRVHhPL3hvYmNNOW5GRE9IY1hXai9NbmM5?=
 =?utf-8?B?WHBNRGNGU0pIK3JWL3lxYmxNbVU2NEZmd0wrVTZ2eEpIekdRU3ZzQ0FhT29Y?=
 =?utf-8?B?dUxqTnRjWE1NYmJlSnQ0YjgvU0o4cmFmYTFSN3BoY251RlU0YXFVSytwTGZ4?=
 =?utf-8?B?a2FEd2xraUhBU3JwVW45Q1VFY1JFTmtLc0FrVzJnTUh5NDhnQVZ4L1g4TXgy?=
 =?utf-8?B?cjhuZUZZaERSR3FZcm9kRE0yU2orclM1QnVBN0QyRndVbVJlVDlldDlIY3Jn?=
 =?utf-8?B?anQzZC9WVTFmbTAvSHllY1BXRVBIcmJDTmtXUmRCZ1Y5S1RIeDNkQ2RrMmtx?=
 =?utf-8?B?K1FZVUhubXEzU1IvMFNyRFlnUXNWcDVzWVhGQlhTbnB3cEMwWC9DeHZOL09D?=
 =?utf-8?B?d1NvVmRFaDBhZkN4N3F6d1ZZclBBTmpPRmhmeW5BZSttejc2U0svUldXY3I1?=
 =?utf-8?B?L3h4ck1SOXZkUXhkSjIvZkZYdW1iaWdzVWFxUDJQZklWRjRLamtRSzRmVmor?=
 =?utf-8?B?b0RXcTRqTmNXOWs4bVN3U3BSdzA1UUZVeFFJQkdlNXRoaG1VYWRQVWlrYkFH?=
 =?utf-8?B?dHpRUlMyaWo4em4zL3BKV3BKdlV2aUNJUWQ0NUIwMVlySWRLTm5BbENDdFha?=
 =?utf-8?Q?jr2BLW3ov/FLKWLFL3oyiOmBI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f1dce89-01f7-4c66-6677-08da847f98b7
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5221.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 20:47:58.7496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rHIpmrHsUIATAneVjSNxir6Bg5BXIhfmh8N/Sb6CtvMc+nckmm10V7TyNg+oHNBA7t5LZBA7m31OgWd8R4CLlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2851
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/22 16:04, Keller, Jacob E wrote:
>> -----Original Message-----
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>> Sent: Friday, August 19, 2022 9:05 AM
>> To: Keller, Jacob E <jacob.e.keller@intel.com>; netdev@vger.kernel.org
>> Cc: K. Y. Srinivasan <kys@microsoft.com>; Haiyang Zhang
>> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
>> Wei Liu <wei.liu@kernel.org>; Cui, Dexuan <decui@microsoft.com>; Shyam
>> Sundar S K <Shyam-sundar.S-k@amd.com>; David S. Miller
>> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub Kicinski
>> <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Siva Reddy Kallam
>> <siva.kallam@broadcom.com>; Prashant Sreedharan
>> <prashant@broadcom.com>; Michael Chan <mchan@broadcom.com>; Yisen
>> Zhuang <yisen.zhuang@huawei.com>; Salil Mehta <salil.mehta@huawei.com>;
>> Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
>> <anthony.l.nguyen@intel.com>; Tariq Toukan <tariqt@nvidia.com>; Saeed
>> Mahameed <saeedm@nvidia.com>; Leon Romanovsky <leon@kernel.org>;
>> Bryan Whitehead <bryan.whitehead@microchip.com>; Sergey Shtylyov
>> <s.shtylyov@omp.ru>; Giuseppe Cavallaro <peppe.cavallaro@st.com>;
>> Alexandre Torgue <alexandre.torgue@foss.st.com>; Jose Abreu
>> <joabreu@synopsys.com>; Maxime Coquelin <mcoquelin.stm32@gmail.com>;
>> Richard Cochran <richardcochran@gmail.com>; Thampi, Vivek
>> <vithampi@vmware.com>; VMware PV-Drivers Reviewers <pv-
>> drivers@vmware.com>; Jie Wang <wangjie125@huawei.com>; Guangbin Huang
>> <huangguangbin2@huawei.com>; Eran Ben Elisha <eranbe@nvidia.com>; Aya
>> Levin <ayal@nvidia.com>; Cai Huoqing <cai.huoqing@linux.dev>; Biju Das
>> <biju.das.jz@bp.renesas.com>; Lad Prabhakar <prabhakar.mahadev-
>> lad.rj@bp.renesas.com>; Phil Edworthy <phil.edworthy@renesas.com>; Jiasheng
>> Jiang <jiasheng@iscas.ac.cn>; Gustavo A. R. Silva <gustavoars@kernel.org>; Linus
>> Walleij <linus.walleij@linaro.org>; Wan Jiabing <wanjiabing@vivo.com>; Lv Ruyi
>> <lv.ruyi@zte.com.cn>; Arnd Bergmann <arnd@arndb.de>
>> Subject: Re: [net-next 14/14] ptp: xgbe: convert to .adjfine and
>> adjust_by_scaled_ppm
>>
>> On 8/18/22 17:27, Jacob Keller wrote:
>>> The xgbe implementation of .adjfreq is implemented in terms of a
>>> straight forward "base * ppb / 1 billion" calculation.
>>>
>>> Convert this driver to .adjfine and use adjust_by_scaled_ppm to calculate
>>> the new addend value.
>>>
>>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>>> Cc: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
>>> ---
>>>
>>> I do not have this hardware, and have only compile tested the change.
>>>
>>>    drivers/net/ethernet/amd/xgbe/xgbe-ptp.c | 20 ++++----------------
>>>    1 file changed, 4 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
>> b/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
>>> index d06d260cf1e2..7051bd7cf6dc 100644
>>> --- a/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
>>> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
>>> @@ -134,27 +134,15 @@ static u64 xgbe_cc_read(const struct cyclecounter
>> *cc)
>>>    	return nsec;
>>>    }
>>>
>>> -static int xgbe_adjfreq(struct ptp_clock_info *info, s32 delta)
>>> +static int xgbe_adjfine(struct ptp_clock_info *info, long scaled_ppm)
>>>    {
>>>    	struct xgbe_prv_data *pdata = container_of(info,
>>>    						   struct xgbe_prv_data,
>>>    						   ptp_clock_info);
>>>    	unsigned long flags;
>>> -	u64 adjust;
>>> -	u32 addend, diff;
>>> -	unsigned int neg_adjust = 0;
>>> +	u64 addend;
>>>
>>> -	if (delta < 0) {
>>> -		neg_adjust = 1;
>>> -		delta = -delta;
>>> -	}
>>> -
>>> -	adjust = pdata->tstamp_addend;
>>> -	adjust *= delta;
>>> -	diff = div_u64(adjust, 1000000000UL);
>>> -
>>> -	addend = (neg_adjust) ? pdata->tstamp_addend - diff :
>>> -				pdata->tstamp_addend + diff;
>>> +	addend = adjust_by_scaled_ppm(pdata->tstamp_addend, scaled_ppm);
>>
>> Since addend is now a u64, but the called function just afterwards,
>> xgbe_update_tstamp_addend(), expects an unsigned int, won't this generate
>> a compiler warning depending on the flags used?
>>
> 
> It doesn't seem to generate anything with W=1 or W=2 on my system. Its possible that the compiler can deduce that this won't overflow a u32?
> 
> We could add a check to ensure it doesn't overflow the u32 size?

As long as we don't see a warning, I'm ok with it.

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

Thanks,
Tom

> 
>> Thanks,
>> Tom
>>
>>>
>>>    	spin_lock_irqsave(&pdata->tstamp_lock, flags);
>>>
>>> @@ -235,7 +223,7 @@ void xgbe_ptp_register(struct xgbe_prv_data *pdata)
>>>    		 netdev_name(pdata->netdev));
>>>    	info->owner = THIS_MODULE;
>>>    	info->max_adj = pdata->ptpclk_rate;
>>> -	info->adjfreq = xgbe_adjfreq;
>>> +	info->adjfine = xgbe_adjfine;
>>>    	info->adjtime = xgbe_adjtime;
>>>    	info->gettime64 = xgbe_gettime;
>>>    	info->settime64 = xgbe_settime;
