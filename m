Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC4EDF6A3
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbfJUUV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:21:29 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44166 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfJUUV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:21:29 -0400
Received: by mail-pg1-f194.google.com with SMTP id e10so8469889pgd.11
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 13:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=+CAm7glUJsOTUc5Pb4S3z3xc/bYjRhOS4eOiBUeqfsE=;
        b=vN35ikRKUJR7aS5qiH43L6fPBMP1MCo4I+wOOZh9ZIU4J3w+Uhny5DksOSzOtFZerd
         oML5QG35/Vf5DAVgKDwiAFMK19kzLZ1ofWEwv0xokPr1krg+r1kKVJfq7sNwrfesGViZ
         P+X3Aykjwr+0qVRDve3t/RwK2VfoLjRnN5fACWjxm0EXJl6Pz/mcn2hYFnpYsFFhBH5T
         c+Bl+TIy3cElFz9+ro43e1ljX7X43LLJ83JtUbNP7rRn8BL+GaQdw/uGQqCH/6MPL0G6
         CR8M5bxLe+pTYSjdb9iXy20ukHW7H/PsfWnNxfoz4r41U8Q3F/U4tJeoYmhw0sE/AUwn
         M6NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+CAm7glUJsOTUc5Pb4S3z3xc/bYjRhOS4eOiBUeqfsE=;
        b=NYdQC4b2a6jCoC0jAlBIWdErevHi9iCv7g3LhOMPvDdEtX5kYMPuW2OaJpAfYuytqc
         4NqTxjoZvYxQ0vktXAHHkKoVd/pAWu/Cuu/holyLbvZp8el2fE5GQCaBBt9Wgbb/arPM
         epqi4qm2U2Fp5wtLegc05Sf0QQrhDbgarQnufpGejrt5UHOlYgb+GoejY6X7W9d5zBmW
         PufyQfdSnXs5s7A6JuTYv1iK/76ZjaIWXO+R5ncb0UT7vGkXGW0Lrnc4zBSvYfJKgFWo
         ssk4XzZwZXt38PP4bz27cGIr54CkmTkBHHeTt+ggKVqC209olmP8b2F4dHMu5YiFh9Ur
         AgUA==
X-Gm-Message-State: APjAAAU91TtaBzHrDVB5CgU0nGizGvHozOIEpy7tLOaaZllD+1r2V/V+
        QcoCNcUpRD0JwyZchwWcuBM=
X-Google-Smtp-Source: APXvYqz0ddaPfsrg/m/ykv4eGjUfYrf3V1Q4ncUal/Pvg8KvJcVDpMB9FMwBKKlUtoa3ZDfs+c8M/A==
X-Received: by 2002:a63:1b41:: with SMTP id b1mr28127075pgm.335.1571689287366;
        Mon, 21 Oct 2019 13:21:27 -0700 (PDT)
Received: from [192.168.0.16] (97-115-93-145.ptld.qwest.net. [97.115.93.145])
        by smtp.gmail.com with ESMTPSA id y20sm13666935pge.48.2019.10.21.13.21.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 13:21:26 -0700 (PDT)
Subject: Re: [PATCH net] net: openvswitch: free vport unless
 register_netdevice() succeeds
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Hillf Danton <hdanton@sina.com>, Taehee Yoo <ap420073@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ying Xue <ying.xue@windriver.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+13210896153522fe1ee5@syzkaller.appspotmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, netdev@vger.kernel.org,
        dev@openvswitch.org
