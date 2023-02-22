Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E0D69ECBB
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 03:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjBVCLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 21:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjBVCLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 21:11:16 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2101.outbound.protection.outlook.com [40.107.20.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46AA6265B8;
        Tue, 21 Feb 2023 18:11:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lmG0TzSrAfr9bdXe4Wc4TI3vhWCBDRbHbofnushr8huRxG38IpJmgwWlodEE1Kh+aWY5TchcIzwW6xljYzuwWngXb2mL+Z8TALxDAAM85BnY/vPvUxvJumlceEUP1XqmEsY9iZqmVbUoV2dsE6K9jM3J0xKbtumZxV0C9jX/LwG9jY/Xl86iz0IRu8Em+T22MoQZ2zGMkgBTsTUj3aAAJXyrxhKN23Fyg+i1lKiG1SyiXFcBqeCjCKf83bskTIJQPlw5+o22iPx7bjA3CQV7YpNuwGPlbEhpy0YSs1gl5N7aWABiY2Ue/zLzHAlY/GLFmiU/8V/BpXEXHDnu5uTdIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1wBL5fKQFiYYVV8qzRJOYjNH9VpN4TeFW7rrum0T/2A=;
 b=EiBQf2sbEstfqYW5fIWDaaMukKd+WeTgefXU/YHgSEBM/+pivhemtkRUAzVvUPyix2YbzTyq+T4yFifzsR7Eg4IcJa1oi2JvekToOVQonWj4Lh24Oe8qez+ctCPJAF3jAbAskY/Q0dxtV7D5+CNlZE/4EyKwnZ8pbldMEDIdaEWXPRQgHorteQ9iaJDs8kVj98ktXuczkhdFchZTUgjMM5Efb2Nm04BlAL+F1sipjkbC4p1tTt6uX1EV5ss8JIJg0mFe8RcK9VloRWd9XM8lM/9CVbW5lRu3JvTvlD7+UR3dYN9V2HogyZ04+KCzxCY3w9Qm8Gq8z0VVVnV71G7D+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wBL5fKQFiYYVV8qzRJOYjNH9VpN4TeFW7rrum0T/2A=;
 b=W8Ncgx4ef0Vqcr7P6hH4NPR9PbMUDVtsonpZFIjtRc+jA9uCNCcWrwB+MGDucBNXk5BS3Js1xs8WU070MBSlK+lhU8+8smGv7FZXWQhQwaaYmpYbCBy7EnN0TsTUTujm2pGNxQXbHiS1uhq2Zq1Z2pWfiWQBcjRjOn4famgGYqeRgke8qK9GKkGKpyxLU1cw6qx7Nc9W+HxkCE2Jw+g1HTDMU3Lid7W9SCvCiDHgvaw36/Zr7VyAxbyZ+NtTXESWk/Xvh6l55oYTyybZ37gO/Yda/pPiQxZniob8/efDdusFkPFkZP0GwBTsEaUHTwPJAnA47n/RGOc/PeRDWlmJAA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com (2603:10a6:803:114::19)
 by PAXPR08MB6414.eurprd08.prod.outlook.com (2603:10a6:102:12e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.18; Wed, 22 Feb
 2023 02:11:12 +0000
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::468a:8a3d:8bd2:6f5]) by VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::468a:8a3d:8bd2:6f5%7]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 02:11:12 +0000
Message-ID: <4c6e6b8e-1d0c-2893-f4b9-ea40170cacd6@virtuozzo.com>
Date:   Wed, 22 Feb 2023 10:11:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] netfilter: fix percpu counter block leak on error path
 when creating new netns
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@openvz.org
References: <20230213042505.334898-1-ptikhomirov@virtuozzo.com>
 <Y/VS7okXF1c6rN/I@salvia>
