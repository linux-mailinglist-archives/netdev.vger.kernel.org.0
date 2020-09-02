Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A954F25B409
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 20:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgIBSnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 14:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgIBSnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 14:43:32 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26DCC061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 11:43:31 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id m23so6902614iol.8
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 11:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l1n7FL3/WgdToFIuzw7kdjJ+zGpM6j9w4hUNWb0OM3w=;
        b=bihzZMyWM1NU2WCPVxu7BRwH1O5yFdeROqSctjZH9nCMU1VVhueqmqOHpiZme0+vnx
         YZAnhvMysdTxySho9VYJgo0HK+qs+a6MfnmB1NNtqKE9q5tXvEgA08RdMiz76Z13Xl6G
         5Sf02EGfEZ4xoqLquyxURo5NVc+MqTVNu1u5de8ifXYjfMP/sikZ9c+IqEdNGXZvZNOL
         UmOwFruUhVETRJMDRxJUTtndyUo+OtExsso4Fg2o1iJwW/K3Xun3n9sD758xLFBJ7c5Y
         wt0DbpWTqorr9Koe/sDipvv83S3YWc0I5uQA7NFy5Sh+691vI4gp68Yle31WD8QgQshE
         1Oaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l1n7FL3/WgdToFIuzw7kdjJ+zGpM6j9w4hUNWb0OM3w=;
        b=UMX70BR29WcsMIGaPnTe8TbzDAcoyp7revkJMssTCbHIUjWeqLBUrQKraZD1InYx7w
         dF5YizmV7d1CxdngB9+F2tYQ3NhvbH+EDGOkdh47yK0dUe3JisD1fBja9IbUE9VIDABc
         PIsoGP8j9N1NeQjVTS3Vkmw3RZs+rp4prhlkc9zwZLaEgtqnCy/LDntsBpWX98+nf6dK
         tf/dfWXGPXiDVLdkUvz/qygk5em3p31d2qWTXU2aj6iuHbK5so025qIZr0m1nX5y64Gw
         0WHGZQfMhPpClvgOaE4plE7DO3aFbBc7eIrUvXalgRSbnk86MIlcwwnQGfyYVIqrgzth
         vyhg==
X-Gm-Message-State: AOAM531KLIoUylJJonAKK2yYGne0nl5Wwi7oScRg/3So56ygpbw4n0b4
        Xz/mcfwYpcra0fpcljWGcefCrFu6BhbEwlkuFCGo5Q==
X-Google-Smtp-Source: ABdhPJyRz/aMNKkWzw7eYqCzzNVlupJiHf1ZwKMYtI9/sRO/8ZBkM823sBeXb23ySXVwjL0aw5f8bUYdvJwyfJ0dc3c=
X-Received: by 2002:a6b:9309:: with SMTP id v9mr4663113iod.15.1599072211145;
 Wed, 02 Sep 2020 11:43:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200901215149.2685117-1-awogbemila@google.com>
 <20200901215149.2685117-4-awogbemila@google.com> <20200901220814.GD3050651@lunn.ch>
In-Reply-To: <20200901220814.GD3050651@lunn.ch>
From:   David Awogbemila <awogbemila@google.com>
Date:   Wed, 2 Sep 2020 11:43:20 -0700
Message-ID: <CAL9ddJd2rPMYdgy4Fr2FWfauM5MpS8U1RaeFKUgtynjgmPHtMg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/9] gve: Use dev_info/err instead of netif_info/err.
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 3:08 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > @@ -1133,7 +1133,9 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >               goto abort_with_db_bar;
> >       }
> >       SET_NETDEV_DEV(dev, &pdev->dev);
> > +
> >       pci_set_drvdata(pdev, dev);
> > +
> >       dev->ethtool_ops = &gve_ethtool_ops;
> >       dev->netdev_ops = &gve_netdev_ops;
> >       /* advertise features */
> > @@ -1160,6 +1162,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >       priv->state_flags = 0x0;
> >
> >       gve_set_probe_in_progress(priv);
> > +
> >       priv->gve_wq = alloc_ordered_workqueue("gve", 0);
> >       if (!priv->gve_wq) {
> >               dev_err(&pdev->dev, "Could not allocate workqueue");
> > @@ -1181,6 +1184,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >       dev_info(&pdev->dev, "GVE version %s\n", gve_version_str);
> >       gve_clear_probe_in_progress(priv);
> >       queue_work(priv->gve_wq, &priv->service_task);
> > +
> >       return 0;
> >
> >  abort_with_wq:
>
> No white space changes please. If you want these, put them into a
> patch of there own.
>
>       Andrew
Thanks I'll fix this.
