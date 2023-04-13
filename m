Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66746E0F6F
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbjDMN7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbjDMN7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:59:15 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A164AF28;
        Thu, 13 Apr 2023 06:58:56 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id ke16so14995933plb.6;
        Thu, 13 Apr 2023 06:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681394336; x=1683986336;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EIBJr1yufy6BuzFLpVBVtJzIO8GguQyHLaPLBtr50HQ=;
        b=Q7AIrgTu+81ekKSSdKHYO9laRyCzCRqlaYGh0zPj/+T+kSewctEjMQSIayqjFDV1hG
         GnCCKe8VcSjyBaPjn/n0e7/E0ZtFaAWEP4CFTrttVyj9kdLlhWnTPJuPOI+UXORvS7ZK
         wxTSKM8ewLrdcNwAe2dyml7jtS8BB9Kxtr/dbg9REQYePzWvlC4jMi0ux/E60l2BAcNC
         ZZ19z5pJrzBNsn8JGDamf95/fMePQexIk5rMMfvclvTgTq6C6x0eSNPh8sKx7qYTOiaM
         QTpBs4/gDGNa/9JydQ7gj1aBnFaGKx8zTS0Q9z9uTF3c/c//4+jQMMqlL9itGGIYsgwM
         ajmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681394336; x=1683986336;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EIBJr1yufy6BuzFLpVBVtJzIO8GguQyHLaPLBtr50HQ=;
        b=Gc5L/6sfwFSn1a7JQf1ieurEj9J/pa+v8tglfwd//4KU8jhZgZsOU0R39qjFq01KaJ
         oEzeY5ZjOJhZae/VTl0R7q8VsPgzp0HIiUPPk0VJVhzUFU6mWdFVoU8tp3fYmlIHi6aP
         +sl2dwz+6C9lGd/7pzfJH8fCVLradCohjcRarMGGHHmsRtsp6SJT5PzqEtyJlfEYjLSI
         GIUhv4wlxHJNkqA8Gep+1HV5YqkdWXs3//4xawAp7VrPbRqn0rRL6dWS1LYg7TKljG+E
         oByDYiBTTMR14VC/U+xjroK7bwo78MJiohbWqU13nkbp4NH747N2W4xm0Z+UAsOWe/TV
         vQHA==
X-Gm-Message-State: AAQBX9cpZYvTyOa+mIKiI2lN5fJdUjq75BxIZD5ZaL2bPHxrD6nD3zsD
        19UkugW+fEjFVyd1NtvYZJ8=
X-Google-Smtp-Source: AKy350ZyPHBtAqnyEv4vH3Tgl4GK/qO0Xki6GrxO/YiX9qjACkK7FndwctAOx/7ZGURs6pPtIP1ZUA==
X-Received: by 2002:a05:6a20:428c:b0:ec:6f00:1a47 with SMTP id o12-20020a056a20428c00b000ec6f001a47mr1910236pzj.32.1681394335816;
        Thu, 13 Apr 2023 06:58:55 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a13-20020a62e20d000000b00587fda4a260sm1459711pfi.9.2023.04.13.06.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 06:58:55 -0700 (PDT)
Message-ID: <6e62d6d8-54b0-858e-4e80-030136601270@gmail.com>
Date:   Thu, 13 Apr 2023 06:58:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [net-next PATCH v6 09/16] net: phy: marvell: Implement
 led_blink_set()
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-10-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230327141031.11904-10-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/27/2023 7:10 AM, Christian Marangi wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> The Marvell PHY can blink the LEDs, simple on/off. All LEDs blink at
> the same rate, and the reset default is 84ms per blink, which is
> around 12Hz.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Reviewed-by: Pavel Machek <pavel@ucw.cz>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
