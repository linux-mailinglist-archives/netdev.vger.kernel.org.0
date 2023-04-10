Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5766DC40A
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 09:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjDJHzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 03:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjDJHzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 03:55:08 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0093A423C
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 00:55:06 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-517bd9b1589so321510a12.1
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 00:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681113306;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rCLlMZi8wtvZ1o5ntOU1qJJ6KGPms7PLTlQ+5dmgS6Y=;
        b=CcCjpkpmVDROzl/4WivWEV6C4V0zqhMPQxvT/bc3S4O/NvpG+yEddGJUpzTjtTXtAL
         rSZHxzlZuMwA+HG/dgLLO0jve5+YIXjya4KEUSaRKAwuTbYLluhVnH9QS3NJ1lvyRRil
         EoUAafxR/vJ9vrzXbMkoJz6xX6/74tTY3l7VsSp9jApdQoMwGbZBMsQN7zcUnJH9c9Rr
         CKRGRblOyTKjktomgh9mhcoZq8DV51J6ejgs1QOQqoiWML1gsSSWAemwTM/9EYNOakhK
         gRpm1iqPs8ABZ6sR3Ck0DzRE1NsZWfrkNIJ3DcMefFxGXBkEe1vK1xG6EI/SetjNwBav
         V7Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681113306;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rCLlMZi8wtvZ1o5ntOU1qJJ6KGPms7PLTlQ+5dmgS6Y=;
        b=Z38QOAB5NJ3UU6Mpqpl7TeHn5wmhJSObK+PGGfnL5ShailWgnnPKlG91e3qh54LnfI
         JAC8i+B33ZmH4sGIOWRJKZFWGXsXrESfeuRC6vWY5V2ME0vot5IvxlMNmHQ6MRx2s7pD
         xB9BTQgUu3ZIvD7MYDIi0lfr5IMAqUN2r6v6Vcqe24w2nWXUNdJ5CUubr32MjleP+KiO
         H4n6Khq+FG1TOVaNe8x36IvMbXJHyDzrz3Yhc0AqeoNAYEEHy39qd/f7EYkonemTWOVJ
         tpwNEDo9CeA8+wk4Gsng6bzurFwgHsVznHMQevu6Mt+a4USiG50egeUUWuZzlA8iGEyU
         /9Lw==
X-Gm-Message-State: AAQBX9fA0kUPGTHIZuVVaZaL9JbQopvMEqsHBIejtoKl5AZKm7Rrixja
        /m66qVaGB0VDAf3pHA0Irfw=
X-Google-Smtp-Source: AKy350YCapirzJn6d2eAMAHjUCM2bccTbz6lldlv8iewSC+sGYf/2jczoJYuXtOnO1V249yzR8FlQA==
X-Received: by 2002:a62:2946:0:b0:633:6eec:fdc6 with SMTP id p67-20020a622946000000b006336eecfdc6mr6033334pfp.1.1681113306281;
        Mon, 10 Apr 2023 00:55:06 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b22-20020aa78716000000b0063486255a87sm3026706pfo.142.2023.04.10.00.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 00:55:05 -0700 (PDT)
Date:   Mon, 10 Apr 2023 15:55:00 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, Liang Li <liali@redhat.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCHv2 net-next] bonding: add software tx timestamping support
Message-ID: <ZDPA1GG7Rgfhu/DP@Laptop-X1>
References: <20230407061228.1035431-1-liuhangbin@gmail.com>
 <CANn89iL_7CYs1kAY8SsUJLFoSZXe1rXAd3HJY-9dziehTfTkaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iL_7CYs1kAY8SsUJLFoSZXe1rXAd3HJY-9dziehTfTkaQ@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 11:34:23AM +0200, Eric Dumazet wrote:
> > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> > index 00646aa315c3..994efc777a77 100644
> > --- a/drivers/net/bonding/bond_main.c
> > +++ b/drivers/net/bonding/bond_main.c
> > @@ -5686,9 +5686,13 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
> >                                     struct ethtool_ts_info *info)
> >  {
> >         struct bonding *bond = netdev_priv(bond_dev);
> > +       struct ethtool_ts_info ts_info;
> >         const struct ethtool_ops *ops;
> >         struct net_device *real_dev;
> >         struct phy_device *phydev;
> > +       bool soft_support = false;
> > +       struct list_head *iter;
> > +       struct slave *slave;
> >         int ret = 0;
> >
> >         rcu_read_lock();
> > @@ -5707,10 +5711,41 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
> >                         ret = ops->get_ts_info(real_dev, info);
> >                         goto out;
> >                 }
> > +       } else {
> > +               /* Check if all slaves support software rx/tx timestamping */
> > +               rcu_read_lock();
> > +               bond_for_each_slave_rcu(bond, slave, iter) {
> > +                       ret = -1;
> > +                       dev_hold(slave->dev);
> 
> You are holding rcu_read_lock() during the loop, so there is no need
> for this dev_hold() / dev_put() dance.

Thanks, I will remove this part.

> 
> And if this was needed, we kindly ask for new dev_hold()/dev_put()
> added in networking code to
> instead use netdev_hold / netdev_put(), we have spent enough time
> tracking hold/put bugs.

I saw dev_hold has called netdev_hold. Is there a need to convert the
old dev_hold to netdev_hold in driver code?

Thanks
Hangbin
