Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8C02D449D
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733054AbgLIOoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLIOoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 09:44:34 -0500
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC42C0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 06:43:53 -0800 (PST)
Received: by mail-vk1-xa42.google.com with SMTP id v3so387123vkb.1
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 06:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7Q6KcYtQg5u1UB7CZSEvhSXseIPsOcn669yzRvM9CMI=;
        b=MlNvVPUG7US7xBW3iVErIuZr+AX7nU82hgF0ulmmxukBGxZ+1aH8RSAISrlziE8ohP
         3rHT2hclrFaH7fVYUBoXUOstwt+bc9QYX3X8ALTg6X5lBTkgBf8WxhMvrd08q9pIuE2E
         ROIhSWl9U3bbWNiEFECJDGApOqjDZgiCLU6BhfPfQaHVd+/ludibgxNig9Ga2clSkxLL
         XDF2E73bcHhgNStuIvVz04fkXa+eJsA1t64j3S3SVLso9HivnYtXI7dqrH6syofZZiOK
         cueIh3qC39Qd2tHI+caBJ6vq9g2IuSR9SalaG0NVyUu4JBRCWQ6SMFlpXefbPZ+E680/
         e2LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7Q6KcYtQg5u1UB7CZSEvhSXseIPsOcn669yzRvM9CMI=;
        b=o6yd6q4q6eC3O4m/Ia8VD/Xb7hbEspRFM0J3Iu2qsarTZRoOx5281ETjW+sn7pd++o
         NzL0J3EUNewLVW48r/inJ/9l9bysdzs27pX+kt9waFIPfRQpVq1UEa0Pr2rIaYTC7RPI
         51xIaJo3kfLXJpxDl5URXMU36fWtjh6P4T06MiijltEbyuj0OBFNK+K01PWRC+o1ncWK
         uqQLlFxGJg3cGl/kLfgoqRD9O/fUtRwNFJ3AcDxTkQ3Kw3Y2P8DX7JIk+69kKtdqqOr0
         p+DLzW6JeUHZQf2BxF9g72IZQUm2N1DQaXmRR09+ci9LzT9dW3IR428LLgOI2MrHmE1/
         ndDQ==
X-Gm-Message-State: AOAM531pL0yRytYX5SyPt5d/TVwik82XwWIaum3j3PTdo4aAlPrIjr0X
        jw6CIPImWfY0C/nmSziwtYaPNmkCsqM=
X-Google-Smtp-Source: ABdhPJyWmUOvmsW4NKorY7bxmi8w0Y8IeBvyIB0PUxF/sEZE/0Y3OtJRM17/GLM1ajdYqYjxicILAA==
X-Received: by 2002:a1f:4595:: with SMTP id s143mr2155420vka.6.1607525032132;
        Wed, 09 Dec 2020 06:43:52 -0800 (PST)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com. [209.85.222.50])
        by smtp.gmail.com with ESMTPSA id r126sm189061vsr.0.2020.12.09.06.43.50
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 06:43:51 -0800 (PST)
Received: by mail-ua1-f50.google.com with SMTP id 17so210129uaq.4
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 06:43:50 -0800 (PST)
X-Received: by 2002:a9f:2356:: with SMTP id 80mr1832051uae.92.1607525030374;
 Wed, 09 Dec 2020 06:43:50 -0800 (PST)
MIME-Version: 1.0
References: <1606982459-41752-1-git-send-email-wangyunjian@huawei.com> <1607517703-18472-1-git-send-email-wangyunjian@huawei.com>
In-Reply-To: <1607517703-18472-1-git-send-email-wangyunjian@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 9 Dec 2020 09:43:13 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfQoDr0jd76xBXSvchhyihQaL2UQXeCR6frJ7hyXxbmVA@mail.gmail.com>
Message-ID: <CA+FuTSfQoDr0jd76xBXSvchhyihQaL2UQXeCR6frJ7hyXxbmVA@mail.gmail.com>
Subject: Re: [PATCH net v2] tun: fix ubuf refcount incorrectly on error path
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        jerry.lilijun@huawei.com, chenchanghu@huawei.com,
        xudingke@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 8:03 AM wangyunjian <wangyunjian@huawei.com> wrote:
