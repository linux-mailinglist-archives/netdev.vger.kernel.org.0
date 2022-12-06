Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363B8644330
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbiLFMcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbiLFMcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:32:13 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E677729819
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 04:32:04 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id c66so13750013edf.5
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 04:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UBQgxqUKfCeoRJwO5X9i5iROVCc9Ze5aifdNi+9+nK0=;
        b=60obe3wn8ih/Uj7kSxFY+m0RxFLo54cM0gyi0FOiEqw6dLyhg7SWhHKqDwdEJUrzM5
         bvvAb6OHLMnC/AstRbPOunffIBj8LP2a893XiHPvfjbA10N7ZEtqOnA5V9LUgs/BGJh1
         OEznEGwlxacgR65Ra+Z9FSHYiqR+RCqg6/4MaqXX4ajJF9M/vWmEFIINVwMo8mnmxf1W
         XsUNC+1TRXUttrczNQU8MWWv8oYBcNd6I3WaKbksiPdOYss5dzkPzXqQL1DbTdFAu6+E
         HZeANEspCm7/hgKmPS7K/9ciaI0MFs8rILewgp81yhOFmVypnliE3AvIPVRvFmuYLHqd
         FR7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UBQgxqUKfCeoRJwO5X9i5iROVCc9Ze5aifdNi+9+nK0=;
        b=osdWtUVcj/EDwUfUhDXxOKm5UmVptuH8Iu5XkHYLxQciDmwQFWEUR9OdfgYYX/xgDk
         YV/+6Wv+sttwxGXeTMiVEqBbqSK6XPF3TnlMjmUWvRWKQZoxlHtcAekFaS9RDqIJgBWP
         Hxoer6IDD4KDFmkgkTLDYJh4ZTfsx3m2DU3rxhzdmZYo97mcS+yf2vu+hCXJ35SCwz/p
         ZHPnoMCar/S8H4HoEIZX1ZA/LRcuyIyLJscMEXbEWxR6PhMbopGAF4vcmyaA2pBns7ht
         x2FVlQcykElqRO46Tc9bQgl08Q2XYNZlNEQEzjOTqfBraME/iYPtcf6m0+lL3PFoLhmh
         YZUA==
X-Gm-Message-State: ANoB5pmcbOwRK7tW8gG2MMGKCdboZLtzpcivMvVqNn+9qSn8aIgLYelJ
        yZrqZkfJECki7NC17r5bHJu79A==
X-Google-Smtp-Source: AA0mqf4FlSc6u/X8EbuiJjz6xZqQ2CvE8fRG9s8yz9LAFCgiXLH9QRMhJ37tIdrFFfo9daCnrZUqaA==
X-Received: by 2002:a05:6402:2b8c:b0:466:12a0:11f3 with SMTP id fj12-20020a0564022b8c00b0046612a011f3mr215891edb.22.1670329923223;
        Tue, 06 Dec 2022 04:32:03 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id u25-20020aa7db99000000b0046c7c3755a7sm931546edt.17.2022.12.06.04.32.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 04:32:02 -0800 (PST)
Message-ID: <35aefd47-937d-c4c9-8cab-697ea07d098f@blackwall.org>
Date:   Tue, 6 Dec 2022 14:32:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next v2 1/9] bridge: mcast: Centralize netlink
 attribute parsing
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221206105809.363767-1-idosch@nvidia.com>
 <20221206105809.363767-2-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221206105809.363767-2-idosch@nvidia.com>
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

On 06/12/2022 12:58, Ido Schimmel wrote:
> Netlink attributes are currently passed deep in the MDB creation call
> chain, making it difficult to add new attributes. In addition, some
> validity checks are performed under the multicast lock although they can
> be performed before it is ever acquired.
> 
> As a first step towards solving these issues, parse the RTM_{NEW,DEL}MDB
> messages into a configuration structure, relieving other functions from
> the need to handle raw netlink attributes.
> 
> Subsequent patches will convert the MDB code to use this configuration
> structure.
> 
> This is consistent with how other rtnetlink objects are handled, such as
> routes and nexthops.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v2:
>     * Remove 'skb' argument from br_mdb_config_init()
>     * Mark 'nlh' argument as 'const'.
> 

Thanks,
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


