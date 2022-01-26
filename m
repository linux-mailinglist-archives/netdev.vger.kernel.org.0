Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D8249C5B5
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 10:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238703AbiAZJBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 04:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbiAZJBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 04:01:39 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C520BC06161C;
        Wed, 26 Jan 2022 01:01:38 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id me13so37507596ejb.12;
        Wed, 26 Jan 2022 01:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=RdwXEu1MmztLKU47ICnLL8SgBU/757WIk4pxla2J/ik=;
        b=YHc0sRTz05ilJCKIaZRtpdWg34iSw3Lm/r+U5Ew6FeIwqVE2cW++4sUu1im21RpvDg
         znYRBMg8HaYQafLOp5aRQQoso7uaKNJbMLDGx96kg/C2bRrjZ3DYPrHrAJEqkq20ubII
         3nH6Wwk+zMBUZzk5JjmNupEF3iPJiFdO7qWwmLoMUlu5CpvtHL/iajjSnvzVTX+9Ohj1
         894xblkbcJGfd/4Ue2QhFqDohuV3POuaKUz5HO11bFEUBNKmvh32E3JkxxF1AgruwSpC
         yS1eDRyv5dW7e4e4uqDPA/X8PlE9TVAO4tBvJt7/3Po59OeyMgpyKVw2YAYlzzRrHuTW
         ehaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RdwXEu1MmztLKU47ICnLL8SgBU/757WIk4pxla2J/ik=;
        b=h7oyXTg1IlNr7K81p7DQ/p4RDyVv/LxxhWhCMZJsIXoBE2DCj6RswLafx+mldfrlJI
         thg/9yERUQ2sIfm9HCUb7/02JQDyGTAtmFnH19AjzaqIb4KNvCviGMuin9Y2gAZq2nVV
         fWT1utbnXvR8Es0hpQ8yZMqQPhyPgPDLvRv8RTaGMy4SDr82lvq7+Tje4f+KZxbuTZxn
         +D/fdVffNt2dwPt8vN23Ymq0d9EPiR58Q7oDcxKt9QrqJ1PAEiGgrRals1w3trIRLRl5
         Rp37I5umS4upXi9khp9fr0CRz6xR7LM/WniUdwue5OwIvLpDyvAOfqXW/6hXMsTUY3RU
         CqDg==
X-Gm-Message-State: AOAM533/sfjaUvVPr3kUUbF8x6mWJVxBD0Kg8aFRHe/v5j9LAe6iiw/t
        fhuWhs2eAFe+UOBR1yUfvWY=
X-Google-Smtp-Source: ABdhPJw9c3/oKvaFb3OmJ2XQN0L+If20W7iI+mp94NCR14nmxXGKuGPePKVDU4CPoJ1b7HPn+pg3+w==
X-Received: by 2002:a17:907:c1f:: with SMTP id ga31mr7326520ejc.529.1643187697302;
        Wed, 26 Jan 2022 01:01:37 -0800 (PST)
Received: from [192.168.0.108] ([77.126.86.139])
        by smtp.gmail.com with ESMTPSA id l3sm7121170ejg.44.2022.01.26.01.01.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 01:01:36 -0800 (PST)
Message-ID: <ee1f1fe5-c8b7-be85-9029-40e441ae4d31@gmail.com>
Date:   Wed, 26 Jan 2022 11:01:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 04/54] net: mellanox: fix open-coded for_each_set_bit()
Content-Language: en-US
To:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20220123183925.1052919-1-yury.norov@gmail.com>
 <20220123183925.1052919-5-yury.norov@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220123183925.1052919-5-yury.norov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/23/2022 8:38 PM, Yury Norov wrote:
> Mellanox driver has an open-coded for_each_set_bit(). Fix it.
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/cmd.c | 23 ++++++-----------------
>   1 file changed, 6 insertions(+), 17 deletions(-)
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks,
Tariq
