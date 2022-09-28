Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F1D5EDBBE
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 13:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiI1L1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 07:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiI1L1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 07:27:37 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF38CA3D20
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 04:27:36 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id b2so3573855eja.6
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 04:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=BEulo8v4FULYUtAwJzns1q2E/oGE4rNqGkXRPC+evRw=;
        b=vDJR8A4LrLfK5SfbkvqM8JiOZMNuw6LRWtL77+VzD58cOyRFvmorwGfYF+yIsmwkHQ
         pH7qHvbUyG11xyx8wfl7ukzd2wCUbX/sx+vutiInhlnEIWH38bzw+JlBK4PGTPm9ZL4B
         0/bQUPHKQTCqjmfnVkyBLqrs05oMYKa2ODGe/X08SeJegegFPYpjva3Paz2kZBZ1pDCt
         /zfUZlKHjcdLM2N1H7hkJGhzTnNWF7qdGbkAlMX1m1dv540e06lQDnQ2ph2GOGEBtAoU
         T00sv1GwK38GbqPzgS3MAY7KHEnn+LDMyWS/bEFV67Cyjbx+dOciJB3uNCDyzAIHC2il
         ThKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=BEulo8v4FULYUtAwJzns1q2E/oGE4rNqGkXRPC+evRw=;
        b=KjNl7bo/Iv0Z4vopnHA8tKGnfKouHJ4h5W3PbUbWwF3i/wJtOTsB4REoffAe07L8jp
         lbL7jnpGZqoPzhkOrNZ2dZ5iJvdxEszNLK0E3pyhaZno7463MkaoN7GeFrE1mCtj/FPH
         ziY2axK8I8uhaWZF3WAWyRThqVXjJ/+JDBuDlU4Mvp6EL/RcD1Mi4TnmsjAQ0sYe9BZf
         84Vc5ydIYVPbEcX+ba8hrzgoLrxXmAlPGEY3stZ/yWbShA6ROQES2Vq9vSiWFiLojXeP
         lZ8TBibpmyMZjFcbPb/9/FIokHpXN/GikpCG2+Jy9VEM/T+Sw9p/XouHu6tbU0U/B4lW
         SIBg==
X-Gm-Message-State: ACrzQf2l5l1iORidy82eNtcolaoHol8jEoSosaO8tnpBAcY+aVon3Zcl
        BGRRsx25q9HhaMO5UR6kypfHtQ==
X-Google-Smtp-Source: AMsMyM4ImuIRdhck7lgAOll2GNC62razucMPSc+8JPl8geUbP1+Pf2goAHtZP3G5it6Bf3fs1W49hA==
X-Received: by 2002:a17:907:70a:b0:750:bf91:caa3 with SMTP id xb10-20020a170907070a00b00750bf91caa3mr27135086ejb.711.1664364455174;
        Wed, 28 Sep 2022 04:27:35 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id t15-20020a1709067c0f00b007789e7b47besm2258579ejo.25.2022.09.28.04.27.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 04:27:34 -0700 (PDT)
Message-ID: <599636e0-ebf2-c954-ef2b-80a642771bb7@blackwall.org>
Date:   Wed, 28 Sep 2022 14:27:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [net-next] net: bonding: Convert to use sysfs_emit() APIs
Content-Language: en-US
To:     Wang Yufen <wangyufen@huawei.com>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org
References: <1664365222-30004-1-git-send-email-wangyufen@huawei.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <1664365222-30004-1-git-send-email-wangyufen@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/09/2022 14:40, Wang Yufen wrote:
> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> should only use sysfs_emit() or sysfs_emit_at() when formatting the value
> to be returned to user space.
> 
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  drivers/net/bonding/bond_sysfs_slave.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 

This converts only the bonding partially (bond_sysfs_slave.c).
Why not do it all in one go?


