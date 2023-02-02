Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEDA0687340
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 03:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjBBCIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 21:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjBBCID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 21:08:03 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33AB83ABB
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 18:07:58 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id x6so253001ilv.7
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 18:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3+BzeSJVfgrSPd0MbuqsjRM9bEzGlx7ixViHWjjvE7s=;
        b=LzWodT1eb5DCcVhR8b+EzMloXXDPgbgfg5yAdRijbYs5VrwQKJ5b4Xn3BrOcQv6ZHm
         j/bfvWWLI1MwoyyRBH16YFEsS/RLHZmYDtrOK68OuhisrVKoWYrz8AY7DIZEDOe1gDZx
         4OF2YnlUs2qkyWJbriJ9+QAh5N1DZRxJo+pdc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3+BzeSJVfgrSPd0MbuqsjRM9bEzGlx7ixViHWjjvE7s=;
        b=li5fQs/3IbM+qfJ9MpBei71XOI2+Hb7ZkVhOsLQqtLE2G79cNWSeCI9Mu+fpdOa+dN
         rK0I6SZoaw6GtwEOY7DV+lU5aJ8TedvTDKzk4LUgYPGjsRUG9c0JMuoTLcgDD/goVSl7
         t9DlZhzL1A2tH5EvITWDPi1aqsfOGSrQD4Lif7tBMT/B06hNWxmaalPKorhPAX7lwt0W
         57hA0RI1S+6+6fGrdvn9jbKMDhHnd+V7js+w6DKErmHj3xfexw3zjEzj+LU9h3XeS4/u
         0xiz0g2rd39WbrFWaa7BgyhzzooOlJ3aQtnOCQFPavxOdgqUjvZ92mLhMN6YvukmTNhK
         BHAg==
X-Gm-Message-State: AO0yUKUGxS21rIjPjo5bECrmzCswg8mMwHbI18ghE7e9rvr37P6K7Aum
        xlwwhwq+nZ+Afbn8PV4ivJUUPX8UdXoxpeV0
X-Google-Smtp-Source: AK7set885G9fsVi6nyk8fZGA4Ca40+OFghSuF3kmr1dqRUTOmqFNraoAAvKt0LfXBjQfFbwgGTGQkA==
X-Received: by 2002:a92:d341:0:b0:310:a904:33ed with SMTP id a1-20020a92d341000000b00310a90433edmr2899734ilh.0.1675303677369;
        Wed, 01 Feb 2023 18:07:57 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id d26-20020a05663802ba00b0039ea2dfebb3sm7259077jaq.24.2023.02.01.18.07.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 18:07:56 -0800 (PST)
Message-ID: <799b87d9-af19-0e6a-01b7-419b4893a0df@linuxfoundation.org>
Date:   Wed, 1 Feb 2023 19:07:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 00/34] selftests: Fix incorrect kernel headers search path
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Cc:     linux-kernel@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
 <560824bd-da2d-044c-4f71-578fc34a47cd@linuxfoundation.org>
Content-Language: en-US
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <560824bd-da2d-044c-4f71-578fc34a47cd@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mathieu,

On 1/30/23 15:29, Shuah Khan wrote:
> On 1/27/23 06:57, Mathieu Desnoyers wrote:
>> Hi,
>>
>> This series fixes incorrect kernel header search path in kernel
>> selftests.
>>
>> Near the end of the series, a few changes are not tagged as "Fixes"
>> because the current behavior is to rely on the kernel sources uapi files
>> rather than on the installed kernel header files. Nevertheless, those
>> are updated for consistency.
>>
>> There are situations where "../../../../include/" was added to -I search
>> path, which is bogus for userspace tests and caused issues with types.h.
>> Those are removed.
>>

Thanks again for taking care of this. I did out of tree build testing on
x86 on linux-kselftest next with these patches below. I haven't seen
any problems introduced by the patch set.

>>    selftests: dma: Fix incorrect kernel headers search path
This one needs a change and I will send a patch on top of yours.
Even with that this test depends on unexported header from the
repo and won't build out of tree. This is not related to your
change.

>>    selftests: mount_setattr: Fix incorrect kernel headers search path
This one fails to build with our without patch - an existing error.

I have to do cross-build tests on arm64 and other arch patches still.
This will happen later this week.

>>    selftests: arm64: Fix incorrect kernel headers search path

drivers patch below had arch specific tests - testing todo

The rest looks good. I will try to run bpf patches on my system.
I do have clang, llvm installed on mine. TODO

thanks,
-- Shuah
