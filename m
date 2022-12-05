Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CB86427B8
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbiLELm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbiLELmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:42:16 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAF119C20
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 03:41:44 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ml11so27102304ejb.6
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 03:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=knyyPlNbBxcU+qJ0FVDjA2Jr+aOD9AGR8p2XI9iZKlA=;
        b=sP0PT5QlxzUm2mdQs2yeqeVnGD/bCIXNEYE7DgEWFvImqA2UtrKcxkxcsz+kjVAlNB
         xmDrQiUN30zBjZ3KcAbEiOEJym5cF/GxeFBV2d1sS5/dNIn7VyZ7yXDkNyV24XHHu9wE
         l1F1+yspsGkw743BRWBxMuLl1lnfwBtAhGFtw9CdhlP5N6oiNvN6SjvsrwZNTl9Ea1yP
         Ae+uWNI9EMRlDqwtqtMKDwrCqx7m0/xK22qjcCVc4uU/R2fPYBzxHugsO+VJh1LMnB6c
         5ToSgPUCQ82FQmuqb76W/GDzY5oVOBLlhGd/Ml07Ik8V89QwgTPfWrNa6EAuv0bGmRUl
         RUkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=knyyPlNbBxcU+qJ0FVDjA2Jr+aOD9AGR8p2XI9iZKlA=;
        b=n+NhRGAmlKpMOPzcdrKVJHXyIP1QOO++0pkwF3EXATTbOy+y1UQ+oMjXOI1XcdPy0s
         GiLVxnPbJG8S9YFrY32N6dm91xHfwLAWx5CgRPq/AVBdP+esZ8ePXdOuRbXhy7iQpNO1
         2bE1RSrlLxUePGFelUsKORSwY5q1mJ80eoyPOONjOJs/fGvTg7CGLjlNmPcInYKpjmyf
         KIw8d0ROOmPhFw5Pxdo+asfA3LqbdYCNtv+1CBpfMFpc6MhPQSrKzQYE0JBOQ8P6vfFH
         7JYre/6AunZ6G2rFqxA2t1w6/epiuNLzgVb2cwMIkXF6+GyzMUfWZ/++1mxbieFjTBIx
         cPgw==
X-Gm-Message-State: ANoB5pmif29mM3Z14NEqWsX+aBrqs2zSNuQcKE5tfQmEfEWQWf36uKxv
        W+iWyvSdVdWJY7b0bkELvc55WQ==
X-Google-Smtp-Source: AA0mqf4bTmxPBnLfpIfTKbXfHkkQFWBx2UZrRTT9ua8aHfhHGyYG80g7p0UsYU2ME9pSr/Ic63PFxA==
X-Received: by 2002:a17:906:774e:b0:782:55de:4fcf with SMTP id o14-20020a170906774e00b0078255de4fcfmr69104958ejn.85.1670240502803;
        Mon, 05 Dec 2022 03:41:42 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id k13-20020a170906680d00b007c0f2d051f4sm1319981ejr.203.2022.12.05.03.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 03:41:42 -0800 (PST)
Message-ID: <729a8f5b-1a4e-1838-93e0-27ac814bb015@blackwall.org>
Date:   Mon, 5 Dec 2022 13:41:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 5/8] bridge: mcast: Use MDB group key from
 configuration structure
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221205074251.4049275-1-idosch@nvidia.com>
 <20221205074251.4049275-6-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221205074251.4049275-6-idosch@nvidia.com>
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
> The MDB group key (i.e., {source, destination, protocol, VID}) is
> currently determined under the multicast lock from the netlink
> attributes. Instead, use the group key from the MDB configuration
> structure that was prepared before acquiring the lock.
> 
> No functional changes intended.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_mdb.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


