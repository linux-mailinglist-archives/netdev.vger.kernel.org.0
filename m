Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A247A2826E6
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 23:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgJCVpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 17:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgJCVph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 17:45:37 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440D5C0613D0;
        Sat,  3 Oct 2020 14:45:36 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id e10so3375059pfj.1;
        Sat, 03 Oct 2020 14:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=YkUAXQMPmvjUV9l+UJIlcFx5SdBT09naUQnGkHuj+B8=;
        b=t5vw0QXHPOchz1V8SraniNG+R+3YQuDdeEvq3g2ljZrqderQi+26wgYclnYhXJ3bXI
         KpES5mPif9CYTD6auU9HJR5Ip2Z4YDIA2iqq0wcS8YsEmk5DNaKp3mzWP2ViAeeRz1hB
         jFEnj5oBg0YCUPSSqDOk9nqEtz+rhAlZuaVWQwo8Th/T4pOaQcDhaEqZ9rAZOfwxHH1w
         ELEK1/CZP5C3Ai80dzQgEldxb6DlwNUXfjUDVYDWlRqiUOBxsMAIFsdfMC8M4wUD/6KM
         wzsPFkRU9i2hpuE1WzeL3VW3pS58H7unNDH2jtPj9v3/0d+8Hpw/RX35Z5KNj7B/0v9D
         uIlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=YkUAXQMPmvjUV9l+UJIlcFx5SdBT09naUQnGkHuj+B8=;
        b=jSfUZDR9LVAVWjHYOiNukck01wWoBiPWAIBaohnVK0s4VR4luD8NtAaB9xXTS+ARvJ
         uoYGypd6W6RfbYHBfzMt+Nr+iFyFpHp7EngHRlZktKrBKpP83z1EyPJzrixon3lvQ6zM
         XAaMjzRD7CQ7ie6iHTyIi4iJ+zXr6PjrzYPwh6VxayOC2GLovFGlbl1Ixutug13Upr/w
         K0hUGlgEWazbKbW7HArHqdWoj2YZ31NfVqUwcQwOcFnh8TtfNKmngKQ3hIHYAJcyK1qW
         gQqq5qGbXebV8ECLLDDXEeFgK+5B2wWL3ibjZZ58CtoKAULw1tkmXuxgap2k/IqIqHA7
         LJBQ==
X-Gm-Message-State: AOAM530GAq152wltlRUSC/f8QEuIgzKND6ogQz8AisRQOoadDYD9m/fu
        wG04DtytvXEd6r3g1VH9mBj/q5AZToTqmm1jMz0=
X-Google-Smtp-Source: ABdhPJwYROoGkGZt6KQvqFerbMfc/dR6YQlgj1tfJoNfTb3oio7K82/Z9zxbSyNhIVaJ2ZsmrfecyQ==
X-Received: by 2002:a62:3812:0:b029:13e:d13d:a062 with SMTP id f18-20020a6238120000b029013ed13da062mr8718921pfa.40.1601761535153;
        Sat, 03 Oct 2020 14:45:35 -0700 (PDT)
Received: from [192.168.0.104] ([49.207.217.69])
        by smtp.gmail.com with ESMTPSA id y10sm6605367pfp.77.2020.10.03.14.45.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2020 14:45:34 -0700 (PDT)
Subject: Re: [PATCH v3] net: usb: rtl8150: set random MAC address when
 set_ethernet_addr() fails
To:     Joe Perches <joe@perches.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201003211931.11544-1-anant.thazhemadam@gmail.com>
 <d44d8c784f9df6f55dcf494c9c21cd11b16338d4.camel@perches.com>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <ed510989-841c-8f2f-73f0-3885eef35a99@gmail.com>
Date:   Sun, 4 Oct 2020 03:15:29 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d44d8c784f9df6f55dcf494c9c21cd11b16338d4.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 04/10/20 3:05 am, Joe Perches wrote:
> On Sun, 2020-10-04 at 02:49 +0530, Anant Thazhemadam wrote:
>> When get_registers() fails, in set_ethernet_addr(),the uninitialized
>> value of node_id gets copied as the address. This can be considered as
>> set_ethernet_addr() itself failing.
> []
>> diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
> []
>> @@ -909,7 +914,10 @@ static int rtl8150_probe(struct usb_interface *intf,
>>  		goto out1;
>>  	}
>>  	fill_skb_pool(dev);
>> -	set_ethernet_addr(dev);
>> +	if (!set_ethernet_addr(dev)) {
>> +		dev_err(&intf->dev, "assigining a random MAC address\n");
>> +		eth_hw_addr_random(dev->netdev);
> 4 things:
> .
> o Typo for assigning
Oh no. I'm sorry about that.
> o Reverse the assignment and message to show the new random MAC
Ah, okay. That would be more informative.
> o This should use netdev_<level>
Understood.
> o Is this better as error or notification?
>
> 	if (!set_ethernet_addr(dev)) {
> 		eth_hw_addr_random(dev->netdev);
> 		netdev_notice(dev->netdev, "Assigned a random MAC: %pM\n",
> 			      dev->netdev->dev_addr);
> 	}
I thought it might be an error since set_ethernet_addr() did fail after
all.  But making it info seems like a better idea, since technically speaking,
the device is still made accessible.

I'll wait for a day or two, to see if anybody else has any other comments,
and send in a v4 incorporating these changes.

Thanks,
Anant
