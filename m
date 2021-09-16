Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C219D40DE64
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 17:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239612AbhIPPrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 11:47:23 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:33699 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239253AbhIPPrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 11:47:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1631807161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0yDVeRNlDDrwVTmm+uLJzYWe4+HRUO5u12ZGOtIo0O0=;
        b=MFXTi36bETzJrndYXclggUrSb/Ko+VvAZ6LsAxaWBVE240BvT0NUzhMyVl42YbUm8FB73C
        YExH3L7pS0Fb6cTJGCxN/J55nBc/MloetdqNIEJj/jihIWrh2BINVduyqb69Me9eegofUg
        nsjZDqrSPSRuPalc8KngOeHklDwNqcc=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2107.outbound.protection.outlook.com [104.47.18.107])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-8-57pnKs7GOdC6qvlBTufvuQ-1; Thu, 16 Sep 2021 17:46:00 +0200
X-MC-Unique: 57pnKs7GOdC6qvlBTufvuQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jpiQ8Vd4nU83PtalOUyyEHBeQTMw1MbVGJS5QrMHL3Y7nkVl3IMVpAQgm13wq3D64FuxmMdctFzRjXkV9PmLtzuBf17zcrdWHnuzUGz1hUvFn9M/OAgmLufDu9Rznv9Q++PO8NBNKviaxDhIa/RpG3kSXB7mHKJCzaVjamlYSLtXEUqHGNK6Scw1Yfbzbj40rTkjPyQ/isRiooEEDKWHxUOmCDEMObjvWIW0SLTcjekqIikDXi8dJstu2aGLZbCD2iFkLFSD9obDwC0cFUGY75+aVs6FbOV4taRdWizE0jqpl1v5JLdQ7vEYnBvY9ji/477a1qc4wSYtQDZjiH+9lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=0yDVeRNlDDrwVTmm+uLJzYWe4+HRUO5u12ZGOtIo0O0=;
 b=STkNGivzQfVM535X4cUbeQBbvMP4Ip3tJb9UrMyLdkD9X7CgHU/3/VK9ggKySdRROumP79+U+LRZYyEu+FOMAta82sRUhlcsKgq8IaPguQPBJTLOteJ6dEGd3D3pB2fPKZbwN4SrqVazRIwCDkO8xWzKQnDguOcWj2Qlw8s6ABLnR8xGGJifJ4UfgTGgoIM9oImfpQ94H7gN9a8CtaqUS6LU5PAJBSxYBZNKcjgu7X9kTtrSbipGAGZr2vp3x1+Lp0YZH0hLbZJvIw9XKKPXbSLfellxG7MLqkWc9xxlcIlHmfHDPmt024N3cmQSnzR5/dog0HHH/cNP7n/AJA8W6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by VI1PR0402MB3934.eurprd04.prod.outlook.com (2603:10a6:803:1b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Thu, 16 Sep
 2021 15:45:58 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::4d37:ec64:4e90:b16b]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::4d37:ec64:4e90:b16b%7]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 15:45:58 +0000
Subject: =?UTF-8?Q?Ping=c2=b2=3a_=5bPATCH=5d_xen-netback=3a_correct_success/?=
 =?UTF-8?Q?error_reporting_for_the_SKB-with-fraglist_case?=
From:   Jan Beulich <jbeulich@suse.com>
To:     paul@xen.org, Wei Liu <wl@xen.org>
Cc:     "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <4dd5b8ec-a255-7ab1-6dbf-52705acd6d62@suse.com>
 <67bc0728-761b-c3dd-bdd5-1a850ff79fbb@xen.org>
 <76c94541-21a8-7ae5-c4c4-48552f16c3fd@suse.com>
 <17e50fb5-31f7-60a5-1eec-10d18a40ad9a@xen.org>
 <57580966-3880-9e59-5d82-e1de9006aa0c@suse.com>
 <a26c1ecd-e303-3138-eb7e-96f0203ca888@xen.org>
 <1a522244-4be8-5e33-77c7-4ea5cf130335@suse.com>
 <9d27a3eb-1d50-64bb-8785-81de1eef3102@suse.com>
