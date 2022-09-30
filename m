Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D7D5F150C
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 23:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbiI3Vk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 17:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiI3Vk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 17:40:26 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0926DCE9F
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:40:24 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id t4so3688503wmj.5
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=RuR/KFU9T2+sNr/GW8PYeOxx0r4SQ6Y0Y2jbdQIlacw=;
        b=K8COZx6eyEnZTVRbnvPdYkfnh9hP1uDqLo/ujRwer7ufv9FtD/KjxWeg4Y9jrVgH4j
         zZNwOFV54qDB5+xbXT58ThdyOV5ci+uz1wyA+Rsmc6hC7fMjdq08FIIE+QmkgEn4a5GD
         ZNTVNk84DMroW9922fUeTFflceMfBaY6gsmoBeV1QTIojoZpLOH9SNa4vSpdRQMsMvzz
         rOEUiw4AxKEx6FJsBHXvzkIOpwBv/tEZayDOaciG3bq7YqB7wbR+TK5Zfdj+2tQAOBmW
         TBLRmBeOGehheeTDjgtniRTC+KXkYwmC11M309RlW9EIOxuXSwQjH86ZPfaVZowryHz2
         LAVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=RuR/KFU9T2+sNr/GW8PYeOxx0r4SQ6Y0Y2jbdQIlacw=;
        b=Rhvm+fUxLnOmdsw6n4cWRm5TypAbt0MZeb1YPajxrpLvviGBi5hF/g87tuP8S1UySt
         qqcfIJ/WVvnFTTg7PQGXYUT3PWXALUVwTOeYj+hzsRAKuEIXnydL+ORUetu6W2v3nUp+
         2hgfnHvw1bbNOH1ApCDplwKVAzdlFyHY5IoGEr8KY0YcXA7+j21jUsu/R7xkra055+BD
         X8EcXLwj/Th4WUE2e901ogZInLbbgkT5cBtvl6tqHQ2PK8OY4Ay9TlGQSnZNRpcgTtEt
         cVwaSz4Bzzq1u+eLaAq7Ed/RT7HziynYBDJ4usPWyK6Z9dUrcWDo7+AYALyAFrgHgBVe
         lc2g==
X-Gm-Message-State: ACrzQf18jm+MaZoeA01ndJx0KixMPpL8xTmHT3cBbA491P0/OhvhzXmL
        WNgUvc80BemoKDhL8jna71lGvW2EhxHN5A==
X-Google-Smtp-Source: AMsMyM6FXwQeajlxDi8sLGZgawElNdx9cDNYE8JVRkQkLT9V930hmtkyv73Y/v/VppI8tb107mD1xA==
X-Received: by 2002:a1c:7213:0:b0:3b3:4065:66cc with SMTP id n19-20020a1c7213000000b003b3406566ccmr110210wmc.184.1664574023098;
        Fri, 30 Sep 2022 14:40:23 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:eccf:bbfd:a57d:90d5? ([2a01:e0a:b41:c160:eccf:bbfd:a57d:90d5])
        by smtp.gmail.com with ESMTPSA id c6-20020a5d4146000000b0022a403954c3sm3108186wrq.42.2022.09.30.14.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 14:40:22 -0700 (PDT)
Message-ID: <275e78cc-5728-8551-ec70-8cb7c1a38b45@6wind.com>
Date:   Fri, 30 Sep 2022 23:40:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCHv5 net-next 1/4] rtnetlink: add new helper
 rtnl_configure_link_notify()
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        David Ahern <dsahern@kernel.org>
References: <20220930094506.712538-1-liuhangbin@gmail.com>
 <20220930094506.712538-2-liuhangbin@gmail.com>
 <ede1abd0-970a-dec8-4dee-290d4a43200f@6wind.com>
 <20220930160150.GD10057@localhost.localdomain>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220930160150.GD10057@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




Le 30/09/2022 à 18:01, Guillaume Nault a écrit :
> On Fri, Sep 30, 2022 at 04:22:19PM +0200, Nicolas Dichtel wrote:
>> Le 30/09/2022 à 11:45, Hangbin Liu a écrit :
>>> -int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm)
>>> +static int rtnl_configure_link_notify(struct net_device *dev, const struct ifinfomsg *ifm,
>>> +				      struct nlmsghdr *nlh, u32 pid)
>> But not here. Following patches also use this order instead of the previous one.
>> For consistency, it could be good to keep the same order everywhere.
> 
> Yes, since a v6 will be necessary anyway, let's be consistent about the
> order of parameters. That helps reading the code.
> 
> While there, I'd prefer to use 'portid' instead of 'pid'. I know
> rtnetlink.c uses both, but 'portid' is more explicit and is what
> af_netlink.c generally uses.
> 
+1

pid is historical but too confusing.
