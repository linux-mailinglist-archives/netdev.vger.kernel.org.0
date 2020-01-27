Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26EA814A885
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 18:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgA0RDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 12:03:34 -0500
Received: from UPDC19PA19.eemsg.mail.mil ([214.24.27.194]:43247 "EHLO
        UPDC19PA19.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgA0RDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 12:03:33 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jan 2020 12:03:32 EST
X-EEMSG-check-017: 50208362|UPDC19PA19_ESA_OUT01.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.70,370,1574121600"; 
   d="scan'208";a="50208362"
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by UPDC19PA19.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 27 Jan 2020 16:56:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1580144180; x=1611680180;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=JONYkeMLPoAJAaqitTzat6W8NCvIdG/UcgyJ1OEpbMA=;
  b=PDKKPlUU+aCKE6lkO/gMbceBz2oUNyaEfvBG60/QLywEo2hR5US3NxX9
   uhNTd6MtXyjti0MBLAbVgSyS9hfcomLifYbFoZ2cQAy2/gajl9Q5L8bn6
   0WCRhpvsV74DmV42yxwcrTwGi4uHfTpWGOJbefciwBRm71eQJhus7X9nT
   YM9fCpks7C3MjhjK5NP9lJXa3OK/iHKqgsSzCEJTT8TBQLvi5qAQ1ew5K
   VV9nDQoyUW8b7eXeRmGDrgYQEIbD9uU/PsmovSxE2VRJ7gfai5pzbJqOU
   CHIe3WWaLaIPE1/XwTpZ7saIWjgvwHb7zvzo4P2Z/nyIlHqnapfXbFSaO
   A==;
X-IronPort-AV: E=Sophos;i="5.70,370,1574121600"; 
   d="scan'208";a="38291032"
IronPort-PHdr: =?us-ascii?q?9a23=3ADBDIDxIV1djs5jRKntmcpTZWNBhigK39O0sv0r?=
 =?us-ascii?q?FitYgXIv3/rarrMEGX3/hxlliBBdydt6sYzbGM+PG4ESxYuNDd6StEKMQNHz?=
 =?us-ascii?q?Y+yuwu1zQ6B8CEDUCpZNXLVAcdWPp4aVl+4nugOlJUEsutL3fbo3m18CJAUk?=
 =?us-ascii?q?6nbVk9Kev6AJPdgNqq3O6u5ZLTfx9IhD2gar9uMRm6twrcutQZjId4JKs91B?=
 =?us-ascii?q?TFr39Ud+9LwW9kOU+fkwzz68ut8pNv6Thct+4k+8VdTaj0YqM0QKBCAj87KW?=
 =?us-ascii?q?41/srrtRfCTQuL+HQRV3gdnwRLDQbY8hz0R4/9vSTmuOVz3imaJtD2QqsvWT?=
 =?us-ascii?q?u+9adrSQTnhzkBOjUk7WzYkM1wjKZcoBK8uxxyxpPfbY+JOPZieK7WYMgXTn?=
 =?us-ascii?q?RdUMlPSyNBA5u8b4oRAOoHIeZYtJT2q18XoRejGQWgGObjxzlGiX/s2a0xzv?=
 =?us-ascii?q?ovHwfI0gc9G94CqXrZodHwOKoUTOu7zrTHzS/bYv1L2Tnz9obIfBMvr/6CUr?=
 =?us-ascii?q?1/c9bex0Y0GgPZjVids5DpMy+b2+kPtWWQ8upuVfioi24iswx/vySvydk0io?=
 =?us-ascii?q?nJmI0VzE3P+zh8wIkvId24TFB0YN65G5ZXrCGVKpB2T9g+Q2BopCk6yroGtY?=
 =?us-ascii?q?S9fCgR0psr3RHfa/uZc4WR5B/oSeifITB9hH1/ebK/gQ6/8Uu+xe3mUMm7zl?=
 =?us-ascii?q?JKojBCktnWuXAA0QHY5MufSvZl40us1jmC2xrT5+1ZO0w4i6XWJ4A7zrItkJ?=
 =?us-ascii?q?cYrF7NETXsmErsia+bbkAk+u+15Ov5erjmvZqcN5NsigH5L6QuhtSzAeQmPQ?=
 =?us-ascii?q?gKWGiW4fi826f5/U34XbVKlec6kqjfsJDUIsQbvbC2DBNP3oY/6xewEzem0N?=
 =?us-ascii?q?MCkXkBMF1FYw6Ig5LsO1HPJPD0Ffa/g1Kynzd33/3KI7LsD5rXInXDjbvtZ6?=
 =?us-ascii?q?hx5kFCxAYp0NxT/5dUBasAIPL3VE/xrtvYDhohPgyv3unnE85w1p8eWG2TAq?=
 =?us-ascii?q?+ZN7nesVmT5u01OeWMa4gVuCjlJ/g/+/HulWM5mUMafaSxwZQYcmu4EepmIk?=
 =?us-ascii?q?iCenrjntcBHn0XvgowSOzllkeCXSdPaHmoRa4z+jY7CIe+B4fZWo+tmKCB3D?=
 =?us-ascii?q?u8HpBOem9JEEuMHmnodomeQPcDdCKSLdV8kjwKUbiuVZUh2AqvtA/817poMO?=
 =?us-ascii?q?7U9jcEupLk0dh///fTmg0q9TxoE8Sd1HmAT2NxnmMPXT82xqF/oVdmx1eFy6?=
 =?us-ascii?q?d4huJXFd1J6/NOSAc6OobWz/ZmBNDqRgLBYtCJRU6iQtWnBzExU90wz8YVY0?=
 =?us-ascii?q?ljB9qikwrD3yu2A74VjrCLAZs0/b/B33j1Oclw0GjG1KY/gFk8WMdPNnOphr?=
 =?us-ascii?q?R59wfNA47FiUKZl7ylda4Exi7C6H+DzXaSvEFfSANwSrvKXXQeZkvQsNT46V?=
 =?us-ascii?q?jPT6GhCbs5KAtN082CJbVQat3vk1pGQO3vONPEY2K+g22wHwqHxquQbIr2fG?=
 =?us-ascii?q?UQxCbdB1YanAAI4XmGMg8+BiS6rm3CDDxuD1XvY0bt8eljrXO3VEg0zxuFb0?=
 =?us-ascii?q?d5zbq65gYVheCAS/MUxr8EuiAhqzVyHFqn3dLWDNqAqBBnfKVHf9w95kxK2n?=
 =?us-ascii?q?7DuAx7OZygKaFiiUIEfARzpU/hyxJ3CoBYm8gwsHwq1BZyKb6f0F5ZbzOXw5?=
 =?us-ascii?q?bwOrLKKmnz+hCjcq3W1U/E0NaQ5KgP7O81q1T6sAGtEUoi7Wto38NO03SG5Z?=
 =?us-ascii?q?XKERASXojrXkYx6Rd2vbPaYjEl7YPOyXJsKbW0siPF298xHOsq0Augf9NEPa?=
 =?us-ascii?q?OcDgDyDskaC9GrKOwtnFipdAwLMPpO+64zOsOsb+GG17KzPOZ8gDKminxK4I?=
 =?us-ascii?q?R60kKW6SV8TO/J35EezvGX2QuHUDj8jFO/vczthY9EYjQSFHKlySf4HI5Rer?=
 =?us-ascii?q?FyfYETBGizOcK32Mtxh5v2VnFF7lGjGU0J2MqteRqVYVz9wRdc1UIJrny7gS?=
 =?us-ascii?q?G41SB7kyk1rqqD2yzD2/7tdB8dNWFWWmZvlk3jIZOxj98BWEiodRIllB276k?=
 =?us-ascii?q?bm36JbvrhwL3HPQUdUeCj7N2diXbWstrWffcFP9oglsTtYUOuie1CWUL39rA?=
 =?us-ascii?q?UA0yPlAWRewCo3dzawupX2hxZ6kn6SLG5vrHrFfsF93RLf68bTRP5SxTcGXT?=
 =?us-ascii?q?V4iTjNClilItmm59GUmIvEsuC7UmKtTIFccS7uzdDIiCzuzmRxDAz3pPuzk8?=
 =?us-ascii?q?DpFQUgmXvw3sJnRA3Tpxb1f4fv2r7/OushdU5tUhu04MNhF5A4iYAwjYwe3X?=
 =?us-ascii?q?UArpST4XcD12z0NJET26f5dmAMXhYNytvY4U7iwkInZnaIwZ/pE26QydZ7Zs?=
 =?us-ascii?q?WrJ2YR1j854uhUB6qOqr9Jhy14phy/tw2VKeNwmjYb1OsG9nEXmacKtRArwy?=
 =?us-ascii?q?HbBaodTmdCOim5rAiF99Czqu1sYW+rdbWhnB5lkcuJEKCJogYaXm3wPJglA3?=
 =?us-ascii?q?kjvY1ELFvQ3Sirucnfc97KYIdW70bFng=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2ANAACVFC9e/wHyM5BmGwEBAQEBAQEFAQEBEQEBAwMBA?=
 =?us-ascii?q?QGBZwYBAQELAYF8gRhUIRIqhBSII2CGdQEBAQEBAQaBN4EBiG6PThSBZwkBA?=
 =?us-ascii?q?QEBAQEBAQErDAEBhEACgkg0CQ4CEAEBAQQBAQEBAQUDAQFshTcMgjspAYJ6A?=
 =?us-ascii?q?QUjBAsBBUEQCRoCAh8HAgJXBgEMBgIBAYJjPwGCViUPkE+bd38zhDUBhFCBO?=
 =?us-ascii?q?AaBDioBjDd5gQeBEScPgihzhDGDKIJeBJd6l16CQ4JMhHaObwYbgkiMT4tlL?=
 =?us-ascii?q?Y4ziGSUIzmBWCsIAhgIIQ+DKBI9GA2GJo1PAxcViE+FXSMDMgGOCQEB?=
Received: from tarius.tycho.ncsc.mil (HELO tarius.infosec.tycho.ncsc.mil) ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 27 Jan 2020 16:56:19 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.infosec.tycho.ncsc.mil (8.14.7/8.14.4) with ESMTP id 00RGtQCM017159;
        Mon, 27 Jan 2020 11:55:27 -0500
Subject: KASAN slab-out-of-bounds in tun_chr_open/sock_init_data (Was: Re:
 [PATCH v14 00/23] LSM: Module stacking for AppArmor)
From:   Stephen Smalley <sds@tycho.nsa.gov>
To:     Casey Schaufler <casey@schaufler-ca.com>,
        casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        lorenzo@google.com, "David S. Miller" <davem@davemloft.net>,
        amade@asmblr.net,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        maxk@qti.qualcomm.com
References: <20200124002306.3552-1-casey.ref@schaufler-ca.com>
 <20200124002306.3552-1-casey@schaufler-ca.com>
 <22585291-b7e0-5a22-6682-168611d902fa@tycho.nsa.gov>
 <6b717a13-3586-5854-0eee-617798f92d34@schaufler-ca.com>
 <de97dc66-7f5b-21f0-cf3d-a1485acbc1c9@tycho.nsa.gov>
Message-ID: <628f018e-5a88-295b-9e4d-b4c6a49645b5@tycho.nsa.gov>
Date:   Mon, 27 Jan 2020 11:56:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <de97dc66-7f5b-21f0-cf3d-a1485acbc1c9@tycho.nsa.gov>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/20 11:14 AM, Stephen Smalley wrote:
> On 1/24/20 4:49 PM, Casey Schaufler wrote:
>> On 1/24/2020 1:04 PM, Stephen Smalley wrote:
>>> On 1/23/20 7:22 PM, Casey Schaufler wrote:
>>>> This patchset provides the changes required for
>>>> the AppArmor security module to stack safely with any other.
>>>>
>>>> v14: Rebase to 5.5-rc5
>>>>        Incorporate feedback from v13
>>>>        - Use an array of audit rules (patch 0002)
>>>>        - Significant change, removed Acks (patch 0002)
>>>>        - Remove unneeded include (patch 0013)
>>>>        - Use context.len correctly (patch 0015)
>>>>        - Reorder code to be more sensible (patch 0016)
>>>>        - Drop SO_PEERCONTEXT as it's not needed yet (patch 0023)
>>>
>>> I don't know for sure if this is your bug, but it happens every time 
>>> I boot with your patches applied and not at all on stock v5.5-rc5 so 
>>> here it is.  Will try to bisect as time permits but not until next 
>>> week. Trigger seems to be loading the tun driver.
>>
>> Thanks. I will have a look as well.
> 
> Bisection led to the first patch in the series, "LSM: Infrastructure 
> management of the sock security". Still not sure if the bug is in the 
> patch itself or just being surfaced by it.

Looks like the bug is pre-existing to me and just exposed by your patch. 
tun_chr_open() is creating a struct tun_file via sk_alloc() with its own 
tun_proto with a custom .obj_size.  It then passes the tun_file->socket 
and ->sk fields to sock_init_data().  sock_init_data() assumes it can 
safely use SOCK_INODE(sock) if sock is non-NULL, which means that it 
presumes all such sockets were wrapped in a struct socket_alloc.  But 
this one wasn't.  I don't know if that's a bug in the tun driver for not 
wrapping its socket in a socket_alloc or in sock_init_data() for 
assuming that all sockets it is passed have been so wrapped.  KASAN is 
tripping on this assignment in sock_init_data():

net/core/sock.c:
    2871                 sk->sk_uid      =       SOCK_INODE(sock)->i_uid;

This appears to have been broken since commit 
86741ec25462e4c8cdce6df2f41ead05568c7d5e ("net: core: Add a UID field to 
struct sock.").

Previously reported here by someone else with RFC patches:
https://lore.kernel.org/netdev/20190929110502.2284-1-amade@asmblr.net/

> 
>>>
>>> [   67.726834] tun: Universal TUN/TAP device driver, 1.6
>>> [   67.736657] 
>>> ==================================================================
>>> [   67.741335] BUG: KASAN: slab-out-of-bounds in 
>>> sock_init_data+0x14a/0x5a0
>>> [   67.745037] Read of size 4 at addr ffff88870afe8928 by task 
>>> libvirtd/1238
>>>
>>> [   67.751861] CPU: 4 PID: 1238 Comm: libvirtd Tainted: G T 
>>> 5.5.0-rc5+ #54
>>> [   67.756250] Call Trace:
>>> [   67.759510]  dump_stack+0xb8/0x110
>>> [   67.761604]  print_address_description.constprop.0+0x1f/0x280
>>> [   67.763768]  __kasan_report.cold+0x75/0x8f
>>> [   67.765895]  ? sock_init_data+0x14a/0x5a0
>>> [   67.768282]  kasan_report+0xe/0x20
>>> [   67.770397]  sock_init_data+0x14a/0x5a0
>>> [   67.772511]  tun_chr_open+0x1de/0x280 [tun]
>>> [   67.774644]  misc_open+0x1cb/0x210
>>> [   67.776820]  chrdev_open+0x15b/0x350
>>> [   67.778917]  ? cdev_put.part.0+0x30/0x30
>>> [   67.781030]  do_dentry_open+0x2cb/0x800
>>> [   67.783135]  ? cdev_put.part.0+0x30/0x30
>>> [   67.785225]  ? devcgroup_check_permission+0x11a/0x260
>>> [   67.787321]  ? __x64_sys_fchdir+0xf0/0xf0
>>> [   67.789418]  ? security_inode_permission+0x5b/0x70
>>> [   67.791513]  path_openat+0x858/0x14a0
>>> [   67.793589]  ? path_mountpoint+0x5e0/0x5e0
>>> [   67.795719]  ? mark_lock+0xb8/0xb00
>>> [   67.797786]  do_filp_open+0x11e/0x1b0
>>> [   67.799840]  ? may_open_dev+0x60/0x60
>>> [   67.801871]  ? match_held_lock+0x1b/0x240
>>> [   67.803968]  ? lock_downgrade+0x360/0x360
>>> [   67.805997]  ? do_raw_spin_lock+0x119/0x1d0
>>> [   67.808041]  ? rwlock_bug.part.0+0x60/0x60
>>> [   67.810099]  ? do_raw_spin_unlock+0xa3/0x130
>>> [   67.812244]  ? _raw_spin_unlock+0x1f/0x30
>>> [   67.814287]  ? __alloc_fd+0x143/0x2f0
>>> [   67.816324]  do_sys_open+0x1f0/0x2d0
>>> [   67.818358]  ? filp_open+0x50/0x50
>>> [   67.820404]  ? trace_hardirqs_on_thunk+0x1a/0x1c
>>> [   67.822447]  ? lockdep_hardirqs_off+0xbe/0x100
>>> [   67.824473]  ? mark_held_locks+0x24/0x90
>>> [   67.826484]  do_syscall_64+0x74/0xd0
>>> [   67.828480]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>> [   67.830478] RIP: 0033:0x7f1a2cce6074
>>> [   67.832495] Code: 24 20 eb 8f 66 90 44 89 54 24 0c e8 86 f4 ff ff 
>>> 44 8b 54 24 0c 44 89 e2 48 89 ee 41 89 c0 bf 9c ff ff ff b8 01 01 00 
>>> 00 0f 05 <48> 3d 00 f0 ff ff 77 32 44 89 c7 89 44 24 0c e8 b8 f4 ff 
>>> ff 8b 44
>>> [   67.834760] RSP: 002b:00007f19e4af46d0 EFLAGS: 00000293 ORIG_RAX: 
>>> 0000000000000101
>>> [   67.837032] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 
>>> 00007f1a2cce6074
>>> [   67.839318] RDX: 0000000000000002 RSI: 00007f1a2d0bfb67 RDI: 
>>> 00000000ffffff9c
>>> [   67.841598] RBP: 00007f1a2d0bfb67 R08: 0000000000000000 R09: 
>>> 00007f19e4af4914
>>> [   67.843941] R10: 0000000000000000 R11: 0000000000000293 R12: 
>>> 0000000000000002
>>> [   67.846283] R13: 000000000000000d R14: 00007f19e4af4920 R15: 
>>> 00007f1a2d0bfb67
>>>
>>> [   67.850936] Allocated by task 1238:
>>> [   67.853241]  save_stack+0x1b/0x80
>>> [   67.855533]  __kasan_kmalloc.constprop.0+0xc2/0xd0
>>> [   67.857935]  sk_prot_alloc+0x115/0x170
>>> [   67.860235]  sk_alloc+0x2f/0xa10
>>> [   67.862541]  tun_chr_open+0x4d/0x280 [tun]
>>> [   67.864894]  misc_open+0x1cb/0x210
>>> [   67.867164]  chrdev_open+0x15b/0x350
>>> [   67.869448]  do_dentry_open+0x2cb/0x800
>>> [   67.871768]  path_openat+0x858/0x14a0
>>> [   67.874041]  do_filp_open+0x11e/0x1b0
>>> [   67.876328]  do_sys_open+0x1f0/0x2d0
>>> [   67.878592]  do_syscall_64+0x74/0xd0
>>> [   67.880899]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>>
>>> [   67.885431] Freed by task 726:
>>> [   67.887689]  save_stack+0x1b/0x80
>>> [   67.889967]  __kasan_slab_free+0x12c/0x170
>>> [   67.892197]  kfree+0xff/0x430
>>> [   67.894444]  uevent_show+0x176/0x1b0
>>> [   67.896709]  dev_attr_show+0x37/0x70
>>> [   67.898940]  sysfs_kf_seq_show+0x119/0x210
>>> [   67.901159]  seq_read+0x29d/0x720
>>> [   67.903367]  vfs_read+0xf9/0x1f0
>>> [   67.905538]  ksys_read+0xc9/0x160
>>> [   67.907736]  do_syscall_64+0x74/0xd0
>>> [   67.909889]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>>
>>> [   67.914100] The buggy address belongs to the object at 
>>> ffff88870afe8000
>>>                  which belongs to the cache kmalloc-4k of size 4096
>>> [   67.918357] The buggy address is located 2344 bytes inside of
>>>                  4096-byte region [ffff88870afe8000, ffff88870afe9000)
>>> [   67.922562] The buggy address belongs to the page:
>>> [   67.924725] page:ffffea001c2bfa00 refcount:1 mapcount:0 
>>> mapping:ffff88881f00de00 index:0x0 compound_mapcount: 0
>>> [   67.926926] raw: 0017ffe000010200 ffffea001c167a00 
>>> 0000000200000002 ffff88881f00de00
>>> [   67.929144] raw: 0000000000000000 0000000080040004 
>>> 00000001ffffffff 0000000000000000
>>> [   67.931362] page dumped because: kasan: bad access detected
>>>
>>> [   67.936192] Memory state around the buggy address:
>>> [   67.938438]  ffff88870afe8800: 00 00 00 00 00 00 00 00 00 00 00 00 
>>> 00 00 00 00
>>> [   67.941078]  ffff88870afe8880: fc fc fc fc fc fc fc fc fc fc fc fc 
>>> fc fc fc fc
>>> [   67.943393] >ffff88870afe8900: fc fc fc fc fc fc fc fc fc fc fc fc 
>>> fc fc fc fc
>>> [   67.945709]                                   ^
>>> [   67.948000]  ffff88870afe8980: fc fc fc fc fc fc fc fc fc fc fc fc 
>>> fc fc fc fc
>>> [   67.950311]  ffff88870afe8a00: fc fc fc fc fc fc fc fc fc fc fc fc 
>>> fc fc fc fc
>>> [   67.952629] 
>>> ==================================================================
> 

