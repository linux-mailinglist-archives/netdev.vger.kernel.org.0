Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3E3524DAE
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 15:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354065AbiELNCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 09:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242572AbiELNCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 09:02:31 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6011962137
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:02:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nl/UE7f/iS0DQncvqCPmxVZIIsBIlPWZ8few9Ax8Ha7i1sCcRbpP1DBDxPuRgniDv5ABGxcS1UNg025avaZeUgD6dj70rEsqIOVleTll4tXkzeCRJ3sPtrshgxslzTH2UYt/KxPgWrQdXtMxNS0yQB4Gzjdcq2+1/jkSaotwFGCjHeIuntzStLd90cGXd3tUsKjUe9O0ywefndtRSyalwMHFHu170VHskzjPww1XaJHPlZ+lRX9MrmBkZzJphrdM9mzNx/4rKGZ6cm+J3W7XtoJvXRnO8sJfeZTnvOTAUu5WzZyaxJHoMSSjuhVAs0ZmWxiESluK9D2FFSGrHOOFxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G4bHigcV6TfacjlP+J9yIdlmiukKhTP1lCvMnotnm0Q=;
 b=VNREE3226ivaVL8M4y01HmMl5biqz436BkXCZ9DRXI/pVAuMapnVs7ZKYeSERqNXK00r2w1Li91WJg+QdseLucSWHwQQHObxj0eczLnTryMArlzQ+u1zuSckQViLAqRN1R511ZkhkF3y3G6wwYAhLjqp5SPHHbKJM8fp9Wn28E0DBLynkk8mUQMpIoVpvDahqYV9HqcEYKCEWH23glng7eyud1qOnEd0YiWQH4nTPthzg1KRQsCfy9Z/0ZzikJRO+vri+WFJokZQZdToDfRTrq8kl6QmNSE8a3+kCP+ool49457w//eOd4PdYEErXpg4WXg4olUDKgnXf8tncNGvFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G4bHigcV6TfacjlP+J9yIdlmiukKhTP1lCvMnotnm0Q=;
 b=gNTTf9mRO1963QBbLqM9Meb8KiPGwmTlUxKnTWyP//EB9hhstLWc8VaJ70pR1ySUGzyQ+6mCrg8Qn9F4VahUZ54LLgYcmMuMOGdBMm0XTeFQp+H5DwSULCff3VS2ZC2n//mOtHMsfLNwd0/J2EBLHIjd9I1GCOO87t1f/JOWr7pOHIsTAqQbvAIjhsufCU3sUW0zRD7sEy031Jfi0H/3ABcGCzs3+GrMYKp/Snai7bjTZAXUfxyvKGRXoPBbMnsXjOOdIHFNzx9ubJD51qPyf7mBM8Jiz4E1DX1Kp2ZFbxc5euMuP42oWv0lWYdeQWIeV5UoC7Jpqvclca9ew8GWyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR1201MB2490.namprd12.prod.outlook.com (2603:10b6:3:e3::20)
 by BYAPR12MB4693.namprd12.prod.outlook.com (2603:10b6:a03:98::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Thu, 12 May
 2022 13:02:28 +0000
Received: from DM5PR1201MB2490.namprd12.prod.outlook.com
 ([fe80::e4a0:43f3:3009:bafb]) by DM5PR1201MB2490.namprd12.prod.outlook.com
 ([fe80::e4a0:43f3:3009:bafb%7]) with mapi id 15.20.5250.014; Thu, 12 May 2022
 13:02:27 +0000
Message-ID: <4388c144-1b1f-6364-233e-07ea11c4d303@nvidia.com>
Date:   Thu, 12 May 2022 16:02:20 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net] net: ping6: Fix ping -6 with interface name
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20220510172739.30823-1-tariqt@nvidia.com>
 <c083d69e-2310-39d3-960b-1971f095463c@kernel.org>
