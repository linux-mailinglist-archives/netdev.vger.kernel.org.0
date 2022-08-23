Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B4259EA4B
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbiHWRmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiHWRmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:42:14 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DCF83F02
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 08:30:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kkQrpXhaFSymTgYOsfz7xvmwaTAmgtPNJQvmJXKmJP8cmI9ygBZvnB8B3wEIiExltcoNhhZ/swAYC5DgYkVAcDU52jCxMvCczYUpWN9JJYVIvyB/LxhCOAv8LA/lUNcPi7i85AjS8hWRqvltqrVLwkgja1SQ9aOX9WCgmgSnJ9GYgNJGhYzZGwAuZHMyQRLqPLRpzbEXzblCd67tAYFABFWJH35W61SEuNYDjOTDgBwy9yU08XuhZixF+AjhA82SEkA1TZZk6yb+5snxRc+6VyFUlaVk0z+WgVWKkeq6SJ7FcKpq1b7VMDZWCla5ddpxkiuxpB2FxbA+UGmIwh7uHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8YRpvHfBDi6/LTsKA0bYTwt+7We36dPbkvMf4MDBBrY=;
 b=Qm7XrILAuySJrUvwvfL/rKLw6OtadOVrfopukr6ZOrgTsdvxggfYpcpsjpUPVVtYxvL7GAboQKJ/GZToSni3NtEGKiGlDzRTESpHQgbMA0PUzpje9TWCZg+HK2VdDDqqocgAFE/o+2zMIBflV4Hm3SHRAsfMjUq9HNMOogwDTq4e9KYA76N19jHSx83UJJdSCS6PpEOWM98e4vlFFfm4/2upvWyqoVo/Z3gtk1v1cYwpRIPgoEaD3LnaCOsfjhbwOfX7zxc7TULUACqMX8LOfiemBD8ilAuirECi0GeXTIx9zrR9i0Yd86sv0oNddniY/BHFXeHEdcYJIlVWb+I4+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8YRpvHfBDi6/LTsKA0bYTwt+7We36dPbkvMf4MDBBrY=;
 b=YrXsM/VC09J3GvD4YMYnoeEUYkfXiNZJl5C5ECKxlXqO5GRHlHm9zVVX4g9r9XYs5Qk5zWOtucmH8LTfgFXq2eBWWs5ini7iq0rsEwlWuEAdYkXa42C7tdyj5nzw83MUGcaUC5IKQs2syP/H8PlF2RQkRaTf8FFVeDIarqtPua6GPoIYK7330oOZstuorLV4FFidKyAIGadSG3rUSPtRBOyrRmP+3XPg3rhLSSAhai3wf0NsAsHQkDWdKUrHsjJU1whVIGwAvr6ZyKRKwDI4mhyV2OYVYDZxnclv/HjEL9xlJ5ek0aWzhYlmhgLGqFRtd9QPf1dxFD+6gv7NEQdDuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 SN6PR12MB4768.namprd12.prod.outlook.com (2603:10b6:805:e8::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.21; Tue, 23 Aug 2022 15:30:54 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::2caa:b525:f495:8a58]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::2caa:b525:f495:8a58%8]) with mapi id 15.20.5546.022; Tue, 23 Aug 2022
 15:30:54 +0000
Message-ID: <ae6132bc-7b7c-8f31-7854-8e451f57cdc7@nvidia.com>
Date:   Tue, 23 Aug 2022 18:30:39 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [net-next 09/14] ptp: mlx5: convert to .adjfine and
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
        Lv Ruyi <lv.ruyi@zte.com.cn>, Arnd Bergmann <arnd@arndb.de>
References: <20220818222742.1070935-1-jacob.e.keller@intel.com>
 <20220818222742.1070935-10-jacob.e.keller@intel.com>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220818222742.1070935-10-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0004.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::9) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00d5021f-bc72-4dd6-3413-08da851c77cd
