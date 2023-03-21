Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725126C390C
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 19:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjCUSTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 14:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjCUSTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 14:19:44 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EC74108A;
        Tue, 21 Mar 2023 11:19:36 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id q102so1847989pjq.3;
        Tue, 21 Mar 2023 11:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679422776;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pu282+aQJwtC+GAeyAgjzP398aBlyHrNiFe0GOpAoEA=;
        b=OWSDnUPCsvxXPKl+q+lS1G24fNXoV4TgUw5Qo9RKtyJCGGh9HpL+9XjfUPUMlljUGu
         oNXABXk4MblrHt4YylCNhHFsGCutzpBu+HOUhIuJ3sOHooJ8OgEVC6W6BB7pW03iuJ2D
         Pu8jkVezJzJwfVQBYhAWWL4fSA3NLzVs7ZSOYxSH/QECpAsFzGixI+WUScjWs8vMqjFN
         Lto6KI+hCB36wg7+ic2yMn7lUDC5DlccM3s1EglsrU9Zz1hQGTQ7j321qIZS+Q37U8eE
         cV6R8H6EFVeiSyM/TMNBbsl8PGAdJ1bUeMiQZy9r97hWlNNij+LfN4klZr05P9n4ygqr
         notw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679422776;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pu282+aQJwtC+GAeyAgjzP398aBlyHrNiFe0GOpAoEA=;
        b=hT8QBiEjwWkfA16xNbvqRd62VBu+nFSsclA/tx/y1jkxEAM+20MDrusA3bKSnCmpOQ
         iDa8ThinyKqB27Luvq36s7nBCu0YmqlJC7NH285mdDIQSZf811u8vnGI0I6UcneZYlrq
         EHblqd+ipls5FW44e92Tm9+uwz7euSNojzc3WsP37+lnWGXqcTjH8N39CYEOfHoWbclN
         wisxo6UuPvMUUCB5auHAjd/dZLWd1YighCS+VSceUqFyl03pF4eor262zNnRhhDn4PMM
         WPSHhuYscZTG0aJGmAXXb6l4PkXDAEM1Zb3iXkpRsB9VCEfIoGgiExgC1JuFjF/sYV/W
         sPrA==
X-Gm-Message-State: AO0yUKWSG0SmG+Sn6sHmq5JWGi6b4hw1Ec19jzFUh69VNexQAkEH17bg
        afHVS8xiRcKBPMxWS51owrHjFk97RUw=
X-Google-Smtp-Source: AK7set9BG9OjV49kzNpQ1wtKsUCpWqgNAO/QtZKAx9JmpNFQp1FpuDwENCKCrBKzdA2qI5yqCPdbHQ==
X-Received: by 2002:a17:90b:3ece:b0:229:f4f3:e904 with SMTP id rm14-20020a17090b3ece00b00229f4f3e904mr720928pjb.11.1679422776042;
        Tue, 21 Mar 2023 11:19:36 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pc2-20020a17090b3b8200b00229b00cc8desm3638866pjb.0.2023.03.21.11.19.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 11:19:35 -0700 (PDT)
Message-ID: <7e6e6e3a-cad9-0b05-9fd3-2adc99f655a1@gmail.com>
Date:   Tue, 21 Mar 2023 11:19:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 3/4] net: dsa: b53: mmap: allow passing a chip ID
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230320155024.164523-1-noltari@gmail.com>
 <20230321173359.251778-1-noltari@gmail.com>
 <20230321173359.251778-4-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230321173359.251778-4-noltari@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/23 10:33, Álvaro Fernández Rojas wrote:
> BCM6318 and BCM63268 SoCs require a special handling for their RGMIIs, so we
> should be able to identify them as a special BCM63xx switch.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

