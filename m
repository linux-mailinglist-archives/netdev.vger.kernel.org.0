Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D6F2826B1
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 22:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgJCU6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 16:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgJCU6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 16:58:23 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CD7C0613D0;
        Sat,  3 Oct 2020 13:58:23 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a17so2508357pju.1;
        Sat, 03 Oct 2020 13:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=AZZnFmMC17E9yGBAkNVOXQNqt+M2aS94kheendbZAAI=;
        b=tXSRk41dOnyVQFHFQteEMOA9RHgmNiqaQmvOeiMspL+XX3vSKCFh+mgDwfo4rsGAZB
         wOI1k7m1YwWeVtEP8ElhegJKyHIEeltLd6mHm4nAIPaR9XYXtGJ+IEK6BZptgeXOQJZm
         nEb9ULgDKPSWi8vMQnrBY3+R37DAjwQycwnfbPx4N3tgWwAc4KFd2HgsmSmYx/eAHjPm
         nEf+UnInjpBuiWNL2+vdY7pNR85TxkqSUeteVJSyzaupPDu8j53qCk9yFNLDUOj2n+sJ
         1Tyg0tjq9qgi81jgGL8q5skGli/aCuWVypJTOuo36KM06igQxOTtGqlTOox5QF2bBf3+
         sVDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=AZZnFmMC17E9yGBAkNVOXQNqt+M2aS94kheendbZAAI=;
        b=EWmyxIDylOp8lqTKMriwO01w2jF0f3ulG1QvaaMFK5d5mNGjCuDaWDN9xh1fyStGgW
         rDNtBRKsDRsT7VYLqZAO1AqV6zfXAIn2tU/B2Ix3VkOHw3PMSNsdCaFFpLK1jyu16Sz1
         LVbIUWq/KHWUlpYgG8gEOi5OiizS0mUOKRgaBx2so8dnlWGwp8WvrVKn5mBah+MvUwFG
         N3aOx71vTA31HvnzKpXuFCetZ3tEenZm5UE40XPaCj3dWWhr7UlKB/MWynkjZVwLTwEQ
         z7zeZbLdL8inJ/yIyzpjUbqrnJZrKbZb2q5MfVdBDX3zk8edf0/+k974ifk3DLxKJtIO
         HEXw==
X-Gm-Message-State: AOAM532AhwETibGy+USevlp2xsF3lwncwBbQxK3d/qjyHX38a7eebb0i
        J4QjLD3m37bbV4WmPdnz+tlTw2JKl7wuhiXzUfU=
X-Google-Smtp-Source: ABdhPJxiKPUGZnuM6OqUtXhszbDMEqmHhXppikt/00huy7eOAH4bexu9KtNZH7gq0ez9wPuyLS+vUQ==
X-Received: by 2002:a17:90a:ea0a:: with SMTP id w10mr8792531pjy.165.1601758701945;
        Sat, 03 Oct 2020 13:58:21 -0700 (PDT)
Received: from [192.168.0.104] ([49.207.217.69])
        by smtp.gmail.com with ESMTPSA id i17sm6640460pfa.29.2020.10.03.13.58.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2020 13:58:21 -0700 (PDT)
Subject: Re: [PATCH v2] net: usb: rtl8150: prevent set_ethernet_addr from
 setting uninit address
To:     Joe Perches <joe@perches.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201001073221.239618-1-anant.thazhemadam@gmail.com>
 <dbe67fce55c6bbe569cefdc1a01708a0d01b140a.camel@perches.com>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <81a5d8b6-5258-1f2e-15da-4324579799df@gmail.com>
Date:   Sun, 4 Oct 2020 02:28:14 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <dbe67fce55c6bbe569cefdc1a01708a0d01b140a.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 04/10/20 1:08 am, Joe Perches wrote:
> On Thu, 2020-10-01 at 13:02 +0530, Anant Thazhemadam wrote:
>> When get_registers() fails (which happens when usb_control_msg() fails)
>> in set_ethernet_addr(), the uninitialized value of node_id gets copied
>> as the address.
> unrelated trivia:
>
>> diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
> []
>> @@ -274,12 +274,17 @@ static int write_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 reg)
>>  		return 1;
>>  }
>>  
>> -static inline void set_ethernet_addr(rtl8150_t * dev)
>> +static bool set_ethernet_addr(rtl8150_t *dev)
>>  {
>>  	u8 node_id[6];
> This might be better as:
>
> 	u8 node_id[ETH_ALEN];
>
>> +	int ret;
>>  
>> -	get_registers(dev, IDR, sizeof(node_id), node_id);
>> -	memcpy(dev->netdev->dev_addr, node_id, sizeof(node_id));
>> +	ret = get_registers(dev, IDR, sizeof(node_id), node_id);
>> +	if (ret == sizeof(node_id)) {
>> +		memcpy(dev->netdev->dev_addr, node_id, sizeof(node_id));
> and
> 		ether_addr_copy(dev->netdev->dev_addr, node_id);
>
>
I will include this change as well, in the v3.
Thank you for pointing that out.

Thanks,
Anant

