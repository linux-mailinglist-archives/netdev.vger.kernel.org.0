Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E92E1326E5
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 05:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfFCD3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 23:29:15 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40467 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfFCD3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 23:29:15 -0400
Received: by mail-pl1-f194.google.com with SMTP id g69so6410422plb.7
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 20:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=PQnXGGdP/A5D00bGfCWs4uE8hOzXxm1T6ltCq+vih2k=;
        b=JbUuCmkBAx+r/hth75ibePfnv/okC9RF5r6d6bzfXFqpY4LPGV4ZP82/is8OAM+hHo
         DtFMBLbJFOVcVoD2fOmPuGrWBUwZXYmD5vS1AqkOJ5kGhPyutHdvO6BHybwIUXu8HVZQ
         ybSmbhB7Gu6lE5ixjiTuGvgcI3+JLxD/2AvkC2N/geDoDcfg/j7REhcFhg75KOPO6Baa
         LhKCpIj3j+g/aHqYI89P/1Xofn/dsIIGfb5aZvKcDUkyYms0qMQFjhZW1PRUG1M9AjFg
         W8RXOeQSOIwa7/CEVn+i8b92VkhKPptQ5XTIruu3gioCr0fb71WsNLWueU/7P4x5mAal
         7DKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PQnXGGdP/A5D00bGfCWs4uE8hOzXxm1T6ltCq+vih2k=;
        b=PG6eKgWggy6UJ/SDWupYzDZzJq4qWamHZPUMp67a4DcCxCbi5Ckye2ncVP8eMK/Y3G
         RWMED34FNmbrr0P0zzWCqkp3Q4nRYol/Coi7057cBFSO8sidKqsa4l3/8So2EsIRFWJR
         J+7uCMpPlGsqbVqCwwO5pej6pdpCzagzYw6MQUSY50v/X+2HMoTuRGGctkZzndsc+FdX
         fGNF2r5K5w7YzSSshlp76UyImkCXr8fdDeAkXY+MD/rrf02LoeFJaZfL/9gYrMuDSDmV
         3WCrznVzCP3y3drAvg7gdJkHFSULSUevX4g7rDcmMSrT6UxMRxhqnibSWLTNkBaVZgXc
         4kTg==
X-Gm-Message-State: APjAAAWzFFDBJN5hqns9N/J9VM0c8c0bGfXgCxMGgSkpio8A/5s+A0JT
        6yGoUtKBBdy6lPxYKhTGgx0=
X-Google-Smtp-Source: APXvYqy2qnYTyfcEIOtexvCRUrU6KJhumEJOtpya9S3EJFtapSULjHRZfUcbOMAXzEiRyYp0ZIb+7A==
X-Received: by 2002:a17:902:8bc1:: with SMTP id r1mr26658145plo.163.1559532554671;
        Sun, 02 Jun 2019 20:29:14 -0700 (PDT)
Received: from [172.27.227.194] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id k3sm12921346pgo.81.2019.06.02.20.29.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 20:29:13 -0700 (PDT)
Subject: Re: KASAN: user-memory-access Read in ip6_hold_safe (3)
To:     syzbot <syzbot+a5b6e01ec8116d046842@syzkaller.appspotmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <000000000000a7776f058a3ce9db@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <88c0d223-f958-06d1-067a-ee7f2c801d71@gmail.com>
Date:   Sun, 2 Jun 2019 21:29:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <000000000000a7776f058a3ce9db@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/19 12:05 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    dfb569f2 net: ll_temac: Fix compile error

just an FYI: this is before any of my IPv6 changes in 5.2-next that are
relevant. At this commit the only IPv6 changes of mine are:

19a3b7eea424 ipv6: export function to send route updates
cdaa16a4f70c ipv6: Add hook to bump sernum for a route to stubs
68a9b13d9219 ipv6: Add delete route hook to stubs

which are function exports - unused at commit dfb569f2.


> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=10afcb8aa00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fc045131472947d7
> dashboard link:
> https://syzkaller.appspot.com/bug?extid=a5b6e01ec8116d046842
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+a5b6e01ec8116d046842@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: user-memory-access in atomic_read
> include/asm-generic/atomic-instrumented.h:26 [inline]
> BUG: KASAN: user-memory-access in atomic_fetch_add_unless
> include/linux/atomic-fallback.h:1086 [inline]
> BUG: KASAN: user-memory-access in atomic_add_unless
> include/linux/atomic-fallback.h:1111 [inline]
> BUG: KASAN: user-memory-access in atomic_inc_not_zero
> include/linux/atomic-fallback.h:1127 [inline]
> BUG: KASAN: user-memory-access in dst_hold_safe include/net/dst.h:297
> [inline]
> BUG: KASAN: user-memory-access in ip6_hold_safe+0xad/0x380
> net/ipv6/route.c:1050
> Read of size 4 at addr 0000000000001ec4 by task syz-executor.0/10106

0xc1ec4 is not a valid address for an allocated rt6_info.

> 
> CPU: 0 PID: 10106 Comm: syz-executor.0 Not tainted 5.2.0-rc1+ #5
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>  __kasan_report.cold+0x5/0x40 mm/kasan/report.c:321
>  kasan_report+0x12/0x20 mm/kasan/common.c:614
>  check_memory_region_inline mm/kasan/generic.c:185 [inline]
>  check_memory_region+0x123/0x190 mm/kasan/generic.c:191
>  kasan_check_read+0x11/0x20 mm/kasan/common.c:94
>  atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
>  atomic_fetch_add_unless include/linux/atomic-fallback.h:1086 [inline]
>  atomic_add_unless include/linux/atomic-fallback.h:1111 [inline]
>  atomic_inc_not_zero include/linux/atomic-fallback.h:1127 [inline]
>  dst_hold_safe include/net/dst.h:297 [inline]
>  ip6_hold_safe+0xad/0x380 net/ipv6/route.c:1050
>  rt6_get_pcpu_route net/ipv6/route.c:1277 [inline]

My hunch is that this is memory corruption in the pcpu memory space.

In a fib6_info, rt6i_pcpu is non-NULL for ALL fib6_info except
fib6_null_entry for which pcpu routes are never generated.

rt6i_pcpu is allocated via pcpu_alloc which means this memory space is
amongst other pcpu users and easily stepped on by other pcpu users. The
entries stored in rt6_pcpu are kmem_cache entries for the ipv6 dst cache
and either a valid allocated memory address or NULL.

Past issues with pcpu routes was the 'from' (the fib6_info used to
generate the rt6_info) being NULL (several), the fib entry getting
released more than it should (0e2338749192) or not getting freed at all
(61fb0d016807).
