Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1292353BF22
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 21:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236206AbiFBTus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 15:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238981AbiFBTuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 15:50:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B92BF220F3
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 12:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654199396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KFAu8V+mmKk34LNH3ZRSMeAaGMAJlRV4pJIBIYKG/qo=;
        b=GGiT8fRQFc5mbl8K4n0hO9a5VZXn8LGwhaO1EkS4fkn+ph9fijwP5977gtqeYJnrVKzI8W
        3xuN9adrbyfb0g1y5NXVPTGpW+dtTgU/wp2AZ22+aSpwhQQAvNvEBmShVD2ob1AD/EFwmI
        M0Q30Ud6OUhYwrtmELqLTUOnLMZtA34=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-A8zi4DC-MVKDdr0f41nVvA-1; Thu, 02 Jun 2022 15:49:55 -0400
X-MC-Unique: A8zi4DC-MVKDdr0f41nVvA-1
Received: by mail-wm1-f72.google.com with SMTP id o3-20020a05600c4fc300b003946a9764baso5630552wmq.1
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 12:49:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KFAu8V+mmKk34LNH3ZRSMeAaGMAJlRV4pJIBIYKG/qo=;
        b=3/NaaGZAbitH9KYnNO7sCt802oFr1+vA/Xblq/QnTWMsq+6QTBKIkDtqpmiyB5g/tx
         koIpJt8tADUVVD+mpNWJmcHWx1VznkWisAlTs78QGpm04M+jzaQ3h3a9eZgX/3MI+YKc
         NcSiMf05tmOXEaN9gxgCUf1rmxtblZsSuVBq/9p6b9X0faGAo3QT+cn9+vMSoCWJCmQs
         Z/xEXwX4WVw17P8oWL3wtu2uhr4PNxsHzxvPgPjNf5kJM4p90no6aA24wG0fH1X+ZcK4
         rJDrSf7wUL2Fg59Y6WMDLefRu6peYcxe5CHJhz8dA5oaB9CNMcx3HdmiIdgtN8yBIo7Y
         ri7g==
X-Gm-Message-State: AOAM531mEhGCvoyTKEVe9je2aEKjYwr4RFs0LtgbP6apUt0JNtrorHba
        bU2MLEbyT+zOTHBqRFjMORq5xfJg8Zgm4qf3r5YUo0KU4SHv6GoAYCl0S3ClquRniCm5rjEsWg6
        7iUSOdM/HMBBqU2rJ
X-Received: by 2002:a5d:4c49:0:b0:210:353c:1c91 with SMTP id n9-20020a5d4c49000000b00210353c1c91mr5117018wrt.159.1654199394234;
        Thu, 02 Jun 2022 12:49:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDdV1Mn2ENQzCBfnn34X0NIwZPawsVz1nTT94jSHJMvq5I7DUFVC8BsTb4t8pWFh5ErMgvUA==
X-Received: by 2002:a5d:4c49:0:b0:210:353c:1c91 with SMTP id n9-20020a5d4c49000000b00210353c1c91mr5117006wrt.159.1654199393949;
        Thu, 02 Jun 2022 12:49:53 -0700 (PDT)
Received: from redhat.com ([2.55.40.171])
        by smtp.gmail.com with ESMTPSA id p33-20020a05600c1da100b003942a244ebesm6484974wms.3.2022.06.02.12.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 12:49:53 -0700 (PDT)
Date:   Thu, 2 Jun 2022 15:49:49 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCH v2 net 3/3] net/af_packet: make sure to pull mac header
Message-ID: <20220602154941-mutt-send-email-mst@kernel.org>
References: <20220602161859.2546399-1-eric.dumazet@gmail.com>
 <20220602161859.2546399-4-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602161859.2546399-4-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 02, 2022 at 09:18:59AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> GSO assumes skb->head contains link layer headers.
