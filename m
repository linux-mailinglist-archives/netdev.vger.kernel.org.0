Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21DE650E264
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 15:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240171AbiDYNze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 09:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237131AbiDYNza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 09:55:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED1CA606FC
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 06:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650894744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jqbyoLD0QYZj8tJ/bx8Pb2e1MwmtWdkXBxeX0ToHtEo=;
        b=LZM/EO5YrpQHXCu1+48WP1DFj+MkHQQqFVVXE2EmXEjZaldr5zMvHHrcPRNxxvYQyT3k+A
        VroNo+ww4GdKMQfseGzJAIDx1t5RrTJuBlR6GDDECZfYdNcMzvaFPRqhrLlfGtOfvLLurp
        yjhPwNfvuXIQ6B439y5Xy91RFSf/Tyg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-36-uJsaseY6OTm_QzEoGEHXKQ-1; Mon, 25 Apr 2022 09:52:19 -0400
X-MC-Unique: uJsaseY6OTm_QzEoGEHXKQ-1
Received: by mail-wr1-f72.google.com with SMTP id k20-20020adfc714000000b001e305cd1597so3397198wrg.19
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 06:52:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jqbyoLD0QYZj8tJ/bx8Pb2e1MwmtWdkXBxeX0ToHtEo=;
        b=Sa+QKYP2sWgyhK4Nia7NNEGAoKEWgzWskZ37iKRqxRyYiGTY4kF5p+525sZ2VRZbT3
         hpZxTYQkR1J3bAPzXdV8Rmj9evC2y/Y6YeETrN0BHWuRdYPyxWGI26bgDXy6OtaZxTJ8
         ZZWstUMa/8nCCGVxfTy6yqgAhH2GUgXpyOq4R1VqVDFfNIJXe/pUHjHtWXyL9bIC16eW
         SySZjnYGSR4TGEJjJmdkKsHMgabHsT+1yIbYvQ//VbEJ6VcO/pqy3/Ayad0IHdCh+IRE
         eehbTNGk470jycIRiK1+YSo4RdE4uz44DB/0OBfXw34JiyKqOlCB0OfB3PtQ5JFLKcXY
         PP3A==
X-Gm-Message-State: AOAM531x3qjhp7uZIF8RYShXVK5PDTsgKoLTf95C19cSKJxH+RSor9qa
        6PiHqTBGkLatpYnOXhXSCP9I2Gshja/fhk8PB4ABd9IBYedOsRtKMGlOtmmiOAdCcPnmbWSzKda
        vM5pmQ29htM9Mxo30
X-Received: by 2002:a5d:6448:0:b0:20a:d70e:cc9 with SMTP id d8-20020a5d6448000000b0020ad70e0cc9mr7346238wrw.184.1650894737368;
        Mon, 25 Apr 2022 06:52:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvFtiuIAPYCaVD2N4ESEJEYEwyN78tnPHv++SehaY9j1u9QAwUsTJU7p1ncVY70Kpx2Yefag==
X-Received: by 2002:a5d:6448:0:b0:20a:d70e:cc9 with SMTP id d8-20020a5d6448000000b0020ad70e0cc9mr7346216wrw.184.1650894737090;
        Mon, 25 Apr 2022 06:52:17 -0700 (PDT)
Received: from redhat.com ([2.53.22.137])
        by smtp.gmail.com with ESMTPSA id az30-20020a05600c601e00b0038ebd950caesm8834133wmb.30.2022.04.25.06.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 06:52:16 -0700 (PDT)
Date:   Mon, 25 Apr 2022 09:52:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net v3] virtio_net: fix wrong buf address calculation
 when using xdp
