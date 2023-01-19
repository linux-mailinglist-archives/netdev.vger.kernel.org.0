Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E24B673660
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjASLKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjASLJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:09:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D784AA6B
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674126548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b5dacYO3mZ+IUzxPOKLB2WoCiOEmnU76gMH3WmurRYc=;
        b=H+Bq2JxPpxADfCyhN9oI0Mzu80MzMvey9auMau6mM4l+uFHjgWQ62XG+dmcTspgecN0ZjU
        8fz9ann5V+H/dhhXxMN756XhfmMHBA4S++rgKr9r1S6Cprug+L68Do/vMJUNkHnT3IVpEs
        eDDlpknP6855N2IhWOz1cNSTikU2Cas=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-383-1kQJuNWpMxm6FRN7pxdtWA-1; Thu, 19 Jan 2023 06:09:04 -0500
X-MC-Unique: 1kQJuNWpMxm6FRN7pxdtWA-1
Received: by mail-ed1-f70.google.com with SMTP id l17-20020a056402255100b00472d2ff0e59so1381000edb.19
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:09:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:to:content-language:subject:cc:user-agent
         :mime-version:date:message-id:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b5dacYO3mZ+IUzxPOKLB2WoCiOEmnU76gMH3WmurRYc=;
        b=V7yPBI3pSOEQq1r3T7ta0+jqKN5s5yhz8QLr0T+eaEfcPq+zOG1AZEGLIrG1AB55lk
         ZjeFPHvuLTrOBIjp7QBusrKNZ8OfhCU5zrOy2yBetInK9gzNVrMPQhu/MWr5iaO7869O
         n7cFEZ352JHGgzHzjO/H0sFwsIBuKwoGGunxCMpXZ4JuLuNvuN0/TCXugaqYRbxuqRFQ
         JQEnivNGr+HhTVoG+BhUm+7spQDgz9T/1G1GMne64SNer2/0EIbRFMS2YrAweuudwuu1
         neyuhfZwNh3GvasGOJFW+b9pMD/K1eMCfjwjrFTmNo7tHB+k11QmniAPFE2ouLrWNzan
         R1zw==
X-Gm-Message-State: AFqh2kq3DZliQ2xPIaMY+FUO0HAEPdTuQKGY+HAlBJXlG7qnwvzDQtZO
        qp/MjuViyHtvLSOHJtEVhVgK7Uz3GoZZJBabyYhcDU+6BsOnjTzaR/L+/DiRl6hBHavK8wtjldf
        Si0TV1riXK4yMwapO
X-Received: by 2002:a17:906:855:b0:86e:f88:c098 with SMTP id f21-20020a170906085500b0086e0f88c098mr11242942ejd.70.1674126543402;
        Thu, 19 Jan 2023 03:09:03 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtbnHfYyGiwOrAeuPRTUID61Xrq5uRfFvaK2kWgnrDkLPDs8ZIDezNWcKJbX3L9nNggDd9XKQ==
X-Received: by 2002:a17:906:855:b0:86e:f88:c098 with SMTP id f21-20020a170906085500b0086e0f88c098mr11242921ejd.70.1674126543111;
        Thu, 19 Jan 2023 03:09:03 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id o14-20020a17090637ce00b00871390a3b74sm5132112ejc.177.2023.01.19.03.09.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 03:09:02 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: multipart/mixed; boundary="------------E0MBYAXpLI6FXJqC5vhpAEI7"
Message-ID: <b29bd572-cd43-7d68-e4bb-4858551981f3@redhat.com>
Date:   Thu, 19 Jan 2023 12:09:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com
Subject: Re: [syzbot] kernel BUG in ip_frag_next
Content-Language: en-US
To:     syzbot <syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com>,
        bpf@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, saeed@kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
References: <000000000000d58eae05f28ca51f@google.com>
In-Reply-To: <000000000000d58eae05f28ca51f@google.com>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------E0MBYAXpLI6FXJqC5vhpAEI7
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 18/01/2023 17.52, syzbot wrote:
> Hello,

Hi Syzbot,

Could you test this attached patch please, against:

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
master


