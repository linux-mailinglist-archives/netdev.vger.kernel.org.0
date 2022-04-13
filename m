Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD264FF748
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 14:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235684AbiDMNBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 09:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbiDMNBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 09:01:42 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE30303;
        Wed, 13 Apr 2022 05:59:20 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id x3so1017301wmj.5;
        Wed, 13 Apr 2022 05:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tLvIKnCsgwq0Fk81VHoLGLNWgDzppdl1EGVsnwIiwWk=;
        b=J+TeCd/41OhdiO9FUGEfBABaBHyh/+x7sT23BLdtYO5M/x78pQgF4HUNKv9pzckLvE
         MxPd2HtNgkI6X7aRD/PgoHW6pVhDxI8euAS9xxP6mmaE1kusyaJ0y+ZjzUz6BMYa5ozG
         9uinPwymgXMcz+Gg+OuQDeTD5Y8mH6LmuNMUDP/r/iZ6ncTL2KniEyeWwa8admD2JJxh
         55468CiYjZUtegpegbpzGpHqZ2PuQ9QJf08kGj4VNjg0PuJiBgKjEWPP6vJNz5uLeKJS
         pPiToZDXWjoFGkMUuKIofSm8bW4zIWYbuSBz6fEuW6Ccl8EM9Nmw4ioblOFhaO1IvD9d
         ZBkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tLvIKnCsgwq0Fk81VHoLGLNWgDzppdl1EGVsnwIiwWk=;
        b=WX/tvb6yVCz0T6oV6WZN9+6cGtZhttzYuuK5nSYV09C9Nf/8nT8nUC27ygpJ6dyW2M
         tw4WVyuhWOsbAs5rRRxi+A8YXNIaJjfzYueLHOTK7PuHS1kRAA6HhrNb9lZf+9I+3efh
         q5aP3vEfB4QJZfH9dKO3jgemiFzZrUpLBt0nMYlnlLGPYMPvRtsKm9bGQrIZYB4cgXlD
         yZ8gg7MQ8JmPXOTqdATmbeBPPxC4+mmYKb6QO+8ieUL6qBFLvzTqdjjLyB0Ix3GE+ur0
         BbVl9LErdE+CUZ9DvyXMyCao/qXJ3XmkWJbhPhuUeNMF7mFkdemSZdR4Uhytm5ofLP/l
         PIzQ==
X-Gm-Message-State: AOAM530Y88/NxUFQi4GGkUdRWW2wfznoyTrFW2Z52bKjMeNg5nlLdW0A
        zaZgs1M/kX/38/5e/2ssP1o=
X-Google-Smtp-Source: ABdhPJzHDsOyWeJ1XYw5H42kbzi5IU99y9X4kNsBdhZkSZSUb/AfGgMpOXsUKWaFNT0R/LhnDJ9bFw==
X-Received: by 2002:a05:600c:5128:b0:38e:bcdd:53bf with SMTP id o40-20020a05600c512800b0038ebcdd53bfmr8352243wms.109.1649854759438;
        Wed, 13 Apr 2022 05:59:19 -0700 (PDT)
Received: from hoboy.vegasvil.org (195-70-108-137.stat.salzburg-online.at. [195.70.108.137])
        by smtp.gmail.com with ESMTPSA id f9-20020a05600c4e8900b0038cc29bb0e1sm2873992wmq.4.2022.04.13.05.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 05:59:18 -0700 (PDT)
Date:   Wed, 13 Apr 2022 05:59:15 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Tan Tee Min <tee.min.tan@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>
Subject: Re: [PATCH net 1/1] net: stmmac: add fsleep() in HW Rx timestamp
 checking loop
Message-ID: <20220413125915.GA667752@hoboy.vegasvil.org>
References: <20220413040115.2351987-1-tee.min.tan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413040115.2351987-1-tee.min.tan@intel.com>
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

On Wed, Apr 13, 2022 at 12:01:15PM +0800, Tan Tee Min wrote:
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
> index d3b4765c1a5b..289bf26a6105 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
> @@ -279,10 +279,11 @@ static int dwmac4_wrback_get_rx_timestamp_status(void *desc, void *next_desc,
>  			/* Check if timestamp is OK from context descriptor */
>  			do {
>  				ret = dwmac4_rx_check_timestamp(next_desc);
> -				if (ret < 0)
> +				if (ret <= 0)
>  					goto exit;
>  				i++;
>  
> +				fsleep(1);

This is nutty.  Why isn't this code using proper deferral mechanisms
like work or kthread?

>  			} while ((ret == 1) && (i < 10));
>  
>  			if (i == 10)
> -- 
> 2.25.1
> 

Thanks,
Richard
