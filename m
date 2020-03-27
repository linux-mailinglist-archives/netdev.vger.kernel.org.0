Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84946195592
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 11:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbgC0Kqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 06:46:53 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40148 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgC0Kqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 06:46:53 -0400
Received: by mail-io1-f66.google.com with SMTP id k9so9346104iov.7;
        Fri, 27 Mar 2020 03:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bkMIfdQgcOHtrAI2jun0eDF5HTnYvMzXkJihd3m0k04=;
        b=UG+EgR+c6QLexLS43dc64m9Ddo08WVPDHR2W/RFI9K++CDNBPWcghrQwenaZOGHQse
         8yHKPzgCVlY38XEnIFK4y1HogXG31pPs1he3eitNoPoTj3yv0vS2CtThemeviucJGFMX
         stvUzWLgkq0dIZ7y8lodU/2HDYAJX4pp+m8zlVHv0gRBynEw51pwcZ6kBApwXIZXlpag
         JAnjC5u6ra+BjqxGSC46X9oNUmxM49QwibWyOYBunZhXjJpA0vZhzaSajvbUJX9401TF
         sxTCQ++B3Bcr7WIRN0yr7a60lixB6dyeXmfrY3AFGg6IS++nmxtvR9h8BSnc+1ru1imR
         rVIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bkMIfdQgcOHtrAI2jun0eDF5HTnYvMzXkJihd3m0k04=;
        b=BhuvK8/KD654vzh/znyDOkxulU9VeUL3Lcr3FWn8tRrhChIpOKwtuaQ3vfOkmTK1cB
         2TexixaumfUdWyIEJD3AESJ11/md74B/kCiFyW1okrKZTO7COQWapxdPtYPaQ2+QiGF+
         cE92e7YtUz8Y269KOdJ2I1Q8tqQQX7t0gFmJAF5Pj3HgiJbzD20MniTmPxTR7wcXt3pV
         RM9DDx2+zfLGai+HXdVJvusoaRyfq37CpoX8iY1LykJFsalIGbOR95hoDo7OlDhcx60B
         ZciiWrK3vm5jZ5+4Y7JgcKOloR1aELD8HCzT9i2yropYf3pfq06YdHAFmRKMdV7vRbGn
         5Fdw==
X-Gm-Message-State: ANhLgQ1GmlOm0pyGjpmTvyCZDDRBF/Dk96DEDCtlBklPilipH1w7AnuK
        xS7BwPfI+d3yEhi03TXJzywRfHGosczsUZGInLw=
X-Google-Smtp-Source: ADFU+vv9RsnpHSIU9cOMKs3ZlOCZDjGU4CkMaME/eRtGUDbxtT8R70kvKdgfWzR2SinCYUv9J8OAkYyBX3inyiX/zhM=
X-Received: by 2002:a6b:8fd7:: with SMTP id r206mr12096863iod.109.1585306011082;
 Fri, 27 Mar 2020 03:46:51 -0700 (PDT)
MIME-Version: 1.0
References: <HK0PR02MB2563E665E2867865CE8258C2ABCC0@HK0PR02MB2563.apcprd02.prod.outlook.com>
In-Reply-To: <HK0PR02MB2563E665E2867865CE8258C2ABCC0@HK0PR02MB2563.apcprd02.prod.outlook.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 27 Mar 2020 11:46:56 +0100
Message-ID: <CAOi1vP-ckVdkAivQSKBTExiYfSFdURSx82_YWWc2ODHP0fYTpg@mail.gmail.com>
Subject: Re: [PATCH] scsi: libiscsi: we should take compound page into account also
To:     =?UTF-8?B?6ZmI5a6J5bqG?= <chenanqing@oppo.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>, Sage Weil <sage@redhat.com>,
        Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 11:04 AM =E9=99=88=E5=AE=89=E5=BA=86 <chenanqing@op=
