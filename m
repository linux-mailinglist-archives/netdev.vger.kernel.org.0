Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E06E3DF293
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbhHCQcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbhHCQcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:32:07 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FF1C061757;
        Tue,  3 Aug 2021 09:31:55 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id g13so40672475lfj.12;
        Tue, 03 Aug 2021 09:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=kj/2FjFDDZ5YXBr22LV5Rs8kW87iERFRfqAT+F3hUHA=;
        b=cPqT/YXsTQINY+ghYzjivbtquFWBbuefQPVNciBcAyHvt3xjfO5WaSBIcsOuTP0Q6I
         JmXTrfKMfM+ItQMHWKYfS1XP6wImedAazr7EJkQzs6xe2IhvDK4PDHgH9/uMJ26dPy1S
         t7MIueozAjNfVFfIqGK7X2H6rC8CE0G4hkQFCSp82CTR6I1dF/YgfYgTzI6hsgJWdKSh
         neSfE/ilEuP9Wy5KgvWeZ5+Pr9FNDqlDESZlsX7a/G/VIqKeKcl/56q+IL3L7FwyPK3m
         Ic+dOU/3iAYsBK4wwmRrbgRCThSdFRCJx9NbXUhTr1OxRw7oGWVqtKp/xMECYamgt0FG
         9Q4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kj/2FjFDDZ5YXBr22LV5Rs8kW87iERFRfqAT+F3hUHA=;
        b=eVOCQHBtF6MVUwsFJA60MOrKjo03TtIEVgcl+qe7mwrJZgt8tqp2n92HI6GTfhBVe4
         rOUWSlsqptkG9toSMO0tBd5MfRYr37UOFXqGXOSMsJ6y4C5SNUsYfRA5+lmDslE6350S
         O3CEa7gIAc0/CF5xyciTsCH1X+u3Bbe6+F+/YcjRQw095QdAsjFf2J5Q7lU+afykxiDz
         hlmbWq1Ri4zzLuIDusDhpoTr9MzksC6tTJs5AEMdLb1ETa3RD0puhIwo6u48Kvew8yaV
         tHIEb2PumLziv7cFyW8PuQaNaxRo4oOYoALfYMCU44EpGNA6Alc1qJuA/i886JPh6YCO
         2C2w==
X-Gm-Message-State: AOAM5337eyE8AKg4ZHQ5QUaKq0s8SRM45QrOmhFrYpYVchwMtZfPj0VM
        duoTFP5OIYzvsLZT9BrJTp4=
X-Google-Smtp-Source: ABdhPJz5KERCHLDdn9/uUYk3lyfUjNM3oIUZlz6AduG/1Um2+YsHUWHI84g2poHrhB/gsycCoRbqBA==
X-Received: by 2002:a05:6512:13a9:: with SMTP id p41mr16772878lfa.403.1628008312065;
        Tue, 03 Aug 2021 09:31:52 -0700 (PDT)
Received: from localhost.localdomain ([94.103.226.235])
        by smtp.gmail.com with ESMTPSA id p21sm1291901lfa.264.2021.08.03.09.31.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 09:31:51 -0700 (PDT)
Subject: Re: [syzbot] net-next boot error: WARNING: refcount bug in
 fib_create_info
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     syzbot <syzbot+c5ac86461673ef58847c@syzkaller.appspotmail.com>,
        davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
References: <0000000000005e090405c8a9e1c3@google.com>
 <02372175-c3a1-3f8e-28fe-66d812f4c612@gmail.com>
