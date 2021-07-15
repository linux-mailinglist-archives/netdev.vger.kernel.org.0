Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADD03C9AEA
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 10:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbhGOJBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 05:01:20 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:54093 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229927AbhGOJBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 05:01:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1626339506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hqcna9SWKCnaSj7E4AYJ5gRi+tzyFWaYJmCoWD4nQsM=;
        b=XyXdtEI4wLdi/v2OvXWlBd9Vax9NhC+uquV5VcaHbKa13s3uDwn40uLu5Z89qX6O88t8uh
        WeZ6KLYlyahHeacko0lGZa9SkovtXqzCWZhi0hL9LFwdQe0Xlv7gUaeo3pIWPr5UcVI7TO
        eZZmUN/tUKHFzhZlFhvFZHVJbBVEVTk=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2058.outbound.protection.outlook.com [104.47.8.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-12-tXVZ4WaKNC2_hfP8-HvVrA-1; Thu, 15 Jul 2021 10:58:25 +0200
X-MC-Unique: tXVZ4WaKNC2_hfP8-HvVrA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QdjFV7FlYfK4v+JEVhSoBYia7NdtUMhDjo09orxU4u2qfKjtmTo1XNSFI2la8LWa4e4IOi/a6GWKbm8XglAOA25FdKchK37f24+fyZ1ax+Vk+SisG7unjEs7ZyySLODY4BI7ViGaNpza0ixN8y4toiv5jnaKJYD5rzmB5nyPqxKxg3qmZXZFltvpJc+cOqcC0U8UXApZrgXfxCt2ymMKSIyXS8W50cB5xKby9A6Y+nsvrVSpsyDfC9BcIvbTqZj4MpGmXPHoo0dYjSlANq9Tza0R3OxA/laWXZe7KyQMKxX7vZxewwim2xMQpnTeeM7KYPOyTlG3AG/mqHqQTjihpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hqcna9SWKCnaSj7E4AYJ5gRi+tzyFWaYJmCoWD4nQsM=;
 b=nzShSaCtILwtOhLREh8WOvBQ6Y6BifUikt5N0lkYL6uIVkRiH/2SQ+NJpCVyun7Rp91N8CYT4iz3Oea+AJePZ3PVQ9BAYC60e8K0anUGpn2LaS986SaAmCuaT+d/ncsX5auVs2EAnA3y8JVLPtGE1gS/d5Py7fa78fSti7tVThbiU7i95PiLjLeDiCf0jifWiJ21JiDM+s+Q0DaHgzyZivFntwP6BJ2H5CJt6TDoFlIU9yf6/qMCCZlqO5qSOgapsHRxy+pL1HV40iZsXg5hz6nsnd86LdQv+0RQMhBTPNwtKtYiXlK5eh0UK5Lt3CmSqFVV2eSFhrUKOkJVv3kiSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: lists.xenproject.org; dkim=none (message not signed)
 header.d=none;lists.xenproject.org; dmarc=none action=none
 header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by VI1PR0401MB2608.eurprd04.prod.outlook.com (2603:10a6:800:4f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Thu, 15 Jul
 2021 08:58:24 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::99d3:99cd:8adf:3eea]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::99d3:99cd:8adf:3eea%5]) with mapi id 15.20.4331.021; Thu, 15 Jul 2021
 08:58:23 +0000
Subject: Ping: [PATCH] xen-netback: correct success/error reporting for the
 SKB-with-fraglist case
From:   Jan Beulich <jbeulich@suse.com>
To:     paul@xen.org, Wei Liu <wl@xen.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
References: <4dd5b8ec-a255-7ab1-6dbf-52705acd6d62@suse.com>
 <67bc0728-761b-c3dd-bdd5-1a850ff79fbb@xen.org>
 <76c94541-21a8-7ae5-c4c4-48552f16c3fd@suse.com>
 <17e50fb5-31f7-60a5-1eec-10d18a40ad9a@xen.org>
 <57580966-3880-9e59-5d82-e1de9006aa0c@suse.com>
 <a26c1ecd-e303-3138-eb7e-96f0203ca888@xen.org>
 <1a522244-4be8-5e33-77c7-4ea5cf130335@suse.com>
