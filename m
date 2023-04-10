Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC83D6DC38B
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 08:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjDJG1B convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 10 Apr 2023 02:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjDJG1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 02:27:01 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC2E40DF;
        Sun,  9 Apr 2023 23:26:56 -0700 (PDT)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6324adf8c69so367514b3a.3;
        Sun, 09 Apr 2023 23:26:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681108016;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1o4Fm/zMjwT/KOOu5Qq10NSwgAuEG/lxaflNYKbr+9w=;
        b=pWT7Vh09qPe8AfjSLiS1UkvPJI+TMrHgwiENafGyXGFvzpDf1qmKdCYFFOXqgfYoMI
         MVOJg8TgOsJ4MhoFneJjYQGsN2OxExdQqupB/OgO7Mo8PcLbo92cCxp8vToapOki/vCG
         rqtYl0veoZcJ+553xGSWo3qPVK/ReR1zNL8HbN+7pe2WDcsZ9Mg3Sl2irJiYZX0DV0I2
         CKCxWrqQFkRaV7LSnbEm19hcqJijpMB3vMQgV4NQWDGFbCaIMwep2ZrlzGa53dtAPWdL
         cBHRCwBxbDhXoQOnAbAAg0tlD9xbKMOa4Ksm2MvElhUMBQa42dNd8wNHulNH3WYXjh1J
         7u2w==
X-Gm-Message-State: AAQBX9eERvdng+iseaEnR6bE2/uZfiLqbxEh+1CVZoNxRkndRTpiyKxi
        BFh9R7KTXRV45UJNwYObHHVg5ihfHCiYjuLjR50=
X-Google-Smtp-Source: AKy350ZZkpmxSW/cGEpdK4UGhXi5yGkBV72Xks2735lI67vmfQfysYEvKTNA6tvmmoNZjZ/1NS70RzTZaXmsFEd3LVY=
X-Received: by 2002:a05:6a00:2182:b0:628:123c:99be with SMTP id
 h2-20020a056a00218200b00628123c99bemr4386385pfi.2.1681108016068; Sun, 09 Apr
 2023 23:26:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230327051048.11589-1-peter_hong@fintek.com.tw>
 <CAMZ6Rq+ps1tLii1VfYyAqfD4ck_TGWBUo_ouK_vLfhoNEg-BPg@mail.gmail.com>
 <5bdee736-7868-81c3-e63f-a28787bd0007@fintek.com.tw> <CAMZ6Rq++N9ui5srP2uBYz0FPXttBYd2m982K8X-ESCC=qu1dAQ@mail.gmail.com>
 <8f43fc07-39b1-4b1b-9dc6-257eb00c3a81@fintek.com.tw> <CAMZ6RqLnWARxkJx0gBsee4NsyQicpg6=bPaysmoFo6KRc-j23g@mail.gmail.com>
 <7e9c01da-74be-3d8d-bb0c-d90935d82081@fintek.com.tw>
In-Reply-To: <7e9c01da-74be-3d8d-bb0c-d90935d82081@fintek.com.tw>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 10 Apr 2023 15:26:44 +0900
Message-ID: <CAMZ6RqJK6jTprZpkKpYALvsv9jDeAtzJyrfHaEakZiD3=bbm_w@mail.gmail.com>
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
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Peter,

