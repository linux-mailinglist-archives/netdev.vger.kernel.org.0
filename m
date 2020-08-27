Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764982549BA
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgH0Pnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgH0Pn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 11:43:26 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772A0C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 08:43:26 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id d10so4914028wrw.2
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 08:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EkgB7WKbYwvaGw7hFU+asOvWt4I+WRSed6oQ9HICx44=;
        b=cD/y+7p8Pu9RwMfE6ZACizJS4n4GdQUFWuSpmS8n+l5CWhDjCiHLxcGMcobeJP+WSS
         JI1PYJ081FNPwsLUNudqI0F891yhaZ/uzoezDsYkQFKVDDJPMvXsx2UH2l2LN8wqIaMK
         O5THWXOfNHju10RcDZpebbT/lmuY7BRSHcD3xL+ukQsCIAK/yEUjVUaQvGI17o26OWiV
         1WhEIxzGfKb7Xmpv7rl57og4wuAUGBIoQBK1cr7+DStdj+zgrc1XZT4trQCZscnHRMEE
         zpKCHuaHe6nSznTVMguKiG/iMYw8ZXelb4JcuPmXvCk6IEIOIXb9wa0g3a/uOduz/M68
         eEww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EkgB7WKbYwvaGw7hFU+asOvWt4I+WRSed6oQ9HICx44=;
        b=EvaUdqLw2yC0d3Fj5vwuRyy0CEpzLnA1HW3p7XhXJ8U3m3BJts3JL/VikOE3k2/Tqw
         TvbZhjZian2BmFiR2ng9OVPCt50HDxGzeAtudQkAoctilYVT9ffFw6IZI23mg7p18RIM
         rDtbXzSyLNvyMoh6hLmc0QpHlfKrb4YR9aVmEdGl/Vee0EpivKdAXRxev3G4PIlAsvzz
         PfGx5FWYz+usYRYZ/h4lAa5v6aSTPZ108F7u6/qBxSVtzCR7uMfJqfRFiLUYnRXkayS+
         0CWSNNGyXGw9wGtuT1UL5lju6/rjYqM3PcEvT9Fwe9hzDvarPdydD9S9A/rDB38EeEq1
         ccSQ==
X-Gm-Message-State: AOAM531pSndw6RXWB1yabwplOjwFL14r354FHgI7Cn0dc9HrXPlmRk7o
        UdX4Zv2Vb6qV5T68xIsgsAEECoUtHHA=
X-Google-Smtp-Source: ABdhPJxR6tw5VOuFt5PDVsPSmmX/+jR0sdv1J2WmytYv5errRiOORMOlADRVX8f+zZotOjFc37wDew==
X-Received: by 2002:a5d:55c9:: with SMTP id i9mr20178525wrw.31.1598543005217;
        Thu, 27 Aug 2020 08:43:25 -0700 (PDT)
Received: from [192.168.8.147] ([37.170.168.205])
        by smtp.gmail.com with ESMTPSA id h11sm6460687wrb.68.2020.08.27.08.43.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 08:43:24 -0700 (PDT)
Subject: Re: [PATCH net 1/2] net: disable netpoll on fresh napis
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, michael.chan@broadcom.com,
        netdev@vger.kernel.org, kernel-team@fb.com,
        Rob Sherwood <rsher@fb.com>
References: <20200826194007.1962762-1-kuba@kernel.org>
 <20200826194007.1962762-2-kuba@kernel.org>
 <25872247-9776-2638-cf83-a51861ce5cd4@gmail.com>
 <20200827081003.289009f4@kicinski-fedora-PC1C0HJN>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7874b0df-8977-2468-0bd9-b6c47ccb068c@gmail.com>
Date:   Thu, 27 Aug 2020 08:43:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200827081003.289009f4@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/27/20 8:10 AM, Jakub Kicinski wrote:
> On Thu, 27 Aug 2020 00:25:31 -0700 Eric Dumazet wrote:
>> On 8/26/20 12:40 PM, Jakub Kicinski wrote:
>>> To ensure memory ordering is correct we need to use RCU accessors.
>>
>>> +	set_bit(NAPI_STATE_NPSVC, &napi->state);
>>> +	list_add_rcu(&napi->dev_list, &dev->napi_list);
>>
>>>  
>>> -	list_for_each_entry(napi, &dev->napi_list, dev_list) {
>>> +	list_for_each_entry_rcu(napi, &dev->napi_list, dev_list) {
>>>  		if (cmpxchg(&napi->poll_owner, -1, cpu) == -1) {
>>>  			poll_one_napi(napi);
>>>  			smp_store_release(&napi->poll_owner, -1);
>>>   
>>
>> You added rcu in this patch (without anything in the changelog).
> 
> I mentioned I need it for the barriers, in particular I wanted the
> store release barrier in list_add. Not extremely clean :(

Hmmm, we also have smp_mb__after_atomic()

> 
>> netpoll_poll_dev() uses rcu_dereference_bh(), suggesting you might
>> need list_for_each_entry_rcu_bh()
> 
> I thought the RCU flavors are mostly meaningless at this point,
> list_for_each_entry_rcu() checks rcu_read_lock_any_held(). I can add
> the definition of list_for_each_entry_rcu_bh() (since it doesn't exist)
> or go back to non-RCU iteration (since the use is just documentation,
> the code is identical). Or fix it some other way?
> 

Oh, I really thought list_for_each_entry_rcu() was only checking standard rcu.

I might have been confused because we do have hlist_for_each_entry_rcu_bh() helper.

Anyway, when looking at the patch I was not at ease because we do not have proper
rcu grace period when a napi is removed from dev->napi_list. A driver might
free the napi struct right after calling netif_napi_del()

