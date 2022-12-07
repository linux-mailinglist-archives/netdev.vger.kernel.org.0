Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1E7645D23
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 16:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiLGPBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 10:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiLGPA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 10:00:57 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0588A1FCC7
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 06:59:26 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id vp12so14609134ejc.8
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 06:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jMXRVGldTk7COdaP24MY28qt9bqJfNKNUcD2+DWf9Jc=;
        b=CGx8xTYvJ2ijDdrLPSvnpvjZivSxCb2eS2a7gzI+SYI9MXev/9Kx7TKidmMRAKqOy3
         HZOc1zRswaK0f6iW9+HSk5TyLWmbuZAkMStIqwiCDl5zGhf1U9OQ65sLT9R73u3dZ5z3
         LkW8sz0/43loKcr3VcKCAMC0sWic81ysujgk0cxJDVC9eeC+oGJ+RSVAhq88k9mz3px3
         umRfsGSCfq12iE/vOvXWUO5kXDYKcodqK+2iQCAyPByhyCL1e8Prw+B1q1HPu4eDEZAh
         jCtaiWedx3JuR0bNjEwfm5UVTU8F5HefzR5dI+keSIkuTOw6mOLwruT+gLVffJ8TE/gY
         yB6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jMXRVGldTk7COdaP24MY28qt9bqJfNKNUcD2+DWf9Jc=;
        b=1nUhyPgoRpMmgLF+vufBaXgdrdipI6BSYqCgbKB9JSlE1m7tX+DIEFjq3pZOec0D1+
         RS03N8VDYzDbs5wkkQzfoqm8Hp9A6Qhqg4yKmn9BMatUoD2SziGzyNUY1eJ216wrBYUq
         cD0h5LcnVzcmHN/Gk1nMXB79WMXiqDG856w4nV+fM1XNZzrrrgU07DcYSobzRav30bNq
         Y8ndGT4yNCUyrZ0TP2whbsjKb19zO5G7X6xEYeqtqYcKD2uvqwO/fcI5VcKN5eFHg+EG
         flWhd/alXMBg4M5a0qSb0k8o5rW5wxG7F4yk6Ivq/8CtohEE2zJADSG7Jlc8dAR5FuUg
         wdrA==
X-Gm-Message-State: ANoB5pmkW6TKAeWMyvZKbyZDfpg6ZZ1OnkjMYjCa7A+6f0dxcTdTIykE
        Maw8LeQZfm0t0rsYOcIvlf+1qTAbOn/BueJ9os8=
X-Google-Smtp-Source: AA0mqf6ErRFQmK1cntQI6QCrFtJ3GfQhEtVifAs9d6yaF0QsUCpds2LyOFQyuf9VVKodil1f5LK4tA==
X-Received: by 2002:a17:906:4f0c:b0:7c0:fd1a:6792 with SMTP id t12-20020a1709064f0c00b007c0fd1a6792mr9547232eju.431.1670425164604;
        Wed, 07 Dec 2022 06:59:24 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id kq16-20020a170906abd000b007c09da0d773sm3056685ejb.100.2022.12.07.06.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:59:23 -0800 (PST)
Date:   Wed, 7 Dec 2022 15:59:22 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, isdn@linux-pingi.de, davem@davemloft.net
Subject: Re: [PATCH net 3/3] mISDN: hfcmulti: don't call dev_kfree_skb()
 under spin_lock_irqsave()
Message-ID: <Y5CqSjfN4fBhLLaH@nanopsycho>
References: <20221207093239.3775457-1-yangyingliang@huawei.com>
 <20221207093239.3775457-4-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207093239.3775457-4-yangyingliang@huawei.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Dec 07, 2022 at 10:32:39AM CET, yangyingliang@huawei.com wrote:
>It is not allowed to call consume_skb() from hardware interrupt context
>or with interrupts being disabled. So replace dev_kfree_skb() with
>dev_consume_skb_irq() under spin_lock_irqsave().
>
>Fixes: af69fb3a8ffa ("Add mISDN HFC multiport driver")
>Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
