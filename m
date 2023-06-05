Return-Path: <netdev+bounces-8117-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E77E4722CAC
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:32:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CB152813A8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6A7979DE;
	Mon,  5 Jun 2023 16:32:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FF522631
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 16:32:08 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0183B1704
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:31:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NbqsmVX+bO/sAW1cIMsJW9Wsy52TInsH8Dm9ZR5fmq9i0P2LMX1hyxNCgm9w4iK0H6Rs0QOfcuaJAqjuOsT+H/fHRRuTmtyle7RKvV3nQFcRYA6ZDhHMbjs386hzrZ1pmzVZzg4kST7iMGeLjaZ+fDqB+QeLaSwmTJqAW75fyTGsjzpXBXsxaLGj0ufNAHIc3/dTDFNyq9KkdFGIVqB268D1bnlFSFcJt2SzCcJdBH9uwoWS2FT221ry4EYFbh8925XoowiIbffBNK+lgAFQtHkfzEiogJQj7MNLk0si3rdfShN6UeX01ZqAIoiO5/FMbu3WaKZyaXMbayx6XELmaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hzNmFcmkk8JsA9OHQymIOkrv0bXOPu43k3XxPhkDL0w=;
 b=IPwV9e2ka+UoIvJ8/AurHMfj2GFZZ9rLoYSdXYydN9iF2SRPeTwIOusUH95YwpTPsOxM0Ifm9yc7l0OLMcHw/lvHBAdlSLVx8y7yW8+WGscr9L6GhiKmyskawnXB2XqbG44ickSoMqejxjKyYxo62bSr6bu9YPJ0q3BBLCXZDqiCm0Injt2DyRhqajnjnfA1t6pyo1/DSojECYVaT8PD6h5QXLKP4TxoU0R32Bb/Hj3xXXKzxNGqnXmmT6PRMc+F7YGtmq9kCXQ5UzrHs88in08XrOomewbBAZA8ANi4M1IozxYKIljolzCdBO2m3NVFoYmCxSFyrgcw+vnyPyrM5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hzNmFcmkk8JsA9OHQymIOkrv0bXOPu43k3XxPhkDL0w=;
 b=bkLuKM5nKKH1icX1mo4i1WFZoClxAXdPktzokfQe3fHXNYcbuq7S7SwVGtcqFUlhgwYLD9e1cqKeDz2QaIK+YXI+IBA6R23T+DWTkSV6ofKwkH3zbFMqVAR9oG90yjBsq1QrL+kV2vAnpIfou5MpLT5hCzJu4Kgdz8qVZl3jTE8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH7PR12MB5997.namprd12.prod.outlook.com (2603:10b6:510:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 16:31:12 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::611f:a9a7:c228:c89a]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::611f:a9a7:c228:c89a%6]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 16:31:11 +0000
Message-ID: <fcd06157-bbef-d4cc-57f6-40db823004f9@amd.com>
Date: Mon, 5 Jun 2023 09:31:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH net-next] ionic: add support for ethtool extended stat
 link_down_count
Content-Language: en-US
To: Siddharth Vadapalli <s-vadapalli@ti.com>, netdev@vger.kernel.org,
 davem@davemloft.net, kuba@kernel.org
Cc: brett.creeley@amd.com, drivers@pensando.io,
 Nitya Sunkad <nitya.sunkad@amd.com>
References: <20230602173252.35711-1-shannon.nelson@amd.com>
 <f92bb09a-9c08-0145-eb32-ae81d210586f@ti.com>
