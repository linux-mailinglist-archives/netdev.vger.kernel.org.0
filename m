Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20F63F5C58
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 12:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbhHXKsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 06:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235905AbhHXKst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 06:48:49 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4046EC061757;
        Tue, 24 Aug 2021 03:48:05 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id l18so29274772lji.12;
        Tue, 24 Aug 2021 03:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=sV9A6fCxSXqAn2G6YZJUCvQ/NbClowiNlaU/ZXl6cdw=;
        b=cwqn3tTO58j2oxSneW3/nHs0QUqI2GdSo7nF+zt8shu76HADZ5838L09lrM8voeuvs
         +JcoIlKU3DX3S1LUDxfzb9RoB98pNuMzAia+FCEwCIHAooLOx1ee8CreAbW27McSDMCC
         9ElMHb5+dLFU5HSlhw+3VWofoNpe8OWqT4WhiaUV760O6f0SSwrf4vMBaXktvs53bdyr
         CHufYmbtg0yZ4W0FlJK0R7OGQm828Paacg/5s1Efh7qt1UXt/GaKBltnxcKZGzxMp3gf
         cVQ/ZSWfY0S6wymNAT7PW/8lwj8WKLrbvypuR+88zO4OctSHEfWLKVbxsTwbFuyEyPQP
         08fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sV9A6fCxSXqAn2G6YZJUCvQ/NbClowiNlaU/ZXl6cdw=;
        b=r9ALSmgZ+ar/Fcm1SLGVqZom0TU8Vv2nJDYzbfJE7d/rbyljMIfdzFZopXdXBN2yre
         z9Q//2/prASQWSG9m6QMHbHopza7zxQIRfO07MF0x6wwwL6hu6AOyhae/E6/06HB985/
         IhOICY0KGXmUK8ynYkecTLDFrddmC5Mr6z40/AtKd0hNOv4BR87irEo6an8KrRoxNbTq
         FPCEiiRCndn6uV2HQGS5TzQ1sxCAHKWi84/vmuFXNVGp7znUUSUUCTnFjit2j8YQMz99
         hob48SI7PuimDKnhVC9L5pyPxqEy4Jg8ikA9psPS2sXXbtfKHtiHpvXjUKjONHMHsdsV
         U1pg==
X-Gm-Message-State: AOAM533ZEJk5NjP0n/ii3XQ4b/ACDBkJXCRH0lpWdl38bsWDDSwYRlTG
        qpX0YDqUkdG1oGQTaUUUU/c=
X-Google-Smtp-Source: ABdhPJy/YdVmMQWjBZLo6tvpjTgGsqyZDG4dnUOk6nmXTg7B/o3mQubKaw0pAlHlrD7CVi5HQJDpDg==
X-Received: by 2002:a2e:bd06:: with SMTP id n6mr26558332ljq.52.1629802083468;
        Tue, 24 Aug 2021 03:48:03 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.66.127])
        by smtp.gmail.com with ESMTPSA id y10sm1881615lfh.40.2021.08.24.03.48.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 03:48:02 -0700 (PDT)
Subject: Re: [syzbot] KASAN: use-after-free Write in null_skcipher_crypt
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     syzbot <syzbot+d2c5e6980bfc84513464@syzkaller.appspotmail.com>,
        calvin.johnson@oss.nxp.com, davem@davemloft.net,
        grant.likely@arm.com, herbert@gondor.apana.org.au,
        ioana.ciornei@nxp.com, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, dkadashev@gmail.com,
        viro@zeniv.linux.org.uk
References: <000000000000c910c305c9c4962e@google.com>
 <7f4eed54-4e40-2e85-eaaa-95b1864c6649@gmail.com>
