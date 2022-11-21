Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4DC632E13
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiKUUjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiKUUjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:39:03 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F6E2F01A
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:39:02 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id z17so8883348qki.11
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ppgkf/zR4kkQ/cd28/1uYM9a541iXD2ioAX+p5rouaw=;
        b=RBzGj+B/xaqhB92AAY41kZOZNuHsnPFKoNxBbX1pIw3OQyIgp/KCBZyXOfXobp8ZYG
         o1qs35czLElgCjK3xXRIjv/G/HHokgkm9hvkf14P9PMcpTFTyQ4xeTWB2eyjWMSFwFL9
         TusfnNH/SHbOd8v+loBAvot8Ev42TNIhLMvVrMwwAZFn7QR93KYxe5hJgdR6JIi9goZb
         4M9EjJg8wOzWgUtOiGi9RNDqUKhtzzJJf4h/IbkiQJ2th6g6mywfGsC6Y1VnsroJb2kg
         tN+Wm+4fRG3O66K/WlOHSNL7noKHTw8xZUYJa7fsalIqPJ4dzX1o3yKNDJOnjiFq5WFk
         KfPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ppgkf/zR4kkQ/cd28/1uYM9a541iXD2ioAX+p5rouaw=;
        b=O3Z2QJx824agYFC3Ta9mjDEQkAjLzus+D1az6b+TzYOFKy0ndM3J/IfBZ6DHqtmdpV
         iFBO6NtFzK2Vu4Lkir7JPpWxj65uLsvzBi7F3kH/yWHnK4g5H3CYLXPzU3rmdaFLBDRU
         aUH8yfdj6hRdnflvIkmBRWL8+4riOnTmZctq1J8KnqnRNjlMeB2EtHt/0clgqjFqvu8O
         QqFULou4e6MEyVgBt3wqWkNzo8LmSvuZ8VKPRfkCaQf1edSGvFsfgB1Cv6QWWEdvd2r8
         VEwuhjmKlDPV+Pwvvpp6Xr3ldZJPp36WPfjbg1zxBsL7teQZDloBcIEJmdH0DweUbi4i
         ghbw==
X-Gm-Message-State: ANoB5pkHeLAyRRQfkK/+lR3fhb3dQRQu+8UggfTOXrJFGE/xw09/5Gw4
        8GiDnCbe9BjGpkERiIRvJOo=
X-Google-Smtp-Source: AA0mqf5NqwRzqINCE4uY50WiF80JhJhmFqOXwZwy2wdHwSb859Tp8NZL0mepMrgZs/7UwgVb/L6H1w==
X-Received: by 2002:a37:b3c3:0:b0:6fb:db69:3d13 with SMTP id c186-20020a37b3c3000000b006fbdb693d13mr12839306qkf.38.1669063141358;
        Mon, 21 Nov 2022 12:39:01 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u3-20020a05620a0c4300b006e42a8e9f9bsm9138091qki.121.2022.11.21.12.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 12:39:00 -0800 (PST)
Message-ID: <39627770-bf79-305c-97e2-23f97876d07c@gmail.com>
Date:   Mon, 21 Nov 2022 12:38:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 17/17] net: dsa: kill off dsa_priv.h
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
 <20221121135555.1227271-18-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221121135555.1227271-18-vladimir.oltean@nxp.com>
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
> The last remnants in dsa_priv.h are a netlink-related definition for
> which we create a new header, and DSA_MAX_NUM_OFFLOADING_BRIDGES which
> is only used from dsa.c, so move it there.
> 
> Some inclusions need to be adjusted now that we no longer have headers
> included transitively from dsa_priv.h.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

