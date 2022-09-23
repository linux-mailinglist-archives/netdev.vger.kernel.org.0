Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023295E7608
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 10:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiIWIoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 04:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiIWIn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 04:43:59 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED2D11A6A5
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 01:43:56 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id n40-20020a05600c3ba800b003b49aefc35fso2784286wms.5
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 01:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=P7l8CjjGnh8Eshe7PkIl/L3a6+PDtvQlFYQDPjZQtRY=;
        b=UtI8lYRhpEyzfEJmBh+nWVqnXqw5dYbVh4q9EkPjeu6e9tYdE8okZ5GvpbXBk+0V+9
         H5ejPXHK8HqNSeWgm5OpbHk4dDcZ8GSABX2QiJUelBIBKrvLeyUcd4WedS+gBvX//6IJ
         OhzG6Z6lc6dyd3lbFAzt1hciU7H+fdBgBkpqJE7DhUXQ9/WSZakqFeISivSwJ0Jct9v2
         FLXbx29dUsegzRNSloON9JVp8zrj3nIVfrCVvINVH9izcZPMm8xlbzigSHHbJ/8dRCgJ
         Cl140kIhcxvH5jPMySWZZcJIC4/l9AOFYjyic4xYEH13wuNwOUdTw8iw/+svHE8x0lWE
         pYOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=P7l8CjjGnh8Eshe7PkIl/L3a6+PDtvQlFYQDPjZQtRY=;
        b=WndRBBb8sz3V/2qJpKq1q5RK6HeXFOoEdrbmBP1xeiJSU6EOxDg4JjTgG2Tjgw3P2s
         3D+e9eMts03MCgU6Z8JfbZh/ET5OTb3DTB3oA7FSG9Og5E3prPpiB5y0uzQFD61aW4YH
         gmEcjZCUwDV7uxB4OJ/giTTCFpJdBZiVyzPucmJzsf7lmEFRrE8iDbiAhBio3XEZAqua
         lxldyrj269/2165kTKkcapY3wJ4RIJle+CLqJBQDx6rAZ+F63Za97ycJbj4Uz0w+r5OO
         Gz9ybNhN83E70Eics+OONCq2dk4SRB4XQXRdkLNELm1s0MRcQ02KTWe4sGO2RPSgHpV1
         1vpQ==
X-Gm-Message-State: ACrzQf1pPeGGfWhQbe+f0CizCZtXGXzOgM8cVQxbF4nK7pP7jkAr99JL
        SkzRFcuXinfXo71pgup/dWNNwQ==
X-Google-Smtp-Source: AMsMyM7Z5v1aZRUr/lN/PqivEf7f1EEcxDz407BAhv2VAyMyqJXubInuc36l2YsXBgJV4RZKVvWVDA==
X-Received: by 2002:a05:600c:5490:b0:3b4:8db0:5547 with SMTP id iv16-20020a05600c549000b003b48db05547mr4967568wmb.77.1663922635320;
        Fri, 23 Sep 2022 01:43:55 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:b8c3:1fb4:31a9:da5a? ([2a01:e0a:b41:c160:b8c3:1fb4:31a9:da5a])
        by smtp.gmail.com with ESMTPSA id m18-20020a5d56d2000000b0022878c0cc5esm6823146wrw.69.2022.09.23.01.43.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 01:43:54 -0700 (PDT)
Message-ID: <5a1f51a2-3a68-54ae-69ec-51881d60b43f@6wind.com>
Date:   Fri, 23 Sep 2022 10:43:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next] rtnetlink: Honour NLM_F_ECHO flag in rtnl_{new,
 set}link
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>
References: <20220921030721.280528-1-liuhangbin@gmail.com>
 <20220921060123.1236276d@kernel.org> <20220921161409.GA11793@debian.home>
 <20220921155640.1f3dce59@kernel.org> <20220922110951.GA21605@debian.home>
 <20220922060346.280b3af8@kernel.org> <20220922145142.GB21605@debian.home>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220922145142.GB21605@debian.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 22/09/2022 à 16:51, Guillaume Nault a écrit :
> I just don't see any way to pass a handle back to user space at the
> moment. The echo mechanism did that and was generic to all netlink
> families (as long as nlmsg_notify() was called with the right
> parameters).
> 
+1
