Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773121EFE32
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 18:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgFEQsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 12:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgFEQsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 12:48:51 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A558C08C5C2
        for <netdev@vger.kernel.org>; Fri,  5 Jun 2020 09:48:51 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d8so689747plo.12
        for <netdev@vger.kernel.org>; Fri, 05 Jun 2020 09:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JkO9jWEk3mPmuBJgeHUNv1PhPeZMVmnow62Budkdjso=;
        b=qlcTsmK/tEc0xZlaz0qH3XuhZROct2NrgveOpapZfmcVZ5hfla2Kr46LgDQlvfhA7F
         yLW+7ss/3xoI2YJFAkXGd/IV/QagcjXpAx5YA1J3EvrVLXlR9mgyK8wRLhwQDdpAgX0e
         Lea4EbyfPEZDoqo9zMVKbBCZzkVCdecbVOCxU3E6RH/R8GvbZtqFBNp8anCo4HBcycXG
         PBgk3L1KkJWBpGBj0vMw47rNJYmv/PnYrD7w+adckgr6cywNvN35qIqMXUCgLJq6WHxV
         84AmrGIcgBnDxRsutG+Sde+DBRMZbLMSklmakodCOofzU8IttFu6FnwZy378rSbju7vB
         67Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JkO9jWEk3mPmuBJgeHUNv1PhPeZMVmnow62Budkdjso=;
        b=b+r7nM6EmFC1wuFv4LPTCCT9bumrQVrbwJCPTgFjNU5/Tra2W8Mnj2kCV6XcKWmtfP
         2NR6B9t7921ik0t2kbk8IpJ7+3RJaIOYXdOgw0qQhpGfNb5sEHbWehx8oYuqplT1Z9VV
         hzb7/mFBOzRrxYcpNDewrZB6PcNQJvMdlc2cYvq4EBY/KhQuQk4gufY9pJ7ySP8F8/cd
         4por1MphEUVMjsvKeuVXAGC5OYopvwUY40Y6LRPwVlLvGJ94seNpx8i/jM+t7c4jpTak
         ML0TneHq6QLmUKllqiAZWG13U79wa7/JjWx+gSBWeMgRX81DPSIYeaZuPbGBbBSYdXsO
         2wrA==
X-Gm-Message-State: AOAM532Veg4qXaclDblO+FRom61LSGXDjF5mbVujYbLVIksT3TfPqh+h
        +41/7Y/BNTyqx6Hrm1vmzosC/P1N
X-Google-Smtp-Source: ABdhPJy1e3fLWM0xZ3gLdoMTWSS9psOBJllG1ZrH1VyWcth+ZuWmTT8PaMMjpTcUN3w0OJ2PEQGrbA==
X-Received: by 2002:a17:90b:3793:: with SMTP id mz19mr3922897pjb.12.1591375730835;
        Fri, 05 Jun 2020 09:48:50 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id b16sm129349pfd.111.2020.06.05.09.48.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 09:48:49 -0700 (PDT)
Subject: Re: TCP_DEFER_ACCEPT wakes up without data
To:     Christoph Paasch <christoph.paasch@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Julian Anastasov <ja@ssi.bg>, Wayne Badger <badger@yahoo-inc.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leif Hedstrom <lhedstrom@apple.com>
References: <538FB666.9050303@yahoo-inc.com>
 <alpine.LFD.2.11.1406071441260.2287@ja.home.ssi.bg>
 <5397A98F.2030206@yahoo-inc.com>
 <58a4abb51fe9411fbc7b1a58a2a6f5da@UCL-MBX03.OASIS.UCLOUVAIN.BE>
 <CALMXkpYBMN5VR9v+xL0fOC6srABYd38x5tGJG5od+VNMS+BSAw@mail.gmail.com>
 <878029e5-b2b2-544c-f4b5-ff4c76fd6bd3@gmail.com>
 <CALMXkpbNeRCrOnQFWAWR8BzX4yRgDveDMPZgS6NupjXrHFX1pg@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b520b541-9013-3095-2e3b-37ec835e4ff8@gmail.com>
Date:   Fri, 5 Jun 2020 09:48:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALMXkpbNeRCrOnQFWAWR8BzX4yRgDveDMPZgS6NupjXrHFX1pg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/5/20 7:57 AM, Christoph Paasch wrote:
> On Thu, Jun 4, 2020 at 6:28 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>>
>> On 6/4/20 4:18 PM, Christoph Paasch wrote:
>>> +Eric & Leif
>>>
>>> Hello,
>>>
>>>
>>> (digging out an old thread ... ;-) )
>>>
>>
>> Is there a tldr; ?
> 
> Sure! TCP_DEFER_ACCEPT delays the creation of the socket until data
> has been sent by the client *or* the specified time has expired upon
> which a last SYN/ACK is sent and if the client replies with an ACK the
> socket will be created and presented to the accept()-call. In the
> latter case it means that the app gets a socket that does not have any
> data to be read - which goes against the intention of TCP_DEFER_ACCEPT
> (man-page says: "Allow a listener to be awakened only when data
> arrives on the socket.").
> 
> In the original thread the proposal was to kill the connection with a
> TCP-RST when the specified timeout expired (after the final SYN/ACK).
> 
> Thus, my question in my first email whether there is a specific reason
> to not do this.
> 
> API-breakage does not seem to me to be a concern here. Apps that are
> setting DEFER_ACCEPT probably would not expect to get a socket that
> does not have data to read.

Thanks for the summary ;)

I disagree.

A server might have two modes :

1) A fast path, expecting data from user in a small amount of time, from peers not too far away.

2) A slow path, for clients far away. Server can implement strategies to control number of sockets
that have been accepted() but not yet active (no data yet received).

I have attended many conferences with bad wifi networks to pretend that 3WHS + headers can always
be completed in X seconds.

> 
> 
> Thanks,
> Christoph
> 
