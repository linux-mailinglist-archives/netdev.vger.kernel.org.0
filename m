Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DAC64EB31
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 13:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiLPMG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 07:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLPMG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 07:06:26 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7411C17A8C
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 04:06:23 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id z92so3361274ede.1
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 04:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pgV8RCm4+hYPRPje6zQTh241lxqy5Y0HFoLr5H04sTE=;
        b=rdp75VwGNxLgoZml9FMBxNJkoU5j6PzSHUuxSO0TN6ziCLZJnoLtodrKTrtVq6lpWJ
         NaroJ4Z6pQJW1gPhhDwKyFx9jA4HASWN7GXfvrdmNP2VUaf9RcCcIsbjj5EyCLGKdeM1
         YXThCRHE7YYnAHtG1pDY7ZsZyRAyApa6qnI4H7pKwbwHoTWQmLigEBaWKtJGF609SOvX
         /a+a7hRoo9qQoGhdwUntDoSzO0ASPqT8ZYtqFl+078QQhifp4qSF+eEIdvHoRXI4OhW8
         d/4Gm1mALmrGKfI+Q+WwpDgMsIg8GmlxOKFK1tgDjPj8wevRuRvKvkRgrylz+8JuZlv9
         sGjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pgV8RCm4+hYPRPje6zQTh241lxqy5Y0HFoLr5H04sTE=;
        b=68WLrDVQnBVJqcSJ8WD1Z5OdnVqnvyUSBMDHmjkZpkqmXDxx6ByU5S7ZpPIQ6H5emV
         RhLsA4GRjh6IFAK2dPwySTjFREkPTesZKCGXMb8I/nTEZCKuSXnQpO9s51ZA+4bMuvVR
         nfKRc6oh+Ge+SS5y2s84ju8HoVIJHbYrvS62iVGWJ92UalLfAlMuiqgOOGH0rNoZqf/U
         cMKVpJKIkN+q2G1j4fIAPNgrwm54Bz7SwkH6wNLskAjW5ENev+kmhiZntAJq8BDvc7xS
         Dpns0Y4OF+hVwh8eGVktpy1uAEbbqigJioluNzfCHQ1K+BELzEypveg/hZzCs6AU9Emu
         r2/g==
X-Gm-Message-State: ANoB5pmncGFnf5C8/a5hJSq1nzZ0v9vdjTaNCE/pj/4unY/Jm6pT/tbD
        uS4xdCUGgr6uhHVOUEV4qldgCw==
X-Google-Smtp-Source: AA0mqf74sWJqK3Nt+HGBT8QcyY7f3Dj0zDd43XK7zavF+hemZ/hFrMS0qBwnlXzUwumJAgPRBi8kzA==
X-Received: by 2002:a05:6402:5162:b0:46a:8d6:fefb with SMTP id d2-20020a056402516200b0046a08d6fefbmr29210883ede.42.1671192381959;
        Fri, 16 Dec 2022 04:06:21 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id e13-20020a056402148d00b004704658abebsm787347edv.54.2022.12.16.04.06.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 04:06:21 -0800 (PST)
Message-ID: <f1127553-6ec6-068d-3ce8-709f1169c210@blackwall.org>
Date:   Fri, 16 Dec 2022 14:06:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH iproute2-next 5/6] bridge: mdb: Add routing protocol
 support
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@nvidia.com
References: <20221215175230.1907938-1-idosch@nvidia.com>
 <20221215175230.1907938-6-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221215175230.1907938-6-idosch@nvidia.com>
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
> Allow user space to specify the routing protocol of the MDB port group
> entry by adding the 'MDBE_ATTR_RTPROT' attribute to the
> 'MDBA_SET_ENTRY_ATTRS' nest.
> 
> Examples:
> 
>  # bridge mdb add dev br0 port dummy10 grp 239.1.1.1 permanent proto zebra
> 
>  # bridge mdb add dev br0 port dummy10 grp 239.1.1.2 permanent
> 
>  # bridge -d mdb show
>  dev br0 port dummy10 grp 239.1.1.2 permanent filter_mode exclude proto static
>  dev br0 port dummy10 grp 239.1.1.1 permanent filter_mode exclude proto zebra
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  bridge/mdb.c      | 28 ++++++++++++++++++++++++++--
>  man/man8/bridge.8 | 12 +++++++++++-
>  2 files changed, 37 insertions(+), 3 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