Message-ID: <e6eab0c9-7b2e-179b-b9c0-459dd9a75ed1@gmail.com>
Date:   Tue, 3 Aug 2021 19:31:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <02372175-c3a1-3f8e-28fe-66d812f4c612@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/21 7:12 PM, Pavel Skripkin wrote:
> On 8/3/21 7:07 PM, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    1187c8c4642d net: phy: mscc: make some arrays static const..
>> git tree:       net-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=140e7b3e300000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=f9bb42efdc6f1d7
>> dashboard link: https://syzkaller.appspot.com/bug?extid=c5ac86461673ef58847c
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
>> 
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+c5ac86461673ef58847c@syzkaller.appspotmail.com
>> 
>> FS-Cache: Netfs 'afs' registered for caching
>> Btrfs loaded, crc32c=crc32c-intel, assert=on, zoned=yes
>> Key type big_key registered
>> Key type encrypted registered
>> AppArmor: AppArmor sha1 policy hashing enabled
>> ima: No TPM chip found, activating TPM-bypass!
>> Loading compiled-in module X.509 certificates
>> Loaded X.509 cert 'Build time autogenerated kernel key: f850c787ad998c396ae089c083b940ff0a9abb77'
>> ima: Allocated hash algorithm: sha256
>> ima: No architecture policies found
>> evm: Initialising EVM extended attributes:
>> evm: security.selinux (disabled)
>> evm: security.SMACK64 (disabled)
>> evm: security.SMACK64EXEC (disabled)
>> evm: security.SMACK64TRANSMUTE (disabled)
>> evm: security.SMACK64MMAP (disabled)
>> evm: security.apparmor
>> evm: security.ima
>> evm: security.capability
>> evm: HMAC attrs: 0x1
>> PM:   Magic number: 1:990:690
>> printk: console [netcon0] enabled
>> netconsole: network logging started
>> gtp: GTP module loaded (pdp ctx size 104 bytes)
>> rdma_rxe: loaded
>> cfg80211: Loading compiled-in X.509 certificates for regulatory database
>> cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
>> ALSA device list:
>>    #0: Dummy 1
>>    #1: Loopback 1
>>    #2: Virtual MIDI Card 1
>> md: Waiting for all devices to be available before autodetect
>> md: If you don't use raid, use raid=noautodetect
>> md: Autodetecting RAID arrays.
>> md: autorun ...
>> md: ... autorun DONE.
>> EXT4-fs (sda1): mounted filesystem without journal. Opts: (null). Quota mode: none.
>> VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
>> devtmpfs: mounted
>> Freeing unused kernel image (initmem) memory: 4476K
>> Write protecting the kernel read-only data: 169984k
>> Freeing unused kernel image (text/rodata gap) memory: 2012K
>> Freeing unused kernel image (rodata/data gap) memory: 1516K
>> Run /sbin/init as init process
>> systemd[1]: systemd 232 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
>> systemd[1]: Detected virtualization kvm.
>> systemd[1]: Detected architecture x86-64.
>> systemd[1]: Set hostname to <syzkaller>.
>> ------------[ cut here ]------------
>> refcount_t: addition on 0; use-after-free.
>> WARNING: CPU: 1 PID: 1 at lib/refcount.c:25 refcount_warn_saturate+0x169/0x1e0 lib/refcount.c:25
>> Modules linked in:
>> CPU: 1 PID: 1 Comm: systemd Not tainted 5.14.0-rc3-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> RIP: 0010:refcount_warn_saturate+0x169/0x1e0 lib/refcount.c:25
>> Code: 09 31 ff 89 de e8 d7 fa 9e fd 84 db 0f 85 36 ff ff ff e8 8a f4 9e fd 48 c7 c7 c0 81 e3 89 c6 05 70 51 81 09 01 e8 48 f8 13 05 <0f> 0b e9 17 ff ff ff e8 6b f4 9e fd 0f b6 1d 55 51 81 09 31 ff 89
>> RSP: 0018:ffffc90000c66ab0 EFLAGS: 00010286
>> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
>> RDX: ffff88813fe48000 RSI: ffffffff815d7b25 RDI: fffff5200018cd48
>> RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000001
>> R10: ffffffff815d195e R11: 0000000000000000 R12: 0000000000000004
>> R13: 0000000000000001 R14: 0000000000000000 R15: ffff888027722e00
>> FS:  00007f8c1c5d0500(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 000055ed0ced4368 CR3: 0000000026bac000 CR4: 00000000001506e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>   __refcount_add include/linux/refcount.h:199 [inline]
>>   __refcount_inc include/linux/refcount.h:250 [inline]
>>   refcount_inc include/linux/refcount.h:267 [inline]
>>   fib_create_info+0x36af/0x4910 net/ipv4/fib_semantics.c:1554
> 
> Missed refcount_set(), I think
> 
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index f29feb7772da..bb9949f6bb70 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -1428,6 +1428,7 @@ struct fib_info *fib_create_info(struct fib_config
> *cfg,
>    	}
> 
>    	fib_info_cnt++;
> +	refcount_set(&fi->fib_treeref, 1);
>    	fi->fib_net = net;
>    	fi->fib_protocol = cfg->fc_protocol;
>    	fi->fib_scope = cfg->fc_scope;
> 
> 
> 
> 
> 

Oops, it's already fixed in -next, so

#syz fix: ipv4: Fix refcount warning for new fib_info


BTW: there is one more bug with refcounts:

link_it:
	ofi = fib_find_info(fi);
	if (ofi) {
		fi->fib_dead = 1;
		free_fib_info(fi);
		refcount_inc(&ofi->fib_treeref);

		^^^^^^^^^^^^^^^^^^^^^^^
		/ *fib_treeref is 0 here */

		return ofi;
	}

	refcount_set(&fi->fib_treeref, 1);



diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index f29feb7772da..38d1fc4d0be1 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1543,6 +1543,8 @@ struct fib_info *fib_create_info(struct fib_config 
*cfg,
  	}

  link_it:
+	refcount_set(&fi->fib_treeref, 1);
+
  	ofi = fib_find_info(fi);
  	if (ofi) {
  		fi->fib_dead = 1;
@@ -1551,7 +1553,6 @@ struct fib_info *fib_create_info(struct fib_config 
*cfg,
  		return ofi;
  	}

-	refcount_set(&fi->fib_treeref, 1);
  	refcount_set(&fi->fib_clntref, 1);
  	spin_lock_bh(&fib_info_lock);
  	hlist_add_head(&fi->fib_hash,



Thoughts?


With regards,
Pavel Skripkin
