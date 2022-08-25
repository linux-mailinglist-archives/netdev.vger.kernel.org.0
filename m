Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863215A08E0
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 08:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbiHYGc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 02:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiHYGc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 02:32:27 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2063.outbound.protection.outlook.com [40.107.212.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F429F8D9
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 23:32:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kbFqtlE98i5r/JqfoGLOvS7aNv0W/K4xKduaJsDVXrLp33Mmcpn1Gcq2phDviruXCNAOSEIM3w+zVQX2lFSSMmxGS++fATCexK5wcSaAZTi11GDkJjIlFdNPjctEJiqw9RwB6ig6RMXs/Ft2YjsMY6/Y594VYqdF6rQo6oAxNcPOE+l1C5zJdWbTSw9Ohk4seGq7KlSl6YgTcl1uSU1uG8T9TBvR/R6IB09+fryZsDjLGUDNB2yYQT8piRpP2hCLZfxxShKIaEvCpGYfp3axLB1rmjvJ9EIPylsQtHOWGUVXw9SdBEl03U7NFEkx5pWnL+dz/i9zk0mVrhOOj6BMVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zK/OuJ6ncx6CpX3gRZObBD7uuM7zQEDa3ebyTmwJAvw=;
 b=Q7W7jquA58FawtpN6O3WgggXuk8Yfj9/IocvLzIWwuP/sR+o04gCyHNOmxG04FZk9dLBUwruxg9oYkPea453XrfPv4u7UYWhFJm+r/4RdNnLjcziMQ4oxGCfPIJIxgqkfD9wyJTNExcQxXQW67o4fR4lmnWyCago/rFosD6x0ixacXXMAJ1DK85BBGrDbZ41b7pvtHIAs8o2bmX8YJy2UhQG7eoLNFN9oQBG7KPjYZ1c6jOZo8xNMKPX6/OvTbMX10gfsoAzXCeRmW/nS3hZJhjiZTB/nhAcxMTEt5p9yte4kvXDqwiF4/MynWHT8dkyqHRAqnH9uQuk3nqPQJRVAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zK/OuJ6ncx6CpX3gRZObBD7uuM7zQEDa3ebyTmwJAvw=;
 b=IaUIyYoyuV80p+219Ncgjbixlpu1JQmjJS0I1Jp46hT//lRsrzvyquG5DCJu7/j0UpErWFTCEfJwD0k5H+eeHlLH5U9+28sJjsM8744hkcc91u/SCkqDR0ikLedt5UAg1GU8kIpwVpewU304O1m2wbOXDkCs2AKscT+zhzG4E7Ecx7232/scQjilzMnEvWZ20aQk/pe2gz7IfoYeFdAm5WNqtR3BYAZxbb422IhwKTkcCYDFqRkgBmoSWhlsV/PUEeVkGXMs4lAoZHGy1wRiVOSNa5cMaFN2vA/5bnB9wUQxR6dK1Cwo1rhMt9qFdYx4lDG2UZoEQ3HdvLAL1rPplg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 CH0PR12MB5155.namprd12.prod.outlook.com (2603:10b6:610:ba::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15; Thu, 25 Aug 2022 06:32:24 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::2caa:b525:f495:8a58]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::2caa:b525:f495:8a58%9]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 06:32:24 +0000
Message-ID: <2d5daf18-f300-6c90-0220-f624afb5a030@nvidia.com>
Date:   Thu, 25 Aug 2022 09:31:51 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [net-next 09/14] ptp: mlx5: convert to .adjfine and
 adjust_by_scaled_ppm
Content-Language: en-US
From:   Gal Pressman <gal@nvidia.com>
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
References: <20220818222742.1070935-1-jacob.e.keller@intel.com>
 <20220818222742.1070935-10-jacob.e.keller@intel.com>
 <ae6132bc-7b7c-8f31-7854-8e451f57cdc7@nvidia.com>
In-Reply-To: <ae6132bc-7b7c-8f31-7854-8e451f57cdc7@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0234.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::23) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65e8203f-df21-4049-01d8-08da86639204
X-MS-TrafficTypeDiagnostic: CH0PR12MB5155:EE_
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m2eCfSJUZZWvky+rLKsDmnVvD+43btyPS6ISYvgqRABOVnG90Ynw2E1dTdnPbMul0GuMWVPwmGFjo02uOPAnTekSk0sPjvErC124r1IPsEMzz0rs+xvCtWCR4OsouSLqYjPpuJv3DIbxojiN96BdW02N+6QnW3gagyyEFPP9EN9bb/+JOvhGU/5zzxeMdXpdK/KV0S0UzRDFiBD63NDxv5rJye0nc+xYf8nEZaDcFe0X7+2qetxIZSZho0SKDGYZXcWGS9dLK2sS7wSs9PUtold3p/5VugV0or4CFto6qv1mg0fat/T9FCrYQxCqdptg7h7AFxgCzM+OWT6EJ10GfjTKmFvtO5Oo3XdDB2v2WetY21sURhUQFe4/0ggtZOho2lBZwmXeNwQseqtIpFxU8K68UpO+Fn06UxEEDNfvdyuxOGYsZDzjIFLyqlyHglQ6tTxis+fcFMxLJdk7ON6+mpZjx6M97NVq64Q6B9KijcOI4CGRNZz8yRJxucZAEjRjEJZb0s2mVuILPvdAWB9w6PkwsnfYLzqKyRDKZucgMIRl5VYVRb1AYrrKdTGB8Qt9SRDd/1nMzRaXkQN0hz239TrtUTIQx5GpJXYqM/rq4SMG+ldDa+E2PbtnbGtyuyxqiqmN7quPXGpI6hY+s0NAwhCpGSnI9/7mhU13Z25eHtl/qAh6Pu+kJOH2Ys1f8GTgMOOWGKdPSnSOrkv8BRVysnAAIOGNdIwrzDrrkNiCdtga8YN4D9Bx0FQ/VQZTebhk5vgx9UfBz1Sez1JErX+iQxNyI60gGCiIUplgRLdDxqcFUbr1df49iMFcvEHLXSk7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(2616005)(186003)(26005)(107886003)(6512007)(41300700001)(6506007)(86362001)(53546011)(6486002)(31696002)(478600001)(38100700002)(83380400001)(66556008)(6666004)(66476007)(8676002)(4326008)(66946007)(5660300002)(54906003)(316002)(8936002)(2906002)(7416002)(7406005)(36756003)(31686004)(142923001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekF4dXZqT0xzRHlDWW5QR1ZVNkVMUmlJNDh4SHJjUHFQSTNnNHQrQVh4cENU?=
 =?utf-8?B?Q2tFYjNUSTVHUjFVMEJSYURmNjVvZHQzdngxUzJKUVcvVE9vVENLZTJNeDVk?=
 =?utf-8?B?bjMzemRLSnBuc3FtOXJTYlhZOE01dGNta1EvbGh3V2tCdHFtWnBvTStSRVVS?=
 =?utf-8?B?amZDMjBPaUgrZU5yNk5vNDZsR3BjSEh5cVVrKzJuOUwxbDcrR2w4c1VpWFQ0?=
 =?utf-8?B?bk5GeSs2di90R1YwUTBXdHROcnQxVnI3eVN4V1k0ZGZENUN6ZVJPSW5VWjFp?=
 =?utf-8?B?VVhTR2hjRlZCaGp6WkJ6STFNdDV6YTk4YVBOWUxvajg0OEFFY2wwdHRoV0Q3?=
 =?utf-8?B?ejNFS3A3T2RKVm1NYVpsVmYxTmpDU20zaEVpSjlJZnBuWVJNOGhabDMreXBu?=
 =?utf-8?B?VHd2N28wSnE2N2FkNlNDWnBsbU5LTmFXQUIxOEMwVkVQR2h5QStTMmJyQlZN?=
 =?utf-8?B?TDZLZVNPemJpcGJLYjlnOHhzdTc5RXVVWlpmb3BnaHJmeWwwaTk1T3Fpandn?=
 =?utf-8?B?ZnJwaW9RTUdnandWbzE1b045ZmxJcnlCaStsU3lvM08zSFRKcndWcEN4MkRT?=
 =?utf-8?B?SlJLVTZyc2xqbHh5cWV1Qm9GOWpjZEE2QVJjWXdTQjA4K3ZwM2tWTWFqRSsw?=
 =?utf-8?B?dzhVY1Zmb2hFQkMybHNJTWVGWW5ST2lIUHo3UEovZCtlLzEzaHE1U3hGaXRH?=
 =?utf-8?B?NlRzekg2bGNPMFI4clRtUXY5THh4SWlYMVhmUVdXYkt2OGhCQktmcWJkRURm?=
 =?utf-8?B?ZzBHSmxhbHJPSnB4TlVtajFsWkxTZktwZWpKa1N4NURNWDB3ZjlWS0d6M0or?=
 =?utf-8?B?V2NYV3dPdlVhNXFNTk9xSWxObHhCK1BEajNyQzhDMnVORGR1Wlk4UVNGYWtt?=
 =?utf-8?B?S0V4aHhUR1NCb2E3Y3QrTUw0akUwY0NjbHpXa0lDdXd3ZnBlYkg5bFZzMVc5?=
 =?utf-8?B?d1lCN3liSnBTNEEwcWx4NXJrT05ZeTlPN0lQZkI5RlFmYzhwS0Zhai9ROVZV?=
 =?utf-8?B?RXc5Y2JjdTdnZnJqekwzV1g0RlU2TTRiNHB1RnQ1Y0VrWC9RNWVJeWF2emlO?=
 =?utf-8?B?V0hEVzNZM0RwQ0picTg5ODRrUTZ5ejdoTytJcWhVVjltbnZQODZaQmJUR2Ru?=
 =?utf-8?B?OStvcm5oTFV6Y2dITkNJcjRPcjhVVW93Z2VaQU5XVE1nV293UWlweGlzUGdW?=
 =?utf-8?B?SzdRZ1BkNXNSYjYvYk5yREw5TEtoTlVxa21VZjZGcWc4K3lCb2RhbkN2d3l0?=
 =?utf-8?B?K0diNk9jUnlZWkVUZXdWazYvRW82YytOWjVZc0RVOS9xWGFrR2NIc284VUpO?=
 =?utf-8?B?Nk50aVRoYVBheFBaZ1ZIOWE2eWRjak9pK1R6NklrNHRERXpNSE9qWWFrUjlq?=
 =?utf-8?B?L1A0b0tpL09ROVQxNDl3UWQvckh3akw5ZHY3Q2hYVU5rWjQ4YUFsRjV3UlBP?=
 =?utf-8?B?NG1DSi9QWjcwcGVNS0t4b1p1VFh6c1B2M0xMNGZCVG1oMklpR0lheU9OZm82?=
 =?utf-8?B?YU9rZHdXYnV5WmMzdzAreWJKY0c0NXUvU0NOQ1hJRW52dHczOTJLYWh5Smx4?=
 =?utf-8?B?SnBNdnFCTmtCc0hPZEJoajdhVmVrTWNGLytCZlIyZkg4eldjZkVCdjVJMWVa?=
 =?utf-8?B?NUlvNmxxMHlpbGEyV0xhY2syVkpFV3BTTkdTWWRjcnRCUzVSbVpVZE45N3Jw?=
 =?utf-8?B?WmRnUVRISXBIVTlWNlc3Rmw0eGUyazBBS0ttMVZqS2cxNkhuemdhZEk1eG1D?=
 =?utf-8?B?bmpxZy9vS0N0TjhhS0JCdWExd2UyVGpncU5EeWsxNmt2b2ttNzlRYjB4SnhD?=
 =?utf-8?B?T20yTzRVUEhiVU9xZUxxYytWTGNmNXEvMHFSNjd1M1lPWkFlV09LRkVIUExZ?=
 =?utf-8?B?aVFxY3NoYm5oWnZzcTVmcENFT3Q2KzI4UEc4Qi8vWlA3KzBUWURZbkZqRU4r?=
 =?utf-8?B?L0J3UG1VdGU1eE5jMm1OZENySzVpVzJ1ZExaUlFxU0JoMzV4YngxUHdOUEZ4?=
 =?utf-8?B?YW5xaEtHeDd6M2J3R0RMSTM4dzgvWkVaZW1tNFpJOXFwMDNBZVM4OGM3akZK?=
 =?utf-8?B?SjVzM0JTbG8yV2I1RTcyK041YVpSMEIxSndDZWs4TWhSZk9Wb3QwbU5VVEhx?=
 =?utf-8?Q?BIAhdHdUFXvWLMqPGOU4zkmzk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65e8203f-df21-4049-01d8-08da86639204
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 06:32:23.9091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cVcz/9yfJ6tTJMekQB5lwVrQg34eftm5Kbd18W+jhdktg095cYo/FWKN4fDZKhSA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5155
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/08/2022 18:30, Gal Pressman wrote:
> On 19/08/2022 01:27, Jacob Keller wrote:
>> The mlx5 implementation of .adjfreq is implemented in terms of a
>> straight forward "base * ppb / 1 billion" calculation.
>>
>> Convert this to the .adjfine interface and use adjust_by_scaled_ppm for the
>> calculation  of the new mult value.
>>
>> Note that the mlx5_ptp_adjfreq_real_time function expects input in terms of
>> ppb, so use the scaled_ppm_to_ppb to convert before passing to this
>> function.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> Cc: Saeed Mahameed <saeedm@nvidia.com>
>> Cc: Leon Romanovsky <leon@kernel.org>
>> Cc: Aya Levin <ayal@nvidia.com>
>> ---
>>
>> I do not have this hardware, and have only compile tested the change.
>>
>>  .../ethernet/mellanox/mlx5/core/lib/clock.c   | 22 +++++--------------
>>  1 file changed, 6 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
>> index 91e806c1aa21..34871ab659d9 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
>> @@ -330,35 +330,25 @@ static int mlx5_ptp_adjfreq_real_time(struct mlx5_core_dev *mdev, s32 freq)
>>  	return mlx5_set_mtutc(mdev, in, sizeof(in));
>>  }
>>  
>> -static int mlx5_ptp_adjfreq(struct ptp_clock_info *ptp, s32 delta)
>> +static int mlx5_ptp_adjfine(struct ptp_clock_info *ptp, long delta)
> Small nit, please rename delta to scaled_ppm.
> I'll try to get this tested in our regression soon.

Tested-by: Shirly Ohnona <shirlyo@nvidia.com>
