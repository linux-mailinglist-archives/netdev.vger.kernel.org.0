Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0112E648756
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 18:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiLIRJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 12:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiLIRIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 12:08:54 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF6D2C105;
        Fri,  9 Dec 2022 09:08:28 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1441d7d40c6so458797fac.8;
        Fri, 09 Dec 2022 09:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jHYtJJccH9+X/NDPOpvz9wnyLRYvarqcfmCuvCJpp+Q=;
        b=HfTt4h7EkEfMcewy82PySWUMm5u1dXfseCtLH064++6bvdblL5O22m9HSFNM2dWkmv
         d7mC8Z1eLLubRStJWHukjRlXmPp/DPxS8XPKIknlHidJs0LFf2TiTSWOpVuF5oniOatn
         gwmJLA0vU1Ua5CEdERswcB7SKt3PXLVsJ0S+Paz97jLQ+MhjBzkjDNrohWM/ooYPAy0X
         wyZjXnS1dbFlsF6R7txiU2d5HOavKPKOBkIAlztzZwtqHAU++eJoACRD/kPB0+At4Da3
         5RaCgspJurBModVLX3U9EWS7nBUORJQvwXsBV0FwlI/uZiCZUAKs/A4OP+Ke0IEkqpya
         Terg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jHYtJJccH9+X/NDPOpvz9wnyLRYvarqcfmCuvCJpp+Q=;
        b=ipD4LmdFZb/rBgg2E7blX3r2WOUgTw6txZxMyH6PBgA9SsGNdF9nvauchJ8Op2yWTB
         +AYebSLlprwPf3BxI6Yhe0ffDkQ8U9yOI6nUyDG1kdqjLQXuylHRxZzV2Twpho6ENAqr
         LuOdMgSbdwKOZ3R7TMwymBMwuB9ode6cPRRUWG4qrQCDL8DdsHgIKgffMmhBQI0535pY
         +CaBacRvkrs6b9246v487FR0WUfVbj8+gINMzXGG5pdXqVXzMnYhLPTpU+HZccBOOF/P
         VuhOfTOTOoQ6iSU9XuHcESjdTZ1+rJAU8wmm//mR+usWjU4+/ngn4EmUeo7fLQrHPiXb
         jrCQ==
X-Gm-Message-State: ANoB5pnlgU3GAUCG6BH+buZvpSiEI6f2haNnR9lDT019UF8mExC73nKq
        EVDagjDpDd7xpDelkS4pD58=
X-Google-Smtp-Source: AA0mqf51EPz7lTOMPNvcIZ9WKqfSr1XOd9YJrDhxkkKyNmd1mJY/SzA7XTaYt7db2DRcnfqG4kT00A==
X-Received: by 2002:a05:6358:178c:b0:dd:2702:1417 with SMTP id y12-20020a056358178c00b000dd27021417mr182327rwm.21.1670605707315;
        Fri, 09 Dec 2022 09:08:27 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r18-20020a05620a299200b006fed2788751sm223773qkp.76.2022.12.09.09.08.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 09:08:26 -0800 (PST)
Message-ID: <3e6d1cb5-8969-1801-812b-fba2673bde42@gmail.com>
Date:   Fri, 9 Dec 2022 09:08:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2] net: lan9303: Fix read error execution path
Content-Language: en-US
To:     Jerry Ray <jerry.ray@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, jbe@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk
References: <20221209153502.7429-1-jerry.ray@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221209153502.7429-1-jerry.ray@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/22 07:35, Jerry Ray wrote:
> This patch fixes an issue where a read failure of a port statistic counter
> will return unknown results.  While it is highly unlikely the read will
> ever fail, it is much cleaner to return a zero for the stat count.
> 
> Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

