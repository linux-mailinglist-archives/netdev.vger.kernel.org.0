Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C88F3DF23D
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhHCQNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbhHCQNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:13:08 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4E2C06175F;
        Tue,  3 Aug 2021 09:12:57 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id c16so11122947lfc.2;
        Tue, 03 Aug 2021 09:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=CNlcolE7HBJHXb5xOsiQx5J9kf1vL0og1HF0SHv/fzY=;
        b=ds1QKmaGVKF45E+rYe4cvQC7e7rkHQ1IFnVJkd/6VVnKXLv92+qk4RTaC4wl878gFU
         vJCoNKgPAnDDtfe//w5laiMsCCDS4uJs5d/IJRZvlpB+q/anngV+EbU5opXI7ahc+K55
         m7qczp6ynBh4HIAv/yS2MxpyCnLKeFYOmip+Cz/M4GoePCJsvX30N1fts7ZfLATxHcCy
         l9CzXojskFMYn1WSBU8bP0DuYjYX2cKrkkalYZV41pF1/bIubD+5ZmDTOOBenPiTDYDm
         ff+ASKw3iWDUaxVllNUwkyLk/UU5cvpKt1h6tshpwz3CzOV+1Xki+bef19RIv0nyLq3E
         FoOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CNlcolE7HBJHXb5xOsiQx5J9kf1vL0og1HF0SHv/fzY=;
        b=o5e8GY7ImnLcW4iw88GoVGof3BEeFETvWDPCpWuOg/DS0SkQFOzBnRB0Oglb2/9G3N
         FT9Vavjs4YogPzj7zamK9/mCVmO127NsxoW5ctkMBu2THrKKq+uY6YVdioCc1UOxC5Ys
         iPO/9ZW5Cqu5WYcXPN20G9dq+BAkOzwhD9MhjowXzyKb9zo9VmSrP+SYtycmUKKgEnb3
         +zqNj244lyGQmlQ9O0b+H6/pQVhM1MhWogkOsUVwOpxgcVeBWruMCg6/WbRVXHvc7bGT
         7hAxu6Syh7NqaZyxFBvSpc8sCpPpnvQ8t/CWunNvC0Z60Xc4VCGGXFFhb6c6ynZmVNYU
         w8yQ==
X-Gm-Message-State: AOAM5330h44Cvkjx03HIeoFAd1joXxTHGwQ0fwY9u4JnZkrY3UqnrJRF
        Rs+dMuO9JQE8MpNRq01OhC0=
X-Google-Smtp-Source: ABdhPJyKsPFan7SOmvp2khzUsr+D3XvRKSp291ACtGAe0yH9lGvS8o/3UXSV5cK4gACUtVLKN6IzSg==
X-Received: by 2002:a05:6512:2242:: with SMTP id i2mr17506365lfu.441.1628007175703;
        Tue, 03 Aug 2021 09:12:55 -0700 (PDT)
Received: from localhost.localdomain ([94.103.226.235])
        by smtp.gmail.com with ESMTPSA id t30sm1280524lfg.289.2021.08.03.09.12.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 09:12:55 -0700 (PDT)
Subject: Re: [syzbot] net-next boot error: WARNING: refcount bug in
 fib_create_info
To:     syzbot <syzbot+c5ac86461673ef58847c@syzkaller.appspotmail.com>,
        davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
