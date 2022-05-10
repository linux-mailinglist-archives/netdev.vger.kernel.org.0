Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263BE520B4F
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 04:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbiEJCiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 22:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233119AbiEJCiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 22:38:02 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42F5238D46
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 19:34:06 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id t13so13514495pgn.8
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 19:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=schmorgal.com; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=PlGbs7sRmxO6R9+ibB4UvNo21NsioKWBMQl4Fg8NMkE=;
        b=MHB6NevCGfYuuW7u5cJ+IxPobq2VLZN45uYsLTPFywxB2CJhiXECSNn6gS0lTWLnhM
         bDG+dfRcmKbjZw5HVwrEtMmANI6PwlJLRFErHCgqf3SXxC8D4ROdXr5LUw5SFIGWB8XK
         jAc70wy6/Ib6VNM74+ijIBgyZMjlvnfTUtCkI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=PlGbs7sRmxO6R9+ibB4UvNo21NsioKWBMQl4Fg8NMkE=;
        b=FuZ8mmTZ9rVl/w5UZfDjRexNvODcMS5VJO1UM5zzkzL4aHQWloifM9+sK0O9PwGf/A
         TbcnVyE8OthLnLZiAU1FybMC1N9+qNv/1mszVK/DdnvYC1XHUCOTpGxwBdS5K0LRRBCB
         RQDDFN+vRbbsCcTmyyNnAu/3C1IG4wlSo3mGoqDw0hijCtfGmJuHceP3JDo8uLA6U6lr
         WoFcnfwovz0vAJsyyYV32zXIytBAugVvQnLenyGHng5RmyKmwMatt2VKXpBDx5+xCI0a
         ULgi55TK+LLp6kf/NBAqSU565waXdq+gosS7qm9JgshLMFE7+aAu2mndHIJoAJ8FB5YW
         Uuug==
X-Gm-Message-State: AOAM530AuXK3jN+u5Mm82+94mVS+0d/a2LM56RDops1AXO6OlRyBM+Wu
        idDcKQm5wcV5DW0Xd+REYjvKow==
X-Google-Smtp-Source: ABdhPJxE3kKSfKkU5MwdRrUTbR2PApkCH7DOCTo4jgy8b7wCwX/lAuQ6qbLOtfm/aPeDVj2yTiToCg==
X-Received: by 2002:a63:531c:0:b0:3c6:a5d7:8bae with SMTP id h28-20020a63531c000000b003c6a5d78baemr8044607pgb.505.1652150046102;
        Mon, 09 May 2022 19:34:06 -0700 (PDT)
Received: from [192.168.1.33] ([50.45.132.243])
        by smtp.googlemail.com with ESMTPSA id c22-20020a17090aa61600b001cd498dc152sm1156155pjq.2.2022.05.09.19.34.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 19:34:05 -0700 (PDT)
Message-ID: <9cac4fbd-9557-b0b8-54fa-93f0290a6fb8@schmorgal.com>
Date:   Mon, 9 May 2022 19:34:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
References: <20220509150130.1047016-1-kuba@kernel.org>
 <CAK8P3a0FVM8g0LG3_mHJ1xX3Bs9cxae8ez7b9qvGOD+aJdc8Dw@mail.gmail.com>
 <20220509103216.180be080@kernel.org>
From:   Doug Brown <doug@schmorgal.com>
Subject: Re: [PATCH net-next] net: appletalk: remove Apple/Farallon LocalTalk
 PC support
In-Reply-To: <20220509103216.180be080@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/2022 10:32 AM, Jakub Kicinski wrote:
> On Mon, 9 May 2022 19:14:42 +0200 Arnd Bergmann wrote:
>> I think however, if we remove this driver, we need to discuss removing the
>> last remaining localtalk driver (CONFIG_COPS) and possibly the localtalk
>> bits in net/appletalk along with it.
> Removing COPS and appletalk makes perfect sense to me (minus what Doug
> has plans to use, obviously).

I also think removing the COPS driver is a great idea. I actually ended
up buying a compatible card in the hopes of working on that driver to
change it to load the firmware through the firmware API, but the
licensing situation with the firmware blobs kind of brought that idea to
a standstill. I would be very surprised if anybody is actually using
LocalTalk ISA cards these days anyway, so it's probably not worth the
effort to maintain it.

There have been a few "modern" LocalTalk interface projects. One is
mine, which I haven't found time to finish, but I was able to get
working in the kernel with a lt0 network interface. I suspect I was the
only one in the last decade to actually use the LocalTalk code in modern
kernel versions, because it was crashing until I fixed a bug involving
too short of a header length being allocated. There's another more
recent LocalTalk project called TashTalk [1]. A kernel driver could be
developed for it using serdev or a tty ldisc, but all of the current
development seems focused on the userspace side.

With that in mind, I personally wouldn't be sad to see the entire
LocalTalk interface support stripped from the kernel, as long as
EtherTalk support can remain. There is still a decent sized community of
users who are using it to talk with classic Macs using netatalk 2.x.
So most of the stuff in net/appletalk is still relevant today for us.

Might as well remove CONFIG_IPDDP too. It actually -interferes- with the
current way that people do MacIP gateways through userspace with macipgw
[2]. I'm not aware of anyone actually using the kernel's implementation.

Doug

[1] https://github.com/lampmerchant/tashtalk
[2] https://github.com/jasonking3/macipgw#kernel