Content-Language: en-US
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
In-Reply-To: <Y/VS7okXF1c6rN/I@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0073.apcprd02.prod.outlook.com
 (2603:1096:4:90::13) To VE1PR08MB4989.eurprd08.prod.outlook.com
 (2603:10a6:803:114::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR08MB4989:EE_|PAXPR08MB6414:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ba3363e-8b88-4347-f432-08db147a11b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W0WN2UIVXllcey78tkF3ehJZNUZ52UeoXWVYzsSseeZOVARLzQG3e9qAwLcQuMdERSKZ5c4tgWibRMA9CrlMxj6i+YXbK/Ebxiz9+N/fV8eDoQkesq45sbC7b+QUMcIY5a3LzPCMieeN3OOF2Yil4mVT7Hj7+UD5mRxtJjuOW55IzY7sVwtvOhV25CTAO1uVJUc9G/qxA4A1KCActn3fWPB4CfGh1WYfgE2qGCxSzB8q9nanQm4setdEo9XrgES9UdRTgRGaNE1LyLnQcax63/gkpSGQSI2jfw3RpxC4t3+VBbw7CHmb0xiXidteEQDjXce4nf4TENW4LIltyA732SzTijq1YseJOYypuPCp6FqU//G7tDgpVO+o9nMM0YsoTdR6HqJ3Umb7qXYFtx7PkXanx44iT/4AeiMpQsdijRllJbb6xwy25Yxiu/FsmqM9BJav/i+KOFEySxHrjH+BsXRg3WjiI/XMnL7of8UkSGsEUtKTZhKt9eaCsMbZK1a8FklTTbcy3fAn5l/KY2ixIU9bdbPBEa/bVpDVZNsr3aAdo3LU6oE423q1WzWbdrAsQvRTOmUZLy41DdksRKtW9Z2e0OgrW7Ov188k5cXK2L+JqCXRf8fwCdXF8pZvDk8BS47PlXHnRH2NSy8Bfwfy97PqUNZs8yZg7/7dHaqYPuNxKOAzT+/59cxwkaMOmF98mhMBwdr8jIV8M79vl5AjgWPIAcN0oPL0qmiOp60brko=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB4989.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39850400004)(136003)(366004)(376002)(451199018)(316002)(83380400001)(54906003)(478600001)(38100700002)(36756003)(2906002)(86362001)(31696002)(66556008)(66946007)(66476007)(8676002)(4326008)(6916009)(41300700001)(8936002)(5660300002)(2616005)(966005)(6486002)(26005)(186003)(31686004)(6512007)(6506007)(53546011)(107886003)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TW1yM2FQNWh1ZFNUV3hXVGlzdFRwWUllWnNUVFd6aXV5ODg1aUkwbG5LaE02?=
 =?utf-8?B?QUJ2ZmtSTXlFdmNiQVFWaDEzMDR5R1ZsQ29SendSYmtaM0d0dGVWWkRoblpv?=
 =?utf-8?B?YXdQeXFqVndJSTI2UWlVTjBOc3hray8yV2pKNFlNcnJQS2habkxBWHpFVzFi?=
 =?utf-8?B?QVB6OTlaZ0Mya3pPQlh4TXZWR1o3YnJtTjQwRWg2MWNlZE9YdVFackhlbHhq?=
 =?utf-8?B?QThiNXNKeW1sOTVKN1lQQXViSGtGbnRlaXBHVWJWem9DcEp4SVdxbEJ6cnly?=
 =?utf-8?B?bGlNODdBUHFyS1M0dEdheitmMy9iS3hQYTBhSmptYmNjbGxpQVJzSnZtbExs?=
 =?utf-8?B?NkVqaVlPb2pmTUlPVEtUMnBoK21wL2t4bXZRS2Q1Yi9TZkxVN3FKTkZ3L2Qz?=
 =?utf-8?B?QmJvVXc1UjhnbTNwZ0dRQjhhdWYvK2dxSDMrK0ExeUpTWTBLeEpUeXM0MTJN?=
 =?utf-8?B?N2Y1ajlCNWkwb2lNb3J2UDQzRmpsZHpOWTdDNTBWN0F2NW5pWU9uby9EODE2?=
 =?utf-8?B?YkJFMEFzcmZ6ckN0SWIrd2dTR1VnR2ZldThwZXN3TDhpc3c1OHQ5cEdyZHYx?=
 =?utf-8?B?S00wNWdDaEFNZ3dkT256TTBGclpmWGdMQlgvaFZQdmFNbkVlVUsyUVNqbU41?=
 =?utf-8?B?Vk5BVWh5VVlWME80UUlrOHJkM0Q1TU9ydmc3T3NOUnhlTUlPNkxvMUxLelhN?=
 =?utf-8?B?YmZ4anl4OUQrQ3g3dnNzQjdJZmRyZnlRRmNCK1JiOS92NGFDYjA3amF1V3pT?=
 =?utf-8?B?aUwvMys1Wm4yQWo3QWNORXdOeGhKWUEvbmFvbEdIVUUvTUdtQm5LeFBhVndq?=
 =?utf-8?B?RUFHOW5lOHZYZTlIK3ZwcU9mZGJBVkVPQkU0V0k4Q1BPSCtlMHNLdW83bDk0?=
 =?utf-8?B?VDNUT0ppWnpkUXlqa3pUN2hTR2JkUnpZeis5aU41S0JqZkJTd2JQUHo4ZTl2?=
 =?utf-8?B?NHFXcjN0Uy9wQkFNWDJjMTM3NUdFRjVGL2luM1R4K3lDRDFhSVh1TTkwKyta?=
 =?utf-8?B?ajVIQmtxUWUwUklFVDFUNGZjd2VZOWxFL3RWZ1d4bUZVK0NUblZkaS9oS0o3?=
 =?utf-8?B?RGxWSXI1dFNqcm5wQVNnajB1cktPQnBBUXNmbE1DRU1LSXo0anFoMWN3VUlP?=
 =?utf-8?B?anlMcnJQMlE2Qlh6TG5MR1Z0S1RJR1c0S3dGV0FYN1dSdU0wOUNEc2IyNi9D?=
 =?utf-8?B?cDRuN2tRdk5rUjFwNm9XUDV0ck0zaG1KNDk0R3R1Z0t2K3lEVGx4L2JPcEVr?=
 =?utf-8?B?M3VkNHZJdWs3dGw2eEhuSFpwTjMxWkwyNnZxSmo1RXE3MStPaFJVQkxpRWJT?=
 =?utf-8?B?ejhpS3liQmo1bi9BKzJtSTJFZW5jRm8wLzRTN2N5T2Y4YlhROGtBZlVYLzZ1?=
 =?utf-8?B?WnZob0ROQlhhQU1NRXRDSnJCQ1pidkxOR3RCNWZMeDhtVCtBc0xtTkJYdXRi?=
 =?utf-8?B?dzZqVTF3TGNFblJjRHUyakhwVnc3ZHFWTmd6QXhwMDFRbmFmZWtpb1JBQXBZ?=
 =?utf-8?B?TkU3S2d4aC9YTmJma1hJb2oxczlxL2hNUSs5aGExMWRZazNacE9jUEdhZm5T?=
 =?utf-8?B?TnNsMWhuUTE2QmVyS0tDSlhmb1AxTU80M0FNMG56YTNWOEFhMUEvK2dadXhJ?=
 =?utf-8?B?TVVrYmJIbHNaTk1Wclc1VGRXYnFvR2d5RW91K09SY1h3TmtOVnlPRWtVZEtq?=
 =?utf-8?B?M1BXdUlyN0krNmpOVWNYdTluVVdpN283QWpwWnVuOTZvanRuOW5QQW8wS2FE?=
 =?utf-8?B?c1hrNGJRMUQ5WWV5WHR3d1BRbndvbm1YdXNSdHdIOW9tZ2toOG1ZU1VlaTBk?=
 =?utf-8?B?WE5ZQ3htQ0Frb1N0ZTRsZ0pDOTY3SWErbE1RQ3hYNzYrbWo5dE4wVUJvNWlW?=
 =?utf-8?B?dnVnZGFUT3hxTzFiZHc1ZklGZGlHeFBxZ3pFcVVla2VwQXp1b2Nuc29Ybkp4?=
 =?utf-8?B?N3ZsSXdSbk02bGlVa2lOczBEOFlVZXRuZjdYNTluN010MEpLNHhROGJNcnNG?=
 =?utf-8?B?L3E2eGVNTSsxNHJaT0FNVkNEQVJ6YlcrTWJ3RENWZkRrNXVpQUJRZ3VFMGxt?=
 =?utf-8?B?NWNOOGxNSXVFWm9BRVZwRDlCTi91c0VUV2ZmL2F3WnRTN1Uya1IzMCtycElU?=
 =?utf-8?B?VHFNaUcyZjlkeHpuaFBWN2p0ZnBCYVFqeG9QNkNpdTlpQW5UVWNhM1J1Z0Q5?=
 =?utf-8?B?TFE9PQ==?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ba3363e-8b88-4347-f432-08db147a11b2
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB4989.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 02:11:12.2000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MT0O0xn7Rb70Ayu+Hb0dMWVFbD+1OkKKV8BVBHvpBqxf1qGeW7uKz2nuH7lJ+bBsbyDsMJ2zbiCENUiWQDhtZF8KUKaf53U+fceSj+Nfzvg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6414
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.02.2023 07:25, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Mon, Feb 13, 2023 at 12:25:05PM +0800, Pavel Tikhomirov wrote:
>> Here is the stack where we allocate percpu counter block:
>>
>>    +-< __alloc_percpu
>>      +-< xt_percpu_counter_alloc
>>        +-< find_check_entry # {arp,ip,ip6}_tables.c
>>          +-< translate_table
>>
>> And it can be leaked on this code path:
>>
>>    +-> ip6t_register_table
>>      +-> translate_table # allocates percpu counter block
>>      +-> xt_register_table # fails
>>
>> there is no freeing of the counter block on xt_register_table fail.
>> Note: xt_percpu_counter_free should be called to free it like we do in
>> do_replace through cleanup_entry helper (or in __ip6t_unregister_table).
>>
>> Probability of hitting this error path is low AFAICS (xt_register_table
>> can only return ENOMEM here, as it is not replacing anything, as we are
>> creating new netns, and it is hard to imagine that all previous
>> allocations succeeded and after that one in xt_register_table failed).
>> But it's worth fixing even the rare leak.
> 
> Any suggestion as Fixes: tag here? This issue seems to be rather old?


If I'm correct:

1) we have this exact percpu leak since commit 71ae0dff02d7 ("netfilter: 
xtables: use percpu rule counters") which introduced the percpu allocation.

2) but we don't call cleanup_entry on this path at least since commit 
1da177e4c3f4 ("Linux-2.6.12-rc2") which is really old.

3) I also see the same thing here 
https://github.com/mpe/linux-fullhistory/blame/1ab7e5ccf454483fb78998854dddd0bab398c3de/net/ipv4/netfilter/arp_tables.c#L1169 
which is probably the initiall commit which introduced 
net/ipv4/netfilter/arp_tables.c file.

So I'm not sure about Fixes: tag, probably one of those three commits.
-- 
Best regards, Tikhomirov Pavel
Software Developer, Virtuozzo.
