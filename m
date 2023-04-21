Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3C86EA4C3
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbjDUHal convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Apr 2023 03:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbjDUHai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:30:38 -0400
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708FA9038;
        Fri, 21 Apr 2023 00:30:14 -0700 (PDT)
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5208be24dcbso1491337a12.1;
        Fri, 21 Apr 2023 00:30:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682062214; x=1684654214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VZh3EUPiL8uMvBnJGoOPV1vumiXLtvWRBeOfpbBUfbg=;
        b=WA/TRQ+KgZeaDt7R95tahxzaLFSZ364naJ2Mk/nz5tF6sEGPn4Cov3foguH7ULYGUQ
         AfNWXftwgti/8JpCDq8GWUTnbIMp9HCYL8DXUeDwz9XafVHfUjKz6Y0z8bo8oyzr/qEk
         IMv1S33knZt7jK1LZybr8+IkogKG3ZKj++yNBGxG9rpjOE4K8+ikA6CuRi23yVHIo08+
         2lurLAunRd1+cHna5qVPvGiTgSM+Prpiz7ORXpuoK9r9j9P3jDgQHLohZUjxP212EwSP
         5q4ZWjrtygHsOcO65BQMHn8ZxhnWxpmC0LSnUMY7Np8YjQAoRhq1e1+bWv/VsIc3htGC
         mF9Q==
X-Gm-Message-State: AAQBX9es4+hFHVPZb9fh5I6PHf2Fvz19pwypDR9R2ybjFmbjsHNWOEVp
        ORo/JsxFzux+4Z7u25Ma5TR//1G87+KO89fO6mc=
X-Google-Smtp-Source: AKy350bBPGaoneQ8QThjfMAdx8xdpF8qm/KXPcHP+gwDk8358ScfaZ65zOuZrZFlGKwSe+NBuMbR3q2fEa8Vkn3vefA=
X-Received: by 2002:a17:90a:6486:b0:247:abb6:1528 with SMTP id
 h6-20020a17090a648600b00247abb61528mr4013457pjj.2.1682062213441; Fri, 21 Apr
 2023 00:30:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230420024403.13830-1-peter_hong@fintek.com.tw>
 <CAMZ6RqKWrtBMFSD=BzGuCbvj=+3X-A-oW9haJ7=4kyL2AbEuHQ@mail.gmail.com> <51991fc1-0746-608f-b3bb-78b64e6d1a3e@fintek.com.tw>
In-Reply-To: <51991fc1-0746-608f-b3bb-78b64e6d1a3e@fintek.com.tw>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 21 Apr 2023 16:30:02 +0900
Message-ID: <CAMZ6Rq+zsC4F-mNhjKvqgPQuLhnnX1y79J=qOT8szPvkHY86VQ@mail.gmail.com>
Subject: Re: [PATCH V5] can: usb: f81604: add Fintek F81604 support
To:     Peter Hong <peter_hong@fintek.com.tw>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     wg@grandegger.com, mkl@pengutronix.de,
        Steen.Hegelund@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        frank.jungclaus@esd.eu, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        hpeter+linux_kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Peter and Michal,

