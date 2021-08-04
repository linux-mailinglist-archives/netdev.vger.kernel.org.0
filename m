Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774C33DFAE0
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 07:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbhHDFGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 01:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhHDFGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 01:06:00 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF21BC0613D5;
        Tue,  3 Aug 2021 22:05:44 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id c16so2389686lfc.2;
        Tue, 03 Aug 2021 22:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hI5NzRhUttF3NkJIlIa+2m79J5Vt3BFIqnT8E+2YJP8=;
        b=u/VCxW3vjNPhkEWCXTf/wTjN2vbWQc3CLJNiad4GADDgvalUCNQfa8BTEK9QsZvXcN
         XreNRtxZ43I55Uw3RkfgQn3xdwJQ2mWIqQFfQ0dk5lY3QNy8zwDOqivjJwVyhTbwlC1O
         hUuBN1fbXL4YSfCX+vRk8gcF41Ze0g5XgB7iOvxz03QAHPEU8UiHpYC9iZb58eMZbpQd
         57VS/dVij0L5R28Jn11pXcqKnBgSn7LuBz84NOWhodUERqSou2azTqwEGc91e4GIZkLZ
         ddWV0kEt6dCigqSagcWiFE3wh7x6JLXSaT6z7jJ6hxiDGN3G/1fEBgwylrOOpARcAOS7
         rVvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hI5NzRhUttF3NkJIlIa+2m79J5Vt3BFIqnT8E+2YJP8=;
        b=lvg58BWZ6Vdyv+1QI7OsTLybvEKPVMqVcvr+cQDit2h3AVXimFv33cjlrhRT7CNMvc
         8aLmZF/XzHLQ4VueJDB9LxC4XBW6eoo7oAJe+oWrfbFo2kvdsWN5HOfh+nwXbh2l0tUu
         9UCbeY0Fc1QSdqxuWqSRtwxp1K9apUSVF8GIKaLB+zcHeRiHcUJVFrHHIBb43B13Yhlz
         CpHdKxVxLHzI9gKLDuj+khzClkMCaBgqRHTlfT/rPyzPI2/Dr1KRwKk925QfQHnBX2v4
         tCN6aI7l40CtX1mGF/nl+h4pVxCsy9u5z7uenBWUzWI/LdHjkUT28oVuV06a5uHX043P
         t3Zw==
X-Gm-Message-State: AOAM530YznCiFHQiRnlFY7Yp4MTHqyc7cUW+D0qb0Wve9PxbeX7CaQNA
        7GWsD9PGH27QzueR7L3/z0I=
X-Google-Smtp-Source: ABdhPJyxzX4rn1jutx6PgAnxB+Sz21O4V45VqnseQdwR26l5GtR25DaMZlXCo62I3hjEwef0pLfaCA==
X-Received: by 2002:a05:6512:3da2:: with SMTP id k34mr17306867lfv.3.1628053543074;
        Tue, 03 Aug 2021 22:05:43 -0700 (PDT)
Received: from localhost.localdomain ([46.61.204.60])
        by smtp.gmail.com with ESMTPSA id n8sm83558lfk.198.2021.08.03.22.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 22:05:42 -0700 (PDT)
Date:   Wed, 4 Aug 2021 08:05:36 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     syzbot <syzbot+c5ac86461673ef58847c@syzkaller.appspotmail.com>,
        davem@davemloft.net, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Subject: Re: [syzbot] net-next boot error: WARNING: refcount bug in
 fib_create_info
Message-ID: <20210804080536.3b655024@gmail.com>
In-Reply-To: <20210803140435.19e560fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <0000000000005e090405c8a9e1c3@google.com>
        <02372175-c3a1-3f8e-28fe-66d812f4c612@gmail.com>
        <e6eab0c9-7b2e-179b-b9c0-459dd9a75ed1@gmail.com>
        <20210803140435.19e560fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.17.8git77 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Aug 2021 14:04:35 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Tue, 3 Aug 2021 19:31:50 +0300 Pavel Skripkin wrote:
