Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E58128A612
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 08:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgJKGyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 02:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbgJKGyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 02:54:49 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354CCC0613CE
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 23:54:49 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id n142so10775971ybf.7
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 23:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DwtEKZWE7kyFtmQNQI1VaHt6bZEv5zkM7EVSuNZ3u+w=;
        b=RiWL/nwx6REBlJQotq0kZSWCrmU08/qAWFrigdmXYNlsWR33TUmaPiHxVOw1U2FDLh
         ka9wvtume7N1EfhSme3MyNhJDPtbACfhvEFqbVqVa8eZH2fOuySKlgiLBZD5UxL09TGy
         mmrthcgPUwTt/y7/gOmeWVUwwPBS6fETM4u193KOmdrq4domga7Zp15U+pYJj+jzkSeC
         JLBcKT7vqSTdzU+2DrsW2dNJjCvQAVLOdbS+wtk1pQ9T6llWLOZfVrhIzTW2O+fpxT4H
         NuJLfdupQjNdKZSvZJMqTsjKdpC8ntSDmq34xZYVbmtxNecqFJPLms1boM12YOhLjS6y
         V0ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DwtEKZWE7kyFtmQNQI1VaHt6bZEv5zkM7EVSuNZ3u+w=;
        b=rWJKD0ns6035htOnINBC/QzyTuWMjPVwis3GS+yuJ3yl6snB3HTWC1S0nOCI3wrUco
         xt449/ONDWAb0PufLqqWb0CREyN79tj9X3VlZSi/E20vJJYClu+YN4wFeg2+HCV8utiQ
         KwXhtVzw906KR9xWxNhfONDsMEbj0F5HwBFZB0EBG/8IIC/nkynpWxZrhEiClsnOO0Rd
         +HF9M59UMC3tucApFT0keAWpvZZsi5J+Q4Ig/kAwhTY9ktCk1zLZhZ/9ufOAjrcQvuqG
         seZ0T8vs7l/LgtnnMXwPegU+17S+h27YOvdEnLHbWZKr8GQdNdruwQhGuHcwXqzAPVTX
         xxyA==
X-Gm-Message-State: AOAM533onQVIYnVSbv4pdMYopVcgUbH0I2eCmgOHJuc+Xf98Baqy2l+M
        1pw7csoHMqoRNZuVbYVUfy6UZrLmHFRqX+m4UpU=
X-Google-Smtp-Source: ABdhPJzfLkn1r2ocZJdM30e8vSbXrAH8Zrvp1/iXO8bWCb7qil7HJ2cP+9ebMs/5Ac/UXFEQHb2WjPX3sG0q+gpPWoI=
X-Received: by 2002:a5b:4d2:: with SMTP id u18mr24157729ybp.56.1602399288409;
 Sat, 10 Oct 2020 23:54:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200930162010.21610-1-borisp@mellanox.com> <20200930162010.21610-9-borisp@mellanox.com>
 <67e29f83-5bab-4abd-44c0-9c5ae29d5784@grimberg.me>
In-Reply-To: <67e29f83-5bab-4abd-44c0-9c5ae29d5784@grimberg.me>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Sun, 11 Oct 2020 09:54:37 +0300
Message-ID: <CAJ3xEMh4FBQ583bhxbXwHZKmZLX28Obf6gArP0qpd5OebnuuSw@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v1 08/10] nvme-tcp: Deal with netdevice DOWN events
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, axboe@fb.com,
        kbusch@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Yoray Zack <yorayz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 1:50 AM Sagi Grimberg <sagi@grimberg.me> wrote:

> > @@ -412,8 +413,6 @@ int nvme_tcp_offload_limits(struct nvme_tcp_queue *queue,
> >               queue->ctrl->ctrl.max_segments = limits->max_ddp_sgl_len;
> >               queue->ctrl->ctrl.max_hw_sectors =
> >                       limits->max_ddp_sgl_len << (ilog2(SZ_4K) - 9);
> > -     } else {
> > -             queue->ctrl->offloading_netdev = NULL;
>
> Squash this change to the patch that introduced it.

OK, will look on that and I guess it should be fine to make this as
you suggested


> > +     case NETDEV_GOING_DOWN:
> > +             mutex_lock(&nvme_tcp_ctrl_mutex);
> > +             list_for_each_entry(ctrl, &nvme_tcp_ctrl_list, list) {
> > +                     if (ndev != ctrl->offloading_netdev)
> > +                             continue;
> > +                     nvme_tcp_error_recovery(&ctrl->ctrl);
> > +             }
> > +             mutex_unlock(&nvme_tcp_ctrl_mutex);
> > +             flush_workqueue(nvme_reset_wq);
>
> Worth a small comment that this we want the err_work to complete
> here. So if someone changes workqueues he may see this.


ack