>
> From: Yunjian Wang <wangyunjian@huawei.com>
>
> After setting callback for ubuf_info of skb, the callback
> (vhost_net_zerocopy_callback) will be called to decrease
> the refcount when freeing skb. But when an exception occurs

With exception, you mean if tun_get_user returns an error that
propagates to the sendmsg call in vhost handle_tx, correct?

> afterwards, the error handling in vhost handle_tx() will
> try to decrease the same refcount again. This is wrong and
> fix this by delay copying ubuf_info until we're sure
> there's no errors.

I think the right approach is to address this in the error paths,
rather than complicate the normal datapath.

Is it sufficient to suppress the call to vhost_net_ubuf_put in the
handle_tx sendmsg error path, given that vhost_zerocopy_callback
will be called on kfree_skb?

Or alternatively clear the destructor in drop:

>
> Fixes: 4477138fa0ae ("tun: properly test for IFF_UP")
> Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
>
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
> v2:
>    Updated code, fix by delay copying ubuf_info
> ---
>  drivers/net/tun.c | 29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 2dc1988a8973..2ea822328e73 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1637,6 +1637,20 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
>         return NULL;
>  }
>
> +/* copy ubuf_info for callback when skb has no error */
> +static inline void tun_copy_ubuf_info(struct sk_buff *skb, bool zerocopy, void *msg_control)
> +{
> +       if (zerocopy) {
> +               skb_shinfo(skb)->destructor_arg = msg_control;
> +               skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
> +               skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
> +       } else if (msg_control) {
> +               struct ubuf_info *uarg = msg_control;
> +
> +               uarg->callback(uarg, false);
> +       }
> +}
> +
>  /* Get packet from user space buffer */
>  static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>                             void *msg_control, struct iov_iter *from,
> @@ -1812,16 +1826,6 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>                 break;
>         }
>
> -       /* copy skb_ubuf_info for callback when skb has no error */
> -       if (zerocopy) {
> -               skb_shinfo(skb)->destructor_arg = msg_control;
> -               skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
> -               skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
> -       } else if (msg_control) {
> -               struct ubuf_info *uarg = msg_control;
> -               uarg->callback(uarg, false);
> -       }
> -
>         skb_reset_network_header(skb);
>         skb_probe_transport_header(skb);
>         skb_record_rx_queue(skb, tfile->queue_index);
> @@ -1830,6 +1834,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>                 struct bpf_prog *xdp_prog;
>                 int ret;
>
> +               tun_copy_ubuf_info(skb, zerocopy, msg_control);
>                 local_bh_disable();
>                 rcu_read_lock();
>                 xdp_prog = rcu_dereference(tun->xdp_prog);
> @@ -1881,6 +1886,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>                         return -ENOMEM;
>                 }
>
> +               tun_copy_ubuf_info(skb, zerocopy, msg_control);
>                 local_bh_disable();
>                 napi_gro_frags(&tfile->napi);
>                 local_bh_enable();
> @@ -1889,6 +1895,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>                 struct sk_buff_head *queue = &tfile->sk.sk_write_queue;
>                 int queue_len;
>
> +               tun_copy_ubuf_info(skb, zerocopy, msg_control);
>                 spin_lock_bh(&queue->lock);
>                 __skb_queue_tail(queue, skb);
>                 queue_len = skb_queue_len(queue);
> @@ -1899,8 +1906,10 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>
>                 local_bh_enable();
>         } else if (!IS_ENABLED(CONFIG_4KSTACKS)) {
> +               tun_copy_ubuf_info(skb, zerocopy, msg_control);
>                 tun_rx_batched(tun, tfile, skb, more);
>         } else {
> +               tun_copy_ubuf_info(skb, zerocopy, msg_control);
>                 netif_rx_ni(skb);
>         }
>         rcu_read_unlock();
> --
> 2.23.0
>
