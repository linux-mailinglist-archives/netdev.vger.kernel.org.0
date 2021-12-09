Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC2A46DF5B
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 01:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241444AbhLIAW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 19:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238337AbhLIAWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 19:22:23 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7F2C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 16:18:50 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id i5-20020a05683033e500b0057a369ac614so4486652otu.10
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 16:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vx8Ci18Bq6F4v668u+ZjVgV2godlqkz2vFb6FDo/wlo=;
        b=Jg0M8owlwRhSYrROnN7NUDMr/KUUiXQilO6dp8Zp0pm+VtX8lwhTXVusq0ZiX9tMc3
         lFUIbH8pWV37oariZEJ+fHPQcnhv0gMz5NLOYJ+CMwXX9i2C/G4zO7/Uttp9w9d8wJO7
         f4HSVTt2VG8Bw/FADlYXgDKwVsejB2r7ZVjwpU8Ry+HMLCXHSxXR+9qwsdP3bDsQ/i9c
         5gO/4EPiwTvgH9ke6k3VbUyZ1nN93XhxyEbMfh+Za8cj+W5UXSyquHR63nOa2EaT1j8h
         /5JGmnSi8c5m6J1s3ICm+8Lxe46ajXi8STTVCkTyCIGH+DzWXB5i3vpFyAYqW26Uv3xm
         Xevw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vx8Ci18Bq6F4v668u+ZjVgV2godlqkz2vFb6FDo/wlo=;
        b=qri2GOc7yAcCcTcJPyA38NeR340p9JrkWzkTj0lcbHVpwBWM1x98M76/ZV+XK51Wxt
         Tv1nzZgSb3LsUfngLy8uo14m1ySaTFAv3OSuetyQCc/5+CMCjwWKjAt33RKv2arMmZhi
         djc4BXvAM1M7tyB2G52Lq8/SCrwdx1NjdyBWL7r6L2IsB30Pw32GK+Iv1bAmtwTcCj5+
         tk2NFr1tlyt15XbZNckm6DGbbXty//yOoB84cTjydcFLmGw+YC1TyaL+ElQssupXNMcp
         gko4FBuZWHrkDZOZiu+o6F+ooCzc0nvBlwgEP3JM4/6jaxofalhw+5T8MLpyLBhxBNAd
         TvAw==
X-Gm-Message-State: AOAM533nvd84gGumlvC74JgVG9YhXeE52MdpvrKwwSdgK54edEdBW4r4
        Ql9D/PZwQe45ZH0gLncuBEk=
X-Google-Smtp-Source: ABdhPJysfVgX/vcuqSSkZcMlxTls6cJHAXA29w9rXzhtlKi4Vul0mINIftWa3FXZKfnbyl5qRmHGsQ==
X-Received: by 2002:a9d:868:: with SMTP id 95mr2537887oty.211.1639009130232;
        Wed, 08 Dec 2021 16:18:50 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id v19sm757591ott.13.2021.12.08.16.18.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 16:18:50 -0800 (PST)
Message-ID: <7ae281fa-3d05-542f-941c-ba86bd35c31e@gmail.com>
Date:   Wed, 8 Dec 2021 17:18:48 -0700
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
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211208160405.18c7d30f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/21 5:04 PM, Jakub Kicinski wrote:
> On Wed, 8 Dec 2021 16:43:28 -0700 David Ahern wrote:
>> On 12/8/21 2:47 PM, Lahav Schlesinger wrote:
>>> No visible changes from what I saw, this API is as fast as group
>>> deletion. Maybe a few tens of milliseconds slower, but it's lost in the
>>> noise.
>>> I'll run more thorough benchmarks to get to a more conclusive conclusion.
>>>
>>> Also just pointing out that the sort will be needed even if we pass an
>>> array (IFLA_IFINDEX_LIST) instead.
>>> Feels like CS 101, but do you have a better approach for detecting
>>> duplicates in an array? I imagine a hash table will be slower as it will
>>> need to allocate a node object for each device (assuming we don't want
>>> to add a new hlist_node to 'struct net_device' just for this)  
>>
>> I think marking the dev's and then using a delete loop is going to be
>> the better approach - avoid the sort and duplicate problem. I use that
>> approach for nexthop deletes:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/ipv4/nexthop.c#n1849
>>
>> Find a hole in net_device struct in an area used only for control path
>> and add 'bool grp_delete' (or a 1-bit hole). Mark the devices on pass
>> and delete them on another.
> 
> If we want to keep state in the netdev itself we can probably piggy
> back on dev->unreg_list. It should be initialized to empty and not
> touched unless device goes thru unregister.
> 

isn't that used when the delink function calls unregister_netdevice_queue?
