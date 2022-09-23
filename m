Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34B05E7EB6
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbiIWPnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbiIWPnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:43:07 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F01BA5712
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:42:36 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id o20-20020a05600c4fd400b003b4a516c479so249763wmq.1
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=yY2csCgsbQ3bTPRE/r4tieLASZ967O6D0+p+iEb2hko=;
        b=GmYJuWYj+jRpiym6E89J/kOfeMxIZ5yklnk1tvgEkXGAsvKN4hFHW8QF/WgAc09oni
         ZyHZCRbh0/Up/GijZtr+g6YHtph92g9LFp5rAs4ZLT6IwKzpeYaNEilp7IjKjmpVVQpR
         52JdjRJ38Y4lCaKnWqpvxfwFTdifdTowbTq/PLKhGoXzhCK3quqNp2D4Hg7WgNmFaJ55
         WmJgiIt/1ykqE3ddUPG8uqOXrWANNYv+Yl7LvJZpBz0NYCSwcNuXz2B+RW4gQ7gYkeIc
         D4U+yebyVagFWhI8XqRGdcuqg081r+o8TUfZM8TeoWVpQltMNcX21TehLffmMBS4Vh+s
         iyfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=yY2csCgsbQ3bTPRE/r4tieLASZ967O6D0+p+iEb2hko=;
        b=DKBWfkyZhyrxDAp8M+BsZdlMe2pd3tRz/6K2HAstLHhAfoKFsA5qG2iOqGu7vVAJLL
         BCQUvAdDNXMw0emAQ3NdZEgDy+OMwCG4tABSiNFq6WfOGSMiedcza4C6fhcwkpRVeXmb
         gGO6RnNy4wzOW11sTrc1QRsSL2iLyNMdOcGR+KeLyTc2YU1+wi+QJYTGnPDMBsIzJl1U
         PZ6CdtQLiLUvfHJitrQTQTJqwF3BQOr4NWIXENG2tXs4StgErzV7oDHG1J0BtV0e+5La
         0mAfWiQfeo8mcKzSBu+4IgWmB3fVhhRY0XLQgZNfPrkILDneimhX9/eqyVHfxSNCxTfH
         lMqw==
X-Gm-Message-State: ACrzQf2qDJZrgmrPYW3+IBUZxJ5BM6cGhGmR7DaglblHwlbo9uzC4VKg
        h2KZqPlR/23BHQDp7KzvuoSKaQ==
X-Google-Smtp-Source: AMsMyM52ZngMJVzun1n1LTVY8Lalr07PmF3OYvc+9qKOzDBIHJd11rMrWgzyjNqUXTZoLD1wLNK63w==
X-Received: by 2002:a05:600c:444b:b0:3b4:cb9e:bd5c with SMTP id v11-20020a05600c444b00b003b4cb9ebd5cmr13212554wmn.124.1663947754815;
        Fri, 23 Sep 2022 08:42:34 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:95ed:dfc7:202f:3203? ([2a01:e0a:b41:c160:95ed:dfc7:202f:3203])
        by smtp.gmail.com with ESMTPSA id p11-20020a05600c204b00b003b4f86b31dfsm2799009wmg.33.2022.09.23.08.42.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 08:42:34 -0700 (PDT)
Message-ID: <2a49231c-496d-132a-93e1-8a2071a35b08@6wind.com>
Date:   Fri, 23 Sep 2022 17:42:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next] rtnetlink: Honour NLM_F_ECHO flag in rtnl_{new,
 set}link
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Guillaume Nault <gnault@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
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
 <5a1f51a2-3a68-54ae-69ec-51881d60b43f@6wind.com>
 <20220923064845.64c9a801@kernel.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220923064845.64c9a801@kernel.org>
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




Le 23/09/2022 à 15:48, Jakub Kicinski a écrit :
> Let me clarify one more time in case Hangbin is waiting for 
> the discussion to resolve...
> 
> On Fri, 23 Sep 2022 10:43:53 +0200 Nicolas Dichtel wrote:
>> Le 22/09/2022 à 16:51, Guillaume Nault a écrit :
>>> I just don't see any way to pass a handle back to user space at the
>>> moment. The echo mechanism did that and was generic to all netlink
>>> families (as long as nlmsg_notify() was called with the right
>>> parameters).
> 
> In NEWLINK, right? In NEWLINK there is no way to pass it back 
> at the moment. A newly added command can just respond with the handle
> always. The problem with NEWLINK is that it _used to_ not respond so 
> we can't make it start responding because it will confuse existing user
> space.
> 
> At the protocol level NEW is no different than GET, whether it sends 
> a response back is decided by whoever implements the command.
> 
> So yes, for NEWLINK we need a way to inform the kernel that user space
> wants a reply. It can be via ECHO, it could be via a new attr.
> 
> What I'm trying to argue about is *not* whether NEWLINK should support
> ECHO but whether requiring ECHO to get a response for newly added
> CREATE / NEW commands is a good idea. I think it is not, and new
> commands should just always respond with the handle.
Sure, but I don't see how we can enforce this.

> 
> My main concern with using ECHO is that it breaks the one-to-one
> relationship between a request and a response. There may be multiple
> notifications generated due to a command, and if we want to retain 
> the "ECHO will loop back to you all resulting notifications" semantics,
> which I think we should, then there can be multiple "responses".
Thanks for the detailed explanation.

> 
> This also has implications for the command IDs used in notifications.
> A lot of modern genl families use different IDs for notifications to
> make it easily distinguishable from responses.
I didn't know that. Indeed, it's a good idea.
