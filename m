Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A586B91EC
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjCNLno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjCNLnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:43:43 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C5F9C9AB
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:43:14 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id p4so7856033wre.11
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678794192;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MCrsF1Bkt9UxCTo/05ahhMR6IA2FanOVtp8JvR2CXcc=;
        b=mRixeqMfSYUD/Ww8F7phJ61EE22o699N+ef7bjGAnnpvqg78eN/3vGhiV/g1Ak7qyJ
         EgObHJqU9BxCXL3+eu11BJBn62LAr0sNifx1p2Iudhx5lAIK1Kz3+HRBg2XLWoDVzqmC
         IHW+P9HQje9rVz8XbDBi+tfyCs6Z/qV1OH7EzBFNOdvHBfrYwrdN/0BobmqzVj5HDnpn
         9Tryc8C7qp8ACWJ2j+3STRCtSQO8X4qdF4QU0TqpdYIPJSy/TobUn98OlpLpqc+X8ckq
         /yB4fwRZSuc9B6pPlZTv4NXbQcwdKaOtEU6xXfvQHoLwuWGSB4LAqwg97KAA7oXt09hw
         xJnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678794192;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MCrsF1Bkt9UxCTo/05ahhMR6IA2FanOVtp8JvR2CXcc=;
        b=QU+xVEkYQX4PeyyVs8RMtIhrqmobiwcpauRlExStV9DAluO4PiAc+PerbqHeebcxfM
         58GTJKQNOzf3ARVQHvYqimpQysP6kbDjT8hMcoOvs+SoxklXbrKH+CSHdDeIcS0pY454
         NWopWQ63v8CqEbcmckR9xckFD5EazXkZSbwEPgzaev4lT0NVBtFRldzLOhdcOH6tKXm6
         Moued7XUW92XlLcCgEsTZteBe0zAGRccTYqd8PBSLvf7Gq1AokZ7UvzgArZ9DYebDvIh
         EGn54JC4ebOJkjSHaTf/iezzF6ZwhW3BbDAeXZqqelYyRXDg2JvN+WdlSkQgERj00xmL
         tq3w==
X-Gm-Message-State: AO0yUKWZBrGmeG6YGVRHzWcgncLSDCbUxikLbCkz0eeQ83xECPI4vG7x
        ZaMjlQgTPiyVAfqKNUvjQf1Qwg==
X-Google-Smtp-Source: AK7set9/7mFutLCjFLkQdwPNg7UOCH5RjV1NNkq8p0eHzVDka8cX3XPm06RYa/8xSb94GCko7azR4A==
X-Received: by 2002:a5d:6504:0:b0:2ce:3e8d:1e3 with SMTP id x4-20020a5d6504000000b002ce3e8d01e3mr25849977wru.46.1678794192618;
        Tue, 14 Mar 2023 04:43:12 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id c15-20020adfef4f000000b002c55ec7f661sm1984443wrp.5.2023.03.14.04.43.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 04:43:12 -0700 (PDT)
Message-ID: <d4a39646-ed81-d900-6cd7-a87c561f8049@blackwall.org>
Date:   Tue, 14 Mar 2023 13:43:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 02/11] bridge: mcast: Implement MDB net device
 operations
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230313145349.3557231-1-idosch@nvidia.com>
 <20230313145349.3557231-3-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230313145349.3557231-3-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2023 16:53, Ido Schimmel wrote:
> Implement the previously added MDB net device operations in the bridge
> driver so that they could be invoked by core rtnetlink code in the next
> patch.
> 
> The operations are identical to the existing br_mdb_{dump,add,del}
> functions. The '_new' suffix will be removed in the next patch. The
> functions are re-implemented in this patch to make the conversion in the
> next patch easier to review.
> 
> Add dummy implementations when 'CONFIG_BRIDGE_IGMP_SNOOPING' is
> disabled, so that an error will be returned to user space when it is
> trying to add or delete an MDB entry. This is consistent with existing
> behavior where the bridge driver does not even register rtnetlink
> handlers for RTM_{NEW,DEL,GET}MDB messages when this Kconfig option is
> disabled.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_device.c  |   3 +
>  net/bridge/br_mdb.c     | 124 ++++++++++++++++++++++++++++++++++++++++
>  net/bridge/br_private.h |  25 ++++++++
>  3 files changed, 152 insertions(+)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