From: Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <f92bb09a-9c08-0145-eb32-ae81d210586f@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0056.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::33) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH7PR12MB5997:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ac78fd1-ebc6-4192-31a3-08db65e2461b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9nwEd/AbggwxTbcEnHMgC6OZpPwS9bRXHk2Tb9Ji3QjVs/N0q/lrkHgeRKzLjaWV+xF2tqXgUfXl2yJEoHM2z1KUWcWz98ML6SKWmrHhG0iEZonuDHtVujcXnR5VlPvQHH0tBYPLTFUWXh5/YTkqzxdCdYl7rkF0EQAioNrhP7jTjR8TtGkVDQ0goODwPIGK3hR+/JTOTaYgqXmb9xZeTl9o2isFrsS4M9M+81x6+klXV44cu6riKmICa/9m8Hcd03Mnys5SINsBLa0dP3JmUtGat97G3+7SAw+z/EjtUlvxWdST8hrFlqF3XpACsZekbb/EkMuljklA0hbFg6PJi+mGfdiwtbFIcnBWzfBUcQo/+K3pRwDAHj3PHGk4ikZZVk17tWkJ1+Sdhn7yg3nJPVI4ObOFA0jvMC4lTHEwqzsmTloOXd/BXRtyBXhegZRR3AqWAB8AvKONXNCuWHmLly2tpp6tb/bRo06R/PqU2sgxB0KJoi1/sc1+MoSMHu/yVF08WDeKppK1vg1s+Zh0VoAVTYaqEyWgSlvw6XzX96PoC147IPYFMqxQpwVeaAr4k5AvyIN9zwS2ibHwqOorg43e8LIL+fff/6fglWc5FHg1bU6ID78s+HZcxHaID26QLwtLjuPOhrb9jTeHk5Swxw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(366004)(39860400002)(346002)(396003)(451199021)(6506007)(26005)(6512007)(53546011)(36756003)(83380400001)(31696002)(86362001)(38100700002)(186003)(2616005)(5660300002)(44832011)(2906002)(478600001)(316002)(41300700001)(4326008)(66946007)(66556008)(66476007)(31686004)(8936002)(8676002)(6666004)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Zk0vVzIxMjhORDhZK2czUytkYVIzM1pIK1hsYnc3cE5lOFgrbDRESXpWaE0v?=
 =?utf-8?B?WVA1TUtOVUhoRlNWYys3QTJaZ1dQQWdCK1d6YTJXT3cwKzhPRmVYeHBEVnBU?=
 =?utf-8?B?MTFvbnlqTGZtZHM1RUwwTzZ0dnFXeThvdXZNU0hSdXN1VlBwL0U2WUFJMkJp?=
 =?utf-8?B?NDJ5SVhmZzAveEJwdDRnM3NwRzJPMDBBamIvZHdOWUxYVUN4U3NKWit6SlJD?=
 =?utf-8?B?NDh4VCtFUFp2YUk3djZydDYrQW16c3ZFRG1ZQWJKK1BzR2NaNnJteHV6TlA5?=
 =?utf-8?B?N1FPbENGby9pYzQ2ZldlREt0c09VN3Z3QmEyd05NQkRXNmxNSDJxVitSem1m?=
 =?utf-8?B?Tis2VXRWS2xTL3ViaTFIckc0b250ZFVzNzZXTlFJSnVhRGJhVmx3cXU4T1lE?=
 =?utf-8?B?dk90ZnJBRGh2bjZyOUJkZTM5V0t3QzBSUTNYM2pTVVBsTmgvbWFrMXhHSVZ5?=
 =?utf-8?B?Wkg3QllCdkhLTjNkN0N1a0NIdXdib3R2WkxUSjYxemdjNit0YVgwTUx4VENq?=
 =?utf-8?B?K1huSlowcGxsQU4yL21LYWNld1I1OGJzS3lLZmQzQ3pDV2VMUldYQUxzNG9v?=
 =?utf-8?B?Wk9GR1JtR0d3Vk95UHpHRjdmemtpbzZuVXZGYUFqbEdDLzVUaDI0b1RlaVY0?=
 =?utf-8?B?QXR0UEtjQjMxSlFKb01hNHBtRkVJMlY4Um1oZ3FrVmlBSW9RR3AwT0N3ZGpG?=
 =?utf-8?B?eWNudy82SVNqRHJ6TEVlTmkwWmw5bngvb3RlL3FNQ3psYktLc1ZGMXlOamxV?=
 =?utf-8?B?aWJGTW5vdjY3TDNqSThCUDZFNGk2cFlLZmM3R1ZzbFRQK1duK2IwRmlRdmFM?=
 =?utf-8?B?cGg0V2loSGR6V0RHNXlxZFE4ZWhKNUNtemZRdGhZaldXRzllNElHYmJaWnEr?=
 =?utf-8?B?cnZjRlBVV1UwY0xlZGQzcjdJYzJxNUhOU3o1ejFURmJJWHUwRUlDb09DclFZ?=
 =?utf-8?B?OG9CbWgvMzlRcXBGUWFNanhSaHBtNFpGQTR2UWQ2YTl2YTJ1YW9aT2h1UUdF?=
 =?utf-8?B?Nlp0eUJ2eDN2ZXBFM2FWVmxzdDVWVkI5ZVhhMWlaNlpSbnkxRWlNT01GWUt3?=
 =?utf-8?B?R2FGeVdFLzZHK1YwaHE0dzZZb0UwNEI0VFZDSHI1eEhIeWdnV3hVZVY3QitW?=
 =?utf-8?B?NE9wMFVDbElZb0M0TitTL0lNaS9sRWF0K3A1VlNKQ1V2NEpHUWQ2Q005Zld5?=
 =?utf-8?B?Z2Q5TGhZZitGSDRtWjhHSXVKQjZudlY3QW9xaEFzVVkyeU9qb3Y2TGtyUVlG?=
 =?utf-8?B?dGN6MkVDVmN0dlBvOHI4VGRlRFZpWWlBMXVvakdNZFNJcUZKdGdpTlFXOFFW?=
 =?utf-8?B?UEwwbnF3ZHJuQzdDYThWTnVNeXZEcDlKVGZlQ1FlcnJ2ZGdYZTFJbEFpb0Fr?=
 =?utf-8?B?eW5hcVBySWt4QzZLUlBRZ1QxTFJmSGE1NU82aVpibENQTUk5OHY1OGNVZXFk?=
 =?utf-8?B?MnJTVU9CYmNYc3MwZTl1Qm9OQ203a2NBK3Y4TnltVm81OGNKbXlJOXM3OVpx?=
 =?utf-8?B?cTBIVHRUbS9JN0VqOWEyWERnWVNIcmZPNXJPTi9BMDJGT2JMSDhDK3dtL0dR?=
 =?utf-8?B?ZGt3bjhEYi9uREFiamVTOUFRcEErUHg3c2NXa3NYUHRIWDh1Y25jRm0rNHE4?=
 =?utf-8?B?K2tlWDh6WXoxVHdvM0F5Mk82eHg4STA2NUV3QURmU2FwMEhPWDNGRzZSTkVI?=
 =?utf-8?B?eTVwVFh4cXpUWWhVcVlhalBsa1RacG9NVzJsdlFTSkpmUGtZbEpnOWJWRkdS?=
 =?utf-8?B?YkRWSTd5K1lUcnBNWWFwUkxHZC9SNjVLTjJWUkdrdjhFWWhmV1p4ZjhCYmZC?=
 =?utf-8?B?MGt6c1gvTklDY0V1c3JtQ1E5RTBtcy83NGxKeEVFVjFSM1FsY1VYWFJ0dGtz?=
 =?utf-8?B?bU9Qai9uZVZuMVpkVUtyd0NWWGJHSWxRUUFpeG9MZXg0V1JFcG4vUnlEVkNo?=
 =?utf-8?B?NHpHbWNTSDVDQUFiVTNWK1R3ZjFTS2hmTE9zYTdjS3E3VGQ5Y1hRaWlqVVhQ?=
 =?utf-8?B?Ymg3M1JrVEtOOHRKYWI5TkxJN3R2RmdNUGxBcTBVdVhNTk9BRitwcjJkaWZa?=
 =?utf-8?B?M0FhRXV4bS9aVkhvU3V5ZnNwUmlBbDV2a0xiaFcxQUhrNDlRR0VySUFzT3M1?=
 =?utf-8?Q?p+J+LUHPPZ6w/l8m3ZPLt29ia?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ac78fd1-ebc6-4192-31a3-08db65e2461b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 16:31:11.7631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5bjzw5tRPbPBE/hfBjwQCY3Dk8fxf0/BVDrc5vQ5eln0PltKnhTJC1nTbXpWqc3EUEOaNK21eFS22K200VS1EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5997
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/2/23 11:11 PM, Siddharth Vadapalli wrote:
> On 02-06-2023 23:02, Shannon Nelson wrote:
>> From: Nitya Sunkad <nitya.sunkad@amd.com>
>>
>> Following the example of 9a0f830f8026 ("ethtool: linkstate: add a statistic
>> for PHY down events"), added support for link down events.
> 
> s/added/add. >
>>
>> Added callback ionic_get_link_ext_stats to ionic_ethtool.c to support
> 
> s/Added/Add >
>> link_down_count, a property of netdev that gets incremented every time
>> the device link goes down.
> 
> Please use imperative mood when writing commit messages.

We'll get these fixed up in a re-spin.

> Also, I think it is a good practice to Cc all the email IDs generated by
> ./scripts/get_maintainer.pl.

Thanks, I'll keep that in mind.

sln

> 
>>
>> Run ethtool -I <devname> to display the device link down count.
>>
>> Signed-off-by: Nitya Sunkad <nitya.sunkad@amd.com>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> 
> Apart from my comments above, the patch looks good to me.
> 
> Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> 
>> ---
>>   drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 9 +++++++++
>>   drivers/net/ethernet/pensando/ionic/ionic_lif.c     | 1 +
>>   drivers/net/ethernet/pensando/ionic/ionic_lif.h     | 1 +
>>   3 files changed, 11 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
>> index 9b2b96fa36af..4c527a06e7d9 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
>> @@ -104,6 +104,14 @@ static void ionic_get_regs(struct net_device *netdev, struct ethtool_regs *regs,
>>        memcpy_fromio(p + offset, lif->ionic->idev.dev_cmd_regs->words, size);
>>   }
>>
>> +static void ionic_get_link_ext_stats(struct net_device *netdev,
>> +                                  struct ethtool_link_ext_stats *stats)
>> +{
>> +     struct ionic_lif *lif = netdev_priv(netdev);
>> +
>> +     stats->link_down_events = lif->link_down_count;
>> +}
>> +
>>   static int ionic_get_link_ksettings(struct net_device *netdev,
>>                                    struct ethtool_link_ksettings *ks)
>>   {
>> @@ -1074,6 +1082,7 @@ static const struct ethtool_ops ionic_ethtool_ops = {
>>        .get_regs_len           = ionic_get_regs_len,
>>        .get_regs               = ionic_get_regs,
>>        .get_link               = ethtool_op_get_link,
>> +     .get_link_ext_stats     = ionic_get_link_ext_stats,
>>        .get_link_ksettings     = ionic_get_link_ksettings,
>>        .set_link_ksettings     = ionic_set_link_ksettings,
>>        .get_coalesce           = ionic_get_coalesce,
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> index 957027e546b3..6ccc1ea91992 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> @@ -168,6 +168,7 @@ static void ionic_link_status_check(struct ionic_lif *lif)
>>                }
>>        } else {
>>                if (netif_carrier_ok(netdev)) {
>> +                     lif->link_down_count++;
>>                        netdev_info(netdev, "Link down\n");
>>                        netif_carrier_off(netdev);
>>                }
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
>> index c9c4c46d5a16..fd2ea670e7d8 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
>> @@ -201,6 +201,7 @@ struct ionic_lif {
>>        u64 hw_features;
>>        bool registered;
>>        u16 lif_type;
>> +     unsigned int link_down_count;
>>        unsigned int nmcast;
>>        unsigned int nucast;
>>        unsigned int nvlans;
> 
> --
> Regards,
> Siddharth.