Message-ID: <9d27a3eb-1d50-64bb-8785-81de1eef3102@suse.com>
Date:   Thu, 15 Jul 2021 10:58:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <1a522244-4be8-5e33-77c7-4ea5cf130335@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P191CA0023.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:54::28) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.156.60.236] (37.24.206.209) by PR3P191CA0023.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:54::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend Transport; Thu, 15 Jul 2021 08:58:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a57244f-81ac-4d80-ec9d-08d9476eb3b3
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2608:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB26081A2A024EEAC4C093BEC3B3129@VI1PR0401MB2608.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sfaXrq3B+9p1PwOuMJF0Z72ZSdXfxgxa72mHSrPEVzvNz5r7pFoDiF71VK57JRdBK6nja9yYPyW3Y1pRYMMrKKFWSG9jmJKY7xSgO6UFI6v+KV0H5fS3krwRkltJvT9eParDcDvL56bQQLtkOSOav9X8X8oWLnnvL8eZUjJdNyuoj3JQs70J4L+HeD0kdQhM39MLe4OenrqvTTVNilzXu9bGeFV7McBaVMLr+dK20Gcdy0CkxfXLN7Y3qeEbtMRnBQzV0lkGEwd4EFl2uuws8NYky4aY1o6VSDtQQ4UDWbCeqYVRuTNNAd6E951NGpNi0k4+WKXZkWDZdBM3L5fJfwb0NgUj9LXwO/FM6VM6G/Fao5YJIQ+oO7GMBZ4I0XtydH02R/ZN8tCz3L3b76v/wi3Vz+LC3fD6sQONQe29SfxqLeODntsKpVxws647ChSSKyu7OMktN0H2Iq3ISi82upX+6kdDk8+7Blct4Y3FcOJeI58KeVYers/MLsmH8sVpHLovyDghc4Hjm2gUHo4iwCShZGOTugLSta5oMgKLMqCBduHiCikt4ZldFUkTX0TeWl2pH+fz3JUWr0DNlBMbIIQWiBlE6e/jCrSu9/fN71gdBzIKJB4RE0VEJ/Sp4VMN+Zm1UcNEWS/R8t8vzgqYRL0f4v31GzXLGJbSH/Dn17c11tPzSzAjgReTSJkyW6CBAO03BHEWs5WJZw7LD+MCXNSEO2nw9L2Gop3ClEZCJyc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(316002)(8676002)(478600001)(31696002)(16576012)(8936002)(5660300002)(53546011)(110136005)(186003)(38100700002)(6486002)(31686004)(86362001)(26005)(36756003)(2906002)(66946007)(66476007)(66556008)(2616005)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHNyYUFVQVpQUjFaOEVTV0ttdTYxRGc5ZzAxUjRGRXhIanlZWWZKVXZWTjh5?=
 =?utf-8?B?cU9Ba1JaWDFsMm5ZcVBLdnpoZGJsNzJQQ1A4RllJWlVXUDdkT1FWVFlCQ0Zr?=
 =?utf-8?B?WkYvajB3d3ZRQmRHOXpmc0p2NWpKM1F6MFJaMURsRWFuem5qSS9lY0phZlJp?=
 =?utf-8?B?TVNmYXhmU0xUWTYxUCtZMmV4TDc3UTkyTUFScmFGMU9JNjRGeUZGV0FRajZy?=
 =?utf-8?B?eEdxR3AyZWN1aGl0WE1DZm90dGdHUUcyVUpXMkZqY2lGZXZISEhucms5bUlR?=
 =?utf-8?B?TzNmOEJ2a3lmNjRiR0FPbW9uMUVaVnAvdTVxSjg3STNyVEZReHZIOENKTjky?=
 =?utf-8?B?UHpTV2luUHJFaFVvc3lOajJMYXNIcUEyaGhTbXN6bm0xUXVVcTZzZTFMeDlJ?=
 =?utf-8?B?Zjd1blNWdGFMd2c2RUtGYVNTZlVrM0VLRy8vZHdQVU1EVUF0WFFWSlNRUmJm?=
 =?utf-8?B?OHhCS0RJcHhyZ0RYSTVFRzVQWnVBYnRCR1V5U0didFc3VHMwVTQvU082aDhp?=
 =?utf-8?B?MGpBVThhSG5YZjBLb0VUWE4rZHJGSlhLYitUU2RnbmszYlJNS2FwSDJVVFpl?=
 =?utf-8?B?Ym5DdXd3ZHF5WU9yaWVTQXFacWxINWlVbWZaaVMxdXJRN2xyRW1EcHY5aHZh?=
 =?utf-8?B?ejFsa2E4TG9Ga0dDTkNCc1RkRmNSNWl2R254V2FudFV3SjM5RXg4emFXZmRy?=
 =?utf-8?B?VG9QeVBVaUV4TlpoMkVxb3R3TkNxajFkQzZ5YjFPSlhPL2tnMlRpOVVrbVhJ?=
 =?utf-8?B?L0ozcXpuV0NWc1NRcXdDOStXT1JnNDQvblFoYlJuVmhWdndKZHUrMThQQXV2?=
 =?utf-8?B?ZEw1QzRTVVkveW1JSmFEQXI0SkRiampBd3k0ZktvUWNUY0oycm0rQ1VGdVo2?=
 =?utf-8?B?UFJ2UEdtcDZ2clI3ODJoNWFVTXZhbkRMRXRaeCs1Y0QvK3htQUs5RjA0dVdC?=
 =?utf-8?B?SWRMMlpLN0oxMjQwSnlqbS93SzRpbFVoeXZnNk56QzlhdWNOS0h5cU5XZEpo?=
 =?utf-8?B?VUhBMW9iaEdMWjFORHA0S2tRZFREbEJySDRVK0RtK2V2c0JFM3pQVFVsbDNJ?=
 =?utf-8?B?aVh4RDQzT3NmbW5YcFdOcHhZMWZlbzVrUkFLcnBaU0R0SUxaZWVab2xENWlh?=
 =?utf-8?B?cUJKK3dWcnpqZkFHWWRxSEpYMXh3VXJlcTl2T01RUnZvR0t3SU5CZldyL3Fl?=
 =?utf-8?B?QmJlYURDcUlhcGM1RlU0RTNDa2traGlaUEhUb2JlNDJpa0hhNTI5cUhGb0ZR?=
 =?utf-8?B?U0trUXJpZFBGUkk0ZEtteG9yVzNHeVpWTmtZa3JoQ1h3MmdGUDNtSlZ4OCtM?=
 =?utf-8?B?UFlTN1h2OHNCeGlQMWVTdVhJaXlWWm9XSWphalp3RjFibGZNOGl1RERUNVM4?=
 =?utf-8?B?T2VuNVNDelBEZmo1YlpkQ2MwVEZXbXJobnQ4NWZlWDQ1NmY1ODFtajh4VW4w?=
 =?utf-8?B?eXRBcVNnZVdWZzlldmxLcTdUcDdCYWNjMW05Z0dOL3QxM3RPb0FvSDVqdlly?=
 =?utf-8?B?MDlIUkIvbnN3RC94K0dZeTBoRG8vM1cwdWUwUUpJSmZUWmRmaXphVDVkY21Q?=
 =?utf-8?B?a2g3c2QxOEd4dm13WDhuQ1k5R2tmVStmQjBGMk5UaGEwNll2eERnRmpoOXgx?=
 =?utf-8?B?a0hiaDM2UmQ2OVZCQ2RrcWYzRlp5UWZ3bHFNazNrYndpaFRkMEdUNmNGVS85?=
 =?utf-8?B?TE1PRXRzcm1GTmF2bXpMSnl0bEZUdzBvWjZiWFhXTjZocE9zY3ZDbzN1dnRS?=
 =?utf-8?Q?jnSBUn2wO7zBGnIA0UgJn5hKIWGYXfeHzcmG1qT?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a57244f-81ac-4d80-ec9d-08d9476eb3b3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 08:58:23.8412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AB9GG8oRwou5ZfRlk+cBf8C7KxdBSWQDwvmnJ9akGMeC8F71BhG1A14ovuOWhDfUAs6PDdJho+mbfsnRN+F8fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2608
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.05.2021 13:46, Jan Beulich wrote:
> On 25.02.2021 17:23, Paul Durrant wrote:
>> On 25/02/2021 14:00, Jan Beulich wrote:
>>> On 25.02.2021 13:11, Paul Durrant wrote:
>>>> On 25/02/2021 07:33, Jan Beulich wrote:
>>>>> On 24.02.2021 17:39, Paul Durrant wrote:
>>>>>> On 23/02/2021 16:29, Jan Beulich wrote:
>>>>>>> When re-entering the main loop of xenvif_tx_check_gop() a 2nd time, the
>>>>>>> special considerations for the head of the SKB no longer apply. Don't
>>>>>>> mistakenly report ERROR to the frontend for the first entry in the list,
>>>>>>> even if - from all I can tell - this shouldn't matter much as the overall
>>>>>>> transmit will need to be considered failed anyway.
>>>>>>>
>>>>>>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>>>>>>>
>>>>>>> --- a/drivers/net/xen-netback/netback.c
>>>>>>> +++ b/drivers/net/xen-netback/netback.c
>>>>>>> @@ -499,7 +499,7 @@ check_frags:
>>>>>>>     				 * the header's copy failed, and they are
>>>>>>>     				 * sharing a slot, send an error
>>>>>>>     				 */
>>>>>>> -				if (i == 0 && sharedslot)
>>>>>>> +				if (i == 0 && !first_shinfo && sharedslot)
>>>>>>>     					xenvif_idx_release(queue, pending_idx,
>>>>>>>     							   XEN_NETIF_RSP_ERROR);
>>>>>>>     				else
>>>>>>>
>>>>>>
>>>>>> I think this will DTRT, but to my mind it would make more sense to clear
>>>>>> 'sharedslot' before the 'goto check_frags' at the bottom of the function.
>>>>>
>>>>> That was my initial idea as well, but
>>>>> - I think it is for a reason that the variable is "const".
>>>>> - There is another use of it which would then instead need further
>>>>>     amending (and which I believe is at least part of the reason for
>>>>>     the variable to be "const").
>>>>>
>>>>
>>>> Oh, yes. But now that I look again, don't you want:
>>>>
>>>> if (i == 0 && first_shinfo && sharedslot)
>>>>
>>>> ? (i.e no '!')
>>>>
>>>> The comment states that the error should be indicated when the first
>>>> frag contains the header in the case that the map succeeded but the
>>>> prior copy from the same ref failed. This can only possibly be the case
>>>> if this is the 'first_shinfo'
>>>
>>> I don't think so, no - there's a difference between "first frag"
>>> (at which point first_shinfo is NULL) and first frag list entry
>>> (at which point first_shinfo is non-NULL).
>>
>> Yes, I realise I got it backwards. Confusing name but the comment above 
>> its declaration does explain.
>>
>>>
>>>> (which is why I still think it is safe to unconst 'sharedslot' and
>>>> clear it).
>>>
>>> And "no" here as well - this piece of code
>>>
>>> 		/* First error: if the header haven't shared a slot with the
>>> 		 * first frag, release it as well.
>>> 		 */
>>> 		if (!sharedslot)
>>> 			xenvif_idx_release(queue,
>>> 					   XENVIF_TX_CB(skb)->pending_idx,
>>> 					   XEN_NETIF_RSP_OKAY);
>>>
>>> specifically requires sharedslot to have the value that was
>>> assigned to it at the start of the function (this property
>>> doesn't go away when switching from fragments to frag list).
>>> Note also how it uses XENVIF_TX_CB(skb)->pending_idx, i.e. the
>>> value the local variable pending_idx was set from at the start
>>> of the function.
>>>
>>
>> True, we do have to deal with freeing up the header if the first map 
>> error comes on the frag list.
>>
>> Reviewed-by: Paul Durrant <paul@xen.org>
> 
> Since I've not seen this go into 5.13-rc, may I ask what the disposition
> of this is?

I can't seem to spot this in 5.14-rc either. I have to admit I'm
increasingly puzzled ...

Jan

