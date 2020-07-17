Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F67F223A05
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 13:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgGQLHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 07:07:12 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48055 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725932AbgGQLHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 07:07:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594984026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LR9jR7lbxSjAbIWcYXZ1pUML1V/7A0vXeY6OCDIPpc4=;
        b=aKA661sI961L+81Pa4fJ0I5OZVpVktFhSEAuQyuCYM+wfp8z8NHr1QmUvHE9+kMjX7vZ/o
        qtVjSpVg3kqaZwQFOpDVjCnXyxakuAJBrc/C1MmwnBmLS0m80lETYYD3qRE7399upNtf+f
        mK2g5RWsN+s9ZZlEavmCSCLBUXUBSdw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-3OySIiTGPIW_aX6-w4eJMQ-1; Fri, 17 Jul 2020 07:07:03 -0400
X-MC-Unique: 3OySIiTGPIW_aX6-w4eJMQ-1
Received: by mail-wr1-f69.google.com with SMTP id y13so8398835wrp.13
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 04:07:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LR9jR7lbxSjAbIWcYXZ1pUML1V/7A0vXeY6OCDIPpc4=;
        b=hAr5GvWhofkBHzKURGAmX+INvG8Y7t5tmmMlK6GyHLYk/C+jC2On1HFouvFNImRsi3
         iXVoibt+O+3Wsv4JgRwb3Hi6O7P7HIGJNFCfokgc1KTAfFAnvlyKZv/gL5qlLrAJpa0O
         WIa7HRl5HuvohYQGc0qRxKE3TcN/C/wEo98I23BcMyEjNHwPQvcGaYaML3+M4LRVPwCE
         delfKfORV3pg4dE6FjiPrkb7iGTvFylPWkBFDYmG2e/HBsGPP2DwLPDtDtqoKCjjHDUq
         SjmQpsg+1WI5s6UyLQjqHIKJVctj8rcbvj7TCfCTaLXCM5ePuViVKXjThbZY2q5nGp66
         vjTQ==
X-Gm-Message-State: AOAM533Vh12dHOisiDeFhRbTN21nkfscA8Sy66TW4ctU8ysliK4zlpKY
        Va02juz6DZ/zx1AOx9Y9T04+D4m8HtTwCp6lP77DNxO/wP0hSBS+k/32RqXJBWMam2nyYQN2M7t
        /d6dj2uOSEaaMXO34
X-Received: by 2002:a1c:5581:: with SMTP id j123mr8451763wmb.75.1594984022049;
        Fri, 17 Jul 2020 04:07:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxhnczYRNnmI9pad3GwPPtohAOjyk6nt4x/EK6bSbnzKRthkevvySUZTI5q9o5y/9keZHy6hw==
X-Received: by 2002:a1c:5581:: with SMTP id j123mr8451698wmb.75.1594984021313;
        Fri, 17 Jul 2020 04:07:01 -0700 (PDT)
Received: from localhost ([151.48.133.17])
        by smtp.gmail.com with ESMTPSA id k18sm14046522wrx.34.2020.07.17.04.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 04:07:00 -0700 (PDT)
Date:   Fri, 17 Jul 2020 13:06:56 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net, toke@redhat.com,
        dsahern@kernel.org, andrii.nakryiko@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH v7 bpf-next 0/9] introduce support for XDP programs in
 CPUMAP
Message-ID: <20200717110656.GB1683270@localhost.localdomain>
References: <cover.1594734381.git.lorenzo@kernel.org>
 <20200717120013.0926a74e@toad>
 <20200717120847.2e4a950a@toad>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Content-Disposition: inline
In-Reply-To: <20200717120847.2e4a950a@toad>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, 17 Jul 2020 12:00:13 +0200
> Jakub Sitnicki <jakub@cloudflare.com> wrote:
>=20

[...]

