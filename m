Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8614C9F56
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 09:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbiCBIh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 03:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiCBIh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 03:37:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F0B3A0BE2
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 00:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646210202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/2FAiDhGcTywdRgwSmwFCo5u8TBif4JlceniLJIbtkU=;
        b=OHabHEOup82+twi5g/YGPqz4MUHuEq0KBlFKbQC1cSC6YrahlijspI3N320iKzi1tNa/HM
        ayiO2lmMrpGaMHu+a0NNfH057GlQHvO2uop6gfXYcFMJNTThvSBg/etOQsrhjnmR5F+f7h
        DAcwl/qyYKuOUrmepdoZGlSOwxdwLNY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-345-RB3qmmjxP96MsaSeXhlifg-1; Wed, 02 Mar 2022 03:36:41 -0500
X-MC-Unique: RB3qmmjxP96MsaSeXhlifg-1
Received: by mail-wr1-f69.google.com with SMTP id z16-20020adff1d0000000b001ef7dc78b23so351489wro.12
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 00:36:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/2FAiDhGcTywdRgwSmwFCo5u8TBif4JlceniLJIbtkU=;
        b=rjQMkX0WDH5q9qjY/dMhGZi6YGOH1Kcqj6ZL0M76z+KeLSHBqQIa9o1hGmhMSg+gU1
         JB5Tmbou7RBTl26tIHgNhB33pN0asqxTwocDIqNr9rhIgIXNdtQ6o6GKWWvAyyLetub3
         phMjt+ppkDE4Vtaoj8jiV2aR1hNPhde+O61gLj7cDQRTFltEYCZsNKFM4b58YBOj4NK/
         N5uuQPfGVJOHP/oo0+dRI37aOvRIdzEDI3g63iHUOJu7TbXthjuPvQVyZt8TDFZLQrw2
         rm0keo/34PwuSSyknAvCxNxOn0yHTNrmRmNEi/ANh0TROjafpSNR3n+p+LLvbuxwg+8E
         rXKw==
X-Gm-Message-State: AOAM532733SJ6H/ReOMFMy15ukgsnmx6wX7fQO49a8f+lZCCyLMVs+sy
        GmqqmuV88BInqCNPeaugpOyNKsDGYdWvnCtcK1i1CfnPDEYmcz2wfIWh0KWKlnHVk1+V1DH9S0S
        BFRzNkulPbWtVyA79
X-Received: by 2002:a05:600c:3c9b:b0:380:be98:6204 with SMTP id bg27-20020a05600c3c9b00b00380be986204mr19516438wmb.121.1646210200111;
        Wed, 02 Mar 2022 00:36:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJymEdMSgAgaDqjHhyxTJw/DIf4G/pqblQVXnivxlcluwVfKcMGVsVinJaSMoAx4IDiFG167KA==
X-Received: by 2002:a05:600c:3c9b:b0:380:be98:6204 with SMTP id bg27-20020a05600c3c9b00b00380be986204mr19516421wmb.121.1646210199815;
        Wed, 02 Mar 2022 00:36:39 -0800 (PST)
Received: from redhat.com ([2a10:8006:355c:0:48d6:b937:2fb9:b7de])
        by smtp.gmail.com with ESMTPSA id q11-20020adfcd8b000000b001e320028660sm15805542wrj.92.2022.03.02.00.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 00:36:39 -0800 (PST)
Date:   Wed, 2 Mar 2022 03:36:36 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Theodore Ts'o <tytso@mit.edu>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 3/3] wireguard: device: clear keys on VM fork
Message-ID: <20220302033314-mutt-send-email-mst@kernel.org>
References: <20220301231038.530897-1-Jason@zx2c4.com>
 <20220301231038.530897-4-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301231038.530897-4-Jason@zx2c4.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 12:10:38AM +0100, Jason A. Donenfeld wrote:
