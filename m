Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F97759A21C
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 18:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352933AbiHSQcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 12:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353419AbiHSQbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 12:31:37 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::61b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA56711E908
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 09:05:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OB/aawu6FRzG3HhLTF2Md3eDHFsDguLslDCZ5DZnUSwWV/dw0pBpGCOcF+0lxuO6xfcbJVsso7KOasEZNwWiPGg2nXFd43qLmphtNUkf4nOP5mTOGi45cE9CbU5TGqeUWpKWtDS3ZJMb3+LdNJdQMfCfeBNNTc/OHBOR8wGqaZzRrOiEMY1fPszstrPRuQfop93jIJPNitVjKey46f2k9dKBx4O3TN+UBYgSRq2aFO5nW1cLWyvXiFRwDCtoLNiorI03ekxyukaloyj1nB5q4erN/m6t8ZFao3hU+Ee+1II/GTBYs6amMd5TXN3zQk6wTYSjIWJdU0zJdQwoAdlr5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bsCGoZXBoB6IZXXYp3vteNy1+1oRuPJJ83a3NTbavUw=;
 b=NydJ1F9sCUhFf/XiEEhoOXRGC6syQezKt+8c1TGFJpL53CxcQbQo+I4uo9G6KMKy0Z3jfVcUBvWC2eMSTYOPfl8RZeHsZ2lmvxfBqbCIT8h3tG8YSbt0mLwDePY/iAs3T2CnK6DteqYlvsv+c2SFWsDy1wtY1WIJBgVL+9/FN37OiB48UKHHHsjws3I0Ps7FmkxJEJ11QZ+FcRIZKOHI2FV0rZbAMkHJTjVNWI5CldED/MDxIIGL+txx1KOOg+/s76pBuaBVhVM3peBsme+s+W/kprM5Y4tBuHW9SVPKGgItKkrI0dhdnmVwnh26NeBOyx8A8+FEEG09wiaQjodaXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bsCGoZXBoB6IZXXYp3vteNy1+1oRuPJJ83a3NTbavUw=;
 b=aVBP/EeoNEydN3cRRph9MES7kgNw8DX9Uf2g4V+CMGszc+VCmqnXcZ4c8b7p27Nw0wQeSK+fw/VJp0/2wJDIoSkEo6ukYL36SHtCXzZgmiXBHzIZ64MQwJ1ijhQqh2YqSBUoyMc2COQg2WLSYD/dCabLKxw4NLhH9qjl2jzqvzQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CH2PR12MB3765.namprd12.prod.outlook.com (2603:10b6:610:25::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Fri, 19 Aug
 2022 16:05:29 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1dac:1301:78a3:c0d0]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1dac:1301:78a3:c0d0%4]) with mapi id 15.20.5546.019; Fri, 19 Aug 2022
 16:05:29 +0000
Message-ID: <334dc732-5a94-678f-56e8-df2fa9ee1035@amd.com>
Date:   Fri, 19 Aug 2022 11:05:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next 14/14] ptp: xgbe: convert to .adjfine and
 adjust_by_scaled_ppm
Content-Language: en-US
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
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
 <20220818222742.1070935-15-jacob.e.keller@intel.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20220818222742.1070935-15-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0021.namprd05.prod.outlook.com
 (2603:10b6:803:40::34) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ff630c3-6bcd-424a-043f-08da81fca2fd
