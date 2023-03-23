Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C56B6C6C1A
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 16:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbjCWPSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 11:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbjCWPSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 11:18:21 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A1B1CBFB
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:18:20 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id r11so88151463edd.5
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1679584699;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9S5Cgrh/Ty40MQJniH5ncaBpS0dpfEEhUQD1FhO0y6I=;
        b=UpIoVliFStBtczIgsvOS9Qy394P/mSLPIZmhBpYcMdw+noyVW4mfupdgUHgclOcXvr
         CiD0LiqCom0DPZHOqTcD+GvgBt//YL/yIuaTCnts2aKHi53xXPHccaw1HlEbdJdQib19
         OlxVb5YbNPTSgRSqM3ofsAnUjEmEHSScu0ZcyReQ6VZjeAMR5TKfS7130s+O3TmvZH+D
         vPhKJuvRMeJwKQI6HPNb4JTNni0pbOumPTnHk3Y+mav094a6WI86tBeM4Gl1utGbSYMg
         GueTMVrTgOKnw9+vd7ncD6Mwaf8q2GQCnpIx9ekcw93v+4g3QlwTO7ZR7ti10YuDc9CM
         NGGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679584699;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9S5Cgrh/Ty40MQJniH5ncaBpS0dpfEEhUQD1FhO0y6I=;
        b=CHX8/KxTuewp41vU5qVNUKoutjQsJIWywteLkbpLVrUi0XXvRVFniVbdpgp5RpMvHJ
         vhacGLODInoLkFa7zy/5ktO5QqTomRMHPSI5HfL0nmM8USOcbgG6K3jXrnvOpb+fu6H+
         BIjTyOr+XwYtBWlYJiBhKyr+rgEyeZeQSPyTWvudQKGYbGLSaQo+mjXgP3GdRm4gbVCi
         Hy7bc6qZilDAvI+j2HobEgvSAWWrzULrIKAy6MKDHhRO1uX6eDpONJESk817ti+iCL/G
         pOT6uu08lJh55pY87wsRCIw6+W+wbKzGo0U8ITy6PrIRgXOm+/6jsTFP6rWCgvxkxpw5
         Yn0A==
X-Gm-Message-State: AO0yUKVYxpPf0j2qERJ/VKCFlYgp16rANW3LsbeSjBPS7hOnxPqh4EeG
        Ux2wjFsHKWAE1pS42CpMwxABBw==
X-Google-Smtp-Source: AK7set+UAnYgf4cvD4p76dTK9+QpgH6v49kD5IdOZ5ZoEH6gYUOQEepvq/RX/TnaU7VWgCgxUpTtPg==
X-Received: by 2002:a17:906:95a:b0:87b:d60a:fcbb with SMTP id j26-20020a170906095a00b0087bd60afcbbmr11653972ejd.47.1679584699293;
        Thu, 23 Mar 2023 08:18:19 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id u6-20020a50d506000000b004fd2aab4953sm9376081edi.45.2023.03.23.08.18.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 08:18:19 -0700 (PDT)
Message-ID: <d5df68ec-8edf-e12c-48a8-832304716d67@blackwall.org>
Date:   Thu, 23 Mar 2023 17:18:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH iproute2-next 3/7] bridge: mdb: Add UDP destination port
 support
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230321130127.264822-1-idosch@nvidia.com>
 <20230321130127.264822-4-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230321130127.264822-4-idosch@nvidia.com>
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
> and view the UDP destination port of VXLAN MDB entries. Specifically,
> add support for the 'MDBE_ATTR_DST_PORT' and 'MDBA_MDB_EATTR_DST_PORT'
> attributes in request and response messages, respectively.
> 
> Use the keyword "dst_port" instead of "port" as the latter is already
> used to specify the net device associated with the MDB entry.
> 
> Example:
> 
>  # bridge mdb add dev vxlan0 port vxlan0 grp 239.1.1.1 permanent dst 198.51.100.1 dst_port 1234
> 
>  $ bridge -d -s mdb show
>  dev vxlan0 port vxlan0 grp 239.1.1.1 permanent filter_mode exclude proto static dst 198.51.100.1 dst_port 1234    0.00
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
>                  "dst": "198.51.100.1",
>                  "dst_port": 1234,
>                  "timer": "   0.00"
>              } ],
>          "router": {}
>      } ]
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  bridge/mdb.c      | 40 ++++++++++++++++++++++++++++++++++++++++
>  man/man8/bridge.8 | 10 +++++++++-
>  2 files changed, 49 insertions(+), 1 deletion(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


