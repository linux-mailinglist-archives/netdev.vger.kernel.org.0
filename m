Return-Path: <netdev+bounces-21-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C16D6F4BB6
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:59:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3C071C20952
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D19D9470;
	Tue,  2 May 2023 20:59:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE83933C0
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 20:59:47 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6AD1BCD
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 13:59:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=awk6AAd2G2PM4UVnjnH4QKI1cMDgKLmiyUnwqrqNfVwt2ippfVDhS/KcHGjIQzQOmrc4LOxgKUO9InaOoCXh3bdcPCIV7riac15jKoHbewX157H7FRlLA2P06kS3HjVw0/RZniMD0Rw/E/aOQyj3zT6eCy12vp2qUD7yNX5dzwDpY57dck1wRzJruo+gPKRD3V14nzKo+E69hI40Sd6R/T1DN14VFWICwTiDAtIp8O3bSWnbHMBRiq0yhgaXxOK3r56c7cGiBCrzsYfk4Gs4teUOlxFKQvYHBHiDw8aCzZHe+GCezuPd+ezF4ceR7FQGRHeIey32AwGVy89wQEJW9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gEJJZxnAVaLJFyQv+7ruyzMkLxi2xmD8tWmzAaItmIk=;
 b=UkiPOf1EEyxYspnZn9vN+uID+5+YrRuA7iIEiCKvei/gocnTDTiyP7Wde8gTinDVtn/ZGi5t9upSIRwZck9I9G9YpeTzUpJuB1BUfqLc90lLbUz+E7E1sQRuaI136elhyfzHw+V+Mxmnnm7zyleo9BrGkUVRIFkjWY/xEl1r/lj6OQHHja2/tuGjt3QJHooFcJjJDZbPTPzvyBZa3gAwFaJLeQ+0Ouhdr6B2e3fXEv4nSE1u/OAYmbMJEFtLf7/9mh6YWo2Johbu3FZMhOh2eiJKPLTB92RqT9TrBPQEwThLDs8Tm1nawLVTLZnHYxJxiwA81iKvo8XaAXJyicTNMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gEJJZxnAVaLJFyQv+7ruyzMkLxi2xmD8tWmzAaItmIk=;
 b=E5FpzCoE2GrsoU+JJc2UBbQMURXz/2HFd6yZV/Xoro0DqqyrjFufoU7OZrc+9DAGxnB82mEleKzHDbfR0KduAj2tjOSl5wIDsompoSLQwNhJ0rvyV65KWCRX/oXoRD02JruY7F2RmzY2ZrJ76XdVZX2NkuFmGxi1+pF+wOwpBsY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DS7PR12MB8084.namprd12.prod.outlook.com (2603:10b6:8:ef::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.31; Tue, 2 May 2023 20:59:42 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc%5]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 20:59:42 +0000
Message-ID: <ad1d28c2-766a-5249-af36-cdaa6ea9f69f@amd.com>
Date: Tue, 2 May 2023 13:59:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH RFC net-next 0/2] pds_core: add switchdev and tc for vlan
 offload
Content-Language: en-US
To: "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
 brett.creeley@amd.com, netdev@vger.kernel.org
Cc: drivers@pensando.io
References: <20230427164546.31296-1-shannon.nelson@amd.com>
 <e7cdeea9-0ee4-7d08-f13b-e8afe13095a7@intel.com>
From: Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <e7cdeea9-0ee4-7d08-f13b-e8afe13095a7@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR01CA0039.prod.exchangelabs.com (2603:10b6:a03:94::16)
 To DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DS7PR12MB8084:EE_
