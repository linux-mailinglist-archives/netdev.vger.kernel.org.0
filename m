Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32DA6A8D3C
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731784AbfIDQiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:38:12 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:36933 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731719AbfIDQiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 12:38:11 -0400
Received: by mail-pl1-f171.google.com with SMTP id b10so4738924plr.4
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 09:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=6p+EadpIEkDO8QoEYI3Jt17cSz/BH+ON+7PoffN3Xhc=;
        b=M9T0J4qAQOkwfTE2/xDLS8ecvYc4kFqyL/WnIDImvGdqKjxF36Kgohw4IfcxAJflLq
         Q24IuRFANU2tNNtDD9fJqbgIv/8n4RBYxt/N8BlWp5OzkmjatBOH4xV4CS4aQlpKozvH
         jPhV5LTJxVXQCThVedS0630Vfyc4NjIASZsfV3rkuNLBk1+K7gPnoOGie+tgo2M26iSl
         cQJEwdTUIwPgRd1exlvTfpB7EENMUhnc3eQTdoYobl0SEmJy1qN7cqyQFnWHLL+8JXco
         LRfgPZQTYgMjAfo4zaTRjfJyIk0A21Cz8TGlwbNOOVitv9k6NBEfIgd78+FF3wmj70yp
         mETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=6p+EadpIEkDO8QoEYI3Jt17cSz/BH+ON+7PoffN3Xhc=;
        b=qvvtAhVCJn+3X2gOBW8e2t3jFABI5N/H82MdGQVVeds6VggT7x/ya81f+4XqeeFhXo
         qHolkCgfMUk+YXH6wKHtt5Z6EW1/oSRA3weyLmOxz95K/Yc7p0FFi5zOkrtSb6m6UZmY
         gjhlr/hXg9aPPelIcyNP48DtaF3NzkQ1h/KfnfX/ot5KY4hC3UzueTfRufA8RWiWF+jh
         wGaXl4ysOK9+N/thSHhYmvzSyt+4jJoPdfOfNHWkZipm8cPaUFkhouWFknO0w7nl9nOx
         jY/Mz2cZ21tTByhl4oKP6LsnPqDeSJ3g+3IJNZ8fWBo5PnJn+4R0xLP/VHW0+baS/71u
         W8Rg==
X-Gm-Message-State: APjAAAUjOZVRQKNQjnZTlQzr5OmSVeix7k4r264aiDUmUwyWQMGfc0oo
        oPGgfDsJD4OPFNodeGEUN8w=
X-Google-Smtp-Source: APXvYqzrQSAILX3UJwyETrmK0ezO2eCIdRGvVSxAHH7rU2uFMHZc+FzyH01zerWZ1RzwAdj5R1/cqg==
X-Received: by 2002:a17:902:968e:: with SMTP id n14mr41554677plp.312.1567615091169;
        Wed, 04 Sep 2019 09:38:11 -0700 (PDT)
Received: from [172.26.108.37] ([2620:10d:c090:180::85c5])
        by smtp.gmail.com with ESMTPSA id s5sm5806528pfe.52.2019.09.04.09.38.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 09:38:10 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Eric Dumazet" <eric.dumazet@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@mellanox.com>
Subject: Re: rtnl_lock() question
Date:   Wed, 04 Sep 2019 09:38:08 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <C46053D2-6BF5-4CFE-BF76-32DDCAD7BC10@gmail.com>
In-Reply-To: <3164f8de-de20-44f7-03fb-8bc39ca8449e@gmail.com>
References: <29EC5179-D939-42CD-8577-682BE4B05916@gmail.com>
 <3164f8de-de20-44f7-03fb-8bc39ca8449e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; markup=markdown
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4 Sep 2019, at 0:39, Eric Dumazet wrote:

> On 9/3/19 11:55 PM, Jonathan Lemon wrote:
>> How appropriate is it to hold the rtnl_lock() across a sleepable
>> memory allocation?  On one hand it's just a mutex, but it would
>> seem like it could block quite a few things.
>>
>
> Sure, all GFP_KERNEL allocations can sleep for quite a while.
>
> On the other hand, we may want to delay stuff if memory is under 
> pressure,
> or complex operations like NEWLINK would fail.
>
> RTNL is mostly taken for control path operations, we prefer them to be
> mostly reliable, otherwise admins job would be a nightmare.
>
> In some cases, it is relatively easy to pre-allocate memory before 
> rtnl is taken,
> but that will only take care of some selected paths.

The particular code path that I'm looking at is mlx5e_tx_timeout_work().

This is called on TX timeout, and mlx5 wants to move an entire channel
and all the supporting structures elsewhere.  Under the rtnl_lock(), it
calls kvzmalloc() in order to grab a large chunk of contig memory, which
ends up stalling the system.

I suspect these large allocation should really be done outside the lock.
-- 
Jonathan