> When a virtual machine forks, it's important that WireGuard clear
> existing sessions so that different plaintext is not transmitted using
> the same key+nonce, which can result in catastrophic cryptographic
> failure. To accomplish this, we simply hook into the newly added vmfork
> notifier, which can use the same notification function we're already
> using for PM notifications.
> 
> As a bonus, it turns out that, like the vmfork registration function,
> the PM registration function is stubbed out when CONFIG_PM_SLEEP is not
> set, so we can actually just remove the maze of ifdefs, which makes it
> really quite clean to support both notifiers at once.
> 
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Catastrophic cryptographic failure sounds bad :(
So in another thread we discussed that there's a race with this
approach, and we don't know how big it is. Question is how expensive
it would be to fix it properly checking for fork after every use of
key+nonce and before transmitting it. I did a quick microbenchmark
and it did not seem too bad - care posting some numbers?

> ---
> Hi Jakub,
> 
> I wasn't planning on sending other WireGuard changes to net-next this
> cycle, and this one here depends on previous things in my random.git
> tree. Is it okay with you if I take this through my tree rather than
> net-next? Alternatively, I could send it through net after rc1 if you'd
> prefer that. Or we could just wait for 5.19, but that seems a long way's
> off.
> 
> Thanks,
> Jason
> 
>  drivers/net/wireguard/device.c | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
> index a46067c38bf5..22cc27c221f8 100644
> --- a/drivers/net/wireguard/device.c
> +++ b/drivers/net/wireguard/device.c
> @@ -59,7 +59,10 @@ static int wg_open(struct net_device *dev)
>  	return ret;
>  }
>  
> -#ifdef CONFIG_PM_SLEEP
> +static int wg_pm_notification(struct notifier_block *nb, unsigned long action, void *data);
> +static struct notifier_block pm_notifier = { .notifier_call = wg_pm_notification };
> +static struct notifier_block vm_notifier = { .notifier_call = wg_pm_notification };
> +
>  static int wg_pm_notification(struct notifier_block *nb, unsigned long action,
>  			      void *data)
>  {
> @@ -70,10 +73,10 @@ static int wg_pm_notification(struct notifier_block *nb, unsigned long action,
>  	 * its normal operation rather than as a somewhat rare event, then we
>  	 * don't actually want to clear keys.
>  	 */
> -	if (IS_ENABLED(CONFIG_PM_AUTOSLEEP) || IS_ENABLED(CONFIG_ANDROID))
> +	if (nb == &pm_notifier && (IS_ENABLED(CONFIG_PM_AUTOSLEEP) || IS_ENABLED(CONFIG_ANDROID)))
>  		return 0;
>  
> -	if (action != PM_HIBERNATION_PREPARE && action != PM_SUSPEND_PREPARE)
> +	if (nb == &pm_notifier && action != PM_HIBERNATION_PREPARE && action != PM_SUSPEND_PREPARE)
>  		return 0;
>  
>  	rtnl_lock();
> @@ -91,9 +94,6 @@ static int wg_pm_notification(struct notifier_block *nb, unsigned long action,
>  	return 0;
>  }
>  
> -static struct notifier_block pm_notifier = { .notifier_call = wg_pm_notification };
> -#endif
> -
>  static int wg_stop(struct net_device *dev)
>  {
>  	struct wg_device *wg = netdev_priv(dev);
> @@ -424,16 +424,18 @@ int __init wg_device_init(void)
>  {
>  	int ret;
>  
> -#ifdef CONFIG_PM_SLEEP
>  	ret = register_pm_notifier(&pm_notifier);
>  	if (ret)
>  		return ret;
> -#endif
>  
> -	ret = register_pernet_device(&pernet_ops);
> +	ret = register_random_vmfork_notifier(&vm_notifier);
>  	if (ret)
>  		goto error_pm;
>  
> +	ret = register_pernet_device(&pernet_ops);
> +	if (ret)
> +		goto error_vm;
> +
>  	ret = rtnl_link_register(&link_ops);
>  	if (ret)
>  		goto error_pernet;
> @@ -442,10 +444,10 @@ int __init wg_device_init(void)
>  
>  error_pernet:
>  	unregister_pernet_device(&pernet_ops);
> +error_vm:
> +	unregister_random_vmfork_notifier(&vm_notifier);
>  error_pm:
> -#ifdef CONFIG_PM_SLEEP
>  	unregister_pm_notifier(&pm_notifier);
> -#endif
>  	return ret;
>  }
>  
> @@ -453,8 +455,7 @@ void wg_device_uninit(void)
>  {
>  	rtnl_link_unregister(&link_ops);
>  	unregister_pernet_device(&pernet_ops);
> -#ifdef CONFIG_PM_SLEEP
> +	unregister_random_vmfork_notifier(&vm_notifier);
>  	unregister_pm_notifier(&pm_notifier);
> -#endif
>  	rcu_barrier();
>  }
> -- 
> 2.35.1
> 
> 

