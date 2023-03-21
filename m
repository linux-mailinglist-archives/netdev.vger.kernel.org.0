Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15ED26C3783
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 17:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjCUQ6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 12:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjCUQ6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 12:58:53 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9374D403;
        Tue, 21 Mar 2023 09:58:51 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id x1so18658665qtr.7;
        Tue, 21 Mar 2023 09:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679417930;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8Kon1tQfMqQN9fG0YTibKYPhYBSJcMK1Kq92bszyZYM=;
        b=TIVWf0XsC/NPL9CaA3CU5KpXqg5w3mc7ehdAEuclsdunFCieHGcxK2IprAUNmMCQZk
         UdKST1b6ya75hFX8//KcSoshKrt8raXhJZ1KZibmOCY3ZW1AEzwiuTBJ+QMJLMphx7Ww
         ZzOX4frXJh2r+WNvapbUgJnJrwa+7fqc+HVSqTtGHexPsXw71wrOzStAnzsl9gAJcZtv
         eUwkRHdOVkMSg+l0kTRAOAttEI2YqkH1NGMX7yqM0q8eTzTXNhohSG3CjJIig244Ro+s
         xvLcznF9xI/OpTaKnHpbZMJQw3f+01WthDhzdopMhnfdt0K55yVK0/DcF9zS8tf0JqiN
         CoXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679417930;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Kon1tQfMqQN9fG0YTibKYPhYBSJcMK1Kq92bszyZYM=;
        b=Lx4RIXMLl7feEr0O3jRl/9m6abiHDnnVxSafQvvc9RV9t219x93vxg7gFdpa7WpEdK
         5P5fmuF59ZKOQoRqPfw9ZKVq7DWXMNwg3ZGXXM4d5St5yIHGQ1bW98Fn7vgItJgGdne8
         LwJt8WR8Sp0k2qQTMjn8gu7zDSYppB2HardOeN8HXJpD68TbDcSjquNm98lyoqImzKgT
         JpJS5qApAYoAYehxreOLds7RHzHXHmfO5sSg/gMprElf+/VJzTv79Qls2aNl8rj8EoZx
         QkLwA4aRg8e9k4zwcvdhn87IGAFymodP+56rgv2851cJUSvxWYKyoeV8v/TJtmwoqfiZ
         NO+w==
X-Gm-Message-State: AO0yUKVVLdn7fmSPla6eVAyUrHYXqJft7V79b/TgSK65eCG+C7FrJDtO
        cx82yh4gFjco53IlOaA9KTAFsd/dqhk=
X-Google-Smtp-Source: AK7set+TaD1I5w6Vc5+hOhcl1Tdpr0mIb/4Y4dI/8X1eoH2kRaVdeP4WYiORIm4ejce/n8fWk/LdaA==
X-Received: by 2002:a05:622a:651:b0:3dd:8b9f:1fe8 with SMTP id a17-20020a05622a065100b003dd8b9f1fe8mr813518qtb.68.1679417930059;
        Tue, 21 Mar 2023 09:58:50 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x24-20020ac87a98000000b003d5266b14cdsm8707326qtr.5.2023.03.21.09.58.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 09:58:49 -0700 (PDT)
Message-ID: <bbbb31b8-65f8-7220-b016-b5a137c5a1bd@gmail.com>
Date:   Tue, 21 Mar 2023 09:58:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next] sh_eth: remove open coded netif_running()
Content-Language: en-US
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <20230321065826.2044-1-wsa+renesas@sang-engineering.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230321065826.2044-1-wsa+renesas@sang-engineering.com>
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

On 3/20/23 23:58, Wolfram Sang wrote:
> It had a purpose back in the days, but today we have a handy helper.
> 
> Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

