Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA7B621012
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 13:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbiKHMPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 07:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiKHMO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 07:14:59 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3B743AE8
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 04:14:54 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id h9so20719543wrt.0
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 04:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TZuTIOZ8Gv4dVWB/8F4/5+uC+7kwLd9y8EfwkapJcZk=;
        b=C7CIbG+BW7UItXkJzrcTZyjyAKUyP1JSUcmC7veiAojYLbJyTfHGQBfHOMsCQErO3I
         fdrNVHN5wl2gJJUF1AckmGVf4ztPulxY57IDcIrAQvf3+WPjO4tMZzeOjWAefdYy4YJ3
         3eqVnMpBnaNxxCadIMY56eIypeQLPP7V0t2X9LhAcMBC7gY73g92d5s9N8nXkd89VTo1
         Ewcy44yttg0Qf6ueNx/as2uxInFigyLqhzoVeplFPt2B3PDa3ms6OfzH7p4W3mNADmyo
         gW+vFwrmAjDruGM96vLO5YZ0d9eaEgHgtP04wkTCraaK1lWeOz7u+OZPo8+uN+cjmUCE
         Qi4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TZuTIOZ8Gv4dVWB/8F4/5+uC+7kwLd9y8EfwkapJcZk=;
        b=IzHdWcqIphiMad5fQq6wEtrAzb0iJWiDtrHXcStPGMZoz7Lk1PBJ6Nae+uCr+x8nbf
         +sVvgsttVhzdXWuChdN6N5NP3VFYMb0FwpBTgCNgjSc0rG+XEMYKjaBmjunzJVS17NOC
         fjMOmN5n49v4CujGedxS4tCSJ/j1SfFFjaQD7zIbYzZRuCy67swpfaUKrwckirImhrRU
         aKUGfpHaKBYqUxdMvjFjpiKUS83A+Z9Oi0eHfYKPuj3zF3LO8op/Cn9fK/h1kCFZuyud
         8yP0hqsI0IhrgKrAUUbo94k6GRuw0eGisxk7vC50GAGUVG5gXMgHWSZkkiQjKNKCJFxb
         14YQ==
X-Gm-Message-State: ACrzQf2jSWprsmbQLHBGNBMWWoZyIsjxUVQlj5E+YaMkmKUlktRjPoxT
        KrOHq0nqdwvI9wBo6OFh/3b9aKjyS+asjrrFduxm9w==
X-Google-Smtp-Source: AMsMyM4vzo0Xg7iLJ3jIF2mCz34gL5mhxplRFcSNZyDszD3FHzPmBmqNaIlIDOa31OFMPOE+i4f5Dxw0XMVSInsPz4A=
X-Received: by 2002:adf:d1c2:0:b0:236:9033:8ead with SMTP id
 b2-20020adfd1c2000000b0023690338eadmr36354480wrd.653.1667909693288; Tue, 08
 Nov 2022 04:14:53 -0800 (PST)
MIME-Version: 1.0
References: <20221108105352.89801-1-haozhe.chang@mediatek.com>
In-Reply-To: <20221108105352.89801-1-haozhe.chang@mediatek.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 8 Nov 2022 13:14:16 +0100
Message-ID: <CAMZdPi96dZV0J_6U-mH5eCquWycSQLPvoz6JX1BHWn0eQJyeDA@mail.gmail.com>
Subject: Re: [PATCH v2] wwan: core: Support slicing in port TX flow of WWAN subsystem
To:     haozhe.chang@mediatek.com
Cc:     Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@linux.intel.com>,
        Liu Haijun <haijun.liu@mediatek.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "open list:MEDIATEK T7XX 5G WWAN MODEM DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, lambert.wang@mediatek.com,
        xiayu.zhang@mediatek.com, hua.yang@mediatek.com,
        srv_heupstream@mediatek.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Haozhe,

