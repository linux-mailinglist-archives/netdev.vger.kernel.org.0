Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723F152B37D
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 09:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbiERHdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 03:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbiERHdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 03:33:21 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F607A804
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 00:33:20 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r30so1337555wra.13
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 00:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=MYRkqqXJPDGgN6tMNRysuyaNC3NF5ydZs0TxSicDM44=;
        b=PvgMdglMNNG23gXygq18WDnd50J/tVdcy6YmUg+w+aNE89Yi+9YGiQstzOgrmh9/pe
         t7ZmmjLo5Z9PcFO2n4un2+JlTKdyVYIys2XCJcJMhmjy9CIPx0xMoGOY18iqPe3xwxhU
         pbpmcrzDcmH4eK44vhWIOO5N4HyUFB2xbhWGCQJjEn1mJstlUrcP6j2XZ3q7uCHfJHrJ
         tSoVQYIOO6XhKawWjxGlkoUifYO8vUCOEB4GmsNspLCpk1Uamfi6ppIPTKLbcxRw7SEY
         nZVGbMxO/yVYgc2k13aDUuQY2y+IAWW0/OoTH2aHsWUAqu2C0tw6fsOHxIbw8SlJG6RH
         Xzkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=MYRkqqXJPDGgN6tMNRysuyaNC3NF5ydZs0TxSicDM44=;
        b=xifU0KAnsayrqoujcyIDayrWSYavfmPkML5X9EKG7XeRjiqOQPIV+gecsJRB3sWHDK
         wSK9U2Cjpqq03113ORmeP8SU5zSiCU/U00UTLVNl2ddpJlfdpcrH7jtMZqHhJo8N/CSg
         AkdJqpyKFgR9EtkxwvnbNXjLB0WA1BZCljh/qPIDbMYjDyeOd2hDgduOsMmwIBt4/bxv
         l8QunbId+dFSjUPAVRFJG4RLhfOluVJIBnmvCwEZTTEBoPNkKax1Hs+nCjwTTYpynWZr
         JGG1kBnv9Q73smhjR72Mv7aYOwBLOAffy2uz1cYiqBRRC+pPbL4unj+IMmcN/qNpGx6A
         8joQ==
X-Gm-Message-State: AOAM530GTfNKeL8QV4z++e31hzSoi5FM71r1q6k4+Qc9UHRtwGjc0a3v
        erzbwN4Y0XeuBDx2pC9mjk0=
X-Google-Smtp-Source: ABdhPJxjAtHs2vxQ32YmJKz9K/l0tCIjwi+ltOjFXKOQLlZZ9e0IzbuKw7eEBxTwCLCu9FEYHZb1Bw==
X-Received: by 2002:a05:6000:18aa:b0:20c:7ec0:b804 with SMTP id b10-20020a05600018aa00b0020c7ec0b804mr8046341wri.128.1652859198676;
        Wed, 18 May 2022 00:33:18 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id a12-20020a056000188c00b0020c5253d8ddsm1173032wri.41.2022.05.18.00.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 00:33:18 -0700 (PDT)
Date:   Wed, 18 May 2022 08:33:16 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH net-next] sfc: siena: Have a unique wrapper ifndef for
 efx channels header
Message-ID: <20220518073316.GB15380@gmail.com>
Mail-Followup-To: Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Edward Cree <ecree.xilinx@gmail.com>
References: <20220518065820.131611-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220518065820.131611-1-saeed@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 11:58:20PM -0700, Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Both sfc/efx_channels.h and sfc/siena/efx_channels.h used the same
> wrapper #ifndef EFX_CHANNELS_H, this patch changes the siena define to be
> EFX_SIENA_CHANNELS_H to avoid build system confusion.
> 
> This fixes the following build break:
> drivers/net/ethernet/sfc/ptp.c:2191:28:
> error: ‘efx_copy_channel’ undeclared here (not in a function); did you mean ‘efx_ptp_channel’?
>   2191 |  .copy                   = efx_copy_channel,
> 
> Fixes: 6e173d3b4af9 ("sfc: Copy shared files needed for Siena (part 1)")
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> Cc: Edward Cree <ecree.xilinx@gmail.com>
> Cc: Martin Habets <habetsm.xilinx@gmail.com>
> ---
>  drivers/net/ethernet/sfc/siena/efx_channels.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/siena/efx_channels.h b/drivers/net/ethernet/sfc/siena/efx_channels.h
> index 10d78049b885..c4b95a2d770f 100644
> --- a/drivers/net/ethernet/sfc/siena/efx_channels.h
> +++ b/drivers/net/ethernet/sfc/siena/efx_channels.h
> @@ -8,8 +8,8 @@
>   * by the Free Software Foundation, incorporated herein by reference.
>   */
>  
> -#ifndef EFX_CHANNELS_H
> -#define EFX_CHANNELS_H
> +#ifndef EFX_SIENA_CHANNELS_H
> +#define EFX_SIENA_CHANNELS_H
>  
>  extern unsigned int efx_siena_interrupt_mode;
>  extern unsigned int efx_siena_rss_cpus;
> -- 
> 2.36.1
