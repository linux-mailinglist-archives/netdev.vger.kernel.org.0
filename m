Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1877B40EA83
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 21:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245756AbhIPTDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 15:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235388AbhIPTDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 15:03:07 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1F9C0AD1DC
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 11:34:21 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id q11so10994817wrr.9
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 11:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:reply-to:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w4Ekv6N9l8FCIqGomJ6KrcmtU6Dai3vMtJDZaK7FIpM=;
        b=aQJNdADA4sjWyHEyiZB8v/YOimfup3q/yreXaUIsDRkCIWXuEkGURS6rDJLMDBGo8j
         /q9oVBu4VyMzqzJmkCtZZO4Wk+KhZnXKB6K0nK8DfpQaKq3edXaU30WCMQIH2JRok3vr
         0bIbbWxeglawI62Ne9ttrxhN+YsQkmIJiE+KibjbbAAEqy81UR0j+y4oJ/h44DOepE4C
         RILQh364ipYOnZFaRHBJF/GywrJwkXBgd5fiO2zt6kOLwc3jK2NUQtmYYzdxNlAb75fk
         nNnmtmHBit70CIhpc7eU7xfS5gy87sdOHSSlvQxZKGOfDtSthBD58mDltOMv0ZnTIViK
         MMjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:reply-to:subject:to:cc:references
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=w4Ekv6N9l8FCIqGomJ6KrcmtU6Dai3vMtJDZaK7FIpM=;
        b=5GgD8T8/20PKuXlYTLJritWbupQ8aJjJEHQ/wfNzF5PFYfHXQrfIItFLQmSnYh/qE+
         7jPsX2NHHB9fEOswg8My8zC7HIk3aNxRjYZIBEDJZ3wD3g5JrLe+i6VGKXCUIQma06hG
         fhZaXIRaW71+k7f1GfGgsaZ4YDU9To+8tHdfVadw5/jswlKcQkaeYxMg1REJI+3Ei4Ri
         XZWJXtliMbc9PW3gCxvLt7X8YXVHzcpnuuiZue1TUw8GCA3zbB11RMa0CynuPAq3Y50+
         jRjNpWh/E1zujxvsuxLkhosyqGJ0dd7OSkVBFUxKI7EQGXmMDDRcO79KnxCH170yb83E
         qvBA==
X-Gm-Message-State: AOAM530ASQi7NuI8J20zZj3vkNBLvyKhbOrBs1yKky/Z3u5wu+ud0vWa
        pbFHh5ChoLar23xvjP1uYiZ0P353ilo=
X-Google-Smtp-Source: ABdhPJy0sR3FbB/pw8T5ItPYEMv6Lo96GQc/NTvLmcBSZhuqqvbxHEwECve262i1QyUWdJo2iIVcxA==
X-Received: by 2002:a5d:65d0:: with SMTP id e16mr7789848wrw.182.1631817260434;
        Thu, 16 Sep 2021 11:34:20 -0700 (PDT)
Received: from ?IPv6:2a00:23c5:5785:9a01:6d33:e960:5a2a:9aae? ([2a00:23c5:5785:9a01:6d33:e960:5a2a:9aae])
        by smtp.gmail.com with ESMTPSA id k6sm6947250wmo.37.2021.09.16.11.34.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 11:34:20 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Reply-To: paul@xen.org
Subject: =?UTF-8?Q?Re=3a_Ping=c2=b2=3a_=5bPATCH=5d_xen-netback=3a_correct_su?=
 =?UTF-8?Q?ccess/error_reporting_for_the_SKB-with-fraglist_case?=
To:     Jan Beulich <jbeulich@suse.com>, Wei Liu <wl@xen.org>
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
 <d4f381e9-6698-3339-1d17-15e3abc71d06@suse.com>