Message-ID: <20220425094526-mutt-send-email-mst@kernel.org>
References: <20220425103703.3067292-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425103703.3067292-1-razor@blackwall.org>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 01:37:03PM +0300, Nikolay Aleksandrov wrote:
> We received a report[1] of kernel crashes when Cilium is used in XDP
> mode with virtio_net after updating to newer kernels. After
> investigating the reason it turned out that when using mergeable bufs
> with an XDP program which adjusts xdp.data or xdp.data_meta page_to_buf()
> calculates the build_skb address wrong because the offset can become less
> than the headroom so it gets the address of the previous page (-X bytes
> depending on how lower offset is):
>  page_to_skb: page addr ffff9eb2923e2000 buf ffff9eb2923e1ffc offset 252 headroom 256
> 
> This is a pr_err() I added in the beginning of page_to_skb which clearly
> shows offset that is less than headroom by adding 4 bytes of metadata
> via an xdp prog. The calculations done are:
>  receive_mergeable():
>  headroom = VIRTIO_XDP_HEADROOM; // VIRTIO_XDP_HEADROOM == 256 bytes
>  offset = xdp.data - page_address(xdp_page) -
>           vi->hdr_len - metasize;
> 
>  page_to_skb():
>  p = page_address(page) + offset;
>  ...
>  buf = p - headroom;
> 
> Now buf goes -4 bytes from the page's starting address as can be seen
> above which is set as skb->head and skb->data by build_skb later. Depending
> on what's done with the skb (when it's freed most often) we get all kinds
> of corruptions and BUG_ON() triggers in mm[2]. We have to recalculate
> the new headroom after the xdp program has run, similar to how offset
> and len are recalculated. Headroom is directly related to
> data_hard_start, data and data_meta, so we use them to get the new size.
> The result is correct (similar pr_err() in page_to_skb, one case of
> xdp_page and one case of virtnet buf):
>  a) Case with 4 bytes of metadata
>  [  115.949641] page_to_skb: page addr ffff8b4dcfad2000 offset 252 headroom 252
>  [  121.084105] page_to_skb: page addr ffff8b4dcf018000 offset 20732 headroom 252
>  b) Case of pushing data +32 bytes
>  [  153.181401] page_to_skb: page addr ffff8b4dd0c4d000 offset 288 headroom 288
>  [  158.480421] page_to_skb: page addr ffff8b4dd00b0000 offset 24864 headroom 288
>  c) Case of pushing data -33 bytes
>  [  835.906830] page_to_skb: page addr ffff8b4dd3270000 offset 223 headroom 223
>  [  840.839910] page_to_skb: page addr ffff8b4dcdd68000 offset 12511 headroom 223
> 
> Offset and headroom are equal because offset points to the start of
> reserved bytes for the virtio_net header which are at buf start +
> headroom, while data points at buf start + vnet hdr size + headroom so
> when data or data_meta are adjusted by the xdp prog both the headroom size
> and the offset change equally. We can use data_hard_start to compute the
> new headroom after the xdp prog (linearized / page start case, the
> virtnet buf case is similar just with bigger base offset):
>  xdp.data_hard_start = page_address + vnet_hdr
>  xdp.data = page_address + vnet_hdr + headroom
>  new headroom after xdp prog = xdp.data - xdp.data_hard_start - metasize
> 
> An example reproducer xdp prog[3] is below.
> 
> [1] https://github.com/cilium/cilium/issues/19453
> 
> [2] Two of the many traces:
>  [   40.437400] BUG: Bad page state in process swapper/0  pfn:14940
>  [   40.916726] BUG: Bad page state in process systemd-resolve  pfn:053b7
>  [   41.300891] kernel BUG at include/linux/mm.h:720!
>  [   41.301801] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
>  [   41.302784] CPU: 1 PID: 1181 Comm: kubelet Kdump: loaded Tainted: G    B   W         5.18.0-rc1+ #37
>  [   41.304458] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1.fc35 04/01/2014
>  [   41.306018] RIP: 0010:page_frag_free+0x79/0xe0
>  [   41.306836] Code: 00 00 75 ea 48 8b 07 a9 00 00 01 00 74 e0 48 8b 47 48 48 8d 50 ff a8 01 48 0f 45 fa eb d0 48 c7 c6 18 b8 30 a6 e8 d7 f8 fc ff <0f> 0b 48 8d 78 ff eb bc 48 8b 07 a9 00 00 01 00 74 3a 66 90 0f b6
>  [   41.310235] RSP: 0018:ffffac05c2a6bc78 EFLAGS: 00010292
>  [   41.311201] RAX: 000000000000003e RBX: 0000000000000000 RCX: 0000000000000000
>  [   41.312502] RDX: 0000000000000001 RSI: ffffffffa6423004 RDI: 00000000ffffffff
>  [   41.313794] RBP: ffff993c98823600 R08: 0000000000000000 R09: 00000000ffffdfff
>  [   41.315089] R10: ffffac05c2a6ba68 R11: ffffffffa698ca28 R12: ffff993c98823600
>  [   41.316398] R13: ffff993c86311ebc R14: 0000000000000000 R15: 000000000000005c
>  [   41.317700] FS:  00007fe13fc56740(0000) GS:ffff993cdd900000(0000) knlGS:0000000000000000
>  [   41.319150] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  [   41.320152] CR2: 000000c00008a000 CR3: 0000000014908000 CR4: 0000000000350ee0
>  [   41.321387] Call Trace:
>  [   41.321819]  <TASK>
>  [   41.322193]  skb_release_data+0x13f/0x1c0
>  [   41.322902]  __kfree_skb+0x20/0x30
>  [   41.343870]  tcp_recvmsg_locked+0x671/0x880
>  [   41.363764]  tcp_recvmsg+0x5e/0x1c0
>  [   41.384102]  inet_recvmsg+0x42/0x100
>  [   41.406783]  ? sock_recvmsg+0x1d/0x70
>  [   41.428201]  sock_read_iter+0x84/0xd0
>  [   41.445592]  ? 0xffffffffa3000000
>  [   41.462442]  new_sync_read+0x148/0x160
>  [   41.479314]  ? 0xffffffffa3000000
>  [   41.496937]  vfs_read+0x138/0x190
>  [   41.517198]  ksys_read+0x87/0xc0
>  [   41.535336]  do_syscall_64+0x3b/0x90
>  [   41.551637]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>  [   41.568050] RIP: 0033:0x48765b
>  [   41.583955] Code: e8 4a 35 fe ff eb 88 cc cc cc cc cc cc cc cc e8 fb 7a fe ff 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 28 ff ff ff ff 48 c7 44 24 30
>  [   41.632818] RSP: 002b:000000c000a2f5b8 EFLAGS: 00000212 ORIG_RAX: 0000000000000000
>  [   41.664588] RAX: ffffffffffffffda RBX: 000000c000062000 RCX: 000000000048765b
>  [   41.681205] RDX: 0000000000005e54 RSI: 000000c000e66000 RDI: 0000000000000016
>  [   41.697164] RBP: 000000c000a2f608 R08: 0000000000000001 R09: 00000000000001b4
>  [   41.713034] R10: 00000000000000b6 R11: 0000000000000212 R12: 00000000000000e9
>  [   41.728755] R13: 0000000000000001 R14: 000000c000a92000 R15: ffffffffffffffff
>  [   41.744254]  </TASK>
>  [   41.758585] Modules linked in: br_netfilter bridge veth netconsole virtio_net
> 
>  and
> 
>  [   33.524802] BUG: Bad page state in process systemd-network  pfn:11e60
>  [   33.528617] page ffffe05dc0147b00 ffffe05dc04e7a00 ffff8ae9851ec000 (1) len 82 offset 252 metasize 4 hroom 0 hdr_len 12 data ffff8ae9851ec10c data_meta ffff8ae9851ec108 data_end ffff8ae9851ec14e
>  [   33.529764] page:000000003792b5ba refcount:0 mapcount:-512 mapping:0000000000000000 index:0x0 pfn:0x11e60
>  [   33.532463] flags: 0xfffffc0000000(node=0|zone=1|lastcpupid=0x1fffff)
>  [   33.532468] raw: 000fffffc0000000 0000000000000000 dead000000000122 0000000000000000
>  [   33.532470] raw: 0000000000000000 0000000000000000 00000000fffffdff 0000000000000000
>  [   33.532471] page dumped because: nonzero mapcount
>  [   33.532472] Modules linked in: br_netfilter bridge veth netconsole virtio_net
>  [   33.532479] CPU: 0 PID: 791 Comm: systemd-network Kdump: loaded Not tainted 5.18.0-rc1+ #37
>  [   33.532482] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1.fc35 04/01/2014
>  [   33.532484] Call Trace:
>  [   33.532496]  <TASK>
>  [   33.532500]  dump_stack_lvl+0x45/0x5a
>  [   33.532506]  bad_page.cold+0x63/0x94
>  [   33.532510]  free_pcp_prepare+0x290/0x420
>  [   33.532515]  free_unref_page+0x1b/0x100
>  [   33.532518]  skb_release_data+0x13f/0x1c0
>  [   33.532524]  kfree_skb_reason+0x3e/0xc0
>  [   33.532527]  ip6_mc_input+0x23c/0x2b0
>  [   33.532531]  ip6_sublist_rcv_finish+0x83/0x90
>  [   33.532534]  ip6_sublist_rcv+0x22b/0x2b0
> 
> [3] XDP program to reproduce(xdp_pass.c):
>  #include <linux/bpf.h>
>  #include <bpf/bpf_helpers.h>
> 
>  SEC("xdp_pass")
>  int xdp_pkt_pass(struct xdp_md *ctx)
>  {
>           bpf_xdp_adjust_head(ctx, -(int)32);
>           return XDP_PASS;
>  }
> 
>  char _license[] SEC("license") = "GPL";
> 
>  compile: clang -O2 -g -Wall -target bpf -c xdp_pass.c -o xdp_pass.o
>  load on virtio_net: ip link set enp1s0 xdpdrv obj xdp_pass.o sec xdp_pass
> 
> CC: stable@vger.kernel.org
> CC: Jason Wang <jasowang@redhat.com>
> CC: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> CC: Daniel Borkmann <daniel@iogearbox.net>
> CC: "Michael S. Tsirkin" <mst@redhat.com>
> CC: virtualization@lists.linux-foundation.org
> Fixes: 8fb7da9e9907 ("virtio_net: get build_skb() buf by data ptr")
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>