X-MS-TrafficTypeDiagnostic: SN6PR12MB4768:EE_
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BsJQI9fhrDeLD4qGdS9PB0eGALkHn6+cW3rhpdwH1ACNT7DcF/KEkj+xmhHdRkUMMvpC4sJeFzWOBVvOP4oOZhfjw1ZD2gksRih/BQNEdVKGv2fGD01A2QHj9QD1QcHhMzdwI6dSRnxtFey/YTwrqBdMbrGFGHhdsvqAgtB7VP5Kx8F0VEYGB6O087EnFzSIU7d456qiIOJ/xp+8JEt4K6Mlxl9Jay1Y2CXXXYYjelsLDB1g0+XV9beodZrRcnHPYpBrOxNZ7WflyP2j4G7risYjgOSzgS0DTH+JdWZTP3gU6bikGfAUhwyrIlGDHsJy4ekrXUGHeiJf0j/UyMSBOooY9gNufIlL3xpksXggI6WVdbwz9zBb2K6tKDKRSuZvg/CUOBlUntq0w4S3Wi2D+9H+PYwCfTZh3A5D0mYKftPEttAPsymDguHTrcSYFmgLccfP6Mbgo5aRhcBT9w8/9fiedOS4x+r4fTo7O6QYGZVzgmCJ6FgYVTktgG0zqHp59NaWrQ92oQRJWNMXb0nTiekK9DY1SR7L3o29Kjp5bXWO2s51RItLwDg6CVG0iAb9NjfPa31Kjrdivru+z9ZWC/D0W/zrVYe78Xwuzj93NgfJXYNlGmqFe1Ie5gUyBBgIkAtp0LnYTdxeCjoxkiyBKT9MhIWrYbu4ZVzC2PY4b1MjNpxgpKnGU0wxxnOgHorFmv+HnByDYiFZhwl8BwmL0BSvFyFNd1BwRpP0EkEeYljUDm36cdqkWm92XuxVklBlpw6xrEzOh8aski+x3g9V+1mVne2l9XtTl6qzOBZH6kq3uzyCCYVassZVlbxj0a7AALFebjNCl0giR245avrP5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(376002)(136003)(366004)(41300700001)(5660300002)(478600001)(7416002)(6486002)(8936002)(31696002)(53546011)(2906002)(26005)(6512007)(6506007)(6666004)(86362001)(7406005)(38100700002)(186003)(2616005)(83380400001)(31686004)(316002)(4326008)(66946007)(8676002)(66556008)(66476007)(54906003)(36756003)(142923001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3hjbHlhZGk3WCswS04wQnlCeDVvaFFZOHpPeDZvRXhJWUZzQ24wY2hxcmJa?=
 =?utf-8?B?TGNtbmIvUTFPRTdkVnNWallUalRJUlZUMCsvZkJhdnRBMEhaWUFuUGZYVFA1?=
 =?utf-8?B?dWF0S0lRMFp0STNxSlI1WEV0K1BJSnRDb3RNVmJ0U3ZzTkE4by9KWmh1ZE9u?=
 =?utf-8?B?ZGxHRW53c2FIVHdUdWlxSGtFaC8zcUNXTHRERmowT3krZFgwR3RFeVAxbWJw?=
 =?utf-8?B?UDhIQTU4SVVtZGlvanZtZ1lyMGhnK2FISXVqbWt2Tmp5S2h2cFE1Y0FENm1a?=
 =?utf-8?B?M0loNnpjQjcvbWVoQzdlREVBT3RGdlRHZzFvbnppSGk0TlRady9wZXQzNlZ3?=
 =?utf-8?B?VU1pT1BDa3NUNlg5RE9hcmlkMDhQSDZMOEZKU2hCZ0pNMzI0a3RKSTc2SklT?=
 =?utf-8?B?RytQMVlaeUkrT1lTeXZBd1RzQXo2T2lBSjdCYUU2STYvUlhNamlqNjN5SWda?=
 =?utf-8?B?aXN2a3VKdFpNOE9ZSHNFek5jRmFnR1JWMklJY1NRaDdJS1hWTkNhWFBkVElK?=
 =?utf-8?B?ZHhpdVluZnRMV1ErVFNFQlVvc3pHNkRtM3JZTWxwa1lYa3BidTh6cHpTc3h1?=
 =?utf-8?B?Y0tlWnJYeHc2RXVMQm9QS01Xd2hkSHJJb00vbnVQMFlPNGhlR09wdjJFTUp4?=
 =?utf-8?B?ZmkzOFV1aDdrTDZiQmovdUtRN2hIUkYyUUtnVmMyTUd3VkxkNVFaREZ3cHgr?=
 =?utf-8?B?VnZlNXIzZmY5dllpSW1US212M2tOankwZW14c2RwOHVBQTNLb3gyMkg2anJa?=
 =?utf-8?B?ZVhBeXdTYWFPVFIxdUdZSnAwaitsVEFmcHVBZzNBK2s5OHR4WEZlVzVSenZy?=
 =?utf-8?B?MUplZUVOSHVsR1NZUlQybVMvOTJseEFwd3VZUmloNmp3NWVUQUliTHBXMU94?=
 =?utf-8?B?ZkNvY0pvbFBvd0szdldJOEUzaWNBM2JGb2RtRzNGY1lNZVF0aUhhT0lKaW5u?=
 =?utf-8?B?KytNb2lDTHRMa2k0dE9vc1lUMCtQSXFkQjBVT0hRMkdYUzNSbldWR2VvWm1R?=
 =?utf-8?B?bU5uNWpBeWw2cUJvaVBBYXFNblNvdElpSTJwdlNoRmJXck9Ra0pMQkd3TlZ3?=
 =?utf-8?B?ZGhnalhxb3JzNURrNzEySS9sdURZZE9BNTNrSkUwdXBzQnpmc3FPRSs2VjRY?=
 =?utf-8?B?SXc2YkdrWGs1S1BCZ1RPU01nMmxPZFFGTjRaeTlDQWt3S1ByaFBzZGlFTDk5?=
 =?utf-8?B?N3Y5QmNpaEZHOEp2WVduNFh1a1I3MTdscERoVE9sd3ZaRElOOHFlN0tvU0JW?=
 =?utf-8?B?eitVK1NsQi8xRTdVb0Q2aEwzdWtxR1hiQ3FZbThxS0RBcWExZ2VTM1B2Vi9O?=
 =?utf-8?B?RGFSak5mS1pUVUplbS9GbGZnUkJndGFYSjRLaXBZUkhpaXpiTXFJeWUraW1z?=
 =?utf-8?B?Szh3REk3MXRYdWo3TGJjaGZ3VmtlWi93RXhidDd6U3lvSk9WSno4QlN3THlV?=
 =?utf-8?B?OEFjOEg1aEJhaWl4Y01JQUpPYitkbGRFSEJEcnkzMllLTCsvMlo4Y3hTaUoz?=
 =?utf-8?B?dTR6bDR4UGhycDB5cUhyc1RwUVBMN2ZETUlkZ3FoNDJyUnMxS3BBSmt1dXlK?=
 =?utf-8?B?UHJhL0gwQlc2dzRBRW5waXMxeG9oMHo1eWs2V3dsUFNLNXdTOUFmSFUvV1NZ?=
 =?utf-8?B?YW9hbjdrMlVlTFczMzAxWk5QRzIwdDVQZURrVEhZV2N6ak1JajVheitnaGN3?=
 =?utf-8?B?bzk5Z1V3ZWZWajh2ZFZzQ0VydWhUM1A3RC90TUhUOWJBWXBjajYzMkxLdmsv?=
 =?utf-8?B?eHh6OGhpbVJVK3RpTUk1bFJObkluancwYVpUZHZVa3hUanF3US9Zb0JNSnR4?=
 =?utf-8?B?SXdLejZRNjJsZjN6eGNBQVlFWW14dWlDeDRYUmZtMkZSQ0s1UXBqUjBUTUJp?=
 =?utf-8?B?b3B2bThOdit4TDdrK21UeHUrSkx3aXcyTERBOEFheGVYZ3BTZVhZUSttZWJO?=
 =?utf-8?B?aUNpMUNGMVJXWVRES0NCcFZWVmNCZ2t1RTRnVkFGTVN1MkV4ZU10cWhybE5z?=
 =?utf-8?B?eUJzRlBNdE1wWGUyZGdJVGVvanNaK0x4cnU1S0s2Umk0Q3IrWUl0eC9RaUgw?=
 =?utf-8?B?MU9reHg3YzB5bWd1eWMzQXQ2djVvdkwxeDUrbGlWbjlGckZRY3lXS2RNbE4r?=
 =?utf-8?Q?eLTWRhMRUKMRH74VEL3icON2i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00d5021f-bc72-4dd6-3413-08da851c77cd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 15:30:54.5830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qY3f6YlSpLEqON6xOvWVvEYW4X8wrlzyf2zmxYTvXBR8pNhfqgrTW68O4cQcMhqM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4768
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/2022 01:27, Jacob Keller wrote:
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
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Aya Levin <ayal@nvidia.com>
> ---
>
> I do not have this hardware, and have only compile tested the change.
>
>  .../ethernet/mellanox/mlx5/core/lib/clock.c   | 22 +++++--------------
>  1 file changed, 6 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
> index 91e806c1aa21..34871ab659d9 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
> @@ -330,35 +330,25 @@ static int mlx5_ptp_adjfreq_real_time(struct mlx5_core_dev *mdev, s32 freq)
>  	return mlx5_set_mtutc(mdev, in, sizeof(in));
>  }
>  
> -static int mlx5_ptp_adjfreq(struct ptp_clock_info *ptp, s32 delta)
> +static int mlx5_ptp_adjfine(struct ptp_clock_info *ptp, long delta)

Small nit, please rename delta to scaled_ppm.
I'll try to get this tested in our regression soon.
