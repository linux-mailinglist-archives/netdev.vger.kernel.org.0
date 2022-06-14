Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40AB54B584
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 18:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356264AbiFNQMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 12:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234800AbiFNQMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 12:12:18 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E3D43ECD;
        Tue, 14 Jun 2022 09:12:17 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id u2so8988738pfc.2;
        Tue, 14 Jun 2022 09:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=/SLmhszGSTZ0vVz5kkFX0OqQLkqAokJHIF8TSGcN0f8=;
        b=ofTQs7qoE5gXNwEp0zVQ9p1G1ZiVQpVTZKqnErTjYV5EXYo7mYnne0By54Lcj6pxe4
         48M+pKBCFr4dKnDvDks1WRfVUKiBCU24ggjKZuCtA7EADw2FkdAMGnEmmpLWO92RnNwR
         YMvilX9JoXkRjRJecjxVnUOY+rJBMZObXIYt9uQYETWWl2M7gWqP4OAZiEG/s5c5JZWZ
         GgoMOjJig9mbMjoaoAVgDBo7OAkdyiiA9ptdZFCuVEN/JYPbzj7zt29UcaSzGvrXLqlI
         VYlYV46lMf0dWGdhsMeiyZDOlgWV488HqlPKKH0fVt1aOICaxTlcE5W+Nf4UTLpcSJdZ
         hW4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/SLmhszGSTZ0vVz5kkFX0OqQLkqAokJHIF8TSGcN0f8=;
        b=t9fQDeqbYPWjvwYcGTugdTy+6DQPw9zWEZMduYS8AEyR+Cfgt12So60Yz3H++N4bG1
         i9DZ4caJYAwB4Ke35dtGiBpydTJKcNeaSDh+LjrJYUpecr0/OiVYQpvOpInNc3pgySJ6
         DRqUbyr7Pm/2je/TbGGxCWoW+UZlR+dfEfCUOGrRf4imKrBZhs5n1FhgQSkYIDR5Al93
         7e/Vw3V1/vMW5AtyuJnChREVO8iTBVrxPBxfI6ubNQ2QV3qhL9xmrLnuM/SDl+vbXIEO
         nQ0pJN6GiH7ZH0chuA6KIoAlg8bU6yX0pv80dLsgI0eXPYJpV2mcq2vaItLbZD7tfWsP
         +mtw==
X-Gm-Message-State: AJIora8tL/AaEWdQGiEjE5X6KEnH49pnJ184+VANtGVo5tczqYQheg8u
        piVzbdyfOwpQq9wur5UkNe8=
X-Google-Smtp-Source: AGRyM1vzBuNrJwkITjgedbtiLDEw9WkboTP/IN8pfrVNstzsOL9V0OC4QeLf2z2zvKewcBwFphKVDQ==
X-Received: by 2002:a65:41ca:0:b0:408:aa25:5026 with SMTP id b10-20020a6541ca000000b00408aa255026mr2735075pgq.96.1655223136880;
        Tue, 14 Jun 2022 09:12:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ep11-20020a17090ae64b00b001eab4d6de9esm3151058pjb.3.2022.06.14.09.12.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 09:12:16 -0700 (PDT)
Message-ID: <fd6fa416-ba17-e0fe-c89c-0abcc6c3fd44@gmail.com>
Date:   Tue, 14 Jun 2022 09:12:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] bcm63xx_enet: reuse skbuff_head
Content-Language: en-US
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>, davem@davemloft.com,
        edumazet@google.com, kuba@kernel.org, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220614021009.696-1-liew.s.piaw@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220614021009.696-1-liew.s.piaw@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/13/22 19:10, Sieng Piaw Liew wrote:
> napi_build_skb() reuses NAPI skbuff_head cache in order to save some
> cycles on freeing/allocating skbuff_heads on every new Rx or completed
> Tx.
> Use napi_consume_skb() to feed the cache with skbuff_heads of completed
> Tx so it's never empty.
> 
> Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
