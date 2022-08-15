Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECDE592BBF
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 12:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242494AbiHOKrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 06:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242475AbiHOKrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 06:47:16 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2127.outbound.protection.outlook.com [40.107.20.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C85322B10;
        Mon, 15 Aug 2022 03:47:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IOaTuWO7CSz/AZZhw4C4dKeL2PBrXShc+CKR9DsE+oUyssLR8YxITkaSkLfb1912K5xkY5kj5dfBFMnCwaWh4dlH98y25eO4/PyAmb5XViBDom54bfQGa4XdW379CnpInpV+MygxN+QwcLyRmPa9ZtqIHkpZ6vpxNEfqZP6m2esAQaDUxI7ael+Yc41nnK9t5aClw/qflJRdfft6kOKV5BcBm76YlFAU9ctlA5kejCEMWUEwBFoIMfNeYQFtHBar/oROthog+E7fhskIJ1IYp0PjB/Vvyk/lkbxMl3n2DGWJkXCW/rfFR57/keQoa2LGlWdR8L30LQ1JOzDsQPh1mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iR0l6PtMPDqP5Uf6BQAqVEOfcWtGX9UQmK0in4aWUSI=;
 b=eyhocptDtnUiS2NpZCyKIfH11vGDLRpTYfSSUN5lPedtuFwwI5V1e645QGhswKVit8YrDE6qsOPC0BieYWdJMKRqlzazNu9bHnquQZQHS7g7TPQLQvJvhGl6ri2UbbsWIVfet4ypY0G7XiJD6fA1eBjqDBxhwdBmWVmP6MTiNPYBVmT/tsG+vPPWxC2eP9WCUw0bmYmJwWNRWQva0KimTHh8VA5s19IZbWT+k0KAKXthnEh3ni2eboJB1guG5uoNP6MmP1aDVZOPf/1VxwZYwVKy4y9wFSWXRQKL0u8D6/IGFAu3cO5OgFfWE2lmzSmTLOJKea9gEmRvaXxEDCdGLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iR0l6PtMPDqP5Uf6BQAqVEOfcWtGX9UQmK0in4aWUSI=;
 b=nQDmxAdPOvQCeyDpHt9KZCNyvPdVsICHDkvRhTBKFt10kRKfgMp+YECGSxM5xjv9FJigA7ncFZ4VgizZ46Sb+VA37Ynji6KLxIwKRrLlIwmIWZi+gxKLVFceFeEu/czfSC5Z8nX+LnvFuUyXD6nW1ZPk9sxRNdfJbK6nUjAVucmUIU4/X/wyr4mBmpm7K9juQ604SZnHy7O6mQN7Q6dcqc3tTJJoJv8E3z6CfAjYtqmj94tKvC9HkRoOtRFp0dSyC7Gh3lsbbBzHiod8HJDAK1d8Kh0HhMeh4K6PqYBrKUmHZGiITSqpHKQO0syYbEZQHfOqxfC5X61CybmP4k7ayw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com (2603:10a6:102:1db::9)
 by DB9PR08MB6362.eurprd08.prod.outlook.com (2603:10a6:10:25a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Mon, 15 Aug
 2022 10:47:12 +0000
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::813d:902d:17e5:499d]) by PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::813d:902d:17e5:499d%4]) with mapi id 15.20.5504.028; Mon, 15 Aug 2022
 10:47:11 +0000
Message-ID: <e0eccb24-2d5d-f778-aa21-08db1e808804@virtuozzo.com>
Date:   Mon, 15 Aug 2022 12:47:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 1/2] neigh: fix possible DoS due to net iface
 start/stop loop
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>, linux-kernel@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        kernel@openvz.org, devel@openvz.org
References: <20220729103559.215140-1-alexander.mikhalitsyn@virtuozzo.com>
 <20220810160840.311628-1-alexander.mikhalitsyn@virtuozzo.com>
 <20220810160840.311628-2-alexander.mikhalitsyn@virtuozzo.com>
 <20220815094432.tdqdfh3pwcfekegg@wittgenstein>
