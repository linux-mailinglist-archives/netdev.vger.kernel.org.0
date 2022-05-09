Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1FE051FC85
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbiEIMWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbiEIMWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:22:51 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2068.outbound.protection.outlook.com [40.107.236.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3E418D4F8;
        Mon,  9 May 2022 05:18:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MfG9ZIoGGIGzsa9lbLhxb0L4YGx7zCCvm42CkfBZznFvc1M5JJpE6FOiFSYZ5coHQ8xrE2gkMMj0W0QG0THod76AZS8Pif6whItCvS6twpTIHEhbdlT+EcdJXzjOGLtj9OIfRF4XtHiqk+30CxGNKDmFQ3OSodYKTWx49voRiyFqM207V0WxqkvcfYip/L4BgexB+lk0JbXJYy4u7In2cEgL0aGZABP/1Gis1v3iU6EGGevQoBttb3wE0RMYUimRwxOCqmWL8LQiyLmmCJhSd3yYHOpJFczrBLYkxBCQnhjvWZ1rmD5Br8MXQUw+BrLNuhPJd+Yh4t0IDyG8fZh5fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=59KEWlvrFOYU9S3k/c7mhY9GwWKb3OSkCdhCIwiXwhk=;
 b=PNDWcuOEvuT8wLje/7czmy4eviKxZWQW02EAflN3FdkrUoXEl422gFFP35kVbQ4I+VI/DKhNN3k4G17tP35KQAxxpN+pevsD2nBeQucV6FD9atPh7loZEMxawO5VJZeVgN5uUpeZpMh8sIcu1RNsoi06s1wtj8daMuSsTdMvEGBgv+kNaIX+zcn3lCFQ5ixGMSu162eKNNHc22ix6E8rIVo0YuRKszxBymTyGSKa+sH3+ViwE8g941VLlQyMpqx5HGw/mZuJvAe2zXUSq+nWeKWpyl2ZDMamfLKoSVkLruhNS71nNF5z4agk4wLgSnveK1JI0uWimvxFbQ6u0wJ0Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59KEWlvrFOYU9S3k/c7mhY9GwWKb3OSkCdhCIwiXwhk=;
 b=Gdz7ShdBEvZhkFxTRE4kgwCbX71RYjM2qs74H+BzwU9f3Xz2iqgVJWzHiFWKCGt25PX4UTR3Fvt1nVqs+gtmZFwVa8OO4jIOZOkiav1nt3GPrAZeZOYT3OPTuEI/K44f06PiLAO1+JkFWD7nRVOVq5RzDEHyjq8OdpWD8t2HZ7j7/EwvJMYi6CtphSgjmLLPWasMhWcRVjbd+E96LUdOcyvgw0tN3RDTeEQ9NuFZGPgLwY0Glf+nPtjts5IcKOFz2REmz4N+AvgWm2MtxyAux+sRhrfZMADtp+38KwVIfOZ74dsxOE6oXSWbClxTxBO1alulaDf7RM/jLSGI4Rtt1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 BYAPR12MB2776.namprd12.prod.outlook.com (2603:10b6:a03:67::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.21; Mon, 9 May 2022 12:18:49 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::fc67:fe4e:c11a:38ba]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::fc67:fe4e:c11a:38ba%7]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 12:18:49 +0000
Message-ID: <acba99bf-975d-54d8-01cf-938d2579f06e@nvidia.com>
Date:   Mon, 9 May 2022 15:18:42 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net] netfilter: nf_flow_table: fix teardown flow timeout
Content-Language: en-US
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Paul Blakey <paulb@nvidia.com>
References: <20220509072916.18558-1-ozsh@nvidia.com>
 <20220509085149.ixdy3fbombutdpd7@SvensMacbookPro.hq.voleatech.com>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <20220509085149.ixdy3fbombutdpd7@SvensMacbookPro.hq.voleatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0172.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::16) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d456650-8940-4775-440a-08da31b61256