On Tue, 8 Nov 2022 at 11:54, <haozhe.chang@mediatek.com> wrote:
>
> From: haozhe chang <haozhe.chang@mediatek.com>
>
> wwan_port_fops_write inputs the SKB parameter to the TX callback of
> the WWAN device driver. However, the WWAN device (e.g., t7xx) may
> have an MTU less than the size of SKB, causing the TX buffer to be
> sliced and copied once more in the WWAN device driver.
>
> This patch implements the slicing in the WWAN subsystem and gives
> the WWAN devices driver the option to slice(by chunk) or not. By
> doing so, the additional memory copy is reduced.
>
> Meanwhile, this patch gives WWAN devices driver the option to reserve
> headroom in SKB for the device-specific metadata.
>
> Signed-off-by: haozhe chang <haozhe.chang@mediatek.com>
>
> ---
> Changes in v2
>   -send fragments to device driver by skb frag_list.
> ---
>  drivers/net/wwan/t7xx/t7xx_port_wwan.c | 42 ++++++++++-------
>  drivers/net/wwan/wwan_core.c           | 65 ++++++++++++++++++++------
>  include/linux/wwan.h                   |  5 +-
>  3 files changed, 80 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/net/wwan/t7xx/t7xx_port_wwan.c b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
> index 33931bfd78fd..74fa58575d5a 100644
> --- a/drivers/net/wwan/t7xx/t7xx_port_wwan.c
> +++ b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
> @@ -54,13 +54,13 @@ static void t7xx_port_ctrl_stop(struct wwan_port *port)
[...]
>  static const struct wwan_port_ops wwan_ops = {
>         .start = t7xx_port_ctrl_start,
>         .stop = t7xx_port_ctrl_stop,
>         .tx = t7xx_port_ctrl_tx,
> +       .needed_headroom = t7xx_port_tx_headroom,
> +       .tx_chunk_len = t7xx_port_tx_chunk_len,

Can you replace 'chunk' with 'frag' everywhere?

>  };
>
>  static int t7xx_port_wwan_init(struct t7xx_port *port)
> diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> index 62e9f7d6c9fe..ed78471f9e38 100644
> --- a/drivers/net/wwan/wwan_core.c
> +++ b/drivers/net/wwan/wwan_core.c
> @@ -20,7 +20,7 @@
>  #include <uapi/linux/wwan.h>
>
>  /* Maximum number of minors in use */
> -#define WWAN_MAX_MINORS                (1 << MINORBITS)
> +#define WWAN_MAX_MINORS                BIT(MINORBITS)
>
>  static DEFINE_MUTEX(wwan_register_lock); /* WWAN device create|remove lock */
>  static DEFINE_IDA(minors); /* minors for WWAN port chardevs */
> @@ -67,6 +67,8 @@ struct wwan_device {
>   * @rxq: Buffer inbound queue
>   * @waitqueue: The waitqueue for port fops (read/write/poll)
>   * @data_lock: Port specific data access serialization
> + * @headroom_len: SKB reserved headroom size
> + * @chunk_len: Chunk len to split packet
>   * @at_data: AT port specific data
>   */
>  struct wwan_port {
> @@ -79,6 +81,8 @@ struct wwan_port {
>         struct sk_buff_head rxq;
>         wait_queue_head_t waitqueue;
>         struct mutex data_lock; /* Port specific data access serialization */
> +       size_t headroom_len;
> +       size_t chunk_len;
>         union {
>                 struct {
>                         struct ktermios termios;
> @@ -550,8 +554,13 @@ static int wwan_port_op_start(struct wwan_port *port)
>         }
>
>         /* If port is already started, don't start again */
> -       if (!port->start_count)
> +       if (!port->start_count) {
>                 ret = port->ops->start(port);
> +               if (port->ops->tx_chunk_len)
> +                       port->chunk_len = port->ops->tx_chunk_len(port);

So, maybe frag len and headroom should be parameters of
wwan_create_port() instead of port ops, as we really need this info
only once.

> +               if (port->ops->needed_headroom)
> +                       port->headroom_len = port->ops->needed_headroom(port);
> +       }
>
>         if (!ret)
>                 port->start_count++;
> @@ -698,30 +707,56 @@ static ssize_t wwan_port_fops_read(struct file *filp, char __user *buf,
>  static ssize_t wwan_port_fops_write(struct file *filp, const char __user *buf,
>                                     size_t count, loff_t *offp)
>  {
> +       size_t len, chunk_len, offset, allowed_chunk_len;
> +       struct sk_buff *skb, *head = NULL, *tail = NULL;
>         struct wwan_port *port = filp->private_data;
> -       struct sk_buff *skb;
>         int ret;
>
>         ret = wwan_wait_tx(port, !!(filp->f_flags & O_NONBLOCK));
>         if (ret)
>                 return ret;
>
> -       skb = alloc_skb(count, GFP_KERNEL);
> -       if (!skb)
> -               return -ENOMEM;
> +       allowed_chunk_len = port->chunk_len ? port->chunk_len : count;

I would suggest making port->chunk_len (frag_len) always valid, by
setting it to -1 (MAX size_t) when creating a port without frag_len
requirement.

> +       for (offset = 0; offset < count; offset += chunk_len) {
> +               chunk_len = min(count - offset, allowed_chunk_len);
> +               len = chunk_len + port->headroom_len;
> +               skb = alloc_skb(len, GFP_KERNEL);

That works but would prefer a simpler solution like:
do {
    len = min(port->frag_len, remain);
    skb = alloc_skb(len + port->needed_headroom; GFP_KERNEL);
    [...]
    copy_from_user(skb_put(skb, len), buf + count - remain)
} while ((remain -= len));

> +               if (!skb) {
> +                       ret = -ENOMEM;
> +                       goto freeskb;
> +               }
> +               skb_reserve(skb, port->headroom_len);
> +
> +               if (!head) {
> +                       head = skb;
> +               } else if (!tail) {
> +                       skb_shinfo(head)->frag_list = skb;
> +                       tail = skb;
> +               } else {
> +                       tail->next = skb;
> +                       tail = skb;
> +               }
>
> -       if (copy_from_user(skb_put(skb, count), buf, count)) {
> -               kfree_skb(skb);
> -               return -EFAULT;
> -       }
> +               if (copy_from_user(skb_put(skb, chunk_len), buf + offset, chunk_len)) {
> +                       ret = -EFAULT;
> +                       goto freeskb;
> +               }
>
> -       ret = wwan_port_op_tx(port, skb, !!(filp->f_flags & O_NONBLOCK));
> -       if (ret) {
> -               kfree_skb(skb);
> -               return ret;
> +               if (skb != head) {
> +                       head->data_len += skb->len;
> +                       head->len += skb->len;
> +                       head->truesize += skb->truesize;
> +               }
>         }
>
> -       return count;
> +       if (head) {

How head can be null here?

> +               ret = wwan_port_op_tx(port, head, !!(filp->f_flags & O_NONBLOCK));
> +               if (!ret)
> +                       return count;
> +       }
> +freeskb:
> +       kfree_skb(head);
> +       return ret;
>  }
>
>  static __poll_t wwan_port_fops_poll(struct file *filp, poll_table *wait)
> diff --git a/include/linux/wwan.h b/include/linux/wwan.h
> index 5ce2acf444fb..bdeeef59bbfd 100644
> --- a/include/linux/wwan.h
> +++ b/include/linux/wwan.h
> @@ -46,6 +46,8 @@ struct wwan_port;
>   * @tx: Non-blocking routine that sends WWAN port protocol data to the device.
>   * @tx_blocking: Optional blocking routine that sends WWAN port protocol data
>   *               to the device.
> + * @needed_headroom: Optional routine that sets reserve headroom of skb.
> + * @tx_chunk_len: Optional routine that sets chunk len to split.
>   * @tx_poll: Optional routine that sets additional TX poll flags.
>   *
>   * The wwan_port_ops structure contains a list of low-level operations
> @@ -58,6 +60,8 @@ struct wwan_port_ops {
>
>         /* Optional operations */
>         int (*tx_blocking)(struct wwan_port *port, struct sk_buff *skb);
> +       size_t (*needed_headroom)(struct wwan_port *port);
> +       size_t (*tx_chunk_len)(struct wwan_port *port);

As said above, maybe move that as variables, or parameter of wwan_create_port.

Regards,
Loic