> syzbot found the following issue on:
> 
> HEAD commit:    0c68c8e5ec68 net: mdio: cavium: Remove unneeded simicolons
> git tree:       net-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=147c7051480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4695869845c5f393
> dashboard link: https://syzkaller.appspot.com/bug?extid=c8a2e66e37eee553c4fd
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=173fca39480000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=107ba0a9480000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/15c191498614/disk-0c68c8e5.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/7c4c9368d89c/vmlinux-0c68c8e5.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/083770efc7c4/bzImage-0c68c8e5.xz
> 
> The issue was bisected to:
> 
> commit eedade12f4cb7284555c4c0314485e9575c70ab7
> Author: Jesper Dangaard Brouer <brouer@redhat.com>
> Date:   Fri Jan 13 13:52:04 2023 +0000
> 
>      net: kfree_skb_list use kmem_cache_free_bulk
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1136ec41480000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=1336ec41480000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1536ec41480000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
> Fixes: eedade12f4cb ("net: kfree_skb_list use kmem_cache_free_bulk")
> 
> raw_sendmsg: syz-executor409 forgot to set AF_INET. Fix it!
> ------------[ cut here ]------------
> kernel BUG at net/ipv4/ip_output.c:724!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 5073 Comm: syz-executor409 Not tainted 6.2.0-rc3-syzkaller-00457-g0c68c8e5ec68 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
> RIP: 0010:ip_frag_next+0xa03/0xa50 net/ipv4/ip_output.c:724
> Code: e8 82 b1 86 f9 e9 95 fa ff ff 48 8b 3c 24 e8 74 b1 86 f9 e9 5b f8 ff ff 4c 89 ff e8 67 b1 86 f9 e9 1f f8 ff ff e8 3d ad 38 f9 <0f> 0b 48 89 54 24 20 4c 89 44 24 18 e8 4c b1 86 f9 48 8b 54 24 20
> RSP: 0018:ffffc90003a6f6b8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffffc90003a6f818 RCX: 0000000000000000
> RDX: ffff8880772c0000 RSI: ffffffff8848a583 RDI: 0000000000000005
> RBP: 00000000000005c8 R08: 0000000000000005 R09: 0000000000000000
> R10: 00000000fffffff2 R11: 0000000000000000 R12: ffff888026841dc0
> R13: ffffc90003a6f81c R14: 00000000fffffff2 R15: ffffc90003a6f830
> FS:  0000555555b08300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005622b70166a8 CR3: 000000007780f000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   <TASK>
>   ip_do_fragment+0x873/0x17d0 net/ipv4/ip_output.c:902
>   ip_fragment.constprop.0+0x16b/0x240 net/ipv4/ip_output.c:581
>   __ip_finish_output net/ipv4/ip_output.c:304 [inline]
>   __ip_finish_output+0x2de/0x650 net/ipv4/ip_output.c:288
>   ip_finish_output+0x31/0x280 net/ipv4/ip_output.c:316
>   NF_HOOK_COND include/linux/netfilter.h:291 [inline]
>   ip_mc_output+0x21f/0x710 net/ipv4/ip_output.c:415
>   dst_output include/net/dst.h:444 [inline]
>   ip_local_out net/ipv4/ip_output.c:126 [inline]
>   ip_send_skb net/ipv4/ip_output.c:1586 [inline]
>   ip_push_pending_frames+0x129/0x2b0 net/ipv4/ip_output.c:1606
>   raw_sendmsg+0x1338/0x2df0 net/ipv4/raw.c:645
>   inet_sendmsg+0x9d/0xe0 net/ipv4/af_inet.c:827
>   sock_sendmsg_nosec net/socket.c:722 [inline]
>   sock_sendmsg+0xde/0x190 net/socket.c:745
>   __sys_sendto+0x23a/0x340 net/socket.c:2142
>   __do_sys_sendto net/socket.c:2154 [inline]
>   __se_sys_sendto net/socket.c:2150 [inline]
>   __x64_sys_sendto+0xe1/0x1b0 net/socket.c:2150
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f8efa22c499
> Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd43ed3198 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00007ffd43ed31b8 RCX: 00007f8efa22c499
> RDX: 000000000000fcf2 RSI: 0000000020000380 RDI: 0000000000000003
> RBP: 0000000000000003 R08: 0000000020001380 R09: 000000000000006e
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd43ed31c0
> R13: 00007ffd43ed31e0 R14: 0000000000000000 R15: 0000000000000000
>   </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:ip_frag_next+0xa03/0xa50 net/ipv4/ip_output.c:724
> Code: e8 82 b1 86 f9 e9 95 fa ff ff 48 8b 3c 24 e8 74 b1 86 f9 e9 5b f8 ff ff 4c 89 ff e8 67 b1 86 f9 e9 1f f8 ff ff e8 3d ad 38 f9 <0f> 0b 48 89 54 24 20 4c 89 44 24 18 e8 4c b1 86 f9 48 8b 54 24 20
> RSP: 0018:ffffc90003a6f6b8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffffc90003a6f818 RCX: 0000000000000000
> RDX: ffff8880772c0000 RSI: ffffffff8848a583 RDI: 0000000000000005
> RBP: 00000000000005c8 R08: 0000000000000005 R09: 0000000000000000
> R10: 00000000fffffff2 R11: 0000000000000000 R12: ffff888026841dc0
> R13: ffffc90003a6f81c R14: 00000000fffffff2 R15: ffffc90003a6f830
> FS:  0000555555b08300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000557162e92068 CR3: 000000007780f000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 
--------------E0MBYAXpLI6FXJqC5vhpAEI7
Content-Type: text/plain; charset=UTF-8; name="18-syzbot-proper-fix-test3"
Content-Disposition: attachment; filename="18-syzbot-proper-fix-test3"
Content-Transfer-Encoding: base64

