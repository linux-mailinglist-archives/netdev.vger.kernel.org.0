Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3BC4170B1
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 13:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245055AbhIXLNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 07:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245046AbhIXLNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 07:13:35 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647C4C061574
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 04:12:01 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id j13so9034253qtq.6
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 04:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hUhQpD5gfUt8U/g+dMoFW28FUgWxCl9mMUlqYJ6VrKg=;
        b=buEbtztHD1qxRxJqNdGG6ZmPDZ5hX9sJ7fc8eaw0P/UoQbRuAXzcD5aXqGoGpzs4Tw
         ogeBAILSRNmHgqFHR/t/djhB/Q2QLC/hEMYYCGpeeCt5GWWjGIWwttyesk3tEBLfK6Bg
         ogRHRZZxqfLDV3nOS5DU+yzo6vvOTlBC0BzSLHootePK2gIewIydxJOVe+DozF1o2Tmz
         9voFhXJHtNVr7WcIHzMToKSTMKZtntyk45grTCbqIcvFnft6bn9/N/EuRv9wS0BeVE+i
         vkpMHjBrvBWM/tPDDjEkbReYfJrEE7Cry1oGBYz5FMoy6HkC3I/pRTUYahMx13908IDw
         ITVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hUhQpD5gfUt8U/g+dMoFW28FUgWxCl9mMUlqYJ6VrKg=;
        b=J++C7gd648Ni5EJ9qLlEEicNtF7gh5Ex5/1K/GCHZsVHRrBVLDTKL9HblUSUNEuwmM
         M+Dlg+zxR30eJD5GP8MwDhwHCERmlCmvSY3Gpk32qzSmzMdU+2HeU+vTd2245/Hh6ZHL
         mGUsRO3uPC49LK5lhh7r+dLcb/Im4FuCdIp+Pzm7Fst+kySqajAAcJPm6FcozhtuX2Vu
         62VmUMP6HMV88L+Dalp0yXmP74G7tWW6sF4wSkP+evA26pJjhpI1fiGrxPoLoLCA3teO
         xUIlpLlPTVU5DxSfdvQd+MjFifNkvOZjQcBcxHI1KFGGQPcleSidEmoy5HDF0gybQNcu
         E2vQ==
X-Gm-Message-State: AOAM532VbiKQahCel55u7Qe2bS6xqCzxdHFnHl7gEV9xyOxua2LDApBQ
        jNfnQ6++w6z9/unwqnC7R3u/FqAkOfalUCyrUEM=
X-Google-Smtp-Source: ABdhPJwQ43KT1loznByXlZpQKMYBBiPiwX+n2+a5OUiYE9NPGH4hjaTYSvvHXEbSDH3OgwvaEEBxkgqESCt9YDjBUlY=
X-Received: by 2002:ac8:7008:: with SMTP id x8mr3441227qtm.397.1632481920431;
 Fri, 24 Sep 2021 04:12:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210924092652.3707-1-dnlplm@gmail.com> <20210924094909.GA19050@workstation>
In-Reply-To: <20210924094909.GA19050@workstation>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Fri, 24 Sep 2021 13:11:55 +0200
Message-ID: <CAGRyCJF7M7wVFthr0MBQVuOo_xe=+mnYxBZ2eYFRZQTmnP8=Kg@mail.gmail.com>
Subject: Re: [PATCH 1/1] drivers: net: mhi: fix error path in mhi_net_newlink
To:     Manivannan Sadhasivam <mani@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mani,

Il giorno ven 24 set 2021 alle ore 11:49 Manivannan Sadhasivam
<mani@kernel.org> ha scritto:
>
> On Fri, Sep 24, 2021 at 11:26:52AM +0200, Daniele Palmas wrote:
> > Fix double free_netdev when mhi_prepare_for_transfer fails.
> >
> > Fixes: 3ffec6a14f24 ("net: Add mhi-net driver")
> > Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
>
> I guess this patch should be backported to stable kernels. So please CC stable
> list.

Just v5.14.x seems to be affected by the same issue, but it requires a
slightly different patch: I'll try to take care of that.

Thanks,
Daniele

>
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
>
> Thanks,
> Mani
>
> > ---
> >  drivers/net/mhi_net.c | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
> > index d127eb6e9257..aaa628f859fd 100644
> > --- a/drivers/net/mhi_net.c
> > +++ b/drivers/net/mhi_net.c
> > @@ -321,7 +321,7 @@ static int mhi_net_newlink(struct mhi_device *mhi_dev, struct net_device *ndev)
> >       /* Start MHI channels */
> >       err = mhi_prepare_for_transfer(mhi_dev);
> >       if (err)
> > -             goto out_err;
> > +             return err;
> >
> >       /* Number of transfer descriptors determines size of the queue */
> >       mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
> > @@ -331,10 +331,6 @@ static int mhi_net_newlink(struct mhi_device *mhi_dev, struct net_device *ndev)
> >               return err;
> >
> >       return 0;
> > -
> > -out_err:
> > -     free_netdev(ndev);
> > -     return err;
> >  }
> >
> >  static void mhi_net_dellink(struct mhi_device *mhi_dev, struct net_device *ndev)
> > --
> > 2.30.2
> >
