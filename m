Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A346E502E
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 20:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjDQS3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 14:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjDQS3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 14:29:08 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A3449E7;
        Mon, 17 Apr 2023 11:29:06 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id k65-20020a17090a3ec700b00247131783f7so10340947pjc.0;
        Mon, 17 Apr 2023 11:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681756145; x=1684348145;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VxqYMpGsUK5vHCXpzGQ9HBKFjTOWbMgTRrCGFMgYc54=;
        b=PvowHmyjyHQp+Je7pcXZuKlB1P9H6MFm/AgV3qCiFXGNS9AFdSaVKbBi9kUoFUGvcA
         P6KY/eNmpqIT6StsyNV3ESNIQD9OOqeZN3EWtWeSKtZEZ04tzy6S7Pwg3bjt6qYgq6jE
         0NFl3F+UuvFlUBDp+cRLWwQDU9Zjwh2JUQnQD4sJXSMI/2y9DEbggke3KeYotnKWv7Lh
         SF5G8RVn9QqNlqjRW+7yRPKAZRxVCBl8xKp6yFyweyJAs0pNwO2M1rMXfxXDV0Zqy1lc
         L8KATagp+mZXQdh5Jk0JABlHFaW9xM0ozZcAhIOryO7UXr68zfFbuJw+gGL0ljKzRza6
         Y/bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681756145; x=1684348145;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VxqYMpGsUK5vHCXpzGQ9HBKFjTOWbMgTRrCGFMgYc54=;
        b=W4E5E5flPdSvEGbACHQbmEc/NG5JLJUFDscYOrGwulaP95bgKs+Au32yey6QlBUn4j
         onlTzgwRRH0RtyNQ+25snyk+/Mb3mLww6vVmnNYGsbswGlrd9Nf42Q4Po9nd6bInhbVe
         Sk9sU6lLno9wh+NVAHGGdMlr08JDwHYQ+9Kphn/NTTSTCZlE9VSl5PHtdu6lc6szeYAz
         kIYR3WgedSToTsQ4xXz6i0s5r2yBEeDVTrtZ2bmG2nkfPncpXzWJ/YFXOJ3WOxrz2+K0
         d7MsCNRVs9//ZnJGb0tRZyTMLh+CFxX4pVIH33ShlVh/1SUa3fOLgO3FiHkABeHghi8R
         qG0w==
X-Gm-Message-State: AAQBX9d8zZrQ/ig/+UOvVERHTNHzwvXk6HtECZO1hKuCS7A2B1/mYFmW
        1gh1buL4lrX1Gt4SxQmGeXOUxREWuBUszA==
X-Google-Smtp-Source: AKy350Zc5to7YXJJ8cONqo3uvWRsWWR5/ydZMeKO0mlNxmwvPabMZ0UtuGo6unBP8sKNgd2QAbZGFQ==
X-Received: by 2002:a17:90b:4b91:b0:247:56b3:4f2 with SMTP id lr17-20020a17090b4b9100b0024756b304f2mr11824803pjb.7.1681756145609;
        Mon, 17 Apr 2023 11:29:05 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id qa7-20020a17090b4fc700b00247164c1947sm306305pjb.0.2023.04.17.11.28.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 11:29:05 -0700 (PDT)
Message-ID: <daf43ba4-22e1-7e07-57b8-ac4a3f82adc4@gmail.com>
Date:   Mon, 17 Apr 2023 11:28:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [net-next PATCH v7 02/16] net: dsa: qca8k: add LEDs basic support
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
References: <20230417151738.19426-1-ansuelsmth@gmail.com>
 <20230417151738.19426-3-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230417151738.19426-3-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/17/23 08:17, Christian Marangi wrote:
> Add LEDs basic support for qca8k Switch Family by adding basic
> brightness_set() support.
> 
> Since these LEDs refelect port status, the default label is set to
> ":port". DT binding should describe the color and function of the
> LEDs using standard LEDs api.
> Each LED always have the device name as prefix. The device name is
> composed from the mii bus id and the PHY addr resulting in example
> names like:
> - qca8k-0.0:00:amber:lan
> - qca8k-0.0:00:white:lan
> - qca8k-0.0:01:amber:lan
> - qca8k-0.0:01:white:lan
> 
> These LEDs supports only blocking variant of the brightness_set()
> function since they can sleep during access of the switch leds to set
> the brightness.
> 
> While at it add to the qca8k header file each mode defined by the Switch
> Documentation for future use.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

