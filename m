Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D03A1EA4F7
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 15:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgFAN0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 09:26:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50071 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725976AbgFAN0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 09:26:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591017970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IRfq5vWGxkg2iGmNT2OiJJevysZiaYLSO0DYjWQmzCo=;
        b=VNwbIyLKC7a7KCC48/0No8RitbCeA6MKCmaGzBp1JV/crZh+WaxG4PnIhxaiwCEKal4BvA
        S5RZCTB/mqIeHImQivBDHHppHXfSPDHGxUCyEsc9NGP1ZIqi7fhZpyEqsel9budd1J6/N+
        PFMyJ+Ysao2mrZyTQ1hHQugOdjq+1TQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-_GUGVgQVOJGSy5gxp12YBg-1; Mon, 01 Jun 2020 09:26:05 -0400
X-MC-Unique: _GUGVgQVOJGSy5gxp12YBg-1
Received: by mail-wr1-f69.google.com with SMTP id m14so3059666wrj.12
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 06:26:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=IRfq5vWGxkg2iGmNT2OiJJevysZiaYLSO0DYjWQmzCo=;
        b=E7B7HWwIMpOdlWnSLFLoULCAVZHY96T8h0zAxKl/ofILAbBM++9aERrY3G/c/2gX2z
         Jx1ZWk8YncAw0+SIZMVvLjjnqJhfoyzFyNi97j5MCVRo1FIj/alB+AhJ77zg0PwWAV/J
         THzPyHPQkF1xa9SIvMjTOxhxpK1GORgaxu/FcOm/Pgmnl0l7Ww7kJMO+7ELBGgdXhQmP
         7r/bpiZuBbjQC8dRNT1YIYKJ7aUvB0+hVFfP2x7P1K6EoLCSI7wp5ylnBa9HbJI5aT3E
         y0Z123FRHr07coliMa8HX8JzFv5p05JZ2OTScoLG7SkvLXBwNAgx9qOFywNXcI8pmH3D
         xF5g==
X-Gm-Message-State: AOAM533MNz5+r5c/tsX8TcsQ8hBxPcNI20igQ03hYscx/2vn6rWLiK4Y
        Sz3atfY7pne7jRBXeudDxJZPak2uk53WJtSGI2OolMieLJ8I1LTnL88zBEAK3rkVnAbG3+spUe1
        pvy3ujrsuzMJ0B2om
X-Received: by 2002:a7b:cd83:: with SMTP id y3mr9035988wmj.5.1591017964167;
        Mon, 01 Jun 2020 06:26:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzl8lRUHSE787paC5X60OoxhERxaaxtuTvkoS0LlVBYhPgpTofNEGYr/DfLFh8K2PDep2O2VQ==
X-Received: by 2002:a7b:cd83:: with SMTP id y3mr9035967wmj.5.1591017963973;
        Mon, 01 Jun 2020 06:26:03 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id p1sm20620154wrx.44.2020.06.01.06.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 06:26:03 -0700 (PDT)
Date:   Mon, 1 Jun 2020 09:26:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     xiangxia.m.yue@gmail.com, makita.toshiaki@lab.ntt.co.jp,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net-next v8 7/7] net: vhost: make busyloop_intr more
 accurate
Message-ID: <20200601092522-mutt-send-email-mst@kernel.org>
References: <1534680686-3108-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1534680686-3108-8-git-send-email-xiangxia.m.yue@gmail.com>
 <f85bfa97-ab9c-2d51-2053-1fe6bb3d45bc@redhat.com>
 <8460e039-d58e-85df-cef9-c87933f46cc2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8460e039-d58e-85df-cef9-c87933f46cc2@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 21, 2018 at 08:47:35AM +0800, Jason Wang wrote:
> 
> 
> On 2018年08月21日 08:33, Jason Wang wrote:
> > 
> > 
> > On 2018年08月19日 20:11, xiangxia.m.yue@gmail.com wrote:
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > 
> > > The patch uses vhost_has_work_pending() to check if
> > > the specified handler is scheduled, because in the most case,
> > > vhost_has_work() return true when other side handler is added
> > > to worker list. Use the vhost_has_work_pending() insead of
> > > vhost_has_work().
> > > 
> > > Topology:
> > > [Host] ->linux bridge -> tap vhost-net ->[Guest]
> > > 
> > > TCP_STREAM (netperf):
> > > * Without the patch:  38035.39 Mbps, 3.37 us mean latency
> > > * With the patch:     38409.44 Mbps, 3.34 us mean latency
> > 
> > The improvement is not obvious as last version. Do you imply there's
> > some recent changes of vhost that make it faster?
> > 
> 
> I misunderstood the numbers, please ignore this.
> 
> It shows less than 1% improvement. I'm not sure it's worth to do so. Can you
> try bi-directional pktgen to see if it has more obvious effect?
> 
> Thanks


Right, this kind of gain is in the noise. Try measuring CPU utilization?

> > Thanks
> > 
> > > 
> > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > ---
> > >   drivers/vhost/net.c | 9 ++++++---
> > >   1 file changed, 6 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > > index db63ae2..b6939ef 100644
> > > --- a/drivers/vhost/net.c
> > > +++ b/drivers/vhost/net.c
> > > @@ -487,10 +487,8 @@ static void vhost_net_busy_poll(struct
> > > vhost_net *net,
> > >       endtime = busy_clock() + busyloop_timeout;
> > >         while (vhost_can_busy_poll(endtime)) {
> > > -        if (vhost_has_work(&net->dev)) {
> > > -            *busyloop_intr = true;
> > > +        if (vhost_has_work(&net->dev))
> > >               break;
> > > -        }
> > >             if ((sock_has_rx_data(sock) &&
> > >                !vhost_vq_avail_empty(&net->dev, rvq)) ||
> > > @@ -513,6 +511,11 @@ static void vhost_net_busy_poll(struct
> > > vhost_net *net,
> > >           !vhost_has_work_pending(&net->dev, VHOST_NET_VQ_RX))
> > >           vhost_net_enable_vq(net, rvq);
> > >   +    if (vhost_has_work_pending(&net->dev,
> > > +                   poll_rx ?
> > > +                   VHOST_NET_VQ_RX: VHOST_NET_VQ_TX))
> > > +        *busyloop_intr = true;
> > > +
> > >       mutex_unlock(&vq->mutex);
> > >   }
> > 
> > _______________________________________________
> > Virtualization mailing list
> > Virtualization@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/virtualization

