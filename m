Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D5A6C6337
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 10:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbjCWJXD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Mar 2023 05:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjCWJWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 05:22:40 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB481CBC4;
        Thu, 23 Mar 2023 02:22:35 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id a16so16591671pjs.4;
        Thu, 23 Mar 2023 02:22:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679563355;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HpKkhyG3kY0MZoMYHml99x+9t/mfe40fmpPl1syLvyE=;
        b=hcPQnb55qxobdkcUGjvllNOqdlrn32Fl0+5+1G+dFyQrinMSTvzPhgO8edgvobcZ1e
         0e4ksRvf/0mMZczECwpgPNWBX5fNuF1inQQIUpb1kPdSUDQMYWwYzH7bt8XQzjgtSGho
         pCCj3+2ECLIgIhDvNwmjSRd2zviqM3ggL+eub9ZDEgUXKF421zOtLpcxXDDaIz8e7PRJ
         BAeSuCrW0GsvvGglHHFiZ7hNsK1RwTzeOOv18vqN7XgxCUJ5sAUVY74SyC/26QAzgsQe
         piwZkZOFpklyfIAax5d7thRUNlEmMcYMdLR6AjqYqn5K3nUktaG510+WrPWbR15JGmNb
         kt7Q==
X-Gm-Message-State: AAQBX9dY2WhH3WSzWyPPl+yrxGJOlbxoeGdp8CL0lqOj1krJOKVN++kK
        LBgAjyqGLE9gZRO0Nj4aculsCQIcDslYpAWM89SGrW+ky2j2kw==
X-Google-Smtp-Source: AKy350bIoU8Zid66dudm652RyKct4B57/THEpIrfPdquoM1cIMEZDGNzlLCKkxJ9KBe0l0l2FigPWyRsP6p3mJzsqFo=
X-Received: by 2002:a17:903:7c8:b0:19f:39f8:88c4 with SMTP id
 ko8-20020a17090307c800b0019f39f888c4mr1906789plb.2.1679563354730; Thu, 23 Mar
 2023 02:22:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230321081152.26510-1-peter_hong@fintek.com.tw>
 <CAMZ6RqJWg1H6Yo3nhsa-Kk-WdU=ZH39ecWaE6wiuKRJe1gLMkQ@mail.gmail.com>
 <f71f1f59-f729-2c8c-f6da-8474be2074b1@fintek.com.tw> <CAMZ6Rq+xSCLe8CYm6K0CyPABo-Gzrt-JUO7_XGgXum+G8k5FCQ@mail.gmail.com>
In-Reply-To: <CAMZ6Rq+xSCLe8CYm6K0CyPABo-Gzrt-JUO7_XGgXum+G8k5FCQ@mail.gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 23 Mar 2023 18:22:23 +0900
Message-ID: <CAMZ6RqJNn8UQ62zyKFVHGLm44h2zverRgkKkwwFCUfSjYEXe-A@mail.gmail.com>
Subject: Re: [PATCH V2] can: usb: f81604: add Fintek F81604 support
To:     Peter Hong <peter_hong@fintek.com.tw>
Cc:     wg@grandegger.com, mkl@pengutronix.de,
        michal.swiatkowski@linux.intel.com, Steen.Hegelund@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, frank.jungclaus@esd.eu,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, hpeter+linux_kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu. 23 Mar 2023 at 14:54, Vincent MAILHOL
