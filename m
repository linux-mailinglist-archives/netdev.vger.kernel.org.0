Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CD763F984
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 22:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiLAVBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 16:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiLAVBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 16:01:40 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E4CB392B;
        Thu,  1 Dec 2022 13:01:39 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id q12so3022832pfn.10;
        Thu, 01 Dec 2022 13:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NawtfWFXHwSrggFzzLM94Nh6iiNoXeMVzyhAqq9RDaU=;
        b=FD5oNMtEVVue/4UNbnujBgtXecxjlObE4/5IVTQN8NSc9Nla35Win3RmCKR+K6F+j0
         eebXxxb9ewr0ju4AhQFRop3OLVVbrR2XCKXO/J+NPXuD4yMeQ+qK6pKgAwqN14Kjbp2I
         4ZUTueheJdRBWhM9ngynGFgjiaM4u9LJTolHD6ybF7h9sOpUcIb4Lag3qZnc0FJZswY/
         oA3OLiYrpZKUSYYBODJmlwZbGn88TQWMD2aysf7y552oL4hpNlXnjIiLWUNFOSAnjtIs
         TV/KmZ3a6IKVD53XPaRUwwYMjz3HAKnvHwo6RWk6AkDKcir7aCygjpHS3L4I13w67l0h
         NJ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NawtfWFXHwSrggFzzLM94Nh6iiNoXeMVzyhAqq9RDaU=;
        b=En2Lpn6m8iQf0X5S6vidyaR62FigrbrLgqoSCtEGF68s2e+uryD/EZZ0rNRIlqQcRp
         hZ1qbgF3nqGZUWPLihbXR4jEaKNSY+1uUY2ZhES8BKGSpiYQDXeinQLUahhsOMtgXg/O
         UBO1/oMY+jfY2icobcF+6C4nQw8kZsc00ZcOu4gydIZmmSKIb9VoXeaDom8yzzObhJ1o
         E8BP0J+cPz/5uJj5jS6d8OEqApmMjPQkQkO8A4JPgWUv2xNuS0+z7RL2seyk/k0sfb/q
         NFw20VOWWrLqgC2r1/gxTf0oH5dYB9nsSppI8zMwTVLNFpJKEUzGc0ZFGwTLVLDp+yzm
         7ojA==
X-Gm-Message-State: ANoB5pl1OG+ohrhdkc4tY8/MrpzSRY0YERmUq8oMu5mYWYA+WK74lRTS
        LgBwhPF2oZQh0+T5QMePIwGpaJ/HSPSPqw==
X-Google-Smtp-Source: AA0mqf43Go4yIh6ZRKN8GpJ0WgyR53Mt/7FKSZRFAWHkltlMFjv/jhplawt3mHHhBJxdL1jZyh+aKg==
X-Received: by 2002:a65:6908:0:b0:477:ae2c:48bb with SMTP id s8-20020a656908000000b00477ae2c48bbmr39597472pgq.525.1669928499323;
        Thu, 01 Dec 2022 13:01:39 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:edbb:db52:d3ff:52f? ([2600:8802:b00:4a48:edbb:db52:d3ff:52f])
        by smtp.gmail.com with ESMTPSA id px13-20020a17090b270d00b00218fb3bec27sm3410144pjb.56.2022.12.01.13.01.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 13:01:38 -0800 (PST)
Message-ID: <7e576ee8-b449-9c01-3365-53b04ac263b9@gmail.com>
Date:   Thu, 1 Dec 2022 13:01:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3 2/3] net: dsa: hellcreek: Check return value
Content-Language: en-US
To:     Artem Chernyshev <artem.chernyshev@red-soft.ru>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
References: <20221201140032.26746-1-artem.chernyshev@red-soft.ru>
 <20221201140032.26746-2-artem.chernyshev@red-soft.ru>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221201140032.26746-2-artem.chernyshev@red-soft.ru>
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



On 12/1/2022 6:00 AM, Artem Chernyshev wrote:
> Return NULL if we got unexpected value from skb_trim_rcsum()
> in hellcreek_rcv()
> 
> Fixes: 01ef09caad66 ("net: dsa: Add tag handling for Hirschmann Hellcreek switches")
> Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
