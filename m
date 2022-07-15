Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C60576846
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 22:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbiGOUiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 16:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbiGOUiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 16:38:09 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FD57FE65
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 13:37:58 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s206so5402115pgs.3
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 13:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oxhFh9vU9ZLrk0ELcC9EfYGQ0HEDf9A9HOZTk0MO6UE=;
        b=pMXVG/mMvAhP+cAQwgtdV7dLt46FDtMPRJqUFqTezVIbk4ZXK9RP/CGRjMdTuPSS9H
         5FQNR2nermRNAajsxaiD55tMUtWFmLIP2T941T6OeRPN6gUAJrdMxYeKaIK/dWCFy0Wu
         oFMWJLyAfdbO4PyOuh60pY2/nQAKTjiUJNqkb2LVDEOldt46mDGFgCB/mnOF5f8dx6wR
         xHmE979fQVcVaN7Tr6rBLNsD5pYBPuTxURBb2n28RBxI5vZUfEINk9qPpOh2UwKMYrnG
         +1GljxxYzx0KC9sXZeBVe3cZaHC67lyA+NB5R09EqoT5V30chPQ3yAaZkjd5nmEpSX4g
         XUcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oxhFh9vU9ZLrk0ELcC9EfYGQ0HEDf9A9HOZTk0MO6UE=;
        b=XUvV1kV4AQJzzR/H/M2dmRSwmprm4KmYy0WFVycNzYXCsPLInbaUbiY3Z5TP5ZQkf0
         1f4ymFQpaHoZ3VWrH/1imrRguumV0QcgfS59EcxB4eYlc6AYlehFk0UZpMLU87rpkJ40
         7EG4x9A9GVpEbel6L4N1Vn+9t92fKrchTuMhWsGzByFkjpST0WpTOKd5ITCF2Oa6tfSZ
         RcEpKRZnemPL+Z08ksb6pLJeIgx6VXpy8tzVUsOzhSBq5orgPW2jeid3pZyDucRbYRas
         wXA+hB+B3a6b50acSR38vvoiSurlz8YQG4QGODC/qE7BOPcrnxr5+Ynpp2hGPDkqNHM3
         cMVg==
X-Gm-Message-State: AJIora8PsrfRzOCQ9G/q1XpFAy04pbUh2XdBf9Ti1OzHiUQQSuQlYKRK
        F2yBhKKIULSSKHLpjekp4j44lA==
X-Google-Smtp-Source: AGRyM1sUWzDhMhn26mFZYOntXWOdeZydFIHZNUthDlDKKizaPYlLE6wUogHtC4OyLVZyTCDoOymZvA==
X-Received: by 2002:a63:1e42:0:b0:419:698f:e716 with SMTP id p2-20020a631e42000000b00419698fe716mr13866096pgm.155.1657917478062;
        Fri, 15 Jul 2022 13:37:58 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t6-20020a635f06000000b0040dffa7e3d7sm3592222pgb.16.2022.07.15.13.37.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 13:37:57 -0700 (PDT)
Message-ID: <b2e36f7b-2f99-d686-3726-c18b32289ed8@kernel.dk>
Date:   Fri, 15 Jul 2022 14:37:55 -0600
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
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <46439555-644d-08a1-7d66-16f8f9a320f0@samsung.com>
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

On 7/15/22 2:28 PM, Marek Szyprowski wrote:
> Hi,
> 
> On 14.07.2022 13:02, Dylan Yudaken wrote:
>> this is in preparation for multishot receive from io_uring, where it needs
>> to have access to the original struct user_msghdr.
>>
>> functionally this should be a no-op.
>>
>> Acked-by: Paolo Abeni <pabeni@redhat.com>
>> Signed-off-by: Dylan Yudaken <dylany@fb.com>
> 
> This patch landed in linux next-20220715 as commit 1a3e4e94a1b9 ("net: 
> copy from user before calling __get_compat_msghdr"). Unfortunately it 
> causes a serious regression on the ARM64 based Khadas VIM3l board:
> 
> Unable to handle kernel access to user memory outside uaccess routines 
> at virtual address 00000000ffc4a5c8
> Mem abort info:
>    ESR = 0x000000009600000f
>    EC = 0x25: DABT (current EL), IL = 32 bits
>    SET = 0, FnV = 0
>    EA = 0, S1PTW = 0
>    FSC = 0x0f: level 3 permission fault
> Data abort info:
>    ISV = 0, ISS = 0x0000000f
>    CM = 0, WnR = 0
> user pgtable: 4k pages, 48-bit VAs, pgdp=0000000001909000
> [00000000ffc4a5c8] pgd=0800000001a7b003, p4d=0800000001a7b003, 
> pud=0800000001a0e003, pmd=0800000001913003, pte=00e800000b9baf43
> Internal error: Oops: 9600000f [#1] PREEMPT SMP
> Modules linked in:
> CPU: 0 PID: 247 Comm: systemd-udevd Not tainted 5.19.0-rc6+ #12437
> Hardware name: Khadas VIM3L (DT)
> pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : get_compat_msghdr+0xd0/0x1b0
> lr : get_compat_msghdr+0xcc/0x1b0
> ...
> Call trace:
>   get_compat_msghdr+0xd0/0x1b0
>   ___sys_sendmsg+0xd0/0xe0
>   __sys_sendmsg+0x68/0xc4
>   __arm64_compat_sys_sendmsg+0x28/0x3c
>   invoke_syscall+0x48/0x114
>   el0_svc_common.constprop.0+0x60/0x11c
>   do_el0_svc_compat+0x1c/0x50
>   el0_svc_compat+0x58/0x100
>   el0t_32_sync_handler+0x90/0x140
>   el0t_32_sync+0x190/0x194
> Code: d2800382 9100f3e0 97d9be02 b5fffd60 (b9401a60)
> ---[ end trace 0000000000000000 ]---
> 
> This happens only on the mentioned board, other my ARM64 test boards 
> boot fine with next-20220715. Reverting this commit, together with 
> 2b0b67d55f13 ("fix up for "io_uring: support multishot in recvmsg"") and 
> a8b38c4ce724 ("io_uring: support multishot in recvmsg") due to compile 
> dependencies on top of next-20220715 fixes the issue.
> 
> Let me know how I can help fixing this issue.

How are you reproducing this?

-- 
Jens Axboe

