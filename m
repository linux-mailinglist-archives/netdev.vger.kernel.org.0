Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143656C6C13
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 16:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbjCWPRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 11:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjCWPRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 11:17:30 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DFB1D93C
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:17:29 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r11so88139284edd.5
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1679584647;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JuQsjT3kJtvBrAcBzokJG752wfRaNupZ4EdtC6UmCMA=;
        b=0noq0uosXCaa1vQvTXNuglMZ6T6uxwszveKGrvpbcg/2yhiXAMKlhPu+nE14WEWgjp
         637OL+loqXmQfX5ZGVqK1ilPqXek3530gPXZf6eO02Y3RfQQ5zawJP76S2OEvaQa5ujT
         mBBLSy2Y0ijVHhvgsB/Jtsk+17yukzG5McAeIgAu1FFj95dOrzQ7rMhOTjJeuvCqh1mq
         aUhvOFD/M+7G/mT0eP58z9ugsFxV8yuu53wXGWMufiKiEbC8QK1Lt0dMILxhYTZ5bkUM
         0a3p12JVsKCRwgKqtrhO6fkIyBzv4Zu54A8YS6iAxhDaXjZR2CagbPwlLcUdh/iA7d9r
         h1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679584647;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JuQsjT3kJtvBrAcBzokJG752wfRaNupZ4EdtC6UmCMA=;
        b=6Sny1YOcxfBPV9V/jOBtEZzavtYX3XwrcjiE339WJShEn7NegX5BzM7o44W87XZx5N
         ChmT2PlbLFBqERxtsZ/rB+tF+uU56QYhqAHF5Shigrd4boOyfmWjIyUrl+ilYjONBpGG
         MaGPw1UE1RdwH8QtpHW4kNWt9GoK8LwRk1HIeo9/dmKVLqfYsQ7ysCxjbO/sSxleE7VW
         tN+EeCtuVwxEucwBiquSoRDmYoqpGFuUgceK7bScgCzmxWxXPBG4D/CFR3WYmqOROQJA
         u89Yc0DG8H36K4GnYHpf90rn9sIwkITHEQ/0I1Hu7XB++0vvyIa1YxkqzULQ1rk8auUX
         4pfw==
X-Gm-Message-State: AO0yUKVPHoouqyby0aqNc8rBYrQwmUdeG0YCtYjrhqBb4b8Stei26HEC
        lB0bqN2q/+Tp19sbvAK/C2yXRQ==
X-Google-Smtp-Source: AK7set/KtsdZ5QvOnD207HGK/GPOKhP0Iw7I8E7r8x/znbH1dddeENqolHIO3TbjhxOLLri6889iqQ==
X-Received: by 2002:a17:907:6d8a:b0:93d:9b73:f07a with SMTP id sb10-20020a1709076d8a00b0093d9b73f07amr546097ejc.0.1679584647585;
        Thu, 23 Mar 2023 08:17:27 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id g4-20020a170906520400b0093a35f65a30sm3628548ejm.41.2023.03.23.08.17.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 08:17:27 -0700 (PDT)
Message-ID: <95bd909b-439d-1165-1a8e-d1df1fab9f76@blackwall.org>
Date:   Thu, 23 Mar 2023 17:17:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH iproute2-next 2/7] bridge: mdb: Add underlay destination
 IP support
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230321130127.264822-1-idosch@nvidia.com>
 <20230321130127.264822-3-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230321130127.264822-3-idosch@nvidia.com>
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
> Allow user space to program and view VXLAN MDB entries. Specifically,
> add support for the 'MDBE_ATTR_DST' and 'MDBA_MDB_EATTR_DST' attributes
> in request and response messages, respectively.
> 
> The attributes encode the IP address of the destination VXLAN tunnel
> endpoint where multicast receivers for the specified multicast flow
> reside.
> 
> Multiple destinations can be added for each flow.
> 
> Example:
> 
>  # bridge mdb add dev vxlan0 port vxlan0 grp 239.1.1.1 permanent dst 198.51.100.1
>  # bridge mdb add dev vxlan0 port vxlan0 grp 239.1.1.1 permanent dst 192.0.2.1
> 
>  $ bridge -d -s mdb show
>  dev vxlan0 port vxlan0 grp 239.1.1.1 permanent filter_mode exclude proto static dst 192.0.2.1    0.00
>  dev vxlan0 port vxlan0 grp 239.1.1.1 permanent filter_mode exclude proto static dst 198.51.100.1    0.00
> 
>  $ bridge -d -s -j -p mdb show
>  [ {
>          "mdb": [ {
>                  "index": 15,
>                  "dev": "vxlan0",
>                  "port": "vxlan0",
>                  "grp": "239.1.1.1",
>                  "state": "permanent",
>                  "filter_mode": "exclude",
>                  "protocol": "static",
>                  "flags": [ ],
>                  "dst": "192.0.2.1",
>                  "timer": "   0.00"
>              },{
>                  "index": 15,
>                  "dev": "vxlan0",
>                  "port": "vxlan0",
>                  "grp": "239.1.1.1",
>                  "state": "permanent",
>                  "filter_mode": "exclude",
>                  "protocol": "static",
>                  "flags": [ ],
>                  "dst": "198.51.100.1",
>                  "timer": "   0.00"
>              } ],
>          "router": {}
>      } ]
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  bridge/mdb.c      | 51 +++++++++++++++++++++++++++++++++++++++++++++--
>  man/man8/bridge.8 | 15 +++++++++++++-
>  2 files changed, 63 insertions(+), 3 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