Message-ID: <d4f381e9-6698-3339-1d17-15e3abc71d06@suse.com>
Date:   Thu, 16 Sep 2021 17:45:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <9d27a3eb-1d50-64bb-8785-81de1eef3102@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0035.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::15) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.156.60.236] (37.24.206.209) by AM0PR10CA0035.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Thu, 16 Sep 2021 15:45:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4d0b0b9-5f10-4f63-1b80-08d9792913d3
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3934:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB39349771094D2911C128FFCFB3DC9@VI1PR0402MB3934.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8+YwVhZxphC0duk/+RGgfSD/sqCUsnRQf329P7WCoXMj4/o9/9Hlf7BeCdFQp7wn9N2/LsvsxaqL8A82JR0pVDDiEQlBBULCW3wAeRv7sjdf8Ni7NdV/2xKCjTCwBHSrM62jj3th+KFH108ftH5x+/8kcKeWAAzKvgkkl8CILufgm6HsLgYezaIaEc8w8y5tA/teR5MFtk8Y+dCwhit8e5DbIqtDkf4XLfPlG3QS/V7Tu+wxOzXXYCRHlYKdrv2Imv01YTet6pGaRDi2mTupdh+bLBezH1cM6pbDFWjMm8oms488VDOPg9WyuFdJNZuMfN8m4D91FSnk7zsX82tMQylU9NDW8HTF72s+FIs51hl9F7gAnmxcAqkYLYXAq9Dwa2rZzBB0mkypTxXhycpm7pvOe/YZycQlbusPAosyFWHe5jJHRCGUMhMw9Jp9l+MxKiHgvIJb5qW6QTS5RTK+uR0zq2TImUdfz6Pagup+gHZBZYz+BuTkZiqho536iKZireEdZh6W9dE+pNGLirGDAOYNKU3kgOXPOlSMA3ZVgYx0VaLsN4+eHSldu7vIK4idY7XguANawErLYQIaLmVoTDAfcUrw13aZIkwsuqVCYrYzlg62o/7OTe2+zLwojJrex8bSoTCRyhkH8gmNhJ56nosawWdm0PVD6qKva1BZweidmVDkczWGIzt1KXtExA9BMoWqguTEnvAMmq+sLLRwoOR+9uKCrbzmb9W9r8lYF4w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(376002)(39860400002)(346002)(86362001)(66946007)(53546011)(66556008)(31696002)(66476007)(31686004)(316002)(16576012)(2616005)(4326008)(478600001)(186003)(5660300002)(26005)(38100700002)(956004)(36756003)(8936002)(2906002)(6916009)(54906003)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3k1emhoVTBSTDdPOFRCclUrRUNpa2tneS9GSUVnYzBlMjF1cTl1L2lNTWVU?=
 =?utf-8?B?aU4rMURwR0pIL1ZLeGE0NGRuZk5LK3poWUJuV2I1OEVXaXJIbFJaV21aT1Z6?=
 =?utf-8?B?OFk3bkhZZjdYeklOaDBqWGRvV0dkK1VLdTFKaEs3TkRUQVFnVjRzdUxxQndB?=
 =?utf-8?B?WXRSV3ZwQXhIT3liQnJjUXJXN0xsNWg5MXBDSlNhVEdzc1NCSG8yaU5IRCtY?=
 =?utf-8?B?SkdtMFVBdlk1N1dhUzIwbFcwVENuY2I3MWIza0d2TVdTa0ovU3JrekFPUjRr?=
 =?utf-8?B?YlNXNXk0akNLRmY4d3lEU0x1ZHlSZU1zQld0VUJKU2h1NzFZMTFkWWFqWGww?=
 =?utf-8?B?RHF5YVIwOVNWSW0yK1lQQ1V3LzhMd3JPWCtwdmQ4SmsxZ2N3cGtXTi9oNHEx?=
 =?utf-8?B?S1B1REwxZVdzZHRjQ283WXlLSXBMbm43TmRrNFpHWjZOZkI3NjBHYlQzeVB5?=
 =?utf-8?B?bVhjdVVMZWFGSUpxRCtOTTFXbWhqMEdQYTMrVGZNRW9TRGl0ZjNTcDBlVm1G?=
 =?utf-8?B?Qjc4VkhLOVpobmk4d01BK0hmdE5JYlh5d2ZyMWFZOFN6dk1VTHhlZUVlUk9G?=
 =?utf-8?B?MEdEQWhQUFB0NG9GZmRheUVnMGJCZjh2azAzcUFlbHJ5MTF1YjFCUmdTV0l3?=
 =?utf-8?B?c1RIc29HMDZubUxDZTc4VjdDbU93U0lQTDgweTRWbjdONXlHaTAzVmdoNlV6?=
 =?utf-8?B?ZEJEanhmQ1kreFUyVmVaU0w1TmFmL1N4K3l6Zm9yM3krRnlURkxFVnVFdStj?=
 =?utf-8?B?TFB6OU9zSHpCTStqbXpLSkxNTnNUQ0NvSWpFeFIxdmNXUGZEekZoQmtoUzk1?=
 =?utf-8?B?QW9KVEc0TnZ6N3pDWGR5ZGJpbjFlckRPQVJkMmNnMklCYTJJN3ZJaGF2Tmhp?=
 =?utf-8?B?bkp3WXF5M3IxTjRGemF3Z3gzcFp2TUl0SzNlRFRzRlJCUjlZT0o0TUdZV3A5?=
 =?utf-8?B?M25JdXRJanBOa1UvQ0hQWFRqRS9OcDRna3VOOU0ycTRTMlJQL2NpZUhZcDVt?=
 =?utf-8?B?TmVHWS9mMlF5K1lob1d6UExDQlE3WVVuMkRmTE1iOVZFcndpTlJESWlLV1lM?=
 =?utf-8?B?QVM0YWNQK3R1NzF5Mk91UVZyOTZ3dmZocHc5bGFVZVBvUENQNnJDT2VWYXov?=
 =?utf-8?B?L2hRcklkT2NseDZNVm0xVGV6WlAwMW90YVl3TWNrUldsRDIrd1VTeFBNaG84?=
 =?utf-8?B?NXJzeDN5Ry9LRXkrR1ErZFpESjZzZWlHZG1idnVBRGRCOGM3OUFSZ1MxYnc3?=
 =?utf-8?B?N3ZGM0JWd1lBOWxjSVl1aFFlQU5uYnJQdHg2WERlMS9jYmEvZGZnQlFGM2dX?=
 =?utf-8?B?NnhCMExvaVBnZnEvV2wxRmpmLzZZMGl6MmRmTG5jcklwRVRVa2M0dXF4eW1S?=
 =?utf-8?B?TkNFM29JeWNHaTd2NGQ3STR5bUxnK0VNMW02bUpxUXFBcDE2aUJZakFyK21p?=
 =?utf-8?B?NVdBMHQyUHIvU0R2alpGNmFyMko2VE9za3hxNHloV2hxYTg3cGlFTXM2Mi9S?=
 =?utf-8?B?aUJRYStCeXN0bjMzUXlldGpReFBvNTQ4KythVllWUmVsdUVscmRaaFJnREVz?=
 =?utf-8?B?dmQyVnFrR0xJUU1Zbzc5RXQ5aEEvQS9TWk5ocE8waUdKZ05ZUWhia2ZkVWJD?=
 =?utf-8?B?cWtqdnNuY3dNbmdabkJHbzF2SXNMUUdVWkJZRWlzTTR5MWUyd2Z5K2cvMFZ0?=
 =?utf-8?B?THFKdW1ZeHNuT2Z1d0FwWkNQOWhaOFptWTBhTGtjOHlwTDhoUzBsWWxMbVlh?=
 =?utf-8?Q?xaCJirdazdFrPhWAeeYatG702CahhD/CYdFGjds?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4d0b0b9-5f10-4f63-1b80-08d9792913d3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 15:45:58.4087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nc6agaP1m7mYXw++eJsHXhY0r54exClQIvAdsMSGacO5FA70+DRixO8Bw1hcFlfyAET+kQvfxLcI3kABDKi6bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3934
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.07.2021 10:58, Jan Beulich wrote:
> On 20.05.2021 13:46, Jan Beulich wrote:
>> On 25.02.2021 17:23, Paul Durrant wrote:
>>> On 25/02/2021 14:00, Jan Beulich wrote:
>>>> On 25.02.2021 13:11, Paul Durrant wrote:
>>>>> On 25/02/2021 07:33, Jan Beulich wrote:
>>>>>> On 24.02.2021 17:39, Paul Durrant wrote:
>>>>>>> On 23/02/2021 16:29, Jan Beulich wrote:
>>>>>>>> When re-entering the main loop of xenvif_tx_check_gop() a 2nd time, the
>>>>>>>> special considerations for the head of the SKB no longer apply. Don't
>>>>>>>> mistakenly report ERROR to the frontend for the first entry in the list,
>>>>>>>> even if - from all I can tell - this shouldn't matter much as the overall
>>>>>>>> transmit will need to be considered failed anyway.
>>>>>>>>
>>>>>>>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>>>>>>>>
>>>>>>>> --- a/drivers/net/xen-netback/netback.c
>>>>>>>> +++ b/drivers/net/xen-netback/netback.c
>>>>>>>> @@ -499,7 +499,7 @@ check_frags:
>>>>>>>>     				 * the header's copy failed, and they are
>>>>>>>>     				 * sharing a slot, send an error
>>>>>>>>     				 */
>>>>>>>> -				if (i == 0 && sharedslot)
>>>>>>>> +				if (i == 0 && !first_shinfo && sharedslot)
>>>>>>>>     					xenvif_idx_release(queue, pending_idx,
>>>>>>>>     							   XEN_NETIF_RSP_ERROR);
>>>>>>>>     				else
>>>>>>>>
>>>>>>>
>>>>>>> I think this will DTRT, but to my mind it would make more sense to clear
>>>>>>> 'sharedslot' before the 'goto check_frags' at the bottom of the function.
>>>>>>
>>>>>> That was my initial idea as well, but
>>>>>> - I think it is for a reason that the variable is "const".
>>>>>> - There is another use of it which would then instead need further
>>>>>>     amending (and which I believe is at least part of the reason for
>>>>>>     the variable to be "const").
>>>>>>
>>>>>
>>>>> Oh, yes. But now that I look again, don't you want:
>>>>>
>>>>> if (i == 0 && first_shinfo && sharedslot)
>>>>>
>>>>> ? (i.e no '!')
>>>>>
>>>>> The comment states that the error should be indicated when the first
>>>>> frag contains the header in the case that the map succeeded but the
>>>>> prior copy from the same ref failed. This can only possibly be the case
>>>>> if this is the 'first_shinfo'
>>>>
>>>> I don't think so, no - there's a difference between "first frag"
>>>> (at which point first_shinfo is NULL) and first frag list entry
>>>> (at which point first_shinfo is non-NULL).
>>>
>>> Yes, I realise I got it backwards. Confusing name but the comment above 
>>> its declaration does explain.
>>>
>>>>
>>>>> (which is why I still think it is safe to unconst 'sharedslot' and
>>>>> clear it).
>>>>
>>>> And "no" here as well - this piece of code
>>>>
>>>> 		/* First error: if the header haven't shared a slot with the
>>>> 		 * first frag, release it as well.
>>>> 		 */
>>>> 		if (!sharedslot)
>>>> 			xenvif_idx_release(queue,
>>>> 					   XENVIF_TX_CB(skb)->pending_idx,
>>>> 					   XEN_NETIF_RSP_OKAY);
>>>>
>>>> specifically requires sharedslot to have the value that was
>>>> assigned to it at the start of the function (this property
>>>> doesn't go away when switching from fragments to frag list).
>>>> Note also how it uses XENVIF_TX_CB(skb)->pending_idx, i.e. the
>>>> value the local variable pending_idx was set from at the start
>>>> of the function.
>>>>
>>>
>>> True, we do have to deal with freeing up the header if the first map 
>>> error comes on the frag list.
>>>
>>> Reviewed-by: Paul Durrant <paul@xen.org>
>>
>> Since I've not seen this go into 5.13-rc, may I ask what the disposition
>> of this is?
> 
> I can't seem to spot this in 5.14-rc either. I have to admit I'm
> increasingly puzzled ...

Another two months (and another release) later and still nothing. Am
I doing something wrong? Am I wrongly assuming that maintainers would
push such changes up the chain?

Jan