On Fry. 21 Apr. 2023 at 12:14, Peter Hong <peter_hong@fintek.com.tw> wrote:
>
> Hi Vincent,
>
> Vincent MAILHOL 於 2023/4/20 下午 08:02 寫道:
> > Hi Peter,
> >
> > Here are my comments. Now, it is mostly nitpicks. I guess that this is
> > the final round.
> >
> > On Thu. 20 avr. 2023 at 11:44, Ji-Ze Hong (Peter Hong)
> > <peter_hong@fintek.com.tw> wrote:
> >> +static void f81604_read_bulk_callback(struct urb *urb)
> >> +{
> >> +       struct f81604_can_frame *frame = urb->transfer_buffer;
> >> +       struct net_device *netdev = urb->context;
> >> +       int ret;
> >> +
> >> +       if (!netif_device_present(netdev))
> >> +               return;
> >> +
> >> +       if (urb->status)
> >> +               netdev_info(netdev, "%s: URB aborted %pe\n", __func__,
> >> +                           ERR_PTR(urb->status));
> >> +
> >> +       switch (urb->status) {
> >> +       case 0: /* success */
> >> +               break;
> >> +
> >> +       case -ENOENT:
> >> +       case -EPIPE:
> >> +       case -EPROTO:
> >> +       case -ESHUTDOWN:
> >> +               return;
> >> +
> >> +       default:
> >> +               goto resubmit_urb;
> >> +       }
> >> +
> >> +       if (urb->actual_length != F81604_DATA_SIZE) {
> > It is more readable to use sizeof() instead of a macro.
> >
> >         if (urb->actual_length != sizeof(*frame)) {
> >
> >> +               netdev_warn(netdev, "URB length %u not equal to %u\n",
> >> +                           urb->actual_length, F81604_DATA_SIZE);
> > Idem.
> >
> >> +               goto resubmit_urb;
> >> +       }
> > In v4, actual_length was allowed to be any multiple of
> > F81604_DATA_SIZE and f81604_process_rx_packet() had a loop to iterate
> > through all the messages.
> >
> > Why did this disappear in v5?
>
> I had over design it. The F81604 will only report 1 frame at 1 bulk-in,
> So I change it to
> process 1 frame only.

Ack. That is why it is good to remove the opaque u8* buffer. It helped
to identify that.

> >> +static void f81604_handle_tx(struct f81604_port_priv *priv,
> >> +                            struct f81604_int_data *data)
> >> +{
> >> +       struct net_device *netdev = priv->netdev;
> >> +       struct net_device_stats *stats;
> >> +
> >> +       stats = &netdev->stats;
> > Merge the declaration with the initialization.
>
> If I merge initialization into declaration, it's may violation RCT?
> How could I change about this ?

@Michal: You requested RTC in:

https://lore.kernel.org/linux-can/ZBgKSqaFiImtTThv@localhost.localdomain/

I looked at the kernel documentation but I could not find "Reverse
Chistmas Tree". Can you point me to where this is defined?

In the above case, I do not think RCT should apply.

I think that this:

        struct net_device *netdev = priv->netdev;
        struct net_device_stats *stats = &netdev->stats;

Is better than that:

        struct net_device *netdev = priv->netdev;
        struct net_device_stats *stats;

        stats = &netdev->stats;

Arbitrarily splitting the definition and assignment does not make sense to me.

Thank you for your comments.

> >> +
> >> +       /* transmission buffer released */
> >> +       if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT &&
> >> +           !(data->sr & F81604_SJA1000_SR_TCS)) {
> >> +               stats->tx_errors++;
> >> +               can_free_echo_skb(netdev, 0, NULL);
> >> +       } else {
> >> +               /* transmission complete */
> >> +               stats->tx_bytes += can_get_echo_skb(netdev, 0, NULL);
> >> +               stats->tx_packets++;
> >> +       }
> >> +
> >> +       netif_wake_queue(netdev);
> >> +}
> >> +
> >> +static void f81604_handle_can_bus_errors(struct f81604_port_priv *priv,
> >> +                                        struct f81604_int_data *data)
> >> +{
> >> +       enum can_state can_state = priv->can.state;
> >> +       struct net_device *netdev = priv->netdev;
> >> +       enum can_state tx_state, rx_state;
> >> +       struct net_device_stats *stats;
> >> +       struct can_frame *cf;
> >> +       struct sk_buff *skb;
> >> +
> >> +       stats = &netdev->stats;
> > Merge the declaration with the initialization.
> >
> > Especially, here it is odd that can_state and netdev are initialized
> > during declaration and that only stats is initialized separately.
>
> idem
>
> >> +               tx_state = data->txerr >= data->rxerr ? can_state : 0;
> >> +               rx_state = data->txerr <= data->rxerr ? can_state : 0;
> >> +
> >> +               can_change_state(netdev, cf, tx_state, rx_state);
> >> +
> >> +               if (can_state == CAN_STATE_BUS_OFF)
> >> +                       can_bus_off(netdev);
> >> +       }
> >> +
> >> +       if (priv->clear_flags)
> >> +               schedule_work(&priv->clear_reg_work);
> >> +
> >> +       if (skb)
> >> +               netif_rx(skb);
> >> +}
> >> +
> >> +static void f81604_read_int_callback(struct urb *urb)
> >> +{
> >> +       struct f81604_int_data *data = urb->transfer_buffer;
> >> +       struct net_device *netdev = urb->context;
> >> +       struct f81604_port_priv *priv;
> >> +       int ret;
> >> +
> >> +       priv = netdev_priv(netdev);
> > Merge the declaration with the initialization.
>
> idem
>
> >> +               id = (cf->can_id & CAN_SFF_MASK) << F81604_SFF_SHIFT;
> >> +               put_unaligned_be16(id, &frame->sff.id);
> >> +
> >> +               if (!(cf->can_id & CAN_RTR_FLAG))
> >> +                       memcpy(&frame->sff.data, cf->data, cf->len);
> >> +       }
> >> +
> >> +       can_put_echo_skb(skb, netdev, 0, 0);
> >> +
> >> +       ret = usb_submit_urb(write_urb, GFP_ATOMIC);
> >> +       if (ret) {
> >> +               netdev_err(netdev, "%s: failed to resubmit tx bulk urb: %pe\n",
> >> +                          __func__, ERR_PTR(ret));
> >> +
> >> +               can_free_echo_skb(netdev, 0, NULL);
> >> +               stats->tx_dropped++;
> > Stats is only used once. Maybe better to not declare a variable and do:
> >
> >                 netdev->stats.tx_dropped++;
> >
> > Also, more than a drop, this looks like an error. So:
> >                 netdev->stats.tx_errors++;
>
> Due to lable nomem_urb and tx_dropped/ tx_errors will not only use once,
> so I'll remain it.

I did not fully understand you. Regardless this is a nitpick. If you
are convinced that tx_dropped is the correct way, let it be like that.

Yours sincerely,
Vincent Mailhol
