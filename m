Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9F95AB634
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 18:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236326AbiIBQJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 12:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237466AbiIBQIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 12:08:21 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A406B12BC29;
        Fri,  2 Sep 2022 09:02:00 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id r6so1795255qtx.6;
        Fri, 02 Sep 2022 09:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=hr32zQkQAMFpdycV9mqRMwFDXvtj260nxYs/HAKXI+Q=;
        b=FhUCkkvqrme+DUmZztWDxyW9DDj+wrSYyrTFVf4UOHfjt09QSg+oA/zzJNoJPf+vyr
         qycjjscw4FyzNAXtPfCnpN+CDD2dYbkqVu3vPD4Xb4S0c6l0OA2qGV8FK6Wdv298NFud
         glz52AYRgM4/3r3agyXbpN/vCngSK24rs+wqcXevLqSkFzvlRU0ZmTsI+SAcAZUVg/eJ
         0/nb2md1U7wDRVfeWb67FirxksK1zPCp/z1UkAcazvP/pGU+Gh6VGqn3fWigL3mWSL8g
         cHiL1Lsdms4LjZj4J4bWxGZnXeSmszU1GS/SL5HUHqw5aA+XiT/hGM2T3D/fnHpjJyEU
         svjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=hr32zQkQAMFpdycV9mqRMwFDXvtj260nxYs/HAKXI+Q=;
        b=aS2yHDoYjCXz6O8px7jrgjufiGGbmengVExz5u1956glL9PCBX3jXfHKSckPYTpdfW
         FPhSjvhzPUlSdmRB+bal2FbcEzMoLNiamf0Buq13tyAlZj76DbSvq9MTzhJdYaZkVjcD
         EXBvL6lFpjDkjXsBVCCepQ7WRxhAbDwaS+FNT+jlDdY3akzftGBbCBCPMTqDkSIXVS3y
         Zkb+slDVrRVs7A1JmGyOD0qzK1dKy33d6ji07XMw7YPj4rM3kZF0iK3A5+41goRtrOCw
         kd4IBkiyj3sNmfhnFRfdCjQuk6B8sdx4Iock9BglHUzvd+GL8hI784/HE2RPBHokcMby
         lwkw==
X-Gm-Message-State: ACgBeo3QIInAJsih+x3xhNHwN/0+5V/7jKCDNQjWdwhx35XSNdCnHnFZ
        FBR/aDqY90F/l7jlszuW7OU=
X-Google-Smtp-Source: AA6agR73e8UxlvuT6qwwN5qmS8H+HvmUVahNMtcaO5mwrZ77r6fYQfeOKWR7E9FlRFnVvW5xjf4QKQ==
X-Received: by 2002:a05:622a:40e:b0:343:7769:5895 with SMTP id n14-20020a05622a040e00b0034377695895mr29463186qtx.467.1662134476733;
        Fri, 02 Sep 2022 09:01:16 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id w2-20020ac87182000000b00342f960d26esm1206063qto.15.2022.09.02.09.01.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 09:01:16 -0700 (PDT)
Message-ID: <dce48f19-ff7d-981e-90bb-9005bf2fbd9a@gmail.com>
Date:   Fri, 2 Sep 2022 09:01:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [Patch net-next 2/3] net: dsa: microchip: lan937x: clear the
 POR_READY_INT status bit
Content-Language: en-US
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Tristram Ha <Tristram.Ha@microchip.com>
References: <20220902103210.10743-1-arun.ramadoss@microchip.com>
 <20220902103210.10743-3-arun.ramadoss@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220902103210.10743-3-arun.ramadoss@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/2/2022 3:32 AM, Arun Ramadoss wrote:
> In the lan937x_reset_switch(), it masks all the switch and port
> registers. In the Global_Int_status register, POR ready bit is write 1
> to clear bit and all other bits are read only. So, this patch clear the
> por_ready_int status bit by writing 1.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
