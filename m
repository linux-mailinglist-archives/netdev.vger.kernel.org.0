Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADF264EB30
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 13:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiLPMF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 07:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLPMFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 07:05:52 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220DA13E26
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 04:05:50 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ud5so5679991ejc.4
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 04:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9ETQnHkfM93hFk6UCQO22tzLw8JVwXgr9/+uxrgjR7s=;
        b=ZvU3HaOy7JaB+kEGZq8KlS8ng8tm2bllaAEAvNCzVqJhQYKzXdjYe7i/1hdZTNTDuz
         m8PVTAepPrX2vfh9uDWFL/3hhZ/CpLr7Ea+hxuulSKGoQwRm0leaF6E+4i/VTyfhPjLT
         HF+/kgc2y/zGkj/WOTIN4EKfHuAl7x+0/PEsgpz1LLQqbCFHmQPnuho2opZk9efgPZ37
         jS52RNB+f2kaL6+KpE/ypbpyt9AtWwlA6Yhx8MdqTw2G0+b2gYcTdFaO/qdzkGxwchG8
         /qAMb70Cxa5Yr2l6Cc3T06H0wg02VtCPbTF6dksT4YuSZqA7fn5bkP+rtGzz1fHQ1xvF
         c1Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ETQnHkfM93hFk6UCQO22tzLw8JVwXgr9/+uxrgjR7s=;
        b=jw+3YcRie4/R7hzL+FhxRNJWPnGnNJCWNKM+MxAYeeesbPMUhFWUVmgah7chHFenDa
         ys33+x3dTQPKwR8wibhL3Qw7BHgLMw5NTk7nGfByIZHco69FyYG5pMacRBfMRi4Gp2vm
         jj+uUt46vln/7axknlERsrSKRQJLArWk7PvGyCXNEfFfaMuGyCofKozk02rRL57u6jKk
         9NmFnyKItAUd4jgpGRnsnDuHgGiW25PIYl+LfOcWLLAQFo/Wc/FFS5iAMvO17X3KaeH/
         r50ApeCjvGS63Chnb8D2qTDjqqO8sak9HplI+Dk09tCo28OpotktNY5f87jSgf9XJQA3
         vfdw==
X-Gm-Message-State: ANoB5pmKMG1Sz6NoX5cfq8nIdejSng7+qxQsOxzPyQ/d57LFFJ2327hT
        6ylGdTd8vMXB74ZcfACzxOWg6g==
X-Google-Smtp-Source: AA0mqf5Oa/r0+25YDpR3X/zulfdl88gkosM6qmsDJVX/+vKHzbw6bKngbt85JEq9CcNSIG8LROOZZg==
X-Received: by 2002:a17:907:a782:b0:7c1:6e82:35fc with SMTP id vx2-20020a170907a78200b007c16e8235fcmr31373536ejc.40.1671192348635;
        Fri, 16 Dec 2022 04:05:48 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id ia11-20020a170907a06b00b007ae32daf4b9sm769121ejc.106.2022.12.16.04.05.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 04:05:48 -0800 (PST)
Message-ID: <c91509bd-8ec0-13f7-97e2-5261fc222f36@blackwall.org>
Date:   Fri, 16 Dec 2022 14:05:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH iproute2-next 4/6] bridge: mdb: Add source list support
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@nvidia.com
References: <20221215175230.1907938-1-idosch@nvidia.com>
 <20221215175230.1907938-5-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221215175230.1907938-5-idosch@nvidia.com>
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

On 15/12/2022 19:52, Ido Schimmel wrote:
> Allow user space to specify the source list of (*, G) entries by adding
> the 'MDBE_ATTR_SRC_LIST' attribute to the 'MDBA_SET_ENTRY_ATTRS' nest.
> 
> Example:
> 
>  # bridge mdb add dev br0 port dummy10 grp 239.1.1.1 temp source_list 198.51.100.1,198.51.100.2 filter_mode exclude
> 
>  # bridge -d -s mdb show
>  dev br0 port dummy10 grp 239.1.1.1 src 198.51.100.2 temp filter_mode include proto static  blocked    0.00
>  dev br0 port dummy10 grp 239.1.1.1 src 198.51.100.1 temp filter_mode include proto static  blocked    0.00
>  dev br0 port dummy10 grp 239.1.1.1 temp filter_mode exclude source_list 198.51.100.2/0.00,198.51.100.1/0.00 proto static   256.42
> 
>  # bridge -j -p -d -s mdb show
>  [ {
>          "mdb": [ {
>                  "index": 10,
>                  "dev": "br0",
>                  "port": "dummy10",
>                  "grp": "239.1.1.1",
>                  "src": "198.51.100.2",
>                  "state": "temp",
>                  "filter_mode": "include",
>                  "protocol": "static",
>                  "flags": [ "blocked" ],
>                  "timer": "   0.00"
>              },{
>                  "index": 10,
>                  "dev": "br0",
>                  "port": "dummy10",
>                  "grp": "239.1.1.1",
>                  "src": "198.51.100.1",
>                  "state": "temp",
>                  "filter_mode": "include",
>                  "protocol": "static",
>                  "flags": [ "blocked" ],
>                  "timer": "   0.00"
>              },{
>              },{
>                  "index": 10,
>                  "dev": "br0",
>                  "port": "dummy10",
>                  "grp": "239.1.1.1",
>                  "state": "temp",
>                  "filter_mode": "exclude",
>                  "source_list": [ {
>                          "address": "198.51.100.2",
>                          "timer": "0.00"
>                      },{
>                          "address": "198.51.100.1",
>                          "timer": "0.00"
>                      } ],
>                  "protocol": "static",
>                  "flags": [ ],
>                  "timer": " 251.19"
>              } ],
>          "router": {}
>      } ]
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  bridge/mdb.c      | 58 ++++++++++++++++++++++++++++++++++++++++++++++-
>  man/man8/bridge.8 | 11 ++++++++-
>  2 files changed, 67 insertions(+), 2 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


