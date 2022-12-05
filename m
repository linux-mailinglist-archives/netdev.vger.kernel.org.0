Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E58642794
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbiLELfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiLELfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:35:37 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B557E193F5
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 03:35:36 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id ml11so27063726ejb.6
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 03:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p+lqCtUO2T8WzhIulXM5wgSeAQF83+0Hc2/jw5pbOGc=;
        b=lwdFTnA19ae+IgrYYz/npsYg4z4drRSms+h2HFXJ65hnj8HMzdJYauBUW5aca1nO9d
         SJNZ8J6dGdurvnrtyJU6u6AypJeexiE674nw0ITpZjMuapYtAvMJlCVaMsDP7bXJ2b+7
         oxN082d4/0bTMmJz3ngMMQxzcsYnYXPnFtmFYW/031sACWF77KK6yVA4pexvnDVHP37N
         Q7QGePxMKEx+WICz6lc4RsZ2LjBio8szNqEDHppgtcFSQ193VvgS2K41nIOCoa5VaURa
         pwLwjb4QHB4asK+nNqrXxNiRogzhLgaXaL30/4MMswEVVR/lhus3XjBJMZL18yl5GTpZ
         EBhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p+lqCtUO2T8WzhIulXM5wgSeAQF83+0Hc2/jw5pbOGc=;
        b=Zeplr40pjtvFViHzB+jLrcCxbxiBWgn5WG+JGLcGzRhKcdSGezzsssijy/d1fJ212j
         ijmykTMeTbotZ07GG8AbqAYYoJI20AY9BIwabRzDj35XpVvVWy7vrF0NE4er+D37KTCa
         jUiCM4+dXydiPzoxbpDI4koh6rdO72XVHUHZBSWrMaYFeF3EnB75ysteFTNO/t0/YSSg
         2WvIQpX/+7+HPEgsC2xdqgE7QdOeIdYtuTQ4X6F1hkdC+TWgHcruQsp3YC+LoRwCEVzP
         IbHO/GdulMRPvRJaoALkvv+iSLo6WqIyZe/3UnHOa6YebKSjbvPxwE2fR+qkM5oCg4y3
         cSBQ==
X-Gm-Message-State: ANoB5pniH+AZnAJlQfNBMmm/l5XdciqjQ1erojqkHE1oWDo1Btk3Sq3x
        MnlUO/dwLJDpyUwZhcs9CzYJrg==
X-Google-Smtp-Source: AA0mqf76r0I1QoL3RWx6mDzICgB8yYXYA+FECzos5QTD298Yo9rl8UzmMZXYT4AeYyh9b+swxXtQQQ==
X-Received: by 2002:a17:907:8b8d:b0:7c0:7dfb:ed4f with SMTP id tb13-20020a1709078b8d00b007c07dfbed4fmr22895394ejc.2.1670240135140;
        Mon, 05 Dec 2022 03:35:35 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id bj15-20020a170906b04f00b007b5903e595bsm6113647ejb.84.2022.12.05.03.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 03:35:34 -0800 (PST)
Message-ID: <b83faf19-ec08-c009-572c-4c9868155ed6@blackwall.org>
Date:   Mon, 5 Dec 2022 13:35:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 3/8] bridge: mcast: Use MDB configuration
 structure where possible
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221205074251.4049275-1-idosch@nvidia.com>
 <20221205074251.4049275-4-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221205074251.4049275-4-idosch@nvidia.com>
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
> The MDB configuration structure (i.e., struct br_mdb_config) now
> includes all the necessary information from the parsed RTM_{NEW,DEL}MDB
> netlink messages, so use it.
> 
> This will later allow us to delete the calls to br_mdb_parse() from
> br_mdb_add() and br_mdb_del().
> 
> No functional changes intended.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_mdb.c | 34 +++++++++++++++-------------------
>  1 file changed, 15 insertions(+), 19 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


