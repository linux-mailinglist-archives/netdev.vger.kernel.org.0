Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1278C58567C
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 23:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239328AbiG2VcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 17:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiG2VcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 17:32:04 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456848AEDD;
        Fri, 29 Jul 2022 14:32:04 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id o12so5684870pfp.5;
        Fri, 29 Jul 2022 14:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Ohhbho9RS/8PnD/2EdnpQPM4lc6r0FGRug8fCKvlEMU=;
        b=YbxVWXR+zTrfcLxYlnH+Z5jx0QjIiwYAMS9LyrXZfd0WkLeP2Omuo+ajoODEzGQULO
         KaajqbIi1tHXkTLCF0p+TW3Hts3Ld2cuKWv+2Hn9WfwdPNtyIz4AKz69ED3KUSDpzNLO
         mnKVZa8tNUDlzwmsCnoprmuQ7QqFdZA1egXmwKZ+rA9bNxL6JLnPLfdDGsYAMEdL8Kt1
         14MbU6LUnFhIRJBCqfWH/4NFwfM/52FiKxvoP/hvc9E0gG9eG9cX7qn1z0iccUIIQi8/
         CzRCSGjwoM/qooMiBq58iugJJ44Y1xAV2lUkCdAG3nBe9rGX5HoEEQr6hNpCrcUMjHmQ
         XbIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Ohhbho9RS/8PnD/2EdnpQPM4lc6r0FGRug8fCKvlEMU=;
        b=Jy0D67jNmRtsT4l2LNhzwvbRdow7GGkvPGBzjAgYjzpw/hiJuWbhkhKNtWaGzVAzSS
         6nxzptgqRlDAb1WiClDAdo3XcgGSbwq2y1Oknk8qeclc7jZWQScNCxGR9y8Ys2CkAdB6
         /ptT97LiGCpedlhmt+LPzTWeaODtaspztwyon49CbnvIei97puveigmc44hSwzLNta2D
         FFmgTKxNYWcqsdIwTejTvlYbxtJU5GLQqigzB7Y04xIQq81y32tMSrbChgxpf2Jq9ndV
         X+L+NZMfso+7o7oIINDXs9TIZa2yP+3Khz67lqOY7MVXg4Xing34plJ6/mmXw0uS7Dgc
         Xhtw==
X-Gm-Message-State: AJIora9Snu7JeRR46lhMNJsRySiBqlygb1kM304yDbfH5Lc+ZeK0wnfd
        cT5WZAs5Xt/MA5LX16Kmers=
X-Google-Smtp-Source: AGRyM1swWrPm+veXZUEIlmG9FIsHcVas0dsxVQk+XyxV5xhHw5FFGaJ3N/jZKLfen58M8g+gF//qxw==
X-Received: by 2002:a65:604f:0:b0:41b:558b:4be with SMTP id a15-20020a65604f000000b0041b558b04bemr4499972pgp.597.1659130323577;
        Fri, 29 Jul 2022 14:32:03 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y23-20020a17090264d700b0016c48c52ce4sm4097327pli.204.2022.07.29.14.31.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 14:32:03 -0700 (PDT)
Message-ID: <6d9eab39-cca8-d40b-4af2-b30c583ed026@gmail.com>
Date:   Fri, 29 Jul 2022 14:31:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next PATCH v5 01/14] net: dsa: qca8k: cache match data to
 speed up access
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-2-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220727113523.19742-2-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8
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

On 7/27/22 04:35, Christian Marangi wrote:
> Using of_device_get_match_data is expensive. Cache match data to speed
> up access and rework user of match data to use the new cached value.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
