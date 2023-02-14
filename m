Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B57695D56
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 09:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbjBNIld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 03:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbjBNIlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 03:41:08 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C007623658
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 00:40:55 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id a3so4202857ejb.3
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 00:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fpl2dYq09X1UimTogkpAO+pdBXIqBUdMeEeTg/7qSas=;
        b=Bg8GgDZY7kilURoRNLSzE7rxV3xwzXlJM55ZH1SFuchlelKg4/Oo2ByXZyYFUPpDax
         9Ju6E4HG3M6A+SBoj3mm1DCi5h38nSAxOxQcIVBUwkmszC1uj9DadSmk/AAGVd6B8zHk
         t70bGTz4hL1S82MoXdc7UpQsOOYDwEqKNbgvLD8Gkrc3zlxaNyieJY/tptgdf4lMKfOl
         qSHK0ls61o9vzdtYW4RmuFjluOFGVvl3IdigDrnZjuTxDTmdggijPGCfNzfpczqepD4a
         cz0HmuE6HZUh2La1hs25nVI/K16REIw7eMbVnw6HRdGInSwspQCzAqTkwMCniqKUK1G8
         jZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fpl2dYq09X1UimTogkpAO+pdBXIqBUdMeEeTg/7qSas=;
        b=zYNu8d2aYV+807EIJM0jcvmjL4UBQJfOyLVZy2s5Ndk/Ql8JtsMywBQyl2cn1xRZoN
         flbM00lOpRc+++zK4jkmhzamMsJWmvhmMQAzp9nRRw9gcepIG8Y6SHw2b5m4+mwnQIfm
         m20ybchMTyHITjEebUekxVxAd02lOo35iRD6D9xWnRr/Z6fCST4oYE/GYE5n2Fw8+NQF
         eLnT9CfRrp0uoBRw9Q8pweePSkAaRYUv2XYA8XKCr69l4V04NQxlTwTqe07/VJ4Xc4O1
         EMQg3r5Twiu262IJfQWej59xfmHeksiZ/FPzHq4Ve30tsvxPqn0/O1ESbGjUOoYcoQjW
         wVjQ==
X-Gm-Message-State: AO0yUKU9/6LRntecxQ+Oh4Tnewsnz8EnpQI2xgmykJ+JDf43eFEvSCHD
        3Q1s7FR7b3K8npfq96HEegxT7Q==
X-Google-Smtp-Source: AK7set+I//8fpiZU3b0KhszicIsqrrq4SNLouZHvMeHfov9b5wupT38PcfS5I7rS9K0/QE6Ss3FaiA==
X-Received: by 2002:a17:906:ecb2:b0:878:5372:a34b with SMTP id qh18-20020a170906ecb200b008785372a34bmr1732692ejb.45.1676364054093;
        Tue, 14 Feb 2023 00:40:54 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id t21-20020a170906179500b0088a9e083318sm7921654eje.168.2023.02.14.00.40.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 00:40:53 -0800 (PST)
Message-ID: <0a255859-9ec1-c808-d7d5-3500a6c49386@blackwall.org>
Date:   Tue, 14 Feb 2023 10:40:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v2 1/2] net: bridge: make kobj_type structure
 constant
Content-Language: en-US
To:     =?UTF-8?Q?Thomas_Wei=c3=9fschuh?= <linux@weissschuh.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230211-kobj_type-net-v2-0-013b59e59bf3@weissschuh.net>
 <20230211-kobj_type-net-v2-1-013b59e59bf3@weissschuh.net>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230211-kobj_type-net-v2-1-013b59e59bf3@weissschuh.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/02/2023 06:23, Thomas Weißschuh wrote:
> Since commit ee6d3dd4ed48 ("driver core: make kobj_type constant.")
> the driver core allows the usage of const struct kobj_type.
> 
> Take advantage of this to constify the structure definition to prevent
> modification at runtime.
> 
> Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
> ---
>  net/bridge/br_if.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> index ad13b48e3e08..24f01ff113f0 100644
> --- a/net/bridge/br_if.c
> +++ b/net/bridge/br_if.c
> @@ -269,7 +269,7 @@ static void brport_get_ownership(const struct kobject *kobj, kuid_t *uid, kgid_t
>  	net_ns_get_ownership(dev_net(p->dev), uid, gid);
>  }
>  
> -static struct kobj_type brport_ktype = {
> +static const struct kobj_type brport_ktype = {
>  #ifdef CONFIG_SYSFS
>  	.sysfs_ops = &brport_sysfs_ops,
>  #endif
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

