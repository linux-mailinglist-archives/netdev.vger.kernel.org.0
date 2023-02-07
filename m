Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096E168E29B
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 22:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjBGVEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 16:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjBGVDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 16:03:36 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A19B234FC
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 13:03:03 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id r3so8109409edq.13
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 13:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=duUT8E4UuVznxi1URA7/9KIa7Q1q0GAqecTAd9LPU9U=;
        b=CcvznQfXzeyZsD3wyfiFfJfntgQmnu0yYpnGCLfaqbHs+nWi1lvMJBr1zhlMmB/i/e
         RgKI6bDS3F4+PlHabLUY+RD2V3xVLqFC/Kzbk+D/OnzvJwDzn0I33LoDphR02ZECuzPt
         7P3cn1nJjZFVEZs3nYhsPDF246YnuzwQTpQuJiDh4XhprhvKesEtTvnEGujNg6sC64dX
         0KXDLo4bnY97Zjs7sVFQcap2LEZMxk5Uocm1AHqeD/IY58Eu4M/VnlNsh4JMDzDK0sBP
         zS2Oo6B39XJliMJX5QiMy4+WAqFxGVc2dZ/CnvGDh0JiL2zJ+01aMRabY735jkECcRUU
         Tk3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=duUT8E4UuVznxi1URA7/9KIa7Q1q0GAqecTAd9LPU9U=;
        b=K1JP7e3OHZJCkOorrdsw5exL9ThUS762WTX3henUHmmG320mPqZiB0qU2EFB/IC9o0
         5azMUzRMZzH1h7r0BGhmOVMI94EC++W+nyhNOiq8BgUao/1UmYzdbpKVt7Dr6A9+/f4B
         oBa46I3D1EW9/HZZkgWpNZX3BgeTW+7LzzYAf2uwghNq4hlwt9qQV2szVDoiAoDWgT60
         74ZT3iItw0WBM8WouwD7RiaswF5b9B5uMQB9meiKmqjQWLc8cnDHMOZ888+joCWciIed
         uxt0Jvu2SMZ1pkoH0I5BIvKrh1lTVBj7oOLM39XPn5ucaDmSYwzIW9fYz5OEOnPS/bSr
         iepQ==
X-Gm-Message-State: AO0yUKVOO7nDlNpz1KauUQOihysNs8mXV4Md8FaKrFm/NJlfUlfjj5DI
        jFM/tTUP7bYfEq0FJnRhLBVVcQ==
X-Google-Smtp-Source: AK7set9IEqE7yzYVaInOeuTb1GjnzZGY4vAqwaZ4VCy2UPclZ7k4vDf2ZZzMyDp9zDPAkd6BDE567w==
X-Received: by 2002:a50:8e5d:0:b0:4aa:b76e:6b7a with SMTP id 29-20020a508e5d000000b004aab76e6b7amr5395468edx.36.1675803781606;
        Tue, 07 Feb 2023 13:03:01 -0800 (PST)
Received: from [192.168.100.228] (212-147-51-13.fix.access.vtx.ch. [212.147.51.13])
        by smtp.gmail.com with ESMTPSA id el8-20020a056402360800b004a2470f920esm6876480edb.25.2023.02.07.13.03.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 13:03:01 -0800 (PST)
Message-ID: <0a820f10-f10f-64b7-14ba-58d9337cbb69@blackwall.org>
Date:   Tue, 7 Feb 2023 22:02:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH net-next 00/13] vxlan: Add MDB support
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230204170801.3897900-1-idosch@nvidia.com>
 <3d7387d0-cff6-f403-55fc-1cb41e87db1a@blackwall.org>
 <Y+IZEJSwNZLH2aXN@shredder>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <Y+IZEJSwNZLH2aXN@shredder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/23 11:25, Ido Schimmel wrote:
> On Tue, Feb 07, 2023 at 12:24:25AM +0100, Nikolay Aleksandrov wrote:
>> Hmm, while I agree that having the control plane in user-space is nice,
>> I do like having a relatively straight-forward and well maintained
>> protocol implementation in the kernel too, similar to its IGMPv3 client
>> support which doesn't need third party packages or external software
>> libraries to work. That being said, I do have (an unfinished) patch-set
>> that adds a bridge daemon to FRR, I think we can always add a knob to
>> switch to some more advanced user-space daemon which can snoop.
>>
>> Anyway to the point - this patch-set looks ok to me, from bridge PoV
>> it's mostly code shuffling, and the new vxlan code is fairly straight-
>> forward.
> 
> Thanks for taking a look. I was hoping you would comment on this
> section... :)
>

:)

> After sending the RFC I realized that what I wrote about the user space
> implementation is not accurate. An AF_PACKET socket opened on the VXLAN
> device will only give you the decapsulated IGMP / MLD packets. You
> wouldn't know from which remote VTEP they arrived. However, my point
> still stands: As long as the kernel is not performing snooping we can
> defer the forming of the replication lists to user space and avoid the
> complexity of the "added_by_star_ex" entries (among many other things).
> If in the future we need to implement snooping in the kernel, then we
> will expose a new knob (e.g., "mcast_snooping", default off), which will
> also enable the "added_by_star_ex" entries.
> 

Yep, I agree that it would be best for this case and we don't need the 
extra complexity in the kernel. I was referring more to the standard
IGMPv3 implementation (both client and bridge).

> I tried looking what other implementations are doing and my impression
> is that by "VXLAN IGMP snooping" they all refer to the snooping done in
> the bridge driver. That is, instead of treating the VXLAN port as a
> router port, the bridge will only forward specific groups to the VXLAN
> port, but this multicast traffic will be forwarded to all the VTEPs.
> This is already supported by the kernel.
> 
> Regarding what you wrote about a new knob in the bridge driver, you mean
> that this knob will enable MDB lookup regardless of "mcast_snooping"?

Yep, we can implement the snooping logic in user-space and use the
bridge only as a dataplane (that's what my bridge daemon in frr was
going to do for IGMPv3 and also explicit host tracking).

> Currently this knob enables both snooping and MDB lookup. Note that I
> didn't add a new knob to the VXLAN device because I figured that if user
> space doesn't want MDB lookup, then it will not configure MDB entries.
>

Yeah, of course. The set makes sense as it is since vxlan's logic would
be in user-space.

> Thanks!

