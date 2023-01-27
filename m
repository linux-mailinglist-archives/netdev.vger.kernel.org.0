Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF1F67EEE5
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbjA0T5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbjA0T5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:57:00 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C968B79C;
        Fri, 27 Jan 2023 11:54:52 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id nn18-20020a17090b38d200b0022bfb584987so5738843pjb.2;
        Fri, 27 Jan 2023 11:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7qWcij4aTayHAt6Wc5uo4+l26xq/GGK4KDY+1q8XzKs=;
        b=UzJaP7ZPU9JhSnB/zZRpz7hb94uX8WzKhyyVquotEtIFyK970raf5yjtLwDB6/h6o5
         zPiMwDAcn2Wum27XZTyo7giOTAdf7a2G9TCmhLXhqdCjPN4jGGVr/pAUV94CvQX4KUu7
         aMLM1yCNZAXWT4UJOWLPaS6kL7OT7y9uHrEKWRsYzyQMV8SY3h1qH9vEWkUers6/PTsV
         vf1OYY7fNwJyEzwm5M8WGCeInAx35MUkczakdkN+uPXHmv2D6Jth6yhcYSyE5eupXNHn
         5OdJiiYsfJlMbWsCgexcum6IhDCs1fyV4vsNyZ3Xj9ZqeH12R8xipujKqVsIgxd96xDW
         Bohg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7qWcij4aTayHAt6Wc5uo4+l26xq/GGK4KDY+1q8XzKs=;
        b=6ZtV7W6WvLIbM8mLEA3RxmnMbOxwFh9vbKl+ONJQRsGKrbL2YlmXKZD/wHkQy8vCh9
         I7VBBSFI4W1v2HdFoKZWPQDFrJuPJPHq8qJtwx+xI3NcBwNXhHeAnj6Mxw+Xb0TwPfR/
         1FWUyypYbhSiaFxjATPr2th0mdIm7mXLX6Uxv9aPsExrRHzPd57RS1RS9NQqwjuf98Zu
         6coFybhIECoFMjvzRZZCc86eVQlAfGXwkCJigwnA2nd8uYNJNAcvePC/Bha2qcUroqa/
         /C13luUg54T8CiKRri5WXgD/XIg7t5+C6y3JgubfhYpIDlUoTHkpRVsnL0uiwvWNWItY
         Dr3g==
X-Gm-Message-State: AO0yUKWU78PSgtZQF8ZDnOSxBYAHfG5dv1tzx5WyItqLS6juvdk+EbpZ
        jraqkv7NlW/JvRVUPiQRseU=
X-Google-Smtp-Source: AK7set+4Q3q4VRTY55s2R7chtHR89ziuCpHkRXAGLts7Va0nQf2/SagJ6ynSA9FOUyelBT/uRYCW3g==
X-Received: by 2002:a17:902:da92:b0:192:7c38:4842 with SMTP id j18-20020a170902da9200b001927c384842mr8280388plx.53.1674849221553;
        Fri, 27 Jan 2023 11:53:41 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id p15-20020a170902a40f00b00195e77c20a9sm3243516plq.163.2023.01.27.11.53.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 11:53:40 -0800 (PST)
Message-ID: <75a911bc-3262-11e5-b0dd-0e4a9b2b634c@gmail.com>
Date:   Fri, 27 Jan 2023 11:53:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v5 net-next 12/13] net: dsa: ocelot: add external ocelot
 switch control
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
 <20230127193559.1001051-13-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230127193559.1001051-13-colin.foster@in-advantage.com>
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



On 1/27/2023 11:35 AM, Colin Foster wrote:
> Add control of an external VSC7512 chip.
> 
> Currently the four copper phy ports are fully functional. Communication to
> external phys is also functional, but the SGMII / QSGMII interfaces are
> currently non-functional.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
