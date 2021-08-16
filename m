Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A7E3ED902
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 16:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbhHPOdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 10:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbhHPOdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 10:33:37 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F34FC061764;
        Mon, 16 Aug 2021 07:33:05 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id t3so19215781qkg.11;
        Mon, 16 Aug 2021 07:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ohvdkImJtmas5BJ9f24j7URfQFSDqGAKrZu4zufh8Es=;
        b=Fts5l2TTYQeSTXf5sl+whP+powtc5W2aeL+6GmFNbaRj1VbE98sMv4b5vcC6t2zCRo
         061M/OG1sA/hb8RXfypLlPaZk+T2Td2BuCXRWEVLhlDO18eZPQHigLn7IHwlbMxc85uB
         MxluS/F+61Vzr18YNSKgS/B86wwb4v5Ies6LYBzsoa1Wopq3gK/2evF8oRNuZ2EdO8HT
         ZJAYS9u+gZeqHSSGqqSGhA3eaH9u4aeiGDjVg8cszGygeOOFwmiLWodVR9g+MtXkzI5B
         oMJUNAuW1SChkWAL6wJJ541qyI3eUYdutVgNykn0Fgid5VAX9D8pXtzu3b70jVocCstz
         NLAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ohvdkImJtmas5BJ9f24j7URfQFSDqGAKrZu4zufh8Es=;
        b=tGs5+F3XM30m0d3jdhkCQ+Oa1BlqY9gxgzMhDN9KjGJkUQ/NNQaws4Xv4RopHnREfE
         uRS7hJHrRbuRgNv41/zmzVzsS26sBy4U8Qv50TN70f9/d3aE+5wHCHWF9aknjaUIOGaL
         u1OySCoudJaYpShtKnGlJEN1y24H4eIUPM9txHItn6NxNpN7Ilf28yZRuevj7dXeh7NX
         5iOo2pHXZNJet6kIWQ3Rjd94Ee/Dt9HHjOXXUOHWeTZ4Zy0WWm7EbtxvZgxcjDmUZre0
         l403YHOu4udoU+bZo2QvLD7oJ587bcp5T4ZM1x/OgnQ6ir86++id5dbuLzQcE77HiH4M
         yskA==
X-Gm-Message-State: AOAM531QoJ2+/DfEcto69A2ISs0sbMWADJNSYEfKKxGfqVw8r0kEM0Fc
        lmFVUAprX+kMg7TB9j+6yTO5lffUDvwU5Q==
X-Google-Smtp-Source: ABdhPJxL6+B+cS4nBgq0kwRnZpu9AE9yBFeuO45YgAikvQl8xUsG+RrH6zbVezboCFt2uum+qiubcA==
X-Received: by 2002:a37:c09:: with SMTP id 9mr7605464qkm.73.1629124384590;
        Mon, 16 Aug 2021 07:33:04 -0700 (PDT)
Received: from [192.168.1.49] (c-67-187-90-124.hsd1.ky.comcast.net. [67.187.90.124])
        by smtp.gmail.com with ESMTPSA id c1sm4828177qtj.36.2021.08.16.07.33.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 07:33:04 -0700 (PDT)
Subject: Re: of_node_put() usage is buggy all over drivers/of/base.c?!
To:     Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210814010139.kzryimmp4rizlznt@skbuf>
From:   Frank Rowand <frowand.list@gmail.com>
Message-ID: <9accd63a-961c-4dab-e167-9e2654917a94@gmail.com>
Date:   Mon, 16 Aug 2021 09:33:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210814010139.kzryimmp4rizlznt@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On 8/13/21 8:01 PM, Vladimir Oltean wrote:
> Hi,
> 
> I was debugging an RCU stall which happened during the probing of a
> driver. Activating lock debugging, I see:

I took a quick look at sja1105_mdiobus_register() in v5.14-rc1 and v5.14-rc6.

Looking at the following stack trace, I did not see any calls to
of_find_compatible_node() in sja1105_mdiobus_register().  I am
guessing that maybe there is an inlined function that calls
of_find_compatible_node().  This would likely be either
sja1105_mdiobus_base_tx_register() or sja1105_mdioux_base_t1_register().

