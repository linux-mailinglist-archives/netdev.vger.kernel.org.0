Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B82632E02
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiKUUek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKUUei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:34:38 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA077DEC1
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:34:38 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id w15-20020a17090a380f00b0021873113cb4so11987468pjb.0
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g1NItrxejtP1yO2zPtw+AtII4HZR0d2AHXIorpzzV8M=;
        b=gQAUepGsvQgIIj1yzGIyDpxIlPmYhZ0jSpWNwYh9ME0SWosdir/QQ++jGxToJ93hs+
         20Uh9Tp9S76Uw8J72Q8faHYIYjzklS2RWTQTOeeb7wFqO1K3W6cY39kn53WVvizoKlD8
         /vthg1eREO1kV3jd/rpLs39Yhj4N7hFEEyzGnyO+6oFp239HXSAd6u5HJ3UX/X5xNJZF
         ekUewCQHMAPVrNsgT3x9mm+mxwct3w027sKDmvIbNOAPnGxXcueDoelK/N9iCjwEB/81
         fy9NS4veZmB9INrNtqZM9PyjnLrgQ21CGuNs/If4Xf5eSH6Xojabit9zMSKaheePh4U1
         Te8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g1NItrxejtP1yO2zPtw+AtII4HZR0d2AHXIorpzzV8M=;
        b=lIRfU4vaYNx/ta5ah5vYiI1Y+n/rZl28F4Xvuo9upizCvVIvz5Jw/jsUWHn+o3c8SA
         c5kESiRgpEuiA8ZXcSq2Q0HlIJoc2s+S13DwJ817BmWv/5I6ILCEgUmY87BL7rwJmwrz
         j9QgKKFYCkyQUHdxTt8y6Jd+rydzloBxlG/ym/CaILlpQMBAPdm3OCFeiUHSDHy+cDFC
         xUVxJNjpkL4M2SjP69l58DJ+XQO2L+HzdjIfC9jafsomqmM1IBKywHvicFm4old0ZFEI
         Wk6Pl8ePMQGzZW+GaYtkmNcrZpwv0K+uExUPWqvSghR5+iFzd46EBF0pbThzRuXaxfuL
         EyZA==
X-Gm-Message-State: ANoB5pmnH/Vj3Zt9zcleQNdD85LbwoVk+8HXxK2U6BTdroAHucu2taA9
        /PILFIDshTplUFPHfhCTHAw=
X-Google-Smtp-Source: AA0mqf74Mj3ixwfoVXLSzDNUzsmQUu0KawhtCm/hWV4MMl5xzov4PlflpbWdqXmzhvKsk4ldRP1K1A==
X-Received: by 2002:a17:902:aa04:b0:17f:6fee:3334 with SMTP id be4-20020a170902aa0400b0017f6fee3334mr471434plb.10.1669062877499;
        Mon, 21 Nov 2022 12:34:37 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z6-20020aa79906000000b005613220346asm9004180pff.205.2022.11.21.12.34.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 12:34:36 -0800 (PST)
Message-ID: <397d903f-719d-f85f-708a-5a0b717a1ff4@gmail.com>
Date:   Mon, 21 Nov 2022 12:34:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 11/17] net: dsa: move dsa_tree_notify() and
 dsa_broadcast() to switch.c
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
 <20221121135555.1227271-12-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221121135555.1227271-12-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 11/21/22 05:55, Vladimir Oltean wrote:
> There isn't an intuitive place for these 2 cross-chip notifier functions
> according to the function-to-file classification based on names
> (dsa_switch_*() goes to switch.c), but I consider these to be part of
> the cross-chip notifier handling, therefore part of switch.c. Move them
> there to reduce bloat in dsa2.c (the place where all code with no better
> place to go goes).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

