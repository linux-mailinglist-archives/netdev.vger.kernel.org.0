Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A746B62C460
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238071AbiKPQ2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234659AbiKPQ1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:27:44 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6CC5C747;
        Wed, 16 Nov 2022 08:22:45 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so2794822pji.1;
        Wed, 16 Nov 2022 08:22:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6qpYuefz2vTkOlrRHnwjbS9oeADDuMH/tiE7OpjIFi8=;
        b=H4AlysemVxcncV5avjp921H7Rvcg1/nme3yea/AHFATMv90pHo+kCnfdQVfA0g+9FB
         2+4ntVkPQgQU3F1HzWfJ2RwabcpluUai5qDW5KOaNdFIkgY5I36er8/S9aWNvY3KIdzL
         Um9ezCQbUZAX0GvzqfU+dk1oQiAOKCcPX+feXJjo5NWN0ieozV4BjqHdLG5LMwaa5plb
         1S8dvnu15kpJITdxX6hYqEILqUdKGahItXwXHGHY7TnnMASwpw0EaREkUd7lvmkZpmIR
         8FjYzZaObE/A3si85MWmiXErlxaB0yfkOjBSEIjnTudPtUFtUM4CtA2qqVqIlq/2jfrg
         Y+/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6qpYuefz2vTkOlrRHnwjbS9oeADDuMH/tiE7OpjIFi8=;
        b=EmQkT+EIaZ9p+yNU9X2DbAxYXqyZtVFW76iR5KFPMlbFRgxJcbkZIOSV4woRGouo64
         /7waSXMfeZmiRNmZu7DN9DSH9+FlQzVmB9VnelXbSQIh0nGAZfuTl8rUEDSSMMV3b6CK
         KX/UMs3+nAZ81WNhBJyCk9Xt6sNvQ8b/aXs3JCHI9TbWGUaI+qXQJPFsTtFkHDjxwT8L
         scO+y6jsoCZiPMoLCt0a/fMY0uLACtoyeGXcas4wro9BjQ1Yj5VsYWEd1YclZu0fMgtN
         WwOOHZcR4qE5PAOi7nam6Q3KBeVNKRj4GgtlK2PESbNh2WgEn9L9xPnDDg1Ytgnofj8X
         DZKw==
X-Gm-Message-State: ANoB5plG1tWIA0nhd84h7L1hxfx9MeapNJEQ1XF2UHwvtjeWaFXdBD+4
        2c9+dVV+xarcODEba/GVJC0=
X-Google-Smtp-Source: AA0mqf4687xglPEMIIWBR7x4Yf1eST+P65kCNJGoWeS4D2eg2V9bxm25V4u7bpzeh2/d0tpCEh4HLg==
X-Received: by 2002:a17:90a:df06:b0:212:d299:4758 with SMTP id gp6-20020a17090adf0600b00212d2994758mr4466625pjb.120.1668615764806;
        Wed, 16 Nov 2022 08:22:44 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:9801:5907:5eb0:dd5f? ([2600:8802:b00:4a48:9801:5907:5eb0:dd5f])
        by smtp.gmail.com with ESMTPSA id e12-20020a170902b78c00b00186a437f4d7sm1767319pls.147.2022.11.16.08.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 08:22:44 -0800 (PST)
Message-ID: <a850ce56-376f-2c9a-6a6f-5ae5cd5cca4c@gmail.com>
Date:   Wed, 16 Nov 2022 08:22:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3 1/3] net: dsa: refactor name assignment for user ports
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221115074356.998747-1-linux@rasmusvillemoes.dk>
 <20221116105205.1127843-1-linux@rasmusvillemoes.dk>
 <20221116105205.1127843-2-linux@rasmusvillemoes.dk>
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221116105205.1127843-2-linux@rasmusvillemoes.dk>
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



On 11/16/2022 2:52 AM, Rasmus Villemoes wrote:
> The following two patches each have a (small) chance of causing
> regressions for userspace and will in that case of course need to be
> reverted.
> 
> In order to prepare for that and make those two patches independent
> and individually revertable, refactor the code which sets the names
> for user ports by moving the "fall back to eth%d if no label is given
> in device tree" to dsa_slave_create().
> 
> No functional change (at least none intended).
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Reviewed-by: Florian Fainelli <f.faineli@gmail.com>
-- 
Florian