> 'test_maps' looks sad :-( Not sure if related.

I trigger this issue even switching back to commit:

commit 59632b220f2d61df274ed3a14a204e941051fdad
Author: Randy Dunlap <rdunlap@infradead.org>
Date:   Wed Jul 15 09:42:46 2020 -0700

	net: ipv6: drop duplicate word in comment


[  244.327081] [   8645]     0  8645      760       31    40960        0   =
          0 test_maps
[  244.327148] oom-kill:constraint=3DCONSTRAINT_NONE,nodemask=3D(null),glob=
al_oom,task_memcg=3D/system.slice/polkit.service,task=3Dpolkitd,pid=3D211,u=
id=3D997
[  244.327264] Out of memory: Killed process 211 (polkitd) total-vm:1541300=
kB, anon-rss:7516kB, file-rss:0kB, shmem-rss:0kB, UID:997 pgtables:180kB oo=
m_score_adj:0
[  244.333067] test_maps invoked oom-killer: gfp_mask=3D0x140cc0(GFP_USER|_=
_GFP_COMP), order=3D0, oom_score_adj=3D0
[  244.333141] CPU: 0 PID: 8632 Comm: test_maps Not tainted 5.8.0-rc4-kvm+ =
#196
[  244.333196] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.1=
3.0-2.fc32 04/01/2014
[  244.333270] Call Trace:
[  244.333301]  dump_stack+0x57/0x70
[  244.333334]  dump_header+0x4a/0x1d7
[  244.333367]  oom_kill_process.cold+0xb/0x10
[  244.333398]  out_of_memory+0x1ca/0x280
[  244.333428]  __alloc_pages_slowpath.constprop.0+0x946/0xc00
[  244.333489]  __alloc_pages_nodemask+0x1f7/0x230
[  244.333529]  alloc_slab_page+0x157/0x2b0
[  244.333556]  allocate_slab+0x2da/0x320
[  244.333585]  ___slab_alloc.constprop.0+0x283/0x4f0
[  244.333622]  ? update_load_avg+0x5b/0x520
[  244.333649]  ? htab_map_alloc+0x3a/0x480
[  244.333677]  ? set_next_entity+0x60/0x80
[  244.333705]  ? pick_next_task_fair+0x25f/0x2c0
[  244.333742]  ? kvm_sched_clock_read+0xd/0x20
[  244.333776]  kmem_cache_alloc_trace+0x1ca/0x1e0
[  244.333811]  ? htab_map_alloc+0x3a/0x480
[  244.333839]  htab_map_alloc+0x3a/0x480
[  244.333869]  __do_sys_bpf+0x2a4/0x1c30
[  244.333897]  ? hrtimer_nanosleep+0xb8/0x190
[  244.333926]  do_syscall_64+0x45/0x240
[  244.333953]  ? exc_page_fault+0x1b4/0x4a0
[  244.333993]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  244.334037] RIP: 0033:0x7fe678a5b43d
[  244.334072] Code: Bad RIP value.
[  244.334103] RSP: 002b:00007ffed0c408a8 EFLAGS: 00000202 ORIG_RAX: 000000=
0000000141
[  244.334166] RAX: ffffffffffffffda RBX: 0000000000000013 RCX: 00007fe678a=
5b43d
[  244.334219] RDX: 0000000000000078 RSI: 00007ffed0c408e0 RDI: 00000000000=
00000
[  244.334268] RBP: 00007ffed0c408c0 R08: 00007ffed0c408e0 R09: 00007ffed0c=
408e0
[  244.334326] R10: 0000000000000000 R11: 0000000000000202 R12: 00000000000=
00001
[  244.334393] R13: 0000000000000002 R14: 0000000000000054 R15: 00000000000=
00000
[  244.334457] Mem-Info:
[  244.334488] active_anon:13749 inactive_anon:81 isolated_anon:0
                active_file:0 inactive_file:2 isolated_file:0
                unevictable:0 dirty:0 writeback:0
                slab_reclaimable:4723 slab_unreclaimable:25886
                mapped:38 shmem:125 pagetables:1432 bounce:0
                free:25932 free_pcp:676 free_cma:0
[  244.334684] Node 0 active_anon:54996kB inactive_anon:324kB active_file:0=
kB inactive_file:8kB unevictable:0kB isolated(anon):0kB isolated(file):0kB =
mapped:152kB dirty:0kB writeback:0kB shmem:500kB shmem_thp: 0kB shmem_pmdma=
pped: 0kB anon_thp: 4096kB writeback_tmp:0kB all_unreclaimable? no
[  244.334839] DMA free:8528kB min:704kB low:880kB high:1056kB reserved_hig=
hatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file=
:0kB unevictable:0kB writepending:0kB present:15992kB managed:15908kB mlock=
ed:0kB kernel_stack:16kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0=
kB free_cma:0kB
[  244.334991] lowmem_reserve[]: 0 1972 1972 1972
[  244.335029] DMA32 free:95200kB min:97596kB low:119944kB high:142292kB re=
served_highatomic:4096KB active_anon:54996kB inactive_anon:324kB active_fil=
e:100kB inactive_file:492kB unevictable:0kB writepending:0kB present:208062=
4kB managed:2024508kB mlocked:0kB kernel_stack:6496kB pagetables:5728kB bou=
nce:0kB free_pcp:2704kB local_pcp:1468kB free_cma:0kB
[  244.335202] lowmem_reserve[]: 0 0 0 0
[  244.335230] DMA: 6*4kB (U) 1*8kB (U) 1*16kB (U) 1*32kB (U) 0*64kB 0*128k=
B 1*256kB (U) 0*512kB 0*1024kB 0*2048kB 2*4096kB (ME) =3D 8528kB
[  244.335313] DMA32: 1607*4kB (MEH) 1383*8kB (UMEH) 913*16kB (UMH) 556*32k=
B (UMEH) 368*64kB (MEH) 82*128kB (MH) 27*256kB (MH) 0*512kB 0*1024kB 2*2048=
kB (UM) 0*4096kB =3D 94948kB
[  244.335415] 159 total pagecache pages
[  244.335444] 0 pages in swap cache
[  244.335472] Swap cache stats: add 0, delete 0, find 0/0
[  244.335503] Free swap  =3D 0kB
[  244.335530] Total swap =3D 0kB
[  244.335559] 524154 pages RAM
[  244.335589] 0 pages HighMem/MovableOnly
[  244.335618] 14050 pages reserved
[  244.335645] Unreclaimable slab info:
[  244.335672] Name                      Used          Total
[  244.335760] 9p-fcall-cache            32KB         32KB
[  244.335808] p9_req_t                   3KB          3KB
[  244.335842] PINGv6                    31KB         31KB
[  244.335880] RAWv6                     78KB         78KB
[  244.335915] UDPv6                     30KB         30KB
[  244.335951] tw_sock_TCPv6              3KB          3KB
[  244.335987] request_sock_TCPv6          3KB          3KB
[  244.336022] TCPv6                     30KB         30KB

Increasing vm memory from 2G to 4G fixes the issue for me. Can you please
double check?

Regards,
Lorenzo

