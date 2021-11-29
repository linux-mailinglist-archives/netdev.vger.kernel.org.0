Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A465462488
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhK2WUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbhK2WSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:18:20 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DE8C200873
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 11:14:08 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id u18-20020a9d7212000000b00560cb1dc10bso26897144otj.11
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 11:14:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hE/Ad8UJJLvSxoB4kAb8iC5e0BVV53p2xN/CykrcB64=;
        b=T4gi8Mh0FWMLBTH0kkDKlZGASggjcOV1Vq+ne5dD29scKfHd2kRsmLI8BX43LkBXGl
         xFlgex754QHdHaKkMmbdTZVU5VberVFG6U3y+2OO4NVGkPofsBsqXSQCRZ2PceOPrca7
         xwF/hA5p+y5qEJVDjMwzWZdJgr8ak4ctnHb20YWJGhnyGgT8SHxNMYkgTRxG+ior30cr
         Tvxt4mtnq6cQ6lxI4lT3lXMmnUWhhJVjf9sWnD8AwLZW4zkOttmYbdt0IFreXCo8EAku
         EZTXjtf3h131LsF5sqH/jPzm9N4mlzj2hscFzqA2FG+tQfMxbE3zYtZNnJtdE50XTG4v
         dDyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hE/Ad8UJJLvSxoB4kAb8iC5e0BVV53p2xN/CykrcB64=;
        b=0i/Gdx1RZeEDDt0eIoXEp9C98KUZSvs/u09nvbT3qp3/VNbqzsjMCpNFKUGlXQqaZ0
         vSDk1mk4TzC4KqOnNPytgHFNnqB+DokodvxpRz+g3Dm+GgCPO9LgBk3mjC5eXLRf/bid
         SaPGM7mJLZqpPIT3OEohenyFxj2t0v1PiBUxtUlgmaKlGwq5epJMylUNXxmL2NZvMG9c
         tIVy7owxRTwzANVRQisa4bUjzgbLsI5Ex3S9gFFSbwcNuzDCgjj1MUlLr4pHxxw+UUzI
         M4pSjqht198Z16rr1Nl/UICNkX8Bzz8QqlbYtGMvnmt6laCKnB02wM5yUvmLjvK/vPyk
         3/NA==
X-Gm-Message-State: AOAM532kCPusSdScHqNiOxJkd7uTmnQdyOEqAJd0FBu3xJhuWYK8TCG8
        UlpKW+wgQf1d1K0gLMzBvw0=
X-Google-Smtp-Source: ABdhPJzQKy3hpLnlpg39i+ofDx99r8vUefZz8C2phvBpnnDlREkqd6nkGt+VMSAxBAY4C4BJFNAwOA==
X-Received: by 2002:a9d:8e9:: with SMTP id 96mr48313811otf.192.1638213247673;
        Mon, 29 Nov 2021 11:14:07 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id w4sm3322964oiv.37.2021.11.29.11.14.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 11:14:07 -0800 (PST)
Message-ID: <e474e1fc-2b92-92a9-29e4-887654575f1c@gmail.com>
Date:   Mon, 29 Nov 2021 12:14:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH net-next v3] rtnetlink: Support fine-grained netdevice
 bulk deletion
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org
References: <20211125165146.21298-1-lschlesinger@drivenets.com>
 <YaMwrajs8D5OJ3yS@unreal> <20211128111313.hjywmtmnipg4ul4f@kgollan-pc>
 <YaNrd6+9V18ku+Vk@unreal> <09296394-a69a-ee66-0897-c9018185cfde@gmail.com>
 <20211129135307.mxtfw6j7v4hdex4f@kgollan-pc>
 <21da13fb-e629-0d6e-1aa1-56e2eb86d1c3@gmail.com>
 <20211129101031.25d35a5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211129101031.25d35a5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/21 11:10 AM, Jakub Kicinski wrote:
> On Mon, 29 Nov 2021 08:30:16 -0700 David Ahern wrote:
>> On 11/29/21 6:53 AM, Lahav Schlesinger wrote:
>>> Hi David, while I also don't have any strong preference here, my
>>> reasoning for failing the whole request if one device can't be deleted
>>> was so it will share the behaviour we currently have with group deletion.
>>> If you're okay with this asymmetry I'll send a V4.  
>>
>> good point - new features should be consistent with existing code.
>>
>> You can add another attribute to the request to say 'Skip devices that
>> can not be deleted'.
> 
> The patch is good as is then? I can resurrect it from 'Changes
> Requested' and apply.

Took another look at it. We should fail if a delete request contains
both IFLA_GROUP and IFLA_IFINDEX_LIST since both are not honored. The
logic in rtnl_list_dellink looks ok.

> 
> Any opinion on wrapping the ifindices into separate attrs, Dave?
> I don't think the 32k vs 64k max distinction matters all that much,
> user can send multiple messages, and we could point the extack at
> the correct ifindex's attribute.
> 

no opinion.
