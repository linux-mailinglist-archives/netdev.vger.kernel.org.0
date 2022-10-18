Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31CC602717
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 10:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiJRIhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 04:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiJRIhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 04:37:19 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAD09E69A
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 01:37:18 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id s30so19431256eds.1
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 01:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0r0CEcLzdsN43NZU3heQZC4qAAFpuw6sOVS1maYA6DQ=;
        b=kg/V4I4ASB09J7gYLUa/gilZUDLGVdLNMAycukH5jFUSl0VvTO+ZzwHyE6/Goz4/cs
         QK4W0TXDkNQwIBj/yB2sBe/zLQdNagY0v/PLCjvQxu1e5jwdp8Q6Jni0TFQxk5KhBGt2
         AQUyiGnzfE5suUPbgUJmYzsFbPpfR8eTP1IWzxu/zEmvCAT5UqQVQhvFsee6QWxcn8N0
         NRWp/Va/RKQUt4JickpDloreBm8vwNDzXlYb7c5REu62D/UzzA/7nnPYRqv+EBlC7gb8
         5+5SYr21pI66uIm++99fDREbhlj+o1OHi+4hFXPYKboAM+fFkBvt7sdFd6+jslS2WfEq
         uzAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0r0CEcLzdsN43NZU3heQZC4qAAFpuw6sOVS1maYA6DQ=;
        b=0EWJRw7IO6E9Ebv8Azxlm3ODo21a59gZH+ZXJtjcLBSxpfY41yHnDkXUn6OhxTyNWj
         KgTzT7KlTrPCLOnSmtz24T3eb1fmXJBubJcACxSbGMysmd4/Nc1pRlH+k1h5U5dXMyXu
         DL1hBDSyLaAl8roviBy19vgIouYn6l59XtkaGSr+5+3LjyBEJ1YoN4SP1zwdbTmLg+7D
         wjQG9vvgQYfnkemfJLTRvck923xNrj0wbmZjf86pqhhyeHfyphuYP5qFDdhEEzVLQJzG
         4ujYvorVbaCPhfUTjLQJGp1bzporwKqRAivlYyhYZkT/op5aEPhQeCSLVuORuxTy6hKv
         s61Q==
X-Gm-Message-State: ACrzQf3cgBndddnP3MdZydXN0HGIxgWeSO1N0IxZxWt1jittPhCsvHIU
        IwIE14mWld/5aQqn6kUS7msFUA==
X-Google-Smtp-Source: AMsMyM6IRFBzi6KglBRS082eAFbVOrF3V2P1sRTRQR0MgPU4LTMYWAEv5s5SJW0fcKRI2BVbj4DF4g==
X-Received: by 2002:a50:fe85:0:b0:458:5562:bf1e with SMTP id d5-20020a50fe85000000b004585562bf1emr1572766edt.167.1666082237618;
        Tue, 18 Oct 2022 01:37:17 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id u13-20020aa7d54d000000b00458478a4295sm8584754edr.9.2022.10.18.01.37.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 01:37:17 -0700 (PDT)
Message-ID: <b22a460d-88bb-f159-c75a-acd635430167@blackwall.org>
Date:   Tue, 18 Oct 2022 11:37:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next 2/4] selftests: bridge_igmp: Remove unnecessary
 address deletion
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221018064001.518841-1-idosch@nvidia.com>
 <20221018064001.518841-3-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221018064001.518841-3-idosch@nvidia.com>
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
> The test group address is added and removed in v2reportleave_test().
> There is no need to delete it again during cleanup as it results in the
> following error message:
> 
>  # bash -x ./bridge_igmp.sh
>  [...]
>  + cleanup
>  + pre_cleanup
>  [...]
>  + ip address del dev swp4 239.10.10.10/32
>  RTNETLINK answers: Cannot assign requested address
>  + h2_destroy
> 
> Solve by removing the unnecessary address deletion.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  tools/testing/selftests/net/forwarding/bridge_igmp.sh | 3 ---
>  1 file changed, 3 deletions(-)

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