X-MS-Office365-Filtering-Correlation-Id: 216990e7-8789-4351-8e34-08db4b5026c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vg4wy1T+a9EcORnIp+fgX+8aeGjGjMX3ZEt/4V0Y8KV/tX2M9b1zEGu9F9PNSbqt9txlVOvb/iynvoKmU4Dubs/l3rZ0/mt+53jTeP/YBYspI9nGgskFYXqf4M9Rkop9f0kQkcQS1PTRxZQ0WG9RjQ831Q1FaMYY/ZIErChUVAAmr6waZsmubhiYfcz4vRDIlot8krSwM9bHBm1KTUtG1cKorku/VL+cMzZf+STEl8h703zcWMRnr1+/4YXihEd2Q2I12AJzZMnBB+SYs1ZCg97jrmJxpsbuECtf4bO2gM0wSDp6YczdFmH8sTfuPsHPynR2upS/TDLcqG15zUnRP9WngfGrYCTuOU72Br7oBshLhUr2AAM8utLqmjsdGrn2WLI/rncbjAkBbC2hVF44/g4RVdpra6Ri2CqP7hmyupA8ukqRSiPAOFe780lanq73TWZUcPCEkYeNdzB+MsiVowpdcW9Xnv3faDDsZar+NLEY5otFPA3CbQ9NLHnCeXR8LIAVzgSG3qypoBFaOB8uVNpU4nUGj4od+QoyJSHvNZBK7bM+KH4mRcEZpaw8C+ye18GOoBNDlB6tr1sQADSRkY3C+AW0eBCxzG1A4iTa94PzYC15+5PlBT/k+iT06sBTVf8QkGtcjarPXpdJYAPP7Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199021)(478600001)(31696002)(36756003)(86362001)(316002)(4326008)(966005)(66476007)(6486002)(66946007)(66556008)(6666004)(44832011)(8936002)(41300700001)(8676002)(2616005)(2906002)(5660300002)(186003)(38100700002)(53546011)(6506007)(6512007)(26005)(83380400001)(66899021)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZW1adE0xWHhVcWMvRU5zbUNvTm55eFZzWTM0cHdRY1NyWjBhbjdnamZCejk5?=
 =?utf-8?B?Y1FDdTE4REVSYVlJUjUwR3JKZzlrdWFWYm1kNzladUVnWEVDZWxHekZYRllK?=
 =?utf-8?B?MXBnaVNGd2hNR1dtMExMMjF6WlR1emtYRGlxYldKRzBQYXZhenlCSmhxbE5t?=
 =?utf-8?B?MnJ0eHArSVJwYmF4NitiWXZNQWpNSzIrNkFMcTJLMGhPMWNCZ2IyK3ZSTGlD?=
 =?utf-8?B?TlRGSHViR1o1S1haMzl4MUhQODRzeklocSs2NVpXVGc3WjlCaFZKczllS3lE?=
 =?utf-8?B?a1FYRUM5cWxEZGtKNlRqcjFYQ1I3dHdXSVdKeGtCWi9kYWc3bXE2dUV6dC9H?=
 =?utf-8?B?WHFBRDZJdnVEUU4yc25Bc2R4N2pTcXV5ZjNxWU01dGwzM1Zram8zQVNmS2xn?=
 =?utf-8?B?b094ZnNHRTRxcUJBbWMyWmExZENCOXJac3FVRml4K2Y0T2R1TityRnFJSEdP?=
 =?utf-8?B?S2RsSnpSempGVGlGT3R3bUM2eVZaR3c4WUlycm5WZG1ZeVZoSDdob0J5MG5l?=
 =?utf-8?B?S1gvekVydnJ4NHZtOFlQTTJrSEY3WVZtelhFWXEwRWRCUXdVRHhRNWcyM3dq?=
 =?utf-8?B?VWpNYmd5WEdZYXNFSDhLanZYYjYrY05sa0dvaHdIb1JXNm1HemRIbHVFT1pa?=
 =?utf-8?B?L3lxcFFjTFBaY2NreENvLzI3ZGFMOVRndFdQM01ITVFmL0loN0NjNHdxdmUr?=
 =?utf-8?B?QVV5Y1Z1ZzRhRFFaajRmWCttQThDbml0eXhVdzhONWtja3BJbjZlbC9Nc2c5?=
 =?utf-8?B?Q3lYVU80Sm05YWt2ZTU1TWJrcmFjdmRjOC9ORlNzVkdWaVAzZ2Q3dWRMZXZ5?=
 =?utf-8?B?bWlVUDFmUEtTV09oQWFKWWNGNnNrbG1DK0dGUjl1bldFclJFenBjM1RLbWVZ?=
 =?utf-8?B?UUFVL2gwZEpTNFFtQkkwaEdwL0k5RnlDVVd4K2hmd08yWlZHYVYyMjVkQTJ4?=
 =?utf-8?B?Tk9UZWlxeVpuUVJEMVlMU3F6ZmUralZMQk9iNU95WHF0eGxYRUt2ajJhQ3Z1?=
 =?utf-8?B?TVBPUDB1blBJcGhCbGYxRTlzd3orT09IUnF4VDBwYWs0QXlxTDZIemhzYXht?=
 =?utf-8?B?YzF1clJBb21TK3p0aWRyRS9LbVIvaG9BWnhLWnFWQ2hRd055U3lKMUo4ZlZw?=
 =?utf-8?B?dHJqeWl3bVFkYStaOXhvb1AzUW5Udy9HTlQ4RHVkd0ovbXN1ME9yc2dYNldn?=
 =?utf-8?B?cnZjNlNhWm1DWVJDWTRaTTFYYlJrL0laZXl5U09tM3hSTzRYSGV0QW8zbGZj?=
 =?utf-8?B?bkh0QXlxa1R2WitlRUwwV2RwZFBXRmpvc0NOdzhyNExlbFhGZ1NrOXZRTWtP?=
 =?utf-8?B?ZERzMzJwWDV2NU9FK2NrL1RUSkF4QTRxOXZkSCswM0J0R09mbUNJS1BzM3ly?=
 =?utf-8?B?aFVQTktMR2dqSklDVXFhNTFWbGhVZFJpUGJJa2dTUFdobWlxMkt2YnFXMU5O?=
 =?utf-8?B?NUZ5OXAyRWhHcEVIOGlTSS96UGxWYUtPVVpXM1BmR3JoNXRFTnZjSkQ2cEZV?=
 =?utf-8?B?MXF2bXNoalZEM3NGa3EzcXRXVW90eGJjVzJVaXdWdVFySklwSklXNWhwdWN4?=
 =?utf-8?B?SEhwSnU0VUxPQ20rOW82dmRMNDdpZWZ3VUViemxQTElwekUzazdpNUNKUWdK?=
 =?utf-8?B?d2FmOXlJRGpCUUJJLzJTb09kYlVqbThCWVBiemtDaytiY0E5WkVTSzdMcFh1?=
 =?utf-8?B?NzR5dThPR3kraWYrZWlybmt6azMxajV2SEYxSXVJU3VWWm1IYUdNSXRlNDBD?=
 =?utf-8?B?S3BNK3pCZXRSd0JOSmZTOWdwbG0zODNvTmMwbXB0Q2w3VkVYRzF4cFVVZXM3?=
 =?utf-8?B?ZEljOGpFcldVZ1JPQ3dVYStWWHNBUDNQeWVJVGVIc1NuYS9TVzd0VVlSQzN4?=
 =?utf-8?B?a2tFT1hYSWhZdHdBT3ZJL2NXdFpwTnZic3Z6NVBGYlhId0tSSWVuQWphTG9Z?=
 =?utf-8?B?MEJFSGhlWCswY2srZVJuUithMGVnRjdYY2V1U0pzSnZtaENURkpoWkp5Yk5w?=
 =?utf-8?B?RlIyOE5rMUR3eVRKL2RFZUF0T2dDdDNvbS91eFkvcjdTODFEN0YzTmZ1QnZV?=
 =?utf-8?B?T3lDSHFOM0lsS2xNYzd5YlVENmh4cU1PbGh2SjJydmZqanZlQTZhcXdVZHJG?=
 =?utf-8?Q?Df7WliuUkmLc4fV/IbI2lAL2v?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 216990e7-8789-4351-8e34-08db4b5026c5
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 20:59:42.4729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: evOjv5s/RfTFpk1dLOA5ERfHmIRfc2qXUjGOJScMXrrsakjIYBv8xLmkLUz03GI0f/NksYvScKAM3IPMoMQ23g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8084
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 4/28/23 3:52 PM, Samudrala, Sridhar wrote:
> 
> On 4/27/2023 11:45 AM, Shannon Nelson wrote:
>> This is an RFC for adding to the pds_core driver some very simple support
>> for VF representors and a tc command for offloading VF port vlans.
>>
>> The problem to solve is how to request that a NIC do the push/pop of port
>> vlans on a VF.  The initial pds_core patchset[0] included this support
>> through the legacy ip-link methods with a PF netdev that had no datapath,
>> simply existing to enable commands such as
>>      ip link set <pf> vf <vfid> vlan <vid>
>> This was soundly squashed with a request to create proper VF 
>> representors.
>> The pds_core driver has since been reworked and merged without this 
>> feature.
>>
>> This pair of patches is a first attempt at adding support for a simple
>> VF representor and tc offload which I've been tinkering with off and
>> on over the last few weeks.  I will acknowledge that we have no proper
>> filtering offload language in our firmware's adminq interface yet.
>> This has been mentioned internally and is a "future project" with no
>> actual schedule yet.  Given that, I have worked here with what I have,
>> using the existing vf_setattr function.
>>
>> An alternative that later occured to me is to make this a "devlink port
>> function" thing, similar to the existing port mac.  This would have the
>> benefit of using a familiar concept from and similar single command as
>> the legacy method, would allow early port setup as with setting the mac
>> and other port features, and would not need to create a lot of mostly
>> empty netdevs for the VF representors.  I don't know if this would then
>> lead to adding "trust" and "spoofcheck" as well, but I'm not aware of any
>> other solutions for them, either.  This also might make more sense for
>> devices that don't end up as user network interfaces, such as a virtio
>> block device that runs over ethernet on the back end.  I don't have RFC
>> code for this idea, but thought I would toss it out for discussion -
>> I didn't see any previous related discussion in a (rather quick) search.
>>
>> I welcome your comments and suggestions.
> 
> Adding a tc rule doesn't seem to be the right interface to
> configure port-vlan for all packets sent/received on a port.
> tc would be appropriate if we want to do push/pop vlan on certain flows.

