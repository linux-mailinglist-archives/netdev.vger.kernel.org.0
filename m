Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769B22AC8DF
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 23:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730528AbgKIWwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 17:52:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33104 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729247AbgKIWwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 17:52:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604962322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qsiGvhQycC/EUjO7ZZQPowbOMUHnBX+zUYl9fAizKWY=;
        b=bB9GCx2/nZDfdjGMYTpNtom00FK9rir7dJP5TgGzoGisVaVeCJGKIZn+rBcpkfh9X1Mvrm
        WpRicR9kyNUaUrhTM2HUQimUzPTuT8c05ahV1VzctsAOLnJxdw6WPtFu5HoMFbAPGTSlyw
        HH36oQyeuODsgYKEdIEf8u9blm4Vusg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-rJIw5RSWO3-Qhldv3CfH2A-1; Mon, 09 Nov 2020 17:51:57 -0500
X-MC-Unique: rJIw5RSWO3-Qhldv3CfH2A-1
Received: by mail-wr1-f70.google.com with SMTP id k1so3563529wrg.12
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 14:51:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qsiGvhQycC/EUjO7ZZQPowbOMUHnBX+zUYl9fAizKWY=;
        b=sJ7hmKEPOFdPzm0ne1iZCc0m5ttiLOCRBnP/FQ5tDFldpPKdFXUg9ELkMOWF7+ElUf
         d+Oiu2hS3Af8RvrY06aTxSj7t/ZGtjJacaqNAqewnauPCSRIK8aH+f4lj6NIqARJCn5n
         /e1Hj/cglDKS3V6m0Os5w5NXUt7A4RLKjiQkNHBfKlCqVq+q6jXBEItBRtbqwZEG0vhK
         vDjcJSIQmNT7S2LXHV15EuQLjCnKqhrW6ZkWIYAjmQQ4Hwv6OqhgUpKAG2ncgJrnT1IV
         xsRNBAw9uzoOPIGZitUxlSssNw0Hu7oPq3FRu8/TYcyWjB1tDg3wbBxSk2Yz4kzHu+AK
         Iz3A==
X-Gm-Message-State: AOAM531hkwNf3lz3TZFmLHVooNBPtlJNE2gy4P+4WOkIduqTftYk1bVR
        OETIOREVKla4Q/zW/2QaNYTzhrdRC6YW1HVSIF/GN/lZcDgl5MlVviA/39tpJ+SfeRiCzkXfeGJ
        iPeHHeikpAXdXS4w/
X-Received: by 2002:a1c:2ecf:: with SMTP id u198mr1441962wmu.61.1604962316332;
        Mon, 09 Nov 2020 14:51:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJworRSodVbf+hwj2XOmqg2z2SQimxmJMpsisn5UHEkJk+6X/vQMUhXb9pv3lZys1WbwOjvJGw==
X-Received: by 2002:a1c:2ecf:: with SMTP id u198mr1441954wmu.61.1604962316097;
        Mon, 09 Nov 2020 14:51:56 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id u202sm931552wmu.23.2020.11.09.14.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 14:51:54 -0800 (PST)
Date:   Mon, 9 Nov 2020 23:51:53 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [RFC PATCH 0/2] add ppp_generic ioctl to bridge channels
Message-ID: <20201109225153.GL2366@linux.home>
References: <20201106181647.16358-1-tparkin@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106181647.16358-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 06:16:45PM +0000, Tom Parkin wrote:
> This small RFC series implements a suggestion from Guillaume Nault in
> response to my previous submission to add an ac/pppoe driver to the l2tp
> subsystem[1].
> 
> Following Guillaume's advice, this series adds an ioctl to the ppp code
> to allow a ppp channel to be bridged to another.  Quoting Guillaume:
> 
> "It's just a matter of extending struct channel (in ppp_generic.c) with
> a pointer to another channel, then testing this pointer in ppp_input().
> If the pointer is NULL, use the classical path, if not, forward the PPP
> frame using the ->start_xmit function of the peer channel."
> 
> This allows userspace to easily take PPP frames from e.g. a PPPoE
> session, and forward them over a PPPoL2TP session; accomplishing the
> same thing my earlier ac/pppoe driver in l2tp did but in much less code!