> 
> [  101.710694] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:938
> [  101.719119] in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 1534, name: sh
> [  101.726763] INFO: lockdep is turned off.
> [  101.730674] irq event stamp: 0
> [  101.733716] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> [  101.739973] hardirqs last disabled at (0): [<ffffd3ebecb10120>] copy_process+0xa78/0x1a98
> [  101.748146] softirqs last  enabled at (0): [<ffffd3ebecb10120>] copy_process+0xa78/0x1a98
> [  101.756313] softirqs last disabled at (0): [<0000000000000000>] 0x0
> [  101.762569] CPU: 4 PID: 1534 Comm: sh Not tainted 5.14.0-rc5+ #272
> [  101.774558] Call trace:
> [  101.794734]  __might_sleep+0x50/0x88
> [  101.798297]  __mutex_lock+0x60/0x938
> [  101.801863]  mutex_lock_nested+0x38/0x50
> [  101.805775]  kernfs_remove+0x2c/0x50             <---- this takes mutex_lock(&kernfs_mutex);
> [  101.809341]  sysfs_remove_dir+0x54/0x70

The __kobject_del() occurs only if the refcount on the node
becomes zero.  This should never be true when of_find_compatible_node()
calls of_node_put() unless a "from" node is passed to of_find_compatible_node().

In both sja1105_mdiobus_base_tx_register() and sja1105_mdioux_base_t1_register()
a from node ("mdio") is passed to of_find_compatible_node() without first doing an
of_node_get(mdio).  If you add the of_node_get() calls the problem should be fixed.

-Frank


> [  101.813166]  __kobject_del+0x3c/0x80
> [  101.816733]  kobject_put+0xf8/0x108
> [  101.820211]  of_node_put+0x18/0x28
> [  101.823602]  of_find_compatible_node+0xa8/0xf8    <--- this takes raw_spin_lock_irqsave(&devtree_lock)
> [  101.828036]  sja1105_mdiobus_register+0x264/0x7a8
> 
> The pattern of calling of_node_put from under the atomic devtree_lock
> context is pretty widespread in drivers/of/base.c.
> 
> Just by inspecting the code, this seems to be an issue since commit:
> 
> commit 75b57ecf9d1d1e17d099ab13b8f48e6e038676be
> Author: Grant Likely <grant.likely@linaro.org>
> Date:   Thu Feb 20 18:02:11 2014 +0000
> 
>     of: Make device nodes kobjects so they show up in sysfs
> 
>     Device tree nodes are already treated as objects, and we already want to
>     expose them to userspace which is done using the /proc filesystem today.
>     Right now the kernel has to do a lot of work to keep the /proc view in
>     sync with the in-kernel representation. If device_nodes are switched to
>     be kobjects then the device tree code can be a whole lot simpler. It
>     also turns out that switching to using /sysfs from /proc results in
>     smaller code and data size, and the userspace ABI won't change if
>     /proc/device-tree symlinks to /sys/firmware/devicetree/base.
> 
>     v7: Add missing sysfs_bin_attr_init()
>     v6: Add __of_add_property() early init fixes from Pantelis
>     v5: Rename firmware/ofw to firmware/devicetree
>         Fix updating property values in sysfs
>     v4: Fixed build error on Powerpc
>         Fixed handling of dynamic nodes on powerpc
>     v3: Fixed handling of duplicate attribute and child node names
>     v2: switch to using sysfs bin_attributes which solve the problem of
>         reporting incorrect property size.
> 
>     Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>     Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
>     Cc: Rob Herring <rob.herring@calxeda.com>
>     Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>     Cc: David S. Miller <davem@davemloft.net>
>     Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
>     Cc: Pantelis Antoniou <panto@antoniou-consulting.com>
> 
> because up until that point, of_node_put() was:
> 
> void of_node_put(struct device_node *node)
> {
> 	if (node)
> 		kref_put(&node->kref, of_node_release);
> }
> 
> and not:
> 
> void of_node_put(struct device_node *node)
> {
> 	if (node)
> 		kobject_put(&node->kobj);
> }
> 
> Either I'm holding it very, very wrong, or this is a very severe
> oversight that just happened somehow to go unnoticed for 7 years.
> 
> Please tell me it's me.
> 

