Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA6F6DEB87
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 08:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjDLGHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 02:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjDLGHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 02:07:20 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F0610D1;
        Tue, 11 Apr 2023 23:07:19 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id s8so5832776wmo.0;
        Tue, 11 Apr 2023 23:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681279637; x=1683871637;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZthFbCKWq4xxG/d6uuV7wZHVH35dQA0t0y0QuJv9qjs=;
        b=P5t5/9DDR0ppW8RjibtuEsds3PggRT9xHkM9PPKLoIkGC6i8LyKMHCgieF2yEt8b3+
         mHQloeqlTQeo8CQH7DTrTWaR35LtKAPJefS9zyzIN7St2tc7rcjBHT3SVMCXrn0j6u0g
         5AfWWM6NWI3ItQ0MXqkahupTtYLg4LCrXWGecTrc2w/KOzStO9RmUmy1RAh8DsTqLVyN
         KU33Og3fMTLpXjVQgNMNYU/XELTy3hjoeG2Asgz/CMrmxzDmcnZq3Qhthizu82pOrunO
         lj5PfNjPwG3xr44yXr8s90q7DGVShp8RD72QBpFF0TflmP9GZ3knfYan89sPz2hpUdsX
         q0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681279637; x=1683871637;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZthFbCKWq4xxG/d6uuV7wZHVH35dQA0t0y0QuJv9qjs=;
        b=xfll2Ucj8j0WeAn0wb5ChWmqtRNJXzINpr7ymdn8rNWwma4gN10/sLSGAnM+SkzvaD
         FbMyUmpjHiT3RRn97WxC2pmWH0IOLfmej7GeX1YpyFGocZwaWt+86/iB4eZKBwfMBY96
         xamalMEMS2ttoZH4Yct07WM6+ZNOiXHG1ndV6EVKMMMJC1nD8eAOCihQ3SkZjUooF6aO
         fA8qg8g90tYB/xuvfdsHySQzvS0vCG/r2Llz6Kefo4YgR0bXFJ3kDv0vCMNrzv4tOawC
         NS7OinOkyH/Mk3xS1VkgP7FYJ3uf5YJkfbo8/YFoXLDG/6CGtb3StfJyY9iF3ymVT3sJ
         p3kQ==
X-Gm-Message-State: AAQBX9dyRORrsxvQblxVx206zH1pBvaMowvihdPDeH60kbWFE8xOakHN
        HrYffLhNH27oF3RUX2CEsZopCwUAoyI=
X-Google-Smtp-Source: AKy350YHvmF/0uCArKNQ2v330KOQXv7QPR7ovXsAzeHzT5L+PwzXZUysA4hTQCBUZiogUYZy62IPAw==
X-Received: by 2002:a1c:7712:0:b0:3ed:237f:3da with SMTP id t18-20020a1c7712000000b003ed237f03damr9467638wmi.22.1681279637289;
        Tue, 11 Apr 2023 23:07:17 -0700 (PDT)
Received: from [192.168.0.106] ([77.126.33.94])
        by smtp.gmail.com with ESMTPSA id x3-20020a1c7c03000000b003edff838723sm1169734wmc.3.2023.04.11.23.07.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 23:07:16 -0700 (PDT)
Message-ID: <8d13ca06-3183-8511-62fd-ae267a9b4699@gmail.com>
Date:   Wed, 12 Apr 2023 09:07:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next v2 3/3] mlx4: use READ_ONCE/WRITE_ONCE for ring
 indexes
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        tariqt@nvidia.com, linux-rdma@vger.kernel.org
References: <20230412015038.674023-1-kuba@kernel.org>
 <20230412015038.674023-4-kuba@kernel.org>
Content-Language: en-US
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230412015038.674023-4-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/04/2023 4:50, Jakub Kicinski wrote:
> Eric points out that we should make sure that ring index updates
> are wrapped in the appropriate READ_ONCE/WRITE_ONCE macros.
> 
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: tariqt@nvidia.com
> CC: linux-rdma@vger.kernel.org
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_tx.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Thanks!
