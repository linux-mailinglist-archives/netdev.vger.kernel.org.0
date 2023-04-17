Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC116E4946
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 15:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbjDQNEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 09:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbjDQNEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 09:04:25 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E8A33A58;
        Mon, 17 Apr 2023 06:01:17 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id me15so4807606qvb.4;
        Mon, 17 Apr 2023 06:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681736401; x=1684328401;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EU8lt8g3BHj29DyEU3O7m04VLuto4byGKmuRQPUH1+M=;
        b=nPuj0w7LyS4vsjQIgfCDKN0zyGHxauQq0+rCh/ZlhTmipM8CwP0cF6aS6s4JVjMwb5
         TmYE7iIB0qVK4kq88esBAO1VITCJiqhYjYCLd7lycuHY+qrYoaNATxJUWdU9f40qSeKq
         8roEc2Zb3ydkimNq26HzNUYLHiKPsSFQgPTZiePMRWISHkNMChY0j0QRxmk33ucKI3jd
         Avx1e+DMuN0m3cSgwTlYdALqjXeb0LofYcAWpTb6IHkIKxIyPv/N5CZ8350V1K0zBiFM
         I1lCsoOc/gf5AhxR5LBjc5f9vY9CDMt5g7M/inQMCsavx6K3AmVPFRSwB+3Z9U6vi+6o
         IzIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681736401; x=1684328401;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EU8lt8g3BHj29DyEU3O7m04VLuto4byGKmuRQPUH1+M=;
        b=R2h158NfczQ+0RfKjX74DRG6EbhG+Sjt+VBejkuTMiekqWFyRusvR8t7v6q4U2+17l
         hfuULy+sZ90TJZI0rRClVuN6LogEWFu9XYGCkEMTlhsLVHbOAeDADu4N/qc57zl6qeP7
         Q4tKbOPT3I4ZyAP7rpUA0mBRbjSvDvIhIQhljVGEXCoGgmR/iF/A3FAGIQwgrlefA4Up
         6l19glnlF9XKVKn+py/6MZNl2TaYeG0kQ5hqWK0R3QDr1wKB0fhNO1Ove69gLKoZ0Aqm
         Eq6lRzEp/9zlbQ/QbKgXVX++jvSD6SJZTZWjlZ+UF1a7Alil6kdCjNAs0y+U/tzECEno
         KtTA==
X-Gm-Message-State: AAQBX9csBv7RauMk036vk9o2uUW6Hcf1rdQvOFBu9qcAzokuvyLgLucr
        xdHtTFxCbJ6H8n82LMUIafc=
X-Google-Smtp-Source: AKy350YjYQ1xFRHmsgqqYTyHX6+4El7x1QTwiKMzVkFWTqZ6GHPGaCRvix4ZQB9h+4VHbJgcNkzzSw==
X-Received: by 2002:ad4:5c82:0:b0:5ef:565d:ae6f with SMTP id o2-20020ad45c82000000b005ef565dae6fmr20623225qvh.52.1681736401091;
        Mon, 17 Apr 2023 06:00:01 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id lx13-20020a0562145f0d00b005dd8b9345b8sm3022945qvb.80.2023.04.17.05.59.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 06:00:00 -0700 (PDT)
Message-ID: <0f5dd91c-2e18-adef-2dfa-51e48696b2a6@gmail.com>
Date:   Mon, 17 Apr 2023 05:59:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 4/7] net: mscc: ocelot: don't rely on cached
 verify_status in ocelot_port_get_mm()
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
References: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
 <20230415170551.3939607-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230415170551.3939607-5-vladimir.oltean@nxp.com>
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



On 4/15/2023 10:05 AM, Vladimir Oltean wrote:
> ocelot_mm_update_port_status() updates mm->verify_status, but when the
> verification state of a port changes, an IRQ isn't emitted, but rather,
> only when the verification state reaches one of the final states (like
> DISABLED, FAILED, SUCCEEDED) - things that would affect mm->tx_active,
> which is what the IRQ *is* actually emitted for.
> 
> That is to say, user space may miss reports of an intermediary MAC Merge
> verification state (like from INITIAL to VERIFYING), unless there was an
> IRQ notifying the driver of the change in mm->tx_active as well.
> 
> This is not a huge deal, but for reliable reporting to user space, let's
> call ocelot_mm_update_port_status() synchronously from
> ocelot_port_get_mm(), which makes user space see the current MM status.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
