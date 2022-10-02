Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF725F22D8
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 13:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiJBLPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 07:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiJBLPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 07:15:52 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C87F27DCD
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 04:15:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vf72oX0s123tyLRaU0o2iu1+Gsu3R62e3DHZ4/A/8Y/6lcSuYneesPwS8oy/+7TND4/0TY08hTdMolARf/CUeG74UHg2ASoO8gOlVZIn/VGjq1gXiHF0TWQ7I1gXDO2TfyVY/9ehynAmsPoXp7eVvkBf2/zIK5c4Jmc4B/WdLLxEJ9pYb8ybN29DTHYdQzEPcKv78Q1fMyciOc6fZhxhd8qXMW0Wj78dJCPZEzxx56fFCAPRLTaVpy9eTXa4oMF1z/NcwzRHqxdNgLqymKFmqSxzHb2lMU9kuBdVdPj8o8YEXsHPchNGLUk4sqpfowwRolKb+laHZrl5zIAarOOlGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W7FPLH7SxcZXDXWCvv0gGhveZBx6Fy+TGbj6FUb0haY=;
 b=a4T/BQSliJ1WoBD6FooQfLX9Y1DVIUS3zomyIXp/BUtUX8a1Q2T2HXIC0tyQiirL0huQ0OJzzFNcSuufS7Bfpb3VKMdERONdxobDBfBT2wakECCN2AsSSSed38ocCmTH8LAQfqfK39xgFWDxN7pwzuU3pcnNf04rrYZfwbt+t7jTaIGnzOSkMFDUarihRoA+JrYMehpXjGCMvE+uBbV05ji1GV21Afsrb2rCLv4OukXfp+hObmHZ3TqHiLGqTeoIgl04QPF5O+7uFFx6+IesPQCdM1RUzHvLTKm6CtOqe9uotzKFAQBmdTkKEMsjuJI8RMEFceD6+n2pX+fVJdG4Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7FPLH7SxcZXDXWCvv0gGhveZBx6Fy+TGbj6FUb0haY=;
 b=ASwA54/knQ1zIFVGze9B8RZJ+sTo2Lm/mYPVhvUEPjylPWFbx1zg5fLFQZPKRQZhMw4zJALHq36mrXnkKPNm28Ks2XP7yfrKYMBM6Qny97UqW1v0It8q74eBQ1nSI4WOjomOaBPH3TVwzxeG7rN8yejH3kJyWrRDKFElPlCjKMp+I5fFsSbd8qX1JauH2X69yF58RHbIpaQIrVvIQFL32Nk3geq3zU+llVneQH3PmNX41ocIu7O7Ddg4GvSjHs8TBLhNSlZMKvdXC9SRbYIE/PYnrS+2ZU9fZNeIKh9uw5J3qaCWDTrMPEWliYqrB+Q3qzaRRhNgXR7+LmAH7RPdfg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 PH0PR12MB5484.namprd12.prod.outlook.com (2603:10b6:510:eb::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.23; Sun, 2 Oct 2022 11:15:49 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c45:abca:a9fc:6fd7]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c45:abca:a9fc:6fd7%5]) with mapi id 15.20.5676.020; Sun, 2 Oct 2022
 11:15:48 +0000
Message-ID: <9ca30e77-e02a-da8a-4eca-38e523c95914@nvidia.com>
Date:   Sun, 2 Oct 2022 14:15:33 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [net-next v2 5/9] ptp: mlx5: convert to .adjfine and
 adjust_by_scaled_ppm
Content-Language: en-US
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
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
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
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
        Vivek Thampi <vithampi@vmware.com>,
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
        Lv Ruyi <lv.ruyi@zte.com.cn>, Arnd Bergmann <arnd@arndb.de>,
        Shirly Ohnona <shirlyo@nvidia.com>
