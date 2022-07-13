Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CCD57340C
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 12:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235889AbiGMKXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 06:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235861AbiGMKXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 06:23:04 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CB6F9904
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 03:23:01 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id dn9so19011654ejc.7
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 03:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2ghhMZwLPASGJo/4zIq1AHGruJYFCLTXZf7ncy6Y8Vw=;
        b=uet/jPhBv+OrSsv/vv8hJZte3e7YiVEOCeXy8TbjqUfF98wkLPYMBkxhwwiSb9eT1z
         ep9tCQcY0bOa5JhirD335tVWAZ8BZrz830OfbxxIx9SNk8UF1A2Pcm5EPXR4NRi9//3k
         kIxn3EvG9zpA7KfDV+1CG2zxQl5VeaFKDPciKFCzhqTXJm+RDyQ5I/YQUcBDpsCMoxAZ
         G+VIKl5KqhEzodUuOa0btZWFd7lGtj0uGQwD8jB3AFWGQmG7i5mjyjHXDHZGL7k8pMuF
         oJZ/944fCDKXIFlr1e3lrhOlaVpTpQ0guGA6VOZ+/YKxf6WVKk0q2LJvKPunYu8aJ2mH
         DXew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2ghhMZwLPASGJo/4zIq1AHGruJYFCLTXZf7ncy6Y8Vw=;
        b=Z6X3OXNneASPkoHT900Jdmvcwuu6AYx4Y05+zVW2Plliepc5RoN2GD3u0d2q3QvuvK
         sy5Cg50eqSkBML1AGV5JU5McqeaVT2kgeT6amYP6p390DmATeGr2U5StXh6P7XCyn0OU
         UOZLr5OP+rA0R39i3P/ltlYyMZc12gu854fJ4WfNBlAKYg9FqKGtKajVCnor1xQekcZE
         tf3hcNuX77KAro5VVN3i/xo76dIvxYhfozCWmKkrH0vYRRPHDxNwS8OYLHy/8vQuQ/2l
         iZ01WvmWz4KtfcbDk2L9i7gce+vRz6Y1zV2Du/wQpZmuenyeIhZyX5RxJndt4JvxahRT
         ebfQ==
X-Gm-Message-State: AJIora9adTUq36TXit/jwfGFkaen7Tl+ubruPs76282TD1FjmvnjXx72
        6gRyobSipIkvJcXnVtW0dBJ/1g==
X-Google-Smtp-Source: AGRyM1tkTf1aX3JWK8/nbEcTYKSGdHwGMGV6YE9Nk/ezbDHXIbvoWv7A551InxQPc5Qz2zSU0QlwmA==
X-Received: by 2002:a17:907:8a04:b0:72b:9173:2fef with SMTP id sc4-20020a1709078a0400b0072b91732fefmr2683477ejc.346.1657707780040;
        Wed, 13 Jul 2022 03:23:00 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id j21-20020aa7c415000000b0043589eba83bsm7669255edq.58.2022.07.13.03.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 03:22:59 -0700 (PDT)
Date:   Wed, 13 Jul 2022 12:22:58 +0200
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
Message-ID: <Ys6dAq2o6h5wYaed@nanopsycho>
References: <20220707182950.29348-1-vikas.gupta@broadcom.com>
 <20220707182950.29348-2-vikas.gupta@broadcom.com>
 <YswaKcUs6nOndU2V@nanopsycho>
 <CAHLZf_t9ihOQPvcQa8cZsDDVUX1wisrBjC30tHG_-Dz13zg=qQ@mail.gmail.com>
 <Ys0UpFtcOGWjK/sZ@nanopsycho>
 <CAHLZf_s7s4rqBkDnB+KH-YJRDBDzeZB6VhKMMndk+dxxY11h3g@mail.gmail.com>
 <Ys24l4O1M/8Kf4/o@nanopsycho>
 <CAHLZf_tzpG9J=_orUsD9xto_Q818S-YqOTFvWchFjRkR3LXhvA@mail.gmail.com>
 <Ys50DGXCi5lPaRBB@nanopsycho>
 <CAHLZf_uw-WtT3ztY=U5M1isxvpvUhPpPXYi2jk2UJxtsWMtBkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHLZf_uw-WtT3ztY=U5M1isxvpvUhPpPXYi2jk2UJxtsWMtBkQ@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 13, 2022 at 12:16:03PM CEST, vikas.gupta@broadcom.com wrote:
>Hi Jiri,
>
>On Wed, Jul 13, 2022 at 12:58 PM Jiri Pirko <jiri@nvidia.com> wrote:
>>
>> Wed, Jul 13, 2022 at 08:40:50AM CEST, vikas.gupta@broadcom.com wrote:
>> >Hi Jiri,
>> >
>> >On Tue, Jul 12, 2022 at 11:38 PM Jiri Pirko <jiri@resnulli.us> wrote:
>> >>
>> >> Tue, Jul 12, 2022 at 06:41:49PM CEST, vikas.gupta@broadcom.com wrote:
>> >> >Hi Jiri,
>> >> >
>> >> >On Tue, Jul 12, 2022 at 11:58 AM Jiri Pirko <jiri@nvidia.com> wrote:
>> >> >>
>> >> >> Tue, Jul 12, 2022 at 08:16:11AM CEST, vikas.gupta@broadcom.com wrote:
>> >> >> >Hi Jiri,
>> >> >> >
>> >> >> >On Mon, Jul 11, 2022 at 6:10 PM Jiri Pirko <jiri@nvidia.com> wrote:
>> >> >> >
>> >> >> >> Thu, Jul 07, 2022 at 08:29:48PM CEST, vikas.gupta@broadcom.com wrote:
>> >>
>> >> [...]
>> >>
>> >>
>> >> >> >> >  * enum devlink_trap_action - Packet trap action.
>> >> >> >> >  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy
>> >> >> >> is not
>> >> >> >> >@@ -576,6 +598,10 @@ enum devlink_attr {
>> >> >> >> >       DEVLINK_ATTR_LINECARD_TYPE,             /* string */
>> >> >> >> >       DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,  /* nested */
>> >> >> >> >
>> >> >> >> >+      DEVLINK_ATTR_SELFTESTS_MASK,            /* u32 */
>> >> >> >>
>> >> >> >> I don't see why this is u32 bitset. Just have one attr per test
>> >> >> >> (NLA_FLAG) in a nested attr instead.
>> >> >> >>
>> >> >> >
>> >> >> >As per your suggestion, for an example it should be like as below
>> >> >> >
>> >> >> >        DEVLINK_ATTR_SELFTESTS,                 /* nested */
>> >> >> >
>> >> >> >        DEVLINK_ATTR_SELFTESTS_SOMETEST1            /* flag */
>> >> >> >
>> >> >> >        DEVLINK_ATTR_SELFTESTS_SOMETEST2           /* flag */
>> >> >>
>> >> >> Yeah, but have the flags in separate enum, no need to pullute the
>> >> >> devlink_attr enum by them.
>> >> >>
>> >> >>
>> >> >> >
>> >> >> >....    <SOME MORE TESTS>
>> >> >> >
>> >> >> >.....
>> >> >> >
>> >> >> >        DEVLINK_ATTR_SLEFTESTS_RESULT_VAL,      /* u8 */
>> >> >> >
>> >> >> >
>> >> >> >
>> >> >> > If we have this way then we need to have a mapping (probably a function)
>> >> >> >for drivers to tell them what tests need to be executed based on the flags
>> >> >> >that are set.
>> >> >> > Does this look OK?
>> >> >> >  The rationale behind choosing a mask is that we could directly pass the
>> >> >> >mask-value to the drivers.
>> >> >>
>> >> >> If you have separate enum, you can use the attrs as bits internally in
>> >> >> kernel. Add a helper that would help the driver to work with it.
>> >> >> Pass a struct containing u32 (or u8) not to drivers. Once there are more
>> >> >> tests than that, this structure can be easily extended and the helpers
>> >> >> changed. This would make this scalable. No need for UAPI change or even
>> >> >> internel driver api change.
>> >> >
>> >> >As per your suggestion, selftest attributes can be declared in separate
>> >> >enum as below
>> >> >
>> >> >enum {
>> >> >
>> >> >        DEVLINK_SELFTEST_SOMETEST,         /* flag */
>> >> >
>> >> >        DEVLINK_SELFTEST_SOMETEST1,
>> >> >
>> >> >        DEVLINK_SELFTEST_SOMETEST2,
>> >> >
>> >> >....
>> >> >
>> >> >......
>> >> >
>> >> >        __DEVLINK_SELFTEST_MAX,
>> >> >
>> >> >        DEVLINK_SELFTEST_MAX = __DEVLINK_SELFTEST_MAX - 1
>> >> >
>> >> >};
>> >> >Below  examples could be the flow of parameters/data from user to
>> >> >kernel and vice-versa
>> >> >
>> >> >
>> >> >Kernel to user for show command . Users can know what all tests are
>> >> >supported by the driver. A return from kernel to user.
>> >> >______
>> >> >|NEST |
>> >> >|_____ |TEST1|TEST4|TEST7|...
>> >> >
>> >> >
>> >> >User to kernel to execute test: If user wants to execute test4, test8, test1...
>> >> >______
>> >> >|NEST |
>> >> >|_____ |TEST4|TEST8|TEST1|...
>> >> >
>> >> >
>> >> >Result Kernel to user execute test RES(u8)
>> >> >______
>> >> >|NEST |
>> >> >|_____ |RES4|RES8|RES1|...
>> >>
>> >> Hmm, I think it is not good idea to rely on the order, a netlink library
>> >> can perhaps reorder it? Not sure here.
>> >>
>> >> >
>> >> >Results are populated in the same order as the user passed the TESTs
>> >> >flags. Does the above result format from kernel to user look OK ?
>> >> >Else we need to have below way to form a result format, a nest should
>> >> >be made for <test_flag,
>> >> >result> but since test flags are in different enum other than
>> >> >devlink_attr and RES being part of devlink_attr, I believe it's not
>> >> >good practice to make the below structure.
>> >>
>> >> Not a structure, no. Have it as another nest (could be the same attr as
>> >> the parent nest:
>> >>
>> >> ______
>> >> |NEST |
>> >> |_____ |NEST|       |NEST|       |NEST|
>> >>         TEST4,RES4   TEST8,RES8   TEST1, RES1
>> >>
>> >> also, it is flexible to add another attr if needed (like maybe result
>> >> message string containing error message? IDK).
>> >
>> >For above nesting we can have the attributes defined as below
>> >
>> >Attribute in  devlink_attr
>> >enum devlink_attr {
>> >  ....
>> >  ....
>> >        DEVLINK_SELFTESTS_INFO, /* nested */
>> >  ...
>> >...
>> >}
>> >
>> >enum devlink_selftests {
>> >        DEVLINK_SELFTESTS_SOMETEST0,   /* flag */
>> >        DEVLINK_SELFTESTS_SOMETEST1,
>> >        DEVLINK_SELFTESTS_SOMETEST2,
>> >        ...
>> >        ...
>> >}
>> >
>> >enum devlink_selftest_result {
>>
>> for attrs, have "attr" in the name of the enum and "ATTR" in name of the
>> value.
>>
>> >        DEVLINK_SELFTESTS_RESULT,       /* nested */
>> >        DEVLINK_SELFTESTS_TESTNUM,      /* u32  indicating the test
>>
>> You can have 1 enum, containing both these and the test flags from
>> above.
> I think it's better to keep enum devlink_selftests_attr (containing
>flags) and devlink_selftest_result_attr separately as it will have an
>advantage.
> For example, for show commands the kernel can iterate through and
>check with the driver if it supports a particular test.
>
>    for (i = 0; i < DEVLINK_SELFTEST_ATTR_MAX, i++) {
>                   if (devlink->ops->selftest_info(devlink, i,
>extack)) {  // supports selftest or not
>                         nla_put_flag(msg, i);
>                }
>        }
>      Also flags in devlink_selftests_attr can be used as bitwise, if required.
>      Let me know what you think.

Okay.


>
>Thanks,
>Vikas
>
>>
>>
>> >number in devlink_selftests enum */
>> >        DEVLINK_SELFTESTS_RESULT_VAL,   /* u8  skip, pass, fail.. */
>>
>> Put enum name in the comment, instead of list possible values.
>>
>>
>> >        ...some future attrr...
>> >
>> >}
>> >enums in devlink_selftest_result can be put in devlink_attr though.
>>
>> You can have them separate, I think it is about the time we try to put
>> new attrs what does not have potencial to be re-used to a separate enum.
>>
>>
>> >
>> >Does this look OK?
>> >
>> >Thanks,
>> >Vikas
>> >
>> >>
>> >>
>> >>
>> >> >______
>> >> >|NEST |
>> >> >|_____ | TEST4, RES4|TEST8,RES8|TEST1,RES1|...
>> >> >
>> >> >Let me know if my understanding is correct.
>> >>
>> >> [...]
>>
>>


