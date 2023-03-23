Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29BA6C6DA3
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjCWQcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbjCWQcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:32:25 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421EE36446;
        Thu, 23 Mar 2023 09:31:51 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id a5so5610254qto.6;
        Thu, 23 Mar 2023 09:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679589110;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=od8eAmGdy82UFPOdrXfyOziu0tAVi4GOrxE4cDu8QzM=;
        b=fi9DKr27lSjVIMnlnExJmx0Vk9jXiMKQckNseSSCjeX8BXmui+3EnfqBZWCvE5OW2y
         gRvujTNJgdMFgBpXzV8GAzXCoD2k/dX5+c/z65E65wYGm4uXiPpEgApZbGgULar2ljuY
         ck/IjDKkG8i+g3ylY/M/uCzzoevNKnhgeR8wI9otXGqhJVx60CazJ93h7NiHAJxsspQq
         aUrsuEEzWNp/Xh0WEkfj2C4p3PhOF6In9sjV3gtqhbL3huqfIUKyCDOFgj8rfx8ymVoF
         EYRoZuoIMgaEeUk0zAzj/jHYGNXAv1AMcR7VugbNCvR+VeqoFCdHbOw6vEtT94LEBqvu
         o3lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679589110;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=od8eAmGdy82UFPOdrXfyOziu0tAVi4GOrxE4cDu8QzM=;
        b=joFV3b5m2z/PMQXJN6Gd+Zbu7L5j3qDUr6fKEFlqaMhx59zDNDoEcM6iAK+dKWeSHn
         ZiodKRbljs/IUER9MaNzvXkNFiC5qj+rNqfmj8pMZgiN5dIOgbCs9cMc1XQ34O5l2Qsl
         b04VOLu4n7fo9pPAAyBLqGGGitUJs8AN+ewtdL5VcJCAvH3iFBdBGISLaa//BvNcbB3Y
         WGImyBTBRB8LtI77LMRzQJmPbIFj+paZGHGq15vnN5lJ6y+eAzRykFiuq4e97UimIiIE
         Kw8r40gAurS/39XN1HkJTEmbBiNGkv15jusL4f0ZtE5OXOUsJk4HdzXZQbSyEx3NS42J
         RXSw==
X-Gm-Message-State: AO0yUKUHsAlD4Bm9togZixaAIugsW1bJ9bMdMkLcSjUkr/SFwxhwqD5l
        B3vBlWCi3hXfEnHKjtDxpG0=
X-Google-Smtp-Source: AK7set+REnXuBI+6R7/XCKXB1d7T5kqQRXibAMIT7gft8NmEwU23CTzWwcGtOrqIeYzXlCZl4bWPXQ==
X-Received: by 2002:a05:622a:651:b0:3d4:8ce9:cef7 with SMTP id a17-20020a05622a065100b003d48ce9cef7mr13345485qtb.8.1679589110145;
        Thu, 23 Mar 2023 09:31:50 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i22-20020ac860d6000000b003dd8ad765dcsm7194096qtm.76.2023.03.23.09.31.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 09:31:49 -0700 (PDT)
Message-ID: <233e2990-699d-465d-9a51-2eb53d0db8ed@gmail.com>
Date:   Thu, 23 Mar 2023 09:31:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 3/9] net: dpaa: avoid one skb_reset_mac_header()
 in dpaa_enable_tx_csum()
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
 <20230322233823.1806736-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230322233823.1806736-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/23 16:38, Vladimir Oltean wrote:
> It appears that dpaa_enable_tx_csum() only calls skb_reset_mac_header()
> to get to the VLAN header using skb_mac_header().
> 
> We can use skb_vlan_eth_hdr() to get to the VLAN header based on
> skb->data directly. This avoids spending a few cycles to set
> skb->mac_header.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