On Mon. 10 Apr 2023 at 14:52, Peter Hong <peter_hong@fintek.com.tw> wrote:
> Hi Vincent,
>
> Vincent MAILHOL 於 2023/3/30 下午 09:11 寫道:
> > Hmm, I am still not a fan of setting a mutex for a single concurrency
> > issue which can only happen during probing.
> >
> > What about this:
> >
> >    static int __f81604_set_termination(struct net_device *netdev, u16 term)
> >    {
> >            struct f81604_port_priv *port_priv = netdev_priv(netdev);
> >            u8 mask, data = 0;
> >
> >            if (netdev->dev_id == 0)
> >                    mask = F81604_CAN0_TERM;
> >            else
> >                    mask = F81604_CAN1_TERM;
> >
> >            if (term == F81604_TERMINATION_ENABLED)
> >                    data = mask;
> >
> >            return f81604_mask_set_register(port_priv->dev, F81604_TERMINATOR_REG,
> >                                            mask, data);
> >    }
> >
> >    static int f81604_set_termination(struct net_device *netdev, u16 term)
> >    {
> >            ASSERT_RTNL();
> >
> >            return __f81604_set_termination(struct net_device *netdev, u16 term);
> >    }
> >
> >    static int f81604_init_termination(struct f81604_priv *priv)
> >    {
> >            int i, ret;
> >
> >            for (i = 0; i < ARRAY_SIZE(f81604_priv->netdev); i++) {
> >                    ret = __f81604_set_termination(f81604_priv->netdev[i],
> >                                                   F81604_TERMINATION_DISABLED);
> >                    if (ret)
> >                            return ret;
> >            }
> >    }
> >
> >    static int f81604_probe(struct usb_interface *intf,
> >                            const struct usb_device_id *id)
> >    {
> >            /* ... */
> >
> >            err = f81604_init_termination(priv);
> >            if (err)
> >                    goto failure_cleanup;
> >
> >            for (i = 0; i < ARRAY_SIZE(f81604_priv->netdev); i++) {
> >                    /* ... */
> >            }
> >
> >            /* ... */
> >    }
> >
> > Initialise all resistors with __f81604_set_termination() in probe()
> > before registering any network device. Use f81604_set_termination()
> > which has the lock assert elsewhere.
>
> The f81604_set_termination() will transform into the following code:
>
> static int f81604_write(struct usb_device *dev, u16 reg, u8 data);
> static int f81604_read(struct usb_device *dev, u16 reg, u8 *data);
> static int f81604_update_bits(struct usb_device *dev, u16 reg, u8 mask,
>                                                 u8 data);
>
> static int __f81604_set_termination(struct usb_device *dev, int idx, u16
> term)
> {
>      u8 mask, data = 0;
>
>      if (idx == 0)
>          mask = F81604_CAN0_TERM;
>      else
>          mask = F81604_CAN1_TERM;
>
>      if (term)
>          data = mask;
>
>      return f81604_update_bits(dev, F81604_TERMINATOR_REG, mask, data);
> }
>
> static int f81604_set_termination(struct net_device *netdev, u16 term)
> {
>      struct f81604_port_priv *port_priv = netdev_priv(netdev);
>      struct f81604_priv *priv;
>
>      ASSERT_RTNL();
>
>      priv = usb_get_intfdata(port_priv->intf);
       ^^^^
Why do you need priv here? I do not see it used in the next line.

>      return __f81604_set_termination(port_priv->dev, netdev->dev_id, term);
> }
>
> and also due to f81604_write() / f81604_read() / f81604_update_bits()
> may use
> in f81604_probe() without port private data, so we'll change their first
> parameter
> from "struct f81604_port_priv *priv" to "struct usb_device *dev". Is it OK ?

Right now, it is hard to visualize the final result. Please send what
you think is the best and we will review.

> > Also, looking at your probe() function, in label clean_candev:, if the
> > second can channel fails its initialization, you do not clean the
> > first can channel. I suggest adding a f81604_init_netdev() and
> > handling the netdev issue and cleanup in that function.
>
> When the second can channel failed its initialization, the label
> "clean_candev" will
> clear second "netdev" object and the first "netdev" will cleanup in
> f81604_disconnect().
>
> Could I remain this section of code ?

Oh! I was not aware that disconnect() would be called on a failed
probe. Overall, I prefer the use of subfunctions because it makes it
easier to understand the logic, especially for the cleanup after
failure. Let's say that it is acceptable as-is. OK to keep.
