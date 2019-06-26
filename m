Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBF05618E
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 06:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfFZEug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 00:50:36 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51102 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfFZEug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 00:50:36 -0400
Received: by mail-wm1-f66.google.com with SMTP id c66so613722wmf.0
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 21:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H7D3fHglUmA8ki5pvg2HcYcxawa/YSemVdGiXWn7cu0=;
        b=n7ziUpo2leTEy3vMZlmmupbstypwUxiopcnGBFPVqBkGxavIqeMOvGWqkq7zKSaq0o
         Tv9+yWU1KtCt0oztcKLvfBtepgF83xmnYyAIlsUXnz9HNU71LvNUa2n33TSsXpWXywvw
         x3XN15+jZqvnImDgHwae1s9n8PQLynHT9c+WWS2csp302spYZZheut7lCvBXeG/C8qtu
         yQNKBErj6UalA9+bnWLNOt6aKLsfKQDh/rNylpsNrjKACRh5Bkt93LwZAeK7cUmIuFOs
         0RntXneNkbpJmhYTNv2Hb7IHjnSg5GXV+Tnwg43P/AlNzIN1FSpa9cXejmm8W/RTp/OB
         kz9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H7D3fHglUmA8ki5pvg2HcYcxawa/YSemVdGiXWn7cu0=;
        b=ssZu68ltHkgaXswG04ziiHoiVLLV09fnE5m54yALXnNT2Mov5LlrXbIblGc99AYHBh
         0GCJC/PPx5QSSb5kRheH3dSxIJ/74ZG8oULdD21n5Pu35EKPPbo2nMPhJEVrWKSat6NS
         mOH3S5506AGz0kKpwdEDfoMihWr/403cS/zG3fNCunWRmBiboYq0pnJVYZqztYlPiVUA
         9G2ZsbprSEHHKIIhnr2Gd7c6g5As6QKgd2c1pltjeusBxXI1SDyhChWcEqJIBaTegPEK
         I34mn19wswmAup8EuBPE5NivC+F7weSTNJ++Ifvq7S8L+8OwhiqvUrohMTMudrcLGYla
         iZAA==
X-Gm-Message-State: APjAAAXaXW3GYDeVPcQjpzuSPehlkBzhMzDejV82xWPJEQJFrxzjiDpU
        OKHqNrjF/QBWw/C/wgn3l91M0QLy
X-Google-Smtp-Source: APXvYqwvadGryNqlcTtqf6A0RQP13xLNO89apRyQXajP5161uPjRJDkqE7bZ3VNsdKJsyPQD8lm7Lw==
X-Received: by 2002:a7b:cf27:: with SMTP id m7mr994247wmg.7.1561524634025;
        Tue, 25 Jun 2019 21:50:34 -0700 (PDT)
Received: from [192.168.8.147] (104.84.136.77.rev.sfr.net. [77.136.84.104])
        by smtp.gmail.com with ESMTPSA id x129sm751686wmg.44.2019.06.25.21.50.31
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 21:50:32 -0700 (PDT)
Subject: Re: [PATCH net] net: make skb_dst_force return false when dst was
 cleared
To:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20190625192209.6250-1-fw@strlen.de>
 <8483d4dc-1ef6-20b5-735f-8d78da579a28@gmail.com>
 <20190625195943.44jvck5syvnzxb55@breakpoint.cc>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <351c686d-5eda-76aa-b561-48c0e876b317@gmail.com>
Date:   Wed, 26 Jun 2019 06:50:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190625195943.44jvck5syvnzxb55@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/19 12:59 PM, Florian Westphal wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>> -static inline void skb_dst_force(struct sk_buff *skb)
>>> +static inline bool skb_dst_force(struct sk_buff *skb)
>>>  {
>>>  	if (skb_dst_is_noref(skb)) {
>>>  		struct dst_entry *dst = skb_dst(skb);
>>> @@ -313,7 +314,10 @@ static inline void skb_dst_force(struct sk_buff *skb)
>>>  			dst = NULL;
>>>  
>>>  		skb->_skb_refdst = (unsigned long)dst;
>>> +		return dst != NULL;
>>>  	}
>>> +
>>> +	return true;
>>
>> This will return true, even if skb has a NULL dst.
> 
> Yes, that was intentional -- it should return false to
> let caller know that no reference could be obtained and
> that the dst was invalidated as a result.

Problem is that some callers ignore skb_dst_force() return value.

> 
>> Say if we have two skb_dst_force() calls for some reason
>> on the same skb, only the first one will return false.
> 
> What would you suggest instead?
> 
> Alternative is something like
> 
> if (skb_dst(skb)) {
> 	skb_dst_force(skb);
> 	if (!skb_dst(skb)) {
> 		kfree_skb(skb);
> 		goto err;
> 	}
> }


Simply change 

return true;

by

return skb->_skb_refdst != 0UL;


