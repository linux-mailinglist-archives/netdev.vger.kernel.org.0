Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD0A460943
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 20:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353316AbhK1TWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 14:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbhK1TUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 14:20:50 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5B8C061746
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 11:17:33 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id i5-20020a05683033e500b0057a369ac614so931546otu.10
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 11:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=meE8l5HKFqstlcM9FqghcUILQGxnqRrOCV9L2gobLCI=;
        b=Fwt5jomsPjkFE80eYn2fqT75Bq9rzQadUknIAmrxv+k2TCCbM8Jh7RQbahW3BmxsXN
         ThA2RfEWlfH2lr1vLqSyfwTzBnLUn40/I7vtCsHKVbjWLSQYJ7ZHMEe13LDrZKeZUG50
         BL7VhtDdItxFCmcQcXk2pyzStz4hlbHZPrHVC/I0lpR2CcE7CwnU+1ry5Xu155vZp/Pt
         D49fzIt/4sE0OKIvHfjwkRZMvDhTd1tQ6Y0FukhYO51Q3TcP/0sM5ga+d+QoJ1GB7M7C
         J0dvC5ZJZOw/hPKp0hkBs6LXBjg5Esnx5lCPdY55+twKPiOPHqCAcNT+grB78eeJBNQ9
         SzTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=meE8l5HKFqstlcM9FqghcUILQGxnqRrOCV9L2gobLCI=;
        b=kRUUnHPP0Shhkyqtc+6quoqh2vbZoSwt8EQQMqsTlqeU8qW81xMBqPRtY4fbRsxMdJ
         rkmvhpW6tA4gX0rmipvOvAW1vthm7z0Gz80iJeWjZWQvExbgUR+EDce2NKvIZuA1rymd
         R1V/bT0/0qkLr79MXdqVHJD8hKh21huTx9wzeXB53dOXhhMi8i/lIVZy7AtVk2+W8e+H
         uY5fIC1yAXzPNE0cDjopUwfFGelT6jPUNPK6IUHIgdpE8deYnCQVU9jOjqd7Uw7YQnOB
         5xcEWe8zt3U+ALRP4LQkHttp288OkQFuN7dAdLdOlojJTLAQ1g1M8ncXuI+GiLhsWEBw
         v99g==
X-Gm-Message-State: AOAM532xW64FmgV1dlRnBgZArwEmI6SVnxOs5fB/EVheLHnA49QQrR1T
        bok7Xh3jXh0cPcwlKmwrcls=
X-Google-Smtp-Source: ABdhPJyxKObEJfj6mIKhP8d7QTcU1FzEq+JO3wCvxdKRRvox196yAuvClErbC5SFGwEk4bChP8pb7Q==
X-Received: by 2002:a9d:6641:: with SMTP id q1mr41048113otm.323.1638127053137;
        Sun, 28 Nov 2021 11:17:33 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id e28sm2521101oiy.10.2021.11.28.11.17.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Nov 2021 11:17:32 -0800 (PST)
Message-ID: <09296394-a69a-ee66-0897-c9018185cfde@gmail.com>
Date:   Sun, 28 Nov 2021 12:17:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH net-next v3] rtnetlink: Support fine-grained netdevice
 bulk deletion
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>,
        Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org
References: <20211125165146.21298-1-lschlesinger@drivenets.com>
 <YaMwrajs8D5OJ3yS@unreal> <20211128111313.hjywmtmnipg4ul4f@kgollan-pc>
 <YaNrd6+9V18ku+Vk@unreal>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <YaNrd6+9V18ku+Vk@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/21 4:43 AM, Leon Romanovsky wrote:
>>>> +static int rtnl_list_dellink(struct net *net, int *ifindices, int size)
>>>> +{
>>>> +     const int num_devices = size / sizeof(int);
>>>> +     struct net_device **dev_list;
>>>> +     LIST_HEAD(list_kill);
>>>> +     int i, ret;
>>>> +
>>>> +     if (size <= 0 || size % sizeof(int))
>>>> +             return -EINVAL;
>>>> +
>>>> +     dev_list = kmalloc_array(num_devices, sizeof(*dev_list), GFP_KERNEL);
>>>> +     if (!dev_list)
>>>> +             return -ENOMEM;
>>>> +
>>>> +     for (i = 0; i < num_devices; i++) {
>>>> +             const struct rtnl_link_ops *ops;
>>>> +             struct net_device *dev;
>>>> +
>>>> +             ret = -ENODEV;
>>>> +             dev = __dev_get_by_index(net, ifindices[i]);
>>>> +             if (!dev)
>>>> +                     goto out_free;
>>>> +
>>>> +             ret = -EOPNOTSUPP;
>>>> +             ops = dev->rtnl_link_ops;
>>>> +             if (!ops || !ops->dellink)
>>>> +                     goto out_free;
>>>
>>> I'm just curious, how does user know that specific device doesn't
>>> have ->delink implementation? It is important to know because you
>>> are failing whole batch deletion. At least for single delink, users
>>> have chance to skip "failed" one and continue.
>>>
>>> Thanks
>>
>> Hi Leon, I don't see any immediate way users can get this information.
>> I do think that failing the whole request is better than silently
>> ignoring such devices.
> 
> I don't have any preference here, probably "fail all" is the easiest
> solution here.

Since there is no API to say which devices can not be deleted failing
the group delete because 1 is say a physical device is going to be
frustrating for users. I think the better approach is to delete what you
can and set extack message to 'Some devices can not be deleted.'

