Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69080396F9E
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 10:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbhFAIzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 04:55:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52490 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233208AbhFAIzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 04:55:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622537632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8WAcJsQSiURJqUup6/vHXemO9q3LwnkDENXrRbvbWL8=;
        b=OI/0Q7l7boKA3iDOU00R2nweF/MXseFrkrQLGqOP8N9+O5iOQKbAkfr027wWkiI3n/+jgW
        45mqv7OHKCfopMstckS2X133lWjykIi07EVnoDVWMvfqOqbT2j37ePW9q4QJWfMTpCm0zE
        ZDoMbqWOCDBFyH2h6lrqANCS5FH/iRo=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-9d_g9Z-EMPmXxdQjObqZEQ-1; Tue, 01 Jun 2021 04:53:51 -0400
X-MC-Unique: 9d_g9Z-EMPmXxdQjObqZEQ-1
Received: by mail-pl1-f199.google.com with SMTP id d10-20020a170902cecab02900f342ad66bdso4203529plg.4
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 01:53:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=8WAcJsQSiURJqUup6/vHXemO9q3LwnkDENXrRbvbWL8=;
        b=OPQwrnMn/qcWpHtkq/SAqBnv+qEUu56hWATRLlMJeK/vA/sqxGLtC2YJm54ECa9CW7
         inaecb+l1QbZrKbL4B953btm8Kw6W8tqv5QAEz2vVwx1AgAZCo6YzWq1c/+7YkKoAWGM
         GxbLsKZ78rzPzHtzGtmFi4/mFyY7YUlq4n4FfXdJ69R+i7A/5PUNkkKrcYmusOIgaKiC
         116V+OAKMbvkp6U+S/b/OXiJShqSuTjy+R2/MZ5cW1M35uimQkYF6lCOJTN8hEzhxQ0q
         prv3/DodB0Pbo3bQhISj0KpEgi9pBTlDUmXVFp9vSv5IG1GAfMVVq+qdO9DGfQtObX0s
         BOOQ==
X-Gm-Message-State: AOAM530x85L9SAKbP2h4vAG6Ck5yBFQk7m3ak8K1nioYbZ2jy6i1CkAd
        HuZWK6Gzigg8RPsdDnoeFvqa3zN/1kDWZxU+wAaW8ix/Dt6gcW7kfnE5Zlqyuv405AP6ASBNlB3
        9iTu30ejFf7ilPv+b
X-Received: by 2002:a17:90a:b28d:: with SMTP id c13mr3860044pjr.80.1622537629591;
        Tue, 01 Jun 2021 01:53:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyVptUOSWsBZH9dICAaOjVBWfDa1kss0dK9yR27Sqmu8qKHzL6FHx0nXJZWYhsiYmSFNmpt0g==
X-Received: by 2002:a17:90a:b28d:: with SMTP id c13mr3860024pjr.80.1622537629393;
        Tue, 01 Jun 2021 01:53:49 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 11sm12590666pfh.182.2021.06.01.01.53.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 01:53:48 -0700 (PDT)
Subject: Re: [PATCH net v2 1/2] virtio-net: fix for unable to handle page
 fault for address
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
References: <20210601064000.66909-1-xuanzhuo@linux.alibaba.com>
 <20210601064000.66909-2-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e7b3a4b8-9f5c-1f17-9e7d-ab38bb193919@redhat.com>
