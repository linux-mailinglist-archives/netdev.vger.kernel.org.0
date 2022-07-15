Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3FEC5768D7
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 23:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbiGOVZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 17:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbiGOVZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 17:25:42 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70BC7390C
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 14:25:38 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q5-20020a17090a304500b001efcc885cc4so7276356pjl.4
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 14:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gkMC58CI5blc0RsSllBKJaaDv6tZbiX3CK0EYe08iok=;
        b=eJZMVjmS6+Jd6dwRHPiup6/aLZyYWxGgsvJJ0bhabSiyirujXadau/34K8ZB432bKK
         RidSWYbxcMbOGu6+8ZEvygyL3Hu+dbw+0HoDbh67b2ErFP3PycLdmKO5UpO9tZ3ZtjdA
         h2gFvBxe+QCJTcXza2wJgPpnpeWGNkxHBgoa7VoCMgqOsJgINtLHEw+cywrRS8OV1u5A
         b1QUY51xc0ExXmVA36ta9l1iwO9kurfllF7vuvyH8nZDyUY1rWyawKR+k5nf4pq28iE5
         62yh6mJXLeStfjEd442QnH9r9FZHuh/hIUegfRCV65dQPwe37yfWmq1U8mhn6/AyN8pV
         AVng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gkMC58CI5blc0RsSllBKJaaDv6tZbiX3CK0EYe08iok=;
        b=Ir9XDnpylZOCPyFwv+07Sb2hSppkusxBuOxe8AkclLPhy+K+GlPeakOputLR8gtx1J
         g9XUDnZw0axT6QJQzcwT9QylHXXwYhn9NOamzaYsiacbtfTUrwdW/2X1WaAmHyFrQRQY
         I+MkZWw1W9zpkAAcJ+FVRm2B3qtSHxdh6rsq7IZ0Tr3/ZXfLp88by9uo68lnT1p90C7R
         nbe2dvQLDfdB/hmYTeuv37tQxqbHPMvgsVMKE2xTL/bxXSzh3Mztms/Xo+gXJav7ALw4
         rDr/ao600ugQMaZik/lQECC5si6kh2LHtsfTLYsQhjlnV7kzfYi98POwQG6gUScfbffR
         aPWw==
X-Gm-Message-State: AJIora/kkck8j8kei0Sdj/GwtnVAKbgL0yMSNfohjuRwrn5GCO1W3X6t
        tguIxjFlJZdDC9ORpeiI/9O1fg==
X-Google-Smtp-Source: AGRyM1vtI5yHsPWNohHA0IyOcjkudf/0alXWyajjzAFctLTigcGBk9Oejo6twqtOi8yVoqO+5TgaOA==
X-Received: by 2002:a17:902:b115:b0:16c:9837:32dd with SMTP id q21-20020a170902b11500b0016c983732ddmr12950429plr.82.1657920338081;
        Fri, 15 Jul 2022 14:25:38 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 7-20020a17090a1a4700b001f0fce69b40sm2555672pjl.17.2022.07.15.14.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 14:25:37 -0700 (PDT)
Message-ID: <d8a4e959-f3ee-252c-5d1c-42407a8e29e8@kernel.dk>
Date:   Fri, 15 Jul 2022 15:25:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 for-next 2/3] net: copy from user before calling
 __get_compat_msghdr
Content-Language: en-US
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        io-uring@vger.kernel.org
Cc:     netdev@vger.kernel.org, Kernel-team@fb.com
References: <20220714110258.1336200-1-dylany@fb.com>
 <20220714110258.1336200-3-dylany@fb.com>
 <CGME20220715202859eucas1p1a336fd34a883adb96bde608ba2ca3a12@eucas1p1.samsung.com>
 <46439555-644d-08a1-7d66-16f8f9a320f0@samsung.com>
 <b2e36f7b-2f99-d686-3726-c18b32289ed8@kernel.dk>
 <b9e1e22a-47ba-fdd8-ca12-e9bdd57afd41@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b9e1e22a-47ba-fdd8-ca12-e9bdd57afd41@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/22 2:58 PM, Marek Szyprowski wrote:
> Hi,
> 
> On 15.07.2022 22:37, Jens Axboe wrote:
>> On 7/15/22 2:28 PM, Marek Szyprowski wrote:
>>> On 14.07.2022 13:02, Dylan Yudaken wrote:
>>>> this is in preparation for multishot receive from io_uring, where it needs
>>>> to have access to the original struct user_msghdr.
>>>>
>>>> functionally this should be a no-op.
>>>>
>>>> Acked-by: Paolo Abeni <pabeni@redhat.com>
>>>> Signed-off-by: Dylan Yudaken <dylany@fb.com>
>>> This patch landed in linux next-20220715 as commit 1a3e4e94a1b9 ("net:
>>> copy from user before calling __get_compat_msghdr"). Unfortunately it
>>> causes a serious regression on the ARM64 based Khadas VIM3l board:
>>>
>>> Unable to handle kernel access to user memory outside uaccess routines
>>> at virtual address 00000000ffc4a5c8
>>> Mem abort info:
>>>     ESR = 0x000000009600000f
>>>     EC = 0x25: DABT (current EL), IL = 32 bits
>>>     SET = 0, FnV = 0
>>>     EA = 0, S1PTW = 0
>>>     FSC = 0x0f: level 3 permission fault
>>> Data abort info:
>>>     ISV = 0, ISS = 0x0000000f
>>>     CM = 0, WnR = 0
>>> user pgtable: 4k pages, 48-bit VAs, pgdp=0000000001909000
>>> [00000000ffc4a5c8] pgd=0800000001a7b003, p4d=0800000001a7b003,
>>> pud=0800000001a0e003, pmd=0800000001913003, pte=00e800000b9baf43
>>> Internal error: Oops: 9600000f [#1] PREEMPT SMP
>>> Modules linked in:
>>> CPU: 0 PID: 247 Comm: systemd-udevd Not tainted 5.19.0-rc6+ #12437
>>> Hardware name: Khadas VIM3L (DT)
>>> pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>>> pc : get_compat_msghdr+0xd0/0x1b0
>>> lr : get_compat_msghdr+0xcc/0x1b0
>>> ...
>>> Call trace:
>>>    get_compat_msghdr+0xd0/0x1b0
>>>    ___sys_sendmsg+0xd0/0xe0
>>>    __sys_sendmsg+0x68/0xc4
>>>    __arm64_compat_sys_sendmsg+0x28/0x3c
>>>    invoke_syscall+0x48/0x114
>>>    el0_svc_common.constprop.0+0x60/0x11c
>>>    do_el0_svc_compat+0x1c/0x50
>>>    el0_svc_compat+0x58/0x100
>>>    el0t_32_sync_handler+0x90/0x140
>>>    el0t_32_sync+0x190/0x194
>>> Code: d2800382 9100f3e0 97d9be02 b5fffd60 (b9401a60)
>>> ---[ end trace 0000000000000000 ]---
>>>
>>> This happens only on the mentioned board, other my ARM64 test boards
>>> boot fine with next-20220715. Reverting this commit, together with
>>> 2b0b67d55f13 ("fix up for "io_uring: support multishot in recvmsg"") and
>>> a8b38c4ce724 ("io_uring: support multishot in recvmsg") due to compile
>>> dependencies on top of next-20220715 fixes the issue.
>>>
>>> Let me know how I can help fixing this issue.
>> How are you reproducing this?
> 
> This happens always during system boot on the mentioned board, when udev 
> starts discovering devices. The complete boot log is here:
> 
> https://pastebin.com/i8WzFzcx

Does this help?


diff --git a/net/compat.c b/net/compat.c
index 513aa9a3fc64..ed880729d159 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -89,7 +89,7 @@ int get_compat_msghdr(struct msghdr *kmsg,
 	if (copy_from_user(&msg, umsg, sizeof(*umsg)))
 		return -EFAULT;
 
-	err = __get_compat_msghdr(kmsg, umsg, save_addr);
+	err = __get_compat_msghdr(kmsg, &msg, save_addr);
 	if (err)
 		return err;
 

-- 
Jens Axboe

