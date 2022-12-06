Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F85644337
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbiLFMdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbiLFMdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:33:00 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0EE13F84
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 04:32:50 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id vp12so5799998ejc.8
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 04:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a9Apa3uOHTaWpyI4d5WsN/NOtmRrJfK1jH1TKEd9eDA=;
        b=YcdOdKovc+PQRGX9VMh5p9K6mbx4EHAfko7hOFYFKl6CslLrtwYEQ1pHihMNi3IJpe
         2tNikG+7dxK2SPd/XzHhW2POiepzA7XTnqD5Dbp1W1DDtdQPIejXmCms+vJaoWrLznxF
         XCqEkT4DjUFXEbH9r6HqszNwWnIywAdhTyMnBjPlhYqnAcC4i/O3gdqoYEsNhYX79XWq
         5OtJwfLe2AGRASttWlhAu78qy7mhfPcB+lpxg4qhqrTCfLaFOr87MoESEoBT0KZQykuF
         CJqiM+w17KaiYYSueA46iBSDoqbx3SYgvQOc2YhH95ftL5FVOGxE/iMRCJJv8cpNUrXX
         2Q0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a9Apa3uOHTaWpyI4d5WsN/NOtmRrJfK1jH1TKEd9eDA=;
        b=7aqiTpWUwjCv/EEM6Z+SIkTrYGPVvBGSadZh9vmlNQuBkgfV9yOgso+NEsOv8iAguP
         min6WzOPdsWpuld1b0YvvphZqgJsHgzaj3eIS94rZD2S6xfcI24uGsj2AocbsBhZjEEG
         7H1iVdWQdyouQ84blUnhLB9LgjxeJKCT/0cRJsnde2NC9Ebc4ggnqBIADxw/TRKUG+hb
         eRk1eIeiHRpDsE0X7l0nT13KiiHCbNMObIzf2qeFIuIVLdQyyEt54mueA1OY4kZ/EKXk
         hn2SZ/VWfS0io5XoIKVKWuwoEw6y+z57uuNRoN5mSCeWPEg6Tn448TAVRTx/X/5YP+P/
         vusw==
X-Gm-Message-State: ANoB5pm+qpM0H2yMfAhC8VIHmP6YN6n9T7OtVshMN/c7LTtZWDdofm5m
        m/dkdXu3cFqByBbhMqHy4iU4DA==
X-Google-Smtp-Source: AA0mqf6AZqnAyvnO68V/atP6PNMyPfKBlhgDycsLkFkV/+GUlWRGrRmBWHVYwjnVHSammElfwF+b/g==
X-Received: by 2002:a17:906:2a10:b0:7c0:cc6d:5df7 with SMTP id j16-20020a1709062a1000b007c0cc6d5df7mr104786eje.68.1670329969196;
        Tue, 06 Dec 2022 04:32:49 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id d22-20020a170906305600b007c0e6d6bd10sm3053291ejd.132.2022.12.06.04.32.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 04:32:48 -0800 (PST)
Message-ID: <d7f8d88a-531b-4ccf-0310-9e3f78356fac@blackwall.org>
Date:   Tue, 6 Dec 2022 14:32:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next v2 9/9] bridge: mcast: Constify 'group' argument
 in br_multicast_new_port_group()
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221206105809.363767-1-idosch@nvidia.com>
 <20221206105809.363767-10-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221206105809.363767-10-idosch@nvidia.com>
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

On 06/12/2022 12:58, Ido Schimmel wrote:
> The 'group' argument is not modified, so mark it as 'const'. It will
> allow us to constify arguments of the callers of this function in future
> patches.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v2:
>     * New patch.
> 
>  net/bridge/br_multicast.c | 2 +-
>  net/bridge/br_private.h   | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 

Nice, that's even less than I anticipated. :) 
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

