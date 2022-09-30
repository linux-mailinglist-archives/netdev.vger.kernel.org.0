Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E24E5F0AAD
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 13:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbiI3LiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 07:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbiI3Lhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 07:37:47 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BD813E2C
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 04:29:27 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id sd10so8454486ejc.2
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 04:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=dAlxSYWHrl2eEwVy2+8+5AjEsyFeJgyxYaITkq6d3z4=;
        b=KWuRNisw4DVLrZRolKRPgin+CmB63vTmtbSuPn/Kbksk1MkMb8l7w13gUs+twx6oxb
         7TxbbhDijIpyl3OW4FLREOZ+MZq4tE+RhLQby0gBSrUwtO4dHZ6kcLTqH7HOCR9uVVps
         SICaCShwEwufNnpB544gsRXiorBpPZtRv3Ut54rk6aFvLU6BS/orc+PhhBNZ4iOBXrWw
         tUBXY8ShOZOROx7cOoyxLD0jVFSQqp3wkRIkt999XPCzPpkRn60wEFk1ndBk+RsGP1B+
         x0lrr4JGbDMd/GfqZ0L7jKXpUTpXLrYOEpVNi0epr8NqgdZqtWIoReq7bWrw2T4Jfi6m
         UBwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=dAlxSYWHrl2eEwVy2+8+5AjEsyFeJgyxYaITkq6d3z4=;
        b=Pl+tLpb8JMfI34yStEDhMvbvSDfLMC/LAx6FLHqjqwPCrfdbL+SV/3as7HcBCRpSEo
         +OjpV1qB83U+EZ2CMQdNVvmF0Myy/Vto549oRH3z33LbxiMdCHk3vQaNfBlshdx99x/o
         3PbihFuFLHWhAwvZNTh707Ah6nyrUzX9VzIvA4ykTzXYMtB2yPyZQ9FUQA1MxrztsKRv
         CpKONOYPGLG46MKO9abfqcXjuhDj1U97LWxMVD3svpB/rLGt59P6P39Ee+rwJAa38vX9
         tBuLDGDDk8N9PSaaGcZ0y+bqDiGrr7a8dl43h2WI6TGnfFb4rhEHW+AK1V9Oy9dFdIg4
         rSdQ==
X-Gm-Message-State: ACrzQf23StgbMFC2VyAK7id9Q8KqGYwnz9WOuuoCF60/HE2wPhj7x4FN
        FKQG0TiPlvy4F4loasx3XjH3Fg==
X-Google-Smtp-Source: AMsMyM5FcWGnHUyM0DpnUySMRhQ7UP3MDHGcroTggYGGUemNsEa1XO0puf9S3wvhvl74WpnK2RVpIw==
X-Received: by 2002:a17:907:1c98:b0:782:e73a:500b with SMTP id nb24-20020a1709071c9800b00782e73a500bmr6284030ejc.400.1664537364978;
        Fri, 30 Sep 2022 04:29:24 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id l1-20020a1709065a8100b0073d7ab84375sm1062579ejq.92.2022.09.30.04.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 04:29:24 -0700 (PDT)
Message-ID: <c3033346-100d-3ec6-0e89-c623fc7b742d@blackwall.org>
Date:   Fri, 30 Sep 2022 14:29:23 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next] docs: netlink: clarify the historical baggage of
 Netlink flags
Content-Language: en-US
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Guillaume Nault <gnault@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Hangbin Liu <liuhangbin@gmail.com>
References: <20220927212306.823862-1-kuba@kernel.org>
 <a3dbb76a-5ee8-5445-26f1-c805a81c4b22@blackwall.org>
 <20220928072155.600569db@kernel.org>
 <CAM0EoMmWEme2avjNY88LTPLUSLqvt2L47zB-XnKnSdsarmZf-A@mail.gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <CAM0EoMmWEme2avjNY88LTPLUSLqvt2L47zB-XnKnSdsarmZf-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/09/2022 14:07, Jamal Hadi Salim wrote:
> On Wed, Sep 28, 2022 at 10:21 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Wed, 28 Sep 2022 10:03:07 +0300 Nikolay Aleksandrov wrote:
>>> The part about NLM_F_BULK is correct now, but won't be soon. I have patches to add
>>> bulk delete to mdbs as well, and IIRC there were plans for other object types.
>>> I can update the doc once they are applied, but IMO it will be more useful to explain
>>> why they are used instead of who's using them, i.e. the BULK was added to support
>>> flush for FDBs w/ filtering initially and it's a flag so others can re-use it
>>> (my first attempt targeted only FDBs[1], but after a discussion it became clear that
>>> it will be more beneficial if other object types can re-use it so moved to a flag).
>>> The first version of the fdb flush support used only netlink attributes to do the
>>> flush via setlink, later moved to a specific RTM command (RTM_FLUSHNEIGH)[2] and
>>> finally settled on the flag[3][4] so everyone can use it.
>>
>> I thought that's all FDB-ish stuff. Not really looking forward to the
>> use of flags spreading but within rtnl it may make some sense. We can
>> just update the docs tho, no?
>>
>> BTW how would you define the exact semantics of NLM_F_BULK vs it not
>> being set, in abstract terms?
> 
> I missed the discussion.
> NLM_F_BULK looks strange. Why pollute the main header? Wouldnt NLM_F_ROOT
> have sufficed to trigger the semantic? Or better create your own
> "service header"
> and put fdb specific into that object header? i.e the idea in netlink
> being you specify:
> {Main header: Object specific header: Object specific attributes in TLVs}
> Main header should only be extended if you really really have to -
> i.e requires much
> longer review..
> 

I did that initially, my first submission used netlink attributes specifically
for fdbs, but then reviews suggested same functionality is needed for other object types
e.g. mdbs, vxlan db, neighbor entries and so on. My second attempt added a new RTM_ msg type that
deletes multiple objects, and finally all settled on the flag because all families can
make use of it, it modifies the delete op to act on multiple objects. For more context please
check the discussions bellow [1] is my first submission (all netlink), [2] is RTM_
and [3][4] are the flag:

[1] https://www.spinics.net/lists/netdev/msg812473.html
[2] https://lore.kernel.org/netdev/20220411230356.GB8838@u2004-local/T/
[3] https://lore.kernel.org/netdev/20220411230356.GB8838@u2004-local/T/#m293c48e788e1a82aa77696f657004e8b4ab72967
[4] https://www.spinics.net/lists/netdev/msg813149.html

> Historical context: We did try to push netlink as a wire protocol
> (meaning it goes
> across nodes instead of user-kernel), see:
> https://www.rfc-editor.org/rfc/rfc3549.html and
> https://datatracker.ietf.org/doc/html/draft-jhsrha-forces-netlink2-02
> (there's an implementation
> of netlink2 that i can dig up).
> unfortunately there was much politiking and ForCES protocol was the compromise;
> as a side, there's _no way in hell_ current netlink would be possible
> to use on the wire
> because of all these one-offs that were being added over time.
> RFC3549 has some documentation which is not really up to date but still valid
> (section 2.2/3 on the header). Note: The EXCL, APPEND etc are very
> similar to file system
> semantics (eg open())
> Generic netlink was written because there were too many people
> grabbing netlink ids
> and we were going to run out of them at some point. IIRC, i called it
> "foobar" originally
> and Dave didnt like that name. It was intended to be the less
> efficient cousin (subject to
> more locks etc) - and the RPC semantic changes were mostly to
> accommodate the fact
> that you couldnt use netlink proper - although I am more a fan of
> CRUD(restful) semantics
> than RPC (netlink proper is salvagable for CRUD as is).
> 
> Not sure how much of this can be leveraged in the documentation (I
> will take a look).
> 
> cheers,
> jamal
> 
> cheers,
> jamal

