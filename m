Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751A86D060C
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 15:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbjC3NLi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 30 Mar 2023 09:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbjC3NLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 09:11:37 -0400
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7BB8A5A;
        Thu, 30 Mar 2023 06:11:34 -0700 (PDT)
Received: by mail-pg1-f176.google.com with SMTP id s19so11299848pgi.0;
        Thu, 30 Mar 2023 06:11:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680181894;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WF/k+smNF0wtDIvwvnJjHksafUxKVuwmCptDceQP0aU=;
        b=8Ffs5vX9nn5hsSQDP71QnYvGUXKgVZPokOS5Joqe5nzZ0wy1ziz8v/NYVT/1NaYWzi
         9xHnAKauiQ7bA8cW3dOQkAUT+6Ntok5r45wstg4Hm+VsEtZZoCIh0A6FhhzVIKB2Jx/y
         ROlBmtreMyA67b/L+z7CFKYe3IPybZJWxOxyuu6GthfzMsFEVfxZE517Y5/aHau9Tl4y
         RHetxs9KjOSbiVaWo2NEewfovGREqp/xcgM7NVGzENkRE7FDhBGcwU9wonXPuyv5SDXX
         cx6H8eRWIgEl9jUbp8hZb4kxXqKImceeynrt5VY+rHStdQBAWTb1Kz8r3MCkwwle6sLF
         2F6A==
X-Gm-Message-State: AAQBX9c5vHpeYOHVt+i6S3EucZLRMv6ofwnW4iiTZz38c/3AMhNO5bUv
        esFexRLYQulq65ryoLIoBu0EqHOSnXeK20xlo0MeWhPIvbk=
X-Google-Smtp-Source: AKy350apEVm4QjI+SfyqcgMcIZVm8PoBxu+KF9LohzrSLU8Q3Hf8U6iOpoh6H5x37ntsWyNn/OgjDrCfckr0ehMjRUg=
X-Received: by 2002:a05:6a00:1a15:b0:62a:56ce:f90b with SMTP id
 g21-20020a056a001a1500b0062a56cef90bmr12216796pfv.2.1680181893612; Thu, 30
 Mar 2023 06:11:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230327051048.11589-1-peter_hong@fintek.com.tw>
 <CAMZ6Rq+ps1tLii1VfYyAqfD4ck_TGWBUo_ouK_vLfhoNEg-BPg@mail.gmail.com>
 <5bdee736-7868-81c3-e63f-a28787bd0007@fintek.com.tw> <CAMZ6Rq++N9ui5srP2uBYz0FPXttBYd2m982K8X-ESCC=qu1dAQ@mail.gmail.com>
 <8f43fc07-39b1-4b1b-9dc6-257eb00c3a81@fintek.com.tw>
