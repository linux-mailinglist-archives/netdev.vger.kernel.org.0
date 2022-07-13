Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13338573A95
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 17:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236941AbiGMPwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 11:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiGMPwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 11:52:04 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272504D4F9
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 08:52:01 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id os14so20619480ejb.4
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 08:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=52qtuFRxRpawHHeL2NdmQteCmSw5P4rfWU52Ibp6ozE=;
        b=GA5rzjuthnDUiEYECRdi/nqObbdrqfbTd2dTljGdLR5s2Vtg7JIW7NxDjRsW4fy5oE
         6a7N1ijnuUEXTkJemcMQctz2hd5Och+/VmH9sOU99NBbf9YGiBe44zI0ZajMElRSJOLi
         wasHMuWAsFqwpHcoAsZCXfJ62PupVSu9KO0ueQ/yJJGzYoG422JnpwdJThZEV8Gz63Fb
         sZH4t2/QLAQHIQgMOQ7MfXsW5HlN+p4RC7KQ3qxEy7yzfHDzoNfhnBziDyRlRMs8eYwy
         +GeM+c3MbQylRChAr/HNz9bCV0swTIz1oLLgNpAZRjmf1zxZPaNA8ScRMIuPYUyFUYlh
         r56w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=52qtuFRxRpawHHeL2NdmQteCmSw5P4rfWU52Ibp6ozE=;
        b=HVIiR467sFc09cXeAw/XCFeGNgBqnJtAt88xGvVNvm4KJ+vT4GREt/B3BKXa+8ZlD2
         Hd/FFqkhWGZl8NTODDJsmiPv9Mbsnk84EKmRzBP+Kt2+MKvqcmmuGc24Fi8dM/606e9t
         3A75Xu14C7LcSLueV9ZMGRF3WNDyNYGWHSB1P0wjcc0FfNnmCkL6nF3XiMVfpNbT8gEu
         myrSYjbCwbx9KUH2a5q3xDnIhXxAlvh4K4nfKSC1m3arGrJIgHb/P5GengH0GSezEkhp
         M8l4fr+OT2LQPep9KxVhgjZLhcHpWpBYpvQLEusEtKL4pH1yrXcAstiW09rqZm4OgYY6
         l5Uw==
X-Gm-Message-State: AJIora+JHsqHA1+GyXFamQDtuGooVe8Dqv+wr4bgswTg0djO4vlRg1x4
        pWyHdbPtZeW+OhMFuVtrCDM=
X-Google-Smtp-Source: AGRyM1vCfQtXWDpYyMlKHEiOX8hBytLbzbIUU7PB5oVBymr2vnALxdNHXEXIfmAEDBf2JLUsQCXIAQ==
X-Received: by 2002:a17:907:7287:b0:726:c82f:f1bf with SMTP id dt7-20020a170907728700b00726c82ff1bfmr4154567ejc.284.1657727519798;
        Wed, 13 Jul 2022 08:51:59 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id q18-20020a056402041200b0043a7c24a669sm8172952edv.91.2022.07.13.08.51.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 08:51:59 -0700 (PDT)
Subject: Re: [PATCH net] sfc: fix kernel panic when creating VF
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com, sshah@solarflare.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Ma Yuying <yuma@redhat.com>
References: <20220713092116.21238-1-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <a29124d2-3bf0-4bf1-a231-5937dfcf96b6@gmail.com>
Date:   Wed, 13 Jul 2022 16:51:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220713092116.21238-1-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/07/2022 10:21, Íñigo Huguet wrote:
...> Fixes: d778819609a2 ("sfc: DMA the VF stats only when requested")
> Reported-by: Ma Yuying <yuma@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

Acked-by: Edward Cree <ecree.xilinx@gmail.com>

Really the whole locking thing around stats is ugly and we ought to
 redesign it so as to fix things properly (AFAICT there's no reason
 why the stats_lock needs to be taken by the caller rather than
 within the nic_type->update_stats() method), but for the time being
 this looks like the right minimal fix for 'net'.
-ed
