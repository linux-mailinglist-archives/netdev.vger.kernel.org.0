Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A046BBC3B
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 19:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbjCOSfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 14:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbjCOSey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 14:34:54 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9215F7C3FF;
        Wed, 15 Mar 2023 11:34:26 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id i24so1118651qtm.6;
        Wed, 15 Mar 2023 11:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678905265;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uEaLzn/jN+Pjmss+rj58XZA9n+R5W97hS6oiTiEatMI=;
        b=H9FCfPVsksK7yPtRdNEeUxP5tSiNs6qNh4oY6twLzzpbD+LfsZH75QyGTFL0XkFDkP
         udkqCuKok+1fF+Ctov42PCZvPnoZP+giBC3EYU2dPqqi0sCA3K7UFEN+EJ0v4wZd5CBf
         VbecwPzeR/oxRKmSoePOJsPqZp/+ciJTKotK92yri/grt79D+ok5eXq0PY5QMry3uGSD
         wcJwX2Eh+53QPifZIEEovNIB+CTvvq3IKh+k/qsYPhJniz2BnLj5ua4jeNNKBqTEn97d
         Nn9rmKK7AMC2+vPXwulM70VLwdcH60pr43iYhxdhEmbLhRjNMlpKnoEotR6XZS8/Nerz
         XGrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678905265;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uEaLzn/jN+Pjmss+rj58XZA9n+R5W97hS6oiTiEatMI=;
        b=adqYL8LCG/thXcknA2QitC1TOE+r5KkUdseC5Eqg6mWQ8YCfVZpJUjcSXIvoHDKgyU
         ZhoveTIQ294R2UwkzIsgaaSrKxtdBPTPBwmzxmM6QpYJDx5bkXQHRsZy1pvLgaoZoSsB
         GlvEXVsxa3uytH0JBoEdZLPR7VLkaKzjvW/76yxt+pz9dIlu4xkzbczLYCzaym8HfvmP
         FeAQZZxcxwc9Z//fBj9FglIlGDI48BiizpLeaJnvOWizwFf2vInWXd6QLl2LlQgtW5V6
         YGA9qL0lNMQiCmFAfyqNBnaheIb5+QXmd7HOJeg5PwbUDxEHaUK1zX3ETXWkjQ4PsAiW
         daqA==
X-Gm-Message-State: AO0yUKWJmDSYkEEsLrP/wZteAeeCZYJ5++5+mArgiAd45SCH6oLbWfvH
        emPpKRa0toRlbikMgH8uric=
X-Google-Smtp-Source: AK7set96Xl798ubI7hM6CE833RDYyRrXNEc8+ym0JxhW6zonaBN3EDquQ1refgKJsyuY+hgpIahdZA==
X-Received: by 2002:ac8:5e4f:0:b0:3bf:d9d2:487d with SMTP id i15-20020ac85e4f000000b003bfd9d2487dmr1584893qtx.8.1678905265448;
        Wed, 15 Mar 2023 11:34:25 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l7-20020ac84cc7000000b003c03b33e6f5sm4161601qtv.90.2023.03.15.11.34.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 11:34:24 -0700 (PDT)
Message-ID: <a2f99c07-f9d0-7e35-61bb-cf3bf76ca919@gmail.com>
Date:   Wed, 15 Mar 2023 11:34:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net 1/2] net: dsa: don't error out when drivers return
 ETH_DATA_LEN in .port_max_mtu()
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Lukasz Majewski <lukma@denx.de>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <20230314182405.2449898-1-vladimir.oltean@nxp.com>
 <20230314182405.2449898-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230314182405.2449898-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 3/14/23 11:24, Vladimir Oltean wrote:
> Currently, when dsa_slave_change_mtu() is called on a user port where
> dev->max_mtu is 1500 (as returned by ds->ops->port_max_mtu()), the code
> will stumble upon this check:
> 
> 	if (new_master_mtu > mtu_limit)
> 		return -ERANGE;
> 
> because new_master_mtu is adjusted for the tagger overhead but mtu_limit
> is not.
> 
> But it would be good if the logic went through, for example if the DSA
> master really depends on an MTU adjustment to accept DSA-tagged frames.
> 
> To make the code pass through the check, we need to adjust mtu_limit for
> the overhead as well, if the minimum restriction was caused by the DSA
> user port's MTU (dev->max_mtu). A DSA user port MTU and a DSA master MTU
> are always offset by the protocol overhead.
> 
> Currently no drivers return 1500 .port_max_mtu(), but this is only
> temporary and a bug in itself - mv88e6xxx should have done that, but
> since commit b9c587fed61c ("dsa: mv88e6xxx: Include tagger overhead when
> setting MTU for DSA and CPU ports") it no longer does. This is a
> preparation for fixing that.
> 
> Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