References: <0000000000005e090405c8a9e1c3@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <02372175-c3a1-3f8e-28fe-66d812f4c612@gmail.com>
Date:   Tue, 3 Aug 2021 19:12:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <0000000000005e090405c8a9e1c3@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/21 7:07 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    1187c8c4642d net: phy: mscc: make some arrays static const..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=140e7b3e300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f9bb42efdc6f1d7
> dashboard link: https://syzkaller.appspot.com/bug?extid=c5ac86461673ef58847c
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c5ac86461673ef58847c@syzkaller.appspotmail.com
> 
> FS-Cache: Netfs 'afs' registered for caching
> Btrfs loaded, crc32c=crc32c-intel, assert=on, zoned=yes
> Key type big_key registered
> Key type encrypted registered
> AppArmor: AppArmor sha1 policy hashing enabled
> ima: No TPM chip found, activating TPM-bypass!
> Loading compiled-in module X.509 certificates
> Loaded X.509 cert 'Build time autogenerated kernel key: f850c787ad998c396ae089c083b940ff0a9abb77'
> ima: Allocated hash algorithm: sha256
> ima: No architecture policies found
> evm: Initialising EVM extended attributes:
> evm: security.selinux (disabled)
> evm: security.SMACK64 (disabled)
> evm: security.SMACK64EXEC (disabled)
> evm: security.SMACK64TRANSMUTE (disabled)
> evm: security.SMACK64MMAP (disabled)
> evm: security.apparmor
> evm: security.ima
> evm: security.capability
> evm: HMAC attrs: 0x1
> PM:   Magic number: 1:990:690
> printk: console [netcon0] enabled
> netconsole: network logging started
> gtp: GTP module loaded (pdp ctx size 104 bytes)
> rdma_rxe: loaded
> cfg80211: Loading compiled-in X.509 certificates for regulatory database
> cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
> ALSA device list:
>    #0: Dummy 1
>    #1: Loopback 1
>    #2: Virtual MIDI Card 1
> md: Waiting for all devices to be available before autodetect
> md: If you don't use raid, use raid=noautodetect
> md: Autodetecting RAID arrays.
> md: autorun ...
> md: ... autorun DONE.
> EXT4-fs (sda1): mounted filesystem without journal. Opts: (null). Quota mode: none.
> VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
> devtmpfs: mounted
> Freeing unused kernel image (initmem) memory: 4476K
> Write protecting the kernel read-only data: 169984k
> Freeing unused kernel image (text/rodata gap) memory: 2012K
> Freeing unused kernel image (rodata/data gap) memory: 1516K
> Run /sbin/init as init process
> systemd[1]: systemd 232 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
> systemd[1]: Detected virtualization kvm.
> systemd[1]: Detected architecture x86-64.
> systemd[1]: Set hostname to <syzkaller>.
> ------------[ cut here ]------------
> refcount_t: addition on 0; use-after-free.
> WARNING: CPU: 1 PID: 1 at lib/refcount.c:25 refcount_warn_saturate+0x169/0x1e0 lib/refcount.c:25
> Modules linked in:
> CPU: 1 PID: 1 Comm: systemd Not tainted 5.14.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:refcount_warn_saturate+0x169/0x1e0 lib/refcount.c:25
> Code: 09 31 ff 89 de e8 d7 fa 9e fd 84 db 0f 85 36 ff ff ff e8 8a f4 9e fd 48 c7 c7 c0 81 e3 89 c6 05 70 51 81 09 01 e8 48 f8 13 05 <0f> 0b e9 17 ff ff ff e8 6b f4 9e fd 0f b6 1d 55 51 81 09 31 ff 89
> RSP: 0018:ffffc90000c66ab0 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88813fe48000 RSI: ffffffff815d7b25 RDI: fffff5200018cd48
> RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffffff815d195e R11: 0000000000000000 R12: 0000000000000004
> R13: 0000000000000001 R14: 0000000000000000 R15: ffff888027722e00
> FS:  00007f8c1c5d0500(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055ed0ced4368 CR3: 0000000026bac000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   __refcount_add include/linux/refcount.h:199 [inline]
>   __refcount_inc include/linux/refcount.h:250 [inline]
>   refcount_inc include/linux/refcount.h:267 [inline]
>   fib_create_info+0x36af/0x4910 net/ipv4/fib_semantics.c:1554

Missed refcount_set(), I think

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index f29feb7772da..bb9949f6bb70 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1428,6 +1428,7 @@ struct fib_info *fib_create_info(struct fib_config 
*cfg,
  	}

  	fib_info_cnt++;
+	refcount_set(&fi->fib_treeref, 1);
  	fi->fib_net = net;
  	fi->fib_protocol = cfg->fc_protocol;
  	fi->fib_scope = cfg->fc_scope;





With regards,
Pavel Skripkin