Nice to see this RFC. Thanks!

> Since I am not an expert in the ppp code, this patch set is RFC to
> gather any comments prior to making a proper submission.  I have tested
> this code using go-l2tp[2] and l2tp-ktest[3], but I have some
> uncertainties about the current implementation:
> 
>  * I believe that the fact we're not explicitly locking anything in the
>    ppp_input path for access to the channel bridge field is OK since:
>    
>     - ppp_input is called from the socket backlog recv
> 
>     - pppox_unbind (which calls ppp_channel_unregister, which unsets the
>       channel bridge field) is called from the socket release
> 
>    As such I think the bridge pointer cannot change in the recv
>    path since as the pppoe.c code says: "Semantics of backlog rcv
>    preclude any code from executing in lock_sock()/release_sock()
>    bounds".

But ppp_input() is used beyond pppoe. For example, I'm pretty sure these
pre-conditions aren't met for L2TP (pppol2tp_recv() processes packets
directly, packets aren't queued by sk_receive_skb()).

To avoid locking the channel bridge in the data path, you can protect
the pointer with RCU.

>  * When userspace makes a PPPIOCBRIDGECHAN ioctl call, the channel the
>    ioctl is called on is updated to point to the channel identified
>    using the index passed in the ioctl call.
> 
>    As such, allow PPP frames to pass in both directions from channel A
>    to channel B, userspace must call ioctl twice: once to bridge A to B,
>    and once to bridge B to A.
> 
>    This approach makes the kernel coding easier, because the ioctl
>    handler doesn't need to do anything to lock the channel which is
>    identified by index: it's sufficient to find it in the per-net list
>    (under protection of the list lock) and take a reference on it.
> 
>    The downside is that userspace must make two ioctl calls to fully set
>    up the bridge.

That's probably okay, but that'd allow for very strange setups, like
channel A pointing to channel B and channel B being used by a PPP unit.
I'd prefer to avoid having to think about such scenarios when reasoning
about the code.

I think that the channel needs to be locked anyway to safely modify the
bridge pointer. So the "no lock needed" benefit of the 2 ioctl calls
approach doesn't seem to stand.

> Any comments on the design welcome, especially thoughts on the two
> points above.

I haven't been go through all the details yet, but the general design
looks good to me. I'll comment inline for more precise feedbacks.

BTW, shouldn't we have an "UNBRIDGE" command to remove the bridge
between two channels?

> Thanks :-)
> 
> [1]. Previous l2tp ac/pppoe patch set:
> 
> https://lore.kernel.org/netdev/20200930210707.10717-1-tparkin@katalix.com/
> 
> [2]. go-l2tp: a Go library for building L2TP applications on Linux
> systems, support for the PPPIOCBRIDGECHAN ioctl is on a branch:
> 
> https://github.com/katalix/go-l2tp/tree/tp_002_pppoe_2
> 
> [3]. l2tp-ktest: a test suite for the Linux Kernel L2TP subsystem
> 
> https://github.com/katalix/l2tp-ktest
> 
> Tom Parkin (2):
>   ppp: add PPPIOCBRIDGECHAN ioctl
>   docs: update ppp_generic.rst to describe ioctl PPPIOCBRIDGECHAN
> 
>  Documentation/networking/ppp_generic.rst |  5 ++++
>  drivers/net/ppp/ppp_generic.c            | 35 +++++++++++++++++++++++-
>  include/uapi/linux/ppp-ioctl.h           |  1 +
>  3 files changed, 40 insertions(+), 1 deletion(-)
> 
> -- 
> 2.17.1
> 