bmV0OiBmaXgga2ZyZWVfc2tiX2xpc3QgdXNlIG9mIHNrYl9tYXJrX25vdF9vbl9saXN0CgpG
cm9tOiBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVyIDxicm91ZXJAcmVkaGF0LmNvbT4KCkEgYnVn
IHdhcyBpbnRyb2R1Y2VkIGJ5IGNvbW1pdCBlZWRhZGUxMmY0Y2IgKCJuZXQ6IGtmcmVlX3Nr
Yl9saXN0IHVzZQprbWVtX2NhY2hlX2ZyZWVfYnVsayIpLiBJdCB1bmNvbmRpdGlvbmFsbHkg
dW5saW5rZWQgdGhlIFNLQiBsaXN0IHZpYQppbnZva2luZyBza2JfbWFya19ub3Rfb25fbGlz
dCgpLgoKVGhlIHNrYl9tYXJrX25vdF9vbl9saXN0KCkgc2hvdWxkIG9ubHkgYmUgY2FsbGVk
IGlmIF9fa2ZyZWVfc2tiX3JlYXNvbigpCnJldHVybnMgdHJ1ZSwgbWVhbmluZyB0aGUgU0tC
IGlzIHJlYWR5IHRvIGJlIGZyZWUnZWQgKGFzIGl0IGNhbGxzL2NoZWNrCnNrYl91bnJlZigp
KS4KClJlcG9ydGVkLWJ5OiBzeXpib3QrYzhhMmU2NmUzN2VlZTU1M2M0ZmRAc3l6a2FsbGVy
LmFwcHNwb3RtYWlsLmNvbQpGaXhlczogZWVkYWRlMTJmNGNiICgibmV0OiBrZnJlZV9za2Jf
bGlzdCB1c2Uga21lbV9jYWNoZV9mcmVlX2J1bGsiKQpTaWduZWQtb2ZmLWJ5OiBKZXNwZXIg
RGFuZ2FhcmQgQnJvdWVyIDxicm91ZXJAcmVkaGF0LmNvbT4KLS0tCiBuZXQvY29yZS9za2J1
ZmYuYyB8ICAgIDYgKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAz
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL25ldC9jb3JlL3NrYnVmZi5jIGIvbmV0L2Nv
cmUvc2tidWZmLmMKaW5kZXggNGU3M2FiMzQ4MmI4Li4xYmZmYmNiZTYwODcgMTAwNjQ0Ci0t
LSBhL25ldC9jb3JlL3NrYnVmZi5jCisrKyBiL25ldC9jb3JlL3NrYnVmZi5jCkBAIC05OTks
MTAgKzk5OSwxMCBAQCBrZnJlZV9za2JfbGlzdF9yZWFzb24oc3RydWN0IHNrX2J1ZmYgKnNl
Z3MsIGVudW0gc2tiX2Ryb3BfcmVhc29uIHJlYXNvbikKIAl3aGlsZSAoc2VncykgewogCQlz
dHJ1Y3Qgc2tfYnVmZiAqbmV4dCA9IHNlZ3MtPm5leHQ7CiAKLQkJc2tiX21hcmtfbm90X29u
X2xpc3Qoc2Vncyk7Ci0KLQkJaWYgKF9fa2ZyZWVfc2tiX3JlYXNvbihzZWdzLCByZWFzb24p
KQorCQlpZiAoX19rZnJlZV9za2JfcmVhc29uKHNlZ3MsIHJlYXNvbikpIHsKKwkJCXNrYl9t
YXJrX25vdF9vbl9saXN0KHNlZ3MpOwogCQkJa2ZyZWVfc2tiX2FkZF9idWxrKHNlZ3MsICZz
YSwgcmVhc29uKTsKKwkJfQogCiAJCXNlZ3MgPSBuZXh0OwogCX0K

--------------E0MBYAXpLI6FXJqC5vhpAEI7--

