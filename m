Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1476D495415
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 19:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346848AbiATSUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 13:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346954AbiATSUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 13:20:35 -0500
Received: from smtp-190f.mail.infomaniak.ch (smtp-190f.mail.infomaniak.ch [IPv6:2001:1600:3:17::190f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE4BC06161C
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 10:20:34 -0800 (PST)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4JfrR30wHPzMpp4H;
        Thu, 20 Jan 2022 19:20:31 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4JfrR04KcwzlhSM0;
        Thu, 20 Jan 2022 19:20:28 +0100 (CET)
Message-ID: <4d2b0f3f-4783-3681-382d-4084c6bf79fc@digikod.net>
Date:   Thu, 20 Jan 2022 19:20:38 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        chiminghao <chi.minghao@zte.com.cn>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        "open list:LANDLOCK SECURITY MODULE" 
        <linux-security-module@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "open list:NETWORKING [MPTCP]" <mptcp@lists.linux.dev>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
Cc:     kernel@collabora.com
References: <20220119101531.2850400-1-usama.anjum@collabora.com>
 <20220119101531.2850400-7-usama.anjum@collabora.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH V2 06/10] selftests: landlock: Add the uapi headers
 include variable
In-Reply-To: <20220119101531.2850400-7-usama.anjum@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 19/01/2022 11:15, Muhammad Usama Anjum wrote:
> Out of tree build of this test fails if relative path of the output
> directory is specified. Add the KHDR_INCLUDES to correctly reach the
> headers.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
> Changes in V2:
>          Revert the excessive cleanup which was breaking the individual
> test build.
> ---
>   tools/testing/selftests/landlock/Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/landlock/Makefile b/tools/testing/selftests/landlock/Makefile
> index a99596ca9882..0b0049e133bb 100644
> --- a/tools/testing/selftests/landlock/Makefile
> +++ b/tools/testing/selftests/landlock/Makefile
> @@ -1,6 +1,6 @@
>   # SPDX-License-Identifier: GPL-2.0
>   
> -CFLAGS += -Wall -O2
> +CFLAGS += -Wall -O2 $(KHDR_INCLUDES)

Reviewed-by: Mickaël Salaün <mic@linux.microsoft.com>

It works for me, but I'm wondering if a missing -I path could cause any 
issue (cf. -I$(khdr_dir) bellow in this file). My GCC and clang ignore 
such non-existent paths unless -Wmissing-include-dirs is used, which 
would print a warning on your CI, but I guess that's OK.

>   
>   src_test := $(wildcard *_test.c)
>   
