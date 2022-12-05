Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E61F6427C2
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiLELob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiLELns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:43:48 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618A7FD7
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 03:43:47 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id r26so15330402edc.10
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 03:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nq/qiZ4kHuJyfTha/rmI50ZFco+CixoW93NZbxAckHE=;
        b=NHKFcuVc8bLzu0js9axZp84zVm4uj8ElmTmkZW5qt0pHWnr70eBt/L5b8kEVPxNnu7
         79pe7PzngBP9EyDHtXrbw037t6mUsINpZIFyI+jmcFnr2c7JzNy47zT3f8yCDLpgRdiy
         ahOL4MwFW57kHxSTVg8X/obBLW1i0ioSu7grsBoYPSeDabST5PDjLAEAtMyTIT0yx62Z
         yOooM8j9LYBFBlEu2Riy48lsvMiTwOjtcrebLexrwXiS9AZQNj0s6GdeZmQ0V/+SWHEg
         p1Bm3pbIFzozydzO6eDIIjpUbJV3xrzmHHxomO/aI0NaixfGMqyZZ6KrbtOKOVQ13336
         pu9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nq/qiZ4kHuJyfTha/rmI50ZFco+CixoW93NZbxAckHE=;
        b=2czwKjaDGtDS4WjF6WOJOx0wH418zRDJQbhiVbsZBGFMcmcXKlrdoGOy7tTHylXFWw
         v+NQ4WGYgyxsx6fXo8YH/LnHsWX1BX7xFbn89TJPeSmZU0yT8yDQi/N8ah9eaN6XaXWV
         19VK+jjtHGU4a9Nd51qpLeAes6Rb1CatpyePSV3F50eRUDGFSXqGd+ewJAwjCRzgAtr7
         4AfKoFY5btb3U6IPZKwsWXZxWEZmiN0N/CaqcEYTEnLvVUtVU2AHw85MJmC/3NyvdLc3
         dP2LGPqA48i+F1eetVDIWTtS9URRGBmynJX/XycmE5P7IvleKawuF9VFu2LYIuAKqIk3
         A6xQ==
X-Gm-Message-State: ANoB5pncx/IKU8HxKxy5XNwhsTNuY7mmmkaJYCOJ4PmlGQ4h/cvdhcg+
        g/eB2PT/las0D/FcXghBz+AaAA==
X-Google-Smtp-Source: AA0mqf44coxYBVT2Xg5vQx/RkQMNEE9oZxoWP8qeHxvCYCo4iQ+gIojYC5QhDkwFrm3Ls1aROLeA0Q==
X-Received: by 2002:aa7:ce86:0:b0:46b:1872:4194 with SMTP id y6-20020aa7ce86000000b0046b18724194mr31842179edv.362.1670240625884;
        Mon, 05 Dec 2022 03:43:45 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id b18-20020a1709063cb200b0073dbaeb50f6sm6058263ejh.169.2022.12.05.03.43.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 03:43:45 -0800 (PST)
Message-ID: <f9e8a036-245f-a77b-095c-d1ae709bfb6d@blackwall.org>
Date:   Mon, 5 Dec 2022 13:43:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 8/8] bridge: mcast: Remove redundant function
 arguments
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221205074251.4049275-1-idosch@nvidia.com>
 <20221205074251.4049275-9-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221205074251.4049275-9-idosch@nvidia.com>
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
> Drop the first three arguments and instead extract them from the MDB
> configuration structure.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_mdb.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


