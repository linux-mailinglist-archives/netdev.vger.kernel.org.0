Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84DD200156
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 06:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgFSEmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 00:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbgFSEmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 00:42:19 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86060C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 21:42:19 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x22so3884028pfn.3
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 21:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v83a1EaJVHh5k2oGMag77EQboZNzumvVqyic/XeROI8=;
        b=krG7JER3wH+/NhcorWyc9Iz054NfeeT+6PTiOqhdKvmTmUB1XI1oy1PQYGA54dScn6
         db+DkR42nOUz8hajNdcVTss+F/GPHUKnE3Nj9vxFSdlwybk8/uaWcv1uLIjLESQ5tNvq
         eqJfY36Ef+GN/HGd3t9BxcjLw3tMrKFwAmghriMO5BWFuYg13LvT6M3pA7c040Le8g8j
         QW8TkgkH4k9MSjJ5uNYhI8jk0Qto2Wu7D50sxqE8CI2Yvfd/MbsJRkBj4zXi/yOh1kwA
         ZRZOFdE0VWm/hJ0r8I4WXMmduWDGP/mY9BERvUgDgWSZ4X2YWDHsOVWIMWl+9cze7mvG
         teGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v83a1EaJVHh5k2oGMag77EQboZNzumvVqyic/XeROI8=;
        b=hcF736qV9XdiLidOPjEl1NPhE+56MI+SZ5uEIieEQonAA4s47uVV5nyxA71ZNOnvlg
         Ycej9nqXTw9bNr4IWBMGst3YsNpvcYevr1pWbaLdtFP9Pqr8+cwcdGkUhYStLwyk0aQW
         9STRBpvX2Jl5+Gq0ChCtfjgzosLa/x0b58xDvZZ8jzxOOo+YaBqV8O1VxIKYeO4wv9bS
         mx6ESLiL0EqTddpcDVoUKJHxMoGesyYLSpEwzpF8PIOmOfn5WOQUW86x4OqkqFhDRqJz
         QM/+arjPaGwD+XP+KOAAxFgLOPCDEdqZFhLdR9Eje+IT1FOjju3+58sIK5l5PpXQCwPM
         SaFA==
X-Gm-Message-State: AOAM533DrpZq56z7wAsqDJABusFuKQJwFVN6I1VmsMEdhMGBCQzwnB+1
        nnY9vt3acEWcu9FiO+za5J6qqjvm
X-Google-Smtp-Source: ABdhPJxr/dlBHOvlHJsVCB99AXZ2JMv94MgqlPFueZv44qtYpkgpoJox0T0cwevG63Z4o5A0Ip1lLA==
X-Received: by 2002:a62:7ccb:: with SMTP id x194mr6814240pfc.318.1592541739007;
        Thu, 18 Jun 2020 21:42:19 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id a8sm1403723pga.64.2020.06.18.21.42.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 21:42:18 -0700 (PDT)
Subject: Re: [PATCH net] net: increment xmit_recursion level in
 dev_direct_xmit()
To:     David Miller <davem@davemloft.net>, edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, kuba@kernel.org,
        syzkaller@googlegroups.com
References: <20200618052325.78441-1-edumazet@google.com>
 <20200618.204830.1094276610079682944.davem@davemloft.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <363832b8-1d7e-1e9e-8887-ef97d748b0c7@gmail.com>
Date:   Thu, 18 Jun 2020 21:42:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200618.204830.1094276610079682944.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/20 8:48 PM, David Miller wrote:
> From: Eric Dumazet <edumazet@google.com>
> Date: Wed, 17 Jun 2020 22:23:25 -0700
> 
>> Back in commit f60e5990d9c1 ("ipv6: protect skb->sk accesses
>> from recursive dereference inside the stack") Hannes added code
>> so that IPv6 stack would not trust skb->sk for typical cases
>> where packet goes through 'standard' xmit path (__dev_queue_xmit())
>>
>> Alas af_packet had a dev_direct_xmit() path that was not
>> dealing yet with xmit_recursion level.
>>
>> Also change sk_mc_loop() to dump a stack once only.
>>
>> Without this patch, syzbot was able to trigger :
>  ...
>> f60e5990d9c1 ("ipv6: protect skb->sk accesses from recursive dereference inside the stack")
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Reported-by: syzbot <syzkaller@googlegroups.com>
> 
> Applied and queued up for -stable.
> 
> I only noticed after pushing this out the missing "Fixes: " prefix, but not
> much I can do about this now sorry :-/

Oh right, sorry for this.
