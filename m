Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4DDD68F478
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjBHR1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbjBHR1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:27:15 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA24420B;
        Wed,  8 Feb 2023 09:26:48 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id g7so21565070qto.11;
        Wed, 08 Feb 2023 09:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SMp4omnrbiYUOgLR33aH/+uqQ4cKHbEEuWNy/QEw9OA=;
        b=oF+LoIq0H+YdYKYs9tXYtnC2oDaO16qyzNHbwobhGHut3qgDuocGV2ZxhWEvG4NRGY
         4J6iebd7ukct27L+yzi9t/7v7QydKd/dg+D1Fm7+S/DFH2WM6cIV+MpxxNqk+h2LEsV0
         HfjgqNZpV5ZQH8mXST1UBDUe280nqo46BqdXoKIpGdBpjsA8w28rvcqMAWuM1Fhu9ZZg
         5C/O10agtJgOIquJgzkOHRs05EkENch8sfoIOQbagN+u1DipiiksY+iZf0oB7XP2xmHQ
         77CJJvhvRuIFHgJjrkiuJkVQsPxtUY/lajW+zngSpryx8jdz4w/6GXRQi8mILEMUF62p
         zVIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SMp4omnrbiYUOgLR33aH/+uqQ4cKHbEEuWNy/QEw9OA=;
        b=vun1wROz7ltavTcMy6JdIGnDJOfrIDnO1vY86S7VQq5UyJYr7mQyUsHHCu1bbTWuHs
         87fjx1SrHu+1ySCvjb5/kx4DBmZy5DMLpWjbSV8ia/NzClGLF8pGGfO9WMcc/y7XZoih
         LCbXpcjGD9BqfTn/zbLyq9Uv/6G248F47AQNAp+xPbg92u4nzlp8dkVmx+mfJ/XWnwZ1
         brmS6y9WJzuEQSNBxqSNaf/GCTZ9JbpMNriFQlRr9TiI79/7G6ZRkl7f4jW2d/Kegjtf
         CzSk1T1hVAnzv+eaeCP67ZcfQU7V5YinVvc2LFoS8RxPvNORvcy7WzSVeZbHpjF0wLzl
         FB1g==
X-Gm-Message-State: AO0yUKW1W7b0hX1dTGzQ4NLTFBMAQtMTA0zpQdLfC4xpczr1F89ZOb8z
        2hrih9ATNt0JJYW5XTIyqKs=
X-Google-Smtp-Source: AK7set8pcKtMGkZv8C4JXzVebCkubJlZW3yFseOnP4JtiRkBzA+9gpFAbtT8b8Mo1W5Joc8kZ4XoaA==
X-Received: by 2002:ac8:5c50:0:b0:3b8:2d45:4760 with SMTP id j16-20020ac85c50000000b003b82d454760mr13658103qtj.61.1675877205219;
        Wed, 08 Feb 2023 09:26:45 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r10-20020ac83b4a000000b003b9bcd88f7dsm11733082qtf.43.2023.02.08.09.26.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 09:26:44 -0800 (PST)
Message-ID: <16976e1e-9c62-715f-b6cb-8a3d0098a23f@gmail.com>
Date:   Wed, 8 Feb 2023 09:26:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v3 1/3] net: dsa: rzn1-a5psw: use a5psw_reg_rmw()
 to modify flooding resolution
Content-Language: en-US
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=c3=a8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230208161749.331965-1-clement.leger@bootlin.com>
 <20230208161749.331965-2-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230208161749.331965-2-clement.leger@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/23 08:17, Clément Léger wrote:
> .port_bridge_flags will be added and allows to modify the flood mask
> independently for each port. Keeping the existing bridged_ports write
> in a5psw_flooding_set_resolution() would potentially messed up this.
> Use a read-modify-write to set that value and move bridged_ports
> handling in bridge_port_join/leave.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

