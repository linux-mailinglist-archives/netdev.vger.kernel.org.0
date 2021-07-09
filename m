Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88EDB3C26E0
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 17:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhGIPfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 11:35:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29941 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232408AbhGIPfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 11:35:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625844784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EhLdp2EAi8bhqguWM4hlM+hzx+BaQvYDa0qBD6QQdRo=;
        b=S2HuoUb1SIOkQJBSQKeuwv/bmUBOuoW5aidipAO8yJydD4v9s869v4fgDY9ACqv8SfxzKL
        l7mKXrSvGzYHqtvhtHTWaQXDv1aAcSI5X27JQ+XdwehItiNOVn//2tyov/HvstwyyeU+FD
        3l/AtK717bexN0KEx6Fiy0VPVQZDbVw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-Ds9QQRhZPqS8tBwnbHD7Fw-1; Fri, 09 Jul 2021 11:33:03 -0400
X-MC-Unique: Ds9QQRhZPqS8tBwnbHD7Fw-1
Received: by mail-wr1-f69.google.com with SMTP id y15-20020a5d614f0000b029013cd60e9baaso672556wrt.7
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 08:33:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=EhLdp2EAi8bhqguWM4hlM+hzx+BaQvYDa0qBD6QQdRo=;
        b=VgdivUzoeCOwhu9mrDY+23geOwVm7J7yuFSkMt5RL4QbkCw6Ssrur5Ga7k4Bkyr8le
         oRrXUjPygWwIcVfpNmYyZikcV6teaDvTRVYHNs+QiMWW6nL3JIrBtjjujHWpDl9AU1e4
         4KUIxfCAGyBsj8mD0fnSr3vBYQk5wK2EyPOVU+ppSON6v1oTQpWcS4ro+aDsqmprA8PT
         aq0QV/0nr7CqupT1NGcAQY6MlcI1v6Fl4qcwWof/s1hdbPWSmIIDfMa9A3MR2Cgv/29q
         JQcvZqiUEAdhodASTWHrvt1NJrxKH3gyeH4NvEJkZxuT1M909u7gN80iuPaKQOq5zJGu
         qGnQ==
X-Gm-Message-State: AOAM5313JDR18Ew2bd5nPfrKTN8quCuhv8WM+8bYWuWc2IwpafM2i1PB
        fKHxZ9mrGCoYKeTeCluJItDAArV7s2Ao+MfD8+GWqqwvduauPNziYGl6yPwMPoIMiQVTVYGaaO8
        GM74VapD17ZvGMpS/
X-Received: by 2002:adf:a350:: with SMTP id d16mr23794020wrb.207.1625844782001;
        Fri, 09 Jul 2021 08:33:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxksxIq/odUSA7gynJBOKcdAhhT5GLgZ5IOMfz04TGNd7PTKbypxiLhm1u+GfcAxmbvBK2hgw==
X-Received: by 2002:adf:a350:: with SMTP id d16mr23793986wrb.207.1625844781716;
        Fri, 09 Jul 2021 08:33:01 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-171.dyn.eolo.it. [146.241.112.171])
        by smtp.gmail.com with ESMTPSA id l16sm13037067wmj.47.2021.07.09.08.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 08:33:01 -0700 (PDT)
Message-ID: <e425920ed8120597a3a2c129c5a19fa1bc4854a2.camel@redhat.com>
Subject: Re: [RFC PATCH 2/3] veth: make queues nr configurable via kernel
 module params
From:   Paolo Abeni <pabeni@redhat.com>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Fri, 09 Jul 2021 17:33:00 +0200
In-Reply-To: <875yxjvl73.fsf@toke.dk>
References: <cover.1625823139.git.pabeni@redhat.com>
         <480e7a960c26c9ab84efe59ed706f1a1a459d38c.1625823139.git.pabeni@redhat.com>
         <875yxjvl73.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-07-09 at 12:24 +0200, Toke Høiland-Jørgensen wrote:
> Paolo Abeni <pabeni@redhat.com> writes:
> 
> > This allows configuring the number of tx and rx queues at
> > module load time. A single module parameter controls
> > both the default number of RX and TX queues created
> > at device registration time.
> > 
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  drivers/net/veth.c | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> > 
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index 10360228a06a..787b4ad2cc87 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -27,6 +27,11 @@
> >  #include <linux/bpf_trace.h>
> >  #include <linux/net_tstamp.h>
> >  
> > +static int queues_nr	= 1;
> > +
> > +module_param(queues_nr, int, 0644);
> > +MODULE_PARM_DESC(queues_nr, "Max number of RX and TX queues (default = 1)");
> 
> Adding new module parameters is generally discouraged. Also, it's sort
> of a cumbersome API that you'll have to set this first, then re-create
> the device, and then use channels to get the number you want.
> 
> So why not just default to allocating num_possible_cpus() number of
> queues? Arguably that is the value that makes the most sense from a
> scalability point of view anyway, but if we're concerned about behaviour
> change (are we?), we could just default real_num_*_queues to 1, so that
> the extra queues have to be explicitly enabled by ethtool?

I was concerned by the amount of memory wasted memory (should be ~256
bytes per rx queue, ~320 per tx, plus the sysfs entries).

real_num_tx_queue > 1 will makes the xmit path slower, so we likely
want to keep that to 1 by default - unless the userspace explicitly set
numtxqueues via netlink.

Finally, a default large num_tx_queue slows down device creation:

cat << ENDL > run.sh
#!/bin/sh
MAX=$1
for I in `seq 1 $MAX`; do
	ip link add name v$I type veth peer name pv$I
done
for I in `seq 1 $MAX`; do
	ip link del dev v$I
done
ENDL
chmod a+x run.sh

# with num_tx_queue == 1
time ./run.sh 100 
real	0m2.276s
user	0m0.107s
sys	0m0.162s

# with num_tx_queue == 128
time ./run.sh 100 1
real	0m4.199s
user	0m0.091s
sys	0m1.419s

# with num_tx_queue == 4096
time ./run.sh 100 
real	0m24.519s
user	0m0.089s
sys	0m21.711s

Still, if there is agreement I can switch to num_possible_cpus default,
plus some trickery to keep real_num_{r,t}x_queue unchanged.

WDYT?

Thanks!

Paolo

