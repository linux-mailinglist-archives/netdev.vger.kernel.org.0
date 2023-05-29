Return-Path: <netdev+bounces-6062-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BD2A714980
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 14:30:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE8311C209BA
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 12:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6538946A2;
	Mon, 29 May 2023 12:30:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547D27471
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 12:30:03 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2079.outbound.protection.outlook.com [40.107.212.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CA4AB
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 05:30:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J34RnZbB5e/fOzbLopY20j+tpfSh0UV9AyoqV8MYXgTktE9K0wLlccwxMktbaqWcABMLbqZ0m8rCUGwow0O6wPLT/VMXfBIMy8K33TnGrk47SXjt/7TGvtau/zZ7ITI5NIBp2pu+5lFBXgInsqg5YnUCFWpq82hqcqbs+z7HHBpNEA144BjRA8C7dQ1Ea2uHXLY74qskCXhJtzhvh+IaVekURZ8PO8QhCs3VcTpbErZpMFpQIrHs+3+S30FU5JiAQI1oo3k8OA9rdCeHwiPVCUZwU6Jj5a1kfCjwgp0qNKVCCbnJvdzYDCl+aSqIOrmSG5UsoUEtfp4Os2WnwM419Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FIWlJHp8QIXo7t/dkfpnYIOvMGpvShagdk/qELDGSQ0=;
 b=iYTzFQYfVftWIF0338mweQaux930qChQ5fHbnwfEJzFcs2J4oXSeaVPOIbsK0F0ySE2PWrJLGpCRacdSzl2vsAyjK2HfMlpIRkrkZCZe3K7mIxufr6br7+B4x2wkBzOaqkY/vjWpKySUJGuduXk1YICUCBNA3OQWnaasWt+KAgC/jRXRKa6ZbBMeK4dDU7WBhyuYCrw5nDqT/CTxYX9ObccbCYARtgeAklv40iaOTG6s9Y4nYud9lWBVugldULXTJPCV0nyrbeXknt+n3skeOu43vordISgcUtmH+/MOHUfUdblSvcS/PLnODAsOTR6FoNxAw3wGMTxChbUQizR5dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIWlJHp8QIXo7t/dkfpnYIOvMGpvShagdk/qELDGSQ0=;
 b=BI/sKdUALsahtEFbUZrhhaWW8ecLxCdX5sjjYeArHZ1QSkC4bpKgc7AdN8GvF1olzOWlIhc9V+AhZgdJmzcs35Ne6QOdxJtLcTAvaddy5CTG89owTNuwLL9OVyeteAw2gPdRKhwhub+BbcOYqKxIBC+h+cnMRgE825xnEOhURzdYbUOYFTJ3N3In9SrOY9ylocR1/eK04ZGuuhSV6UUWsDCeZzk1+WbJeVfMubLWS8iJ2yGYtNM22aCVUzBjvTPOw6rPPHWolisPKTLTCarS5V3yE0nco/W4zaVPr7aW3ojLz5B9lENzHzPlkREAK6qoMzGsn5aqwLiRFe7Qdy6Qkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 BL1PR12MB5222.namprd12.prod.outlook.com (2603:10b6:208:31e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Mon, 29 May
 2023 12:29:59 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::e0d9:ae35:e476:283b]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::e0d9:ae35:e476:283b%5]) with mapi id 15.20.6433.022; Mon, 29 May 2023
 12:29:59 +0000
Message-ID: <7517ba8c-2f51-6ced-ba84-e349f5db8cac@nvidia.com>
Date: Mon, 29 May 2023 15:29:51 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH iproute2] lib/libnetlink: ensure a minimum of 32KB for the
 buffer used in rtnl_recvmsg()
To: David Ahern <dsahern@gmail.com>, Eric Dumazet <edumazet@google.com>,
 Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev <netdev@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
 Hangbin Liu <liuhangbin@gmail.com>, Phil Sutter <phil@nwl.cc>,
 Jakub Kicinski <kuba@kernel.org>, Michal Kubecek <mkubecek@suse.cz>
References: <20190213015841.140383-1-edumazet@google.com>
 <b42f0dcb-3c8c-9797-a9f1-da71642e26cc@gmail.com>
