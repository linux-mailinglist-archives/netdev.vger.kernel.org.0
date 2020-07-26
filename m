Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C88F22E1C8
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 19:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgGZR6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 13:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgGZR6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 13:58:39 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B123BC0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 10:58:39 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id t11so7834238pfq.11
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 10:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HYL7qm5HfK3gO+k1ZGAFSPu9gAOgsUgty4Q670wt4Js=;
        b=dOvK1TXWpP8+gFau9jhrGr3VHVLrAlRL7IDipiw1GWeZ7IrmsIYn3CJnb8WU/aRD6r
         q+yE1L76oAqvVhCueXYvYXnM+wK/Ae1wyvxH7Xc3SoDIFKR57ywKiWVH28nRZqaTSkcw
         IvWbb2rzKofXm1ZA/WfU+QUU41m5OZRcAGyFPkxxM0aT46e6ZY9ZGn3uTYZ+dKeDdmPb
         IxTX3TbBlZXezuvH0/u1+R+fvE1Q7wi24CciZFogZ9qvgDTOw91BvFZ8YEpjePq/YEZD
         XghPv3x2O04nmcsFKwFBgXKrK04d9+w9RECYA58WaBRkIQ5EhzGHIiV3PULg+lJupK0m
         aaaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HYL7qm5HfK3gO+k1ZGAFSPu9gAOgsUgty4Q670wt4Js=;
        b=dT/ib2Rm+GH1Hx45FWq7HElciwWV5qY3l62y/yxcRcxzUdG06//seIOOOWyaz60Ss5
         izrC1Lv9pdzafqbxCW9iJ36/XSgHK1pjWUZZ5DE//5iBYb14mi08ipK80VlXa3Tl7qE1
         KHBoGEkjTPBcZ1aUcgd7ktq044UKernHTaM7HGyg1sIs6mM0JSZSIivwFVi0Qum/N2Me
         sYQr3U5pvAXUTc1H8hGbaeSHjcJZxZbqw5iyI05flOIzmrUQ2qVn9sJCzZHD5Ged1qeI
         Y33Hi4UyJ023ybgOCg8OBL/xMKJ5KRtmqAV5Qubm5Ub6YAkqN3cnA6ZTSUyGp4k2MI/e
         rnJA==
X-Gm-Message-State: AOAM530OONYuCEj4M4QYtVo9cqpY7LFtFCdXm+a/Z5ERMdKdHe0FpqAm
        bFgkdL+ZbGm6p2jeO52aLls=
X-Google-Smtp-Source: ABdhPJxW2pT9VW4KamAxXiUXFNP1WlaR8uK054Be6UJEWfwgbYwPEefiBKqow5L8lSlFUydhNUtwKA==
X-Received: by 2002:a05:6a00:14ce:: with SMTP id w14mr16570194pfu.304.1595786319030;
        Sun, 26 Jul 2020 10:58:39 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id e8sm1768250pfd.34.2020.07.26.10.58.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2020 10:58:38 -0700 (PDT)
Subject: Re: [RFC] net: add support for threaded NAPI polling
To:     Felix Fietkau <nbd@nbd.name>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Cc:     Hillf Danton <hdanton@sina.com>
References: <20200726163119.86162-1-nbd@nbd.name>
 <546c2923-ca6e-00e7-8bcb-3a3eb034a58e@gmail.com>
 <daad6ba2-6916-3923-c116-d0470920fe1a@nbd.name>
From:   Eric Dumazet <erdnetdev@gmail.com>
Message-ID: <0305d884-0f59-b9c3-5489-b6fd1391d76d@gmail.com>
Date:   Sun, 26 Jul 2020 10:58:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <daad6ba2-6916-3923-c116-d0470920fe1a@nbd.name>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/26/20 10:19 AM, Felix Fietkau wrote:
> On 2020-07-26 18:49, Eric Dumazet wrote:
>> On 7/26/20 9:31 AM, Felix Fietkau wrote:
>>> For some drivers (especially 802.11 drivers), doing a lot of work in the NAPI
>>> poll function does not perform well. Since NAPI poll is bound to the CPU it
>>> was scheduled from, we can easily end up with a few very busy CPUs spending
>>> most of their time in softirq/ksoftirqd and some idle ones.
>>>
>>> Introduce threaded NAPI for such drivers based on a workqueue. The API is the
>>> same except for using netif_threaded_napi_add instead of netif_napi_add.
>>>
>>> In my tests with mt76 on MT7621 using threaded NAPI + a thread for tx scheduling
>>> improves LAN->WLAN bridging throughput by 10-50%. Throughput without threaded
>>> NAPI is wildly inconsistent, depending on the CPU that runs the tx scheduling
>>> thread.
>>>
>>> With threaded NAPI, throughput seems stable and consistent (and higher than
>>> the best results I got without it).
>>
>> Note that even with a threaded NAPI, you will not be able to use more than one cpu
>> to process the traffic.
> For a single threaded NAPI user that's correct. The main difference here
> is that the CPU running the poll function does not have to be the same
> as the CPU that scheduled it, and it can change based on the load.
> That makes a huge difference in my tests.

This really looks like there is a problem in the driver itself.

Have you first checked that this patch was not hurting your use case ?

commit 4cd13c21b207e80ddb1144c576500098f2d5f882    softirq: Let ksoftirqd do its job

If yes, your proposal would again possibly hurt user space threads competing
with a high priority workqueue, and packets would not be consumed by user applications.
Having cpus burning 100% of cycles in kernel space is useless.


It seems you need two cpus per queue, I guess this might be because
you use a single NAPI for both tx and rx ?

Have you simply tried to use two NAPI, as some Ethernet drivers do ?

Do not get me wrong, but scheduling a thread only to process one packet at a time
will hurt common cases.

Really I do not mind if you add a threaded NAPI, but it seems you missed
a lot of NAPI requirements in the proposed patch.

For instance, many ->poll() handlers assume BH are disabled.

Also part of RPS logic depends on net_rx_action() calling net_rps_action_and_irq_enable()