> > On 8/3/21 7:12 PM, Pavel Skripkin wrote:
> > > On 8/3/21 7:07 PM, syzbot wrote:  
> > >> Hello,
> > >> 
> > >> syzbot found the following issue on:
> > >> 
> > >> HEAD commit:    1187c8c4642d net: phy: mscc: make some arrays
> > >> static const.. git tree:       net-next
> > >> console output:
> > >> https://syzkaller.appspot.com/x/log.txt?x=140e7b3e300000 kernel
> > >> config:
> > >> https://syzkaller.appspot.com/x/.config?x=f9bb42efdc6f1d7
> > >> dashboard link:
> > >> https://syzkaller.appspot.com/bug?extid=c5ac86461673ef58847c
> > >> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld
> > >> (GNU Binutils for Debian) 2.35.1
> > >> 
> > >> IMPORTANT: if you fix the issue, please add the following tag to
> > >> the commit: Reported-by:
> > >> syzbot+c5ac86461673ef58847c@syzkaller.appspotmail.com
> > >> 
> > >> FS-Cache: Netfs 'afs' registered for caching
> > >> Btrfs loaded, crc32c=crc32c-intel, assert=on, zoned=yes
> > >> Key type big_key registered
> > >> Key type encrypted registered
> > >> AppArmor: AppArmor sha1 policy hashing enabled
> > >> ima: No TPM chip found, activating TPM-bypass!
> > >> Loading compiled-in module X.509 certificates
> > >> Loaded X.509 cert 'Build time autogenerated kernel key:
> > >> f850c787ad998c396ae089c083b940ff0a9abb77' ima: Allocated hash
> > >> algorithm: sha256 ima: No architecture policies found
> > >> evm: Initialising EVM extended attributes:
> > >> evm: security.selinux (disabled)
> > >> evm: security.SMACK64 (disabled)
> > >> evm: security.SMACK64EXEC (disabled)
> > >> evm: security.SMACK64TRANSMUTE (disabled)
> > >> evm: security.SMACK64MMAP (disabled)
> > >> evm: security.apparmor
> > >> evm: security.ima
> > >> evm: security.capability
> > >> evm: HMAC attrs: 0x1
> > >> PM:   Magic number: 1:990:690
> > >> printk: console [netcon0] enabled
> > >> netconsole: network logging started
> > >> gtp: GTP module loaded (pdp ctx size 104 bytes)
> > >> rdma_rxe: loaded
> > >> cfg80211: Loading compiled-in X.509 certificates for regulatory
> > >> database cfg80211: Loaded X.509 cert 'sforshee:
> > >> 00b28ddf47aef9cea7' ALSA device list:
> > >>    #0: Dummy 1
> > >>    #1: Loopback 1
> > >>    #2: Virtual MIDI Card 1
> > >> md: Waiting for all devices to be available before autodetect
> > >> md: If you don't use raid, use raid=noautodetect
> > >> md: Autodetecting RAID arrays.
> > >> md: autorun ...
> > >> md: ... autorun DONE.
> > >> EXT4-fs (sda1): mounted filesystem without journal. Opts:
> > >> (null). Quota mode: none. VFS: Mounted root (ext4 filesystem)
> > >> readonly on device 8:1. devtmpfs: mounted
> > >> Freeing unused kernel image (initmem) memory: 4476K
> > >> Write protecting the kernel read-only data: 169984k
> > >> Freeing unused kernel image (text/rodata gap) memory: 2012K
> > >> Freeing unused kernel image (rodata/data gap) memory: 1516K
> > >> Run /sbin/init as init process
> > >> systemd[1]: systemd 232 running in system mode. (+PAM +AUDIT
> > >> +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP
> > >> +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD
> > >> +IDN) systemd[1]: Detected virtualization kvm. systemd[1]:
> > >> Detected architecture x86-64. systemd[1]: Set hostname to
> > >> <syzkaller>. ------------[ cut here ]------------ refcount_t:
> > >> addition on 0; use-after-free. WARNING: CPU: 1 PID: 1 at
> > >> lib/refcount.c:25 refcount_warn_saturate+0x169/0x1e0
> > >> lib/refcount.c:25 Modules linked in: CPU: 1 PID: 1 Comm: systemd
> > >> Not tainted 5.14.0-rc3-syzkaller #0 Hardware name: Google Google
> > >> Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > >> RIP: 0010:refcount_warn_saturate+0x169/0x1e0 lib/refcount.c:25
> > >> Code: 09 31 ff 89 de e8 d7 fa 9e fd 84 db 0f 85 36 ff ff ff e8
> > >> 8a f4 9e fd 48 c7 c7 c0 81 e3 89 c6 05 70 51 81 09 01 e8 48 f8
> > >> 13 05 <0f> 0b e9 17 ff ff ff e8 6b f4 9e fd 0f b6 1d 55 51 81 09
> > >> 31 ff 89 RSP: 0018:ffffc90000c66ab0 EFLAGS: 00010286 RAX:
> > >> 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > >> RDX: ffff88813fe48000 RSI: ffffffff815d7b25 RDI:
> > >> fffff5200018cd48 RBP: 0000000000000002 R08: 0000000000000000
> > >> R09: 0000000000000001 R10: ffffffff815d195e R11:
> > >> 0000000000000000 R12: 0000000000000004 R13: 0000000000000001
> > >> R14: 0000000000000000 R15: ffff888027722e00 FS:
> > >> 00007f8c1c5d0500(0000) GS:ffff8880b9d00000(0000)
> > >> knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0:
> > >> 0000000080050033 CR2: 000055ed0ced4368 CR3: 0000000026bac000
> > >> CR4: 00000000001506e0 DR0: 0000000000000000 DR1:
> > >> 0000000000000000 DR2: 0000000000000000 DR3: 0000000000000000
> > >> DR6: 00000000fffe0ff0 DR7: 0000000000000400 Call Trace:
> > >> __refcount_add include/linux/refcount.h:199 [inline]
> > >> __refcount_inc include/linux/refcount.h:250 [inline]
> > >> refcount_inc include/linux/refcount.h:267 [inline]
> > >> fib_create_info+0x36af/0x4910 net/ipv4/fib_semantics.c:1554  
> > > 
> > > Missed refcount_set(), I think
> > > 
> > > diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> > > index f29feb7772da..bb9949f6bb70 100644
> > > --- a/net/ipv4/fib_semantics.c
> > > +++ b/net/ipv4/fib_semantics.c
> > > @@ -1428,6 +1428,7 @@ struct fib_info *fib_create_info(struct
> > > fib_config *cfg,
> > >    	}
> > > 
> > >    	fib_info_cnt++;
> > > +	refcount_set(&fi->fib_treeref, 1);
> > >    	fi->fib_net = net;
> > >    	fi->fib_protocol = cfg->fc_protocol;
> > >    	fi->fib_scope = cfg->fc_scope;
> > 
> > Oops, it's already fixed in -next, so
> > 
> > #syz fix: ipv4: Fix refcount warning for new fib_info
> > 
> > 
> > BTW: there is one more bug with refcounts:
> > 
> > link_it:
> > 	ofi = fib_find_info(fi);
> > 	if (ofi) {
> > 		fi->fib_dead = 1;
> > 		free_fib_info(fi);
> > 		refcount_inc(&ofi->fib_treeref);
> > 
> > 		^^^^^^^^^^^^^^^^^^^^^^^
> > 		/ *fib_treeref is 0 here */
> 
> Why 0? ofi is an existing object it's already initialized.
> 

Yep, I see now, sorry for misinformation :(



With regards,
Pavel Skripkin