> 
> tun device in some case can provide base 14 bytes,
> regardless of VLAN being used or not.
> 
> After blamed commit, we can end up setting a network
> header offset of 18+, we better pull the missing
> bytes to avoid a posible crash in GSO.
> 
> syzbot report was:
> kernel BUG at include/linux/skbuff.h:2699!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 3601 Comm: syz-executor210 Not tainted 5.18.0-syzkaller-11338-g2c5ca23f7414 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:__skb_pull include/linux/skbuff.h:2699 [inline]
> RIP: 0010:skb_mac_gso_segment+0x48f/0x530 net/core/gro.c:136
> Code: 00 48 c7 c7 00 96 d4 8a c6 05 cb d3 45 06 01 e8 26 bb d0 01 e9 2f fd ff ff 49 c7 c4 ea ff ff ff e9 f1 fe ff ff e8 91 84 19 fa <0f> 0b 48 89 df e8 97 44 66 fa e9 7f fd ff ff e8 ad 44 66 fa e9 48
> RSP: 0018:ffffc90002e2f4b8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000012 RCX: 0000000000000000
> RDX: ffff88805bb58000 RSI: ffffffff8760ed0f RDI: 0000000000000004
> RBP: 0000000000005dbc R08: 0000000000000004 R09: 0000000000000fe0
> R10: 0000000000000fe4 R11: 0000000000000000 R12: 0000000000000fe0
> R13: ffff88807194d780 R14: 1ffff920005c5e9b R15: 0000000000000012
> FS:  000055555730f300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000200015c0 CR3: 0000000071ff8000 CR4: 0000000000350ee0
> Call Trace:
>  <TASK>
>  __skb_gso_segment+0x327/0x6e0 net/core/dev.c:3411
>  skb_gso_segment include/linux/netdevice.h:4749 [inline]
>  validate_xmit_skb+0x6bc/0xf10 net/core/dev.c:3669
>  validate_xmit_skb_list+0xbc/0x120 net/core/dev.c:3719
>  sch_direct_xmit+0x3d1/0xbe0 net/sched/sch_generic.c:327
>  __dev_xmit_skb net/core/dev.c:3815 [inline]
>  __dev_queue_xmit+0x14a1/0x3a00 net/core/dev.c:4219
>  packet_snd net/packet/af_packet.c:3071 [inline]
>  packet_sendmsg+0x21cb/0x5550 net/packet/af_packet.c:3102
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:734
>  ____sys_sendmsg+0x6eb/0x810 net/socket.c:2492
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2546
>  __sys_sendmsg net/socket.c:2575 [inline]
>  __do_sys_sendmsg net/socket.c:2584 [inline]
>  __se_sys_sendmsg net/socket.c:2582 [inline]
>  __x64_sys_sendmsg+0x132/0x220 net/socket.c:2582
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> RIP: 0033:0x7f4b95da06c9
> Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd7defc4c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007ffd7defc4f0 RCX: 00007f4b95da06c9
> RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
> RBP: 0000000000000003 R08: bb1414ac00000050 R09: bb1414ac00000050
> R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffd7defc4e0 R14: 00007ffd7defc4d8 R15: 00007ffd7defc4d4
>  </TASK>
> 
> Fixes: dfed913e8b55 ("net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Acked-by: Hangbin Liu <liuhangbin@gmail.com>
> Acked-by: Willem de Bruijn <willemb@google.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  net/packet/af_packet.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 677f9cfa9660816a160a11bfa4c291431412005f..ca6e92a229239f9093900bf9249396cf0d410104 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -1935,8 +1935,10 @@ static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
>  	/* Move network header to the right position for VLAN tagged packets */
>  	if (likely(skb->dev->type == ARPHRD_ETHER) &&
>  	    eth_type_vlan(skb->protocol) &&
> -	    __vlan_get_protocol(skb, skb->protocol, &depth) != 0)
> -		skb_set_network_header(skb, depth);
> +	    __vlan_get_protocol(skb, skb->protocol, &depth) != 0) {
> +		if (pskb_may_pull(skb, depth))
> +			skb_set_network_header(skb, depth);
> +	}
>  
>  	skb_probe_transport_header(skb);
>  }
> -- 
> 2.36.1.255.ge46751e96f-goog

