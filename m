Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EDD1AC6D5
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 16:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394007AbgDPOpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 10:45:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58025 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2898880AbgDPN7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 09:59:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587045584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/fp2UUoqV6fjSf3Fv842n0jm7zbl47NciGPGYI/kg5Y=;
        b=F+fP/Cur8fuevX3Aki79J6FH6SWxYipf/nH8xrTPSZbjnggA7so514gaw7qeQ8P9sEme2S
        dvFJQhRk7dSuD2lLFcSoN8yO8TfgxsfjJfdu7Dyz1jDZIvH3BBigAYBqeLDlVZlp3OFdX0
        7a9lYSXgR+C5Yi2WoROhstEr9mLpyGo=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-vytyC8UIPRipvBxvg8-2fA-1; Thu, 16 Apr 2020 09:59:42 -0400
X-MC-Unique: vytyC8UIPRipvBxvg8-2fA-1
Received: by mail-lf1-f71.google.com with SMTP id y19so2319934lfk.13
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 06:59:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/fp2UUoqV6fjSf3Fv842n0jm7zbl47NciGPGYI/kg5Y=;
        b=tOgJo5Sia15f/GjngCeYnBwYWereejdqCtdgYFuyS/vI2Wn4B7eBU/n14PXnuqJRvv
         dcJl/IXQNjOPDt4r7b8DK3dtkuwcC8yvB5ckE9X9arTwI4/HVon/ATVuggpo5W9D5dZ/
         8n10WtJpDsMa0maqzqD2ucq+HA379f8ZN3gV4RaVyVHid/XZ4eTzqRzQYL0Nnsc/H2In
         2wDI+/GWM4MgPF/MaE25a9hW6ZejqCk7aJSvkejA71i9avQADuGOx4dGfK492kUS4RGz
         YdtEvfDbkezIaRpKarCibV0y8NJ1jeeFZhz8uGcdGxRszJJLU3TOBr5nyBL50ifIJRYE
         /s/g==
X-Gm-Message-State: AGi0PubQaBSMI+KF6a91vckcBbLj9i0p47emuzvDQwSVOJ+/a8hiuKm8
        /gE9ZMHiJt54b+QUoGsU6zAIVyDCIiAIY0IbSUDIMM2JrogYROI3kmKhDcszaFzrUI0mVXvPSQs
        WVXeYTU5APiaSBexO
X-Received: by 2002:a2e:7e03:: with SMTP id z3mr6702208ljc.200.1587045581286;
        Thu, 16 Apr 2020 06:59:41 -0700 (PDT)
X-Google-Smtp-Source: APiQypI8e11YaadHSkOqEtQFBwpEdiyMnnRxx95rWFqKGcVjFRVkGpiyJxXqMSg1uvXghYtKIoRCDQ==
X-Received: by 2002:a2e:7e03:: with SMTP id z3mr6702195ljc.200.1587045581046;
        Thu, 16 Apr 2020 06:59:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 23sm14173886ljr.32.2020.04.16.06.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 06:59:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5F6B4181587; Thu, 16 Apr 2020 15:59:39 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
Subject: Re: [PATCH RFC-v5 bpf-next 00/12] Add support for XDP in egress path
In-Reply-To: <20200413171801.54406-1-dsahern@kernel.org>
References: <20200413171801.54406-1-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 16 Apr 2020 15:59:39 +0200
Message-ID: <87pnc7lees.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> From: David Ahern <dsahern@gmail.com>
>
> This series adds support for XDP in the egress path by introducing
> a new XDP attachment type, BPF_XDP_EGRESS, and adding a UAPI to
> if_link.h for attaching the program to a netdevice and reporting
> the program. bpf programs can be run on all packets in the Tx path -
> skbs or redirected xdp frames. The intent is to emulate the current
> RX path for XDP as much as possible to maintain consistency and
> symmetry in the 2 paths with their APIs.
>
> This is a missing primitive for XDP allowing solutions to build small,
> targeted programs properly distributed in the networking path allowing,
> for example, an egress firewall/ACL/traffic verification or packet
> manipulation and encapping an entire ethernet frame whether it is
> locally generated traffic, forwarded via the slow path (ie., full
> stack processing) or xdp redirected frames.
>
> Nothing about running a program in the Tx path requires driver specific
> resources like the Rx path has. Thus, programs can be run in core
> code and attached to the net_device struct similar to skb mode. The
> existing XDP_FLAGS_*_MODE are not relevant at the moment, so none can
> be set in the attach. XDP_FLAGS_HW_MODE can be used in the future
> (e.g., the work on offloading programs from a VM).
>
> The locations chosen to run the egress program - __netdev_start_xmit
> before the call to ndo_start_xmit and bq_xmit_all before invoking
> ndo_xdp_xmit - allow follow on patch sets to handle tx queueing and
> setting the queue index if multi-queue with consistency in handling
> both packet formats.

I like the choice of hook points. It is interesting that it implies that
there will not be not a separate "XDP generic" hook on egress. And it's
certainly a benefit to not have to change all the drivers. So that's
good :)

I also think it'll be possible to get the information we want (such as
TXQ fill level) at the places you put the hooks. For the skb case
through struct netdev_queue and BQL, and for REDIRECT presumably with
Magnus' queue abstraction once that lands. So overall I think we're
getting there :)

I'll add a few more comments for each patch...

-Toke

