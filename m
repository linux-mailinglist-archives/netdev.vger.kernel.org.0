Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1449A58568D
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 23:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239357AbiG2ViI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 17:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238882AbiG2ViH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 17:38:07 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967F48C162;
        Fri, 29 Jul 2022 14:38:06 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t2so5693792ply.2;
        Fri, 29 Jul 2022 14:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=uWB8tH4w5fjH9bObIeBmYZmXBFtr/f8bJm12s1p3xPo=;
        b=nBsTFnBXswFauJmi+2a8lPem1fN56xgD/wcO6+lfIh/PNHYD0l+oCKztUDEYAf4Dn/
         O1t2ndfUxJD8rJPVXSEEZ0oDWioCapPkWf2POTm8+Je3l8SIpPKmJIK7o9EcICRldDrL
         lHDMSgloZ4ZR5BW6yJNrZqDxCD96pd/WYa7NcS+8xvLqJ9WaYoFaW6c+N3sMQu8CwANB
         /BSuggR3zL1CRUuhEt8SoS/BAKqiauRf7lvaH+bbu/26QdyAmqzUw7tZ7zTwPNDcMztc
         RxBFX7mg/4DUVy3wS2iVEsxf2ZuN3RVQgyVJMZT8g5SniR+bGh7GqukcOqtrUJziFi6s
         2/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=uWB8tH4w5fjH9bObIeBmYZmXBFtr/f8bJm12s1p3xPo=;
        b=YZyMQ6DWGqXZ/LQExo9mByTWAt+SvWVOpAngTo4s1alcbZnY96iD7YY/mzM5XUL8/H
         9lQVla5RAstayFkAHTAVRZ4WbcmxEDvrELFU6ALJ+twYVMrKGILDFdylCZGcsdBrZPmw
         pa+ffuNCXp5kzbsm+akcG77vwarkBt7ow6Hc6WvUDYVP/HXbPghMcD+2TtAHuDnDtEoE
         VaUsb3iu05o3tL2KhVsA42+3Au+fIhdGJkvA5O4fvfRdfsmt7cH+FCBVmJevv9doX4wd
         IHSaJHF/9AmRHDA9XAv4ZuE4ShLvVsNv5WPp0IYDjlabeNCWoIY5E7VTdYDmIxXdu3X1
         pgbQ==
X-Gm-Message-State: ACgBeo0ySA24NoTMaQSamlck2PQYAQqaYAJ9RIaRhVrygf3Ku0PnDBaS
        2k2YIhtkJ+WzJoQJAU/fHz4=
X-Google-Smtp-Source: AA6agR7tSjRp8wvphJupJEsOpzh/qDzzdsZvE17v7uZTL/FZahgmRs+oor3SrstwRIQPTG70EsWCfA==
X-Received: by 2002:a17:902:7807:b0:16d:ce68:445d with SMTP id p7-20020a170902780700b0016dce68445dmr5690898pll.148.1659130685967;
        Fri, 29 Jul 2022 14:38:05 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id mg20-20020a17090b371400b001f30b100e04sm6287244pjb.15.2022.07.29.14.38.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 14:38:05 -0700 (PDT)
Message-ID: <f14c1181-87ee-fdee-9942-713e46c1068f@gmail.com>
Date:   Fri, 29 Jul 2022 14:38:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next PATCH v5 08/14] net: dsa: qca8k: move bridge functions
 to common code
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-9-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220727113523.19742-9-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/22 04:35, Christian Marangi wrote:
> The same bridge functions are used by drivers based on qca8k family
> switch. Move them to common code to make them accessible also by other
> drivers.
> While at it also drop unnecessary qca8k_priv cast for void pointers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
