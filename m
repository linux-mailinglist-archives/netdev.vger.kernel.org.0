Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9F635E753
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348136AbhDMTxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:53:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44211 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236723AbhDMTxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 15:53:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618343589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PgxG98RIEr3wCT1TwIssbfw/Fb5NwDAXhW1pDV2SLkI=;
        b=KQGyyBbxiQ8EKwJEJAu7gfYdumNnvoCpnvEnTJdKpZp3S6cvCqD9J/Rix6Mqy2ZR4cQbDf
        1EoIVJ9P3pDiJGfomCXDPiMlKJn0g+IXQkoWo5sLM2nkzfzEhxb4izTPeQsMm49QK/45fV
        9A5K5RNUOW9Mm9FXQM5XNHBneGMzJvc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-bNy_axEaPGG01nK87VXvHg-1; Tue, 13 Apr 2021 15:53:07 -0400
X-MC-Unique: bNy_axEaPGG01nK87VXvHg-1
Received: by mail-wm1-f70.google.com with SMTP id u11-20020a05600c00cbb029012a3f52677dso1558548wmm.8
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 12:53:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PgxG98RIEr3wCT1TwIssbfw/Fb5NwDAXhW1pDV2SLkI=;
        b=QbczipkC17lBUc2OeG1E8VuS0GT/kFqD09sD4kzTTTB1gbpZooxI9H0bHjHf2e+QhY
         mhqTXVM6XvNzJZMH6dFTiCgeTTjvEm2E60qCNu0g5YvJZ5UTVNcY+IGifhdWFwxw/SJ1
         337MukG953dNZnYncxSBXksmtW2hYnRbmz+y+ryZ7SHqjGrHgTG+eIzZnHudF+lmgio8
         qxJQWFZCAP6gvSU2ImYr5Q5QYCU2gOAQA3aWBcOrPx5avqFcnag3/If4e7vClTnp6lXt
         jreT18RmUVMnj3IWekuAsQG6JJX0IWDLFkiqBSf83Ds9H3wLyq3UWB0axvk4VUm7SKJB
         X1ug==
X-Gm-Message-State: AOAM531acKi09IYjUFFLX7l2tjX+q9cWhEdLFHPVpbuRczy16WHMeQzd
        t832d5/pUIfc2xpqt34/dCEbkzSOb2OtDUOnrNAJJ//IpoxaqmLioCECPJodg/FhVcJQxJHRH8G
        GzHXv/2F/TeI+Gck3
X-Received: by 2002:a05:600c:b4b:: with SMTP id k11mr1571295wmr.180.1618343586103;
        Tue, 13 Apr 2021 12:53:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlmN7KaZKdITDxZqR2cpHlOrzpfnuJ/uAOJzQ9V0l+bBdQa1ahISUDELIG3Q25KPQ4au2brg==
X-Received: by 2002:a05:600c:b4b:: with SMTP id k11mr1571284wmr.180.1618343585950;
        Tue, 13 Apr 2021 12:53:05 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id a15sm20955449wrr.53.2021.04.13.12.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 12:53:05 -0700 (PDT)
Date:   Tue, 13 Apr 2021 15:53:02 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC v2 1/4] virtio: fix up virtio_disable_cb
Message-ID: <20210413153951-mutt-send-email-mst@kernel.org>
References: <20210413054733.36363-1-mst@redhat.com>
 <20210413054733.36363-2-mst@redhat.com>
 <CA+FuTSe_SjUY4JxR6G9b8a0nx-MfQOkLdHJSzmjpuRG4BvsVPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSe_SjUY4JxR6G9b8a0nx-MfQOkLdHJSzmjpuRG4BvsVPw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 10:01:11AM -0400, Willem de Bruijn wrote:
> On Tue, Apr 13, 2021 at 1:47 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > virtio_disable_cb is currently a nop for split ring with event index.
> > This is because it used to be always called from a callback when we know
> > device won't trigger more events until we update the index.  However,
> > now that we run with interrupts enabled a lot we also poll without a
> > callback so that is different: disabling callbacks will help reduce the
> > number of spurious interrupts.
> 
> The device may poll for transmit completions as a result of an interrupt
> from virtnet_poll_tx.
> 
> As well as asynchronously to this transmit interrupt, from start_xmit or
> from virtnet_poll_cleantx as a result of a receive interrupt.
> 
> As of napi-tx, transmit interrupts are left enabled to operate in standard
> napi mode. While previously they would be left disabled for most of the
> time, enabling only when the queue as low on descriptors.
> 
> (in practice, for the at the time common case of split ring with event index,
> little changed, as that mode does not actually enable/disable the interrupt,
> but looks at the consumer index in the ring to decide whether to interrupt)
> 
> Combined, this may cause the following:
> 
> 1. device sends a packet and fires transmit interrupt
> 2. driver cleans interrupts using virtnet_poll_cleantx
> 3. driver handles transmit interrupt using vring_interrupt,
>     detects that the vring is empty: !more_used(vq),
>     and records a spurious interrupt.
> 
> I don't quite follow how suppressing interrupt suppression, i.e.,
> skipping disable_cb, helps avoid this.
> I'm probably missing something. Is this solving a subtly different
> problem from the one as I understand it?

I was thinking of this one:

 1. device is sending packets
 2. driver cleans them at the same time using virtnet_poll_cleantx
 3. device fires transmit interrupts
 4. driver handles transmit interrupts using vring_interrupt,
     detects that the vring is empty: !more_used(vq),
     and records spurious interrupts.


but even yours is also fixed I think.

The common point is that a single spurious interrupt is not a problem.
The problem only exists if there are tons of spurious interrupts with no
real ones. For this to trigger, we keep polling the ring and while we do
device keeps firing interrupts. So just disable interrupts while we
poll.



> > Further, if using event index with a packed ring, and if being called
> > from a callback, we actually do disable interrupts which is unnecessary.
> >
> > Fix both issues by tracking whenever we get a callback. If that is
> > the case disabling interrupts with event index can be a nop.
> > If not the case disable interrupts. Note: with a split ring
> > there's no explicit "no interrupts" value. For now we write
> > a fixed value so our chance of triggering an interupt
> > is 1/ring size. It's probably better to write something
> > related to the last used index there to reduce the chance
> > even further. For now I'm keeping it simple.
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

