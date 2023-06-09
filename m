Return-Path: <netdev+bounces-9648-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4463172A1B2
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:54:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 915FB1C21156
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B6BF2098B;
	Fri,  9 Jun 2023 17:54:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE6919BA3
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:54:55 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FD1DD
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:54:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kB7cEHwhHNINAbqnKddoHOuHCf97uAExWTPU8W61ebsPlnY7/hxRfYwSFU23IMWkE0LISB7iXyrLQUTdFJ19qY2ghMeyPOneC+FKoYtrlB3TmBz5Qcdu1gDR2tcXW3DdiUnH+YnrReaTtlFHWHMFLDShoNFHe5T3IcpM25kjP05bQYefSgJBpFp18lxbOLjGSKhFHSawQXnsLyXqUrCMd7AjuXAjv4XVUaOV8g4/mv0alXabqr7rcvVjMOZt1tZzFqvh71uaNvLIgh0CRBuMeB5Y5WvMJ+ZGBB2dOlLt37D+XAEgL3kqdhKfCzChR9SAnthxrIKNy4eM8UwrRrYGYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tHdGtfR78fydFCuaW+ZrTfPmonmEqQTRwnNV1N+fRrM=;
 b=V45GGnxUbhhVOqT1bUCdbql6sFd5EFVt7F2YHr+r8doednc9kIl2KSxOoBSNAySSbcVqVYkg9BSymuMtZDCWG+xKEgvjJdEMOLeI1bqGtiBp8WbKqLmNyh6Kea1qRGXCuTXij7O5QvVZI7mg8jEFjYEnK3GH3y+X2aDzaL+BTprc0/Nkk0D4jRo8ATFW7GpBCcjbonNUn6Z7HxE4VAF/It2htGSIrKPS3O4DMvRl3XWHtmGGStUK06zUL90g/POJ2mUGfRXodPD/s62jGp36Lgqeb6D9PslrBP74eZfjcabk0C/WVpiwNZJt8iqAO+7h5w/h2hDJ94bJB9HFmaHLtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tHdGtfR78fydFCuaW+ZrTfPmonmEqQTRwnNV1N+fRrM=;
 b=dmu6aUt9g7qjgql10jGWYZG7rFMkxHwXOxST5wUeBk8AwylP3uZeUIhauPFJbJAjFEPyygayIwII3zb+W+o2Q31kb8R6MnOZUuctGDehpnkS/JCw2CZd1VGhlKbnciSUb2winZ83dY9xaCexlnjlOklCLNQq1+StihjFFwbo0EQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CY5PR12MB6250.namprd12.prod.outlook.com (2603:10b6:930:22::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.38; Fri, 9 Jun 2023 17:54:50 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::818a:c10c:ce4b:b3d6]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::818a:c10c:ce4b:b3d6%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 17:54:50 +0000
Message-ID: <c9bcdfa6-81a9-8020-8760-f6fb2d59d828@amd.com>
Date: Fri, 9 Jun 2023 10:54:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH v2 net-next] ionic: add support for ethtool extended stat
 link_down_count
Content-Language: en-US
To: Larysa Zaremba <larysa.zaremba@intel.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
 brett.creeley@amd.com, drivers@pensando.io,
 Nitya Sunkad <nitya.sunkad@amd.com>
References: <20230609055016.44008-1-shannon.nelson@amd.com>
 <ZIM68vWe0nRSTkBv@lincoln>
