Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8351618DD4
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 02:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiKDB4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 21:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKDB4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 21:56:54 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A6A23BC1;
        Thu,  3 Nov 2022 18:56:53 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id r18so3194050pgr.12;
        Thu, 03 Nov 2022 18:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hahG+pLLvNBwFEBQ4n5uEz0JMPGbGNZS4G8tloHlXys=;
        b=fQieufBaPR5Vfx3aHT2A+hECFy+epZR7J9MBUCkKBSbKp7SzKd7APQNsl9LmkIiUJd
         bHZ6cutHHv77CTjNXtMFndRyED0FjhM7iwE9uvJCqadAUsyBeGDSR24/ficQ6Iioxi5Y
         TWtSveqdX7zNtgfocAJmHv+6wzgM4TYPNs1jc1lqxRVTbuFZZqwnTNYuH3oBS70gFp36
         LQrpWyOCoZGY/L2PxmZTGE5Da8oT5ICpA3LMNV8X4LkvOjoOkSmhRxDHV+ZTFIddltIu
         qKYZ1Wmaiabaz3q7HKxjcsLoRC0NkHF5C37RIlS05ij7OeI9imxOQf4M7A/KZBDtOq52
         XRkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hahG+pLLvNBwFEBQ4n5uEz0JMPGbGNZS4G8tloHlXys=;
        b=vh50iXyrShzQVtg3IcGHKejiJDyVUzoD+Rj/Y53Aiqe7GECAqv2clj9t1nykv1isdt
         z32ZqcGooJ1JA3mk77mWBbF5kL5ws/yWPCjg98XO5UmdEyC7H7tKo/F6YgzGM1Ycgm07
         thQl1xUPLzFagCCNs1NJcwR2LizePKZXOybeVwOV7IcxTzsFViZR658vj8H3b1XgK8rg
         Bt2x9JC6aq4ET4oUwS5lvmPNYWwTFEhbZH0iot8TLor5ZYzEq4DNPRIkOocqEMpcG3/U
         WzTAgtkwaIGc8ZfYwVVVfuiLYFk/M+DOjwTAIWdHUddLw3PIN5lUCql75qNz4DB0R7BZ
         DOug==
X-Gm-Message-State: ACrzQf2x8s+HDWvGIisGGFttdjvDsA0j2h5w/KB5OD4TNzdEW6+MNtoG
        fEo+cm6XKSWQfsoVprmCwQA=
X-Google-Smtp-Source: AMsMyM514Rzfez2LlvAOJyeCSzSo1LRgwHZqVOuz/boBq4HQF0nFwG7jdbC65MnoOGtU7l7Pf6vpYA==
X-Received: by 2002:aa7:951d:0:b0:56b:9937:c749 with SMTP id b29-20020aa7951d000000b0056b9937c749mr33298542pfp.78.1667527013347;
        Thu, 03 Nov 2022 18:56:53 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-15.three.co.id. [180.214.232.15])
        by smtp.gmail.com with ESMTPSA id u10-20020a654c0a000000b0045751ef6423sm1329787pgq.87.2022.11.03.18.56.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 18:56:53 -0700 (PDT)
Message-ID: <b680a914-ad3c-4167-1108-2e2db633609b@gmail.com>
Date:   Fri, 4 Nov 2022 08:56:46 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net-next] net/core: Allow live renaming when an interface
 is up
Content-Language: en-US
To:     Andy Ren <andy.ren@getcruise.com>, netdev@vger.kernel.org
Cc:     richardbgobert@gmail.com, davem@davemloft.net,
        wsa+renesas@sang-engineering.com, edumazet@google.com,
        petrm@nvidia.com, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, andrew@lunn.ch, dsahern@gmail.com,
        sthemmin@microsoft.com, idosch@idosch.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        roman.gushchin@linux.dev
References: <20221103235847.3919772-1-andy.ren@getcruise.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20221103235847.3919772-1-andy.ren@getcruise.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/22 06:58, Andy Ren wrote:
> This patch allows a network interface to be renamed when the interface
> is up.
> 
> Live renaming was added as a failover in the past, and there has been no
> arising issues of user space breaking. Furthermore, it seems that this
> flag was added because in the past, IOCTL was used for renaming, which
> would not notify the user space. Nowadays, it appears that the user
> space receives notifications regardless of the state of the network
> device (e.g. rtnetlink_event()). The listeners for NETDEV_CHANGENAME
> also do not strictly ensure that the netdev is up or not.
> 
> Hence, this patch seeks to remove the live renaming flag and checks due
> to the aforementioned reasons.
> 
> The changes are of following:
> - Remove IFF_LIVE_RENAME_OK flag declarations
> - Remove check in dev_change_name that checks whether device is up and
> if IFF_LIVE_RENAME_OK is set by the network device's priv_flags
> - Remove references of IFF_LIVE_RENAME_OK in the failover module
> 

You have sent the patch twice, yet with same content ([1] and [2]),
so I reply to this latter version instead.

Please write the patch description in imperative mood ("make foo do
bar") instead of descriptive one like you have written ("this patch/commit
makes foo do bar").

Thanks.

[1]: https://lore.kernel.org/linux-doc/20221103224644.3806447-1-andy.ren@getcruise.com/
[2]: https://lore.kernel.org/linux-doc/20221103235847.3919772-1-andy.ren@getcruise.com/

-- 
An old man doll... just what I always wanted! - Clara

