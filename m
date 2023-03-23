Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1BD6C6C2A
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 16:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbjCWPU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 11:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjCWPU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 11:20:26 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F942B2A3
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:20:25 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id eh3so88147028edb.11
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1679584824;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jVk9L8OjcWyw4yQmeYxOQkkW0z7zhMdc3Eaui4v4R2Q=;
        b=56eu+Y8tNQcOVhwR51GOVbkj5anxsdozwrW14cb56bkmalOD2WI0sQ0ybUQwjKdGX4
         8TctDATSECWn+L2HOyzvIchu8UOV6KisCkoOtBptSKYqQFXD8BYMiVzGdv7YPgxWgoYc
         gL43jKMY2Ylaf40NXhfBY/iITlrnsKLR/hNWCc14hnLB76iilKv8IlLPl1MdNdGY7Mdw
         OGPkj9dMXlTSSF8Lue441sJjfzIbAqhQkoqt6rLjz/5kRmx4rDkG3Y3RP2pDx0WOvqJr
         iqzaf5eqCvh3yCplUtYkzNxgop8ctM+lq+gK8uILQbHU/t2OHWP2rPrul7Xj3bvChWn/
         wYJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679584824;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jVk9L8OjcWyw4yQmeYxOQkkW0z7zhMdc3Eaui4v4R2Q=;
        b=obvymBUW0w7/WZF7HC7IxIjs2i7fMBwGyg3a8nc2pRizMwPyHAf4khZZ+zHfJjCrKR
         D/xcEx9nbV+BkqjwZ+XCAdmTPyDCPVgNriTQ3St21g6nHWy/3pKN0w1QpX8ZDBzZe+EU
         pSWX08+3N92cZspzJJmxsNlpMkGf9nXLYkNgHaes308OZfBg73OJu4UEtKI0d2V1Fmub
         COc04GLsNCNbr0ik4jQVGHlwCzsYfHsIGGwRIkvqmUS9U0AN7SDl1QvrLIapiOlvDyQM
         c3ObE3h9lOFfeZjRPxJpxknvv055/DvSRJAGIIo1R21mRMJBkbdjlWH0aNHAIrNGx0xC
         Pg0A==
X-Gm-Message-State: AO0yUKVYiYtIQKDD5AfrL0LrfvEJz7Uzup9t4o7sNNpdVsCnQLAbUR6k
        cvn+NzytE5QBii1evVF2ZBVPFA==
X-Google-Smtp-Source: AK7set9GV3bDizQcS1yH5FQvcA7gl7cRiO0ZAKt8nwPWqOq1eJrCMlEeV7Re/bi5xJFuU5WkrJVd0w==
X-Received: by 2002:a17:906:370c:b0:933:3663:a1ea with SMTP id d12-20020a170906370c00b009333663a1eamr10721838ejc.57.1679584824051;
        Thu, 23 Mar 2023 08:20:24 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id u7-20020a170906b10700b0092f38a6d082sm8777981ejy.209.2023.03.23.08.20.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 08:20:23 -0700 (PDT)
Message-ID: <dc70c958-c5d2-2375-4670-42c6ba0ddbed@blackwall.org>
Date:   Thu, 23 Mar 2023 17:20:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH iproute2-next 5/7] bridge: mdb: Add source VNI support
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230321130127.264822-1-idosch@nvidia.com>
 <20230321130127.264822-6-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230321130127.264822-6-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=3.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/03/2023 15:01, Ido Schimmel wrote:
> In a similar fashion to VXLAN FDB entries, allow user space to program
> and view the source VNI of VXLAN MDB entries. Specifically, add support
> for the 'MDBE_ATTR_SRC_VNI' and 'MDBA_MDB_EATTR_SRC_VNI' attributes in
> request and response messages, respectively.
> 
> The source VNI is only relevant when the VXLAN device is in external
> mode, where multiple VNIs can be multiplexed over a single VXLAN device.
> 
> Example:
> 
>  # bridge mdb add dev vxlan0 port vxlan0 grp 239.1.1.1 permanent dst 198.51.100.1 src_vni 2222
> 
>  $ bridge -d -s mdb show
>  dev vxlan0 port vxlan0 grp 239.1.1.1 permanent filter_mode exclude proto static dst 198.51.100.1 src_vni 2222    0.00
> 
>  $ bridge -d -s -j -p mdb show
>  [ {
>          "mdb": [ {
>                  "index": 16,
>                  "dev": "vxlan0",
>                  "port": "vxlan0",
>                  "grp": "239.1.1.1",
>                  "state": "permanent",
>                  "filter_mode": "exclude",
>                  "protocol": "static",
>                  "flags": [ ],
>                  "dst": "198.51.100.1",
>                  "src_vni": 2222,
>                  "timer": "   0.00"
>              } ],
>          "router": {}
>      } ]
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  bridge/mdb.c      | 18 ++++++++++++++++--
>  man/man8/bridge.8 | 10 +++++++++-
>  2 files changed, 25 insertions(+), 3 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


