Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616A046DFAB
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 01:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbhLIAuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 19:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235894AbhLIAuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 19:50:37 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0187C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 16:47:04 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso4565300ots.6
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 16:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2JG7HNFUZA+1jy7u/iHyqFNjO3PTQyhRSdGfu77CwOI=;
        b=P8eqLRmSid91wwgC0SnhMW5GaX2TLHvM9P0RZxdCJRxCz1qHDlgAvRX+XjON3lkYRq
         S5XNI+GoVRYUtFpFdOKQzPPiRGqGJX5goggjR+wtwNRfZy/ADVnZtopAouFMWTRRPDx1
         lPKAuxmYaB/1tK0sjSVdzQlRiWEa3bC+FopLUEEBSOms/RqovP1nW+4RMIjaEqcz4AYk
         0wA6skc/qwm55fx/0ByqfltpWPbqR3rudKFkGG9JfZOYeoIHLvcvkGzDLk3zSHpbjiPl
         vqzdxXnaYG2YPcT9sFAWCpOyRpDrgLPTRgckqrA4gwK9tYt2iD/1X9GC82eIW6v7zyJZ
         UVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2JG7HNFUZA+1jy7u/iHyqFNjO3PTQyhRSdGfu77CwOI=;
        b=uYHVOF4hYWt3b/tz3uL3J2gS1MV/9kuKosfB4+FUX4H+HUI1YbT/PeUT59VWQechOL
         s4+YCR82s7aVohpR0TIQpN7pkd/MFrW/Ui/52/G85CuJdWAbn1PCh5/tSH6KwvuGnfEO
         Bl5mk0RaN8ap/fBhmvSw8QmzX7M78JA5WvwBZQNdPqpQVKHk2HHBLbmsbl/RcX7eSX+F
         SnsPqReT41xCI9J4bHYcTIXqmQewZ8MHnBrRmhBJYH60k1mBbOrTACfuYlkjHwseTrf9
         +/3CygcWdkrlRNgbgPB/WaFt6XNJG5i+fQ56EpgZ2DtrGdBEHmkphxjUQ2009RUFSAKP
         wQpA==
X-Gm-Message-State: AOAM533vvb3haZ9pNYssc0Yzmt4gLYcVDBH4V/p/Da4Ayr9C58td+x64
        5mmpfKf65CIiVAEAA97JUwvhZoi7cVc=
X-Google-Smtp-Source: ABdhPJzom3SOVSIT6JYpWIOE4kSD451nzODKHDpjZeYDuFD9tX0LkJu/PZtAgc56Lso3AlIizr6wYg==
X-Received: by 2002:a9d:7f91:: with SMTP id t17mr2643416otp.197.1639010824303;
        Wed, 08 Dec 2021 16:47:04 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id bi20sm1156087oib.29.2021.12.08.16.47.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 16:47:04 -0800 (PST)
Message-ID: <c0e2a287-4dc6-71b7-aed7-ec7243018078@gmail.com>
Date:   Wed, 8 Dec 2021 17:47:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH net-next v5] rtnetlink: Support fine-grained netdevice
 bulk deletion
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org, nikolay@nvidia.com
References: <20211205093658.37107-1-lschlesinger@drivenets.com>
 <e5d8a127-fc98-4b3d-7887-a5398951a9a0@gmail.com>
 <20211208214711.zr4ljxqpb5u7z3op@kgollan-pc>
 <05fe0ea9-56ba-9248-fa05-b359d6166c9f@gmail.com>
 <20211208160405.18c7d30f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7ae281fa-3d05-542f-941c-ba86bd35c31e@gmail.com>
 <20211208164544.64792d51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211208164544.64792d51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/21 5:45 PM, Jakub Kicinski wrote:
> On Wed, 8 Dec 2021 17:18:48 -0700 David Ahern wrote:
>> On 12/8/21 5:04 PM, Jakub Kicinski wrote:
>>>> I think marking the dev's and then using a delete loop is going to be
>>>> the better approach - avoid the sort and duplicate problem. I use that
>>>> approach for nexthop deletes:
>>>>
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/ipv4/nexthop.c#n1849
>>>>
>>>> Find a hole in net_device struct in an area used only for control path
>>>> and add 'bool grp_delete' (or a 1-bit hole). Mark the devices on pass
>>>> and delete them on another.  
>>>
>>> If we want to keep state in the netdev itself we can probably piggy
>>> back on dev->unreg_list. It should be initialized to empty and not
>>> touched unless device goes thru unregister.
>>
>> isn't that used when the delink function calls unregister_netdevice_queue?
> 
> Sure but all the validation is before we start calling delink, so
> doesn't matter?
> 
> list to_kill, queued;
> 
> for_each_attr(nest) {
> 	...
> 
> 	dev = get_by_index(nla_get_s32(..));
> 	if (!dev)
> 		goto cleanup;
> 	if (!list_empty(&dev->unreg_list))
> 		goto cleanup;
> 	...
> 
> 	list_add(&to_kill, &dev->unreg_list);
> }
> 
> for_each_entry_safe(to_kill) {
> 	list_del_init(&dev->unreg_list);

sure my mental model was walking the list and not doing that part. :-)


> 	->dellink(dev, queued);
> }
> 
> unreg_many(queued);
> 
> return
> 
> cleanup:
> 	for_each_entry_safe(to_kill) {
> 		list_del_init(&dev->unreg_list);
> 	}
> 
> No?
> 