Content-Language: en-US
From: Gal Pressman <gal@nvidia.com>
In-Reply-To: <b42f0dcb-3c8c-9797-a9f1-da71642e26cc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0229.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b2::14) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|BL1PR12MB5222:EE_
X-MS-Office365-Filtering-Correlation-Id: e9977f54-fad7-4c08-6c97-08db60406aba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3gAu/xW8nKCVxuw2PJ+ryfxHJgWEqJlv+EiFFMUmXQqp9o1zeEtAD0o7NDj3NdcmyYAzuq6nMLJ9jD+9LVltWnwKRn0vAbaiVZ2sfD4crcW1IQpo80qg/mBFGGElFeGxuC0GsMDWFth7R/FXjwV8g3P/AykRVFV00hc9R7N3rdAKHnKmKYnoy5aAIj1qeJAd3ThH4POjweRlnFKK5n2/QUMCAGNlnCEDQ6V439sSYoI7u2WoWhR9pPCJjQoCB8c0IUTjSkfcJuuCKdA0wf5P2oLVbaFe1I0PZGY5u/+LF+nu7SRCjir3yPdRVYcHoDWuK1IM70dZkr9ix7PUb7GnXAj4C1JrAqq1lYw1EXgKBPoGoPpALaMClJIW8tdrpR5L75FdVyhC5QMdX0Fin04x78TrvKR9YXzM8+iOiADdLO7H9vqYvQJrO5u8FvWWjSsBa1AJth3q7getaxG+9Fy7HjoXirGGXjRy8YiD7C0J8jW4aF8vHXS9Uy6rNNaZ7yptek6nmzegd5kuP6x6dL487ECq+ynZbDJMFwpZKSHhwbOn0Ej6I7ZWEa3YEkWgJ48QpFzIad5JlP0mjCF+hWo+hJWBiAMlsI6dOeVcaMQOA5QgeEG/2n8PYLZL8Oyc1BULjtOLDvuDs2VTJnBrBA6QVA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(396003)(346002)(376002)(366004)(451199021)(31696002)(6486002)(86362001)(41300700001)(4326008)(6666004)(316002)(66476007)(66556008)(66946007)(36756003)(5660300002)(186003)(2906002)(478600001)(53546011)(31686004)(6512007)(6506007)(26005)(2616005)(83380400001)(54906003)(8676002)(8936002)(110136005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MGZ4Q2NsWFEwdDc1TGdpZEJZVDJPS3hJVmUzcUNFOWhLbnE0VDZlWm9WSFRh?=
 =?utf-8?B?Rkx4SUdhWmlKRlErZlNabUcybE54bTZwQlRvU2JmRURyK25sR25wWDNuc2d3?=
 =?utf-8?B?RGhnSnZILzhHd2FyS3dLNTQwNmRsSTJOVytGSHA3R20xK0ZweDJ5MXYvNTE1?=
 =?utf-8?B?VjFXQlRtdW1TM1o5L2tseHFiZ0IwaTJLUFQySDVMdW1RT21GNCtjVS8xdE5J?=
 =?utf-8?B?VWFRRS9zaTduMWZGN3psT04zOUZIaXBsMHNnb2prRSswRVF3M2I1VkYvdUpi?=
 =?utf-8?B?c3dpY1hMdnE1Z01YSHNLV0pUU0wxemZZK3RjU3pFVkJiN3drR1NSaTl0bjVt?=
 =?utf-8?B?ZnFQVlBwWVNLTlBuSWpTcE9wMnNVRzJCU1NRV3RGWFZWNk9HT0xhei9CR1JP?=
 =?utf-8?B?TzB1ZGNnd3RIUlNXaUg2cnJrQW5ORldMa2Z4eUJ5T1FscGdTMkdYYnV1djJ4?=
 =?utf-8?B?bE9rR2FrQkczQWhMZU9VM1RzVjZNTkN5OFllVkJSbWt1TGpGUVZ0TE1QL2dk?=
 =?utf-8?B?M0duclpGODNXcmJMalhNY0tUV1FWNFMxTndaUW9PYkdzM05ITCtDNFFvVEJJ?=
 =?utf-8?B?czZMeEVuMzVITHVjYml6a1d2ajZBMGpXaGVQd2pqK0xHWDd2cEF0L2wwWE9I?=
 =?utf-8?B?OEVwby92YWRXR3RGNGlxL1o3S1N5RDF6TWJPSHlpOXptdThKdk5ZTFhmMmMx?=
 =?utf-8?B?K1RWTVpycGt5NnZtM1R3aGZZZXhKMzljZHZ5MExSdk81djRQSVFlWFJJdFFS?=
 =?utf-8?B?em85cjNaTElLSEU4UkoyTmhFdEFidHpCVDU0OE44REwxdnhaTGN2WCt4T3Nk?=
 =?utf-8?B?THNpLzZjQ243TytiUVp3YVVxK3FLVWc4SitjUThLVFhjVlVjRjJvckZaVnNy?=
 =?utf-8?B?ak5HdTZwTytndVJDZ3hpM0h3eHo2cEJJbEJMVmRYVTA4YTc1YzdnNlFlTjNH?=
 =?utf-8?B?UFNvOUJXM0U3S09SM1M0S0FhRzlaZFpUQ0lmYm1vZFczTGVvcS9KY3NRTUh0?=
 =?utf-8?B?SEdQZGF5N3diUmZHS0NqeWdhZnV4RGY1K2N0V3Nyc3A2S1Z0OXJTOFQwQSsx?=
 =?utf-8?B?U2Q1TVk0aGJYWXhZRXhuZndTbEJqbTc3MUJDVW02VUVaTFRGRldyaDlHaW80?=
 =?utf-8?B?RGZwWmhmaVBhaTFkMUtuWDFNZ2tqdUFqR1oraEhDemVKNVR5S2dYS0RPTGtM?=
 =?utf-8?B?NE5qaWQ3ejFFNzRDLzBMYTAybGlEc2RTUVhXQmw2NGtaOXpaanJzd2Z5aHpF?=
 =?utf-8?B?MHoraENmejZkZTZRRlZXbEYvQ3ZYeUhkd1puOFNodTNibE1pUVJTN3hIWncx?=
 =?utf-8?B?dHRzckc1UkdldWwwSy9wZmt4cGF4M2hKMWVDeGJPMGE0SHFHMFlXRjNHUkVp?=
 =?utf-8?B?cy9TbTBpdzdqZU9HY24vSzhEMVB1MTRuT1dSbW52SWp3dzRoc3lkSk9XTGdV?=
 =?utf-8?B?TlRJOGhBREVLR1h3UUs4WUl4NUpqbWl4Vi9mME1HS0wwM3ROT0F3MmIydE5G?=
 =?utf-8?B?RFpCY3ZDOUQ0Q0x4eUY0cnNuc2dyZ2RPRU1lVTJaQkZhRjIzc3lvZy9EVVRC?=
 =?utf-8?B?QXBiREVaK2JGWURJY0RDN3FoQkFvdEVXMHRDNng4Q1lJa0prQ1JJMS9qTlRW?=
 =?utf-8?B?eEl4dUxtZVp1eWMyZVpCQTZBaVZiZlBydjhWSUhTL25GSjVTTUlWQzFjUHdT?=
 =?utf-8?B?V2l3TmduemV0TlZMVFhodlVEUmJuZmF4R2tsNTlaQTJSUk9vWVBWZm1TU2dD?=
 =?utf-8?B?NVNIZU9GcFBmYzZZbVFIT0VMcktneDNyWmtoNUY2UUtlSU05Yk5SOGtDL1hV?=
 =?utf-8?B?ZEYrbERlN0w0MXN4NjRKUSt4cllITEJad2F3WGdVY2tSYlJNYnFVRHBzZUs1?=
 =?utf-8?B?bWNCcUFxQUwzLytsdzY5RzFnYkx4RlRVMmE4UmtjTUp5aTZrdmJpTFRBWUJq?=
 =?utf-8?B?a2VHUjNvaFVSYVhYYjVMaXRhU3Z4Nmhtc3VRNEtMME9SN1hCUWJQR1o5dloy?=
 =?utf-8?B?V3owMlNyZTZwdkFTZi83VzRpcCtHdXlmQTJuSUhNdHIwZEZKa2ZZTWFMUHhI?=
 =?utf-8?B?OVkrY3BJZHd3akpLcFVjZDJKVGdGZlhicjZCSGhDcGQzVVRHK3BkRmdDUW11?=
 =?utf-8?Q?4/sZrz/KQQjWQ9CtxP21qCaxA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9977f54-fad7-4c08-6c97-08db60406aba
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 12:29:59.1948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ch5z8hoPz9PfQs6ZA2UyQXNcjZ79JTTBWv97/2KI0RKqJDvqmjwBtBn/CpB9ZafM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5222
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 13/02/2019 4:04, David Ahern wrote:
> On 2/12/19 6:58 PM, Eric Dumazet wrote:
>> In the past, we tried to increase the buffer size up to 32 KB in order
>> to reduce number of syscalls per dump.
>>
>> Commit 2d34851cd341 ("lib/libnetlink: re malloc buff if size is not enough")
>> brought the size back to 4KB because the kernel can not know the application
>> is ready to receive bigger requests.
>>
>> See kernel commits 9063e21fb026 ("netlink: autosize skb lengthes") and
>> d35c99ff77ec ("netlink: do not enter direct reclaim from netlink_dump()")
>> for more details.
>>
>> Fixes: 2d34851cd341 ("lib/libnetlink: re malloc buff if size is not enough")
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Cc: Hangbin Liu <liuhangbin@gmail.com>
>> Cc: Phil Sutter <phil@nwl.cc>
>> ---
>>  lib/libnetlink.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/lib/libnetlink.c b/lib/libnetlink.c
>> index 1892a02ab5d0d73776c9882ffc77edcd2c663d01..0d48a3d43cf03065dacbd419578ab10af56431a4 100644
>> --- a/lib/libnetlink.c
>> +++ b/lib/libnetlink.c
>> @@ -718,6 +718,8 @@ static int rtnl_recvmsg(int fd, struct msghdr *msg, char **answer)
>>  	if (len < 0)
>>  		return len;
>>  
>> +	if (len < 32768)
>> +		len = 32768;
>>  	buf = malloc(len);
>>  	if (!buf) {
>>  		fprintf(stderr, "malloc error: not enough buffer\n");
>>
> 
> I believe that negates the whole point of 2d34851cd341 - which I have no
> problem with. 2 recvmsg calls per message is overkill.
> 
> Do we know of any single message sizes > 32k? 2d34851cd341 cites
> increasing VF's but at some point there is a limit. If not, the whole
> PEEK thing should go away and we just malloc 32k (or 64k) buffers for
> each recvmsg.
> 

Hey,

Sorry for reviving this old thread, but I see this topic was already
discussed here :).
I have a system where the large number of VFs result in a message
greater than 32k, which makes a simple 'ip link' command return an error.

Should we change the kernel's 'max_recvmsg_len' to 64k? Any other (more
robust) ideas to resolve this issue?