Date:   Tue, 1 Jun 2021 16:53:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210601064000.66909-2-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/1 ÏÂÎç2:39, Xuan Zhuo Ð´µÀ:
> In merge mode, when xdp is enabled, if the headroom of buf is smaller
> than virtnet_get_headroom(), xdp_linearize_page() will be called but the
> variable of "headroom" is still 0, which leads to wrong logic after
> entering page_to_skb().
>
> [   16.600944] BUG: unable to handle page fault for address: ffffecbfff7b43c8[   16.602175] #PF: supervisor read access in kernel mode
> [   16.603350] #PF: error_code(0x0000) - not-present page
> [   16.604200] PGD 0 P4D 0
> [   16.604686] Oops: 0000 [#1] SMP PTI
> [   16.605306] CPU: 4 PID: 715 Comm: sh Tainted: G    B             5.12.0+ #312
> [   16.606429] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/04
> [   16.608217] RIP: 0010:unmap_page_range+0x947/0xde0
> [   16.609014] Code: 00 00 08 00 48 83 f8 01 45 19 e4 41 f7 d4 41 83 e4 03 e9 a4 fd ff ff e8 b7 63 ed ff 4c 89 e0 48 c1 e0 065
> [   16.611863] RSP: 0018:ffffc90002503c58 EFLAGS: 00010286
> [   16.612720] RAX: ffffecbfff7b43c0 RBX: 00007f19f7203000 RCX: ffffffff812ff359
> [   16.613853] RDX: ffff888107778000 RSI: 0000000000000000 RDI: 0000000000000005
> [   16.614976] RBP: ffffea000425e000 R08: 0000000000000000 R09: 3030303030303030
> [   16.616124] R10: ffffffff82ed7d94 R11: 6637303030302052 R12: 7c00000afffded0f
> [   16.617276] R13: 0000000000000001 R14: ffff888119ee7010 R15: 00007f19f7202000
> [   16.618423] FS:  0000000000000000(0000) GS:ffff88842fd00000(0000) knlGS:0000000000000000
> [   16.619738] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   16.620670] CR2: ffffecbfff7b43c8 CR3: 0000000103220005 CR4: 0000000000370ee0
> [   16.621792] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   16.622920] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   16.624047] Call Trace:
> [   16.624525]  ? release_pages+0x24d/0x730
> [   16.625209]  unmap_single_vma+0xa9/0x130
> [   16.625885]  unmap_vmas+0x76/0xf0
> [   16.626480]  exit_mmap+0xa0/0x210
> [   16.627129]  mmput+0x67/0x180
> [   16.627673]  do_exit+0x3d1/0xf10
> [   16.628259]  ? do_user_addr_fault+0x231/0x840
> [   16.629000]  do_group_exit+0x53/0xd0
> [   16.629631]  __x64_sys_exit_group+0x1d/0x20
> [   16.630354]  do_syscall_64+0x3c/0x80
> [   16.630988]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   16.631828] RIP: 0033:0x7f1a043d0191
> [   16.632464] Code: Unable to access opcode bytes at RIP 0x7f1a043d0167.
> [   16.633502] RSP: 002b:00007ffe3d993308 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> [   16.634737] RAX: ffffffffffffffda RBX: 00007f1a044c9490 RCX: 00007f1a043d0191
> [   16.635857] RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> [   16.636986] RBP: 0000000000000000 R08: ffffffffffffff88 R09: 0000000000000001
> [   16.638120] R10: 0000000000000008 R11: 0000000000000246 R12: 00007f1a044c9490
> [   16.639245] R13: 0000000000000001 R14: 00007f1a044c9968 R15: 0000000000000000
> [   16.640408] Modules linked in:
> [   16.640958] CR2: ffffecbfff7b43c8
> [   16.641557] ---[ end trace bc4891c6ce46354c ]---
> [   16.642335] RIP: 0010:unmap_page_range+0x947/0xde0
> [   16.643135] Code: 00 00 08 00 48 83 f8 01 45 19 e4 41 f7 d4 41 83 e4 03 e9 a4 fd ff ff e8 b7 63 ed ff 4c 89 e0 48 c1 e0 065
> [   16.645983] RSP: 0018:ffffc90002503c58 EFLAGS: 00010286
> [   16.646845] RAX: ffffecbfff7b43c0 RBX: 00007f19f7203000 RCX: ffffffff812ff359
> [   16.647970] RDX: ffff888107778000 RSI: 0000000000000000 RDI: 0000000000000005
> [   16.649091] RBP: ffffea000425e000 R08: 0000000000000000 R09: 3030303030303030
> [   16.650250] R10: ffffffff82ed7d94 R11: 6637303030302052 R12: 7c00000afffded0f
> [   16.651394] R13: 0000000000000001 R14: ffff888119ee7010 R15: 00007f19f7202000
> [   16.652529] FS:  0000000000000000(0000) GS:ffff88842fd00000(0000) knlGS:0000000000000000
> [   16.653887] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   16.654841] CR2: ffffecbfff7b43c8 CR3: 0000000103220005 CR4: 0000000000370ee0
> [   16.655992] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   16.657150] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   16.658290] Kernel panic - not syncing: Fatal exception
> [   16.659613] Kernel Offset: disabled
> [   16.660234] ---[ end Kernel panic - not syncing: Fatal exception ]---
>
> Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/net/virtio_net.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 9b6a4a875c55..6b929aca155a 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -958,7 +958,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   				put_page(page);
>   				head_skb = page_to_skb(vi, rq, xdp_page, offset,
>   						       len, PAGE_SIZE, false,
> -						       metasize, headroom);
> +						       metasize,
> +						       VIRTIO_XDP_HEADROOM);
>   				return head_skb;
>   			}
>   			break;

