Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E178758817
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfF0ROH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:14:07 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:46393 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfF0ROG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:14:06 -0400
Received: by mail-io1-f70.google.com with SMTP id s83so3309398iod.13
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 10:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=0xoNZyk4kpn5MObgO7gsjfUHk2xSfL/r3fmiyjl8Q2A=;
        b=ukgTYiQwfnGicngzKjgKtguCMyM3Lcbz9XW40tKNh0cHF7IopFA6vzznyvfAkEZLo5
         KDCxGvPMLTRKjJacFJZhynwOgmAyCmc90vEeJqxBqKOtd3h4AZWQbmIS0670O0KmUst6
         kW4s+pQEdxUiVJgWNnxrrXubmq2OIdhZSiYxLvSZwQGzfaArpcVj5WUxZTtgrAdnnZgL
         L4wpo6+9pQCx9a+g7UBwgnebqnIm7KBiMune9qYE6RTQZ2UcwecREqz06O2cG23//te7
         7hTQwyKmVjMoUdbBfcA/O4i529vTqIbPhIA9v7VGaKvktckI6nFpPNWXKEglC73WtPgO
         3uIQ==
X-Gm-Message-State: APjAAAVplwmZVnTeWkiVyxtyPAoA9LSbylz2WvptcQn+8/VBOWNRkxHl
        syppf87bDSlaFoB7yYyguBiHmlotbM+UjXoGz9N4Ik9qBusS
X-Google-Smtp-Source: APXvYqzmmL3QfniIfIyU0hiLnDhXidMckh4y6/hhi2CbXfqeBvWrBqqa9Kt3AZpyt0ev5SrA4msilTduA/N3+m8OtqxuZLHqZkuu
MIME-Version: 1.0
X-Received: by 2002:a6b:f00c:: with SMTP id w12mr5714279ioc.280.1561655645648;
 Thu, 27 Jun 2019 10:14:05 -0700 (PDT)
Date:   Thu, 27 Jun 2019 10:14:05 -0700
In-Reply-To: <000000000000a97a15058c50c52e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000053e16058c514a2d@google.com>
Subject: Re: KMSAN: uninit-value in aesti_encrypt
From:   syzbot <syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net, ebiggers@kernel.org,
        glider@google.com, herbert@gondor.apana.org.au,
        john.fastabend@gmail.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    41550654 [UPSTREAM] KVM: x86: degrade WARN to pr_warn_rate..
git tree:       kmsan
console output: https://syzkaller.appspot.com/x/log.txt?x=11302ccba00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=40511ad0c5945201
dashboard link: https://syzkaller.appspot.com/bug?extid=6f50c99e8f6194bf363f
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12906f79a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14355961a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com

==================================================================
BUG: KMSAN: uninit-value in subshift crypto/aes_ti.c:148 [inline]
BUG: KMSAN: uninit-value in aesti_encrypt+0x1238/0x1bc0 crypto/aes_ti.c:292
CPU: 0 PID: 11119 Comm: syz-executor333 Not tainted 5.2.0-rc4+ #7
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x162/0x2d0 mm/kmsan/kmsan.c:611
  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:304
  subshift crypto/aes_ti.c:148 [inline]
  aesti_encrypt+0x1238/0x1bc0 crypto/aes_ti.c:292
  crypto_cipher_encrypt_one include/linux/crypto.h:1753 [inline]
  crypto_cbcmac_digest_update+0x3cf/0x550 crypto/ccm.c:871
  crypto_shash_update crypto/shash.c:107 [inline]
  shash_ahash_finup+0x659/0xb20 crypto/shash.c:276
  shash_async_finup+0xbb/0x110 crypto/shash.c:291
  crypto_ahash_op+0x1cd/0x6e0 crypto/ahash.c:368
  crypto_ahash_finup+0x8c/0xb0 crypto/ahash.c:393
  crypto_ccm_auth+0x14b2/0x1570 crypto/ccm.c:230
  crypto_ccm_encrypt+0x272/0x8d0 crypto/ccm.c:309
  crypto_aead_encrypt include/crypto/aead.h:331 [inline]
  tls_do_encryption net/tls/tls_sw.c:521 [inline]
  tls_push_record+0x341a/0x4f70 net/tls/tls_sw.c:730
  bpf_exec_tx_verdict+0x1454/0x1c90 net/tls/tls_sw.c:770
  tls_sw_sendmsg+0x15bd/0x2740 net/tls/tls_sw.c:1033
  inet_sendmsg+0x48e/0x750 net/ipv4/af_inet.c:798
  sock_sendmsg_nosec net/socket.c:646 [inline]
  sock_sendmsg net/socket.c:665 [inline]
  __sys_sendto+0x905/0xb90 net/socket.c:1958
  __do_sys_sendto net/socket.c:1970 [inline]
  __se_sys_sendto+0x107/0x130 net/socket.c:1966
  __x64_sys_sendto+0x6e/0x90 net/socket.c:1966
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:302
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x4402d9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffcef4112e8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004402d9
RDX: ffffffffffffff7f RSI: 00000000200005c0 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: fffffffffffffd56
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401b60
R13: 0000000000401bf0 R14: 0000000000000000 R15: 0000000000000000

