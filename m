Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E726A6651
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 04:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjCADKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 22:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjCADKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 22:10:37 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242042CC77
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 19:10:31 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id b20so7082965pfo.6
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 19:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677640230;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CEysnDdx6JRqKcZNWR/Qvf05mn2uE2UqY/BT4rdoBjI=;
        b=V3rS525VGydYvGveG7qj1P8al1oHlcyK8uNylQrKeAkvMzJR9Jv6t32UcE8NTLU1E9
         9SnRrdYJMwE1JjTM0BFBqXIPN7OlkLrT4/9ppNTfxwhFOwlQB6RlqIjoQj0DeRpsyR+4
         QuG6gz0uZhB1yKvfVvI4HFDWRJtTiflxid8Xj1sJdnRlf9cUtoScXM4T9emCebEc+AmB
         pAd4uD/do8saHWkuDI/MvR+jxyDyqEYsWpa2nj+QrWcHA0jGXbaW3xP27eMahqMRUvzc
         Zn4MhiwcoI96hrgpaENXq2CH0PgOFXwC2LAypdOZQGU7UlKjhLY3YMGeQS5TGPk7JTCl
         Aycg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677640230;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CEysnDdx6JRqKcZNWR/Qvf05mn2uE2UqY/BT4rdoBjI=;
        b=Lso73+/JLUBoLotwaZT7p3xsOFMMU16PKcCluH8TGfjseTMpj/VDj7KvSZmktT3Ryn
         zYfFHrFsHzvo1cBiBbQNLgTSFs++xAC+xYZAkx0bfCgWzxG41fFfjINynqtnsPoxcQ46
         t1/3OxhuOC3W1mQijIVRwjX5KczW41I0hG8SDUTNz0TDsC5qU5pyWSaBkeZxCCUVh7mY
         AbGtKXj/efBrCbzeh6P7oc9ZUXPf9O4x1sWKNPmNC/UIsiPUkAyucZoqMjhfNc0SmMKa
         SYtaMQnqlcMx+RiNcINAIy+FaCzUruvU834B12+Uc5vhKNz7/or1ZyYF2XhIiesn84d2
         iBJg==
X-Gm-Message-State: AO0yUKXtt02PxmxEwRvSP/r8e2lG6ySMB7KFFvuUvdtAVYcI0Y7Y7Pc0
        k1x3fAVCfQwn5gm8UNU4eyidfISD3T0E1T54
X-Google-Smtp-Source: AK7set8I1v00H3D+GdozFk8mDueJwB5GbpkpGdDudy9leahMSKKQtnUo7A0iJkOVe1MdOOb2r/CElQ==
X-Received: by 2002:a05:6a00:47:b0:5a9:b4eb:d262 with SMTP id i7-20020a056a00004700b005a9b4ebd262mr4715420pfk.1.1677640230510;
        Tue, 28 Feb 2023 19:10:30 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id i22-20020aa78b56000000b00586fbbdf6e4sm6770175pfd.34.2023.02.28.19.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 19:10:29 -0800 (PST)
Date:   Wed, 1 Mar 2023 11:10:26 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2] u32: fix TC_U32_TERMINAL printing
Message-ID: <Y/7CIiBcHabfFaD6@Laptop-X1>
References: <20230228034955.1215122-1-liuhangbin@gmail.com>
 <CAM0EoM=-sSuZbgjEH_KH8WTqTXYSagN0E6JLF+MKBFDSG_z9Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoM=-sSuZbgjEH_KH8WTqTXYSagN0E6JLF+MKBFDSG_z9Hw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 05:55:30AM -0500, Jamal Hadi Salim wrote:
> Hangbin,
> Can you please run tdc tests on all tc (both for iproute2 and kernel)
> changes you make and preferably show them in the commit log? If you
> introduce something new then add a new tdc test case to cover it.

OK, the patch fixed an issue I found when run tdc u32 test.

1..11
not ok 1 afa9 - Add u32 with source match
	Could not match regex pattern. Verify command output:
filter protocol ip pref 1 u32 chain 0 
filter protocol ip pref 1 u32 chain 0 fh 800: ht divisor 1 
filter protocol ip pref 1 u32 chain 0 fh 800::800 order 2048 key ht 800 bkt 0 *flowid 1:1 not_in_hw 
  match 7f000001/ffffffff at 12
	action order 1: gact action pass
	 random type none pass val 0
	 index 1 ref 1 bind 1

After the fix, the u32.json test passed

All test results:

1..11
ok 1 afa9 - Add u32 with source match
ok 2 6aa7 - Add/Replace u32 with source match and invalid indev
ok 3 bc4d - Replace valid u32 with source match and invalid indev
ok 4 648b - Add u32 with custom hash table
ok 5 6658 - Add/Replace u32 with custom hash table and invalid handle
ok 6 9d0a - Replace valid u32 with custom hash table and invalid handle
ok 7 1644 - Add u32 filter that links to a custom hash table
ok 8 74c2 - Add/Replace u32 filter with invalid hash table id
ok 9 1fe6 - Replace valid u32 filter with invalid hash table id
ok 10 0692 - Test u32 sample option, divisor 256
ok 11 2478 - Test u32 sample option, divisor 16


When I post the patch, I though this issue is a clear logic one, so I didn't
 paste the test result.

Thanks
Hangbin
