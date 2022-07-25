Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0003157FE0C
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 13:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbiGYLHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 07:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234703AbiGYLHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 07:07:05 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8380019C0F
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 04:07:03 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id m8so13396019edd.9
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 04:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n+BeAGcM1vq8ZV/ndWyo+zk8e0dfuS3zI75lX0M5C2w=;
        b=4ms6i4laHSu5iZlef+raBf2V73x2tuq6e3cOiFP1UAUH43CgRJFYGWCgpdOzxChBbB
         uuPPG6JVj1dwUw5a8a6cElip0FDeUiCqrm/TLUIaTDrWajPRVVYc3wMmYfd8RhP/vDRR
         O3t9OxcFanbV9pBTorqDaNbDfKmuydzSIa8emvXpbf3WcNfX+inT5dnBYbC/VefyZLuI
         D/ypCWO62zzThBg+noSmy5o81mGzm1om3cTxwMSn+3wUCytQcHeb4VSrqzCVhzb25hvG
         DkLy0AzOKHAuZzHHkvzv9d5mZYZIeSM8eaAcHgXMAayXA+MH5zVcQoaPLc9+3o/ekh2u
         zyWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n+BeAGcM1vq8ZV/ndWyo+zk8e0dfuS3zI75lX0M5C2w=;
        b=O75o9/2+brbPnIlcRTPf/bPJNkmEwJeZacRRDn7zNwwHynONsPkwiljvFNzPiEqSyf
         claOBZwO1x9pm4WmJ0YR4QwkgS5vIPGg44rcwMdR2c4Z7N6FxmFdOms3YVZX2k100gVL
         QWFLpBx05RSmbQ79/3Asjz5nyHWm41d+bIecHwf57L+QiCZhBmNPmemvxIECInWOftTh
         Oyo27ELhD6GbotPlwEqYPqJAICMZwopuSffIDKO3OG/VYNXqM2vU7EfsX7dqLcqrvJGs
         RU/bOy7+QrEk7f0iaJAoKMhWEPaNEcAkSDFfsI0fyHOJD+tQU3yjooUWErugUEM2ynw6
         YSPw==
X-Gm-Message-State: AJIora8676/a3xAN7kcMNDqLM+Y+Jik1j9qWiKiGmGYbjWvDzo/hWXib
        0YgyD9CUUWuUSbp6FQvuAx4+Ew==
X-Google-Smtp-Source: AGRyM1uzygQ7IcGlo7tWExJkeaAPv1aDXBKe0jd6OkKFAERi1ZPwX3guPUdn2Oqszle7jYGmTuSH2Q==
X-Received: by 2002:a05:6402:1117:b0:43b:c965:549e with SMTP id u23-20020a056402111700b0043bc965549emr12589985edv.366.1658747221572;
        Mon, 25 Jul 2022 04:07:01 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id b7-20020aa7c6c7000000b0043a78236cd2sm7037185eds.89.2022.07.25.04.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 04:07:00 -0700 (PDT)
Date:   Mon, 25 Jul 2022 13:07:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, dsahern@kernel.org,
        stephen@networkplumber.org, Eric Dumazet <edumazet@google.com>,
        pabeni@redhat.com, ast@kernel.org, leon@kernel.org,
        linux-doc@vger.kernel.org, corbet@lwn.net,
        Michael Chan <michael.chan@broadcom.com>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>
Subject: Re: [PATCH net-next v6 1/2] devlink: introduce framework for
 selftests
Message-ID: <Yt55VKOYmn/dF4Ob@nanopsycho>
References: <20220723042206.8104-1-vikas.gupta@broadcom.com>
 <20220723042206.8104-2-vikas.gupta@broadcom.com>
 <20220723091600.1277e903@kernel.org>
 <Yt5L8TbzTwthnrl7@nanopsycho>
 <CAHLZf_uWxnS5Voc6h7pnS=dRq96JV1wq9zVXKhVbyrRva9=b0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHLZf_uWxnS5Voc6h7pnS=dRq96JV1wq9zVXKhVbyrRva9=b0g@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 25, 2022 at 10:48:39AM CEST, vikas.gupta@broadcom.com wrote:
>Hi Jiri,
>
>On Mon, Jul 25, 2022 at 1:23 PM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Sat, Jul 23, 2022 at 06:16:00PM CEST, kuba@kernel.org wrote:
>> >On Sat, 23 Jul 2022 09:52:05 +0530 Vikas Gupta wrote:
>> >> +enum devlink_attr_selftest_test_id {
>> >> +    DEVLINK_ATTR_SELFTEST_TEST_ID_UNSPEC,
>> >> +    DEVLINK_ATTR_SELFTEST_TEST_ID_FLASH,    /* flag */
>> >> +
>> >> +    __DEVLINK_ATTR_SELFTEST_TEST_ID_MAX,
>> >> +    DEVLINK_ATTR_SELFTEST_TEST_ID_MAX = __DEVLINK_ATTR_SELFTEST_TEST_ID_MAX - 1
>> >> +};
>> >> +
>> >> +enum devlink_selftest_test_status {
>> >> +    DEVLINK_SELFTEST_TEST_STATUS_SKIP,
>> >> +    DEVLINK_SELFTEST_TEST_STATUS_PASS,
>> >> +    DEVLINK_SELFTEST_TEST_STATUS_FAIL
>> >> +};
>> >> +
>> >> +enum devlink_attr_selftest_result {
>> >> +    DEVLINK_ATTR_SELFTEST_RESULT_UNSPEC,
>> >> +    DEVLINK_ATTR_SELFTEST_RESULT,                   /* nested */
>> >> +    DEVLINK_ATTR_SELFTEST_RESULT_TEST_ID,           /* u32,
>> >> +                                                     * enum devlink_attr_selftest_test_id
>> >> +                                                     */
>> >> +    DEVLINK_ATTR_SELFTEST_RESULT_TEST_STATUS,       /* u8,
>> >> +                                                     * enum devlink_selftest_test_status
>> >> +                                                     */
>> >> +
>> >> +    __DEVLINK_ATTR_SELFTEST_RESULT_MAX,
>> >> +    DEVLINK_ATTR_SELFTEST_RESULT_MAX = __DEVLINK_ATTR_SELFTEST_RESULT_MAX - 1
>> >
>> >Any thoughts on running:
>> >
>> >       sed -i '/_SELFTEST/ {s/_TEST_/_/g}' $patch
>>
>> Sure, why not. But please make sure you keep all other related things
>> (variables, cmdline opts) consistent.
>>
>> Thanks!
>Does the 'test_id' in command line
> 'devlink dev selftests run DEV test_id flash'
>will still hold good if DEVLINK_ATTR_SELFTEST_RESULT_TEST_ID changes
>to DEVLINK_ATTR_SELFTEST_RESULT_ID ?
>or it should be
>'devlink dev selftests run DEV selftest_id flash' ?

Just "id". Thanks!


>
>Thanks,
>Vikas
>
>
>>
>>
>> >
>> >on this patch? For example DEVLINK_ATTR_SELFTEST_RESULT_TEST_STATUS
>> >is 40 characters long, ain't nobody typing that, and _TEST is repeated..
>> >
>> >Otherwise LGTM!