Uninit was stored to memory at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:201 [inline]
  kmsan_save_stack mm/kmsan/kmsan.c:213 [inline]
  kmsan_internal_chain_origin+0xcc/0x150 mm/kmsan/kmsan.c:414
  __msan_chain_origin+0x6b/0xe0 mm/kmsan/kmsan_instr.c:200
  __crypto_xor+0x1e8/0x1470 crypto/algapi.c:1019
  crypto_xor include/crypto/algapi.h:214 [inline]
  crypto_cbcmac_digest_update+0x2ba/0x550 crypto/ccm.c:865
  crypto_shash_update crypto/shash.c:107 [inline]
  shash_ahash_finup+0x659/0xb20 crypto/shash.c:276
  shash_async_finup+0xbb/0x110 crypto/shash.c:291
  crypto_ahash_op+0x1cd/0x6e0 crypto/ahash.c:368
  crypto_ahash_finup+0x8c/0xb0 crypto/ahash.c:393
  crypto_ccm_auth+0x14b2/0x1570 crypto/ccm.c:230
  crypto_ccm_encrypt+0x272/0x8d0 crypto/ccm.c:309
  crypto_aead_encrypt include/crypto/aead.h:331 [inline]
  tls_do_encryption net/tls/tls_sw.c:521 [inline]
  tls_push_record+0x341a/0x4f70 net/tls/tls_sw.c:730
  bpf_exec_tx_verdict+0x1454/0x1c90 net/tls/tls_sw.c:770
  tls_sw_sendmsg+0x15bd/0x2740 net/tls/tls_sw.c:1033
  inet_sendmsg+0x48e/0x750 net/ipv4/af_inet.c:798
  sock_sendmsg_nosec net/socket.c:646 [inline]
  sock_sendmsg net/socket.c:665 [inline]
  __sys_sendto+0x905/0xb90 net/socket.c:1958
  __do_sys_sendto net/socket.c:1970 [inline]
  __se_sys_sendto+0x107/0x130 net/socket.c:1966
  __x64_sys_sendto+0x6e/0x90 net/socket.c:1966
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:302
  entry_SYSCALL_64_after_hwframe+0x63/0xe7

Uninit was created at:
  kmsan_save_stack_with_flags+0x37/0x70 mm/kmsan/kmsan.c:201
  kmsan_internal_alloc_meta_for_pages+0x123/0x510 mm/kmsan/kmsan_hooks.c:103
  kmsan_alloc_page+0x7a/0xf0 mm/kmsan/kmsan_hooks.c:247
  __alloc_pages_nodemask+0x144d/0x6020 mm/page_alloc.c:4700
  alloc_pages_current+0x6a0/0x9b0 mm/mempolicy.c:2132
  alloc_pages include/linux/gfp.h:511 [inline]
  skb_page_frag_refill+0x15e/0x560 net/core/sock.c:2349
  sk_page_frag_refill+0xa4/0x330 net/core/sock.c:2369
  sk_msg_alloc+0x203/0x1050 net/core/skmsg.c:37
  tls_alloc_encrypted_msg net/tls/tls_sw.c:284 [inline]
  tls_sw_sendmsg+0xb6a/0x2740 net/tls/tls_sw.c:953
  inet_sendmsg+0x48e/0x750 net/ipv4/af_inet.c:798
  sock_sendmsg_nosec net/socket.c:646 [inline]
  sock_sendmsg net/socket.c:665 [inline]
  __sys_sendto+0x905/0xb90 net/socket.c:1958
  __do_sys_sendto net/socket.c:1970 [inline]
  __se_sys_sendto+0x107/0x130 net/socket.c:1966
  __x64_sys_sendto+0x6e/0x90 net/socket.c:1966
  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:302
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
==================================================================