This is something that had occurred to me.  The tc commands seem to be 
aimed at a finer grain control than what I need for this case.

> 
>    bridge vlan add dev $VF_REP vid 200 pvid untagged master
> would be a better option. This may require adding vf reps to a bridge
> and enable vlan_filtering on the bridge. The driver needs to register
> for SWITCHDEV_PORT_OBJ_ADD events.

I thought about this as well, but this also seems to be abusing the 
model when there are no data streams and no representor for the PF.

> 
> Extending devlink port function to support port-vlan similar to setting
> a mac address also looks like a good option without the requirement of
> having to add port reps to a bridge.

I'm hoping that others will chime in on this idea.  Meanwhile, I'll see 
if I can work up an RFC for this thought later this week.

sln

> 
>>
>> Thanks,
>> sln
>>
>> [0]: 
>> https://lore.kernel.org/netdev/20221118225656.48309-1-snelson@pensando.io/
>>
>> Shannon Nelson (2):
>>    pds_core: netdev representors for each VF
>>    pds_core: tc command handling for vlan push-pop
>>
>>   drivers/net/ethernet/amd/pds_core/Makefile |   1 +
>>   drivers/net/ethernet/amd/pds_core/core.h   |  12 +
>>   drivers/net/ethernet/amd/pds_core/main.c   |  28 +-
>>   drivers/net/ethernet/amd/pds_core/rep.c    | 322 +++++++++++++++++++++
>>   4 files changed, 361 insertions(+), 2 deletions(-)
>>   create mode 100644 drivers/net/ethernet/amd/pds_core/rep.c
>>