>=20
> bash-5.0# ./test_maps
> Fork 1024 tasks to 'test_update_delete'
> Fork 1024 tasks to 'test_update_delete'
> Fork 100 tasks to 'test_hashmap'
> Fork 100 tasks to 'test_hashmap_percpu'
> Fork 100 tasks to 'test_hashmap_sizes'
> [   66.961150] test_maps invoked oom-killer: gfp_mask=3D0x100cca(GFP_HIGH=
USER_MOVABLE), order=3D0, oom_score_adj=3D0
> [   66.962490] CPU: 3 PID: 3263 Comm: test_maps Not tainted 5.8.0-rc4-014=
71-g15d51f3a516b #814
> [   66.963617] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2=
014
> [   66.965958] Call Trace:
> [   66.966404]  dump_stack+0x9e/0xe0
> [   66.966978]  dump_header+0x89/0x49a
> [   66.967624]  oom_kill_process.cold+0xb/0x10
> [   66.968379]  out_of_memory+0x1b1/0x820
> [   66.969060]  ? oom_killer_disable+0x210/0x210
> [   66.969833]  __alloc_pages_slowpath.constprop.0+0x125f/0x1460
> [   66.970852]  ? warn_alloc+0x120/0x120
> [   66.971508]  ? __alloc_pages_nodemask+0x30f/0x5c0
> [   66.972237]  __alloc_pages_nodemask+0x4fd/0x5c0
> [   66.972863]  ? __alloc_pages_slowpath.constprop.0+0x1460/0x1460
> [   66.973681]  ? find_held_lock+0x85/0xa0
> [   66.974223]  ? lock_downgrade+0x360/0x360
> [   66.974760]  ? policy_nodemask+0x19/0x90
> [   66.975266]  ? policy_node+0x56/0x60
> [   66.975719]  pagecache_get_page+0xf7/0x360
> [   66.976259]  filemap_fault+0xe4a/0xfe0
> [   66.976743]  ? read_cache_page_gfp+0x20/0x20
> [   66.977274]  ? find_held_lock+0x85/0xa0
> [   66.977792]  ? filemap_page_mkwrite+0x140/0x140
> [   66.978383]  __do_fault+0x6a/0x1e0
> [   66.978789]  handle_mm_fault+0x16eb/0x1fb0
> [   66.979319]  ? copy_page_range+0xf80/0xf80
> [   66.979755]  ? vmacache_find+0xba/0x100
> [   66.980166]  do_user_addr_fault+0x2ce/0x5ed
> [   66.980625]  exc_page_fault+0x5e/0xc0
> [   66.981005]  ? asm_exc_page_fault+0x8/0x30
> [   66.981445]  asm_exc_page_fault+0x1e/0x30
> [   66.981860] RIP: 0033:0x7f33d40901bd
> [   66.982248] Code: Bad RIP value.
> [   66.982579] RSP: 002b:00007ffe84e1dd18 EFLAGS: 00010202
> [   66.983143] RAX: fffffffffffffff4 RBX: 0000000000000002 RCX: 00007f33d=
40901bd
> [   66.984038] RDX: 0000000000000078 RSI: 00007ffe84e1dd50 RDI: 000000000=
0000000
> [   66.984831] RBP: 00007ffe84e1dd30 R08: 00007ffe84e1dd50 R09: 00007ffe8=
4e1dd50
> [   66.985619] R10: 0000000000000000 R11: 0000000000000202 R12: 000000000=
0020000
> [   66.986399] R13: 0000000000000004 R14: 0000000000000000 R15: 000000000=
0000060
> [   66.987656] Mem-Info:
> [   66.987924] active_anon:1424 inactive_anon:126 isolated_anon:0
> [   66.987924]  active_file:53 inactive_file:33 isolated_file:0
> [   66.987924]  unevictable:0 dirty:0 writeback:0
> [   66.987924]  slab_reclaimable:11120 slab_unreclaimable:98031
> [   66.987924]  mapped:88 shmem:137 pagetables:120 bounce:0
> [   66.987924]  free:21175 free_pcp:725 free_cma:0
> [   66.993308] Node 0 active_anon:5696kB inactive_anon:504kB active_file:=
212kB inactive_file:132kB unevictable:0kB isolated(anon):0kB isolated(file)=
:0kB mapped:352kB dirty:0kB writeback:0kB shmem:548kB shmem_thp: 0kB shmem_=
pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB all_unreclaimable? yes
> [   66.997665] Node 0 DMA free:13708kB min:308kB low:384kB high:460kB res=
erved_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inac=
tive_file:0kB unevictable:0kB writepending:0kB present:15992kB managed:1590=
8kB mlocked:0kB kernel_stack:96kB pagetables:0kB bounce:0kB free_pcp:0kB lo=
cal_pcp:0kB free_cma:0kB
> [   67.002330] lowmem_reserve[]: 0 2925 3354 3354
> [   67.003090] Node 0 DMA32 free:60008kB min:58668kB low:73332kB high:879=
96kB reserved_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:=
0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3129212kB ma=
naged:3001752kB mlocked:0kB kernel_stack:25536kB pagetables:292kB bounce:0k=
B free_pcp:844kB local_pcp:248kB free_cma:0kB
> [   67.008157] lowmem_reserve[]: 0 0 428 428
> [   67.008843] Node 0 Normal free:9528kB min:8600kB low:10748kB high:1289=
6kB reserved_highatomic:2048KB active_anon:5404kB inactive_anon:504kB activ=
e_file:336kB inactive_file:0kB unevictable:0kB writepending:0kB present:104=
8576kB managed:439260kB mlocked:0kB kernel_stack:5824kB pagetables:128kB bo=
unce:0kB free_pcp:1596kB local_pcp:660kB free_cma:0kB
> [   67.014007] lowmem_reserve[]: 0 0 0 0
> [   67.014673] Node 0 DMA: 1*4kB (U) 1*8kB (U) 2*16kB (UE) 1*32kB (U) 1*6=
4kB (E) 2*128kB (UE) 2*256kB (UE) 1*512kB (E) 2*1024kB (UE) 3*2048kB (UME) =
1*4096kB (M) =3D 13708kB
> [   67.016793] Node 0 DMA32: 8*4kB (UM) 5*8kB (UM) 4*16kB (UME) 8*32kB (U=
ME) 7*64kB (ME) 8*128kB (UME) 6*256kB (UM) 8*512kB (ME) 3*1024kB (M) 2*2048=
kB (ME) 11*4096kB (M) =3D 59720kB
> [   67.018915] Node 0 Normal: 256*4kB (UME) 149*8kB (UM) 89*16kB (UM) 41*=
32kB (UM) 20*64kB (UMH) 8*128kB (UM) 2*256kB (MH) 1*512kB (H) 1*1024kB (H) =
0*2048kB 0*4096kB =3D 9304kB
> [   67.020673] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_su=
rp=3D0 hugepages_size=3D1048576kB
> [   67.021811] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_su=
rp=3D0 hugepages_size=3D2048kB
> [   67.022768] 184 total pagecache pages
> [   67.023418] 0 pages in swap cache
> [   67.023912] Swap cache stats: add 0, delete 0, find 0/0
> [   67.024726] Free swap  =3D 0kB
> [   67.025150] Total swap =3D 0kB
> [   67.025530] 1048445 pages RAM
> [   67.025865] 0 pages HighMem/MovableOnly
> [   67.026510] 184215 pages reserved
> [   67.027002] 0 pages cma reserved
> [   67.027542] 0 pages hwpoisoned
> [   67.027928] Unreclaimable slab info:
> [   67.028500] Name                      Used          Total
> [   67.029057] 9p-fcall-cache           297KB        445KB
> [   67.029793] 9p-fcall-cache            49KB         49KB
> [   67.030375] 9p-fcall-cache           123KB        272KB
> [   67.030897] 9p-fcall-cache           346KB        495KB
> [   67.031539] p9_req_t                  16KB         16KB
> [   67.032326] fib6_nodes                 4KB          4KB
> [   67.032950] RAWv6                     31KB         31KB
> [   67.033960] mqueue_inode_cache         31KB         31KB
> [   67.034708] ext4_bio_post_read_ctx         15KB         15KB
> [   67.035647] bio-2                      7KB          7KB
> [   67.036471] UNIX                     372KB        372KB
> [   67.037769] tcp_bind_bucket            4KB          4KB
> [   67.038701] ip_fib_trie                4KB          4KB
> [   67.039496] ip_fib_alias               3KB          3KB
> [   67.040414] ip_dst_cache               4KB          4KB
> [   67.041365] RAW                       31KB         31KB
> [   67.042341] UDP                      121KB        121KB
> [   67.043540] tw_sock_TCP                7KB          7KB
> [   67.044491] request_sock_TCP           7KB          7KB
> [   67.045447] TCP                       58KB         58KB
> [   67.046445] hugetlbfs_inode_cache         31KB         31KB
> [   67.047443] bio-1                     15KB         15KB
> [   67.048375] eventpoll_pwq             23KB         23KB
> [   67.049388] eventpoll_epi             35KB         35KB
> [   67.050361] inotify_inode_mark          3KB          3KB
> [   67.051399] request_queue             62KB         62KB
> [   67.052563] blkdev_ioc                 7KB          7KB
> [   67.053623] bio-0                     20KB         20KB
> [   67.054603] biovec-max               327KB        327KB
> [   67.055593] skbuff_fclone_cache         15KB         15KB
> [   67.056627] skbuff_head_cache        281KB        312KB
> [   67.057868] file_lock_cache           31KB         31KB
> [   67.058878] file_lock_ctx             15KB         15KB
> [   67.059874] fsnotify_mark_connector          4KB          4KB
> [   67.060957] task_delay_info          451KB        451KB
> [   67.061644] proc_dir_entry           125KB        125KB
> [   67.062404] pde_opener                59KB         59KB
> [   67.063696] seq_file                 210KB        241KB
> [   67.064759] sigqueue                  19KB         19KB
> [   67.065763] shmem_inode_cache        795KB        795KB
> [   67.066778] kernfs_node_cache       2565KB       2565KB
> [   67.067762] mnt_cache                 31KB         31KB
> [   67.068798] filp                   11820KB      11820KB
> [   67.069807] names_cache              327KB        476KB
> [   67.070795] key_jar                   15KB         15KB
> [   67.071787] nsproxy                    3KB          3KB
> [   67.072802] vm_area_struct          3236KB       3400KB
> [   67.073773] mm_struct                870KB       1154KB
> [   67.074787] fs_cache                 232KB        264KB
> [   67.076008] files_cache              860KB        972KB
> [   67.076969] signal_cache            2626KB       2686KB
> [   67.077911] sighand_cache           2370KB       2405KB
> [   67.078963] task_struct             8564KB       8564KB
> [   67.080472] cred_jar                 392KB        420KB
> [   67.081767] anon_vma_chain          1191KB       1413KB
> [   67.082736] anon_vma                 200KB        220KB
> [   67.083805] pid                      593KB        640KB
> [   67.084733] Acpi-Operand             265KB        308KB
> [   67.085598] Acpi-ParseExt             47KB         47KB
> [   67.086504] Acpi-Parse               189KB        205KB
> [   67.091509] Acpi-State               200KB        216KB
> [   67.092511] Acpi-Namespace            24KB         24KB
> [   67.093388] numa_policy                3KB          3KB
> [   67.094249] trace_event_file         151KB        151KB
> [   67.095076] ftrace_event_field        196KB        196KB
> [   67.099230] pool_workqueue            16KB         16KB
> [   67.100094] vmap_area                567KB        567KB
> [   67.105224] page->ptl                385KB        433KB
> [   67.106079] kmemleak_scan_area        286KB        286KB
> [   67.107190] kmemleak_object       163919KB     168558KB
> [   67.108081] kmalloc-8k             21840KB      21840KB
> [   67.108932] kmalloc-4k             24592KB      24592KB
> [   67.114003] kmalloc-2k             15684KB      15684KB
> [   67.114896] kmalloc-1k             44936KB      44936KB
> [   67.121018] kmalloc-512             4192KB       4192KB
> [   67.122212] kmalloc-256             1128KB       1128KB
> [   67.123089] kmalloc-192             5008KB       5008KB
> [   67.128978] kmalloc-128              356KB        356KB
> [   67.129877] kmalloc-96               145KB        156KB
> [   67.132262] kmalloc-64              1032KB       1032KB
> [   67.133085] kmalloc-32               233KB        244KB
> [   67.138993] kmalloc-16               108KB        108KB
> [   67.139847] kmalloc-8                440KB        533KB
> [   67.142221] kmem_cache_node           43KB         43KB
> [   67.143038] kmem_cache               140KB        140KB
> [   67.149977] Tasks state (memory values in pages):
> [   67.150743] [  pid  ]   uid  tgid total_vm      rss pgtables_bytes swa=
pents oom_score_adj name
> [   67.153263] [    103]     0   103     7766     1042    81920        0 =
        -1000 systemd-udevd
