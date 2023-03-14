Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4C56B921C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbjCNLv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbjCNLv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:51:58 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B0F1814B
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:51:24 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id x22so4626047wmj.3
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678794674;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RDVVUR+sXeSTSSTr5N1GxIRd1v5VKh3gMAujp5AXOCw=;
        b=tytzsvmhA7PbupttINkYDa2kvVAiTmURa5SS/dWCfHmzmYutlP5ay9czU9bk6VD3FD
         RfUL7nNjFhVqAu8WIvVQpwT3UZpUPZu6b0hm3G7C1dPGoL8aaY38WRLzaf75Aie8k2Ux
         DJx26v8VzoBe3EOWU1Y2M7zT2Q+E2H2nw+QRARGGPKbQzl+Ez/QoVkle7ajCtgETIzMI
         mPET47b+z1hPmQSrVc95VGksAnQi9hlXHbCdqC37Ye3+isbaqtbpv+f2DFD0Vd2bE1oc
         2CvQgIb8O8ayJyVe5oWvP45vxJkTpTxB12sAQm4/1J/lFlHZbBjQn0CyZSTBLWZ5+l61
         tErg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678794674;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RDVVUR+sXeSTSSTr5N1GxIRd1v5VKh3gMAujp5AXOCw=;
        b=pk7DhJCAXvcgOdk3ByOh3gd7h/Za9m1CCZNbfn0NCamKEpLWMp8E/YpSRlJdZwZYwt
         pkaM/9s2ED+B19U4oFUZjB9BrseTDoAKd9xUdPhkOlDAIX02CokOYjBTX1PfTr7SJ4lQ
         P+ERGkitFN6d+f0OYFtyeYPvwsmxmgEsiUQGWYD5JePAToL5BUtMmLF2EJG5AeEDJ4Cs
         LhCR2/3AoYJycTJXt+CFLKipZplgbLd1BwqgAn1+ofShwnbC7TkQRTQsNB4iPG3RM9XD
         78u721JJY1ev3fkPe2oas4Cdvj1fBA98+dlepLz3k/lgvxIYyN/rmPuJOBf7DUC1gcgo
         GFIg==
X-Gm-Message-State: AO0yUKWVb6RvehIUCt5B0oZSuSM+WWr+6oDw8QB1sylZY3boJZ/g4fS/
        1hCVQImlR9RrcWAu9lqRCgcgaDdxvU8fMUDQ6Prbyw==
X-Google-Smtp-Source: AK7set+Dmb73QxFZOvG+Cj9vuj9692XHJVHML0b6UoNMNGZ9FIouknDT3Ww1hrO8OTJQMb3OTZa9tQ==
X-Received: by 2002:a05:600c:548e:b0:3eb:2708:86ca with SMTP id iv14-20020a05600c548e00b003eb270886camr15415319wmb.28.1678794673763;
        Tue, 14 Mar 2023 04:51:13 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id l17-20020a7bc351000000b003e21f959453sm2579991wmj.32.2023.03.14.04.51.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 04:51:13 -0700 (PDT)
Message-ID: <dc4b2eb0-2478-7e26-4292-b8856494fae2@blackwall.org>
Date:   Tue, 14 Mar 2023 13:51:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 03/11] rtnetlink: bridge: mcast: Move MDB
 handlers out of bridge driver
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230313145349.3557231-1-idosch@nvidia.com>
 <20230313145349.3557231-4-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230313145349.3557231-4-idosch@nvidia.com>
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
> Currently, the bridge driver registers handlers for MDB netlink
> messages, making it impossible for other drivers to implement MDB
> support.
> 
> As a preparation for VXLAN MDB support, move the MDB handlers out of the
> bridge driver to the core rtnetlink code. The rtnetlink code will call
> into individual drivers by invoking their previously added MDB net
> device operations.
> 
> Note that while the diffstat is large, the change is mechanical. It
> moves code out of the bridge driver to rtnetlink code. Also note that a
> similar change was made in 2012 with commit 77162022ab26 ("net: add
> generic PF_BRIDGE:RTM_ FDB hooks") that moved FDB handlers out of the
> bridge driver to the core rtnetlink code.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v1:
>     * Use NL_ASSERT_DUMP_CTX_FITS().
>     * memset the entire context when moving to the next device.
>     * Reset sequence counters when moving to the next device.
>     * Use NL_SET_ERR_MSG_ATTR() in rtnl_validate_mdb_entry().
> 
>  net/bridge/br_device.c  |   6 +-
>  net/bridge/br_mdb.c     | 301 ++--------------------------------------
>  net/bridge/br_netlink.c |   3 -
>  net/bridge/br_private.h |  35 ++---
>  net/core/rtnetlink.c    | 217 +++++++++++++++++++++++++++++
>  5 files changed, 244 insertions(+), 318 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

