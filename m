Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11083110C7
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 02:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfEBAu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 20:50:56 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34339 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfEBAuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 20:50:55 -0400
Received: by mail-pg1-f195.google.com with SMTP id c13so252136pgt.1
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 17:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ssFCj4sAN3kpeGckLbmov0T+H+j7TxGSG0J8QLio6KA=;
        b=ZwTfXbXGnKAoclInUsaTHWqUlgqGm1/EiW8CJ0FhFaZQR9PxcErrT/gglJ4EotzuhO
         WNmrA6aLkQ/aWJI8EtqHr3hnJPRMCgFqW0YG/62tqQlvk979XNBtTftt2T12M4/kwboN
         yIi3fnKXjuUqxy+v1qtwwd+RYrN4ySr+rfVRJjPUTBvK9Lsam+YDQKsp4JGy/L0y6B0p
         5WKIvlCBjpl8JJcezoskcJd8T7wMKnollXU+0F71dUYMgoiE//xzq7irrWwjUTulClnY
         uurR6LM2nE7u4i4GKR/fDGH9hKBX69WAAUT3wGfXTgrVGgEKWN4AMUdo7NbMzBcY5fHo
         SKGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ssFCj4sAN3kpeGckLbmov0T+H+j7TxGSG0J8QLio6KA=;
        b=mOopQDmkS2nykYzZDr036jGfP+T+kbEtKVbG/LqstJntlfmvrmw4bdScUeDgxyMBkY
         hMQZNQAc2fse/6zND1oTmCkl2DjrzPYhkQN7P4v8PHJXEKm6/sp0AxZP0rZudumdU0Co
         +BH7eQuaKQJq7yVVYDbatLNhx6fawU2LyMIzHwqer9paeaWDmKCeoAiV6jmrGj5MMU47
         +ldPqQXZR8qW6TBPSMh0An+DSVJjCUikLnFuu5lxQg/RQcWrE5DaxFmr8/crE+ZWTLId
         3AYO/csKUILJEnhi/fsNECK6ZWK6kVKwXvZoJPzSvZery2cd1LvXJJqbcN6Q7KFsb8r6
         4LGQ==
X-Gm-Message-State: APjAAAXNNMIpVKXL3dX95Lur6HYswdGDRvucSDWZhmb0XsPqRyz0guLC
        3PVU8+TkYkMLOBOM+WthNQfTvgzb3WcvDOua3Cc=
X-Google-Smtp-Source: APXvYqygTE/ZEPfaJOzd0yGnzhrkiXJ4JyiL27msW76y+6VKaazUKoGR//L6KwOWCghtnYlFmVcOcTSSixrT3fZK9uo=
X-Received: by 2002:a05:6a00:cc:: with SMTP id e12mr937316pfj.207.1556758255087;
 Wed, 01 May 2019 17:50:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190430185009.20456-1-xiyou.wangcong@gmail.com> <68f5b7e3-4022-edd4-8d18-752b3dfc500f@mellanox.com>
In-Reply-To: <68f5b7e3-4022-edd4-8d18-752b3dfc500f@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 1 May 2019 17:50:43 -0700
Message-ID: <CAM_iQpUfKWFUXKs_eVhvbD6C3C2LkiqaMM60hAtAgbEuBGSPeQ@mail.gmail.com>
Subject: Re: [Patch net-next] net: add a generic tracepoint for TX queue timeout
To:     Eran Ben Elisha <eranbe@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 1, 2019 at 6:11 AM Eran Ben Elisha <eranbe@mellanox.com> wrote:
>
>
>
> On 4/30/2019 9:50 PM, Cong Wang wrote:
> > Although devlink health report does a nice job on reporting TX
> > timeout and other NIC errors, unfortunately it requires drivers
> > to support it but currently only mlx5 has implemented it.
>
> The devlink health was never intended to be the generic mechanism for
> monitoring all driver's TX timeouts notifications. mlx5e driver chose to
> handle TX timeout notification by reporting it to the newly devlink
> health mechanism.

Understood.

>
> > Before other drivers could catch up, it is useful to have a
> > generic tracepoint to monitor this kind of TX timeout. We have
> > been suffering TX timeout with different drivers, we plan to
> > start to monitor it with rasdaemon which just needs a new tracepoint.
>
> Great idea to suggest a generic trace message that can be monitored over
> all drivers.
>
> >
> > Sample output:
> >
> >    ksoftirqd/1-16    [001] ..s2   144.043173: net_dev_xmit_timeout: dev=ens3 driver=e1000 queue=0
> >
> > Cc: Eran Ben Elisha <eranbe@mellanox.com>
> > Cc: Jiri Pirko <jiri@mellanox.com>
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> > ---
> >   include/trace/events/net.h | 23 +++++++++++++++++++++++
> >   net/sched/sch_generic.c    |  2 ++
> >   2 files changed, 25 insertions(+)
> >
> > diff --git a/include/trace/events/net.h b/include/trace/events/net.h
> > index 1efd7d9b25fe..002d6f04b9e5 100644
> > --- a/include/trace/events/net.h
> > +++ b/include/trace/events/net.h
> > @@ -303,6 +303,29 @@ DEFINE_EVENT(net_dev_rx_exit_template, netif_receive_skb_list_exit,
> >       TP_ARGS(ret)
> >   );
> >
>
> I would have put this next to net_dev_xmit trace event declaration.
>

Sounds reasonable, it would be slightly easier to find it.
I will send v2.

Thanks.
