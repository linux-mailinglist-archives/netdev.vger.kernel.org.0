Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491B0313AE6
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbhBHR1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234563AbhBHRWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 12:22:20 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0254C061788
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 09:21:38 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id l3so6436834oii.2
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 09:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r0NRWFZTrvDaGw0h5yVzDaHbQEyEWC1KU7r0ksEIq8I=;
        b=qhD+PPI37iDsX9Kgf+w9rDCrYDwmEhJF+tMf1C0lMjYlBzr3q/uBKTdwT6amjlPnra
         ojqjXv6oihCAl+Xvv7r9w9sh0OjlpdRua506grV679C8/jRcZRChQKhy/q7S21hIihOn
         /nc6yt1hj62zT8pCjC153L1a2ij/GPuL+cRRvHCaXtdjsr5D4kO4gvaWc2WgVHZU1OLP
         OJOwZ31OgbRghzLWCqOE5QnmjyZU1+Dya5edvUouOzpQBg6JiRXKod9lYRR6hUpQHvL/
         /EeTg2mRwpm2VCkwItM4t+y9uxc4ND1/q3JZIIpVhtMkvQaxgXpBOdPCnxmvMYH+v/gW
         V6pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r0NRWFZTrvDaGw0h5yVzDaHbQEyEWC1KU7r0ksEIq8I=;
        b=lifa7nP3XOx36g2IgX6buhLnyHEVCqodaYIrTe1QHUZs1orBq+DV/mTGNk1AGri+JG
         zGFw26fMsQtk02taZk4MRlhiovIdMECmKBoHpOS5QMsGOZD/AbjX6CKHkjc+KUQesk4Y
         v142vp4xSrETEiQpZLMXaikO30IHXyH9OjoscYnqU06DOF5Rl6uxA2ypiPRYtpaWnfHd
         uFCN2IpkYX1Lg1ujmozv14r+c5x0Wf+3P3DTfYES4qA826/uYfJRDhZ+Xhj8nhd2kfbq
         t6h7lc75GZsHlR5tEoVrHQPpCsJYt+e1zRHdt1gpGl8OkBzWV0TznjAhgE7EcJgkZ2K+
         vSNw==
X-Gm-Message-State: AOAM5317QA/p7DemCPs6LH1S65Wh0c0eMpkgP8QqZT0o+5Bj03bh0kX6
        HGNz3yHUTbNSXYw1tRytOJ023ZrjVznDMBxYmQ==
X-Google-Smtp-Source: ABdhPJxMFvcbdQLRHM69cRmgNRCc2s9tMA6Mb0wRYdtqRHKBJuu9kUS78a7nq3alx0m72Yc83KUQMhe/Ta+kah/UtW8=
X-Received: by 2002:a05:6808:f09:: with SMTP id m9mr12170598oiw.92.1612804898381;
 Mon, 08 Feb 2021 09:21:38 -0800 (PST)
MIME-Version: 1.0
References: <20210204215926.64377-1-george.mccollister@gmail.com>
 <20210204215926.64377-4-george.mccollister@gmail.com> <20210206232931.pbdvtx3gyluw2s4u@skbuf>
In-Reply-To: <20210206232931.pbdvtx3gyluw2s4u@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 8 Feb 2021 11:21:26 -0600
Message-ID: <CAFSKS=MbXJ5VOL1aPWsNyxZfhOUh9XJ7taGMrNnNv5F2OQPJzA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/4] net: dsa: add support for offloading HSR
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 6, 2021 at 5:29 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Thu, Feb 04, 2021 at 03:59:25PM -0600, George McCollister wrote:
> > @@ -1935,6 +1936,19 @@ static int dsa_slave_changeupper(struct net_device *dev,
> >                       dsa_port_lag_leave(dp, info->upper_dev);
> >                       err = NOTIFY_OK;
> >               }
> > +     } else if (is_hsr_master(info->upper_dev)) {
> > +             if (info->linking) {
> > +                     err = dsa_port_hsr_join(dp, info->upper_dev);
> > +                     if (err == -EOPNOTSUPP) {
> > +                             NL_SET_ERR_MSG_MOD(info->info.extack,
> > +                                                "Offloading not supported");
> > +                             err = 0;
> > +                     }
> > +                     err = notifier_from_errno(err);
> > +             } else {
> > +                     dsa_port_hsr_leave(dp, info->upper_dev);
> > +                     err = NOTIFY_OK;
> > +             }
> >       }
> [..]
> > +static int dsa_switch_hsr_join(struct dsa_switch *ds,
> > +                            struct dsa_notifier_hsr_info *info)
> > +{
> > +     if (ds->index == info->sw_index && ds->ops->port_hsr_join)
> > +             return ds->ops->port_hsr_join(ds, info->port, info->hsr);
> > +
> > +     return 0;
> > +}
> > +
> > +static int dsa_switch_hsr_leave(struct dsa_switch *ds,
> > +                             struct dsa_notifier_hsr_info *info)
> > +{
> > +     if (ds->index == info->sw_index && ds->ops->port_hsr_leave)
> > +             ds->ops->port_hsr_leave(ds, info->port, info->hsr);
> > +
> > +     return 0;
> > +}
> > +
>
> If you return zero, the software fallback is never going to kick in.

For join and leave? How is this not a problem for the bridge and lag
functions? They work the same way don't they? I figured it would be
safe to follow what they were doing.
