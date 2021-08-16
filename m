Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD373ED9A9
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 17:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhHPPO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 11:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbhHPPOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 11:14:55 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F0AC0613C1;
        Mon, 16 Aug 2021 08:14:24 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id t190so6044899qke.7;
        Mon, 16 Aug 2021 08:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PCGu6LKv/RVKdtYv9khNj4fVhn3c3G222WeZkDQYghA=;
        b=CISces9TDTtyNHUhb+Dzk9UPoZjkkFXWYex7qH35eoRxGkQVLgR/1DTqaRkfd78IuQ
         xpRbqNcaPxnjmxKfMPsl97t8z5ktu5ohAzxkVsEyke1kmjRaLwCC4bQxurQJX+scFQUa
         xMM6XOi+foF8nmOqGYxv8ZoWEyfaMniSFzs1s03DYzWXAE9vqHIG9g7YVvlYPGws3vpT
         6yioiJMXf3ojQrLqCPUqabZWVIkq2LJxyYYkkWffzSbNWvvzzjkuw9rldmpJMEtICRWP
         rXdcOrs16jzuzo4rGDTodQBL7ocHJ9hFU14MZNNq4073wGUxuvxL9GtbvYpe9T6cwVEV
         Clgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PCGu6LKv/RVKdtYv9khNj4fVhn3c3G222WeZkDQYghA=;
        b=Ihkm6RMAxIdD35JgUKbeJb+S5/XcAfVZN1uxcqRN94KNAyRKJl4EUGpHQNKfe8F4Mk
         D5iYzzE5qzryqDO288fVsCdb0lBBhpfzqGxusDupYBwKkQfXlC/a3s3gu2XndagpfyBR
         rbJSskndQ+c5Ym0JS3roe9jZn5GfbcqtZdnujxn/bWmL0k60uPQqhFL5tZ0nM/z49gim
         7pCAJaC++HaZYvNe661FrbC9xGj7f2OB77xpkJuG+D/t1ZaHLhOwPamXGijdZi5hmQsD
         pGbFDmOsZuw0YTbEq4F/Tnh0ytAj7bThh33WmXEJ29dfnAebBrgktu6+cGQlRhOKQmSZ
         5lCQ==
X-Gm-Message-State: AOAM5301guf6ysAatA1XuP47AY3XJZogeQer+hDYTMXSHq0C4QZFVUuw
        83P40FZFPFG70AWKfmrZ7pI=
X-Google-Smtp-Source: ABdhPJx10FRGjHSg4Ez0RVwMZX3QF/Boe88olE7QrDUkXZMVx1/+P4kFFuKCAIsHCE6XhGJENd4vpQ==
X-Received: by 2002:a37:d4c:: with SMTP id 73mr16227882qkn.188.1629126863427;
        Mon, 16 Aug 2021 08:14:23 -0700 (PDT)
Received: from [192.168.1.49] (c-67-187-90-124.hsd1.ky.comcast.net. [67.187.90.124])
        by smtp.gmail.com with ESMTPSA id y9sm4771547qtw.51.2021.08.16.08.14.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 08:14:23 -0700 (PDT)
Subject: Re: of_node_put() usage is buggy all over drivers/of/base.c?!
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210814010139.kzryimmp4rizlznt@skbuf>
 <9accd63a-961c-4dab-e167-9e2654917a94@gmail.com>
 <20210816144622.tgslast6sbblclda@skbuf>
From:   Frank Rowand <frowand.list@gmail.com>
Message-ID: <4cad28e0-d6b4-800d-787b-936ffaca7be3@gmail.com>
Date:   Mon, 16 Aug 2021 10:14:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210816144622.tgslast6sbblclda@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/21 9:46 AM, Vladimir Oltean wrote:
> Hi Frank,
> 
> On Mon, Aug 16, 2021 at 09:33:03AM -0500, Frank Rowand wrote:
>> Hi Vladimir,
>>
>> On 8/13/21 8:01 PM, Vladimir Oltean wrote:
>>> Hi,
>>>
>>> I was debugging an RCU stall which happened during the probing of a
>>> driver. Activating lock debugging, I see:
>>
>> I took a quick look at sja1105_mdiobus_register() in v5.14-rc1 and v5.14-rc6.
>>
>> Looking at the following stack trace, I did not see any calls to
>> of_find_compatible_node() in sja1105_mdiobus_register().  I am
>> guessing that maybe there is an inlined function that calls
>> of_find_compatible_node().  This would likely be either
>> sja1105_mdiobus_base_tx_register() or sja1105_mdioux_base_t1_register().
> 
> Yes, it is sja1105_mdiobus_base_t1_register which is inlined.
> 
>>>
>>> [  101.710694] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:938
>>> [  101.719119] in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 1534, name: sh
>>> [  101.726763] INFO: lockdep is turned off.
>>> [  101.730674] irq event stamp: 0
>>> [  101.733716] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
>>> [  101.739973] hardirqs last disabled at (0): [<ffffd3ebecb10120>] copy_process+0xa78/0x1a98
>>> [  101.748146] softirqs last  enabled at (0): [<ffffd3ebecb10120>] copy_process+0xa78/0x1a98
>>> [  101.756313] softirqs last disabled at (0): [<0000000000000000>] 0x0
>>> [  101.762569] CPU: 4 PID: 1534 Comm: sh Not tainted 5.14.0-rc5+ #272
>>> [  101.774558] Call trace:
>>> [  101.794734]  __might_sleep+0x50/0x88
>>> [  101.798297]  __mutex_lock+0x60/0x938
>>> [  101.801863]  mutex_lock_nested+0x38/0x50
>>> [  101.805775]  kernfs_remove+0x2c/0x50             <---- this takes mutex_lock(&kernfs_mutex);
>>> [  101.809341]  sysfs_remove_dir+0x54/0x70
>>
>> The __kobject_del() occurs only if the refcount on the node
>> becomes zero.  This should never be true when of_find_compatible_node()
>> calls of_node_put() unless a "from" node is passed to of_find_compatible_node().
> 
> I figured that was the assumption, that the of_node_put would never
> trigger a sysfs file / kobject deletion from there.
> 
>> In both sja1105_mdiobus_base_tx_register() and sja1105_mdioux_base_t1_register()
>> a from node ("mdio") is passed to of_find_compatible_node() without first doing an
>> of_node_get(mdio).  If you add the of_node_get() calls the problem should be fixed.
> 
> The answer seems simple enough, but stupid question, but why does
> of_find_compatible_node call of_node_put on "from" in the first place?

Actually a good question.

I do not know why of_find_compatible_node() calls of_node_put() instead of making
the caller of of_find_compatible_node() responsible.  That pattern was created
long before I was involved in devicetree and I have not gone back to read the
review comments of when that code was created.

-Frank
