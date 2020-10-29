Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD0F29EF8E
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 16:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbgJ2PSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 11:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727290AbgJ2PSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 11:18:43 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DF5C0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 08:18:43 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id y20so3879856iod.5
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 08:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xh/0MAfnjiFoBJyDoXXFUcTMFR/278BpRZ1UOiFzfik=;
        b=swV13xQJfKhcSC5vV8XC4BHbhhbUBuN7adUI4Z6Dh3CmIa9ApcofyUnoMon6eoxkhJ
         +fKn3ZEOfy1dBNpKqmUII3Ci5TQUaAt8zyZIGACZfBlsYgGiXAyhoK3TxM/0TlrdN5Q5
         DRzq/fZCGRDwyCK0+vQI7cTQSGgwjhDfyShZbNC3E1EhEoVF5WkIAG4L4iFmRV0/T4vg
         i5uZKfvUZZpeU7L714FWLbizKuv9BOifcXy75ObsJBca/K+oZi30zrWN5bHwMl2Yct4J
         n/Emr1C1XVRwyTRd2jzdLKX97eCrBW82QHBU8sEyoKDXCtZKgIh0nFN2T/1HN+2Emizs
         HYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xh/0MAfnjiFoBJyDoXXFUcTMFR/278BpRZ1UOiFzfik=;
        b=QW4KdWKWgHz8MnJZ3c2XYMQCJZ+vYx8o9aAvCBNdSBFB4pwjBMd2/YTVxD4uEie2lg
         OylK92Vy470GY8oZ3fRBLthRQ7RSFU1hPu9ZvStZ1UmzcVa8+5aVD7WrPr+N/aJpTgGc
         +Uz8S7HDyzhY0ADsoS9DwRG4xxUjMT6fJApbghpB5CLIM6/PvOzkpwHcZQKn2SmkSW8L
         KMEozQ0GCxzY9zRL4wTeoczbvBhIR/ogNIfXkrsvtv49mdRCYgoEVfnb/TbX6GI/6YSK
         ApHPfbE7nxBFUnmRjn4vn2KrDtHh3fYZaTOQfEEuYssuvYL+HvAKtfPUTng3SV1oDO0V
         Aadg==
X-Gm-Message-State: AOAM532P7lRyR6cdyQtzmbhVsksUJm9CohlLu3FRQIdjvv6M049HZdP6
        zGwFv8B261HHb8xp/7WYhUg=
X-Google-Smtp-Source: ABdhPJxJjg79wmCGP4nSQ1Rwx1CsmMDw8UwqfLBSK8O2UykNu5l4pvn4wsJQ1LzaKcUULIhD5JDTNg==
X-Received: by 2002:a6b:3f88:: with SMTP id m130mr3819685ioa.78.1603984722776;
        Thu, 29 Oct 2020 08:18:42 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:cc1b:c747:56c1:5265])
        by smtp.googlemail.com with ESMTPSA id f144sm2784943ilh.54.2020.10.29.08.18.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 08:18:42 -0700 (PDT)
Subject: Re: arping stuck with ENOBUFS in 4.19.150
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>
References: <9bede0ef7e66729034988f2d01681ca88a5c52d6.camel@infinera.com>
 <e09b367a58a0499f3bb0394596a9f87cc20eb5de.camel@infinera.com>
 <777947a9-1a05-c51b-81fc-4338aca3af26@gmail.com>
 <97730e024e7279d67f3eca7e0ef24395e9e08bff.camel@infinera.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bf33dfc1-8e37-8ac0-7dcb-09002faadc7a@gmail.com>
Date:   Thu, 29 Oct 2020 09:18:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <97730e024e7279d67f3eca7e0ef24395e9e08bff.camel@infinera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/20 8:10 AM, Joakim Tjernlund wrote:
> OK, bisecting (was a bit of a bother since we merge upstream releases into our tree, is there a way to just bisect that?)
> 
> Result was commit "net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc"  (749cc0b0c7f3dcdfe5842f998c0274e54987384f)
> 
> Reverting that commit on top of our tree made it work again. How to fix?

Adding the author of that patch (linyunsheng@huawei.com) to take a look.


> 
>  Jocke
>  
> On Mon, 2020-10-26 at 12:31 -0600, David Ahern wrote:
>>
>> On 10/26/20 6:58 AM, Joakim Tjernlund wrote:
>>> Ping  (maybe it should read "arping" instead :)
>>>
>>>  Jocke
>>>
>>> On Thu, 2020-10-22 at 17:19 +0200, Joakim Tjernlund wrote:
>>>> strace arping -q -c 1 -b -U  -I eth1 0.0.0.0
>>>> ...
>>>> sendto(3, "\0\1\10\0\6\4\0\1\0\6\234\v\6 \v\v\v\v\377\377\377\377\377\377\0\0\0\0", 28, 0, {sa_family=AF_PACKET, proto=0x806, if4, pkttype=PACKET_HOST, addr(6)={1, ffffffffffff},
>>>> 20) = -1 ENOBUFS (No buffer space available)
>>>> ....
>>>> and then arping loops.
>>>>
>>>> in 4.19.127 it was:
>>>> sendto(3, "\0\1\10\0\6\4\0\1\0\6\234\5\271\362\n\322\212E\377\377\377\377\377\377\0\0\0\0", 28, 0, {​sa_family=AF_PACKET, proto=0x806, if4, pkttype=PACKET_HOST, addr(6)={​1,
>>>> ffffffffffff}​, 20) = 28
>>>>
>>>> Seems like something has changed the IP behaviour between now and then ?
>>>> eth1 is UP but not RUNNING and has an IP address.
>>>>
>>>>  Jocke
>>>
>>
>> do a git bisect between the releases to find out which commit is causing
>> the change in behavior.
> 

