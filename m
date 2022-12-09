Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A8C647E98
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiLIHcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiLIHbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:31:42 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DE56312
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 23:30:24 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id bx10so4342143wrb.0
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 23:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e8ok8dp6S7YvgkcFRjV3Iy77BKsNsOh23uWLYPjfni4=;
        b=HqdUkj4Sr3Sjf0oIj/n7uWMxpYgSghv876bfGCbd0v/QlQobwmMHTLVqR8Y+geJER9
         Peno6DmUNhOXOEayXlJmxNoUFRTJpM2fwAuJzljCg6KaDJ6lWQ37Th+FrqZWBlNWBZu6
         Px301IalmUidhxrEna0DytuK2nt0ozmzIL7NkIqsUEoCf8B6NjKPeDdIz+lWH4Gkf8sX
         9N50Jx0dfFp6wJlanN6iC9TXlZAK7AEjO6MC17Q5xjOGqc2qak1Rv5FdUuBvHyvIYrfm
         zHsQiJg3QmFj3vh+JxBdrP8eidG+5y6deGD815Di6RhwAdmrccjCcyDYCFXNcYc/rRMu
         8NYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e8ok8dp6S7YvgkcFRjV3Iy77BKsNsOh23uWLYPjfni4=;
        b=wYrKGblaf0E9iHG7Ajc8zH6+VryCcnbsMOc3+ePHDni333fEw9K0Jdz4jbIyQEkt8c
         ZzrSTe4fhRmnTbTVFO3JSB5JPFvHS+SrYq8WDHm0FS73c1FZ+GfT2/3gIckz85shu/O8
         fBOXQLv9fWUucc8jOeSV/UR9TfUFhhqwyG+aAoaNJo1bodtOr9cL9VdEXutUNbqllmXq
         qhOJTaOTIg4cQeumBLZLsEmw0bZAXXEOpCJRq8q7eRF5rmut9/s2iA6ROHSS2qZESgnv
         AnrF8V2GYKjAbet4DhV5DZ+teHbUN0L8zYwGpT1U4FihWAZbZwEuWrol956mBgGg/swz
         b79Q==
X-Gm-Message-State: ANoB5pnbZOZCrOsn6IdfLLkeMvKx0nSlc4DvezOSJbKCOhtgxLxWXBCj
        dwc5BKqgSon5ctbrBNWCTt/9kA==
X-Google-Smtp-Source: AA0mqf4vFxC0TQkwfzHb9izTIv86s8znirs7oYyFppPMb+ac0rtZ40JVkpQqZhkEU93whSAX20rfAQ==
X-Received: by 2002:adf:e345:0:b0:236:7215:44a5 with SMTP id n5-20020adfe345000000b00236721544a5mr2846869wrj.32.1670571022638;
        Thu, 08 Dec 2022 23:30:22 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id z9-20020a5d4c89000000b0022cc3e67fc5sm643328wrs.65.2022.12.08.23.30.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 23:30:22 -0800 (PST)
Message-ID: <2fa88776-fc7e-564c-18d9-83c75414b838@blackwall.org>
Date:   Fri, 9 Dec 2022 09:30:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 04/14] bridge: mcast: Add a centralized error
 path
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221208152839.1016350-1-idosch@nvidia.com>
 <20221208152839.1016350-5-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221208152839.1016350-5-idosch@nvidia.com>
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

On 08/12/2022 17:28, Ido Schimmel wrote:
> Subsequent patches will add memory allocations in br_mdb_config_init()
> as the MDB configuration structure will include a linked list of source
> entries. This memory will need to be freed regardless if br_mdb_add()
> succeeded or failed.
> 
> As a preparation for this change, add a centralized error path where the
> memory will be freed.
> 
> Note that br_mdb_del() already has one error path and therefore does not
> require any changes.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_mdb.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


