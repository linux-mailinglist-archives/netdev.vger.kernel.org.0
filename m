Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE19C586614
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 10:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiHAIOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 04:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiHAIOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 04:14:14 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E800031230
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 01:14:13 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id y9so7475489qtv.5
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 01:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=6XGg6JP3KOGpuRLDpHqMry1pPebE7W8BpsfNwD3Hd4Q=;
        b=SQdAMQltmwjJJMC+PjDbZE4PYt3XHPOQGFS5IFWY+yAkLI4GCtJag1Da3yegKkT2Vc
         VvaXxGncyq66JC6iOwMROlD8hXSnsxX1dPWS6i/xCpYR2ERjtWwMKYXTKY8/xqhnR1p3
         RbCvFi3RfuOGHBQ9N/jiIjqdkdVL8qsLV559f1elxVBExpY3eBt2e/QrX06JLhp7AfJ/
         hH1oZa2X/3P5TesMK+D21HACnocX01cbKYb+q5i6i8XOD78SuGqgtEjenzqOUhT8OWCp
         U/ReYUuj9XYHpHMBojsDKh8Npwqpat+B+roufOHpYnCTZydobFfrzQegCOo9X5cUCMu/
         UHOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=6XGg6JP3KOGpuRLDpHqMry1pPebE7W8BpsfNwD3Hd4Q=;
        b=0zTr4sYdJnswReaRZuQKzqgRArYj7CrVEm3Hmom4XNXqzsYtFof9z+9YWLF8dDo31D
         W+cn+Qw6Q3rtols/Ypvg9oa/b+RClFQ5lhfm19Exw12jaq+nvbOr8xRhBtNXSalbgoTp
         +CCnO6FC2T/hx3Vy/Tf0LI7Zfp3CQIQSTXfkbMvbm9VcPyQJGpNRKMniIXWYcMxbNDKO
         XYZ3fiDZfjdik9OSCr8kejA0CX47N9dskuWwiJjZ6Y3nFHCyEWPzoU0/4lFxreJHqAOT
         Z1poDixNYInHg1wV5B19SZqolAGbyeD7DMcMH32db3Kx5oefhbS5S5Ov85HC2JzvElt0
         uLQA==
X-Gm-Message-State: AJIora/kHdt9AqLCFXndu2yZRSSoPJVoJWO2dTY3U37szmeqhPNcapTe
        B602Kzgb+ToUkyQ3c8w/fFFANgVyf3p/Gg==
X-Google-Smtp-Source: AGRyM1vAQw4NXs3Mp0KEtKHdjCfvQhkLQSYEEiYmsf1DI8bWH7OAMyhSAwHDmE2ZUVz68EBVlQYzWg==
X-Received: by 2002:ac8:5a86:0:b0:31e:d114:1964 with SMTP id c6-20020ac85a86000000b0031ed1141964mr12860469qtc.572.1659341652991;
        Mon, 01 Aug 2022 01:14:12 -0700 (PDT)
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com. [209.85.128.174])
        by smtp.gmail.com with ESMTPSA id bv21-20020a05622a0a1500b0031eb3af3ffesm6567634qtb.52.2022.08.01.01.14.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Aug 2022 01:14:12 -0700 (PDT)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-324293f1414so66678797b3.0
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 01:14:12 -0700 (PDT)
X-Received: by 2002:a0d:c184:0:b0:324:d917:78ac with SMTP id
 c126-20020a0dc184000000b00324d91778acmr3800226ywd.468.1659341651830; Mon, 01
 Aug 2022 01:14:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220729190307.667b4be0@kernel.org> <20220801045736.20674-1-cbulinaru@gmail.com>