> [   67.157980] [    194]     0   194     1032      136    40960        0 =
            0 bash
> [   67.161986] [    195]     0   195      758       40    45056        0 =
            0 test_maps
> [   67.167074] [   3178]     0  3178      758       39    45056        0 =
            0 test_maps
> [   67.170572] [   3186]     0  3186      758       39    45056        0 =
            0 test_maps
> [   67.172052] [   3205]     0  3205      758       39    45056        0 =
            0 test_maps
> [   67.177580] [   3213]     0  3213      758       39    45056        0 =
            0 test_maps
> [   67.179026] [   3221]     0  3221      758       39    45056        0 =
            0 test_maps
> [   67.184143] [   3222]     0  3222      758       39    45056        0 =
            0 test_maps
> [   67.187571] [   3230]     0  3230      758       39    45056        0 =
            0 test_maps
> [   67.189053] [   3241]     0  3241      758       39    45056        0 =
            0 test_maps
> [   67.194580] [   3243]     0  3243      758       39    45056        0 =
            0 test_maps
> [   67.196058] [   3250]     0  3250      758       39    45056        0 =
            0 test_maps
> [   67.201124] [   3263]     0  3263      758       39    45056        0 =
            0 test_maps
> [   67.206581] [   3298]     0  3298      758       39    45056        0 =
            0 test_maps