From:   Aya Levin <ayal@nvidia.com>
In-Reply-To: <c083d69e-2310-39d3-960b-1971f095463c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0039.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::27) To DM5PR1201MB2490.namprd12.prod.outlook.com
 (2603:10b6:3:e3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd341e48-0c97-48be-bc32-08da3417aa77
X-MS-TrafficTypeDiagnostic: BYAPR12MB4693:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB4693A222ACAF795CDDC6EBD1BDCB9@BYAPR12MB4693.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fEIeMbSaIBFrvGiiBAiSDnA4kbh7OtaMxlUqR30B4A4GLhxzwQLYysqr9sgcLrAxgPViQiNQLYN8tZIgi9v2DUxrXKMnBRmEKzNjJ3aSDiYi44Wy2wggsI8fXHEpr3jH7/WSddVGuaJyne6vJhIKETHtL3qs9z8JrTyYzY2ZPbFiQJuef+DEypZTBmHlrBtlYOxnB2ea0l1seWC5jZ9YPc2KAKd829qzKLTTG68hetC1meot01aaDTy4GNwFpvBZR0Bjq5uxTDz/5l6rfLhbwSR9KIJqPgU7UdUoEr4zSLknLcED9GCjC0sU1go7O39vDLVDDjYokP0dEk9xe/giceX95ezcBqNwae/LJbhbI43H5oRJmQgQV1aBagsxnwa07JZQpzhXpOe9IQJDnvFKh+zig5tqwdBOUb8PLntb/KinTCAtPyA81Pgy2D/+X6gXeLVjekiOWcUOvpvJWRcWJaeG2U8y3YVARnHeNtAdN5jO6IPMG8/UH3ZAFfdFUk4fF4aIi3mP9jJGMdVJEkp9xGM4WHde2QdfB+Kbp3Kaa1XGfCqdD75RpAFhrIsTwxzZwGTy84msjHjFIOViUUOC5Bij1lLTW4wrfoef0GvsswUVQDCvH+py9psLfu8wiyPCyATncjG9p3eEzqhqgE3QBRrVASQzMqJP0nmjQSsEeyr7wmzvo/bz53nnSa2evtRlPEaQqQKhs3lcTthOJNMegf501me8Sv8OECalzGj3zm0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB2490.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(26005)(6512007)(53546011)(8936002)(5660300002)(110136005)(6666004)(86362001)(38100700002)(2906002)(4326008)(66476007)(66556008)(8676002)(31696002)(66946007)(6486002)(31686004)(36756003)(186003)(508600001)(2616005)(107886003)(54906003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bk1wZjViR0ZNQ21kK1Y3ZWJZRWprd3ZsbzJZYWx5a1Ewc1ppckpuTGYyNkpW?=
 =?utf-8?B?cjZIR2xXU0dRY3lKOERnVGVNVTZPSmxqampPSzh3ZWJXbjduSUlENTBGbjJ6?=
 =?utf-8?B?eGxlQ0p4MkFGY3VyMG9vWnNUbng1TlB0YXloM1BQSHRyNXU3NlZSamVFZUFl?=
 =?utf-8?B?cXhWalBmZzFKaUdQQ1ZrMUpWUEh6TnhhV28zbk12bks3Sm9pUWRkYTVSN1F2?=
 =?utf-8?B?aU5QZldFSG5WdFV0OElZMThEYVhvWEZ5MHZ6VUJTUkpJeXNYUktDZWNINVJY?=
 =?utf-8?B?dVRLbEZYVmJPczdMY1pkK3lqSmd1am11NFY3M0QveVVlMXFoYWlCcDFOZFVr?=
 =?utf-8?B?Q0pHaEVQYlkzVThseHZwK21kaDlNcUlNNmlSSTEzWHhuRElaeUZid2prTWhr?=
 =?utf-8?B?dlNTOEFyUzRyRVdUTlYxRDFaWG40eGN1TzM4a0VzT1lGQ3ZuQTNtaVA4bnd5?=
 =?utf-8?B?THBCbkw4UWxZQkdKVWtEcDhVSjFYTXRKNEJaTjdoTUw1eHRsWk9RM3lJREtk?=
 =?utf-8?B?UUhFbldOY1RCcDV2dGRIQVJIbGtJMDExUkgxTzc3TG1sVWF6QzV1aVdhaTc4?=
 =?utf-8?B?NlJocnJldGpqdENyeHBQeXA5Qkd2RGpxN3dOamNzeGxDVzBnUW52MGJ6aCt0?=
 =?utf-8?B?N3ZNWnQ2c2l0STZHa0dwcTltdmlsMDRxSGpBYXVqdTUwVGpzS0pMUmtBYlln?=
 =?utf-8?B?aVhmNjc0WFdBTHY0ek1TeTN6ZXU4a3Bhb3pkS1ZNNFdoRmg0VVBselJGcG1z?=
 =?utf-8?B?YmVDVDdKY2pKSlhoazNOOURLc1FnK1FlZUxHOVhvQk9CQU52dlJEVWN3SFFX?=
 =?utf-8?B?Ykx2c0ZPcnlidEl0eDRBNHkrRk94cnlGVlVhc2NjcDhRR0RmRERqanBONEUz?=
 =?utf-8?B?eXpzU0R1M29kSFVRUlpEU1BDV0oyZnYzM1MwSEsyeUlGL0xJbldtYzMwTlF1?=
 =?utf-8?B?WjExZDhMOGZ6SEZqZG9xVUl1dVpDem5mR0c1dDlyanJKS1NrR1M3RXhxK3Nl?=
 =?utf-8?B?a2dGbVJFSUhvR2cveTJCb2llYnlKL0tyS3Y5dWcrWmszUk1vd0tkRFA1b2dD?=
 =?utf-8?B?WUhvL1JTMnpSSDIyMS95Um12dWFYcGh2cm96ZWkycXhlN1EvcjBObDF5dEw5?=
 =?utf-8?B?QzVmU3pUMUxFWjI5OXRuaDJKd0VNN3pHVEMwSVVvQWlLTGJRMllRZytia3hU?=
 =?utf-8?B?b3FpemJvWGY1MVE2RHFORnJ2OVZKczAxUU5HL2tMMTY0VU5GZS9USmdQcUI2?=
 =?utf-8?B?UUkveFhyNXJWOXp5cFpzaDY4WGFiZGRhN0pJNEY3WXU4N3h0U083QWNzWDJD?=
 =?utf-8?B?eklzeFVacGF1dkdXNG4yV1dFRnV1aVh5dWU1YzAvcWRseitkd0o4dnMzNFI1?=
 =?utf-8?B?YkViSXJkeVBOeUpKamlmREl3M0w0UjhDTWk4RUE0S3hIZnRJWmcrWmFyZm54?=
 =?utf-8?B?VWV6MVg3QWVZdHhYaGVmbmM2UkV2aEM2dnZIUGhXYk03Q3ZXMHZGUk54Ukpz?=
 =?utf-8?B?MWhFSVJJdWdhbkpjc1dmVkQ0VzNNRkNiNXlQdURpWGMzRWZyeTUxSzZiSGFK?=
 =?utf-8?B?cTE0R3MwN3IyNTJGUXYxVTVIblU3d3hiVlV1cVZ5S2pTTEtLbW5rT1g1MW54?=
 =?utf-8?B?endaNkhWMVdRRlZ0QWI2OUNJLzhGbWJzZENZQmFmRDVETG1qUU42elVlWDNS?=
 =?utf-8?B?WUVqd2c0Ni9hNEJ2akhReXQydjRuSHdoSGhHQTNETUpUVkJ1VXpPZ01zRXda?=
 =?utf-8?B?SU5FKzB4QUd3OEd1ZXliQjdpang0WEV0ZWVYL3pkNFBQcVVnOXo1elNRNWlI?=
 =?utf-8?B?d3FMSFZpWWwzM2M1UXhKbDQzVUZwZ1YvS3NiM1J4ZGhiQ3dDRHJpRFVDeW9J?=
 =?utf-8?B?Z1RFQ1RZdmx2WkRjSlFxblRkMWJqTGh3bFQ0azFoZXQvVXpMMnNpeXFpSjgv?=
 =?utf-8?B?RTlZQis3UUNETFFneTdMenlUU0RoSzYxY01lVGVQdVN3SzE1YjQ3YlBTWi9O?=
 =?utf-8?B?NUVrRG50Q0JtZ0dqK043dHNSeXlaYW1mZmI0N0ZFY0xHS0JucUpuVjF1NTRU?=
 =?utf-8?B?b202M09wUXdmVGhuUnVxYjVUdVBOTzVleHB2VkNzRklZQzhGcCtJdXlDdnJw?=
 =?utf-8?B?N3N0L0llTXFOMGhyUTNybjB3WEdjTTVocXdHS1owcllmamhZVnRUNyt0OHp5?=
 =?utf-8?B?Tk9Kc2FWcTU1UG1UQ1pmcXVVSXppZ1BsRWpsY0RtL0dJMkdKRTFTZnlIL0Na?=
 =?utf-8?B?MEFKMndxeWtPNUovV3NIclV3VW5KdFdOTkw2dG4rVEZUdWtmbnd6UmlSZ3M2?=
 =?utf-8?B?eDZKOVdZcWxzYTUrU29sYkw5VndOUHJHcy9nYjRVcWJYUnNnWlJMUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd341e48-0c97-48be-bc32-08da3417aa77
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB2490.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 13:02:27.8180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7YnJd3OEbBkJFykZExkpIdCtZp7GcgG6Wh7dU6JZz2jf+Nq1DrJN5KAFNei+LWIF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4693
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/10/2022 11:27 PM, David Ahern wrote:
> On 5/10/22 11:27 AM, Tariq Toukan wrote:
>> From: Aya Levin <ayal@nvidia.com>
>>
>> When passing interface parameter to ping -6:
>> $ ping -6 ::11:141:84:9 -I eth2
>> Results in:
>> PING ::11:141:84:10(::11:141:84:10) from ::11:141:84:9 eth2: 56 data bytes
>> ping: sendmsg: Invalid argument
>> ping: sendmsg: Invalid argument
>>
>> Initialize the fl6's outgoing interface (OIF) before triggering
>> ip6_datagram_send_ctl.
>>
>> Fixes: 13651224c00b ("net: ping6: support setting basic SOL_IPV6 options via cmsg")
>> Signed-off-by: Aya Levin <ayal@nvidia.com>
>> Reviewed-by: Gal Pressman <gal@nvidia.com>
>> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
>> ---
>>   net/ipv6/ping.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
>> index ff033d16549e..83f014559c0d 100644
>> --- a/net/ipv6/ping.c
>> +++ b/net/ipv6/ping.c
>> @@ -106,6 +106,8 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>>   
>>   		opt.tot_len = sizeof(opt);
>>   		ipc6.opt = &opt;
>> +		memset(&fl6, 0, sizeof(fl6));
>> +		fl6.flowi6_oif = oif;
>>   
>>   		err = ip6_datagram_send_ctl(sock_net(sk), sk, msg, &fl6, &ipc6);
>>   		if (err < 0)
> 
> I agree that fl6 is used unitialized here, but right after this is:
> 
>          memset(&fl6, 0, sizeof(fl6));
> 
>          fl6.flowi6_proto = IPPROTO_ICMPV6;
>          fl6.saddr = np->saddr;
>          fl6.daddr = *daddr;
>          fl6.flowi6_oif = oif;
> 
> so adding a memset before the call to ip6_datagram_send_ctl duplicates
> the existing one. Best to move the memset before the 'if
> (msg->msg_controllen) {'
Hi,

Thanks for your comment. As far as I understand the flow, any changes 
done to fl6 inside ip6_datagram_send_ctl is to be disregarded. That's 
how I understand the comment:
/* Changes to txoptions and flow info are not implemented, yet.
  * Drop the options, fl6 is wiped below.
  */

Thanks,
Aya
