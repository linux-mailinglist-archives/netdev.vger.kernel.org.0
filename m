Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A9A5EE84A
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 23:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbiI1V0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 17:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiI1V0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 17:26:08 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D6B6554A
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 14:26:03 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id r6so4393199wru.8
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 14:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=XZeg3Cz9yrUdwRujBHfZjNx3v6d8fzcGHWra7KfqfRE=;
        b=J10uZS7KoEuL/pGWgLGuapyvki2rUOikc9PkxAvta1pvt7oCN9ESjMJWVWqZhyncmw
         m3FpEaUSiMr7CXrT2v0uWZX4dJ2nj2RdYqTwim9pjx9FRcpbQ2amKGMpOaodFY2xhLh8
         /lOAEw67gQWBfTFQSObKiE6RsGqAA7Geo1ktwRb4lhaCojLuad4MA1p2AuPh0mrdSTlB
         I2YZaPTKfyfLogEpPCOIfg3BSXfEVmBI883GM659X748jG5duvtlVV9n5SsvNjZeO4HS
         4SjI5U/nyNRIlfRbUoQL1WlhH3xdCv/OGwtwPPQakKS3R8DctssNzHzkyJujEIspg2AB
         10+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=XZeg3Cz9yrUdwRujBHfZjNx3v6d8fzcGHWra7KfqfRE=;
        b=SRx7QqhMZ52FBr1AqWvrBcgh2WZoaHRiiF4BTzeQnjLNfD/zZ1IHD/plHntjjBGhed
         TxeIjECyFHznU0TrPMtDLEiAWDO1No8C4k/Nmip9A3h+wj8x4XJth8CZX463ifi40d81
         /fllYjamiA+9qBfcKe+juCxtXKKKyWWwJ9e0PQItrTW6RADbhkiLus9kHstcmOPx3Oa6
         +CAbkVbRJYXRPsJI0RxJ+lUyoQEzo9l0WtasehbqBbneRJyd8LbGKNsr4d88EIU8fAAH
         wlHEiloFOtfdXlJ9ToQHeYGwP3WINY8ApT62Z0Z3uPfFBjE7VwC/CebS3SfbKzX2QeoA
         7R0Q==
X-Gm-Message-State: ACrzQf1zVO01rIf+ahbJeSYREtw1WAWggGABUlr770/tYcJI4dm2jlw/
        RKQS8XFhF1e3rdegNAvkHJu6RQ==
X-Google-Smtp-Source: AMsMyM5xufyqI9AWgxVuPTZ1JtrWuoRLjjkv0OAeegrQm/ceTLm/sqrQg3jYE48t6DhSY8oSiJZ6yA==
X-Received: by 2002:a05:6000:1a87:b0:22a:56da:9a2b with SMTP id f7-20020a0560001a8700b0022a56da9a2bmr22384584wry.433.1664400362345;
        Wed, 28 Sep 2022 14:26:02 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:3555:34ed:fe84:7989? ([2a01:e0a:b41:c160:3555:34ed:fe84:7989])
        by smtp.gmail.com with ESMTPSA id jb5-20020a05600c54e500b003a604a29a34sm2645291wmb.35.2022.09.28.14.26.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 14:26:01 -0700 (PDT)
Message-ID: <0147506b-1abc-0938-73e5-dbaa1d8a74f1@6wind.com>
Date:   Wed, 28 Sep 2022 23:26:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] genetlink: reject use of nlmsg_flags for new commands
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Guillaume Nault <gnault@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
References: <20220928183515.1063481-1-kuba@kernel.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220928183515.1063481-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




Le 28/09/2022 à 20:35, Jakub Kicinski a écrit :
> Commit 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
> introduced extra validation for genetlink headers. We had to gate it
> to only apply to new commands, to maintain bug-wards compatibility.
> Use this opportunity (before the new checks make it to Linus's tree)
> to add more conditions.
> 
> Validate that Generic Netlink families do not use nlmsg_flags outside
> of the well-understood set.
> 
> Link: https://lore.kernel.org/all/20220928073709.1b93b74a@kernel.org/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> CC: Florent Fourcot <florent.fourcot@wifirst.fr>
> CC: Nikolay Aleksandrov <razor@blackwall.org>
> CC: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> CC: Johannes Berg <johannes@sipsolutions.net>
> CC: Pablo Neira Ayuso <pablo@netfilter.org>
> CC: Florian Westphal <fw@strlen.de>
> CC: Jamal Hadi Salim <jhs@mojatatu.com>
> CC: Jacob Keller <jacob.e.keller@intel.com>
> CC: Guillaume Nault <gnault@redhat.com>
> CC: Hangbin Liu <liuhangbin@gmail.com>

Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Thanks!
