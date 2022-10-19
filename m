Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA416052B3
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 00:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiJSWA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 18:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJSWAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 18:00:55 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEC51ACA8D;
        Wed, 19 Oct 2022 15:00:54 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id o2so11663371qkk.10;
        Wed, 19 Oct 2022 15:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eg6xj9LjsWy3yFCM+N+a3W4QVyV0xbmzesPJopiuZZo=;
        b=M17rqGpqCPWdVtujteLrsyP7RVaurdgTnC3CJ6BdkM0I2gELMFyWB9Ai7bpMd9mZ5u
         HpbVR/Yco3bLZD0Evl1HbgzuMemAQYs+X2cRdQyAxlAF6taJRu4aoueRbLLG7FY5fG5A
         yLZIvKRQWXE6KPWt3E0QLel7p1SNFfByMwaTXRoiX/ldPd/bbDvTXBiWkLjyqmQtyuk7
         g5oGSkasOTkTNjh/Hsze7s/mLbqGpjdcRNf9ryGwtbiywGMlzGx9fe0G/L+x8hBP+tnD
         pU0XgMoLmg1lS9fqYssCA+d0OeyB/oSpnSCwoyz5TKNtpU3EtoqLwMMM1BiZ0e1eOCTv
         du5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eg6xj9LjsWy3yFCM+N+a3W4QVyV0xbmzesPJopiuZZo=;
        b=4KdZ2JwEIVnffwwvwMSs/qzRdoLTdOwPFeMlDrohX8U0g0+HK0hlVoBMapsxI9LGjJ
         WRTZNENy802BO7l8WpOexqYhTh65r+JB08BqLb0FneBxuNP0z4IRvvEk2stYIi72ZR+Z
         T5fe+NhawdkQ7buPrxYBf4niFW/ofFD1Aks8eZlA0oJFvXT0Sk3J28fcBFdBrhahWpqQ
         G+0cZZ1pIHaUifJJIXGxlIN5iusk9FNxeXSz4nt/Ce7MnSHvTgoFz0rTxv2PlhMSthpt
         55vSncN0104oaYmuPB3Ir6lrVI771WphHyTlgil7OMXKkXfIdwTuOACJly6r/XhLlK6D
         D+bw==
X-Gm-Message-State: ACrzQf3YgOku5XIDXBI4OVzSd0t1EQX/rwmcMiv+CGa7G0Et5ym8Tol6
        OsCRoDcxyK2se2pv3o6ovqI6kFKeqLdAPA==
X-Google-Smtp-Source: AMsMyM5K0DkgXg55cUg91mfZF2vpz5uFOpzqBkw8uuSVIVOJim+SYI70meOWnmAS0rUKghrO1515gw==
X-Received: by 2002:a05:620a:1fa:b0:6ee:8d8e:4f5 with SMTP id x26-20020a05620a01fa00b006ee8d8e04f5mr7461593qkn.564.1666216853288;
        Wed, 19 Oct 2022 15:00:53 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c1-20020ac87d81000000b0039a8b075248sm5004067qtd.14.2022.10.19.15.00.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 15:00:52 -0700 (PDT)
Message-ID: <69d84e99-0543-b8f4-5ba5-4144075b53db@gmail.com>
Date:   Wed, 19 Oct 2022 15:00:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net-next v2] net: bcmgenet: add RX_CLS_LOC_ANY support
Content-Language: en-US
To:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221019215123.316997-1-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221019215123.316997-1-opendmb@gmail.com>
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

On 10/19/22 14:51, Doug Berger wrote:
> If a matching flow spec exists its current location is as good
> as ANY. If not add the new flow spec at the first available
> location.
> 
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