In-Reply-To: <20220801045736.20674-1-cbulinaru@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 1 Aug 2022 10:13:35 +0200
X-Gmail-Original-Message-ID: <CA+FuTSfNLfLCxV8NNsJKSQynvBCa2_b7YqqPPXr=2gDhXnGiYA@mail.gmail.com>
Message-ID: <CA+FuTSfNLfLCxV8NNsJKSQynvBCa2_b7YqqPPXr=2gDhXnGiYA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] Fixes: 924a9bc362a5 ("net: check if protocol
 extracted by virtio_net_hdr_set_proto is correct")
To:     Cezar Bulinaru <cbulinaru@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 1, 2022 at 6:57 AM Cezar Bulinaru <cbulinaru@gmail.com> wrote:
>
> Fixes a NULL pointer derefence bug triggered from tap driver.
> When tap_get_user calls virtio_net_hdr_to_skb the skb->dev is null
> (in tap.c skb->dev is set after the call to virtio_net_hdr_to_skb)
> virtio_net_hdr_to_skb calls dev_parse_header_protocol which
> needs skb->dev field to be valid.
>
> The line that trigers the bug is in dev_parse_header_protocol
> (dev is at offset 0x10 from skb and is stored in RAX register)
>   if (!dev->header_ops || !dev->header_ops->parse_protocol)
>   22e1:   mov    0x10(%rbx),%rax
>   22e5:   mov    0x230(%rax),%rax
>
> Setting skb->dev before the call in tap.c fixes the issue.
>
> BUG: kernel NULL pointer dereference, address: 0000000000000230
> RIP: 0010:virtio_net_hdr_to_skb.constprop.0+0x335/0x410 [tap]
> Code: c0 0f 85 b7 fd ff ff eb d4 41 39 c6 77 cf 29 c6 48 89 df 44 01 f6 e8 7a 79 83 c1 48 85 c0 0f 85 d9 fd ff ff eb b7 48 8b 43 10 <48> 8b 80 30 02 00 00 48 85 c0 74 55 48 8b 40 28 48 85 c0 74 4c 48
> RSP: 0018:ffffc90005c27c38 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff888298f25300 RCX: 0000000000000010
> RDX: 0000000000000005 RSI: ffffc90005c27cb6 RDI: ffff888298f25300
> RBP: ffffc90005c27c80 R08: 00000000ffffffea R09: 00000000000007e8
> R10: ffff88858ec77458 R11: 0000000000000000 R12: 0000000000000001
> R13: 0000000000000014 R14: ffffc90005c27e08 R15: ffffc90005c27cb6
> FS:  0000000000000000(0000) GS:ffff88858ec40000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000230 CR3: 0000000281408006 CR4: 00000000003706e0
> Call Trace:
>  tap_get_user+0x3f1/0x540 [tap]
>  tap_sendmsg+0x56/0x362 [tap]
>  ? get_tx_bufs+0xc2/0x1e0 [vhost_net]
>  handle_tx_copy+0x114/0x670 [vhost_net]
>  handle_tx+0xb0/0xe0 [vhost_net]
>  handle_tx_kick+0x15/0x20 [vhost_net]
>  vhost_worker+0x7b/0xc0 [vhost]
>  ? vhost_vring_call_reset+0x40/0x40 [vhost]
>  kthread+0xfa/0x120
>  ? kthread_complete_and_exit+0x20/0x20
>  ret_from_fork+0x1f/0x30
>
> Signed-off-by: Cezar Bulinaru <cbulinaru@gmail.com>

There is something wrong with the subject line.

The Fixes tag is still missing too.

Small comments inside, but overall the code looks good to me as is, too.

>
> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> index c3d42062559d..557236d51d01 100644
> --- a/drivers/net/tap.c
> +++ b/drivers/net/tap.c
> @@ -716,10 +716,20 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
>         skb_reset_mac_header(skb);
>         skb->protocol = eth_hdr(skb)->h_proto;
>
> +       rcu_read_lock();
> +       tap = rcu_dereference(q->tap);
> +       if (tap) {
> +               skb->dev = tap->dev;
> +       } else {
> +               kfree_skb(skb);
> +               goto post_send;
> +       }
> +

I would just

  if (!tap) {
          rcu_read_unlock();
          kfree_skb(skb);
          return total_len;
  }

I agree to not change the code beyond the strict bug fix, but slight
aside that it seems weird that this code returns success on this
failure, and that it could use kfree_skb_reason
(SKB_DROP_REASON_DEV_READY?).

>         if (vnet_hdr_len) {
>                 err = virtio_net_hdr_to_skb(skb, &vnet_hdr,
>                                             tap_is_little_endian(q));
>                 if (err) {
> +                       rcu_read_unlock();
>                         drop_reason = SKB_DROP_REASON_DEV_HDR;
>                         goto err_kfree;
>                 }
> @@ -732,8 +742,6 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
>             __vlan_get_protocol(skb, skb->protocol, &depth) != 0)
>                 skb_set_network_header(skb, depth);
>
> -       rcu_read_lock();
> -       tap = rcu_dereference(q->tap);
>         /* copy skb_ubuf_info for callback when skb has no error */
>         if (zerocopy) {
>                 skb_zcopy_init(skb, msg_control);
> @@ -742,12 +750,9 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
>                 uarg->callback(NULL, uarg, false);
>         }
>
> -       if (tap) {
> -               skb->dev = tap->dev;
> -               dev_queue_xmit(skb);
> -       } else {
> -               kfree_skb(skb);
> -       }
> +       dev_queue_xmit(skb);
> +
> +post_send:
>         rcu_read_unlock();
>
>         return total_len;
> --
> 2.34.1
>
