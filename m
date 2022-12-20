Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B03651E8A
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 11:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbiLTKNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 05:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbiLTKNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 05:13:16 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849B26388
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 02:13:15 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id d20so16859790edn.0
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 02:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6UrO2j9DEey1G8UqydjmxQqMxVbqAZzAn1bK1fPzhSc=;
        b=Ce84Cz9ZMLrEN2Gk2uhhVVozKt2Ab9/SVRJooyCg87u9QWuaXj2DzyRfdtJPOtJ/y1
         caxj6AxhZeVQV21Mz7mN99Oe9sUOteH83ZZBnEC1zGQIS+y56hR0g9LEc4yKwfcI876m
         8BL/xL0n1Zkpxa4xIK8ntmNbuGmbMqXb6DMKHmlGAeEQ07STXlZkyerrchrhlcAXsq5O
         fEuxO7r57G7VHe8XV15zLqyUdmuh4l/DQIhRor++mvff2ByfO+/2rKHymzbFOkLs2/RX
         OyoVx1HDQm1yNO0rfnMdz7pIKj106xQFQo/JrlKIe1Ae9oFkDn+G/SislAwKHyP3092p
         Ssow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6UrO2j9DEey1G8UqydjmxQqMxVbqAZzAn1bK1fPzhSc=;
        b=Hnzzmj8x8Jy6xhi9fR5D5vnaojV3iWf5NHvYnNdB7cT6xv9V9GTs503/jwccrjK+P7
         5eeWRcKjPjI4naVJG2l59CAUspOt7AONFJxmzdMm4iI9G1eR+cjQfgg4O3l083H55LKW
         bGqJRV75lJmdI+tvaRxBzXReP0K6dBu0ZWg+Szupg+/dqIH1VCm63d8zeXaL8LXIhmmG
         E/oyP3EMFZNmkGydXFAL4g/lvDRTGsYPt2zYiiemIUQm20ztJBpFo9lBGMdwkJIGzszB
         iLLYdeOFX3Uu7q+wuZBcUn9r4N9yNsa42CnjpBtHhokm+aiJM6lMrDAbgQm5UN7eWuPp
         kJBA==
X-Gm-Message-State: ANoB5pnkcygDkQLpSerc62M9tPVxhRpTlEMjnFUMx2iAFwFgzPDJIZjE
        dmyJW/yXhe64WnYsBHdJHTFpeg==
X-Google-Smtp-Source: AA0mqf526bxkpxOkdLFI2Q1atb7+xe2frMnb8gtgGOtE6L+34AT1XQfmQutkBdDLaHHRiCaFlZSlhQ==
X-Received: by 2002:a05:6402:3641:b0:462:6d7d:ab09 with SMTP id em1-20020a056402364100b004626d7dab09mr41021775edb.38.1671531193850;
        Tue, 20 Dec 2022 02:13:13 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id n1-20020a05640206c100b0046150ee13besm5360318edy.65.2022.12.20.02.13.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 02:13:13 -0800 (PST)
Message-ID: <05d630bf-7fa8-4495-6345-207f133ef746@blackwall.org>
Date:   Tue, 20 Dec 2022 12:13:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] net: bridge: mcast: read ngrec once in igmp3/mld2 report
Content-Language: en-US
To:     Joy Gu <jgu@purestorage.com>, bridge@lists.linux-foundation.org
Cc:     roopa@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, joern@purestorage.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221220024807.36502-1-jgu@purestorage.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221220024807.36502-1-jgu@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/12/2022 04:48, Joy Gu wrote:
> In br_ip4_multicast_igmp3_report() and br_ip6_multicast_mld2_report(),
> "ih" or "mld2r" is a pointer into the skb header. It's dereferenced to
> get "num", which is used in the for-loop condition that follows.
> 
> Compilers are free to not spend a register on "num" and dereference that
> pointer every time "num" would be used, i.e. every loop iteration. Which
> would be a bug if pskb_may_pull() (called by ip_mc_may_pull() or
> ipv6_mc_may_pull() in the loop body) were to change pointers pointing
> into the skb header, e.g. by freeing "skb->head".
> 
> We can avoid this by using READ_ONCE().
> 
> Suggested-by: Joern Engel <joern@purestorage.com>
> Signed-off-by: Joy Gu <jgu@purestorage.com>
> ---
>  net/bridge/br_multicast.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

I doubt any compiler would do that (partly due to the ntohs()). If you have hit a bug or
seen this with some compiler please provide more details, disassembly of the resulting
code would be best.

Thanks.