From:   "Denis V. Lunev" <den@virtuozzo.com>
In-Reply-To: <20220815094432.tdqdfh3pwcfekegg@wittgenstein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR06CA0147.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::40) To PAXPR08MB6956.eurprd08.prod.outlook.com
 (2603:10a6:102:1db::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfae8242-ec5f-45e8-8ae8-08da7eab8251
X-MS-TrafficTypeDiagnostic: DB9PR08MB6362:EE_
X-LD-Processed: 0bc7f26d-0264-416e-a6fc-8352af79c58f,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g1m5c/Pk5lc/AMCujPgJTxdP1Cklx3WmislqD8UyyeWOmg9ugH7HaNpCUyrDEyOnaPo8NbjrYKJicdEWbsJ2dLfF1pg2M2LV7/pGt9yasgf2EgwPeJ70JGJb3M1TsOVSdWHXf9qNEFUmN1lukcCGFOKb7RrBfpHhSwdi1dM60wy4xIqBAmy7cRm63Wmoi6dCGvszOa1IYi/MwGV9PzgZ9a3QHp2e+iiG2hOgTlfJf090XvZMtZtb/xbHmfHw8YkK7wOLTnSRwiKqPM+2qaCG+kg+6Ll7J4QJFQ5WOL2C9K8J8AWGMtGKSWL8lGThS7m6SSsoz2msD6uXbjAkxp6XrncuipDZdadZMpkoRVkNb1H907tGGB9Mu0NWKXqVcgBYtnZC/k7sT6kyXrv7Iwpenjbp/qDrPz4bPy4uTYwy9U/hbo2eFg1qjXcMIuTJMPLoMe00ljJNdeijwnONH8lukVlj/7VWjxluIRIlnyd7tQf42EI0Wix5QUIh7Co4hFHVS9ofn0JJkgEV0UY1AVP/tdJi50HT/TKqW2rr8husP+udHkce7iQbI6P3cyxMcyq843+yIhDooGARz4V77ZVskj5BNoVyzqOU3k9QMTYwixrSGge91YEbJPAAuD9/pPgbpLBiu9oPVoQzfiItkbvtOBwbCCFLmuqaJBGH8F9mO5K1880+bHNUyhaM/vw8UYxwQ5t4L0WUZw0hSFZ7yXzqare9mbG8rh7eqxKf4SzfIHUR5+HrMofQeXYEVMKrqzpRwM+k7X3etmdUo2fgZrm1dgvW6Oh1cmxK89I61ewM3nbBzq6BTFV99tYhmo1rnLlLkS1oYXSmr3pLy1T1DduETO5kbF3bOfaUsCSa93QInjuK/ll6VUFcs32VuPnuX++3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB6956.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39850400004)(396003)(136003)(376002)(366004)(41300700001)(6636002)(316002)(54906003)(478600001)(26005)(6486002)(38350700002)(38100700002)(4326008)(7416002)(110136005)(66946007)(8676002)(8936002)(66556008)(66476007)(5660300002)(2906002)(36756003)(107886003)(53546011)(31686004)(186003)(86362001)(31696002)(6506007)(2616005)(52116002)(83380400001)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEVQZlA4RnhzSnEwVllnaDRzMFBxZ0FnZ0FJNFNJNjRaaVl5T2RMeEs2WjFG?=
 =?utf-8?B?Z3RwMmhQd2I4c2g5bFp3R3d4QXVvenYzMmZxREhnWU00OXhxVE5kY0xaUXlI?=
 =?utf-8?B?dm0yMjdySmZ6TGl4YWlGSFdtb1pSWCtzTGZpdWVuVktEQnd3RnV5UDMwajRM?=
 =?utf-8?B?WlkzSVg5a1JGZEtDR1hwSk1vSjQ1YWZqRXF3QWxnSUI1cWl0cmFCNzVUWHEx?=
 =?utf-8?B?SG1aUkFCdU9aQmVLWHJueUpLaVR3ci8walBsd0VaNEh3dDhaMWMzMElhRWRa?=
 =?utf-8?B?OFBBSVJDVDh6bmtRcGp3T0xFWTJjS0Y2eTExTXl5cCtRc2w3R0kzeHMxNkl6?=
 =?utf-8?B?OERjQ2t2VWoxVFltTjZ0YVcxZmdpcnpoK1Y3UFFRMHVWRUpHSm81SjIyT09B?=
 =?utf-8?B?ZEVSNk5wcXdVNHliWXE3UlRnanlLWjdFY3E0aVUwRVFBeHl4T0FDcm1ycFJY?=
 =?utf-8?B?bUQ0UzZFZ2MwSnpBT1VaY0FoaktLMDl5dVFUblorWHVNMy90bldGMGhNSVZY?=
 =?utf-8?B?VnY5aFB5NjlBTnh5QklnR2ZKN1lCR0NadlBndEUrZ0R3bHFIb1h4cjMvQm1r?=
 =?utf-8?B?V09nWXRIRTdtdFVKNTkwMTlNZ0NyOVMvRXFCUjU3UWlma0xkNk9mRWtIOGN1?=
 =?utf-8?B?bEw0eEZZZkV6c0luVHFVSW4zWkgrY2JuZU1peUE2eW1JMGN1Nndoa0ZSQ2pw?=
 =?utf-8?B?cENISytUTXE0Rkg3VEFkeFpmcFI0Mno0aG55TnUzbEJCMzN1Qkh6MjZsc2dr?=
 =?utf-8?B?WTNnS1dlOWhTOWZqejhuU2JtSGhhWXN0VXFvQmZGNEYzenRiZkNBR0VUa1VH?=
 =?utf-8?B?WU01OGsvT3FsSTRCZXNWOS92ZU5hNm9Ja05DUnBDNVFiWm5UVUJkcGZsS3Er?=
 =?utf-8?B?MEdra1FqYzl1emMyQVEwQnBBcXRuMG53UUlRaXhCQWw2ZnVIM0FKeklmMUgw?=
 =?utf-8?B?RXZKNDExdm54SE1vaHlyR0orSitPVDJ6OHhvU2U5dTZScE8vcmwyY1RwTERl?=
 =?utf-8?B?TWhvV21GR3FhMU9JMGpVWDJkZ05wWCtMK3U2OTNuZG9EUkVRUXRRdVJsYVcy?=
 =?utf-8?B?SVUvWGRlZXRHSlpGcHVnb1N6RUlPanZ2UWo3SVk0RVdTYkRjblFwdi9ReWxF?=
 =?utf-8?B?elpCSERhQzJkSUwrcnVkeVZzbGdsdWMvdjhWUHdjdUR3MVRGU3phMENXUTk1?=
 =?utf-8?B?YXpuSitlWjFDYy96eDlCdWpqL211MTc2Y0M0R2FCVUNlVE4waG1zaitkNXhQ?=
 =?utf-8?B?eWxUVGhOZVh3TjVFQlFFbHRTSHFvTG9FOCtBdkRjT3prelZTbHVRRDVtMTkv?=
 =?utf-8?B?YXkxbU9WTXBZT0tSSElKUEg5L0NZempGL01FL1AyYktjTnJ5SW1jRVVvNnpX?=
 =?utf-8?B?Nks2RWNsRW13aCt2dUNjQk5RbnpHVTJUYysrQnNKeVdNUSs3ZFdrTWJ4WTQy?=
 =?utf-8?B?cHVRK09YRWVjM3N3SmdRWTNQYUQ0ejZvblcxczR5TEVINGlqM0tETXYrMUFE?=
 =?utf-8?B?TUthdXdFNm1YaSttRTdGdHZCc2k3U1VIWm54NVdzV0hwS0ZjUkxYcTdkZ1Zv?=
 =?utf-8?B?ME1Dc1RNK0tCMHZNYk1Qck51TEVYdHd2OEJUMzJ0alJZSGF4T0U2UDNVQm1k?=
 =?utf-8?B?eWtzOEYralNsWjd5dERMelh4N2ZNS2IwZUtPVHN5VGVWVml2T2h2REtzMEhI?=
 =?utf-8?B?WTcxcm1JVkhabmozOU9FOHNMRHBDcUp0YTc5MDYwRUdnQnNDNjFIN2RqUFRR?=
 =?utf-8?B?S3RmZVRRNzcrWUV3aUk4MWwrUnQxVTFVNHdib0syY2lMKzRUZzdEMTNhWGFX?=
 =?utf-8?B?NjVSODR0Zmh5RXhnSWtkQ2JpbG04eDdUWi9OWXZEYVpBNm5aMjI3ZEwyY3Qy?=
 =?utf-8?B?MmgrbFJRdFB1VzM1bDFwV2RjN0RIMW1ZQ3BjdUMvZmZsQWU5dmRpemI4RkI0?=
 =?utf-8?B?OGxMR1ZpNGVGU3FkL29xeTg3UDd2bXRBUFJpdHhabHJvU3dwZG5td3NzQUlM?=
 =?utf-8?B?NmxmQzRBYXdCMmx0UHhQNmR6M3B4RjBmT3M4eTNHbFMzM2dXWW5tK2FKUk1X?=
 =?utf-8?B?MU9aNU5LbXNBVU5pN3BZbThWZHErTTRiejZLc1FHNGs1dldBS1M5U2VsZ2pk?=
 =?utf-8?Q?5rqp0wRe9tA3Edaq1hYF3Jw6K?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfae8242-ec5f-45e8-8ae8-08da7eab8251