<mailhol.vincent@wanadoo.fr> wrote:
> Le jeu. 23 mars 2023 à 14:14, Peter Hong <peter_hong@fintek.com.tw> a écrit :
> >
> > Hi Vincent,
> >
> > Vincent MAILHOL 於 2023/3/21 下午 11:50 寫道:
> > >> +static netdev_tx_t f81604_start_xmit(struct sk_buff *skb,
> > >> +                                    struct net_device *netdev)
> > >> +{
> > >> +       struct can_frame *cf = (struct can_frame *)skb->data;
> > >> +       struct f81604_port_priv *priv = netdev_priv(netdev);
> > >> +       struct net_device_stats *stats = &netdev->stats;
> > >> +       int status;
> > >> +       u8 *ptr;
> > >> +       u32 id;
> > >> +
> > >> +       if (can_dropped_invalid_skb(netdev, skb))
> > >> +               return NETDEV_TX_OK;
> > >> +
> > >> +       netif_stop_queue(netdev);
> > >> +
> > >> +       ptr = priv->bulk_write_buffer;
> > >> +       memset(ptr, 0, F81604_DATA_SIZE);
> > >> +
> > >> +       ptr[0] = F81604_CMD_DATA;
> > >> +       ptr[1] = min_t(u8, cf->can_dlc & 0xf, 8);
> > >> +
> > >> +       if (cf->can_id & CAN_EFF_FLAG) {
> > >> +               id = (cf->can_id & CAN_ERR_MASK) << 3;
> > >> +               ptr[1] |= F81604_EFF_BIT;
> > >> +               ptr[2] = (id >> 24) & 0xff;
> > >> +               ptr[3] = (id >> 16) & 0xff;
> > >> +               ptr[4] = (id >> 8) & 0xff;
> > >> +               ptr[5] = (id >> 0) & 0xff;
> > >> +               memcpy(&ptr[6], cf->data, ptr[1]);
> > > Rather than manipulating an opaque u8 array, please declare a
> > > structure with explicit names.
> >
> > I had try to declare a struct like below and refactoring code :
> >
> > struct f81604_bulk_data {
> >      u8 cmd;
> >      u8 dlc;
> >
> >      union {
> >          struct {
> >              u8 id1, id2;
> >              u8 data[CAN_MAX_DLEN];
> >          } sff;
> >
> >          struct {
> >              u8 id1, id2, id3, id4;
> >              u8 data[CAN_MAX_DLEN];
> >          } eff;
> >      };
> > } __attribute__((packed));
> >
> > This struct can used in TX/RX bulk in/out. Is it ok?
>
> That's nearly it. It is better to declare the struct sff and eff
> separately. Also, do not split the id in bytes. Declare it as a little
> endian using the __le16 and __le32 types.
>
> Something like this (I let you adjust):
>
>   struct f81604_sff {
>           __le16 id:
>           u8 data[CAN_MAX_DLEN];
>   } __attribute__((packed));
>
>   struct f81604_eff {
>           __le32 id;
>           u8 data[CAN_MAX_DLEN];
>   } __attribute__((packed));
>
>   struct f81604_bulk_data {
>           u8 cmd;
>           u8 dlc;
>
>           union {
>                   struct f81604_sff sff;
>                   struct f81604_eff eff;
>            };
>   } __attribute__((packed));
>
> The __le16 field should be manipulated using cpu_to_leXX() and
> leXX_to_cpu() if the field is aligned, if not, it should be
> manipulated using {get|set}_unaligned_leXX() (where XX represents the
> size in bits).
>
> Also, f81604_bulk_data->dlc is not only a DLC but also carries the
> F81604_EFF_BIT flag, right? At least, add documentation to the
> structure to clarify this point.
>
> > > +static int f81604_prepare_urbs(struct net_device *netdev)
> > > +{
> > > +       static const u8 bulk_in_addr[F81604_MAX_DEV] = { 0x82, 0x84 };
> > > +       static const u8 bulk_out_addr[F81604_MAX_DEV] = { 0x01, 0x03 };
> > > +       static const u8 int_in_addr[F81604_MAX_DEV] = { 0x81, 0x83 };
> > > +       struct f81604_port_priv *priv = netdev_priv(netdev);
> > > +       int id = netdev->dev_id;
> > > +       int i;
> > > +
> > > +       /* initialize to NULL for error recovery */
> > > +       for (i = 0; i < F81604_MAX_RX_URBS; ++i)
> > > +               priv->read_urb[i] = NULL;
> > > priv was allocated with devm_kzalloc() so it should already be zeroed,
> > > right? What is the purpose of this loop?
> >
> > This operation due to following condition:
> >      f81604_open() -> f81604_close() -> f81604_open() failed.
> >
> > We had used  devm_kzalloc() in f81604_probe(), so first f81604_open() all
> > pointers are NULL. But after f81604_close() then f81604_open() second
> > times, the URB pointers are not NULLed, it'll makes error on 2nd
> > f81604_open()
> > with fail.
>
> Makes sense, thanks for the clarification.
>
> Then, please replace your loop by a memset(priv->read_urb, 0,
> sizeof(priv->read_urb).

Actually, your code never accesses the zeroed memory. The next lines are:

  for (i = 0; i < F81604_MAX_RX_URBS; ++i) {
          priv->read_urb[i] = usb_alloc_urb(0, GFP_KERNEL);

If priv->read_urb[i] is never read before being initialized, no need to zero it.

> > >> +/* Called by the usb core when driver is unloaded or device is removed */
> > >> +static void f81604_disconnect(struct usb_interface *intf)
> > >> +{
> > >> +       struct f81604_priv *priv = usb_get_intfdata(intf);
> > >> +       int i;
> > >> +
> > >> +       for (i = 0; i < F81604_MAX_DEV; ++i) {
> > >> +               if (!priv->netdev[i])
> > >> +                       continue;
> > >> +
> > >> +               unregister_netdev(priv->netdev[i]);
> > >> +               free_candev(priv->netdev[i]);
> > >> +       }
> > >   i> +}
> >
> > Is typo here?
>
> Yes, please ignore.
>
>
> Yours sincerely,
> Vincent Mailhol
