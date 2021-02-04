Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A1B30FB85
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 19:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239165AbhBDScC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 13:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238760AbhBDSap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 13:30:45 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA257C06178A
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 10:29:52 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id e132so4134366ybh.8
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 10:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eWgh0XkVaRWPuWo7WK7qz5Q0H3AISoN4etSff7sqhGw=;
        b=Zm8Jwd2j2XDdwDja/gEY8F0m/doWOuQFeKvwXWxdJhS2QyIi6oaf3OHot4DBk9Hqbx
         Q3TfccWb3tsqlbkXKHWfSk7PY+9bDCoofSB5v7UxmnKqt2DgL2ggzMzmG3OVmVf59v4m
         bAKEmhAT5C4En27IXXiIIOnPGYEp1Ugk9cM1Jhaj8noNTyLvpzvO+1vyn4+kIE3ucaCl
         qMK9L6C0qsNTQWYweqWEfebQaRHIH9Qw0t/Pt5L1S2iWt/jgaz0yg/AXpmqGbhJQu23s
         ftGltkD6+LUile+VMud9NATpK9oyWJspgiDAV704nfJnZ/riL3BGqcJ+GxeA0I/1q9k9
         UA8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eWgh0XkVaRWPuWo7WK7qz5Q0H3AISoN4etSff7sqhGw=;
        b=AEuupFMH6XJOojesLmisVFpfuUninPzJiUUX5lWIckhTL2gyrAHEGrnBy+u8xUt+hO
         V/ScCZvY0fL1sUEo7HOMKOCDsB7Y8JtpPZeNdrp8ZGezQleMiymlYFYxjmGmpisZ9V4w
         /iekIPl0zGZwu8NVNBzOvCcG//FmaGpNacjEejTlpnsolEpdjKpUHph6WuRCoD9W2EeB
         xQzLmChq7tVLtmApicf660PWRlfsajDQcBmLq3GDWPS1pWLjTnQLNJjtUmZbBohcChi/
         Uo5HMhkXq4+uyas7hs/ExNVPM0Dt5gLekDaiwuimTJAlbLCCfkH/ujpWWX6P4M1+fSz7
         EzuA==
X-Gm-Message-State: AOAM533Gj3RKZ/bGmXolZIVJYItDJD+7ENPx8URO2glGtX743qc19fCU
        ypVHaapN2H8D2b/clZeh+zwZpifBNruAsr/O6+s=
X-Google-Smtp-Source: ABdhPJyPbmOvFiklD3H0VNXQr6NZf54rjz/Qni/kpYtt32m4+s71llCUvOi0m045SGW63zF5Gn5rMFTsMJzoP//s2f0=
X-Received: by 2002:a25:ba13:: with SMTP id t19mr763188ybg.129.1612463392132;
 Thu, 04 Feb 2021 10:29:52 -0800 (PST)
MIME-Version: 1.0
References: <20210201100509.27351-1-borisp@mellanox.com> <20210201100509.27351-10-borisp@mellanox.com>
 <c864eb96-18ea-21dd-3ef3-15ca908c5959@grimberg.me>
In-Reply-To: <c864eb96-18ea-21dd-3ef3-15ca908c5959@grimberg.me>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Thu, 4 Feb 2021 20:29:41 +0200
Message-ID: <CAJ3xEMjzh=PEqLNwW5RMtofskGQubD3Z5+CR_JhuCUCH50jtGg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 09/21] nvme-tcp: Deal with netdevice DOWN events
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, axboe@fb.com,
        Keith Busch <kbusch@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>, smalin@marvell.com,
        Yoray Zack <yorayz@mellanox.com>, yorayz@nvidia.com,
        boris.pismenny@gmail.com, Ben Ben-Ishay <benishay@mellanox.com>,
        benishay@nvidia.com, linux-nvme@lists.infradead.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Or Gerlitz <ogerlitz@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 11:17 AM Sagi Grimberg <sagi@grimberg.me> wrote:
> > @@ -2930,6 +2931,27 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
> >       return ERR_PTR(ret);
> >   }
> >
> > +static int nvme_tcp_netdev_event(struct notifier_block *this,
> > +                              unsigned long event, void *ptr)
> > +{
> > +     struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
> > +     struct nvme_tcp_ctrl *ctrl;
> > +
> > +     switch (event) {
> > +     case NETDEV_GOING_DOWN:
> > +             mutex_lock(&nvme_tcp_ctrl_mutex);
> > +             list_for_each_entry(ctrl, &nvme_tcp_ctrl_list, list) {
> > +                     if (ndev != ctrl->offloading_netdev)
> > +                             continue;
> > +                     nvme_tcp_error_recovery(&ctrl->ctrl);
> > +             }
> > +             mutex_unlock(&nvme_tcp_ctrl_mutex);
> > +             flush_workqueue(nvme_reset_wq);
> > +             /* we assume that the going down part of error recovery is over */
>
> Maybe phrase it as:
> /*
>   * The associated controllers teardown has completed, ddp contexts
>   * were also torn down so we should be safe to continue...
>   */

sure
