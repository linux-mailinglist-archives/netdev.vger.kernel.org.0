Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2441E68A76E
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 02:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbjBDBGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 20:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbjBDBGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 20:06:18 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9A768103
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 17:06:17 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id y2so2621054iot.4
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 17:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EJJNrsJn7yzBqph2acvSr4Hti6BrkgyiwRkgePteRzI=;
        b=cOFCW2eKrPz/F7vUGV3S812saggF5YeG/hVM7hcFN7yyU4S9pS1nxzMNle0FhONcm0
         QinIgL9G1RKgP/tdAGV0W7F1TlYTQQnn5j6CVZ8G16iJYwrrpp8MBWSstnhHVVbP9jaa
         +1GfdV7ZDn1qFvbfmQwolq9ris01IwB9DRXK0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EJJNrsJn7yzBqph2acvSr4Hti6BrkgyiwRkgePteRzI=;
        b=2tYD4Sgj9PHdqsnsiHlRg7WzBOe+QL4pRfdFYs3g3PT4oYSuLyP657dKcoiFSVZwWR
         bdWQh75Mf48gsGIgUbmSP5iUgzR+OAQBsI/TURjCkUm472LPSxcIwAtllMON9XgjDfwo
         rCstCVZ1kVCfSYQCbGY2CpI5GVdvliQePk5S2bHkuM+zTnDGNs2II2J3AmHmlv53GJ8f
         zNa0gTkvgw7bxDsx/IzWdEqZpFtEFR67HS2vJz0Df8TST+cH8v+3HN5q8iFHiPzla+G2
         PxYF/5rXBUL0fTJVdCwzay6UayX1yI6dbAdrFNx/1A+6OCdPSy+PZ4z6Zaq/XNE9EpNw
         YNig==
X-Gm-Message-State: AO0yUKUA4ULGoicFU4JkJUGV4wERKcE8+SNru8u4dS7H2WzJ2mD0g72O
        2u033IOZNBAgHNWAujlHZvknMw==
X-Google-Smtp-Source: AK7set9499rugZh/K8yzehbsATZ6fL7OrnwVY1iWmkEuyNyOtCYXT0lcwjPiJcBHW95uVphhlXqPsA==
X-Received: by 2002:a6b:3b14:0:b0:715:f031:a7f5 with SMTP id i20-20020a6b3b14000000b00715f031a7f5mr6443794ioa.1.1675472776701;
        Fri, 03 Feb 2023 17:06:16 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id h16-20020a022b10000000b003a970f21f9asm1294500jaa.78.2023.02.03.17.06.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 17:06:15 -0800 (PST)
Message-ID: <975995d6-366a-88e3-2321-f0728f7e22a7@linuxfoundation.org>
Date:   Fri, 3 Feb 2023 18:06:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 00/34] selftests: Fix incorrect kernel headers search path
Content-Language: en-US
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Cc:     linux-kernel@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
 <560824bd-da2d-044c-4f71-578fc34a47cd@linuxfoundation.org>
 <799b87d9-af19-0e6a-01b7-419b4893a0df@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <799b87d9-af19-0e6a-01b7-419b4893a0df@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/23 19:07, Shuah Khan wrote:
> Hi Mathieu,
> 
> On 1/30/23 15:29, Shuah Khan wrote:
>> On 1/27/23 06:57, Mathieu Desnoyers wrote:
>>> Hi,
>>>
>>> This series fixes incorrect kernel header search path in kernel
>>> selftests.
>>>
>>> Near the end of the series, a few changes are not tagged as "Fixes"
>>> because the current behavior is to rely on the kernel sources uapi files
>>> rather than on the installed kernel header files. Nevertheless, those
>>> are updated for consistency.
>>>
>>> There are situations where "../../../../include/" was added to -I search
>>> path, which is bogus for userspace tests and caused issues with types.h.
>>> Those are removed.
>>>
> 
> Thanks again for taking care of this. I did out of tree build testing on
> x86 on linux-kselftest next with these patches below. I haven't seen
> any problems introduced by the patch set.
> 
>>>    selftests: dma: Fix incorrect kernel headers search path
> This one needs a change and I will send a patch on top of yours.
> Even with that this test depends on unexported header from the
> repo and won't build out of tree. This is not related to your
> change.
> 
>>>    selftests: mount_setattr: Fix incorrect kernel headers search path
> This one fails to build with our without patch - an existing error.
> 
> I have to do cross-build tests on arm64 and other arch patches still.
> This will happen later this week.

arm64, s390 patches look good.

thanks,
-- Shuah
