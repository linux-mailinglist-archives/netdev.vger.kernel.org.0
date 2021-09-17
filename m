Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7739B40F23C
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 08:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbhIQGXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 02:23:24 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:44741 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229474AbhIQGXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 02:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1631859716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CMM/97FhbTpeL+vc4edx0Gfl6KNqYqL9R5Sqa0QJDBQ=;
        b=KgrO33uY8xZ3Aez/5RobpMyaNKOEBm6HTnAuUEjhYWmtpBLvtWxzpTb0mLUeAOf7V+LWH3
        fF3eTX6ASHFaKIwQ2TCCwGGnewr9j28KBPj+5XapMNmESwrbS8R9n35xH48W/Ud/yrNJw9
        qMMHEacAv3IUcZBunIyANtyOWHB6MoA=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2057.outbound.protection.outlook.com [104.47.9.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-6-2XHNJDdAPzOW9fkG3Hlk-g-1;
 Fri, 17 Sep 2021 08:21:55 +0200
X-MC-Unique: 2XHNJDdAPzOW9fkG3Hlk-g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBuDm9U8ePbj6QZONi6zz7a+671/mr88cytxzCnbdnj27mNGUQe9RK8iHGD5io2sR879wht96NfvtZGwkMKSVX+H2EXxmyPvr9KnzlT2Dk57v/IuClk5f433goKkaGJawA3WE1ucj7FqjEDscIXqcsSal8F5sdYbB+GWwpfVK95fJh5EeFuvy3UzpXBy3IwRtBQPtjfdIVnjFtCNCSkh91HbkwkZssQGncqao/ZMEYk+Bx3g6PWgBG/qxlmZCNWFFgCAfyMajIsKrl641uexdRlyZx8LmhtayUe49URNiLAUDVhm6TTjrjPZ1QHZsAxEPqmF7X39SCW9XaWgx7mZkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=CMM/97FhbTpeL+vc4edx0Gfl6KNqYqL9R5Sqa0QJDBQ=;
 b=e07MXve257lbbSQsT3TzrGGxt5aPcRVWE0GB3sf6hbB2i7EllH31r7LBV3z0Q3gg2r0UPEod5BRDlevJap2B+rX5MgtbgdsOJRoXS8Pm7dj1IQ/bTx15SfGaTuIpg4I9oEMXdGHrizG3JU7hARPu4HSP95XI9iBz7tgUqIjpb0XgO0TNS50p7THS8hccRwW+fq1Slk3Okd0TNMHNfR9rLdQLqheDq0pUgbK4kmWoyxlA1wNC5q0tDkp5LbcCBzUJGOGijPS5CJfwwvN22M1kjQvCKPLIhxpqXOwlnODI1yclMEL/lj/F8O8hmF2c/Ja+vJUlGtYgnL91cbHh4fZi7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: xen.org; dkim=none (message not signed)
 header.d=none;xen.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by VI1PR0402MB2701.eurprd04.prod.outlook.com (2603:10a6:800:af::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 06:21:53 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::4d37:ec64:4e90:b16b]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::4d37:ec64:4e90:b16b%7]) with mapi id 15.20.4523.016; Fri, 17 Sep 2021
 06:21:53 +0000
Subject: =?UTF-8?Q?Re=3a_Ping=c2=b2=3a_=5bPATCH=5d_xen-netback=3a_correct_su?=
 =?UTF-8?Q?ccess/error_reporting_for_the_SKB-with-fraglist_case?=
To:     Sander Eikelenboom <sander@eikelenboom.it>
Cc:     "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        paul@xen.org, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Wei Liu <wl@xen.org>
References: <4dd5b8ec-a255-7ab1-6dbf-52705acd6d62@suse.com>
 <67bc0728-761b-c3dd-bdd5-1a850ff79fbb@xen.org>
 <76c94541-21a8-7ae5-c4c4-48552f16c3fd@suse.com>
 <17e50fb5-31f7-60a5-1eec-10d18a40ad9a@xen.org>
 <57580966-3880-9e59-5d82-e1de9006aa0c@suse.com>
 <a26c1ecd-e303-3138-eb7e-96f0203ca888@xen.org>
 <1a522244-4be8-5e33-77c7-4ea5cf130335@suse.com>
 <9d27a3eb-1d50-64bb-8785-81de1eef3102@suse.com>
 <d4f381e9-6698-3339-1d17-15e3abc71d06@suse.com>
 <0dff83ff-629a-7179-9fef-77bd1fbf3d09@xen.org>
 <5a8c1f28-eefb-87e2-998b-7cbfb0f0b8dd@eikelenboom.it>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <289a190d-0591-a5a1-669e-28c48a3168c5@suse.com>
