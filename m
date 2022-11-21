Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0EED632E0B
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiKUUiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiKUUiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:38:21 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DCE8326F1
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:38:20 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id s4so8059076qtx.6
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gz7GnEtcMakrKauSuV0Dj+lCo9MwCIzLSv/B6ID4Srs=;
        b=hPUu1zqIFSZKglrwZZmjsX2r/BgN4IgzscodyERAHSj+GrJ10FBxaEBtSnf5vjiQtI
         0567Len+49k0rDxjw3uFRvIL56SvyHxmIiNlOLyUYldwqjoUpi2ZNUTjDCxT/DoQorga
         eOKlzpvQV0t9atZ04u5WU6R2h8EEMIpMtZajduBXOM1wtHmNZcuqgCgVdMrTnvasjHjK
         Jr3Cfyk3JWQxXKuRcw3gtMISKHFMEfZv7DeO0fWkFF71y6lTFRq5L+NUQ8j5YwTD2bGe
         SAguqLg9C2IJMJpvfLkR2H/hDXMoQ+5A7nEriRAK9YhH+I8l6XTjdsF6RpDXtHtCA9HB
         MEBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gz7GnEtcMakrKauSuV0Dj+lCo9MwCIzLSv/B6ID4Srs=;
        b=5NmMgB9OB9GKpKf5RrDru4JuI/yVcp0p3r/olik51GH31Js5KpDxY77iFs+hmHvk5y
         Vnx91Qj8IxghZ7V8AtU80JqetHNE5nUhWT5JpzsH0cCjR95nSfmxOoeycZIk8WcqvKk8
         Xgti3zzNsM6R0USRt+DqzmA7PIv+6p5+Cxy2TtQGJ1f/bn5l3Bnr+jvgWTNOy9dqySWh
         N5ZdDS5DgVqydNrORptCmtuM67gpp3rk/0/XP+uV4Omhe0bY1zIn3QnG87ms+rOrGXIg
         xXEw91X5ebuConmvmDE9k56A4+m4waocYrcV2Y+ikzgATzRKew8XmkktvwE6NUEXq5Dy
         iX+g==
X-Gm-Message-State: ANoB5pn7z5zq2p0p79Mh8HYTT3Yq30fAJr/pUYocrGbolF+LC6JCP9+s
        dIUxWoWK1NtoaB0ME0tX1uKp8QU7f2U=
X-Google-Smtp-Source: AA0mqf7djAp+ix3X/bb3Hqxgku/8r6x3XEtZGVm7XGSNOaS0tA6+bzY+ZSN/cHLSJyQbyO6ZR6uh4g==
X-Received: by 2002:ac8:41d9:0:b0:3a5:6a0f:49f7 with SMTP id o25-20020ac841d9000000b003a56a0f49f7mr3000111qtm.389.1669063099648;
        Mon, 21 Nov 2022 12:38:19 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u7-20020a05620a430700b006eed75805a2sm8854287qko.126.2022.11.21.12.38.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 12:38:19 -0800 (PST)
Message-ID: <0bda268f-95f4-5e7a-6bae-ba61a37d93e9@gmail.com>
Date:   Mon, 21 Nov 2022 12:38:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 16/17] net: dsa: move tag_8021q headers to their
 proper place
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
 <20221121135555.1227271-17-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221121135555.1227271-17-vladimir.oltean@nxp.com>
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
> tag_8021q definitions are all over the place. Some are exported to
> linux/dsa/8021q.h (visible by DSA core, taggers, switch drivers and
> everyone else), and some are in dsa_priv.h.
> 
> Move the structures that don't need external visibility into tag_8021q.c,
> and the ones which don't need the world or switch drivers to see them
> into tag_8021q.h.
> 
> We also have the tag_8021q.h inclusion from switch.c, which is basically
> the entire reason why tag_8021q.c was built into DSA in commit
> 8b6e638b4be2 ("net: dsa: build tag_8021q.c as part of DSA core").
> I still don't know how to better deal with that, so leave it alone.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