References: <3caa233b136b5104c817a52a5fdc02691e530528.1571651489.git.sbrivio@redhat.com>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <85c687b8-1f33-6330-04b7-6244fa9fd232@gmail.com>
Date:   Mon, 21 Oct 2019 13:21:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <3caa233b136b5104c817a52a5fdc02691e530528.1571651489.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/2019 3:01 AM, Stefano Brivio wrote:
> From: Hillf Danton <hdanton@sina.com>
>
> syzbot found the following crash on:
>
> HEAD commit:    1e78030e Merge tag 'mmc-v5.3-rc1' of git://git.kernel.org/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=148d3d1a600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=30cef20daf3e9977
> dashboard link: https://syzkaller.appspot.com/bug?extid=13210896153522fe1ee5
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=136aa8c4600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=109ba792600000
>
> =====================================================================
> BUG: memory leak
> unreferenced object 0xffff8881207e4100 (size 128):
>     comm "syz-executor032", pid 7014, jiffies 4294944027 (age 13.830s)
>     hex dump (first 32 bytes):
>       00 70 16 18 81 88 ff ff 80 af 8c 22 81 88 ff ff  .p........."....
>       00 b6 23 17 81 88 ff ff 00 00 00 00 00 00 00 00  ..#.............
>     backtrace:
>       [<000000000eb78212>] kmemleak_alloc_recursive  include/linux/kmemleak.h:43 [inline]
>       [<000000000eb78212>] slab_post_alloc_hook mm/slab.h:522 [inline]
>       [<000000000eb78212>] slab_alloc mm/slab.c:3319 [inline]
>       [<000000000eb78212>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
>       [<00000000006ea6c6>] kmalloc include/linux/slab.h:552 [inline]
>       [<00000000006ea6c6>] kzalloc include/linux/slab.h:748 [inline]
>       [<00000000006ea6c6>] ovs_vport_alloc+0x37/0xf0  net/openvswitch/vport.c:130
>       [<00000000f9a04a7d>] internal_dev_create+0x24/0x1d0  net/openvswitch/vport-internal_dev.c:164
>       [<0000000056ee7c13>] ovs_vport_add+0x81/0x190  net/openvswitch/vport.c:199
>       [<000000005434efc7>] new_vport+0x19/0x80 net/openvswitch/datapath.c:194
>       [<00000000b7b253f1>] ovs_dp_cmd_new+0x22f/0x410  net/openvswitch/datapath.c:1614
>       [<00000000e0988518>] genl_family_rcv_msg+0x2ab/0x5b0  net/netlink/genetlink.c:629
>       [<00000000d0cc9347>] genl_rcv_msg+0x54/0x9c net/netlink/genetlink.c:654
>       [<000000006694b647>] netlink_rcv_skb+0x61/0x170  net/netlink/af_netlink.c:2477
>       [<0000000088381f37>] genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
>       [<00000000dad42a47>] netlink_unicast_kernel  net/netlink/af_netlink.c:1302 [inline]
>       [<00000000dad42a47>] netlink_unicast+0x1ec/0x2d0  net/netlink/af_netlink.c:1328
>       [<0000000067e6b079>] netlink_sendmsg+0x270/0x480  net/netlink/af_netlink.c:1917
>       [<00000000aab08a47>] sock_sendmsg_nosec net/socket.c:637 [inline]
>       [<00000000aab08a47>] sock_sendmsg+0x54/0x70 net/socket.c:657
>       [<000000004cb7c11d>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2311
>       [<00000000c4901c63>] __sys_sendmsg+0x80/0xf0 net/socket.c:2356
>       [<00000000c10abb2d>] __do_sys_sendmsg net/socket.c:2365 [inline]
>       [<00000000c10abb2d>] __se_sys_sendmsg net/socket.c:2363 [inline]
>       [<00000000c10abb2d>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2363
>
> BUG: memory leak
> unreferenced object 0xffff88811723b600 (size 64):
>     comm "syz-executor032", pid 7014, jiffies 4294944027 (age 13.830s)
>     hex dump (first 32 bytes):
>       01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
>       00 00 00 00 00 00 00 00 02 00 00 00 05 35 82 c1  .............5..
>     backtrace:
>       [<00000000352f46d8>] kmemleak_alloc_recursive  include/linux/kmemleak.h:43 [inline]
>       [<00000000352f46d8>] slab_post_alloc_hook mm/slab.h:522 [inline]
>       [<00000000352f46d8>] slab_alloc mm/slab.c:3319 [inline]
>       [<00000000352f46d8>] __do_kmalloc mm/slab.c:3653 [inline]
>       [<00000000352f46d8>] __kmalloc+0x169/0x300 mm/slab.c:3664
>       [<000000008e48f3d1>] kmalloc include/linux/slab.h:557 [inline]
>       [<000000008e48f3d1>] ovs_vport_set_upcall_portids+0x54/0xd0  net/openvswitch/vport.c:343
>       [<00000000541e4f4a>] ovs_vport_alloc+0x7f/0xf0  net/openvswitch/vport.c:139
>       [<00000000f9a04a7d>] internal_dev_create+0x24/0x1d0  net/openvswitch/vport-internal_dev.c:164
>       [<0000000056ee7c13>] ovs_vport_add+0x81/0x190  net/openvswitch/vport.c:199
>       [<000000005434efc7>] new_vport+0x19/0x80 net/openvswitch/datapath.c:194
>       [<00000000b7b253f1>] ovs_dp_cmd_new+0x22f/0x410  net/openvswitch/datapath.c:1614
>       [<00000000e0988518>] genl_family_rcv_msg+0x2ab/0x5b0  net/netlink/genetlink.c:629
>       [<00000000d0cc9347>] genl_rcv_msg+0x54/0x9c net/netlink/genetlink.c:654
>       [<000000006694b647>] netlink_rcv_skb+0x61/0x170  net/netlink/af_netlink.c:2477
>       [<0000000088381f37>] genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
>       [<00000000dad42a47>] netlink_unicast_kernel  net/netlink/af_netlink.c:1302 [inline]
>       [<00000000dad42a47>] netlink_unicast+0x1ec/0x2d0  net/netlink/af_netlink.c:1328
>       [<0000000067e6b079>] netlink_sendmsg+0x270/0x480  net/netlink/af_netlink.c:1917
>       [<00000000aab08a47>] sock_sendmsg_nosec net/socket.c:637 [inline]
>       [<00000000aab08a47>] sock_sendmsg+0x54/0x70 net/socket.c:657
>       [<000000004cb7c11d>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2311
>       [<00000000c4901c63>] __sys_sendmsg+0x80/0xf0 net/socket.c:2356
>
> BUG: memory leak
> unreferenced object 0xffff8881228ca500 (size 128):
>     comm "syz-executor032", pid 7015, jiffies 4294944622 (age 7.880s)
>     hex dump (first 32 bytes):
>       00 f0 27 18 81 88 ff ff 80 ac 8c 22 81 88 ff ff  ..'........"....
>       40 b7 23 17 81 88 ff ff 00 00 00 00 00 00 00 00  @.#.............
>     backtrace:
>       [<000000000eb78212>] kmemleak_alloc_recursive  include/linux/kmemleak.h:43 [inline]
>       [<000000000eb78212>] slab_post_alloc_hook mm/slab.h:522 [inline]
>       [<000000000eb78212>] slab_alloc mm/slab.c:3319 [inline]
>       [<000000000eb78212>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
>       [<00000000006ea6c6>] kmalloc include/linux/slab.h:552 [inline]
>       [<00000000006ea6c6>] kzalloc include/linux/slab.h:748 [inline]
>       [<00000000006ea6c6>] ovs_vport_alloc+0x37/0xf0  net/openvswitch/vport.c:130
>       [<00000000f9a04a7d>] internal_dev_create+0x24/0x1d0  net/openvswitch/vport-internal_dev.c:164
>       [<0000000056ee7c13>] ovs_vport_add+0x81/0x190  net/openvswitch/vport.c:199
>       [<000000005434efc7>] new_vport+0x19/0x80 net/openvswitch/datapath.c:194
>       [<00000000b7b253f1>] ovs_dp_cmd_new+0x22f/0x410  net/openvswitch/datapath.c:1614
>       [<00000000e0988518>] genl_family_rcv_msg+0x2ab/0x5b0  net/netlink/genetlink.c:629
>       [<00000000d0cc9347>] genl_rcv_msg+0x54/0x9c net/netlink/genetlink.c:654
>       [<000000006694b647>] netlink_rcv_skb+0x61/0x170  net/netlink/af_netlink.c:2477
>       [<0000000088381f37>] genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
>       [<00000000dad42a47>] netlink_unicast_kernel  net/netlink/af_netlink.c:1302 [inline]
>       [<00000000dad42a47>] netlink_unicast+0x1ec/0x2d0  net/netlink/af_netlink.c:1328
>       [<0000000067e6b079>] netlink_sendmsg+0x270/0x480  net/netlink/af_netlink.c:1917
>       [<00000000aab08a47>] sock_sendmsg_nosec net/socket.c:637 [inline]
>       [<00000000aab08a47>] sock_sendmsg+0x54/0x70 net/socket.c:657
>       [<000000004cb7c11d>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2311
>       [<00000000c4901c63>] __sys_sendmsg+0x80/0xf0 net/socket.c:2356
>       [<00000000c10abb2d>] __do_sys_sendmsg net/socket.c:2365 [inline]
>       [<00000000c10abb2d>] __se_sys_sendmsg net/socket.c:2363 [inline]
>       [<00000000c10abb2d>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2363
> =====================================================================
>
> The function in net core, register_netdevice(), may fail with vport's
> destruction callback either invoked or not. After commit 309b66970ee2,
> the duty to destroy vport is offloaded from the driver OTOH, which ends
> up in the memory leak reported.
>
> It is fixed by releasing vport unless device is registered successfully.
> To do that, the callback assignment is defered until device is registered.
>
> Reported-by: syzbot+13210896153522fe1ee5@syzkaller.appspotmail.com
> Fixes: 309b66970ee2 ("net: openvswitch: do not free vport if register_netdevice() is failed.")
> Cc: Taehee Yoo <ap420073@gmail.com>
> Cc: Greg Rose <gvrose8192@gmail.com>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> Cc: Andrey Konovalov <andreyknvl@google.com>
> Signed-off-by: Hillf Danton <hdanton@sina.com>
> Acked-by: Pravin B Shelar <pshelar@ovn.org>
> [sbrivio: this was sent to dev@openvswitch.org and never made its way
>   to netdev -- resending original patch]
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
> This patch was sent to dev@openvswitch.org and appeared on netdev
> only as Pravin replied to it, giving his Acked-by. I contacted the
> original author one month ago requesting to resend this to netdev,
> but didn't get an answer, so I'm now resending the original patch.
>
>   net/openvswitch/vport-internal_dev.c | 11 ++++-------
>   1 file changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
> index 21c90d3a7ebf..58a7b8312c28 100644
> --- a/net/openvswitch/vport-internal_dev.c
> +++ b/net/openvswitch/vport-internal_dev.c
> @@ -137,7 +137,7 @@ static void do_setup(struct net_device *netdev)
>   	netdev->priv_flags |= IFF_LIVE_ADDR_CHANGE | IFF_OPENVSWITCH |
>   			      IFF_NO_QUEUE;
>   	netdev->needs_free_netdev = true;
> -	netdev->priv_destructor = internal_dev_destructor;
> +	netdev->priv_destructor = NULL;
>   	netdev->ethtool_ops = &internal_dev_ethtool_ops;
>   	netdev->rtnl_link_ops = &internal_dev_link_ops;
>   
> @@ -159,7 +159,6 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
>   	struct internal_dev *internal_dev;
>   	struct net_device *dev;
>   	int err;
> -	bool free_vport = true;
>   
>   	vport = ovs_vport_alloc(0, &ovs_internal_vport_ops, parms);
>   	if (IS_ERR(vport)) {
> @@ -190,10 +189,9 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
>   
>   	rtnl_lock();
>   	err = register_netdevice(vport->dev);
> -	if (err) {
> -		free_vport = false;
> +	if (err)
>   		goto error_unlock;
> -	}
> +	vport->dev->priv_destructor = internal_dev_destructor;
>   
>   	dev_set_promiscuity(vport->dev, 1);
>   	rtnl_unlock();
> @@ -207,8 +205,7 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
>   error_free_netdev:
>   	free_netdev(dev);
>   error_free_vport:
> -	if (free_vport)
> -		ovs_vport_free(vport);
> +	ovs_vport_free(vport);
>   error:
>   	return ERR_PTR(err);
>   }

Thanks Stefano and Hillf.  LGTM

Reviewed-by: Greg Rose <gvrose8192@gmail.com>

