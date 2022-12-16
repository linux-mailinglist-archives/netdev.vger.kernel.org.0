Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F4664EB32
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 13:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiLPMG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 07:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiLPMGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 07:06:55 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CC42AE1D
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 04:06:52 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id m18so5672953eji.5
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 04:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YWZVSvottKMXFDxmqgre9mHPJCeheRtjM/n2uG4P79Y=;
        b=yqTaLIIYTUsAgK0LLmzI9Z6la5/XEVkxSAWW9qHBS7gBkq0LQ22l8xEmip9apmVRa6
         HfbuMZ1PeOXcfnhR5sHhF4u0ip/+eIV+72PQH807tuiBkC8LU0eBxMNK0A0JFwU/Qcom
         wVAItcBPnLHZTe8L43EbV8nSxrSV5icXQpWEC1/GD+DPfgGIqghEmbAG5AlvWLM5OE/u
         HzLMFXjkhrxY5kLVerupcDJuolzVRspHhR52zFkICoYI9QAm122wry+vRLU/1oTjIyTI
         62gzXvK9Z+7LoSWLMaL8C/jap5+XJmFAtFvBVQR+f6srECMESE1LRX2zvCRlc2yTxTjE
         KbEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YWZVSvottKMXFDxmqgre9mHPJCeheRtjM/n2uG4P79Y=;
        b=1RYcRsZgLf//S+Fl1PpKwF9GcK11zWGQo4qitwRmZA5WUym4L5c8/S0+LlJFkFyZGJ
         phQJRmdR3BOqQ5Yf2dz+SILofviUChVETET7EaVMHh4n3eY9s+i60/wXr8uI5Ut6poHf
         YyA9rZ4yoPwfZnOPBAXXgA27M52RRnoWe339ttL2vztu5VtPRJ0XhgTVMIAM/wKFD9Ot
         TE5M24A2h5+155JMCFaXbofMxbLAOIkzpWjHCo6IGkXJBEBFxt/qZuQe6O98m83vsSWV
         Y5JkoE/mNPjjaKdfGxd5AVMpZaVLLmA7Jo3eWZg0cN948d4Wv8hFc6vl7tjUxsW9HYnD
         yrvQ==
X-Gm-Message-State: ANoB5pnx4ALb8eY/g8F12qaLo+FGxholCFWBNMMghNbMd16EiouXNu1H
        d0lwB/DLrsNOyNT5HsNUm9Lsmj9FA9rgdKJC2DM=
X-Google-Smtp-Source: AA0mqf6FkqQuJHdtWW797WH9YKcqTyc1hAEasSPbdpe4+CssSWXKxX0tKIYpS3ByqTycoqrJEhlxAA==
X-Received: by 2002:a17:907:a782:b0:7c1:6e82:35fc with SMTP id vx2-20020a170907a78200b007c16e8235fcmr31379831ejc.40.1671192411346;
        Fri, 16 Dec 2022 04:06:51 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id v12-20020a1709064e8c00b007c0f90a9cc5sm782085eju.105.2022.12.16.04.06.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 04:06:51 -0800 (PST)
Message-ID: <b936f4a1-8fa6-0736-fc28-e8799a6da107@blackwall.org>
Date:   Fri, 16 Dec 2022 14:06:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH iproute2-next 6/6] bridge: mdb: Add replace support
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@nvidia.com
References: <20221215175230.1907938-1-idosch@nvidia.com>
 <20221215175230.1907938-7-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221215175230.1907938-7-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/12/2022 19:52, Ido Schimmel wrote:
> Allow user space to replace MDB port group entries by specifying the
> 'NLM_F_REPLACE' flag in the netlink message header.
> 
> Examples:
> 
>  # bridge mdb replace dev br0 port dummy10 grp 239.1.1.1 permanent source_list 192.0.2.1,192.0.2.2 filter_mode include
>  # bridge -d -s mdb show
>  dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.2 permanent filter_mode include proto static     0.00
>  dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.1 permanent filter_mode include proto static     0.00
>  dev br0 port dummy10 grp 239.1.1.1 permanent filter_mode include source_list 192.0.2.2/0.00,192.0.2.1/0.00 proto static     0.00
> 
>  # bridge mdb replace dev br0 port dummy10 grp 239.1.1.1 permanent source_list 192.0.2.1,192.0.2.3 filter_mode exclude proto zebra
>  # bridge -d -s mdb show
>  dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.3 permanent filter_mode include proto zebra  blocked    0.00
>  dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.1 permanent filter_mode include proto zebra  blocked    0.00
>  dev br0 port dummy10 grp 239.1.1.1 permanent filter_mode exclude source_list 192.0.2.3/0.00,192.0.2.1/0.00 proto zebra     0.00
> 
>  # bridge mdb replace dev br0 port dummy10 grp 239.1.1.1 temp source_list 192.0.2.4,192.0.2.3 filter_mode include proto bgp
>  # bridge -d -s mdb show
>  dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.4 temp filter_mode include proto bgp     0.00
>  dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.3 temp filter_mode include proto bgp     0.00
>  dev br0 port dummy10 grp 239.1.1.1 temp filter_mode include source_list 192.0.2.4/259.44,192.0.2.3/259.44 proto bgp     0.00
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  bridge/mdb.c      |  4 +++-
>  man/man8/bridge.8 | 13 ++++++++++---
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


