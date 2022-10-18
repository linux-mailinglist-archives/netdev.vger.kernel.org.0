Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D58C602715
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 10:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiJRIhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 04:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiJRIhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 04:37:09 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA6783237
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 01:37:08 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id s30so19430674eds.1
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 01:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yxuQEGrIO8vmCslS3QuI3tXzAw6DQgSClcUN2Vo4mcw=;
        b=jtfgTY9eXvSBQ8QQS3vP7sFZZ5Zac6fDuYv5BXUkk/Dzc5wKQ+CtAr++Mj7qWKHttl
         dQ2/7pm0ZI2RfjydiNIbCiqhTwRNLcRX92KUmnWvqhkNMrG1JbljzpA2Dxw9D84SvGMW
         cxJnkTLop9xkURaeRj3IpLehpz2/ERgjWKVbAk4m2QRn7xYAVaGsb4rofHEXoTS2HfMx
         1cdedvj9lQvCyEBB7c5OWliit9q/g+9CG2IHCBNzkEu5JqR/i1+47xsES8vMadfEZZRr
         qCyK7sisl4QGJIw+GIvZibLk6Uy1DRy3EV2Mp3qVpjOfEu8VYNmhbzJy06d4s/HKEK0X
         qzjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yxuQEGrIO8vmCslS3QuI3tXzAw6DQgSClcUN2Vo4mcw=;
        b=uBCW5EKUX0CRNFRtcfnhHjTmS6TwAu5juA+YDx7yPPKrt4QSdr+uZ4XuAOFCCp2NWj
         izLhlQ+dbs8kg1FUnuAnuiwTydEDcAkc7pxBYBnP9epY+f35QPTwda55vJWGlQ/nRMA2
         ggi2M45wGy5wtSMMk/3woO6l04PpqxJzKDEuthR6TZmtGyDU692guyIQfjuRUC0uwH50
         CX7BGQH9CCtJkBXisHLj6IAMq0ksuteTk/WkPP0xsF3Ks+RkYn4ZZKQHmTaknmXvLFpO
         c37f47MCEQgCOghY/EEmDTPLUzzJohFLsVlGSNYR0SeCZiaVLF01gmbpTANJjEH/63nO
         F3fQ==
X-Gm-Message-State: ACrzQf0odG6764cexqQCNVQfgj0xUNo7Tf26t8yMC0eQ7c6gwqML7xmk
        05XlPX36Fg8YLuFeF43IP2itZA==
X-Google-Smtp-Source: AMsMyM7sHNQYtDXTv0bjYTa26O9ozx0687OmIQopxQAjo6JI0d2Reep7KOMWaCZgFmvyTW74ZRAyYw==
X-Received: by 2002:a05:6402:2146:b0:458:15d7:b99a with SMTP id bq6-20020a056402214600b0045815d7b99amr1605913edb.24.1666082226329;
        Tue, 18 Oct 2022 01:37:06 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id p11-20020a170906604b00b0078df3b4464fsm7378166ejj.19.2022.10.18.01.37.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 01:37:05 -0700 (PDT)
Message-ID: <04d81c6c-33e3-c780-f546-c5050444620c@blackwall.org>
Date:   Tue, 18 Oct 2022 11:37:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next 1/4] selftests: bridge_vlan_mcast: Delete qdiscs
 during cleanup
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221018064001.518841-1-idosch@nvidia.com>
 <20221018064001.518841-2-idosch@nvidia.com>
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221018064001.518841-2-idosch@nvidia.com>
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

On 18/10/2022 09:39, Ido Schimmel wrote:
> The qdiscs are added during setup, but not deleted during cleanup,
> resulting in the following error messages:
> 
>  # ./bridge_vlan_mcast.sh
>  [...]
>  # ./bridge_vlan_mcast.sh
>  Error: Exclusivity flag on, cannot modify.
>  Error: Exclusivity flag on, cannot modify.
> 
> Solve by deleting the qdiscs during cleanup.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh | 3 +++
>  1 file changed, 3 insertions(+)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

