Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F56A3C2614
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 16:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbhGIOku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 10:40:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41819 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231791AbhGIOku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 10:40:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625841486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rTGsZKDBscf5j/omVcyy3u7BgMK4Gb8z9DPenQ2VjSQ=;
        b=C+rC01JKmv+e308Ae10fWZl5s5ca7phj5V8ah/cNUyM5KIMy7FbdT+tw4si1pSrFZdW0eU
        9pmAPqaVX00G6n2vwXhMIiE7k7/xMJ601oDTtMH1TJYRzc0JEWQNw3Zvl1D+1q/qJVlPI9
        pWedfTXkZBSUHGpwJJxVooc6GxqKugo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-Kz4tVI9mM62S17YmJoQnPQ-1; Fri, 09 Jul 2021 10:38:05 -0400
X-MC-Unique: Kz4tVI9mM62S17YmJoQnPQ-1
Received: by mail-wr1-f72.google.com with SMTP id h15-20020adffd4f0000b0290137e68ed637so2965384wrs.22
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 07:38:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=rTGsZKDBscf5j/omVcyy3u7BgMK4Gb8z9DPenQ2VjSQ=;
        b=CqGqUtF78cG0WcVTWlMjy4qe9Sge1+D+L1EKgnEMrw42OcydSs1Vz/VAksifCdDT2e
         5yj/q/2TfLdpl+TZ2+4q3Vk04WkNZAmWcZnyEie92AyB71WvT+aQB6q7TYZV1zNXRxZL
         VmlrnRIL7XwPyBzZnNVz575GKRGGTCHgCEi7P5YfW2QWf8SFSOEzLQDvcmbE2o/X/n9t
         cEH4TQiel3VVXa/Qx6lEl1IawqhV2hHll+KbTkL7USsj38Ka9WKgWpCPqYvVMYBZpqEK
         5yh0rKqZ7262Zm0o9nqjCd6gq2qf9KyxGDkHtYDdDmP+eayboefsvQaP3FiEwgGNYxvC
         4btw==
X-Gm-Message-State: AOAM531pLahQc3C7zvCdqebmhLlJ2TI9O5k0ud2m64lynn49au2jM/Me
        2yH+P4B76oC4bpU4ihsYM8tee4vh/QX+p1sR9U9vlpe6fGDx7VfZVMIJP6BJoDclhaqmx5N7Wb7
        ywE6PGRL5K884deNH
X-Received: by 2002:a05:600c:364f:: with SMTP id y15mr40078803wmq.55.1625841483852;
        Fri, 09 Jul 2021 07:38:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJws/Bwp88mqJ/H2jZnpP5sor86ms9XvyENbs/56uKqNnAaoDy67YkLw58pe1b7ME2/n7fD+Lw==
X-Received: by 2002:a05:600c:364f:: with SMTP id y15mr40078785wmq.55.1625841483604;
        Fri, 09 Jul 2021 07:38:03 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-171.dyn.eolo.it. [146.241.112.171])
        by smtp.gmail.com with ESMTPSA id f14sm12100254wmq.10.2021.07.09.07.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 07:38:03 -0700 (PDT)
Message-ID: <9c451d25fb36bc82e602bb93e384b262be743fbf.camel@redhat.com>
Subject: Re: [RFC PATCH 1/3] veth: implement support for set_channel ethtool
 op
From:   Paolo Abeni <pabeni@redhat.com>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Fri, 09 Jul 2021 16:38:02 +0200
In-Reply-To: <1c3d691c01121e4110f23d5947b2809d5cce056b.camel@redhat.com>
References: <cover.1625823139.git.pabeni@redhat.com>
         <681c32be3a9172e9468893a89fb928b46c5c5ee6.1625823139.git.pabeni@redhat.com>
         <878s2fvln4.fsf@toke.dk>
         <1c3d691c01121e4110f23d5947b2809d5cce056b.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-07-09 at 12:49 +0200, Paolo Abeni wrote:
> On Fri, 2021-07-09 at 12:15 +0200, Toke Høiland-Jørgensen wrote:
> > > +	if (netif_running(dev))
> > > +		veth_close(dev);
> > > +
> > > +	priv->num_tx_queues = ch->tx_count;
> > > +	priv->num_rx_queues = ch->rx_count;
> > 
> > Why can't just you use netif_set_real_num_*_queues() here directly (and
> > get rid of the priv members as above)?
> 
> Uhm... I haven't thought about it. Let me try ;)

Here there is a possible problem: if the latter
netif_set_real_num_*_queues() fails, we should not change the current
configuration, so we should revert the
first netif_set_real_num_*_queues() change.

Even that additional revert operation could fail. If/when that happen
set_channel() will leave the device in a different state from both the
old one and the new one, possibly with an XDP-incompatible number of
queues.

Keeping the  netif_set_real_num_*_queues() calls in veth_open() avoid
the above issue: if the queue creation is problematic, the device will
stay down.

I think the additional fields are worthy, WDYT? 

Cheers,
Paolo