Acked-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> v3: Add a comment explaining why offset and headroom are equal,
>     no code changes
> v2: Recalculate headroom based on data, data_hard_start and data_meta
> 
>  drivers/net/virtio_net.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 87838cbe38cf..cbba9d2e8f32 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1005,6 +1005,24 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  			 * xdp.data_meta were adjusted
>  			 */
>  			len = xdp.data_end - xdp.data + vi->hdr_len + metasize;
> +
> +			/* recalculate headroom if xdp.data or xdp_data_meta
> +			 * were adjusted, note that offset should always point
> +			 * to the start of the reserved bytes for virtio_net
> +			 * header which are followed by xdp.data, that means
> +			 * that offset is equal to the headroom (when buf is
> +			 * starting at the beginning of the page, otherwise
> +			 * there is a base offset inside the page) but it's used
> +			 * with a different starting point (buf start) than
> +			 * xdp.data (buf start + vnet hdr size). If xdp.data or
> +			 * data_meta were adjusted by the xdp prog then the
> +			 * headroom size has changed and so has the offset, we
> +			 * can use data_hard_start, which points at buf start +
> +			 * vnet hdr size, to calculate the new headroom and use
> +			 * it later to compute buf start in page_to_skb()
> +			 */
> +			headroom = xdp.data - xdp.data_hard_start - metasize;
> +
>  			/* We can only create skb based on xdp_page. */
>  			if (unlikely(xdp_page != page)) {
>  				rcu_read_unlock();
> @@ -1012,7 +1030,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  				head_skb = page_to_skb(vi, rq, xdp_page, offset,
>  						       len, PAGE_SIZE, false,
>  						       metasize,
> -						       VIRTIO_XDP_HEADROOM);
> +						       headroom);
>  				return head_skb;
>  			}
>  			break;
> -- 
> 2.35.1

