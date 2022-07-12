Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F6D572231
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 20:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbiGLSIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 14:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiGLSI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 14:08:29 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE092AE553
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 11:08:26 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id z12so12284932wrq.7
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 11:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DGz+BY3xnZELHM6ryZfTEhs4BFSh6HG4c9xaRhOdDBo=;
        b=eATREUwe5KadLfNjw8E2OW3DLp6+xaXH9pE7xPuScqZ/3UTqteOJA4331fRQnqqLyl
         oAM//6GD5o7X7rzo41Dhzgi//jvDgdDAKpaN6K/IXpbcpKZqoNClJIXZpeTsMfaOqiMz
         TopiZP54AuO0nG/77QILQysk/4jc75EA07J7SD1PyzpZXuw/p8mo/umz5Jb8o2Q4VKNw
         wre9k0na3PvIpnwuEQ78yb4LnMB8u6GB3fpwoGWG6PfDfPmprrhxFsSyouCH2uOzGG2E
         uDn9ts3DGWA7aREWeNVDwcVvNrYV25QjtZO9hgCJCl1Fvb28MUyhtojAqU+CzDcYULLm
         psPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DGz+BY3xnZELHM6ryZfTEhs4BFSh6HG4c9xaRhOdDBo=;
        b=jSpFWhkjraZqv4M2FI3284CGszjVtAiUSMGmnZYuuDb6zE91l4P5u0c/lQNmk2rqtw
         KGLFobsZr/epDqAW7+zfiHFgY9CEEU7nouIc5JqUTdvRec9rdOglEE49XCQjj6wJhZ1W
         Q/RC+GWRyO8El+mH34hupGkzc/1jGSlWXjc1WOECww6pmqjbs5+Aqp/CFXqPO8TVjeZC
         FroEjQmvo38Hdj1CBfQQi4X3R3swu/k1dD8U/LCML/+520A7SALpNAIkHbkYDkeftw2u
         TeOFCEDXzz/SHjf44T4u4qCchVUHEGGjp2BIyFBXU2UAOABUxWHV/fHKNubHVeefnbyE
         gSCA==
X-Gm-Message-State: AJIora/OtPe/etguyrnPxelabTar5j+3oEtlLPI7hZQCk+9ggSOs7bb9
        XOk8iVME2qcO0dStX2LOcTXsmQ==
X-Google-Smtp-Source: AGRyM1v7/Ig14MY8t442WbNsWeoaSgcjtu4MSGmscQ8plX+daxEtm2CNix76Opc5SpGWbiGJHGXwTw==
X-Received: by 2002:adf:fcca:0:b0:21d:68ff:2e5a with SMTP id f10-20020adffcca000000b0021d68ff2e5amr23300797wrs.453.1657649305307;
        Tue, 12 Jul 2022 11:08:25 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d20-20020a05600c4c1400b003a1980d55c4sm12883840wmp.47.2022.07.12.11.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 11:08:24 -0700 (PDT)
Date:   Tue, 12 Jul 2022 20:08:23 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, dsahern@kernel.org,
        stephen@networkplumber.org, Eric Dumazet <edumazet@google.com>,
        pabeni@redhat.com, ast@kernel.org, leon@kernel.org,
        linux-doc@vger.kernel.org, corbet@lwn.net,
        Michael Chan <michael.chan@broadcom.com>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>
Subject: Re: [PATCH net-next v2 1/3] devlink: introduce framework for
 selftests
Message-ID: <Ys24l4O1M/8Kf4/o@nanopsycho>
References: <20220628164241.44360-1-vikas.gupta@broadcom.com>
 <20220707182950.29348-1-vikas.gupta@broadcom.com>
 <20220707182950.29348-2-vikas.gupta@broadcom.com>
 <YswaKcUs6nOndU2V@nanopsycho>
 <CAHLZf_t9ihOQPvcQa8cZsDDVUX1wisrBjC30tHG_-Dz13zg=qQ@mail.gmail.com>
 <Ys0UpFtcOGWjK/sZ@nanopsycho>
 <CAHLZf_s7s4rqBkDnB+KH-YJRDBDzeZB6VhKMMndk+dxxY11h3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHLZf_s7s4rqBkDnB+KH-YJRDBDzeZB6VhKMMndk+dxxY11h3g@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 12, 2022 at 06:41:49PM CEST, vikas.gupta@broadcom.com wrote:
>Hi Jiri,
>
>On Tue, Jul 12, 2022 at 11:58 AM Jiri Pirko <jiri@nvidia.com> wrote:
>>
>> Tue, Jul 12, 2022 at 08:16:11AM CEST, vikas.gupta@broadcom.com wrote:
>> >Hi Jiri,
>> >
>> >On Mon, Jul 11, 2022 at 6:10 PM Jiri Pirko <jiri@nvidia.com> wrote:
>> >
>> >> Thu, Jul 07, 2022 at 08:29:48PM CEST, vikas.gupta@broadcom.com wrote:

[...]


>> >> >  * enum devlink_trap_action - Packet trap action.
>> >> >  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy
>> >> is not
>> >> >@@ -576,6 +598,10 @@ enum devlink_attr {
>> >> >       DEVLINK_ATTR_LINECARD_TYPE,             /* string */
>> >> >       DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,  /* nested */
>> >> >
>> >> >+      DEVLINK_ATTR_SELFTESTS_MASK,            /* u32 */
>> >>
>> >> I don't see why this is u32 bitset. Just have one attr per test
>> >> (NLA_FLAG) in a nested attr instead.
>> >>
>> >
>> >As per your suggestion, for an example it should be like as below
>> >
>> >        DEVLINK_ATTR_SELFTESTS,                 /* nested */
>> >
>> >        DEVLINK_ATTR_SELFTESTS_SOMETEST1            /* flag */
>> >
>> >        DEVLINK_ATTR_SELFTESTS_SOMETEST2           /* flag */
>>
>> Yeah, but have the flags in separate enum, no need to pullute the
>> devlink_attr enum by them.
>>
>>
>> >
>> >....    <SOME MORE TESTS>
>> >
>> >.....
>> >
>> >        DEVLINK_ATTR_SLEFTESTS_RESULT_VAL,      /* u8 */
>> >
>> >
>> >
>> > If we have this way then we need to have a mapping (probably a function)
>> >for drivers to tell them what tests need to be executed based on the flags
>> >that are set.
>> > Does this look OK?
>> >  The rationale behind choosing a mask is that we could directly pass the
>> >mask-value to the drivers.
>>
>> If you have separate enum, you can use the attrs as bits internally in
>> kernel. Add a helper that would help the driver to work with it.
>> Pass a struct containing u32 (or u8) not to drivers. Once there are more
>> tests than that, this structure can be easily extended and the helpers
>> changed. This would make this scalable. No need for UAPI change or even
>> internel driver api change.
>
>As per your suggestion, selftest attributes can be declared in separate
>enum as below
>
>enum {
>
>        DEVLINK_SELFTEST_SOMETEST,         /* flag */
>
>        DEVLINK_SELFTEST_SOMETEST1,
>
>        DEVLINK_SELFTEST_SOMETEST2,
>
>....
>
>......
>
>        __DEVLINK_SELFTEST_MAX,
>
>        DEVLINK_SELFTEST_MAX = __DEVLINK_SELFTEST_MAX - 1
>
>};
>Below  examples could be the flow of parameters/data from user to
>kernel and vice-versa
>
>
>Kernel to user for show command . Users can know what all tests are
>supported by the driver. A return from kernel to user.
>______
>|NEST |
>|_____ |TEST1|TEST4|TEST7|...
>
>
>User to kernel to execute test: If user wants to execute test4, test8, test1...
>______
>|NEST |
>|_____ |TEST4|TEST8|TEST1|...
>
>
>Result Kernel to user execute test RES(u8)
>______
>|NEST |
>|_____ |RES4|RES8|RES1|...

Hmm, I think it is not good idea to rely on the order, a netlink library
can perhaps reorder it? Not sure here.

>
>Results are populated in the same order as the user passed the TESTs
>flags. Does the above result format from kernel to user look OK ?
>Else we need to have below way to form a result format, a nest should
>be made for <test_flag,
>result> but since test flags are in different enum other than
>devlink_attr and RES being part of devlink_attr, I believe it's not
>good practice to make the below structure.

Not a structure, no. Have it as another nest (could be the same attr as
the parent nest:

______
|NEST |
|_____ |NEST|       |NEST|       |NEST|
        TEST4,RES4   TEST8,RES8   TEST1, RES1

also, it is flexible to add another attr if needed (like maybe result
message string containing error message? IDK).



>______
>|NEST |
>|_____ | TEST4, RES4|TEST8,RES8|TEST1,RES1|...
>
>Let me know if my understanding is correct.

[...]
