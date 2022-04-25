Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C0A50ECFE
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 01:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238894AbiDYX5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 19:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238742AbiDYX5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 19:57:07 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE31B11054E;
        Mon, 25 Apr 2022 16:53:55 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id t12so2792942vkt.5;
        Mon, 25 Apr 2022 16:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pFdf3CGk1xed0dOzWyIPZUPWtNLb0GuzgkXN6n4q9lw=;
        b=SvrttGjYctWvTyMWoR0SmS80lc+Y70tEvrBKCDN09SiLoaMKwkW1dKuQJYui2xopnS
         tURECsj9P01ul8u5awK6NDp9UDi6Dz6G6C7rLiNhgM6YILpkYbbiOWOt1V57HdEdC3zG
         F/xOaGrKc+AgDOWf1eRq4UjwV+uKjYtsUXpRJh4klITyTQfyw3zdAXuFzNz28Jm0aoOe
         OPS+npyA6N0w1VzLVYr66e03re+gb4bF3nwaoXccDNl7drhi8/udaI43LWadvI9pRvYN
         G2nF7bBxsDLoHn67uQa5eGNGYnbCieRMFzPSRGVXc6wYP6LdIrxtiPOt+5W6axzmrJGf
         IVFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pFdf3CGk1xed0dOzWyIPZUPWtNLb0GuzgkXN6n4q9lw=;
        b=u9A0E8Tyv6SzjlYRazmb5ddFIUuhTwTWEqET5hvD0RoWi9gUD8VS1zWSb5MdHEL9/q
         BqKF0pOAaXc/0ZywQB1xCvxoiZm9gQZhjlKF7bGpTjQCYZvnj1n2gj4YtpAydJCIBVng
         tTPodB+O17MJjp//nvIejF/h9pX3RucaviTQ+8o/0Zg9Ye6L0D0++CfYt+smfKv+zMaD
         auzi96e+dRkWER+jue/Hd1+jTNW9Q3Sq9wgMMbjaSd2SybKB+dCCIqmhtkAX/iPnRp4c
         rFQ+t0u7URuV7AyZco9vpj/r4hwISfBokIC8oI/wpn/GlViyrS40dD78+7wVmN6r+xmq
         gXug==
X-Gm-Message-State: AOAM530nngj8JlHqyoBQmH9wUcb8Uou+oeJ4Rc0WmHatJLVgmV/nzrd9
        jFqMDJ5aw1vbT6Laavh7gL5nRRWQlATdmdbNGH61NitWQTZU+g==
X-Google-Smtp-Source: ABdhPJyKzPZcLME/QtycIfvIdTssLSz+rphDOJTYPcidZoc0PBEK+bDvGCixUJO/7XbXpK1Yx6d2pxEdXJf5wDvMVxU=
X-Received: by 2002:a1f:e2c7:0:b0:34d:310f:6b0 with SMTP id
 z190-20020a1fe2c7000000b0034d310f06b0mr3633861vkg.19.1650930834997; Mon, 25
 Apr 2022 16:53:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-5-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220407223629.21487-5-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 26 Apr 2022 02:53:54 +0300
Message-ID: <CAHNKnsQWThUnMnk6ruGek9cuDKOAcPa18nA7-CgLf58=iEgE0g@mail.gmail.com>
Subject: Re: [PATCH net-next v6 04/13] net: wwan: t7xx: Add port proxy infrastructure
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        ilpo.johannes.jarvinen@intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        madhusmita.sahu@intel.com
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

On Fri, Apr 8, 2022 at 1:37 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> Port-proxy provides a common interface to interact with different types
> of ports. Ports export their configuration via `struct t7xx_port` and
> operate as defined by `struct port_ops`.
>
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>
> From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c

[skipped]

> +static struct t7xx_port_conf t7xx_md_port_conf[] = {};

Please spell this definition in two lines (i.e. move closing brace
into next line):