X-MS-TrafficTypeDiagnostic: BYAPR12MB2776:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB2776FA637EBC1B2C27D2F81FA6C69@BYAPR12MB2776.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4xlkxhw+nJl4hWPR7iy/GbQQ98tX0HPqVaoaBD/ZVVRXjXi084x+/uLDaeJwj3A0JYht8uWQvXz7nn3ZQtTRaDqSHhasoeFcyv1Qn9GNusphIBXNGNNldh/myTFC6vXkUzsDhPJF4VCe+tjDPMwPE97D5567+Fi+nD+eysf/oBfIAmBpN9BpZx7FXwfYOYXSqb6ZfZtCEK0EQKiW+oUv+fuaYZL1DtH6FU+qhaFxirvff9dG9TRViWTCCwDmA7Qb517qDiLGPvDScXAu7SH+kT/MYiMRthk7UHbe9J6IJucTNooLJ+NF1C32Sc9yzzE142OseSbS+wOVNKI3o651GIcPAN18nlJ9Lnx8Sxwf8QzrdLnYRngM/HciS14JpZLlawJOoKRPmEeB5al9UlwcAVTo/jWZmidAB2E2M5Yu8Se6d6/a9m8IHzg8XsG/dZsUWl0F1wwJkrLo3TjgmL/bfRKcjCV/X2cY8ku4xF3qJpNy2iPqqJ9b9vZvRYeeCVUC18um2Vxe23TfKIbPwbP2+3/C33+pQ/VRI6SLvDR66DwIgoJ0a0Uh9xDBz6LaplzPMQLlivlKE+bpbK/idF1/46bf90kGCtQE/xWTjzhH14Sz6MP5GsVYab+A3daPMJuwGT5y4onVLf5yYbDl4AFfKxJI+lAtBPqySKmat4vdJ6zF7JsjfoCfcexWW55DrDCT8ow+9zroqNMR8o/ExVb+tzTBBPKVbjVJb+wxc/LECcI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(6486002)(508600001)(38100700002)(5660300002)(186003)(36756003)(31686004)(83380400001)(31696002)(8676002)(4326008)(66476007)(8936002)(316002)(107886003)(54906003)(2616005)(86362001)(6916009)(66946007)(26005)(6506007)(6666004)(53546011)(6512007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkZmMm9LZ1M4ZTBkMU00V1Z2bkFJVXM3ZFJIb1p2Q1hQVlpjQk52ZWNTTFZP?=
 =?utf-8?B?czZSV3VjSHVxMFRtWWk0L2tmbzZLY1FIalNyaUdRRGZDcVNuMmtXdEkvR0ZB?=
 =?utf-8?B?dktmT0Nva3ZRcXV4Q3JaKzNCUGpueFFLcjg1dHg5YVBFcTVxWTRnVTkzNWYx?=
 =?utf-8?B?RFdrZGlibEluRmFBc1hGTHZCYW1ObWpROENyUTZ3dEhLNFJVZjVpSXZuUmw0?=
 =?utf-8?B?cDVuVmRCNlpBbDNvb0YreEp5ZkFsM1hZcFFYa094K2FQMXJVQTlHQzNJSXU0?=
 =?utf-8?B?NGsva0JoN09sL0lsckdDUmJNZGtjek41aUxlbGJ6Q2JFK1hXUGQwckVrdXhZ?=
 =?utf-8?B?bEJSUmZyK2lTV3B2T0V0Rjh6bUtxeTNFYWI1N2luNEIwbUUyZlFRQmdTcXl2?=
 =?utf-8?B?ejdGM1ZvTTZQZVFQMkR0bEZuZjN0RnNxSDhtczdvK0g5bkZxRitmbWw1TkZV?=
 =?utf-8?B?MlRtQ0xhd01IbmxoRjg4TGNSSFdHZnY1dHNoMURabWpucHdFQ3pEa0N3OFBj?=
 =?utf-8?B?UG5KdTRiajh6eUU2VEtuYlVGbVN2cVlVdzFJOTUyN2NwMnFKNWUxVUtEOHY4?=
 =?utf-8?B?RVp4UEhHS0VPRmQrRlhxd04vV2NpZkFlMkRFY1F0UklTcXpMT1F3SGZLaUx5?=
 =?utf-8?B?RVRmWnk1djJ2VW5zWkNmTUdST0J0TEtTc0hvS3NaSXpnZFVTVjZHcGRTc28z?=
 =?utf-8?B?dnZPOS8wTURZNnM1LzNhNktlM3dmbFlIazVhWTdIazVlaElBUWcrazcwTlg2?=
 =?utf-8?B?d3VDbkxjdlVFY3BlN2Q3YUdPYlY2Z2tjdmUzTGcrOTdidGw4T1BTdE4zaWpG?=
 =?utf-8?B?ekp2SnRmS080V2pyeWZKS1lQZnBvTEtLNDkrbXJndkJJVm1ybEVicmJXa3Ux?=
 =?utf-8?B?d0Y1Qkk2ZHVFd1FQSjhBMm1NRkIyWVdmSjkrM01DbGZrOHFsa3E0NTB3ZndU?=
 =?utf-8?B?MlZUbGpud2RQMy9udE0rNnZGMkFhM1ZnYkIyekpSblBPOVhwL0dtNEptTTIr?=
 =?utf-8?B?aXZtU0Q0Q0tVQSs1NnljMVNjQkd0TUtZVXZTQlY2UUk4M3BQTEloT3p6cVJT?=
 =?utf-8?B?N1RvZmozVFZwZnRzNTRmaWFJaTRJVWFGcEU1TzhDRG5GT3RLTHMwUlpqcDdU?=
 =?utf-8?B?TTgxbER0VmZEdlRHaklKMys3UXE5K05IOER1bk1pcm1uWlNvaDYyNC9zWE1q?=
 =?utf-8?B?MEhYOVQrc1FoV3lUdkNiNXZ5aFR4MTFnY2hrYWtNVkN0ak5zN2RXdjRTblE4?=
 =?utf-8?B?OFMyM3UvK3BPeFBxMWxEZWRpdE1URTZ0UHlQc2MvaDBxNGsvRmNsZ2JtNkZr?=
 =?utf-8?B?a0tsRE5vNlJxa2RkVUFDKzBCT2ZTTEJzRldKclNlL3A5eG1qczhuNXl6SVNp?=
 =?utf-8?B?TW9PT3pxMlFTaWdpSE9BNWhUYUJBSW1mTGpsWCtzY09oM2tHaE5GS1hkeVFy?=
 =?utf-8?B?UTB6REdEa0hjclN2ZWpCNzl2NG5tenlQYWF6MXduU3V3K2tIUkxMMitqNnZF?=
 =?utf-8?B?S1hqQVZqMityaFBYbWNwWUUyN3M3aHEyQTA1QWR4OTV1TzNGZlJ5Ump0SEFw?=
 =?utf-8?B?OGhJL3NMTGJFbGdUUjc2L1YrWk1tRHVQTUNsVHp1RStBcEluZzVEKzFyVllC?=
 =?utf-8?B?RE93Sld3TnNERlFyWkFpZVc0dGpKZlAza3NrVTduSlZGYUhMaDAyOGs2MVhp?=
 =?utf-8?B?d2UvZFptTDFvVXZFM0RZOGJhQUd5bldZVEllazJPcmw0amt3L0JBTGg1bTJD?=
 =?utf-8?B?dFUrVmhFRmVCTjJ3bjVsa0JRcHFBZlhCNU5OTkdwODVHWjVKV3RZUUtOTGZa?=
 =?utf-8?B?K24wa3lWL01DcGp5bE00OEJhZys2MHRmRXZUUDh6bzdSRmk0bTdUY1dlcnVV?=
 =?utf-8?B?aWl1UHR1K1hDa3JYeVZYK3hYTWNqMUZJTkkzZEdEZUc5cCtZRlE0cjM5ODRr?=
 =?utf-8?B?b29SWGFpZlo3emlzclgwVDdua3A1YkpiTjh4OXU1U2dYOE5NdHJOZzI4ZU96?=
 =?utf-8?B?RWR6aUFoa3dkR3hxUFJGeE9pME90anpWc0FncVNEdmkwb0lDVWpWeFUyRWlZ?=
 =?utf-8?B?S3g3RjFsZnYwRWU5RndXY1FzVlFBd3BSaElKd09uci8zZStmWGhzWGdpMXl6?=
 =?utf-8?B?QVBsZVZkWmRyaUFIZW55YXBHcjZXTTluN3lpb29OMXk0WjJpbW1jOGtWOVJi?=
 =?utf-8?B?cGRFMEJ6TzRmbWlLd2VQeWhGYzYxcHRvVlNGbFMwTG93R3lRVlBBTDBoTzlx?=
 =?utf-8?B?b2x6bTlNZlduWnJWSElOZVE5d1haR3FZUWVLU1ozOUtNdmhOY1RoZ2pLSm41?=
 =?utf-8?B?QzdkNmJkNURPbWx1MVpCaHFhSnJSOWo3am1ua2xVcU9nS2YzZDBVUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d456650-8940-4775-440a-08da31b61256
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 12:18:48.9986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TFfcZndFdtCAcEY67jWUn1VmKvc9pLw4lSr1zjiYu+Vpzggu5GDgBvBPzNnChUO2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2776
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sven,

On 5/9/2022 11:51 AM, Sven Auhagen wrote:
> Hi Oz,
> 
> thank you, this patch fixes the race between ct gc and flowtable teardown.
> There is another big problem though in the code currently and I will send a patch
> in a minute.
> 
> The flowtable teardown code always forces the ct state back to established
> and adds the established timeout to it even if it is in CLOSE or FIN WAIT
> which ultimately leads to a huge number of dead states in established state.

The system's design assumes that connections are added to nf flowtable 
when they are in established state and are removed when they are about 
to leave the established state.
It is the front-end's responsibility to enforce this behavior.
Currently nf flowtable is used by nft and tc act_ct.

act_ct removes the connection from nf flowtable when a fin/rst packet is 
received. So the connection is still in established state when it is 
removed from nf flow table (see tcf_ct_flow_table_lookup).
act_ct then calls nf_conntrack_in (for the same packet) which will 
transition the connection to close/fin_wait state .

I am less familiar with nft internals.

> 
> I will CC you on the patch, where I also stumbled upon your issue.

I reviewed the patch but I did not understand how it addresses the issue 
that is fixed here.

The issue here is that IPS_OFFLOAD_BIT remains set when teardown is 
called and the connection transitions to close/fin_wait state.
That can potentially race with the nf gc which assumes that the 
connection is owned by nf flowtable and sets a one day timeout.

> 
> Best
> Sven
> 
> On Mon, May 09, 2022 at 10:29:16AM +0300, Oz Shlomo wrote:
>> Connections leaving the established state (due to RST / FIN TCP packets)
>> set the flow table teardown flag. The packet path continues to set lower
>> timeout value as per the new TCP state but the offload flag remains set.
>> Hence, the conntrack garbage collector may race to undo the timeout
>> adjustment of the packet path, leaving the conntrack entry in place with
>> the internal offload timeout (one day).
>>
>> Return the connection's ownership to conntrack upon teardown by clearing
>> the offload flag and fixing the established timeout value. The flow table
>> GC thread will asynchonrnously free the flow table and hardware offload
>> entries.
>>
>> Fixes: 1e5b2471bcc4 ("netfilter: nf_flow_table: teardown flow timeout race")
>> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
>> Reviewed-by: Paul Blakey <paulb@nvidia.com>
>> ---
>>   net/netfilter/nf_flow_table_core.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
>> index 3db256da919b..ef080dbd4fd0 100644
>> --- a/net/netfilter/nf_flow_table_core.c
>> +++ b/net/netfilter/nf_flow_table_core.c
>> @@ -375,6 +375,9 @@ void flow_offload_teardown(struct flow_offload *flow)
>>   	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
>>   
>>   	flow_offload_fixup_ct_state(flow->ct);
>> +	flow_offload_fixup_ct_timeout(flow->ct);
>> +
>> +	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
>>   }
>>   EXPORT_SYMBOL_GPL(flow_offload_teardown);
>>   
>> -- 
>> 1.8.3.1
>>
