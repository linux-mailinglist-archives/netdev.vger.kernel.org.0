Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF6C6427C1
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiLELoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbiLELnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:43:37 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111B3F52
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 03:43:32 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id td2so27059766ejc.5
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 03:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8/CyNdrc1NG+SiV/WyFqFX763UJgr1kiBYK1y29Dd3Q=;
        b=WovpQAkmjcZCSOQ+lMsEsETG7brsFoL+2ZXQibGwumzD52tGEerBqsmtc1QbxA7Iui
         CeOckv807i5mMP8Jw1Um0uzfeXJxwzBMUFhtgDpkDfvNROwobmscG9jDh88WzhsYo9Pq
         HjM8jF1p8h7gLq2L1Sv0HMvWUl/d8Ary9vu83Fn7pCZ+TpzwRTp7v3XoM7XCJDdtVGRD
         RX4rMM+XxWB9kdsqlEG7XROAHyoXnAn8s+WW6PGZza8LqBFjy7xlosvx9coy8JovqQGf
         l7OSGUUj631c1RX43qlmuvkh8VPxKVn+w1bz5It+tLJumScqW1f7DnPs/uQZuhx5d/Jc
         moZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8/CyNdrc1NG+SiV/WyFqFX763UJgr1kiBYK1y29Dd3Q=;
        b=6uCx5VsALZrfJyua1+b+zQxREN6H7VUxQSRosalJrCaCXiOJ9NjKLffbKztsM133Hp
         eh+uu4ot7DusOH+LSpLEC5IkQzf+pfuFdQ5/HcF+5g7tVLJ1yTK/TXW2HeMmTAHZENP6
         QymGwMX2YLmDz4uML8aJtrlqEmZdeuZIS6cSPfIAwmmQVAZPK2bNTl0cVHU1zvU/WkSy
         rhAkaTj1gBwmkt2L+9Gf+smsj5W+OeaBrzQzY30xc29CXEaiXHo2IyCF6CUu8sVnw7ye
         lfdFwMj9UZWdzZ02NNR6nxl1p8xIwcFsOGiVDLKQpB2OPU9bQYUFPrgf3Qr6LslQ4nKO
         yPvw==
X-Gm-Message-State: ANoB5pkpQafS1TJx+jmC9LsQnDhjkD6OvuGmS5Q+OYfXzsi3dGfcSzI6
        hRxJrsVd+Lnf3jX0YpOq+xwPyQ==
X-Google-Smtp-Source: AA0mqf6Va2Rd1Wd7OSjGasJzLU4rpjntrRZQeRosD83Kii8kA3L2nkBwViB9YMYlUgiqieUDZ+sRdA==
X-Received: by 2002:a17:906:8296:b0:7ba:29a1:543c with SMTP id h22-20020a170906829600b007ba29a1543cmr20134056ejx.297.1670240610444;
        Mon, 05 Dec 2022 03:43:30 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id r9-20020a1709061ba900b007aec1b39478sm6152538ejg.188.2022.12.05.03.43.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 03:43:30 -0800 (PST)
Message-ID: <3d7da3fd-53ca-c321-0b00-b79948b85993@blackwall.org>
Date:   Mon, 5 Dec 2022 13:43:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 7/8] bridge: mcast: Move checks out of critical
 section
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221205074251.4049275-1-idosch@nvidia.com>
 <20221205074251.4049275-8-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221205074251.4049275-8-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/12/2022 09:42, Ido Schimmel wrote:
> The checks only require information parsed from the RTM_NEWMDB netlink
> message and do not rely on any state stored in the bridge driver.
> Therefore, there is no need to perform the checks in the critical
> section under the multicast lock.
> 
> Move the checks out of the critical section.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_mdb.c | 36 ++++++++++++++++++------------------
>  1 file changed, 18 insertions(+), 18 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


