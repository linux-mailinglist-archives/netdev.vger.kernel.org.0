Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062824222F8
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 12:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbhJEKBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 06:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233289AbhJEKBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 06:01:50 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B033DC06161C;
        Tue,  5 Oct 2021 02:59:59 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id z20so24823151edc.13;
        Tue, 05 Oct 2021 02:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8Q2qP0gzBKg31ibi+4OJDDQ+9ysa+79XE1gm8GYKlvs=;
        b=gAoZ7mA7pfJjCKGPFHf5qr8gaemT91vhSRvOnV9IxZlj5r0ZQoGCJYVE1chCYyWWi3
         tl9sWHOWitYa21kOPfs/CcrF2/9bFFhRU4KSBgVy5LXKREoisblr89q4KQH8MtEBhMqa
         fXezmSEk3aacvnam7dCXcNnvdvqBnPljvJmh4ou/G5fKbd9V6EugS2LByIiso+XNw8uX
         t208+yOzwTyyQqTW7rWcB6SeGuTL9HwRLNwjxEMDOCSNX6T31qy8PHFfAi94tcZEqmU5
         iBwONQeDaUkWIJt5PkrFacCxUr+Lw2sf2lE+GQORB8t6QMTAp5tmDUsjLnJvTDvsqgRp
         FJnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8Q2qP0gzBKg31ibi+4OJDDQ+9ysa+79XE1gm8GYKlvs=;
        b=6s3jbTmxRCBLMNvA70FnZeeR8Ys5seq/5YHmGvZhbO0g5/s1zCD7NF7wcrkwN8JMpA
         0m4Ch3SNlFNfp/irkCA6neAS+1EIbHJiQofrs+VKZdB8Fp3VKOVzkr2lJ2S9w+1ZMdEA
         3wG4N0tg7yXfxJRQ5bCLsTOgbmlTQMGWJ0z+3pEv0f8r+dgkXtbs+pCDXg4TmGicEHNP
         6uC3k2zXXNuBGWaqisvqyu9XM6Y15mhi89imp6uxBR2+i9w72pKfEvdZUliHR6QaqeEp
         AtiYJlPZb5gdf1Mic3D8EKwe3AUcYxc/ueZ9V/PvjxNz2J/oi1j3NXTtndW5TheGvxjJ
         iNEg==
X-Gm-Message-State: AOAM530ZkNnVtjdoeRUDMRLPggYkjclcYJLKpgliVFWJcv72EbB6TFbB
        kFGXHieH5Tf5P4wopHkCX55zlU6bc4k=
X-Google-Smtp-Source: ABdhPJygwlimuv2iotPwCebh/g+Ywp0VWJmwIMEWYH/by9cphPLfHhZpJQTL1KD01gMDUi9u7ORhZQ==
X-Received: by 2002:a50:cd02:: with SMTP id z2mr6915715edi.241.1633427998050;
        Tue, 05 Oct 2021 02:59:58 -0700 (PDT)
Received: from [192.168.0.108] ([176.228.98.2])
        by smtp.gmail.com with ESMTPSA id j14sm8561322edl.21.2021.10.05.02.59.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 02:59:57 -0700 (PDT)
Subject: Re: [PATCH net-next 2/4] mlx4: replace mlx4_u64_to_mac() with
 u64_to_ether_addr()
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, tariqt@nvidia.com, yishaih@nvidia.com,
        linux-rdma@vger.kernel.org
References: <20211004191446.2127522-1-kuba@kernel.org>
 <20211004191446.2127522-3-kuba@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <7b1b45b5-546c-2ce3-a5d9-e8463ba588b3@gmail.com>
Date:   Tue, 5 Oct 2021 12:59:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211004191446.2127522-3-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/2021 10:14 PM, Jakub Kicinski wrote:
> mlx4_u64_to_mac() predates the common helper but doesn't
> make the argument constant.
> 

Neither does the argument constant.

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   drivers/net/ethernet/mellanox/mlx4/cmd.c |  2 +-
>   include/linux/mlx4/driver.h              | 10 ----------
>   2 files changed, 1 insertion(+), 11 deletions(-)
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