Message-ID: <2e7d8a38-da4b-a79b-2482-f5d05a4dbbfd@gmail.com>
Date:   Tue, 24 Aug 2021 13:48:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <7f4eed54-4e40-2e85-eaaa-95b1864c6649@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/17/21 10:04 PM, Pavel Skripkin wrote:
> On 8/17/21 8:24 PM, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    a9a507013a6f Merge tag 'ieee802154-for-davem-2021-08-12' o..
>> git tree:       net
>> console output: https://syzkaller.appspot.com/x/log.txt?x=16647ca1300000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=343fd21f6f4da2d6
>> dashboard link: https://syzkaller.appspot.com/bug?extid=d2c5e6980bfc84513464
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14989fe9300000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12b1a779300000
>> 
>> The issue was bisected to:
>> 
>> commit 8d2cb3ad31181f050af4d46d6854cf332d1207a9
>> Author: Calvin Johnson <calvin.johnson@oss.nxp.com>
>> Date:   Fri Jun 11 10:53:55 2021 +0000
>> 
>>      of: mdio: Refactor of_mdiobus_register_phy()
>> 
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=106b97d6300000
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=126b97d6300000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=146b97d6300000
>> 
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+d2c5e6980bfc84513464@syzkaller.appspotmail.com
>> Fixes: 8d2cb3ad3118 ("of: mdio: Refactor of_mdiobus_register_phy()")
>> 
>> ==================================================================
>> BUG: KASAN: use-after-free in memcpy include/linux/fortify-string.h:191 [inline]
>> BUG: KASAN: use-after-free in null_skcipher_crypt+0xa8/0x120 crypto/crypto_null.c:85
>> Write of size 4096 at addr ffff88801c040000 by task syz-executor554/8455
>> 
>> CPU: 0 PID: 8455 Comm: syz-executor554 Not tainted 5.14.0-rc4-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>>   __dump_stack lib/dump_stack.c:88 [inline]
>>   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
>>   print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:233
>>   __kasan_report mm/kasan/report.c:419 [inline]
>>   kasan_report.cold+0x83/0xdf mm/kasan/report.c:436
>>   check_region_inline mm/kasan/generic.c:183 [inline]
>>   kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
>>   memcpy+0x39/0x60 mm/kasan/shadow.c:66
>>   memcpy include/linux/fortify-string.h:191 [inline]
>>   null_skcipher_crypt+0xa8/0x120 crypto/crypto_null.c:85
>>   crypto_skcipher_encrypt+0xaa/0xf0 crypto/skcipher.c:630
>>   crypto_authenc_encrypt+0x3b4/0x510 crypto/authenc.c:222
>>   crypto_aead_encrypt+0xaa/0xf0 crypto/aead.c:94
>>   esp6_output_tail+0x777/0x1a90 net/ipv6/esp6.c:659
>>   esp6_output+0x4af/0x8a0 net/ipv6/esp6.c:735
>>   xfrm_output_one net/xfrm/xfrm_output.c:552 [inline]
>>   xfrm_output_resume+0x2997/0x5ae0 net/xfrm/xfrm_output.c:587
>>   xfrm_output2 net/xfrm/xfrm_output.c:614 [inline]
>>   xfrm_output+0x2e7/0xff0 net/xfrm/xfrm_output.c:744
>>   __xfrm6_output+0x4c3/0x1260 net/ipv6/xfrm6_output.c:87
>>   NF_HOOK_COND include/linux/netfilter.h:296 [inline]
>>   xfrm6_output+0x117/0x550 net/ipv6/xfrm6_output.c:92
>>   dst_output include/net/dst.h:448 [inline]
>>   ip6_local_out+0xaf/0x1a0 net/ipv6/output_core.c:161
>>   ip6_send_skb+0xb7/0x340 net/ipv6/ip6_output.c:1935
>>   ip6_push_pending_frames+0xdd/0x100 net/ipv6/ip6_output.c:1955
>>   rawv6_push_pending_frames net/ipv6/raw.c:613 [inline]
>>   rawv6_sendmsg+0x2a87/0x3990 net/ipv6/raw.c:956
>>   inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:821
>>   sock_sendmsg_nosec net/socket.c:703 [inline]
>>   sock_sendmsg+0xcf/0x120 net/socket.c:723
>>   ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
>>   ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
>>   __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x43f4b9
>> Code: 1d 01 00 85 c0 b8 00 00 00 00 48 0f 44 c3 5b c3 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007ffc1e9cfff8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f4b9
>> RDX: 0000000000000000 RSI: 0000000020000500 RDI: 0000000000000004
>> RBP: 0000000000000005 R08: 6c616b7a79732f2e R09: 6c616b7a79732f2e
>> R10: 00000000000000e8 R11: 0000000000000246 R12: 00000000004034b0
>> R13: 0000000000000000 R14: 00000000004ad018 R15: 0000000000400488
>> 
>> Allocated by task 1:
>>   kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>>   kasan_set_track mm/kasan/common.c:46 [inline]
>>   set_alloc_info mm/kasan/common.c:434 [inline]
>>   __kasan_slab_alloc+0x84/0xa0 mm/kasan/common.c:467
>>   kasan_slab_alloc include/linux/kasan.h:254 [inline]
>>   slab_post_alloc_hook mm/slab.h:519 [inline]
>>   slab_alloc_node mm/slub.c:2956 [inline]
>>   slab_alloc mm/slub.c:2964 [inline]
>>   kmem_cache_alloc+0x285/0x4a0 mm/slub.c:2969
>>   getname_flags.part.0+0x50/0x4f0 fs/namei.c:138
>>   getname_flags fs/namei.c:2747 [inline]
>>   user_path_at_empty+0xa1/0x100 fs/namei.c:2747
>>   user_path_at include/linux/namei.h:57 [inline]
>>   vfs_statx+0x142/0x390 fs/stat.c:203
>>   vfs_fstatat fs/stat.c:225 [inline]
>>   vfs_lstat include/linux/fs.h:3386 [inline]
>>   __do_sys_newlstat+0x91/0x110 fs/stat.c:380
>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>> 
>> Freed by task 1:
>>   kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>>   kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
>>   kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
>>   ____kasan_slab_free mm/kasan/common.c:366 [inline]
>>   ____kasan_slab_free mm/kasan/common.c:328 [inline]
>>   __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:374
>>   kasan_slab_free include/linux/kasan.h:230 [inline]
>>   slab_free_hook mm/slub.c:1625 [inline]
>>   slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1650
>>   slab_free mm/slub.c:3210 [inline]
>>   kmem_cache_free+0x8a/0x5b0 mm/slub.c:3226
>>   putname+0xe1/0x120 fs/namei.c:259
> 
> (*)
> 
>>   filename_lookup+0x3df/0x5b0 fs/namei.c:2477
>>   user_path_at include/linux/namei.h:57 [inline]
>>   vfs_statx+0x142/0x390 fs/stat.c:203
>>   vfs_fstatat fs/stat.c:225 [inline]
>>   vfs_lstat include/linux/fs.h:3386 [inline]
>>   __do_sys_newlstat+0x91/0x110 fs/stat.c:380
>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>> 
> 
> +CC Dmitry
> 
> 
> 
> I think, it was caused by 9d96ea38873f ("namei: change
> filename_parentat() calling conventions").
> 
> Now what looks strange to me
> 
> Upstream version:
> 
> static struct filename *filename_parentat(...)
> {
> ...
> 	retval = path_parentat(&nd, flags | LOOKUP_RCU, parent);
> ...
> 	if (likely(!retval)) {
> 		*last = nd.last;
> 		*type = nd.last_type;
> 		audit_inode(name, parent->dentry, AUDIT_INODE_PARENT);
> 	} else {
> 		putname(name);  <-- putting name if retval if not-zero
> 		name = ERR_PTR(retval);
> 	}
> 
> }
> 
> 
> Linux-next version:
> 
> static int __filename_parentat(...)
> {
> 
> 	retval = path_parentat(&nd, flags | LOOKUP_RCU, parent);
> ...
> 	if (likely(!retval)) {
> 		*last = nd.last;
> 		*type = nd.last_type;
> 		audit_inode(name, parent->dentry, AUDIT_INODE_PARENT);
> 	}
> 	restore_nameidata();
> 	return retval;
> }
> 
> static int filename_parentat(...)
> {
> 	int retval = __filename_parentat(...);
> 
> 	putname(name);   <-- always putting the name
> 	return retval;
> }
> 
> And bug report says, that name was freed by this put (*)
> 
> I guess, we should do smth like:
> 
> if (retval)
> 	putname(name);
> 
> I didn't dig into details, because Dmitry's patch series was really
> huge, so it's just for thoughts ;)
> 
> 
> 

+CC Alexander,

since people start getting this error while testing patches on top of 
linux-next




With regards,
Pavel Skripkin
