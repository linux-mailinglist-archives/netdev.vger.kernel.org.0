Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8A0F4FC130
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 17:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345915AbiDKPpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 11:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243187AbiDKPpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 11:45:17 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784B03AA5D
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 08:43:03 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso12445135wma.0
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 08:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=nmJolD/r0RRhBNoHIskQnq1/lLQ+zP29m6nleMrtNP0=;
        b=XfKwXGth5I7b7EQ2qcpwLIEAQOTKr1A79WIs1DTSvvWsuroXduYLpBrRwCw3vI7yex
         7sSj9eKrUXCyGd0qA4eRJT4sG7XdzpyGAQY0obXVQR00e6VkDHCcyDlbMwEqEvZk0xG1
         oAy9+MqxreJxYwaMn50zWpM6rAksNnkAU8MOUPjqxMsCT2zSmpiwT7CPRUBTWrbMXb+A
         +twxaYBX7V4CXEZe3cgJbQL5SrSibaz9s7fBjjnp3HNPKPrihDhwEswHr7J6OdX6QpCR
         kFEQPmtSxUEymlPWzi5ou525gTh9XcjvHl4BoxQcQPpbVI25myJMzDgAgpcFpRgwiH3X
         w8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=nmJolD/r0RRhBNoHIskQnq1/lLQ+zP29m6nleMrtNP0=;
        b=BZB6HR8/2BcVhTCZXWoY3z6KaFNwT1XqBX1pMGg1/7Q8GWOlZ6pNZTHGw74qCKfEL3
         NGH1olDQJtwJl4CnNWiguNZY3/cgtFdvucsZR8rsmqHkCLGz5E+mzm4q8JbANWlmduCR
         p4EpteUuhVKZykWKZTNTXV4ZLnRyH3CThoX4f56gk8JDieVJYT9tO5Lhw9mBjqQIzmhM
         WqDOOItz36CdotJdAJWI0vP0IZv0q5f0tS2wFwtEq8VLyd/42VPdiWYJmM4aQDmen8E2
         7B6ksaQnquwvvK8aFisFWhLEUjUBhatLVHXQRxX6Bzt6cSApdnmn7HcC9ztcehbJwPRR
         gqfQ==
X-Gm-Message-State: AOAM533ZLtZZZv2yGYgwrF1MVmLxxTO9FSubP14a0NQjyIE6xCMfnFhw
        9RImMn8h93kqaq6Adw+b/61/kTHXAIpjCqLD
X-Google-Smtp-Source: ABdhPJwfDJblOlR0Dv8JWeJYeH+JcXX/4Q7sgY/WTcoHlb1Vme99hBw9351P+K0ANdMpvZx25Q8wkQ==
X-Received: by 2002:a1c:e911:0:b0:38e:6c5d:40e5 with SMTP id q17-20020a1ce911000000b0038e6c5d40e5mr29728858wmc.116.1649691782098;
        Mon, 11 Apr 2022 08:43:02 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:4d92:8b8b:5889:ee2f? ([2a01:e0a:b41:c160:4d92:8b8b:5889:ee2f])
        by smtp.gmail.com with ESMTPSA id v1-20020adf9e41000000b00205c3d212easm27761744wre.51.2022.04.11.08.43.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 08:43:01 -0700 (PDT)
Message-ID: <cb3e862f-ad39-d739-d594-a5634c29cdb3@6wind.com>
Date:   Mon, 11 Apr 2022 17:43:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: What is the purpose of dev->gflags?
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220408183045.wpyx7tqcgcimfudu@skbuf>
 <20220408115054.7471233b@kernel.org> <20220408191757.dllq7ztaefdyb4i6@skbuf>
 <797f525b-9b85-9f86-2927-6dfb34e61c31@6wind.com>
 <20220411153334.lpzilb57wddxlzml@skbuf>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220411153334.lpzilb57wddxlzml@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 11/04/2022 à 17:33, Vladimir Oltean a écrit :
[snip]
> Would you agree that the __dev_set_allmulti() -> __dev_notify_flags()
> call path is dead code? If it is, is there any problem it should be
> addressing which it isn't, or can we just delete it?
I probably miss your point, why is it dead code?