X-MS-TrafficTypeDiagnostic: CH2PR12MB3765:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HVQiFiFi7axqbhFEIsI0yq4g2e2NLzKebi/4/suYsGP1cHTsS9mu42mw01Iqvujq276ecMEdkBURB/fGrOIuACeR8rTDGPt6V8GE1uL2Yl9i+1YM45+VNmeKz/pIipnLIOfwnoWXuMp6sx2fjdYggFPyGSzX2dfMlSHrMwhhHh4hSRNGZsotdAEuuQKr8kq1PpC3C3Gn4xiswKtQLJXktc/jwksCHnxgs/5BQp1Z35zGH9zhIiPsJPV2kbyuPvjCyWf71lobYx8LdJKDGtV1f9T48Mox1V29atae0hi7nxDCI6ZeBNgvgobFfmP9RtquEGeCyoM+lpcb1Z0eOCkkovqk+uNVa+IpZez3oFvRV3l7Vh5Uu8AlewXF0E5QdopacWptKusouUOIucpt7dGwIPBhApkQYh/1kkoTJgKpVjyhB0QtWdnDi923Rep5kwFNHIOsi82kcOqIn5CBhYY9Kn0uE3Ueu5P5HNLzO/gC5MC31TLRMpt7Y/d1YgOi1uBxQ8nXgm3lGKqAoYh+DMW8+nh7yY3JvGD0KQhNEIDLmmbJUmmWmJleFzeShyg9wXOIo4t5VSUSYALMD21OeKvfIHrz01I3+T0XGmOafEflvfY7lW3CnUUpkoSXL6xjqStQJxASTYHUfXXPs2a2HeI9LA26lR82NOtmiWqfOJw8+Mkm5lyWtilLpxAdocvpQDM5GQAmTTKrAexY1UuZ2ucmcC+/C6MPDZpbgz3hKxmuOsDuYS+shI2OkIKercKfoYSMmiq84Y9c39S8kQdTD74SsmCkIt0c8jgHtRkBlAKZ8ips7rax5e8UFlPviB4CCs+q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(2906002)(478600001)(8936002)(41300700001)(7406005)(6506007)(6486002)(7416002)(53546011)(6512007)(6666004)(26005)(54906003)(8676002)(66556008)(316002)(66476007)(4326008)(36756003)(31696002)(66946007)(38100700002)(86362001)(5660300002)(31686004)(83380400001)(2616005)(186003)(142923001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTRaRmR2WkZFM05SajF5cjhwSS9XRXdyTWFqR0F6ZEVtRmJKZG9CK2dtY0JX?=
 =?utf-8?B?SHB0Y1NoZGFsMldCUnpXNXUvTXhvQmdFenZ4Mm1WQXJBSUN2NDlNcjNGOU1U?=
 =?utf-8?B?YzFTS3dpWmsybk93Mk5MbkRSZHF3ZWZDU2pPMUxRS2lDWVJHR0Qvdkd6RWpt?=
 =?utf-8?B?cHd3RjIvM0tqTXMyUlhCUTNwUkJPcmR2L2djdnlsd2R6ZDRHamJPOWFhUXNV?=
 =?utf-8?B?K283SzRWOVU3cVUxVjJkc0Y5R1RtYS9hQ1ZRbmxld3MxeFZFRjBha2tLVEM0?=
 =?utf-8?B?MG1sUm1sTUlCR21ueHVyRUsvdTFjR056eWIrK0RpWVRwNmJjdnEzTFg2dFo1?=
 =?utf-8?B?WXVNV0xHV3R3TXBIY3NUWWdTT2FnYllDcjJOVUZQdytjVTluQ2dTQUtFZUVa?=
 =?utf-8?B?STRiWTR4d0tIWnRGSGRMT3JQVU50QmppRDAvczExWFFxMEUzWW94MmZGQk1N?=
 =?utf-8?B?WGluUnJFNlI1eHlNWWdKYkgrVmpsakxSRE56VzBkLzF0MjVGcFVqYVZrc1Nq?=
 =?utf-8?B?YXd0ZWxVRk55M1Y0Zm5pY2FRamVSamhXdjdBNXpFVTZWM2VTcEtBTHFVSGwy?=
 =?utf-8?B?bExBMjkxdVFsREEvOG93NklYTmhaeHhZK2NOaHV3bGVRNk0zUUVrU3pQcitY?=
 =?utf-8?B?cHlVbUdRY0liY0VNT2NzczRFbGpabUEvWEE1S2tvNHRQYmN2alh3WWUzVllN?=
 =?utf-8?B?S3lsN1hYblE1QXRieGJ0Q1hRM09uNkxwT2NsYzZuUG1DNU90bi9LRzVtT0gx?=
 =?utf-8?B?OTR2a2hGOG52Q0hVYXY0cHhNVGV4TENJVkhXdFFnWHJURERqaW0wRm1jUUF0?=
 =?utf-8?B?SENQWmxjWWx6MERwV1BiZnBvZHZmbjBwOEF6NjBEYkJES1NBV242Ymp2Q05v?=
 =?utf-8?B?ajJ5UDkzcjBwc1dXK1hVSTArc0JMZU80OU01VjRMMGFTbDVnQ0FRRDdveUZr?=
 =?utf-8?B?cjcyZlhGMEhJdWc1R0psOE9pOU5iaWRkTWh5UFgxUmN3aVZTTEgvTTFSeEJL?=
 =?utf-8?B?VmpPWVBBOE51dHRLd2ZlVW1iVExVL1MvMlEzeERQNUxxM2lRMlUvV3lLTGVz?=
 =?utf-8?B?REtTT1ZYazBWYVZkSDVXNUd0Q3NISktKZzh5Qzdnb1E4MTZnMDk0b0puL1hW?=
 =?utf-8?B?Y3pIZldSTTBGZzlRREFHblh3YmZNd0J0WVV2QUxMbWQ2WnlvbnBFZG8vTHZp?=
 =?utf-8?B?TVBkb01hZ2RqUDUzWWRYQjhwcDJHenBQQmF6MjZ6WVVVS1czRTh3dnNKYWVt?=
 =?utf-8?B?a2V3MXRMQnpLUmtCSjRrNWQrbVd4MlMzSFB0UzA0K2crRUlXZk0vdnFIYkE5?=
 =?utf-8?B?WktQWG1hNG9tWWZNY1NZbDJJOUVvOVdreHJERVJjd0txNmoxM2piYVJiSzgw?=
 =?utf-8?B?WXlFNVFXUHh4WkxHR0xKZ3NwbjhDMjBQaXZGblFxVC8vZ3hoYmVQWXBEbVJo?=
 =?utf-8?B?ekIzeVB6ZXRCSmR5c2JMSGZQbG1qMFhUcTZ3RTY1R0JyV0thVXVlalhINEVZ?=
 =?utf-8?B?MnBTS1hMRGVDeWZqSnRMR0c2WEdLNmh6UDlmeXBuZkYwVUs5ZjBKcWl4TUdH?=
 =?utf-8?B?WStnRnRtbFljRG5xeFlZRGNkUjIzOFF1cHFDY04rQXp3VGhVU2I5cmxVZm9G?=
 =?utf-8?B?Ky96S0V5aW1xb2hKNEkyUXVIc0xTM3J2eC9DcUJYS3dDQ0E2RmFoUWpob1ds?=
 =?utf-8?B?NkFnN0Zxak9iQmFrejF1NFAxM2M5cUkvbHdvTU1BUUVWcnRKeUU3RWMvZnIz?=
 =?utf-8?B?K0YxSnJtUFVFVmtTTFFuMkJDamExSmF6Z3JEelQ2RHVxY1hhdGFVZFgzMCt3?=
 =?utf-8?B?L2RxVGk0Z0d3VWdDbVVrWmdhdWdPZ1pianNqUk83Y0JkeWI0bnRxZWM4SHll?=
 =?utf-8?B?aTJldFBzSGV2OFZGV1dQQXV1QjVaTnRCY3drcVgyQUNHcUdKRGE2OWY2Ritj?=
 =?utf-8?B?Skl4L1YwM0xlOWFsakVFdUJXMzcyTXowaG53RlVQL3MwT1gvZ2UrUVplL1Ez?=
 =?utf-8?B?Vkx6aWk2eS9RODVZTCtDWXBKUTRjOVJvemxEVUdRK1hlclVVUW1hOHVabkxT?=
 =?utf-8?B?dkxITDdqZFE4cVE5anIxZmhxeWRYTDBKZUxDQVorY0lpQ0ZqbWtlZEFBK1Vk?=
 =?utf-8?Q?b+SwmjWsEwiMY1+G6nYv73ZSb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ff630c3-6bcd-424a-043f-08da81fca2fd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 16:05:29.4922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4mBVIgJddnH/6UurugSwY0pdW0oMphJn52DfJl5gDmBMor4dYQG+acsjmEjSaW8JxLNMggdnPTJhlUrkPRvMyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3765
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/22 17:27, Jacob Keller wrote:
> The xgbe implementation of .adjfreq is implemented in terms of a
> straight forward "base * ppb / 1 billion" calculation.
> 
> Convert this driver to .adjfine and use adjust_by_scaled_ppm to calculate
> the new addend value.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> ---
> 
> I do not have this hardware, and have only compile tested the change.
> 
>   drivers/net/ethernet/amd/xgbe/xgbe-ptp.c | 20 ++++----------------
>   1 file changed, 4 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c b/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
> index d06d260cf1e2..7051bd7cf6dc 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
> @@ -134,27 +134,15 @@ static u64 xgbe_cc_read(const struct cyclecounter *cc)
>   	return nsec;
>   }
>   
> -static int xgbe_adjfreq(struct ptp_clock_info *info, s32 delta)
> +static int xgbe_adjfine(struct ptp_clock_info *info, long scaled_ppm)
>   {
>   	struct xgbe_prv_data *pdata = container_of(info,
>   						   struct xgbe_prv_data,
>   						   ptp_clock_info);
>   	unsigned long flags;
> -	u64 adjust;
> -	u32 addend, diff;
> -	unsigned int neg_adjust = 0;
> +	u64 addend;
>   
> -	if (delta < 0) {
> -		neg_adjust = 1;
> -		delta = -delta;
> -	}
> -
> -	adjust = pdata->tstamp_addend;
> -	adjust *= delta;
> -	diff = div_u64(adjust, 1000000000UL);
> -
> -	addend = (neg_adjust) ? pdata->tstamp_addend - diff :
> -				pdata->tstamp_addend + diff;
> +	addend = adjust_by_scaled_ppm(pdata->tstamp_addend, scaled_ppm);

Since addend is now a u64, but the called function just afterwards, 
xgbe_update_tstamp_addend(), expects an unsigned int, won't this generate 
a compiler warning depending on the flags used?

Thanks,
Tom

>   
>   	spin_lock_irqsave(&pdata->tstamp_lock, flags);
>   
> @@ -235,7 +223,7 @@ void xgbe_ptp_register(struct xgbe_prv_data *pdata)
>   		 netdev_name(pdata->netdev));
>   	info->owner = THIS_MODULE;
>   	info->max_adj = pdata->ptpclk_rate;
> -	info->adjfreq = xgbe_adjfreq;
> +	info->adjfine = xgbe_adjfine;
>   	info->adjtime = xgbe_adjtime;
>   	info->gettime64 = xgbe_gettime;
>   	info->settime64 = xgbe_settime;
