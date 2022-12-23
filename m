Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7059765530D
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 18:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbiLWRFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 12:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbiLWRFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 12:05:15 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E532F18345
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 09:05:14 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4NdtpY30Gbz9sZ5;
        Fri, 23 Dec 2022 18:05:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1671815109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rTOZObAYeq/ahR3/5yzqf6/P/StLFtliQ0IqPetpOD0=;
        b=jtFvXmybMne8FH6dGNiNS7WCPITuBZtpLWdfE4oYZdIABXwNZyViemZDGrTG0OuZ3DWO1O
        i6XiGEa7XP1SZcaejFa5/bPi4kz2jPdtyrT7W8o2LeV8yZvzYfG4jS+0qihSBRUOx6uCBo
        Tc69fEta5Wewhxmcw0WqBXvlMxE8PXVt80P8rDp/iy3gUqr9sXyZ4LF5rA5YESHg55RDyi
        M4o89hu7yChmXErTt2cJPshNwWfQCMGtxPQ2svg5y2J6voXC9p8ZFIAutDJbOFRW5OOTGz
        88VPnSzEMvu3w13OA2p4XXLWlN707v9Sd0RoMT3hYUHERUj6xTgfd0TlTBtyRg==
Message-ID: <c77f9a6e-0273-7732-7e91-6686083e24dc@hauke-m.de>
Date:   Fri, 23 Dec 2022 18:05:09 +0100
MIME-Version: 1.0
Subject: Re: [PATCH iproute2] configure: Remove include <sys/stat.h>
Content-Language: en-US
To:     Heiko Thiery <heiko.thiery@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20221221225304.3477126-1-hauke@hauke-m.de>
 <CAEyMn7bK7rfXfg99RyMvyudGHd1JVP1v1r-7rzRsx4ABgP10Lg@mail.gmail.com>
From:   Hauke Mehrtens <hauke@hauke-m.de>
In-Reply-To: <CAEyMn7bK7rfXfg99RyMvyudGHd1JVP1v1r-7rzRsx4ABgP10Lg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/23/22 07:30, Heiko Thiery wrote:
> Hi Hauke,
> 
> Am Mi., 21. Dez. 2022 um 23:53 Uhr schrieb Hauke Mehrtens <hauke@hauke-m.de>:
>>
>> The check_name_to_handle_at() function in the configure script is
>> including sys/stat.h. This include fails with glibc 2.36 like this:
>> ````
>> In file included from /linux-5.15.84/include/uapi/linux/stat.h:5,
>>                   from /toolchain-x86_64_gcc-12.2.0_glibc/include/bits/statx.h:31,
>>                   from /toolchain-x86_64_gcc-12.2.0_glibc/include/sys/stat.h:465,
>>                   from config.YExfMc/name_to_handle_at_test.c:3:
>> /linux-5.15.84/include/uapi/linux/types.h:10:2: warning: #warning "Attempt to use kernel headers from user space, see https://kernelnewbies.org/KernelHeaders" [-Wcpp]
>>     10 | #warning "Attempt to use kernel headers from user space, see https://kernelnewbies.org/KernelHeaders"
>>        |  ^~~~~~~
>> In file included from /linux-5.15.84/include/uapi/linux/posix_types.h:5,
>>                   from /linux-5.15.84/include/uapi/linux/types.h:14:
>> /linux-5.15.84/include/uapi/linux/stddef.h:5:10: fatal error: linux/compiler_types.h: No such file or directory
>>      5 | #include <linux/compiler_types.h>
>>        |          ^~~~~~~~~~~~~~~~~~~~~~~~
>> compilation terminated.
>> ````
>>
>> Just removing the include works, the manpage of name_to_handle_at() says
>> only fcntl.h is needed.
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> 
> Unfortunately I do not have an environment with uclibc-ng < 1.0.35 to
> test it against this. But I just build the package in buildroot with a
> newer version and it works with your changes.
> 
> Tested-by: Heiko Thiery <heiko.thiery@gmail.com>
> 
> thanks


Thanks for testing this with uclibc-ng. I added your tested by tag and 
the fixes tag.

Hauke

