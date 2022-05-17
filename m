Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D978F52978A
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 04:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236507AbiEQC43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 22:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbiEQC42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 22:56:28 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F11111A13;
        Mon, 16 May 2022 19:56:28 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id s14so16184967plk.8;
        Mon, 16 May 2022 19:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Q9Ai2SC5IaCYWiy3V3GAcS8ERRaKC7t0xTnH1HRB2Dc=;
        b=TCJWckB5u8l8PynksdB80EJr5p0pqraw44ZViivn8n6CM+PWJZsmJelnXxpur/42Rj
         0Tz6kC10xWpc3RWFwFryj/xQjjtft18X3+/+R8EAx0wXSmRg8LWfzjq/tIipDf6+5xPM
         9QXxNKOsxK5o+hHF0EO9E436lZvzS47kXVXHFcEyW2bKZY66107hQ7a6CrEP8cJcPImQ
         3arZpcaQD6At2pwm5706AwSOqV19+84u2W9VYR+fS3K/E9/ZuCjiE7xMZhG03jvbcHKy
         O3FMw61Xf2HgtWhuq9HvFS2KEihZK744LIDAL56sIJyvir3D/t6+M/MAn6UavH2DmG7I
         5FUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Q9Ai2SC5IaCYWiy3V3GAcS8ERRaKC7t0xTnH1HRB2Dc=;
        b=C5yClSj1wPkTxnfwOebzTTHzcvCc2asV4ZZudap95nKXthNXNPcjpE4+iNZJ2I9LXm
         QfycfKDDe9vQEUZjmL3ClBsoQ1F2zYs3PaqNnXWGYEXyxyuxXz6jkY9zZj4FXOaJ7JiK
         NaPZf1pz01gfCscSe7NwVi4LdqzrfyxSOopxbqCygVSgRr6/2EdLFZO2CwS4BfAyiFCh
         yQ8709R8z8RspZ/FohFxaS4XiIA+YeQ7FGnPhj2qeGnCQw8M1znMEHiKMtGsqmzDh+tX
         zP/+bmXUtR3jazO8Va8rHg8Ussmy40XxPGJZZ7WU90hRLJUXdwxRbDYjUqL5NmGO1mrU
         dsaQ==
X-Gm-Message-State: AOAM530h1DElZjLIqbgS803V+YPLzj02c67g4EvmlUCBoKBHi1upp+KX
        z8uZqSoqhHhQV37hdJCW1iM=
X-Google-Smtp-Source: ABdhPJzBV4IxWdeXPDR8/OhI8Fs5XViPl7VTj2P1ar3XMyGdJc27EzdP7y7FGJOr80sWFUKhA4DdJw==
X-Received: by 2002:a17:90b:1809:b0:1dc:1597:20c with SMTP id lw9-20020a17090b180900b001dc1597020cmr22675439pjb.36.1652756187635;
        Mon, 16 May 2022 19:56:27 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id p123-20020a625b81000000b0050dc76281d7sm7753734pfb.177.2022.05.16.19.56.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 19:56:27 -0700 (PDT)
Message-ID: <2b7a94f0-7f1a-793f-91da-f4508534ba9f@gmail.com>
Date:   Mon, 16 May 2022 19:56:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [RFC Patch net-next v2 6/9] net: dsa: microchip: move get_strings
 to ksz_common
Content-Language: en-US
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
References: <20220513102219.30399-1-arun.ramadoss@microchip.com>
 <20220513102219.30399-7-arun.ramadoss@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220513102219.30399-7-arun.ramadoss@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/2022 3:22 AM, Arun Ramadoss wrote:
> ksz8795 and ksz9477 uses the same algorithm for copying the ethtool
> strings. Hence moved to ksz_common to remove the redundant code.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