> [   67.210563] oom-kill:constraint=3DCONSTRAINT_NONE,nodemask=3D(null),cp=
uset=3D/,mems_allowed=3D0,global_oom,task_memcg=3D/,task=3Dbash,pid=3D194,u=
id=3D0
> [   67.214666] Out of memory: Killed process 194 (bash) total-vm:4128kB, =
anon-rss:544kB, file-rss:0kB, shmem-rss:0kB, UID:0 pgtables:40kB oom_score_=
adj:0
> [   67.226601] oom_reaper: reaped process 3298 (test_maps), now anon-rss:=
0kB, file-rss:0kB, shmem-rss:0kB
> [   67.228355] oom_reaper: reaped process 3178 (test_maps), now anon-rss:=
0kB, file-rss:0kB, shmem-rss:0kB
> [   67.234148] oom_reaper: reaped process 3222 (test_maps), now anon-rss:=
0kB, file-rss:0kB, shmem-rss:0kB
> [   67.236873] oom_reaper: reaped process 3213 (test_maps), now anon-rss:=
0kB, file-rss:0kB, shmem-rss:0kB
> [   67.239028] oom_reaper: reaped process 3186 (test_maps), now anon-rss:=
0kB, file-rss:0kB, shmem-rss:0kB
> [   67.268146] oom_reaper: reaped process 3221 (test_maps), now anon-rss:=
0kB, file-rss:0kB, shmem-rss:0kB
> [   67.275959] kthreadd invoked oom-killer: gfp_mask=3D0x40cc0(GFP_KERNEL=
|__GFP_COMP), order=3D1, oom_score_adj=3D0
> [   67.277227] CPU: 0 PID: 2 Comm: kthreadd Not tainted 5.8.0-rc4-01471-g=
15d51f3a516b #814
> [   67.278278] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2=
014
> [   67.279895] Call Trace:
> [   67.280250]  dump_stack+0x9e/0xe0
> [   67.280674]  dump_header+0x89/0x49a
> [   67.281113]  out_of_memory.cold+0xa/0xbb
> [   67.281608]  ? oom_killer_disable+0x210/0x210
> [   67.282157]  __alloc_pages_slowpath.constprop.0+0x125f/0x1460
> [   67.282894]  ? warn_alloc+0x120/0x120
> [   67.283377]  ? __alloc_pages_nodemask+0x30f/0x5c0
> [   67.283925]  __alloc_pages_nodemask+0x4fd/0x5c0
> [   67.284446]  ? __alloc_pages_slowpath.constprop.0+0x1460/0x1460
> [   67.285146]  alloc_slab_page+0x2e/0x7a0
> [   67.285590]  ? new_slab+0x22e/0x2b0
> [   67.285999]  new_slab+0x276/0x2b0
> [   67.286402]  ___slab_alloc+0x4ba/0x6d0
> [   67.286892]  ? copy_process+0x256d/0x2f80
> [   67.287391]  ? lock_downgrade+0x360/0x360
> [   67.287908]  ? copy_process+0x256d/0x2f80
> [   67.288482]  ? __slab_alloc.isra.0+0x4b/0x90
> [   67.289207]  __slab_alloc.isra.0+0x4b/0x90
> [   67.289874]  ? copy_process+0x256d/0x2f80
> [   67.290565]  kmem_cache_alloc_node+0xb7/0x330
> [   67.291163]  ? trace_hardirqs_on+0x1e/0x130
> [   67.291699]  copy_process+0x256d/0x2f80
> [   67.292231]  ? mark_lock+0x13f/0xc30
> [   67.292746]  ? find_held_lock+0x85/0xa0
> [   67.293314]  ? __cleanup_sighand+0x60/0x60
> [   67.293889]  _do_fork+0xcf/0x840
> [   67.294354]  ? copy_init_mm+0x20/0x20
> [   67.294856]  ? lockdep_hardirqs_on_prepare+0x14c/0x240
> [   67.295530]  ? _raw_spin_unlock_irq+0x24/0x50
> [   67.296036]  ? trace_hardirqs_on+0x1e/0x130
> [   67.296529]  ? preempt_count_sub+0x14/0xc0
> [   67.297010]  ? lock_acquire+0x133/0x4e0
> [   67.297467]  kernel_thread+0xa8/0xe0
> [   67.297886]  ? legacy_clone_args_valid+0x30/0x30
> [   67.298429]  ? kthread_create_on_node+0xd0/0xd0
> [   67.298966]  ? do_raw_spin_unlock+0xa3/0x130
> [   67.299458]  ? preempt_count_sub+0x14/0xc0
> [   67.299907]  kthreadd+0x2be/0x340
> [   67.300290]  ? kthread_create_on_cpu+0x120/0x120
> [   67.300775]  ? lockdep_hardirqs_on_prepare+0x14c/0x240
> [   67.301324]  ? _raw_spin_unlock_irq+0x24/0x50
> [   67.301771]  ? trace_hardirqs_on+0x1e/0x130
> [   67.302206]  ? kthread_create_on_cpu+0x120/0x120
> [   67.302685]  ret_from_fork+0x1f/0x30
> [   67.303234] Mem-Info:
> [   67.303485] active_anon:1210 inactive_anon:126 isolated_anon:0
> [   67.303485]  active_file:5 inactive_file:12 isolated_file:0
> [   67.303485]  unevictable:0 dirty:0 writeback:0
> [   67.303485]  slab_reclaimable:11187 slab_unreclaimable:98423
> [   67.303485]  mapped:12 shmem:137 pagetables:70 bounce:0
> [   67.303485]  free:20722 free_pcp:1 free_cma:0
> [   67.307090] Node 0 active_anon:4840kB inactive_anon:504kB active_file:=
20kB inactive_file:48kB unevictable:0kB isolated(anon):0kB isolated(file):0=
kB mapped:48kB dirty:0kB writeback:0kB shmem:548kB shmem_thp: 0kB shmem_pmd=
mapped: 0kB anon_thp: 0kB writeback_tmp:0kB all_unreclaimable? yes
> [   67.309863] Node 0 DMA free:13708kB min:308kB low:384kB high:460kB res=
erved_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inac=
tive_file:0kB unevictable:0kB writepending:0kB present:15992kB managed:1590=
8kB mlocked:0kB kernel_stack:96kB pagetables:0kB bounce:0kB free_pcp:0kB lo=
cal_pcp:0kB free_cma:0kB
> [   67.312641] lowmem_reserve[]: 0 2925 3354 3354
> [   67.313081] Node 0 DMA32 free:60868kB min:58668kB low:73332kB high:879=
96kB reserved_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:=
0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3129212kB ma=
naged:3001752kB mlocked:0kB kernel_stack:25824kB pagetables:240kB bounce:0k=
B free_pcp:248kB local_pcp:0kB free_cma:0kB
> [   67.316022] lowmem_reserve[]: 0 0 428 428
> [   67.316560] Node 0 Normal free:8312kB min:8600kB low:10748kB high:1289=
6kB reserved_highatomic:0KB active_anon:4916kB inactive_anon:504kB active_f=
ile:308kB inactive_file:32kB unevictable:0kB writepending:0kB present:10485=
76kB managed:439260kB mlocked:0kB kernel_stack:8192kB pagetables:40kB bounc=
e:0kB free_pcp:392kB local_pcp:0kB free_cma:0kB
> [   67.319987] lowmem_reserve[]: 0 0 0 0
> [   67.320421] Node 0 DMA: 1*4kB (U) 1*8kB (U) 2*16kB (UE) 1*32kB (U) 1*6=
4kB (E) 2*128kB (UE) 2*256kB (UE) 1*512kB (E) 2*1024kB (UE) 3*2048kB (UME) =
1*4096kB (M) =3D 13708kB
> [   67.321913] Node 0 DMA32: 6*4kB (M) 26*8kB (UM) 29*16kB (UM) 11*32kB (=
UME) 9*64kB (UME) 10*128kB (UME) 6*256kB (UM) 7*512kB (ME) 4*1024kB (M) 2*2=
048kB (ME) 11*4096kB (M) =3D 61272kB
> [   67.323562] Node 0 Normal: 488*4kB (UME) 251*8kB (UM) 86*16kB (UM) 37*=
32kB (UM) 18*64kB (UM) 6*128kB (M) 4*256kB (UM) 0*512kB 0*1024kB 0*2048kB 0=
*4096kB =3D 9464kB
> [   67.325773] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_su=
rp=3D0 hugepages_size=3D1048576kB
> [   67.326999] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_su=
rp=3D0 hugepages_size=3D2048kB
> [   67.328287] 155 total pagecache pages
> [   67.328836] 0 pages in swap cache
> [   67.329365] Swap cache stats: add 0, delete 0, find 0/0
> [   67.330140] Free swap  =3D 0kB
> [   67.330596] Total swap =3D 0kB
> [   67.331043] 1048445 pages RAM
> [   67.331478] 0 pages HighMem/MovableOnly
> [   67.332080] 184215 pages reserved
> [   67.332617] 0 pages cma reserved
> [   67.333114] 0 pages hwpoisoned
> [   67.333816] Unreclaimable slab info:
> [   67.334439] Name                      Used          Total
> [   67.335297] 9p-fcall-cache           297KB        445KB
> [   67.336094] 9p-fcall-cache            49KB         49KB
> [   67.336933] 9p-fcall-cache           123KB        272KB
> [   67.337751] 9p-fcall-cache           445KB        495KB
> [   67.338572] p9_req_t                  16KB         16KB
> [   67.339391] fib6_nodes                 4KB          4KB
> [   67.340229] RAWv6                     31KB         31KB
> [   67.341033] mqueue_inode_cache         31KB         31KB
> [   67.341997] ext4_bio_post_read_ctx         15KB         15KB
> [   67.342835] bio-2                      7KB          7KB
> [   67.343695] UNIX                     372KB        372KB
> [   67.344560] tcp_bind_bucket            4KB          4KB
> [   67.345368] ip_fib_trie                4KB          4KB
> [   67.346190] ip_fib_alias               3KB          3KB
> [   67.346997] ip_dst_cache               4KB          4KB
> [   67.347819] RAW                       31KB         31KB
> [   67.348668] UDP                      121KB        121KB
> [   67.349856] tw_sock_TCP                7KB          7KB
> [   67.350723] request_sock_TCP           7KB          7KB
> [   67.351567] TCP                       58KB         58KB
> [   67.352412] hugetlbfs_inode_cache         31KB         31KB
> [   67.353319] bio-1                     15KB         15KB
> [   67.354116] eventpoll_pwq             23KB         23KB
> [   67.354919] eventpoll_epi             35KB         35KB
> [   67.355735] inotify_inode_mark          3KB          3KB
> [   67.356618] request_queue             62KB         62KB
> [   67.357680] blkdev_ioc                 7KB          7KB
> [   67.358569] bio-0                     20KB         20KB
> [   67.359520] biovec-max               327KB        327KB
> [   67.360396] skbuff_fclone_cache         15KB         15KB
> [   67.361277] skbuff_head_cache        281KB        312KB
> [   67.362116] file_lock_cache           31KB         31KB
> [   67.362967] file_lock_ctx             15KB         15KB
> [   67.363597] fsnotify_mark_connector          4KB          4KB
> [   67.364279] task_delay_info          455KB        455KB
> [   67.364832] proc_dir_entry           125KB        125KB
> [   67.365663] pde_opener                59KB         59KB
> [   67.366265] seq_file                 210KB        241KB
> [   67.366805] sigqueue                  19KB         19KB
> [   67.367386] shmem_inode_cache        795KB        795KB
> [   67.367909] kernfs_node_cache       2565KB       2565KB
> [   67.368489] mnt_cache                 31KB         31KB
> [   67.369014] filp                   11820KB      11820KB
> [   67.369585] names_cache              327KB        476KB
> [   67.370113] key_jar                   15KB         15KB
> [   67.370664] nsproxy                    3KB          3KB
> [   67.371230] vm_area_struct          2870KB       3100KB
> [   67.371754] mm_struct                831KB       1154KB
> [   67.372337] fs_cache                 176KB        212KB
> [   67.372862] files_cache              843KB        956KB
> [   67.373625] signal_cache            2809KB       2809KB
> [   67.374210] sighand_cache           2615KB       2615KB
> [   67.374750] task_struct             9207KB       9207KB
> [   67.375335] cred_jar                 392KB        420KB
> [   67.375856] anon_vma_chain          1058KB       1291KB
> [   67.376437] anon_vma                 144KB        160KB
> [   67.376952] pid                      609KB        640KB
> [   67.377519] Acpi-Operand             265KB        308KB
> [   67.378063] Acpi-ParseExt             47KB         47KB
> [   67.378645] Acpi-Parse               189KB        205KB
> [   67.379216] Acpi-State               200KB        216KB
> [   67.379747] Acpi-Namespace            24KB         24KB
> [   67.380345] numa_policy                3KB          3KB
> [   67.380870] trace_event_file         151KB        151KB
> [   67.381649] ftrace_event_field        196KB        196KB
> [   67.382199] pool_workqueue            16KB         16KB
> [   67.382722] vmap_area                567KB        567KB
> [   67.383261] page->ptl                384KB        429KB
> [   67.383781] kmemleak_scan_area        286KB        286KB
> [   67.384527] kmemleak_object       162939KB     167943KB
> [   67.385080] kmalloc-8k             21840KB      21840KB
> [   67.385618] kmalloc-4k             25736KB      25736KB
> [   67.386158] kmalloc-2k             15684KB      15684KB
> [   67.386679] kmalloc-1k             44936KB      44936KB
> [   67.387208] kmalloc-512             4192KB       4192KB
> [   67.387826] kmalloc-256             1184KB       1184KB
> [   67.388514] kmalloc-192             5032KB       5032KB
> [   67.389397] kmalloc-128              356KB        356KB
> [   67.390100] kmalloc-96               145KB        156KB
> [   67.390775] kmalloc-64              1052KB       1052KB
> [   67.391489] kmalloc-32               233KB        244KB
> [   67.392261] kmalloc-16               108KB        108KB
> [   67.392964] kmalloc-8                440KB        533KB
> [   67.393657] kmem_cache_node           43KB         43KB
> [   67.394424] kmem_cache               140KB        140KB
> [   67.395296] Tasks state (memory values in pages):
> [   67.395889] [  pid  ]   uid  tgid total_vm      rss pgtables_bytes swa=
pents oom_score_adj name
> [   67.397031] [    103]     0   103     7766     1042    81920        0 =
        -1000 systemd-udevd