Date:   Fri, 17 Sep 2021 08:21:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <5a8c1f28-eefb-87e2-998b-7cbfb0f0b8dd@eikelenboom.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::18) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.156.60.236] (37.24.206.209) by FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.5 via Frontend Transport; Fri, 17 Sep 2021 06:21:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a88c9d7-cb18-44ec-ae07-08d979a3713b
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2701:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2701F07D73E6D4E22DC1CC93B3DD9@VI1PR0402MB2701.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6vpsJN/MyORCsMmJvfm0AP1FXRikDwMyI0x47mBUdCYeo2SXOv1V9LOCrGm7UEh/XyAy7HDTAs4zb5RFc74xDknu0LocTty8AAb4iKlEFe20E/abY+4EyiVVPzCv/UGOhUUnVr3mrjor0uh66rN15o/sLvlIMbTdhEyWCvrYOeAfKJRXQot0L/DlzGpD4HiRl//1oWAEnl+qEZiI5OvGs2YD6aZLzRzdcP/+iejbhTtV+QwqKTQemwdGRe3BRT7/lGkbVOMLd0M8lQ0e6BqmfFvW3jv3IqmItmMwHQrV4A5CGC61SkMaJKRLQy05Oo1e77OFBbwODCZCgj9ChOmgRl+85Yp1TTkT8sX9Lj3ZrEEtdlND6DewYIm1r8dp0JdMC2xaQC+oIQFaZpZUcJHzQl54pKaNqKrbnYMz2QDiRmGmpflhc3QAWCIcssfjV7YJoczPnLyIO23WOTOcQYnexvm3Yy9kdZ2rVMvmzwxrFVjLD3oVb8kZrlEH+zdQ9hW7HxGLuvSfrtMP4JWXLXj0T+JKvwfObfLXqmok6tGWIxUZRI78z5VBXoxuBUG0fZJ1MGmwOr0Vf4Ytc70i9jpsh5diwSgywJKS1u41waWpaE8g/GBsQ9x9ZFyVXUJecnQux+pqeBPXGHAuPKZ8o0RBU7HRVQILZ7Y5lE6oTpXzaIBc8jrCXOvkyh2bk7qjB8483Zmx8k9esESfpzo3nus73vqaq2bm/Wqpa48AVRH7No4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(66946007)(31696002)(2906002)(38100700002)(26005)(186003)(66476007)(316002)(16576012)(6916009)(36756003)(31686004)(4326008)(508600001)(86362001)(2616005)(956004)(5660300002)(54906003)(66556008)(6486002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d093aThuRTlEdWV5TWpYOVNrVzBvZGJOT1BMVElpRVZONCtVZGJvcUQvQkhK?=
 =?utf-8?B?QkNCRlR5cHhpcndaNVp6SGRsbGt1TjZMV1cyMWNpcEpmU1F1ditCWHZtbkZK?=
 =?utf-8?B?THczdHBzLzg5NS9IMXhoT1BYcm56QzdWYnVPSFdnWWluMnB5ZCtFSHNwRVRm?=
 =?utf-8?B?MEN3Zjc2WlpRQlB3MGJwWHRnc3E0TXdDVitlVkRMOTZNdzlqL01hamM3SWdv?=
 =?utf-8?B?QVpRSWN5Mk5mSmRIUW10Q3cyRVlTTmh2cXpIWllMZWZ0YUo3WExTNk4weG5x?=
 =?utf-8?B?MmpVVW9XN0VVdXM2Z2NvMmlXd2ZIZnEydWtrZ0tyTGF4WEliaW05aUJVUFhs?=
 =?utf-8?B?aTZ0Smo1WERNdGZ2cDUrZ3p1OTA0S1NjU0dmTzRXK1ZINEFLTlRPL2FXczEr?=
 =?utf-8?B?ZVdEOXo4cTdQVTE2aW5QdE5QZklIYjM3aGJhQldqdTYzVWx0TGhRZ3VEYWpn?=
 =?utf-8?B?eTl1eW1RbzlaRDl1eGQ1QUJLQyt0MkhhMXBaVEJHeG03TVIwcW1ZM2J6eVBP?=
 =?utf-8?B?cVR3aFhuOHNuSTdBNU9xTFVmclBrRTNIQVk0ejNETTRGNmFReW1WajB3dzlO?=
 =?utf-8?B?M0VRZDdKTElDUzhUQ1hzaXg2ZTVSMDNFaGxucGlLcUJlbHZQS0Z3NUpsYTFO?=
 =?utf-8?B?YXJpS2EzUnFOdng0K0tzT2tPcFdpd2o2M3BDakpwaEVZdHJ3SDZNNFd1dHEr?=
 =?utf-8?B?MFFPTUZKOWYyaXl5YzJndFdKaHpuWVN5Yzk4bm8vd0w3cURKV2ZrTUp5Ti9Y?=
 =?utf-8?B?cytJdld2QzdOVGtFQUorVjd0dnFjNnBra1VSdC9HQUwvcFlsNkhSbW9odStT?=
 =?utf-8?B?UzlEL0UwcksvT2x4a0RSeE9UajEvN0pBY2F5dmVGM1A5cDNIZFVUMzlDM25y?=
 =?utf-8?B?T0JDNCsranAya01VRHZoV0w5cDFMVUM1WEUyT1k2Rkk1S2MzblNGSHcrREJF?=
 =?utf-8?B?eURlTjdDdjBqYmtGcWFLL0kvWjlzbkd2SG5LWUlWR1YxU25jQVJqRGljMzFE?=
 =?utf-8?B?UjZKb2VsYm1qTHY3WWZRQ1JWTmJFSzZIbE1BRWs1MGZ6NnNBcjF3YXhLWDhE?=
 =?utf-8?B?emhmQTM3czBuL3MrUVdFdVpNb09VeUpIRUJjNko3N1JXQXMzMlNzSWpsK1lt?=
 =?utf-8?B?OFgrNnNqZGcyTlQ2YmtyMmVsWTJIZVdKSnJJTUkvc21UeElUM25jdUx1R3J2?=
 =?utf-8?B?ZVltYnM5YWtRbVNGSXVFbWdEcVRka0RpUFBBQ09vNXNzOWRIMzJxTXFjR0J2?=
 =?utf-8?B?QmJoYzE0NzIvRHZaR2pXU1ZBcCt1OXBtdVR1Y3QrcmJDMFljdUpWdEpjcGdu?=
 =?utf-8?B?SWZJbjQ1VGhrbWxaanZqRmpVTlpqYzliVTBQanFXalcwaTE0SG9mU2lnVUdX?=
 =?utf-8?B?Z2RTQU5iQXlzWTZwZ2RtYi96SFZ0MEFsNzl6eVRONlpHRTVOWTR5KzhPWlVE?=
 =?utf-8?B?VzBCRDNIdG9uZmtTZVZGZy8wV0MvOW1XREs4SHZEYzlvUVJZOERaclZGbi96?=
 =?utf-8?B?VXhKd3p2WFhsSnZMclFUZHlLVDVjVDlMK3BNTnVsMko5NnZMUytkb1VQMysw?=
 =?utf-8?B?UFdSdGYwangyM1dobWNOVUNPVE04R2YzNmVtOVNBb3VCMDhoRDl5N2pPd216?=
 =?utf-8?B?UXlYOVRETTBUV1BWeFpoWHFJdi9OTzBFd2tDNDhnWGtRUHRwN251UHlsWFlz?=
 =?utf-8?B?M0dDcXZaQkRBUUR3eDl6T0VQOXVkRzcwN0VQTGpuaktpR2ZLVGRrWjFpYXdz?=
 =?utf-8?Q?EHc4U/Yy2rS9cL2ibN+0HDR0PNRm9k/XnEkGHHy?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a88c9d7-cb18-44ec-ae07-08d979a3713b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 06:21:53.8211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CRcddLvMtkbFHGPvD48Fwgf6SI1c4IN7aEqN5tuVL+LQMyBTiPSGtipMh4cSHN+zwmmALb4B03htMNJ26eFSQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2701
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.09.2021 23:48, Sander Eikelenboom wrote:
> On 16/09/2021 20:34, Paul Durrant wrote:
>> On 16/09/2021 16:45, Jan Beulich wrote:
>>> On 15.07.2021 10:58, Jan Beulich wrote:
>>>> On 20.05.2021 13:46, Jan Beulich wrote:
>>>>> On 25.02.2021 17:23, Paul Durrant wrote:
>>>>>> On 25/02/2021 14:00, Jan Beulich wrote:
>>>>>>> On 25.02.2021 13:11, Paul Durrant wrote:
>>>>>>>> On 25/02/2021 07:33, Jan Beulich wrote:
>>>>>>>>> On 24.02.2021 17:39, Paul Durrant wrote:
>>>>>>>>>> On 23/02/2021 16:29, Jan Beulich wrote:
>>>>>>>>>>> When re-entering the main loop of xenvif_tx_check_gop() a 2nd time, the
>>>>>>>>>>> special considerations for the head of the SKB no longer apply. Don't
>>>>>>>>>>> mistakenly report ERROR to the frontend for the first entry in the list,
>>>>>>>>>>> even if - from all I can tell - this shouldn't matter much as the overall
>>>>>>>>>>> transmit will need to be considered failed anyway.
>>>>>>>>>>>
>>>>>>>>>>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>>>>>>>>>>>
>>>>>>>>>>> --- a/drivers/net/xen-netback/netback.c
>>>>>>>>>>> +++ b/drivers/net/xen-netback/netback.c
>>>>>>>>>>> @@ -499,7 +499,7 @@ check_frags:
>>>>>>>>>>>       				 * the header's copy failed, and they are
>>>>>>>>>>>       				 * sharing a slot, send an error
>>>>>>>>>>>       				 */
>>>>>>>>>>> -				if (i == 0 && sharedslot)
>>>>>>>>>>> +				if (i == 0 && !first_shinfo && sharedslot)
>>>>>>>>>>>       					xenvif_idx_release(queue, pending_idx,
>>>>>>>>>>>       							   XEN_NETIF_RSP_ERROR);
>>>>>>>>>>>       				else
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> I think this will DTRT, but to my mind it would make more sense to clear
>>>>>>>>>> 'sharedslot' before the 'goto check_frags' at the bottom of the function.
>>>>>>>>>
>>>>>>>>> That was my initial idea as well, but
>>>>>>>>> - I think it is for a reason that the variable is "const".
>>>>>>>>> - There is another use of it which would then instead need further
>>>>>>>>>       amending (and which I believe is at least part of the reason for
>>>>>>>>>       the variable to be "const").
>>>>>>>>>
>>>>>>>>
>>>>>>>> Oh, yes. But now that I look again, don't you want:
>>>>>>>>
>>>>>>>> if (i == 0 && first_shinfo && sharedslot)
>>>>>>>>
>>>>>>>> ? (i.e no '!')
>>>>>>>>
>>>>>>>> The comment states that the error should be indicated when the first
>>>>>>>> frag contains the header in the case that the map succeeded but the
>>>>>>>> prior copy from the same ref failed. This can only possibly be the case
>>>>>>>> if this is the 'first_shinfo'
>>>>>>>
>>>>>>> I don't think so, no - there's a difference between "first frag"
>>>>>>> (at which point first_shinfo is NULL) and first frag list entry
>>>>>>> (at which point first_shinfo is non-NULL).
>>>>>>
>>>>>> Yes, I realise I got it backwards. Confusing name but the comment above
>>>>>> its declaration does explain.
>>>>>>
>>>>>>>
>>>>>>>> (which is why I still think it is safe to unconst 'sharedslot' and
>>>>>>>> clear it).
>>>>>>>
>>>>>>> And "no" here as well - this piece of code
>>>>>>>
>>>>>>> 		/* First error: if the header haven't shared a slot with the
>>>>>>> 		 * first frag, release it as well.
>>>>>>> 		 */
>>>>>>> 		if (!sharedslot)
>>>>>>> 			xenvif_idx_release(queue,
>>>>>>> 					   XENVIF_TX_CB(skb)->pending_idx,
>>>>>>> 					   XEN_NETIF_RSP_OKAY);
>>>>>>>
>>>>>>> specifically requires sharedslot to have the value that was
>>>>>>> assigned to it at the start of the function (this property
>>>>>>> doesn't go away when switching from fragments to frag list).
>>>>>>> Note also how it uses XENVIF_TX_CB(skb)->pending_idx, i.e. the
>>>>>>> value the local variable pending_idx was set from at the start
>>>>>>> of the function.
>>>>>>>
>>>>>>
>>>>>> True, we do have to deal with freeing up the header if the first map
>>>>>> error comes on the frag list.
>>>>>>
>>>>>> Reviewed-by: Paul Durrant <paul@xen.org>
>>>>>
>>>>> Since I've not seen this go into 5.13-rc, may I ask what the disposition
>>>>> of this is?
>>>>
>>>> I can't seem to spot this in 5.14-rc either. I have to admit I'm
>>>> increasingly puzzled ...
>>>
>>> Another two months (and another release) later and still nothing. Am
>>> I doing something wrong? Am I wrongly assuming that maintainers would
>>> push such changes up the chain?
>>>
>>
>> It has my R-b so it ought to go in via netdev AFAICT.
>>
>>     Paul
> 
> Could it be the missing "net" or "net-next" designation in the subject 
> [1] which seems to be used and important within their patchwork 
> semi-automated workflow ?

I wouldn't exclude this, but having to play special games there means
I'll try to refrain from fixing any bugs under net/ in the future. I'll
resend following their apparently required pattern.

Jan