X-MS-Exchange-CrossTenant-AuthSource: PAXPR08MB6956.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 10:47:11.8017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iOOLt4vrafyxTIf7IGMX1VLSHto9xEdmlERnx12fZSiCcJhybaU4i3lR2b40ZLdfUo5wDTLHKiAMVx7T+bR8ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6362
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.08.2022 11:44, Christian Brauner wrote:
> On Wed, Aug 10, 2022 at 07:08:39PM +0300, Alexander Mikhalitsyn wrote:
>> From: "Denis V. Lunev" <den@openvz.org>
>>
>> Normal processing of ARP request (usually this is Ethernet broadcast
>> packet) coming to the host is looking like the following:
>> * the packet comes to arp_process() call and is passed through routing
>>    procedure
>> * the request is put into the queue using pneigh_enqueue() if
>>    corresponding ARP record is not local (common case for container
>>    records on the host)
>> * the request is processed by timer (within 80 jiffies by default) and
>>    ARP reply is sent from the same arp_process() using
>>    NEIGH_CB(skb)->flags & LOCALLY_ENQUEUED condition (flag is set inside
>>    pneigh_enqueue())
>>
>> And here the problem comes. Linux kernel calls pneigh_queue_purge()
>> which destroys the whole queue of ARP requests on ANY network interface
>> start/stop event through __neigh_ifdown().
>>
>> This is actually not a problem within the original world as network
>> interface start/stop was accessible to the host 'root' only, which
>> could do more destructive things. But the world is changed and there
>> are Linux containers available. Here container 'root' has an access
>> to this API and could be considered as untrusted user in the hosting
>> (container's) world.
>>
>> Thus there is an attack vector to other containers on node when
>> container's root will endlessly start/stop interfaces. We have observed
>> similar situation on a real production node when docker container was
>> doing such activity and thus other containers on the node become not
>> accessible.
>>
>> The patch proposed doing very simple thing. It drops only packets from
>> the same namespace in the pneigh_queue_purge() where network interface
>> state change is detected. This is enough to prevent the problem for the
>> whole node preserving original semantics of the code.
> This is how I'd do it as well.
>
>> v2:
>> 	- do del_timer_sync() if queue is empty after pneigh_queue_purge()
>>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Eric Dumazet <edumazet@google.com>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Paolo Abeni <pabeni@redhat.com>
>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>> Cc: David Ahern <dsahern@kernel.org>
>> Cc: Yajun Deng <yajun.deng@linux.dev>
>> Cc: Roopa Prabhu <roopa@nvidia.com>
>> Cc: Christian Brauner <brauner@kernel.org>
>> Cc: netdev@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
>> Cc: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
>> Cc: Konstantin Khorenko <khorenko@virtuozzo.com>
>> Cc: kernel@openvz.org
>> Cc: devel@openvz.org
>> Investigated-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
>> Signed-off-by: Denis V. Lunev <den@openvz.org>
>> ---
>>   net/core/neighbour.c | 25 +++++++++++++++++--------
>>   1 file changed, 17 insertions(+), 8 deletions(-)
>>
>> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
>> index 54625287ee5b..19d99d1eff53 100644
>> --- a/net/core/neighbour.c
>> +++ b/net/core/neighbour.c
>> @@ -307,14 +307,23 @@ static int neigh_del_timer(struct neighbour *n)
>>   	return 0;
>>   }
>>   
>> -static void pneigh_queue_purge(struct sk_buff_head *list)
>> +static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net)
>>   {
>> +	unsigned long flags;
>>   	struct sk_buff *skb;
>>   
>> -	while ((skb = skb_dequeue(list)) != NULL) {
>> -		dev_put(skb->dev);
>> -		kfree_skb(skb);
>> +	spin_lock_irqsave(&list->lock, flags);
> I'm a bit surprised to see a spinlock held around a while loop walking a
> linked list but that seems to be quite common in this file. I take it
> the lists are guaranteed to be short.
Within the current code the size of the list is 64 packets at most
(same spinlock is held during packets processing).

Though this semantics is changed in the next patch from
Alexander, where we will get 64 packets/interface.

Den

>> +	skb = skb_peek(list);
>> +	while (skb != NULL) {
>> +		struct sk_buff *skb_next = skb_peek_next(skb, list);
>> +		if (net == NULL || net_eq(dev_net(skb->dev), net)) {
>> +			__skb_unlink(skb, list);
>> +			dev_put(skb->dev);
>> +			kfree_skb(skb);
>> +		}
>> +		skb = skb_next;
>>   	}
>> +	spin_unlock_irqrestore(&list->lock, flags);
>>   }
>>   
>>   static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
>> @@ -385,9 +394,9 @@ static int __neigh_ifdown(struct neigh_table *tbl, struct net_device *dev,
>>   	write_lock_bh(&tbl->lock);
>>   	neigh_flush_dev(tbl, dev, skip_perm);
>>   	pneigh_ifdown_and_unlock(tbl, dev);
>> -
>> -	del_timer_sync(&tbl->proxy_timer);
>> -	pneigh_queue_purge(&tbl->proxy_queue);
>> +	pneigh_queue_purge(&tbl->proxy_queue, dev_net(dev));
>> +	if (skb_queue_empty_lockless(&tbl->proxy_queue))
>> +		del_timer_sync(&tbl->proxy_timer);
>>   	return 0;
>>   }
>>   
>> @@ -1787,7 +1796,7 @@ int neigh_table_clear(int index, struct neigh_table *tbl)
>>   	cancel_delayed_work_sync(&tbl->managed_work);
>>   	cancel_delayed_work_sync(&tbl->gc_work);
>>   	del_timer_sync(&tbl->proxy_timer);
>> -	pneigh_queue_purge(&tbl->proxy_queue);
>> +	pneigh_queue_purge(&tbl->proxy_queue, NULL);
>>   	neigh_ifdown(tbl, NULL);
>>   	if (atomic_read(&tbl->entries))
>>   		pr_crit("neighbour leakage\n");
>> -- 
>> 2.36.1
>>