References: <20220930204851.1910059-1-jacob.e.keller@intel.com>
 <20220930204851.1910059-6-jacob.e.keller@intel.com>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220930204851.1910059-6-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR01CA0023.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:540::23) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|PH0PR12MB5484:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f18464a-85b6-4545-831c-08daa4677556
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cG3KYrbE62Zhcb/AeTn1fN7CrHBAVE6UaCwlcQmE8pB+clhrNRsfFdpFKPSXSgDSa2XcCr5aXDjh5FSbQwrVf4Mm32FUZ2YwDeVV29obnk+req3+Bvjx5Zuvq60W//6JAlXXRBGbTZOVb8ZUh3f9Lc5UsPQes+l7wgYu3wgOTkNi1HLWEBF5LkUC2NggIxc+rlt2D349PrWCX0EFbfsoV4sUDXDePzim35EqRYfkadUg8hzDPcgiF3YUHmxMjaP8C/dT6luBulIU+wS8BwijwE+2YukXv1k3N5U841p+XSgbVNHghIlm3xCOHxcJCi/yEDfbnQ8XFUqS8xlQt7DBZtE8iE9WUFTk5ZixDl0kKOChqBS4RjO27xR7IKpAW1++oU9En/EpQU7ggB2XmLNcIifkVhTTF023JdAq7dsV/8coQHV8fptnW3VfsyLpvLBGpfq2Pq+l/Ju1DeBVJH9q/rUF8hTdD9ANOzmYsS3RMhSnvmio9DagpFlqezQk9528y0Z4ERcbhVZnFJvS1uyqm+XlQ/4arwT0rIUgI6uVbR+1dWn1yi56y0Baw7q3zrtJl1aK2EiqOxQEoba3EdC6PSirMGBsIZcq4zWg6fPRza5/3iJQRF6G1evwLq28f41JwPElXLiyTqRKqhfDu1/hQeSi6hAfRnV931nzSOFg2IZYa6M8pSbfI8y9D+tiJxYhL9fZ/Pf/uwuKmcsUKXQ/UP36xTVzE2G44E/KPnm4mCBnqPizRah8DjSgQ5CuL3t+QEvX6W9xQ3gDKWT9nwUJDq3wW7x/T0AfvVqTtgjW5UMRSmQpfVHTQgMpTvyJhFWy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(451199015)(478600001)(6486002)(38100700002)(36756003)(26005)(2906002)(8936002)(2616005)(107886003)(5660300002)(6666004)(7406005)(316002)(53546011)(7416002)(6506007)(186003)(31696002)(31686004)(66476007)(66556008)(6512007)(41300700001)(4744005)(54906003)(4326008)(8676002)(86362001)(66946007)(142923001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OGdTcEZkNFFWZnQ5RDhFeWZ1WjAvUFVlRGRyQno0ZkMzeFI2TmoxMEpDUEJI?=
 =?utf-8?B?ZVI4RWpnN2EvQXBnTUhxOGh2UlNlaHJoZ2lIZjJmY3k3NGxtbFNMLysvL285?=
 =?utf-8?B?QU9CSjQyeVdLelpCakZndzF6U1hJNTUwZ3ZIWFI0c1FXczlNU3I0ZzJ5b1BB?=
 =?utf-8?B?ZjN4WlJOR1ppQjdkUm5HNllDYTFZaERhdDlMUkhtcFBvVmNhRHBydDJjZm5Z?=
 =?utf-8?B?cnJoNmRqY1lzeGNMVmJPUlBzbENFNW9XWllXRVo0dGNNZXdsRGhTUlJpMHYz?=
 =?utf-8?B?a2R5OExyUUpMMVFaVUdyWHprK2RQQkh5V3YrditwOStRRHJXcXRuV3B5UGQr?=
 =?utf-8?B?WGhPbEZsVDVSL3pBcG1jTGt2bHR1NjhGc2xlV3NXcVN6d0VIdTRyekFxYVlE?=
 =?utf-8?B?TVY5R1c2VDRHdVd4VlozWXhkQU1RV09VRG5seW04ZjQydWc2c1IrNWx0ZTFP?=
 =?utf-8?B?cGkvWTcrQ203ampBYmtnZjQ4bloxRWQ1TFVLZDArMmRsN3ZNUXRCOHJFb3E2?=
 =?utf-8?B?a1RhZVRBbTBnV0N6MlI5cTVFZDd0U0w3M09hSVZYWEVTOUxxckk2OFJicXpZ?=
 =?utf-8?B?SElDa0RjbDE4Q0VJZDBmdTV2UUdYdUxidHhheHVsNHNpYnAvaTR1T1VLcU5k?=
 =?utf-8?B?eGF4Mit3RVhVdndTbzZiUjZ2ems0QUpkTDF0UWNON1FsYmhHZmkwbWpNSnUr?=
 =?utf-8?B?MUtQZ0hBVlpTWHluT2dFK3hzeHBNTGRoMGpwLzRCd3g5Y0pMenM0S0V5YXlk?=
 =?utf-8?B?WWo4MEdUamJINEttYVI1cURsVDJZSGhNZ1pScjNFWVg5czRyM2xiNDJQZ2VP?=
 =?utf-8?B?UStSMElTL0FNd2VndStCaEE5R1M0WHBZeWZoNUJqaEpSLzZYSnJ0T2pJdWJQ?=
 =?utf-8?B?SDhYcHNUSE41RDlZT2I4WDRTSm5lQUJjbmNXTmNwZExYRFBOaUVyWTU4aEQ2?=
 =?utf-8?B?WnNJWUJHcmtWZ1ZCQXh3MEQ1aHl6dHZWMFJZUXM0MkRuQkVvVE9NZUV0dG5O?=
 =?utf-8?B?V1F1N3pYS25IZGtQWE5MaHZ1VTRQaG04dG4xcmFpS2Y3R1ZrUnhvb1RFczBM?=
 =?utf-8?B?WnRmd0lMMCtydWdwQm1aZHRQZmpGaHpCdkJJOWtLK3pPNmZmOUZaMlhaclBh?=
 =?utf-8?B?QUd6TU1qVC9OQWR6QWtyWFk1ZDJSUFZDaDRvOU5CdWZKUk9xMng3TTRhd09m?=
 =?utf-8?B?TzRQejFUeVJ4U3M1eUtNVHBmSlVjVDVXZ0s2UTBybWk0QWRLOW9FV2dxQkVM?=
 =?utf-8?B?VDByR1R3YkxzZ0xJRS9nVVIwWG1jTVVESUp0aGVibktrZ093cTJxeEV6dHdI?=
 =?utf-8?B?SHVNUmR0MHpnazRPeDFpTmdHd3dXRkpyY0s1T2FpeitURE5kSUN4R2R3eTQz?=
 =?utf-8?B?TmpzQzBvdTZPUGVZMGpoVmdlQ0toSHF3NThiNnVZejA3VWlBcjE2c1pZSGVM?=
 =?utf-8?B?U080UzhXSUtmTFNWRVhUakVXNzUrWEdlZ2NKcHpGODYwVEp1NzhIWGhqbFFU?=
 =?utf-8?B?eTFYbFduZnQxaGdhZ29FUkRiWlFBUUZhYk85R0ovajVEZjBpWFNEb0todEs4?=
 =?utf-8?B?UEFYcCs4OHlFTk1mN1VMV2xPOEIveVJTVWFJRnFqTmNDSzBXMG9yd3ZaSzNh?=
 =?utf-8?B?MEpGbWdQRktneWwzRTBqN3JtSjEvUHNLWXk1M0wwc2I4aG9OTTVQK3ZkdHNk?=
 =?utf-8?B?TGVXRWhKb1NFNGJJY1lOKy9uN25aeE51TzgwVEVjTzRDYlNIYjZrZ3NLMWNs?=
 =?utf-8?B?bEwvQVdBcWJXalVaOGg0UjFjOHF0WHFGME9RU1hUbnhPQUFobmFCcFhhbDMw?=
 =?utf-8?B?NHhnY2plMjdJdFhJSGRpUG5ucHNVY0dMZHR1dU1RWTRabUdlWmVlRjN2S0w5?=
 =?utf-8?B?bVFaQnJwdGhKWVJ6VHFxa0YwYU9MWVZrb3crOFhLWFBNRDRHL0Y5Y3dpbno4?=
 =?utf-8?B?elU0NEY3UjBpZGNYSVYxd3FLanFkazhTZGJUSGxXUVFFMmZyTjRPOGxDUEkx?=
 =?utf-8?B?VlVVeGpoWXJuRjA3ZWRjd08wR2tvelNOT3N6N3lBcGMycjRZZW4rdi81Ny9B?=
 =?utf-8?B?M0FLYy8xbnVzb0VjTkhtNHFzM0xWbTRsQWZrTVJZRjhRQ0Z1Z3A3R0o5OGZK?=
 =?utf-8?Q?EHuMazn8DfcdF3UGxckOpcNH1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f18464a-85b6-4545-831c-08daa4677556
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2022 11:15:48.5880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o4CkvI2wfkAxOlHjJhzP/8YY0mZrissO5JGE3whlre6Q0inb9E8Jjgq6GJhKo799
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5484
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/09/2022 23:48, Jacob Keller wrote:
> The mlx5 implementation of .adjfreq is implemented in terms of a
> straight forward "base * ppb / 1 billion" calculation.
>
> Convert this to the .adjfine interface and use adjust_by_scaled_ppm for the
> calculation  of the new mult value.
>
> Note that the mlx5_ptp_adjfreq_real_time function expects input in terms of
> ppb, so use the scaled_ppm_to_ppb to convert before passing to this
> function.
>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Shirly Ohnona <shirlyo@nvidia.com>
> Cc: Gal Pressman <gal@nvidia.com>
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Aya Levin <ayal@nvidia.com>

Looks great, thanks for the patch Jacob!
