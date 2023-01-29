Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D187667FDC3
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 10:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjA2JLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 04:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjA2JLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 04:11:13 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7CD1F4BB
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 01:11:12 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id qw12so8221304ejc.2
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 01:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/RrG8+2GzDsOsAIBF6eDzsvs9rII5iqkY1XaHqvkNRg=;
        b=slB4v7GfVVCDKkd+LJ+iBUuWRbUMJzf+9V/umfjvfn8r/EK/HE2dtoLYOvczDJl4AT
         W2alqhgdM1dfXBd8EDCgdSKkUtWcv9QNOpf9Mn1pi2wiJ3uUbb1GPB6cmNv2cXq3bYy/
         Co+Emm+vLCcV4V+j16kQd6sGcpP2nuSN2lZJ7x1PY1kw5OjkaNeOzCeYnPP25Q/H1bgR
         /X54LttEtS0bqwqhNFPHV8vjcX/MZzHAeZRPGahxKaun4MgZvgFJZ5bG8+xsl0eWUOsj
         cBphYCbGP72AcAAcDYcV/FAviHdfUzdU6Yv3yF/VqDrzH3WaQ6/6RCt55+9H98Y193Dd
         vVXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/RrG8+2GzDsOsAIBF6eDzsvs9rII5iqkY1XaHqvkNRg=;
        b=EGHdDwINH2TXn1zgZxA3Ua59SRiAgsppzkCGnhN4yFUjH1C7mvkYhNh9RNt/5FK9SO
         0zCKw7nbMu08u06QJU+MM9N59QLbT6BnkoAL5wSwZ6pk3X1R3fi1VwY0bPspmzoTUEW3
         XXL9/PItXs1cQO0nhAUzIB6WzS8nILUu9JHEo0RVnqN7CRE7akaH7RAUX4nn3d26gnA2
         msWmZ4DTQ4tCuKOtgRphtilIE1dAAXBnGf/7J5LMyMPxT+NHbiSufqq08NJ7GAQrdbP0
         /AhSRFB0VyeeDA8rX5NH66ZeUwH0ci86CJYUGbFb0iCALKEUhsuiDAEVsyq2TUcLO8jT
         yOSA==
X-Gm-Message-State: AFqh2kr9jq6NGnTECSir72WAPKRkoH3RtKGa/ijKPEk8bFI8rb0FWnoa
        zxXGYbNYMqGhRgS4+EPDi+kwUw==
X-Google-Smtp-Source: AMrXdXtdgPdpiT8m7xlb7FaVRLf9lqQZIsBZ3pOQZx95/5iYXJp9QBinPvbnALRe4PJ3NLRA5PiecQ==
X-Received: by 2002:a17:907:88cd:b0:859:5541:f3ff with SMTP id rq13-20020a17090788cd00b008595541f3ffmr54286534ejc.32.1674983471373;
        Sun, 29 Jan 2023 01:11:11 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id lv1-20020a170906bc8100b00883ec4c63e0sm1747321ejb.142.2023.01.29.01.11.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 01:11:11 -0800 (PST)
Message-ID: <d4190cd6-f90f-ac51-1c1e-ddd0880e932c@blackwall.org>
Date:   Sun, 29 Jan 2023 11:11:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next 04/16] net: bridge: Add
 br_multicast_del_port_group()
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
 <982c17c28b513bd3e6dd670fa2db13ec76bc4460.1674752051.git.petrm@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <982c17c28b513bd3e6dd670fa2db13ec76bc4460.1674752051.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2023 19:01, Petr Machata wrote:
> Since cleaning up the effects of br_multicast_new_port_group() just
> consists of delisting and freeing the memory, the function
> br_mdb_add_group_star_g() inlines the corresponding code. In the following
> patches, number of per-port and per-port-VLAN MDB entries is going to be
> maintained, and that counter will have to be updated. Because that logic
> is going to be hidden in the br_multicast module, introduce a new hook
> intended to again remove a newly-created group.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_mdb.c       |  3 +--
>  net/bridge/br_multicast.c | 11 +++++++++++
>  net/bridge/br_private.h   |  1 +
>  3 files changed, 13 insertions(+), 2 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