In-Reply-To: <8f43fc07-39b1-4b1b-9dc6-257eb00c3a81@fintek.com.tw>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 30 Mar 2023 22:11:22 +0900
Message-ID: <CAMZ6RqLnWARxkJx0gBsee4NsyQicpg6=bPaysmoFo6KRc-j23g@mail.gmail.com>
Subject: Re: [PATCH V3] can: usb: f81604: add Fintek F81604 support
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
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu. 30 Mars 2023 at 15:49, Peter Hong <peter_hong@fintek.com.tw> wrote:
> Hi Vincent,
>
> Vincent MAILHOL 於 2023/3/28 下午 12:49 寫道:
> >>>> +static int f81604_set_reset_mode(struct net_device *netdev)
> >>>> +{
> >>>> +       struct f81604_port_priv *priv = netdev_priv(netdev);
> >>>> +       int status, i;
> >>>> +       u8 tmp;
> >>>> +
> >>>> +       /* disable interrupts */
> >>>> +       status = f81604_set_sja1000_register(priv->dev, netdev->dev_id,
> >>>> +                                            SJA1000_IER, IRQ_OFF);
> >>>> +       if (status)
> >>>> +               return status;
> >>>> +
> >>>> +       for (i = 0; i < F81604_SET_DEVICE_RETRY; i++) {
> >>> Thanks for removing F81604_USB_MAX_RETRY.
> >>>
> >>> Yet, I still would like to understand why you need one hundred tries?
> >>> Is this some paranoiac safenet? Or does the device really need so many
> >>> attempts to operate reliably? If those are needed, I would like to
> >>> understand the root cause.
> >> This section is copy from sja1000.c. In my test, the operation/reset may
> >> retry 1 times.
> >> I'll reduce it from 100 to 10 times.
> > Is it because the device is not ready? Does this only appear at
> > startup or at random?
>
> I'm using ip link up/down to test open/close(). It's may not ready so fast.
> but the maximum retry is only 1 for test 10000 times.

Ack, thanks for the explanation.

> >>>> +static int f81604_set_termination(struct net_device *netdev, u16 term)
> >>>> +{
> >>>> +       struct f81604_port_priv *port_priv = netdev_priv(netdev);
> >>>> +       struct f81604_priv *priv;
> >>>> +       u8 mask, data = 0;
> >>>> +       int r;
> >>>> +
> >>>> +       priv = usb_get_intfdata(port_priv->intf);
> >>>> +
> >>>> +       if (netdev->dev_id == 0)
> >>>> +               mask = F81604_CAN0_TERM;
> >>>> +       else
> >>>> +               mask = F81604_CAN1_TERM;
> >>>> +
> >>>> +       if (term == F81604_TERMINATION_ENABLED)
> >>>> +               data = mask;
> >>>> +
> >>>> +       mutex_lock(&priv->mutex);
> >>> Did you witness a race condition?
> >>>
> >>> As far as I know, this call back is only called while the network
> >>> stack big kernel lock (a.k.a. rtnl_lock) is being hold.
> >>> If you have doubt, try adding a:
> >>>
> >>>     ASSERT_RTNL()
> >>>
> >>> If this assert works, then another mutex is not needed.
> >> It had added ASSERT_RTNL() into f81604_set_termination(). It only assert
> >> in f81604_probe() -> f81604_set_termination(), not called via ip command:
> >>       ip link set dev can0 type can termination 120
> >>       ip link set dev can0 type can termination 0
> >>
> >> so I'll still use mutex on here.
> > Sorry, do you mean that the assert throws warnings for f81604_probe()
> > -> f81604_set_termination() but that it is OK (no warning) for ip
> > command?
> >
> > I did not see that you called f81604_set_termination() internally.
> > Indeed, rtnl_lock is not held in probe(). But I think it is still OK.
> > In f81604_probe() you call f81604_set_termination() before
> > register_candev(). If the device is not yet registered,
> > f81604_set_termination() can not yet be called via ip command. Can you
> > describe more precisely where you think there is a concurrency issue?
> > I still do not see it.
>
> Sorry, I had inverse the mean of ASSERT_RTNL(). It like you said.
>      f81604_probe() not held rtnl_lock.
>      ip set terminator will held rtnl_lock.
>
> Due to f81604_set_termination() will called by f81604_probe() to
> initialize, it may need mutex in
> situation as following:
>
> User is setting can0 terminator when f81604_probe() complete generate
> can0 and generating can1.
> So IMO, the mutex may needed.

Hmm, I am still not a fan of setting a mutex for a single concurrency
issue which can only happen during probing.

What about this:

  static int __f81604_set_termination(struct net_device *netdev, u16 term)
  {
          struct f81604_port_priv *port_priv = netdev_priv(netdev);
          u8 mask, data = 0;

          if (netdev->dev_id == 0)
                  mask = F81604_CAN0_TERM;
          else
                  mask = F81604_CAN1_TERM;

          if (term == F81604_TERMINATION_ENABLED)
                  data = mask;

          return f81604_mask_set_register(port_priv->dev, F81604_TERMINATOR_REG,
                                          mask, data);
  }

  static int f81604_set_termination(struct net_device *netdev, u16 term)
  {
          ASSERT_RTNL();

          return __f81604_set_termination(struct net_device *netdev, u16 term);
  }

  static int f81604_init_termination(struct f81604_priv *priv)
  {
          int i, ret;

          for (i = 0; i < ARRAY_SIZE(f81604_priv->netdev); i++) {
                  ret = __f81604_set_termination(f81604_priv->netdev[i],
                                                 F81604_TERMINATION_DISABLED);
                  if (ret)
                          return ret;
          }
  }

  static int f81604_probe(struct usb_interface *intf,
                          const struct usb_device_id *id)
  {
          /* ... */

          err = f81604_init_termination(priv);
          if (err)
                  goto failure_cleanup;

          for (i = 0; i < ARRAY_SIZE(f81604_priv->netdev); i++) {
                  /* ... */
          }

          /* ... */
  }

Initialise all resistors with __f81604_set_termination() in probe()
before registering any network device. Use f81604_set_termination()
which has the lock assert elsewhere.

Also, looking at your probe() function, in label clean_candev:, if the
second can channel fails its initialization, you do not clean the
first can channel. I suggest adding a f81604_init_netdev() and
handling the netdev issue and cleanup in that function.

> >>>> +               port_priv->can.do_get_berr_counter = f81604_get_berr_counter;
> >>>> +               port_priv->can.ctrlmode_supported =
> >>>> +                       CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_3_SAMPLES |
> >>>> +                       CAN_CTRLMODE_ONE_SHOT | CAN_CTRLMODE_BERR_REPORTING |
> >>>> +                       CAN_CTRLMODE_CC_LEN8_DLC | CAN_CTRLMODE_PRESUME_ACK;
> >>> Did you test the CAN_CTRLMODE_CC_LEN8_DLC feature? Did you confirm
> >>> that you can send and receive DLC greater than 8?
> >> Sorry, I had misunderstand the define. This device is only support 0~8
> >> data length,
> >    ^^^^^^^^^^^
> >
> > Data length or Data Length Code (DLC)? Classical CAN maximum data
> > length is 8 but maximum DLC is 15 (and DLC 8 to 15 mean a data length
> > of 8).
> >
>
> This device can't support DLC > 8. It's only support 0~8.

Ack.
