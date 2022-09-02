Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB435AB595
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 17:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237049AbiIBPqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 11:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237055AbiIBPq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 11:46:29 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7F93206E
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 08:35:06 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id h21so1741052qta.3
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 08:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=+HutdPYTJ4HN6pWAUnPzH0oz5jqWiDmwQjhQwMjOZGo=;
        b=jQIKZOtnykTdd8wrNVPb2BCdk0Kc8+gd5fGcEgcvKknOdY/xylATbT+Fa7LANFamWP
         YKsHxs3vgyBL4W9f5IR36yEzNRW0KUlo3KHS+wUeZ7IEWWL/y6S1eijmMu5F9bsoiGV+
         E34nJ4CxRG0XfQkPiC+Lf4iZg6vZySRaj8QHo8kyS03B0o7NAVEeAC4Moyvb4cZq0/t0
         Xg6cA0yaDVNKR4jIY1mhbKYvbnA5ZOfk5EhP2bCPZLDBx4Z5DNK4Bg5b+MZ7ekA27rIE
         wLEpgB3NDTqEjRt5w5SGRkhICNHXfX9WanTsdewqn+j1CWkQr3mLmRmPdSD/zaehNwyl
         7EZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=+HutdPYTJ4HN6pWAUnPzH0oz5jqWiDmwQjhQwMjOZGo=;
        b=UeKsXu3wO+VqbP9G+wuK4poRZhuqoDiQjj2Y99JXieZMd0NPPAdNUwo30Kr4jfadkK
         GIQacCTPPJeIvX1aCKhHHzr7ZK0wBhzJNPSJXaWM6gPSRNA8JPlpkga19wuggIQLzqjL
         L2E0FH9aRXWg9jFpAwMWmgDsdDeS8QV4sH9zQoNLPLEQGYVfKqizmMwuksCYWX+ubazT
         lF+ECd8DODZNXnwb2xAG6CHxBroeIVzsr75RCJEA2O9nMRZWnzf6xHW1ZgqZzCF4T1Ql
         kkF06Ly7xjYTzVt1PnF2Bmvhh5iWX+maEcu0wywFaXeden85qC5RADMjEA8YlmGEbpEj
         +PSg==
X-Gm-Message-State: ACgBeo0DnIbj17Yvfqf7UyGDE4hR53FEy8jvzCQSdVPkWWGCsurjDeXl
        NJOfPSpfClSTVrcIR53OV90=
X-Google-Smtp-Source: AA6agR4FrdCbjBnrk0et/fRyfzu9cwY/RduKIG0FqciZ/5dYgdD2hS0A5qF4zsv/x9Ha6TaymRrGnA==
X-Received: by 2002:a05:622a:1a25:b0:342:f78b:2178 with SMTP id f37-20020a05622a1a2500b00342f78b2178mr29505165qtb.308.1662132905419;
        Fri, 02 Sep 2022 08:35:05 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id t32-20020a05622a182000b0033aac3da27dsm1222026qtc.19.2022.09.02.08.35.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 08:35:04 -0700 (PDT)
Message-ID: <794a683b-5885-659a-5b60-23d7ca6cc5a4@gmail.com>
Date:   Fri, 2 Sep 2022 08:35:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] net: broadcom: Fix return type for implementation of
Content-Language: en-US
To:     GUO Zihua <guozihua@huawei.com>, netdev@vger.kernel.org
Cc:     rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com
References: <20220902075407.52358-1-guozihua@huawei.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220902075407.52358-1-guozihua@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/2/2022 12:54 AM, GUO Zihua wrote:
> Since Linux now supports CFI, it will be a good idea to fix mismatched
> return type for implementation of hooks. Otherwise this might get
> cought out by CFI and cause a panic.
> 
> bcm4908_enet_start_xmit() would return either NETDEV_TX_BUSY or
> NETDEV_TX_OK, so change the return type to netdev_tx_t directly.
> 
> Signed-off-by: GUO Zihua <guozihua@huawei.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
