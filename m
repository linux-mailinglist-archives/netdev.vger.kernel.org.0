Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E940C52B907
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 13:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbiERLoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 07:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235741AbiERLoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 07:44:02 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A921796C3
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 04:44:01 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id bq30so3156637lfb.3
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 04:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VUs/qiRUXkX7u01sNNHH5nG6z38UxD4eg1cpL+kl3IY=;
        b=NL6N69NjUsnYgCBbK2CT7VS2GcLCktUlueSaZScu8TI9QduQ1VobJVGHSjM38FUuyN
         svg/5Jvr9RM/i54uw89DK5BdJVd3k7bYxS4fKpNGfgzeHiu2IBBMc4/H2B5p7LBXQW/l
         fSjbKPI6oR+Lutlwlrodtc0ejMPjEb4ELg7Sz0HPnCX9/dhG01EVYeV0/H3crVaUdqjh
         f0moCm64ZwSM9COqEFhdyLvS3Zi7jVSzlzlVPD2xqhhr3zNskJFro2paspiFWn9X25ON
         hO7Yvk2ts2a+8I06rySiQ2nPfQJEhwCZFLB2l69ERfJkczOkCp96X75BOrrnejjQ5OR+
         ExYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VUs/qiRUXkX7u01sNNHH5nG6z38UxD4eg1cpL+kl3IY=;
        b=R3lIVsrga2D5gE6GdGPgiDSAiMLwAjfBOaNRtc/U8wgc9zHuWCo5rFgSiBbsZLtQEZ
         XUDzr1KF11UXZjS6LMNI9zGQh8xP9Cxm1DgwYYQcg3XgP07ISfZrHAyXKqzehvfqSy71
         tdKp9lysBC44rjyG5VbKKzX+SnCPi1lJDJfoBKLKph58FNwkLUsO3NKBbgqqM6I0cSCB
         URUBW54lp2sUjRgt2OAG+WMPtlMNVzB6juZooZzdo2qMAFCvAnD8zS/VJ40AZibne3jO
         dfbsMWOpK6pW1tRf2yohhXtKU3+qpYB1AKaS6QXuYU7ppUv8RYTMdFnVpryhCyWDeYso
         znsA==
X-Gm-Message-State: AOAM530bBVyOl8APsd24LmemmvQfePzb9meoi6+AHMHs4h1qellXIqSy
        n0bJ15ruzIjynCgcxTCVg55a4Q==
X-Google-Smtp-Source: ABdhPJwlewLBeyGbH+jR6wIjAntDY4XD70LvPuqQZXZ1HYzVHqv2jEV/UgO2M8DbS0xmSByoyJGxsg==
X-Received: by 2002:a05:6512:3f94:b0:474:68e:46c3 with SMTP id x20-20020a0565123f9400b00474068e46c3mr20754082lfa.431.1652874240015;
        Wed, 18 May 2022 04:44:00 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id h18-20020a05651211d200b0047255d211eesm181695lfr.285.2022.05.18.04.43.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 04:43:59 -0700 (PDT)
Message-ID: <efb99320-b0d5-11fc-cd37-2c2f1ca90ece@linaro.org>
Date:   Wed, 18 May 2022 13:43:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net v2] NFC: hci: fix sleep in atomic context bugs in
 nfc_hci_hcp_message_tx
Content-Language: en-US
To:     duoming@zju.edu.cn
Cc:     linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        netdev@vger.kernel.org
References: <20220517105526.114421-1-duoming@zju.edu.cn>
 <2ce7a871-3e55-ae50-955c-bf04a443aba3@linaro.org>
 <71c24f38.1a1f4.180d29ff1fd.Coremail.duoming@zju.edu.cn>
 <68ccef70-ef30-8f53-6ec5-17ce5815089c@linaro.org>
 <454a29ba.1b9b1.180d576985b.Coremail.duoming@zju.edu.cn>
 <bb566eb7-c571-9a51-af51-78e36412fbfc@linaro.org>
 <670b87a9.1d1aa.180d6d8952e.Coremail.duoming@zju.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <670b87a9.1d1aa.180d6d8952e.Coremail.duoming@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/05/2022 13:05, duoming@zju.edu.cn wrote:
> Hello,
> 
> 
>  struct st21nfca_hci_info {
> 
> If you think this solution is ok, I will send "PATCH v3".

More or less, send entire patch, so we'll see.

> 
> Best regards,
> Duoming Zhou


Best regards,
Krzysztof