> [   67.398411] Out of memory and no killable processes...
> [   67.399203] Kernel panic - not syncing: System is deadlocked on memory
> [   67.400146] CPU: 0 PID: 2 Comm: kthreadd Not tainted 5.8.0-rc4-01471-g=
15d51f3a516b #814
> [   67.401254] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2=
014
> [   67.403154] Call Trace:
> [   67.403536]  dump_stack+0x9e/0xe0
> [   67.404021]  panic+0x1ab/0x3ae
> [   67.404497]  ? __warn_printk+0xf3/0xf3
> [   67.405075]  ? __rcu_read_unlock+0x58/0x250
> [   67.405705]  ? out_of_memory.cold+0x2d/0xbb
> [   67.406272]  ? out_of_memory.cold+0x1f/0xbb
> [   67.406910]  out_of_memory.cold+0x45/0xbb
> [   67.407540]  ? oom_killer_disable+0x210/0x210
> [   67.408225]  __alloc_pages_slowpath.constprop.0+0x125f/0x1460
> [   67.409178]  ? warn_alloc+0x120/0x120
> [   67.409849]  ? __alloc_pages_nodemask+0x30f/0x5c0
> [   67.410722]  __alloc_pages_nodemask+0x4fd/0x5c0
> [   67.411533]  ? __alloc_pages_slowpath.constprop.0+0x1460/0x1460
> [   67.412641]  alloc_slab_page+0x2e/0x7a0
> [   67.413345]  ? new_slab+0x22e/0x2b0
> [   67.413883]  new_slab+0x276/0x2b0
> [   67.414534]  ___slab_alloc+0x4ba/0x6d0
> [   67.415221]  ? copy_process+0x256d/0x2f80
> [   67.415930]  ? lock_downgrade+0x360/0x360
> [   67.416659]  ? copy_process+0x256d/0x2f80
> [   67.417390]  ? __slab_alloc.isra.0+0x4b/0x90
> [   67.418171]  __slab_alloc.isra.0+0x4b/0x90
> [   67.418903]  ? copy_process+0x256d/0x2f80
> [   67.419600]  kmem_cache_alloc_node+0xb7/0x330
> [   67.420339]  ? trace_hardirqs_on+0x1e/0x130
> [   67.421078]  copy_process+0x256d/0x2f80
> [   67.421722]  ? mark_lock+0x13f/0xc30
> [   67.422284]  ? find_held_lock+0x85/0xa0
> [   67.422838]  ? __cleanup_sighand+0x60/0x60
> [   67.423515]  _do_fork+0xcf/0x840
> [   67.423978]  ? copy_init_mm+0x20/0x20
> [   67.424496]  ? lockdep_hardirqs_on_prepare+0x14c/0x240
> [   67.425321]  ? _raw_spin_unlock_irq+0x24/0x50
> [   67.426018]  ? trace_hardirqs_on+0x1e/0x130
> [   67.426702]  ? preempt_count_sub+0x14/0xc0
> [   67.427328]  ? lock_acquire+0x133/0x4e0
> [   67.427938]  kernel_thread+0xa8/0xe0
> [   67.428523]  ? legacy_clone_args_valid+0x30/0x30
> [   67.429283]  ? kthread_create_on_node+0xd0/0xd0
> [   67.430026]  ? do_raw_spin_unlock+0xa3/0x130
> [   67.430708]  ? preempt_count_sub+0x14/0xc0
> [   67.431402]  kthreadd+0x2be/0x340
> [   67.431958]  ? kthread_create_on_cpu+0x120/0x120
> [   67.432726]  ? lockdep_hardirqs_on_prepare+0x14c/0x240
> [   67.433575]  ? _raw_spin_unlock_irq+0x24/0x50
> [   67.434288]  ? trace_hardirqs_on+0x1e/0x130
> [   67.434976]  ? kthread_create_on_cpu+0x120/0x120
> [   67.435746]  ret_from_fork+0x1f/0x30
> [   67.436548] Kernel Offset: disabled
>=20

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXxGGTQAKCRA6cBh0uS2t
rJI5AQCW949kV5SdkQLIF2YYCjZA/gU7FEesWqQSL5a5J2ak9wD/Qpb7DBSmLcE0
hrLYsPnFWnz6FjRxmBbeQ8Mulbum1QU=
=SSXM
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--

