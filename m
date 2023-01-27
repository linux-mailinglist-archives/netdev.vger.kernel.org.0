Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF2C67EE65
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjA0TkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbjA0Tja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:39:30 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EBF820E2;
        Fri, 27 Jan 2023 11:38:49 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id k12so4596637qvj.5;
        Fri, 27 Jan 2023 11:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B8weFOdevdbDd+nHJkpNzUOQWJ9uTzMskiaZIbNYRnM=;
        b=NCYU0M4o7ql1yd216RiC3vbtmLHX6RYDhkFsi+GKiCiODpzVUW0+lzBz+FPP9hk5gM
         ewo5FRyqAHiAITW1Xt/Jzv+A/P7BUPg8zGc/RRTgFXPcrE8UVyBi/S1iQNTR5/fd1rsE
         ctBWhJ6mdabJKQbXBZeyLOZi5fQGOjVx4UXGhViym2SrCQFT89ixI69NqOOJIzBgC/nu
         Z6x0MEElfytWaQwXQX5t6IfIqDaMLuEuZBNMeEsjYvDKIP9w9NffJvJGnCU+F3gP5kHc
         Fg3RgeeKLWtJoNlUbaZKKNamIiW24kw6Ee1eIXdpo9Nvd9YD1SpagAws8wYSKHYJmHLq
         Qelw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B8weFOdevdbDd+nHJkpNzUOQWJ9uTzMskiaZIbNYRnM=;
        b=BKe3Y+FKg0uKI3E/GawrEcZHfdUoldBbY/tszs4Pl1fl1y7mVkg/Mra8EkIPJSNbhJ
         hufE1W/Budhd4u2/ZYaOzA+yjXey0yMOYn1LijSoAyDGWEa/m/UQC1tcLCo6AbByAmmI
         t187eSlunx6gMZBh7UPJmku1pVphiWg0x/w4jpxi+bE+n5mgGjEGRlmm7Tz4Esc5HJMA
         od85B4X4D6Y8mzmtQzXxSccEskrm1lLj520SegoLu8DOmD1TUTOKUxjyRc+M7FGvadTz
         RcSiyGVdVcGZ5jvzMa5+gXj9bOVxgMu/7ixoMlAV6HPd0wzkhmZQpNzXKYBD2gfkrk+i
         x2Og==
X-Gm-Message-State: AO0yUKVCWSL3jlcZnhUWGtbZAjyzCHf4P5jJbIqit4YndgpJdMjYunUx
        wL/BYJdYm60QsOPVDMDZ5Lw=
X-Google-Smtp-Source: AK7set/492aaZa/C2lxnlygjv6TKqlsoELgK1NBobT77pMnLQFRbSvuOfWBpVWdhKa+70o9zqBO0bQ==
X-Received: by 2002:a0c:9e89:0:b0:537:9e59:3997 with SMTP id r9-20020a0c9e89000000b005379e593997mr8450082qvd.51.1674848311480;
        Fri, 27 Jan 2023 11:38:31 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id pj4-20020a05620a1d8400b0070648cf78bdsm3410026qkn.54.2023.01.27.11.38.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 11:38:30 -0800 (PST)
Message-ID: <55e43946-a2cc-064f-b685-f82a4829301d@gmail.com>
Date:   Fri, 27 Jan 2023 11:38:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v5 net-next 02/13] net: mscc: ocelot: expose regfield
 definition to be used by other drivers
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
 <20230127193559.1001051-3-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230127193559.1001051-3-colin.foster@in-advantage.com>
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
> The ocelot_regfields struct is common between several different chips, some
> of which can only be controlled externally. Export this structure so it
> doesn't have to be duplicated in these other drivers.
> 
> Rename the structure as well, to follow the conventions of other shared
> resources.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
