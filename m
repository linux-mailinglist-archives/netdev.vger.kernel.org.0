Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E7E51A27C
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 16:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347412AbiEDOsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 10:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234113AbiEDOsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 10:48:45 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6011260E
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 07:45:09 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id x12so1326089pgj.7
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 07:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gLmm7WrQQvHEopn8Cp3z/7xPKtL6rSznsyFvNBOvNls=;
        b=eh8bgv1qeUtNq3LOS7Ml/+b8RBKOyaOGHAOC37VembdEKCpvFeHVfvujcy4GEd1SYH
         ufckQ8xB76B/qqdR4XV2IzWuhx1tcVYv1QypkaeWtaY9aceQLm3IaaIf4oC3MziVzr4S
         NtHALIN0HDMcAWZziokdg/LZKZ4lOlxtvLUysM9mEH/b1KQxlg28HycD/0R6Gp5bcE1+
         7lVLzk8N3Yubo8Y1RZxSrWP344MLdokIy+oIr4D9Yddr9SfRvK7mnFvagvien+v623EA
         hK0YxvBLzNYuNeFMjGuEFc4ji1idJehMZkjutqvrL1lViR1hQ+R8nBWLeK97/j7hb7w6
         B7PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gLmm7WrQQvHEopn8Cp3z/7xPKtL6rSznsyFvNBOvNls=;
        b=QbN+5WrYK3MfE/jWiVgeoBHj+7FKbE224WSxb+XgryfSxuUw9Gbp2nAKnuOS+Sk548
         XH5asVm9VXGfNNwJGaPFkxfkdpgTona5UPu7f3B3oQ4Wb7c8KjnLo9NWH30rB/cLksCN
         4jjg37eOJ3vfCaBoNDrhW3g4DePZo0lcBelJTk1Mw9SvYIUM6qOYrL7EfD5B1kKDGJqc
         Rbj7O42AQCmHT9npUSGwiWjhoLJ+4wJ4hZolsH/LK1xV7lIlxQGvLqxp5RiJ5BwZYSp5
         fYfvmNEdMy1jOusVwGc5Dz5xFrYcPpFWQdS8yEik+CmPgCWatQArDrrFx2/9TLuEU4Ee
         5AHg==
X-Gm-Message-State: AOAM533wcq72PZ+94cTCrLA884c/7KiNdz6oTI5xl5mcAnnjz0AYYb04
        xsxQ4Xyfs5akpa1cXF5v3u+9l/nzUTiMUzNimPT7cg==
X-Google-Smtp-Source: ABdhPJz6Q7j1DrphmUyco+KTdiKnpxp7VKbw0Uin7Kx+Ig92gdkYVIqdX2VF4CLb2EGhebFslb/nc+BPy3tTg2MmifM=
X-Received: by 2002:a63:f4e:0:b0:382:1e31:79e8 with SMTP id
 14-20020a630f4e000000b003821e3179e8mr18436065pgp.167.1651675508773; Wed, 04
 May 2022 07:45:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220504142006.3804-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20220504142006.3804-1-m.chetan.kumar@linux.intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 4 May 2022 16:44:32 +0200
Message-ID: <CAMZdPi9DB09dsjuFt-d6U5-NdVsoZ3NqDbmegLyCndRU9G9gJQ@mail.gmail.com>
Subject: Re: [PATCH] net: wwan: fix port open
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        linuxwwan@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chetan,

On Wed, 4 May 2022 at 16:09, M Chetan Kumar
<m.chetan.kumar@linux.intel.com> wrote:
>
> Wwan device registered port can be opened as many number of times.
> The first port open() call binds dev file to driver wwan port device
> and subsequent open() call references to same wwan port instance.
>
> When dev file is opened multiple times, all contexts still refers to
> same instance of wwan port. So in tx path, the received data will be
> fwd to wwan device but in rx path the wwan port has a single rx queue.
> Depending on which context goes for early read() the rx data gets
> dispatched to it.
>
> Since the wwan port is not handling dispatching of rx data to right
> context restrict wwan port open to single context.

The reason for this behavior comes from:
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2313348.html

Especially:
---
"I told you before, do not try to keep a device node from being opened
multiple times, as it will always fail (think about passing file
handles around between programs...) If userspace wants to do this, it
will do it.  If your driver can't handle that, that's fine, userspace
will learn not to do that. But the kernel can not prevent this from
happening."
---

So maybe a user-side solution would be more appropriate, /var/lock/ ?

Regards,
Loic


>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> ---
>  drivers/net/wwan/wwan_core.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> index b8c7843730ed..9ca2d8d76587 100644
> --- a/drivers/net/wwan/wwan_core.c
> +++ b/drivers/net/wwan/wwan_core.c
> @@ -33,6 +33,7 @@ static struct dentry *wwan_debugfs_dir;
>
>  /* WWAN port flags */
>  #define WWAN_PORT_TX_OFF       0
> +#define WWAN_PORT_OPEN         1
>
>  /**
>   * struct wwan_device - The structure that defines a WWAN device
> @@ -58,7 +59,6 @@ struct wwan_device {
>  /**
>   * struct wwan_port - The structure that defines a WWAN port
>   * @type: Port type
> - * @start_count: Port start counter
>   * @flags: Store port state and capabilities
>   * @ops: Pointer to WWAN port operations
>   * @ops_lock: Protect port ops
> @@ -70,7 +70,6 @@ struct wwan_device {
>   */
>  struct wwan_port {
>         enum wwan_port_type type;
> -       unsigned int start_count;
>         unsigned long flags;
>         const struct wwan_port_ops *ops;
>         struct mutex ops_lock; /* Serialize ops + protect against removal */
> @@ -496,7 +495,7 @@ void wwan_remove_port(struct wwan_port *port)
>         struct wwan_device *wwandev = to_wwan_dev(port->dev.parent);
>
>         mutex_lock(&port->ops_lock);
> -       if (port->start_count)
> +       if (test_and_clear_bit(WWAN_PORT_OPEN, &port->flags))
>                 port->ops->stop(port);
>         port->ops = NULL; /* Prevent any new port operations (e.g. from fops) */
>         mutex_unlock(&port->ops_lock);
> @@ -549,11 +548,14 @@ static int wwan_port_op_start(struct wwan_port *port)
>         }
>
>         /* If port is already started, don't start again */
> -       if (!port->start_count)
> -               ret = port->ops->start(port);
> +       if (test_bit(WWAN_PORT_OPEN, &port->flags)) {
> +               ret = -EBUSY;
> +               goto out_unlock;
> +       }
> +       ret = port->ops->start(port);
>
>         if (!ret)
> -               port->start_count++;
> +               set_bit(WWAN_PORT_OPEN, &port->flags);
>
>  out_unlock:
>         mutex_unlock(&port->ops_lock);
> @@ -564,8 +566,7 @@ static int wwan_port_op_start(struct wwan_port *port)
>  static void wwan_port_op_stop(struct wwan_port *port)
>  {
>         mutex_lock(&port->ops_lock);
> -       port->start_count--;
> -       if (!port->start_count) {
> +       if (test_and_clear_bit(WWAN_PORT_OPEN, &port->flags)) {
>                 if (port->ops)
>                         port->ops->stop(port);
>                 skb_queue_purge(&port->rxq);
> --
> 2.25.1
>
