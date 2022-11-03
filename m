Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B1E617C1B
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 13:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbiKCMDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 08:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiKCMDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 08:03:47 -0400
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC1F12A8D;
        Thu,  3 Nov 2022 05:03:44 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id j15so2453652wrq.3;
        Thu, 03 Nov 2022 05:03:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=frMmRWbz+CrWSwXHd1wJhRWogqGhZzQQP8lyso7wOSg=;
        b=oqkQBVkDIs3ZZy4zdoXzDY65VYBxo6sYIkazKn+pWPrxDU/sv3GbFsNZkREGyn+1oB
         r5crBiyxDYeIx0l6ZVu7Yc5kb53OugbSPzmDOHxqsvdnjIf1CV3t+HWouJ0ODgcQzmuJ
         3aOGj6SxE9C6d6NjAu3rnoljLEtDAxSpAFjOQNXPsUk62jqsXgx031NA/c9rE3Z04lok
         AN6WGzj4FWudqv4F7vpZZaq7jqlZI+bLawyCVbOuS2wzxPQdJcYeMjnfcQ2YhGeuaWsw
         uOeaCXjx1ellSpEPR7v466pDe1cE1HImpuOReKXXwV7zS4jduvNBx7l8Q/K+9jgmUB0e
         L+HQ==
X-Gm-Message-State: ACrzQf1GY320QHxN49rM76hEC8qhHoalQAuTadha/w9nlNz397Nrr84R
        j66lJ8ol64Z0ust2kE2us8k=
X-Google-Smtp-Source: AMsMyM7mOpiAGdP3bMUTH4qm2eG3uGGD+AF28LOaryDBJl0zkEaKdVJwqta2ulDwD21Y5KVQVqxwyw==
X-Received: by 2002:a5d:62cd:0:b0:236:6ea0:a609 with SMTP id o13-20020a5d62cd000000b002366ea0a609mr17472410wrv.508.1667477023312;
        Thu, 03 Nov 2022 05:03:43 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id c4-20020a05600c0a4400b003cf894c05e4sm3778568wmq.22.2022.11.03.05.03.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 05:03:42 -0700 (PDT)
Message-ID: <bf584d22-8aca-3867-5e3a-489d62a61929@kernel.org>
Date:   Thu, 3 Nov 2022 13:03:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] i40e (gcc13): synchronize allocate/free functions return
 type & values
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jesse.brandeburg@intel.com, linux-kernel@vger.kernel.org,
        Martin Liska <mliska@suse.cz>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
References: <20221031114456.10482-1-jirislaby@kernel.org>
 <20221102204110.26a6f021@kernel.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20221102204110.26a6f021@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03. 11. 22, 4:41, Jakub Kicinski wrote:
> On Mon, 31 Oct 2022 12:44:56 +0100 Jiri Slaby (SUSE) wrote:
>> I.e. the type of their return value in the definition is int, while the
>> declaration spell enum i40e_status. Synchronize the definitions to the
>> latter.
>>
>> And make sure proper values are returned. I.e. I40E_SUCCESS and not 0,
>> I40E_ERR_NO_MEMORY and not -ENOMEM.
> 
> Let's go the opposite way, towards using standard errno.

This is propagated several layers up throughout the whole i40e driver. 
It would be a mass change which I'd rather leave up to the driver 
maintainers -- I don't even have the HW to test.

thanks,
-- 
js

