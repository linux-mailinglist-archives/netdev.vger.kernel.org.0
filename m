Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B3E6C00D5
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 12:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjCSLg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 07:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjCSLgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 07:36:54 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF26206A9
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 04:36:51 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id fd5so36589830edb.7
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 04:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679225810;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=13pdUj0eXBrgzATmYw+vGsgwVGCat1vMbOWyXDCe+yQ=;
        b=LGIn5HMnf9HNbRjWe0cnziZpAia9Oa9MA4QmIHn/qwZMEdf2Lk8rVrtK+GWmXsDr/d
         XY6hIqWlIuPP6aNeWgVjokiHKCnHQ6kuVaIP3KxDUhQ9XdhlnQm7qcnDnCycydZuq/EZ
         lubwJ6KWoyDBtvvZZL6CWsflWwJbWzhbeEEKS+iCGy+wUcnkv6FrwJBIBuuSvx7XP3F5
         16fbnHzDhtsJptqu5DACwWCuu7YSmRWhbCFQ2UUVslr4jp6dsw+iy2c/Frd8kRpm6gWl
         rhTqMdhp5BUFLqHkFaWUKdDr8YBSeLUPSVhgkMj1BH86SOlfio6s0TDr6Ayq+Vckp0SS
         3mig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679225810;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=13pdUj0eXBrgzATmYw+vGsgwVGCat1vMbOWyXDCe+yQ=;
        b=TIwgLea8johM6ZDOUsQdNZFYgm41PbE1+fEPjHtj3RaNWgT9H31rQkkox5MwBs8Wq6
         h9FfrJGpy5BwC9rooKKrViXPAqzZZqptOLyItd/z1ZkI6ITTRqpQ6hTcG1jS8q8uIVQW
         wKodUa/ah1JNTCQ/dKwMjYRyKPuJwbNtZYMlFmJokjntcGZU/qsFeIwB8B//XUTcJ7k3
         E1ZWDwgWkoQpHIocvt254aL7fXqDU+nZSvRUmH3cWduyiWSpc2Yp++f9mTUP5zIaQqpZ
         7E3jwC3lp9+fuzL1BUhu0DQ5DAu5IVNxtld9irxJyBS32ADVunlekbxPH0V15uxNyMl6
         //Mw==
X-Gm-Message-State: AO0yUKW0NK8KAuvcq3qSRFWT8jTrTe243EGd3pRiJU07cOhUKuSiVbDG
        wKmxgDsfwxfqnNH/FHvwLIuqVw==
X-Google-Smtp-Source: AK7set/KGTzc0Uh2hFSw9UpUVTS8SqDF0imEGBF0xkzYYkn8tv55EVRfs8fTzesm+5HEyFuQJgYnNw==
X-Received: by 2002:aa7:c948:0:b0:4ab:d1f4:4b88 with SMTP id h8-20020aa7c948000000b004abd1f44b88mr7729818edt.41.1679225810301;
        Sun, 19 Mar 2023 04:36:50 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:5b5f:f22b:a0b:559d? ([2a02:810d:15c0:828:5b5f:f22b:a0b:559d])
        by smtp.gmail.com with ESMTPSA id u20-20020a50a414000000b004fd1ee3f723sm3374383edb.67.2023.03.19.04.36.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Mar 2023 04:36:49 -0700 (PDT)
Message-ID: <98cfa82a-5258-3cad-a85e-aae2bbccb825@linaro.org>
Date:   Sun, 19 Mar 2023 12:36:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 3/3] net: mdio: remove BCM6368 MDIO mux bus driver
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230317113427.302162-1-noltari@gmail.com>
 <20230317113427.302162-4-noltari@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230317113427.302162-4-noltari@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/03/2023 12:34, Álvaro Fernández Rojas wrote:
> This driver is now registered from DSA B53 MMAP switches.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

(...)

> -
> -static int bcm6368_mdiomux_remove(struct platform_device *pdev)
> -{
> -	struct bcm6368_mdiomux_desc *md = platform_get_drvdata(pdev);
> -
> -	mdio_mux_uninit(md->mux_handle);
> -	mdiobus_unregister(md->mii_bus);
> -
> -	return 0;
> -}
> -
> -static const struct of_device_id bcm6368_mdiomux_ids[] = {
> -	{ .compatible = "brcm,bcm6368-mdio-mux", },

This is an ABI break.

Best regards,
Krzysztof

