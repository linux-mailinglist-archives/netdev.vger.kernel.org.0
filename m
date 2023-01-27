Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F5367EE67
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjA0Tko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjA0TkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:40:25 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF9022788;
        Fri, 27 Jan 2023 11:39:31 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id x18so4621688qvl.1;
        Fri, 27 Jan 2023 11:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ktwXV2v9sxz8B6JFTHh3jtazavEY62ysb8j6M/sBQ1c=;
        b=I/tdKLqntkyAVcEap6t7RM9qCBJdnnJKDArJbip5feB+GAGRHLHebl1uLN4K0uZQpg
         rynh+Wr1ZhOCcMNWXJffkglMRp7fSiVmJQS4VNmKPKwQMM/vUMqsQ89hasO1pijGs0Sd
         qXifzSeEDomhESL8vIloEwDVs/ANRjI2mbZiLzF5HIRI09kJMVOdxjTV6pOu80NkXsoO
         N02N0riOIFPnO9LOil+xXYjDso4hUAwjKoDo1PX4DGkaOtF3sT9t17RDfhHKHvTmP01f
         s4ksydx6QuQghcYuHCHBlvbpItlRR/J+BTSHfELZvArRjqrjKt9RxUl2QkmzoRcZTvt1
         TkEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ktwXV2v9sxz8B6JFTHh3jtazavEY62ysb8j6M/sBQ1c=;
        b=0BwIf6INoA+WigFc1pCc1hagh3AJlWoU8GRXg5UoQXDwaf/pc6pLPDWYA1BFOd0SMz
         ULtsttFFYRl6qoyKn97rkQuRnyd+xoi9P8Uq6d9KCzLj4VYN5wX3QM5gKmjxWSrSSxA0
         GlToGGRstyNE09BaZJzhfjeOJFa99x4SEWp2DALER0DI8qbIW0oH7mkqRxQwendXT9HI
         Wn6hl6SFdvLM/HlHBl9R9m9tASppYalGSIfxfdxZfX3ECNbJTKZvAxCVeUOBgLmfdmfP
         0qaFHOxuD4HFms3gz9RkruMFx6F9/C80sAIPCU9Agbb+AIhh4yVBzQLotkGx3UJc7lcz
         gxMw==
X-Gm-Message-State: AO0yUKVLDIrVEhh3iQ19QuiEDZx4TrfhLZ8IVFKD5d0MGAhEi0nPZkYk
        EEzLhNRa1cifiyG8t0/VLW8=
X-Google-Smtp-Source: AK7set8tYHfJi1aI2/QkWMigkUPEupUlqHwekkzIeOlpEBLuq2UqojfhMEt1JVMf0yvrdOiURJriRQ==
X-Received: by 2002:a05:6214:a8b:b0:531:8b4b:b59d with SMTP id ev11-20020a0562140a8b00b005318b4bb59dmr8772957qvb.50.1674848323529;
        Fri, 27 Jan 2023 11:38:43 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 66-20020a370c45000000b006fca1691425sm3382565qkm.63.2023.01.27.11.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 11:38:42 -0800 (PST)
Message-ID: <88b9f46b-9077-4d3f-b7d3-1bb6ec505f17@gmail.com>
Date:   Fri, 27 Jan 2023 11:38:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v5 net-next 03/13] net: mscc: ocelot: expose vcap_props
 structure
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
 <20230127193559.1001051-4-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230127193559.1001051-4-colin.foster@in-advantage.com>
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
> The vcap_props structure is common to other devices, specifically the
> VSC7512 chip that can only be controlled externally. Export this structure
> so it doesn't need to be recreated.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