po.com> wrote:
>
>
> On Fri, Mar 27, 2020 at 9:36 AM <chenanqing@oppo.com> wrote:
> >
> > From: Chen Anqing <chenanqing@oppo.com>
> > To: Ilya Dryomov <idryomov@gmail.com>
> > Cc: Jeff Layton <jlayton@kernel.org>,
> >         Sage Weil <sage@redhat.com>,
> >         Jakub Kicinski <kuba@kernel.org>,
> >         ceph-devel@vger.kernel.org,
> >         netdev@vger.kernel.org,
> >         linux-kernel@vger.kernel.org,
> >         chenanqing@oppo.com
> > Subject: [PATCH] libceph: we should take compound page into account
> > also
> > Date: Fri, 27 Mar 2020 04:36:30 -0400
> > Message-Id: <20200327083630.36296-1-chenanqing@oppo.com>
> > X-Mailer: git-send-email 2.18.2
> >
> > the patch is occur at a real crash,which slab is come from a compound
> > page,so we need take the compound page into account also.
> > fixed commit 7e241f647dc7 ("libceph: fall back to sendmsg for slab page=
s")'
> >
> > Signed-off-by: Chen Anqing <chenanqing@oppo.com>
> > ---
> >  net/ceph/messenger.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c index
> > f8ca5edc5f2c..e08c1c334cd9 100644
> > --- a/net/ceph/messenger.c
> > +++ b/net/ceph/messenger.c
> > @@ -582,7 +582,7 @@ static int ceph_tcp_sendpage(struct socket *sock, s=
truct page *page,
> >          * coalescing neighboring slab objects into a single frag which
> >          * triggers one of hardened usercopy checks.
> >          */
> > -       if (page_count(page) >=3D 1 && !PageSlab(page))
> > +       if (page_count(page) >=3D 1 && !PageSlab(compound_head(page)))
> >                 sendpage =3D sock->ops->sendpage;
> >         else
> >                 sendpage =3D sock_no_sendpage;
>
> >Hi Chen,
>
> >AFAICT compound pages should already be taken into account, because Page=
Slab is defined as:
> >
> >  __PAGEFLAG(Slab, slab, PF_NO_TAIL)
> >
> >  #define __PAGEFLAG(uname, lname, policy)                       \
> >      TESTPAGEFLAG(uname, lname, policy)                         \
> >      __SETPAGEFLAG(uname, lname, policy)                        \
> >      __CLEARPAGEFLAG(uname, lname, policy)
> >
> >  #define TESTPAGEFLAG(uname, lname, policy)                     \
> >  static __always_inline int Page##uname(struct page *page)      \
> >      { return test_bit(PG_##lname, &policy(page, 0)->flags); }
> >
> > and PF_NO_TAIL policy is defined as:
>
> >  #define PF_NO_TAIL(page, enforce) ({                        \
> >      VM_BUG_ON_PGFLAGS(enforce && PageTail(page), page);     \
> >      PF_POISONED_CHECK(compound_head(page)); })
>
> > So compound_head() is called behind the scenes.
>
> >Could you please explain what crash did you observe in more detail?
> >Perhaps you backported this patch to an older kernel?
>
> >Thanks,
>
> >                Ilya
> Hi llya,
>  thank you for you reply so quickly.
>  I have apply the patch in my server ,it's work fine ,so I thought it sho=
uld be pushed to the community, but I Know nothing about the
>  PageSlab has been changed ,because I use the 3.10.0- all the time ,sorry=
 for that. i also send patch to scsi group also.

No problem at all, pushing fixes upstream is a good thing!

So yes, if you are backporting to 3.10 on your own, you need this
patch.  FWIW libceph has been patched in kernel-3.10.0-957.10.1.el7.
Can't say anything about tgtd though.

>
>  my crash is writed below:
>
> [85774.558604] usercopy: kernel memory exposure attempt detected from fff=
f9cba0bf75400 (kmalloc-512) (1024 bytes)
> [85774.559261] ------------[ cut here ]------------
> [85774.559839] kernel BUG at mm/usercopy.c:72!
> [85774.560367] invalid opcode: 0000 [#1] SMP
> [85774.560879] Modules linked in: cmac arc4 md4 nls_utf8 cifs ccm dns_res=
olver xfs iscsi_tcp libiscsi_tcp libiscsi iptable_raw iptable_mangle sch_sf=
q sch_htb scsi_transport_iscsi veth ipt_MASQUERADE nf_nat_masquerade_ipv4 x=
t_comment xt_mark iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 =
xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack br_netfilter br=
idge stp llc dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc3=
2c loop bonding fuse sunrpc dm_mirror dm_region_hash dm_log dm_mod dell_smb=
ios dell_wmi_descriptor iTCO_wdt iTCO_vendor_support dcdbas skx_edac intel_=
powerclamp coretemp intel_rapl iosf_mbi kvm_intel kvm irqbypass crc32_pclmu=
l ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryp=
td ipmi_ssif sg pcspkr mei_me lpc_ich i2c_i801 mei wmi ipmi_si
> [85774.564343]  ipmi_devintf ipmi_msghandler acpi_pad acpi_power_meter ip=
_tables ext4 mbcache jbd2 sd_mod crc_t10dif crct10dif_generic crct10dif_pcl=
mul crct10dif_common crc32c_intel mgag200 drm_kms_helper syscopyarea sysfil=
lrect sysimgblt fb_sys_fops ttm megaraid_sas drm ixgbe ahci igb drm_panel_o=
rientation_quirks libahci mdio libata ptp pps_core dca i2c_algo_bit nfit li=
bnvdimm
> [85774.566809] CPU: 9 PID: 28054 Comm: tgtd Kdump: loaded Not tainted 3.1=
0.0-957.27.2.el7.x86_64 #1
> [85774.567446] Hardware name: Dell Inc. PowerEdge R740/0YNX56, BIOS 2.4.8=
 11/26/2019
> [85774.568094] task: ffff9cb12e1e0000 ti: ffff9cb124224000 task.ti: ffff9=
cb124224000
> [85774.568754] RIP: 0010:[<ffffffff9803f557>]  [<ffffffff9803f557>] __che=
ck_object_size+0x87/0x250
> [85774.569419] RSP: 0018:ffff9cb124227b98  EFLAGS: 00010246
> [85774.570072] RAX: 0000000000000062 RBX: ffff9cba0bf75400 RCX: 000000000=
0000000
> [85774.570723] RDX: 0000000000000000 RSI: ffff9cc13bf13898 RDI: ffff9cc13=
bf13898
> [85774.571372] RBP: ffff9cb124227bb8 R08: 0000000000000000 R09: ffff9cb13=
13e6f00
> [85774.572017] R10: 000000000003bc95 R11: 0000000000000001 R12: 000000000=
0000400
> [85774.572669] R13: 0000000000000001 R14: ffff9cba0bf75800 R15: 000000000=
0000400
> [85774.573325] FS:  00007f41a122a740(0000) GS:ffff9cc13bf00000(0000) knlG=
S:0000000000000000
> [85774.573994] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [85774.574655] CR2: 0000000003236fe0 CR3: 0000001023138000 CR4: 000000000=
07607e0
> [85774.575314] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [85774.575964] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [85774.576609] PKRU: 55555554
> [85774.577242] Call Trace:
> [85774.577880]  [<ffffffff9818dd9d>] memcpy_toiovec+0x4d/0xb0
> [85774.578531]  [<ffffffff9842c858>] skb_copy_datagram_iovec+0x128/0x280
> [85774.579190]  [<ffffffff9849372a>] tcp_recvmsg+0x22a/0xb30
> [85774.579838]  [<ffffffff984c2340>] inet_recvmsg+0x80/0xb0
> [85774.580474]  [<ffffffff9841a6ec>] sock_aio_read.part.9+0x14c/0x170
> [85774.581097]  [<ffffffff9841a731>] sock_aio_read+0x21/0x30
> [85774.581714]  [<ffffffff98041b33>] do_sync_read+0x93/0xe0
> [85774.582328]  [<ffffffff98042615>] vfs_read+0x145/0x170
> [85774.582934]  [<ffffffff9804342f>] SyS_read+0x7f/0xf0
> [85774.583543]  [<ffffffff98576ddb>] system_call_fastpath+0x22/0x27
> [85774.584158] Code: 45 d1 48 c7 c6 05 c3 87 98 48 c7 c1 f6 57 88 98 48 0=
f 45 f1 49 89 c0 4d 89 e1 48 89 d9 48 c7 c7 00 27 88 98 31 c0 e8 30 e4 51 0=
0 <0f> 0b 0f 1f 80 00 00 00 00 48 c7 c0 00 00 e0 97 4c 39 f0 73 0d
> [85774.585495] RIP  [<ffffffff9803f557>] __check_object_size+0x87/0x250
> [85774.586135]  RSP <ffff9cb124227b98>
>
> crash> dis -l skb_copy_datagram_iovec
> /usr/src/debug/kernel-3.10.0-957.27.2.el7/linux-3.10.0-957.27.2.el7.x86_6=
4/net/core/datagram.c: 395
> 0xffffffff9842c730 <skb_copy_datagram_iovec>:   nopl   0x0(%rax,%rax,1) [=
FTRACE NOP]
> 0xffffffff9842c735 <skb_copy_datagram_iovec+5>: push   %rbp
> 0xffffffff9842c736 <skb_copy_datagram_iovec+6>: mov    %rsp,%rbp
> 0xffffffff9842c739 <skb_copy_datagram_iovec+9>: push   %r15
> 0xffffffff9842c73b <skb_copy_datagram_iovec+11>:        push   %r14
> 0xffffffff9842c73d <skb_copy_datagram_iovec+13>:        mov    %rdi,%r14
> 0xffffffff9842c740 <skb_copy_datagram_iovec+16>:        push   %r13
> 0xffffffff9842c742 <skb_copy_datagram_iovec+18>:        push   %r12
> 0xffffffff9842c744 <skb_copy_datagram_iovec+20>:        mov    %esi,%r12d
> 0xffffffff9842c747 <skb_copy_datagram_iovec+23>:        push   %rbx------=
----------=EF=BC=9Askb is store in rbx and I get it from stack
> 0xffffffff9842c748 <skb_copy_datagram_iovec+24>:        mov    %ecx,%ebx
> 0xffffffff9842c74a <skb_copy_datagram_iovec+26>:        sub    $0x28,%rsp
>
> crash> sk_buff.len ffff9cb0e3b388f8
>   len =3D 1024
>
> crash> sk_buff.data_len  ffff9cb0e3b388f8
>   data_len =3D 1024
>
> crash> sk_buff.head  ffff9cb0e3b388f8
>   head =3D 0xffff9cbf9c679400 ""
>
> crash> sk_buff.end  ffff9cb0e3b388f8 -x
>   end =3D 0x2c0
> crash> px  0xffff9cbf9c679400 + 0x2c0
> $5 =3D 0xffff9cbf9c6796c0
>
> crash> skb_shared_info 0xffff9cbf9c6796c0
> struct skb_shared_info {
>   nr_frags =3D 1 '\001',
>   tx_flags =3D 32 ' ',
>   gso_size =3D 0,
>   gso_segs =3D 1,
>   gso_type =3D 0,
>   frag_list =3D 0x0,
>   hwtstamps =3D {
>
>
> crash> skb_shared_info.frags 0xffff9cbf9c6796c0
>   frags =3D {{
>       page =3D {
>         p =3D 0xfffff597a42fdd40-----it the page which store the data
>       },
>       page_offset =3D 1024,
>       size =3D 1024
>     }, {
>
> crash> kmem ffff9cba0bf75400------------the address which is reported in =
the bugon line=EF=BC=8C
> CACHE            NAME                 OBJSIZE  ALLOCATED     TOTAL  SLABS=
  SSIZE
> ffff9ca27fc07600 kmalloc-512              512     242454    464512   7258=
    32k
>   SLAB              MEMORY            NODE  TOTAL  ALLOCATED  FREE
>   fffff597a42fdc00  ffff9cba0bf70000     1     64         59     5
>   FREE / [ALLOCATED]
>   [ffff9cba0bf75400]
>
>       PAGE         PHYSICAL      MAPPING       INDEX CNT FLAGS
> fffff597a42fdd40 190bf75000                0        0  0 6fffff00008000 t=
ail
>
> and I found the page is not the head page ,it is a tail page of compound =
page.
>
> so I search the linux code ,I get the patch:
> commit 7e241f647dc7 ("libceph: fall back to sendmsg for slab pages")'
> commit 08b11eaccfcf ("scsi: libiscsi: fall back to sendmsg for slab pages=
").

Thanks,

                Ilya