Message-ID: <0dff83ff-629a-7179-9fef-77bd1fbf3d09@xen.org>
Date:   Thu, 16 Sep 2021 19:34:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <d4f381e9-6698-3339-1d17-15e3abc71d06@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/09/2021 16:45, Jan Beulich wrote:
> On 15.07.2021 10:58, Jan Beulich wrote:
>> On 20.05.2021 13:46, Jan Beulich wrote:
>>> On 25.02.2021 17:23, Paul Durrant wrote:
>>>> On 25/02/2021 14:00, Jan Beulich wrote:
>>>>> On 25.02.2021 13:11, Paul Durrant wrote:
>>>>>> On 25/02/2021 07:33, Jan Beulich wrote:
>>>>>>> On 24.02.2021 17:39, Paul Durrant wrote:
>>>>>>>> On 23/02/2021 16:29, Jan Beulich wrote:
>>>>>>>>> When re-entering the main loop of xenvif_tx_check_gop() a 2nd time, the
>>>>>>>>> special considerations for the head of the SKB no longer apply. Don't
>>>>>>>>> mistakenly report ERROR to the frontend for the first entry in the list,
>>>>>>>>> even if - from all I can tell - this shouldn't matter much as the overall
>>>>>>>>> transmit will need to be considered failed anyway.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>>>>>>>>>
>>>>>>>>> --- a/drivers/net/xen-netback/netback.c
>>>>>>>>> +++ b/drivers/net/xen-netback/netback.c
>>>>>>>>> @@ -499,7 +499,7 @@ check_frags:
>>>>>>>>>      				 * the header's copy failed, and they are
>>>>>>>>>      				 * sharing a slot, send an error
>>>>>>>>>      				 */
>>>>>>>>> -				if (i == 0 && sharedslot)
>>>>>>>>> +				if (i == 0 && !first_shinfo && sharedslot)
>>>>>>>>>      					xenvif_idx_release(queue, pending_idx,
>>>>>>>>>      							   XEN_NETIF_RSP_ERROR);
>>>>>>>>>      				else
>>>>>>>>>
>>>>>>>>
>>>>>>>> I think this will DTRT, but to my mind it would make more sense to clear
>>>>>>>> 'sharedslot' before the 'goto check_frags' at the bottom of the function.
>>>>>>>
>>>>>>> That was my initial idea as well, but
>>>>>>> - I think it is for a reason that the variable is "const".
>>>>>>> - There is another use of it which would then instead need further
>>>>>>>      amending (and which I believe is at least part of the reason for
>>>>>>>      the variable to be "const").
>>>>>>>
>>>>>>
>>>>>> Oh, yes. But now that I look again, don't you want:
>>>>>>
>>>>>> if (i == 0 && first_shinfo && sharedslot)
>>>>>>
>>>>>> ? (i.e no '!')
>>>>>>
>>>>>> The comment states that the error should be indicated when the first
>>>>>> frag contains the header in the case that the map succeeded but the
>>>>>> prior copy from the same ref failed. This can only possibly be the case
>>>>>> if this is the 'first_shinfo'
>>>>>
>>>>> I don't think so, no - there's a difference between "first frag"
>>>>> (at which point first_shinfo is NULL) and first frag list entry
>>>>> (at which point first_shinfo is non-NULL).
>>>>
>>>> Yes, I realise I got it backwards. Confusing name but the comment above
>>>> its declaration does explain.
>>>>
>>>>>
>>>>>> (which is why I still think it is safe to unconst 'sharedslot' and
>>>>>> clear it).
>>>>>
>>>>> And "no" here as well - this piece of code
>>>>>
>>>>> 		/* First error: if the header haven't shared a slot with the
>>>>> 		 * first frag, release it as well.
>>>>> 		 */
>>>>> 		if (!sharedslot)
>>>>> 			xenvif_idx_release(queue,
>>>>> 					   XENVIF_TX_CB(skb)->pending_idx,
>>>>> 					   XEN_NETIF_RSP_OKAY);
>>>>>
>>>>> specifically requires sharedslot to have the value that was
>>>>> assigned to it at the start of the function (this property
>>>>> doesn't go away when switching from fragments to frag list).
>>>>> Note also how it uses XENVIF_TX_CB(skb)->pending_idx, i.e. the
>>>>> value the local variable pending_idx was set from at the start
>>>>> of the function.
>>>>>
>>>>
>>>> True, we do have to deal with freeing up the header if the first map
>>>> error comes on the frag list.
>>>>
>>>> Reviewed-by: Paul Durrant <paul@xen.org>
>>>
>>> Since I've not seen this go into 5.13-rc, may I ask what the disposition
>>> of this is?
>>
>> I can't seem to spot this in 5.14-rc either. I have to admit I'm
>> increasingly puzzled ...
> 
> Another two months (and another release) later and still nothing. Am
> I doing something wrong? Am I wrongly assuming that maintainers would
> push such changes up the chain?
> 

It has my R-b so it ought to go in via netdev AFAICT.

   Paul

