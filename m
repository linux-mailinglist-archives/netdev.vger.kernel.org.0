Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E026E6C6C2B
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 16:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbjCWPU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 11:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjCWPU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 11:20:56 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F251BAD3
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:20:55 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id o12so88146316edb.9
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1679584853;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tmErZizvv/tVF4vX3ASnb16suMaRan5P0YQmwBnNP00=;
        b=6FqLrdUBSHvjOkAhGKwx4cmBiE6u/X28wQfMbJh4Cezf1hr36jsp7+donnH4L63fge
         ROeAxBSX4Cbhvebk+kOrMdUJIMLBy3FEoOZPZzL41PCpw6qKGdSQf/QpcbEX7YxeF4ht
         P4qlDIQQcNEkBUsHL2xFl2OZBhGqbQ+sM6Uanv1tBtpxye6wOs9+0WjqHjnu756h5k2R
         e7ydT1nfceMwcMvc5gEGsqDZKgljo+JXCgvFRw1BoCP4/By9A7lqTbM34Q5DB3FJ4BaL
         12tuZAGlZltSKknptUhiNwk3XDtf883eT3y1SW7/xvUoAu2hjk1JM4IU2U2AKj/IvEYe
         /3uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679584853;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tmErZizvv/tVF4vX3ASnb16suMaRan5P0YQmwBnNP00=;
        b=LHBbjY0XqkuiDa+8dsYPOwbvwgonnvj0Ttu5rVeYkG/iM9u5ePx/r73f/jSTlBFgrY
         BbQ1wdM91usb+p4t7Jv3vIZBgV43fmQ+vawEf/cx2RHi0hQ/ru0zYsWvHihMTqbWBTOa
         XUhwU8AdbJUNkZ7aulSZZ+1t8F8E8+JO8gSpxRR59WpEechRSz08E3z048AwRaUjx/zj
         FUQ8W9j7b1wFBLVKgLccBTZgz0Q/MhRRI1ZJSgjWErqlsqzf3kWl6oFB5WjDI9m9cYYT
         ge2xbe03+EvPa1NBsZnGXQgbOUaslWMZet/LsWAuSUaiyUxjqN4j9mP5ZW/nA+7rnbzf
         vr9Q==
X-Gm-Message-State: AO0yUKW5pH966Bb+6Th2NhKNh7+MKkIoMabuX4I1sd/Y1owfQzOsETj1
        7nzJMUCF9IgZtPCgHIg8l+hTwQ==
X-Google-Smtp-Source: AK7set8B78SGL1XQQaT+qqPHGwxDEvXGrPJEd62vPTn+HSjnYjkUkkCRJtxgXOUl/beWtgMmtRWk3w==
X-Received: by 2002:aa7:d3c1:0:b0:4fe:9bba:1d65 with SMTP id o1-20020aa7d3c1000000b004fe9bba1d65mr11686969edr.21.1679584853490;
        Thu, 23 Mar 2023 08:20:53 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id e14-20020a170906044e00b0093204090617sm8524465eja.36.2023.03.23.08.20.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 08:20:53 -0700 (PDT)
Message-ID: <7c1e5059-5754-39dc-0b92-1647647ad767@blackwall.org>
Date:   Thu, 23 Mar 2023 17:20:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH iproute2-next 6/7] bridge: mdb: Add outgoing interface
 support
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230321130127.264822-1-idosch@nvidia.com>
 <20230321130127.264822-7-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230321130127.264822-7-idosch@nvidia.com>
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
> and view the outgoing interface of VXLAN MDB entries. Specifically, add
> support for the 'MDBE_ATTR_IFINDEX' and 'MDBA_MDB_EATTR_IFINDEX'
> attributes in request and response messages, respectively.
> 
> The outgoing interface will be forced during the underlay route lookup
> and is required when the underlay destination IP is multicast, as the
> multicast routing tables are not consulted.
> 
> Example:
> 
>  # bridge mdb add dev vxlan0 port vxlan0 grp 239.1.1.1 permanent dst 198.51.100.1 via dummy10
> 
>  $ bridge -d -s mdb show
>  dev vxlan0 port vxlan0 grp 239.1.1.1 permanent filter_mode exclude proto static dst 198.51.100.1 via dummy10    0.00
> 
>  $ bridge -d -s -j -p mdb show
>  [ {
>          "mdb": [ {
>                  "index": 10,
>                  "dev": "vxlan0",
>                  "port": "vxlan0",
>                  "grp": "239.1.1.1",
>                  "state": "permanent",
>                  "filter_mode": "exclude",
>                  "protocol": "static",
>                  "flags": [ ],
>                  "dst": "198.51.100.1",
>                  "via": "dummy10",
>                  "timer": "   0.00"
>              } ],
>          "router": {}
>      } ]
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  bridge/mdb.c      | 32 ++++++++++++++++++++++++++++++--
>  man/man8/bridge.8 |  9 ++++++++-
>  2 files changed, 38 insertions(+), 3 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