+static struct t7xx_port_conf t7xx_md_port_conf[] = {
+};

Such spelling in this patch will help you avoid editing the line when
you add the first entry in the next (control port introducing) patch:

-static struct t7xx_port_conf t7xx_md_port_conf[] = {};
+static struct t7xx_port_conf t7xx_md_port_conf[] = {
+       {
+               ...
+               .name = "t7xx_ctrl",
+       },
+};

It will become as simple as:

 static struct t7xx_port_conf t7xx_md_port_conf[] = {
+       {
+               ...
+               .name = "t7xx_ctrl",
+       },
 };

BTW, if the t7xx_md_port_conf contents are not expected to change at
run-time, should this array, as well as all pointers to it, be const?

[skipped]

> +int t7xx_port_enqueue_skb(struct t7xx_port *port, struct sk_buff *skb)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&port->rx_wq.lock, flags);
> +       if (port->rx_skb_list.qlen >= port->rx_length_th) {
> +               spin_unlock_irqrestore(&port->rx_wq.lock, flags);

Probably skb should be freed here before returning. The caller assumes
that skb will be consumed even in case of error.

> +               return -ENOBUFS;
> +       }
> +       __skb_queue_tail(&port->rx_skb_list, skb);
> +       spin_unlock_irqrestore(&port->rx_wq.lock, flags);
> +
> +       wake_up_all(&port->rx_wq);
> +       return 0;
> +}

[skipped]

> +static int t7xx_port_proxy_recv_skb(struct cldma_queue *queue, struct sk_buff *skb)
> +{
> +       struct ccci_header *ccci_h = (struct ccci_header *)skb->data;
> +       struct t7xx_pci_dev *t7xx_dev = queue->md_ctrl->t7xx_dev;
> +       struct t7xx_fsm_ctl *ctl = t7xx_dev->md->fsm_ctl;
> +       struct device *dev = queue->md_ctrl->dev;
> +       struct t7xx_port_conf *port_conf;
> +       struct t7xx_port *port;
> +       u16 seq_num, channel;
> +       int ret;
> +
> +       if (!skb)
> +               return -EINVAL;
> +
> +       channel = FIELD_GET(CCCI_H_CHN_FLD, le32_to_cpu(ccci_h->status));
> +       if (t7xx_fsm_get_md_state(ctl) == MD_STATE_INVALID) {
> +               dev_err_ratelimited(dev, "Packet drop on channel 0x%x, modem not ready\n", channel);
> +               goto drop_skb;
> +       }
> +
> +       port = t7xx_port_proxy_find_port(t7xx_dev, queue, channel);
> +       if (!port) {
> +               dev_err_ratelimited(dev, "Packet drop on channel 0x%x, port not found\n", channel);
> +               goto drop_skb;
> +       }
> +
> +       seq_num = t7xx_port_next_rx_seq_num(port, ccci_h);
> +       port_conf = port->port_conf;
> +       skb_pull(skb, sizeof(*ccci_h));
> +
> +       ret = port_conf->ops->recv_skb(port, skb);
> +       if (ret) {
> +               skb_push(skb, sizeof(*ccci_h));

Header can not be pushed back here, since the .recv_skb() callback
consumes (frees) skb even in case of error. See
t7xx_port_wwan_recv_skb() and my comment in t7xx_port_enqueue_skb().
Pushing the header back after failure will trigger the use-after-free
error.

> +               return ret;
> +       }
> +
> +       port->seq_nums[MTK_RX] = seq_num;

The expected sequence number updated only on successful .recv_skb()
exit. This will trigger the out-of-order seqno warning on a next
message after a .recv_skb() failure. Is this intentional behaviour?

Maybe the expected sequence number should be updated before the
.recv_skb() call? Or even the sequence number update should be moved
to t7xx_port_next_rx_seq_num()?

> +       return 0;
> +
> +drop_skb:
> +       dev_kfree_skb_any(skb);
> +       return 0;
> +}

--
Sergey