From: Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <ZIM68vWe0nRSTkBv@lincoln>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0092.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::33) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CY5PR12MB6250:EE_
X-MS-Office365-Filtering-Correlation-Id: 2340d262-7a8f-48c3-903d-08db69129f23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lQ2Y3zZx6HBuzCa/FUgLqSz+dl81stIrWWz5rBzQXS6LavdY6PuibI3Drvvy2s+xOrUaccooaxaE3PIxgbuKctWJGdnqOKqz1o1dKgXt04NcGcv4SqI3+ScY41DcuJHVGH4lZNOpCrxAaPEWbEI7jfUPtB+NbNtvqC8YLHYErbPFJbligNkEI6Z319SuK83RyigGPjISKoDrelG8ljswBtIbdakRVzXPuyjmCDyYYxMkZRu0P26CDkqSSQEDOLCSnoSaLhClGxnURPKIhRusT1ETiLfQUmjaAPTn6YbMFzyE6gnz5ZAmRxR2OU/TP4R7BfVOWOLPizt8BndODfEhkTxZqriVhmzkCsG5WyQahkPkjwKOekAmd1ylOpOL9M/tzJ1ok9n51jkFdzcYOs29j3ojuAJrbN2fvZwU4U59foJJUhAP7/ZEiHgXlKClBz6gttPR1nMZ/uy8YbqYXKAP3FcPmptzR6oJNkh67d74J/3QfaZBAgyHnlbUnHb/4sMP66r23MW3sMtXp+TC5e1Jb05wPtSdtFNCAkP7m/dFHEQFvyPo3XDAM5PwbElovuHC2WAniJSNCRtkUUWcO17YJ1M0zE6ZSbkKpOSegGJURqJfO9uHlYY5AdsJeRMUu2DqOpL056byoUrkBGCLl54cMg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(451199021)(6506007)(53546011)(6512007)(966005)(186003)(31686004)(2616005)(26005)(66899021)(6486002)(6666004)(66946007)(66476007)(66556008)(36756003)(4326008)(478600001)(38100700002)(83380400001)(8936002)(44832011)(5660300002)(86362001)(8676002)(6916009)(31696002)(316002)(41300700001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OWd4OVc4Nk93WVNTcGg0a3JmRkRWV3Q5YzRlNkNzdTI0cGlSM0QwZTNlc3RB?=
 =?utf-8?B?WUJjMnJSWjIyZWNpc1ZpQTBFZTlQYnBrbWhhRzdGTGF5Z2ltWVFReThQd3da?=
 =?utf-8?B?YTFlbU1kRUs5TTU4dUVia0VsSVhOdmFmdk9lY2ZzbGt3cGRsLzh4bjJuaGdC?=
 =?utf-8?B?dlpZMGpEbC9RY2Z2bXVlM2FNMDhUMjZuWk9VQmN2Q2dGNGVrZURDNTI0NGhi?=
 =?utf-8?B?K2Y4TjR5TkN1L2RaZ0hoZUJMRlA2U25MKzNmYVNyeXR3b0trbGJ3VUNUdDl3?=
 =?utf-8?B?Z29BL1cyKzkrcFEvT1liVGZlMENvaDdhdENYNGxRK0t0RHFxYVY2ZU5KRFVo?=
 =?utf-8?B?dW9nYmwrM0UwRUprOTNYcWxmYmptUWtVeGRmYW5iZGZuNGN2bGtybEE3bmhv?=
 =?utf-8?B?U1JZMS9BdXdCdWhmTDNtV0creGNXL1pJQVc3Tm40b2VYQjNQK2JiektMWVVT?=
 =?utf-8?B?R1NJYmhnRGg4QjNRcUx6NFA5S3A1WHB0enBHemNOemRRZk1DRVp5Wm1YMnFP?=
 =?utf-8?B?QUYxZC9wdmRQRHhnbHNMVmxzdzM5eGhNck9GbVVpbjhUem4zN0ZkcGo0bElo?=
 =?utf-8?B?TGZ2YzUzdXE1aUFiSjdxdmR3cDZyWDlIbmpzQWlNMThzSis0NmJNQ0xyNStq?=
 =?utf-8?B?NlczT0JtZFloN1BCMXk1OTV6dDQrU1FrVmJmZnd2bmltZVNCbldYdDl5TGoz?=
 =?utf-8?B?ZXMwazlQWEJsREtMU3VzWlhBVnZpT2FhaVZRZ1RpVzhHMkkvQXdOamVWSDla?=
 =?utf-8?B?M1B3akR3UVpYK3BYZ0xDUk0xVW1UNDFuc2twbU1xOFFYOVJRR0xWSitpMk5u?=
 =?utf-8?B?b2J5M24ySmZkR2pJWTJsMVhYcWF2ZGtJbXNmMC9hU0U0Tm50MkpsV2VWWU1T?=
 =?utf-8?B?UUF2L0ZRNktWNU4rSjJtNDkwdE5PQWh4cnk4am4xOFJNTjJPSVlsWkMwRXRJ?=
 =?utf-8?B?VHVFSks3MXJZTzBKb0VEblhKV1hDb2VSZ3FvbGpoZEhKYjd2TDljTzJGbGl1?=
 =?utf-8?B?ZGNBckdjN1JYNi9CR2RVb3UrRThXcXBRbDBPeitKa282R0MrUTZKRDViUzlW?=
 =?utf-8?B?YkFQU0F1K2d0dWo5Z3hjTU1vQ1JwM2NOL01xRVFnbTdmL2JQL0o1VG5BOTJC?=
 =?utf-8?B?dmR6UFlsLzYvUWM1VjdVS01nMnVFY2pCenBXeVVtbm11OTZPanJHdEpSZDhj?=
 =?utf-8?B?TkdPOGpMUzE3bmVkbHN0dnR3RlBTS2REL0pGRFBUMDVtTkNmdU9mTTNZdFNP?=
 =?utf-8?B?SjM2NldtM1gvQ0ZPQytKM2I3WDgyK200WG85OGhVTU4zWmZKOVk0TlJFNjlR?=
 =?utf-8?B?SmZKT3pya3Vzb3gxU29uUmlFTGNFUHJwZjNOdTA1Z1hIK2huQzAwVmgvUkR0?=
 =?utf-8?B?YXZKYzd4S3RDank3empxT3FwcEFYdW8yOHEwR0trbS9lTDhZSnNCcEgxTWFV?=
 =?utf-8?B?ektLM0JaYXM3aklQc2hzS1JiMlV6aFJDRmE1ZWhBa05kYWtJQk5GT2JkeFhu?=
 =?utf-8?B?dkhVdXBBb3dPWE1FL0xFTTFFN1ZMWGFGaGttQ3Y5ZmVaamhMK3V3dFVCMVhQ?=
 =?utf-8?B?Q0M0K0hBMVJHV24wLzY5YlJBalZZRkZUTStYK1V3NjkzZDVNKytrUTdRQ3cx?=
 =?utf-8?B?M29RSjJ6dUg0OGoyLzE4aFVOU1RMUjYxSlFUd2VCbGhXNGpWNjkxWG1nSGlO?=
 =?utf-8?B?ZTBYeGg5ei8vNlZPSXVDVS83VVVlS0Uzc29VdnJtcnp4OVZ3R2kvUE16a0Y4?=
 =?utf-8?B?Vkp4VzRtN0JLRTNKbzZXRGpXWURmVEk5VjA5VGxJSU1ZUXRFM1VIejlKNW9L?=
 =?utf-8?B?SVlJUDR5dlY5ckQrNUxxSE9UYkQ0RGRiV1hkVGgycHhocHpYZGJyL2w5ZlBt?=
 =?utf-8?B?L3VTQ3AvSytucEpMdEt6RUlZeU1mUnJoT2NmU3ozelc5NFhSZFlneDFtV0VS?=
 =?utf-8?B?WmJSUWhxT3laNnhRaklQTkszdkZiaTlJMTlUU3NlbURGK1c3QXg0ODJUa01y?=
 =?utf-8?B?VTVZalVTUE9qZUhxNG1iR3E0WEc5K1hjSTBzVXk0MktaN2ZVSVNET0dFUWNZ?=
 =?utf-8?B?NXNsZThoS2duWERYeW9GRFNwYzh3Qk9vTFJXcHZiOWlxK2Z4WDlnV25EQlo1?=
 =?utf-8?Q?YaHpSC8AolbFcHUZsUwsKKeVC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2340d262-7a8f-48c3-903d-08db69129f23
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 17:54:50.4793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4LovfdcrvH92frsr/G1NUDxd2d8kw4ksYO0qJWo7iX5UvSMQ+N11NP/v7SnJqd1juEqqK+gmvXpbkMi6EiQEyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6250
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/9/23 7:45 AM, Larysa Zaremba wrote:
> 
> On Thu, Jun 08, 2023 at 10:50:16PM -0700, Shannon Nelson wrote:
>> From: Nitya Sunkad <nitya.sunkad@amd.com>
>>
>> Following the example of 'commit 9a0f830f8026 ("ethtool: linkstate:
>> add a statistic for PHY down events")', added support for link down
>> events.
>>
>> Added callback ionic_get_link_ext_stats to ionic_ethtool.c to support
>> link_down_count, a property of netdev that gets reported exclusively
>> on physical link down events.
> 
> Commit message hasn't changed since v1, despite the comment about usage of
> "added" vs "add".

Sorry, missed that.  Not sure this is worth another spin by itself.

> 
>>
>> Run ethtool -I <devname> to display the device link down count.
>>
>> Signed-off-by: Nitya Sunkad <nitya.sunkad@amd.com>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>> v2: Report link_down_count only on PF, not on VF
>>
>>   drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 10 ++++++++++
>>   drivers/net/ethernet/pensando/ionic/ionic_lif.c     |  1 +
>>   drivers/net/ethernet/pensando/ionic/ionic_lif.h     |  1 +
>>   3 files changed, 12 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
>> index 9b2b96fa36af..3a6b0a9bc241 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
>> @@ -104,6 +104,15 @@ static void ionic_get_regs(struct net_device *netdev, struct ethtool_regs *regs,
>>        memcpy_fromio(p + offset, lif->ionic->idev.dev_cmd_regs->words, size);
>>   }
>>
>> +static void ionic_get_link_ext_stats(struct net_device *netdev,
>> +                                  struct ethtool_link_ext_stats *stats)
>> +{
>> +     struct ionic_lif *lif = netdev_priv(netdev);
>> +
>> +     if (lif->ionic->pdev->is_physfn)
> 
> Maybe
> 
> ionic->pdev->device == PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF
> 
> from [0] would be a more reliable way to determine, whether we are dealing with
> a PF?
> 
> [0] https://lore.kernel.org/netdev/20191212003344.5571-3-snelson@pensando.io/

Note that the indicated code was removed from later versions of that 
patchset and never actually made it into the driver.
See commit fbb39807e9ae ('ionic: support sr-iov operations')

Also, using is_physfn will still work with no further changes if we ever 
add another PF device id.

Unless anyone else has a preference, I think this works fine as is.

sln


> 
>> +             stats->link_down_events = lif->link_down_count;
>> +}
>> +
>>   static int ionic_get_link_ksettings(struct net_device *netdev,
>>                                    struct ethtool_link_ksettings *ks)
>>   {
>> @@ -1074,6 +1083,7 @@ static const struct ethtool_ops ionic_ethtool_ops = {
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
>> --
>> 2.17.1
>>
>>

