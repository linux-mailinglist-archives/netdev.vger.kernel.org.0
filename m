Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814C33ED923
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 16:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhHPOq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 10:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbhHPOq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 10:46:59 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC2FC061764;
        Mon, 16 Aug 2021 07:46:27 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id bq25so22194418ejb.11;
        Mon, 16 Aug 2021 07:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5gRcCSfuDiif1weUga1cR6YDto2XU1RGTA+nGmrUzlA=;
        b=Jng5b8NzqkU23UbDejFxtGjMbUB5GDNcV/64Tit7qlan9nFxUq1TGflKqtaxJTh9US
         QFSxMvShLT2fvSpnKAomKUYAQ/HU09BbSrRFlxYeXFkZhLB1/htbn44TePJAW9Hh51wq
         0+k/pNQ85GRc21wu15vaeGyCQs3P/XFEhs+u2KgXXFMFgs+fogBwwo9KCjgbb3QEwkKn
         /V0sOwFRXQX91njIMyaWLjx4QqDzJqbL7ChWeB4YO/xnEhPOF0+egRiftSURothV3HWC
         qmsvcdcHkvffvT4ZlrmZ5U8nYW6YMMDtnJfi/eXxYDbBOTAZq7Kat5QCrHfmBwwZVuQ6
         4klA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5gRcCSfuDiif1weUga1cR6YDto2XU1RGTA+nGmrUzlA=;
        b=qZLrcmXlFoeh8A0MElgCi8ptQJq899/jbRd6L5qP9YXGTI3dKkd1xTfsd3zqhHpb47
         /SMfe5iO08WL9kJy0jwgGRI+zyAjTjwvN0kdGfeWwJKqvQW4RPFV7KxbKivXOD/qsvH+
         c75OpK69QXgAi/5xPRm2Cg7NhPkO3cccnFdul7FBKSahc4V+Rt4FMhKGxzbVTqozYNGx
         jmK4SJ+RNPZ5UU1c2tAPpbdAQutuPDY6n5vxS9L13EKYixRS4MAKLHK+l385DMkjT6aL
         rCg3PFdNsuBpIk4FYP0g6wkmarLgQmwZBtrP7dGAdwNz1ljanNfX9IH0esyPs4nGoLim
         0fpg==
X-Gm-Message-State: AOAM531/QUHr9t5DlntFCEoC/tzBu8JFLnisgtp8mp7ppdvHOg7WF0/U
        oO82qaa14LcYdhXdloiJ8Ug=
X-Google-Smtp-Source: ABdhPJyaE3N8N7ro9b3JQPjkfT7sQ1cJVMRUiyqsxaFpKfdR6rd3n0D2wqKpvdpRcTrF2ZcJYEwzJQ==
X-Received: by 2002:a17:907:7895:: with SMTP id ku21mr7753366ejc.361.1629125186076;
        Mon, 16 Aug 2021 07:46:26 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id r2sm4990871edv.78.2021.08.16.07.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 07:46:25 -0700 (PDT)
Date:   Mon, 16 Aug 2021 17:46:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Rowand <frowand.list@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: of_node_put() usage is buggy all over drivers/of/base.c?!
Message-ID: <20210816144622.tgslast6sbblclda@skbuf>
References: <20210814010139.kzryimmp4rizlznt@skbuf>
 <9accd63a-961c-4dab-e167-9e2654917a94@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9accd63a-961c-4dab-e167-9e2654917a94@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Frank,

On Mon, Aug 16, 2021 at 09:33:03AM -0500, Frank Rowand wrote:
> Hi Vladimir,
> 
> On 8/13/21 8:01 PM, Vladimir Oltean wrote:
> > Hi,
> > 
> > I was debugging an RCU stall which happened during the probing of a
> > driver. Activating lock debugging, I see:
> 
> I took a quick look at sja1105_mdiobus_register() in v5.14-rc1 and v5.14-rc6.
> 
> Looking at the following stack trace, I did not see any calls to
> of_find_compatible_node() in sja1105_mdiobus_register().  I am
> guessing that maybe there is an inlined function that calls
> of_find_compatible_node().  This would likely be either
> sja1105_mdiobus_base_tx_register() or sja1105_mdioux_base_t1_register().

Yes, it is sja1105_mdiobus_base_t1_register which is inlined.

> > 
> > [  101.710694] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:938
> > [  101.719119] in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 1534, name: sh
> > [  101.726763] INFO: lockdep is turned off.
> > [  101.730674] irq event stamp: 0
> > [  101.733716] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> > [  101.739973] hardirqs last disabled at (0): [<ffffd3ebecb10120>] copy_process+0xa78/0x1a98
> > [  101.748146] softirqs last  enabled at (0): [<ffffd3ebecb10120>] copy_process+0xa78/0x1a98
> > [  101.756313] softirqs last disabled at (0): [<0000000000000000>] 0x0
> > [  101.762569] CPU: 4 PID: 1534 Comm: sh Not tainted 5.14.0-rc5+ #272
> > [  101.774558] Call trace:
> > [  101.794734]  __might_sleep+0x50/0x88
> > [  101.798297]  __mutex_lock+0x60/0x938
> > [  101.801863]  mutex_lock_nested+0x38/0x50
> > [  101.805775]  kernfs_remove+0x2c/0x50             <---- this takes mutex_lock(&kernfs_mutex);
> > [  101.809341]  sysfs_remove_dir+0x54/0x70
> 
> The __kobject_del() occurs only if the refcount on the node
> becomes zero.  This should never be true when of_find_compatible_node()
> calls of_node_put() unless a "from" node is passed to of_find_compatible_node().

I figured that was the assumption, that the of_node_put would never
trigger a sysfs file / kobject deletion from there.

> In both sja1105_mdiobus_base_tx_register() and sja1105_mdioux_base_t1_register()
> a from node ("mdio") is passed to of_find_compatible_node() without first doing an
> of_node_get(mdio).  If you add the of_node_get() calls the problem should be fixed.

The answer seems simple enough, but stupid question, but why does
of_find_compatible_node call of_node_put on "from" in the first place?
