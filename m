Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFA06B93C1
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbjCNM22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbjCNM2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:28:09 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4618A1FE3
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:25:57 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id r29so6134913wra.13
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678796681;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UwbHt6idtZCCtjCrFRLotwokcc91x7BzRsfspk4D+Bs=;
        b=OViau/4tkuET8wV7RbEr1O4VwMsMJLlFKZQ6nZzuv2/WxY6VPlvYsIRw8TL8MIFtAM
         EdpPM471ZMa5w0fI8st+88q5NBg150pKY2en4UOtsWRhdNSJsUVfJlPRw6AgVK3kBdL6
         J26H+2HS5DrgKNi+oTeHyC8A1mJXqXJ998yuAjaHMktb1FuPY4jfNSv6iJafA/wVXZTO
         js7NbZJiCYIwtolYKKNARhMRGHFSrLxR8bPQ+YRwpYCbGEhV8AhjYerLQL1qEZXeRobO
         mpRe+zMyfxeKTNYRo2o9PFgoaCaYQn4C0CS98qL+SBA7hq0CdD5afnmdBtIlYFrCEnVf
         K+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678796681;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UwbHt6idtZCCtjCrFRLotwokcc91x7BzRsfspk4D+Bs=;
        b=xI/hHAAvdE9ra9jR/a7SZV81/O7A5WbwM2oG2c0DOIm7KtXgwgCR31zBC5e2fZoB+F
         L0EZW7Pt0xsQmLmOHJ+s3AODaL1cM/dwN/tACh4bvOc7ytdffTFEC0BqKXrknCWQrQrc
         0JyzJfkF+cXen+6OilYARrrusBWfUn+EOLc2pCt8yhF1xzzNFyQK5edqLaTBNZvfVm/I
         xpzxomBvjHsjrtrbwLq/oD7slmaVX35AKBM6l3fotvoGlzgZEwLCdaRazKny6x5Rgbqv
         ZIxKdp25AYMVQYGinSPHwmNBfwf0u80L6pPA4Cx8xZk3fqHA4gGqvPjWgIGhHMKHX86K
         OgsA==
X-Gm-Message-State: AO0yUKUn2k70z4tkhhaPfyyR+qrqXptHu5Rg4ycvw7GTfDsdO5ANeUUv
        fK/+gXjUAeuHJ8LsFpjTG4AGeg==
X-Google-Smtp-Source: AK7set8UPY0A4K25Q5NYBDSxflcJENisQU+pV8MviFIRckaA8XIQFIGKFJ+xIHUYV0D63gCX84wWZg==
X-Received: by 2002:a5d:4c46:0:b0:2c5:9ef9:9bab with SMTP id n6-20020a5d4c46000000b002c59ef99babmr25370010wrt.43.1678796681518;
        Tue, 14 Mar 2023 05:24:41 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id m1-20020adffa01000000b002c5526234d2sm2071470wrr.8.2023.03.14.05.24.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 05:24:41 -0700 (PDT)
Message-ID: <b4f379a4-b883-d903-148b-a6270aedce20@blackwall.org>
Date:   Tue, 14 Mar 2023 14:24:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 08/11] vxlan: mdb: Add an internal flag to
 indicate MDB usage
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230313145349.3557231-1-idosch@nvidia.com>
 <20230313145349.3557231-9-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230313145349.3557231-9-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2023 16:53, Ido Schimmel wrote:
> Add an internal flag to indicate whether MDB entries are configured or
> not. Set the flag after installing the first MDB entry and clear it
> before deleting the last one.
> 
> The flag will be consulted by the data path which will only perform an
> MDB lookup if the flag is set, thereby keeping the MDB overhead to a
> minimum when the MDB is not used.
> 
> Another option would have been to use a static key, but it is global and
> not per-device, unlike the current approach.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  drivers/net/vxlan/vxlan_mdb.c | 7 +++++++
>  include/net/vxlan.h           | 1 +
>  2 files changed, 8 insertions(+)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


