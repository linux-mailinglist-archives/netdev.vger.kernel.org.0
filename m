Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1C74B962F
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 03:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbiBQC6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 21:58:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbiBQC6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 21:58:06 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955F0C4E36
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 18:57:52 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id o2so7440787lfd.1
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 18:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PRXzl4MrenAXFcJTPHd0cfLMk6vHd+SMBNj1p9vvORo=;
        b=UXiXYe0csgNHz5JzZK9/SQAmZHnBmqw8se4iY04CaKD4OcOe4YxyTbqUnHKSgXFGJB
         zHw4zKxDa495bLd8b1PM8wU3COP2tHIek0YFzUewCPdse44G6tIVC32q5mccn769q2tE
         XOUng1cGckbHtk3If74XDKg/GRVJ5eLqI/r7Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PRXzl4MrenAXFcJTPHd0cfLMk6vHd+SMBNj1p9vvORo=;
        b=jrCYyYpsPKxvPLBXSGe9UuTGv9P+C2ObT/zskwQjiT7guNNVZZeoQVBMEUwUQO5GUa
         2qLS62rTZOFMHzT8K/ma94l+RjkYiejl5utkaQJ5lugyvHO9E7Dmi3jISQi3dUwkPXd0
         ew/ptnUlL0SdM/IOOT2zcFER2+2s51p4y9I2lNSYIxsYVwSoR15AK0fJrkxs0BVLjxSk
         CTSMjU6L5qYhGmTi2lLwxxQ6dwPVhABK6RyM1ipxN1fF/yc15wCWur9VX9hohhHqL2t1
         g9hKwHiqpzGBRf1ODrpkynTWzXZmL25aYrS4NYtAJbj0yGXrEP2woKrJrI6UznLR2Qpk
         zF6A==
X-Gm-Message-State: AOAM530YyDGhyiVYL5ap16jruGkwvnWscmYI+Q8ggZdsAGxaQX9VdUR7
        yATt35+SL9q8MHzR8XbkdVzJsUc1GDbsq6pT+u374jnHWgo=
X-Google-Smtp-Source: ABdhPJyUNQHsgQ43Sw7rxWIp2ClrFx7XdZ0BCYLt5PCBHmTf0ALmlO0Lx/WddvwL5cbIVByZ9VOURWErT21YRTnEiT4=
X-Received: by 2002:a19:f011:0:b0:443:9d63:df20 with SMTP id
 p17-20020a19f011000000b004439d63df20mr685562lfc.69.1645066669848; Wed, 16 Feb
 2022 18:57:49 -0800 (PST)
MIME-Version: 1.0
References: <20220110015636.245666-1-dmichail@fungible.com>
 <20220110015636.245666-4-dmichail@fungible.com> <20220112144550.17c38ccd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220112144550.17c38ccd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Wed, 16 Feb 2022 18:57:36 -0800
Message-ID: <CAOkoqZ=jF=oK+_s_QTr8eL+6Dw6r7710mGpgqLjgWbAruS_Ucg@mail.gmail.com>
Subject: Re: [PATCH net-next v6 3/8] net/funeth: probing and netdev ops
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
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

On Wed, Jan 12, 2022 at 2:45 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun,  9 Jan 2022 17:56:31 -0800 Dimitris Michailidis wrote:
> > +static void fun_update_link_state(const struct fun_ethdev *ed,
> > +                               const struct fun_admin_port_notif *notif)
> > +{
> > +     unsigned int port_idx = be16_to_cpu(notif->id);
> > +     struct net_device *netdev;
> > +     struct funeth_priv *fp;
> > +
> > +     if (port_idx >= ed->num_ports)
> > +             return;
> > +
> > +     netdev = ed->netdevs[port_idx];
> > +     fp = netdev_priv(netdev);
> > +
> > +     write_seqcount_begin(&fp->link_seq);
> > +     fp->link_speed = be32_to_cpu(notif->speed) * 10;  /* 10 Mbps->Mbps */
> > +     fp->active_fc = notif->flow_ctrl;
> > +     fp->active_fec = notif->fec;
> > +     fp->xcvr_type = notif->xcvr_type;
> > +     fp->link_down_reason = notif->link_down_reason;
> > +     fp->lp_advertising = be64_to_cpu(notif->lp_advertising);
> > +
> > +     if ((notif->link_state | notif->missed_events) & FUN_PORT_FLAG_MAC_DOWN)
> > +             netif_carrier_off(netdev);
> > +     if (notif->link_state & FUN_PORT_FLAG_MAC_UP)
> > +             netif_carrier_on(netdev);
> > +
> > +     write_seqcount_end(&fp->link_seq);
> > +     fun_report_link(netdev);
> > +}
> > +
> > +/* handler for async events delivered through the admin CQ */
> > +static void fun_event_cb(struct fun_dev *fdev, void *entry)
> > +{
> > +     u8 op = ((struct fun_admin_rsp_common *)entry)->op;
> > +
> > +     if (op == FUN_ADMIN_OP_PORT) {
> > +             const struct fun_admin_port_notif *rsp = entry;
> > +
> > +             if (rsp->subop == FUN_ADMIN_SUBOP_NOTIFY) {
> > +                     fun_update_link_state(to_fun_ethdev(fdev), rsp);
>
> Is there locking between service task and admin queue events?

There isn't any lock between them. They coordinate through atomic
bitops and the synchronization work_structs provide.
