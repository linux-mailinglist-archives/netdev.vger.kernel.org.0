Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F026A2AD177
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 09:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731404AbgKJIkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 03:40:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28393 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729441AbgKJIjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 03:39:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604997593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hyh7UaM+g2trOiYngrS9dlcrb+FW3phxTbIaNTk+T7A=;
        b=b9o392c8a6dLMBfCuW/vlXBKcgWWQ750CX5sv2CDbqAxeK5/Xqcru3xMRlVbF3O5sCRQ7B
        fY4qN5iUK+kl/iWedqi+V7qcZxedIB1Gb4XxUYC72dpEJJMCBmFR/kDZ26n5Rhzp/Ounmg
        GqVJHzy0MCGZekCd+E2ikGCYl1CErx4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-vVTOm1gcOzyc0M4B8uO8ew-1; Tue, 10 Nov 2020 03:39:50 -0500
X-MC-Unique: vVTOm1gcOzyc0M4B8uO8ew-1
Received: by mail-wr1-f72.google.com with SMTP id e18so5400781wrs.23
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 00:39:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hyh7UaM+g2trOiYngrS9dlcrb+FW3phxTbIaNTk+T7A=;
        b=uIEY1UbRFPN7CzE9caKyO6Z2FXKuzmIkG/HEnR1pr/DcxrBnx+LxRT51WjdjAl8FzJ
         l3nd5gQ9dCU9dLEPzQNOPDAGBDAtRaZKsF6dSHAlzf53B0M40g5q08jjXK8taOj9a0Wn
         T/z+oFeWfxoEp2d8D+8sMNyrmEN7GXpFFDxmHScxr6ecT+IEkxZKjtE51NdnKrZpR9qa
         s7L1WHG0O2701ENt/NZrsgMhNqfsEXOVjjhFH4qFfg88yWs6unWbf0wHblOePi+d0roq
         I+OgXTLSuu7sLnw7vGftxqp6qQ2Yl80z8Uy9PlZDAm1NxkErKW84DEZHHpSxRuPlWJH4
         +iMA==
X-Gm-Message-State: AOAM532nVTklOqsCqXV6JAmowN4me4/7V6djWEMfZ2ZnGAuMeiijxLSw
        cVdE6a+qLGvcH34iuMViYGJJU/3xiz2P9iBIdEjEe0nq2Z4o6rPoEUNyayXQD+iep1//mWSZSuh
        tQOf5e2+c1DlfXxSWaqBkp7NvBHm1Anq9
X-Received: by 2002:a1c:1906:: with SMTP id 6mr3356322wmz.87.1604997588697;
        Tue, 10 Nov 2020 00:39:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygpgV8AXXuqlYLBeLe3dxUBkWwtMJMFF9d1iDZ4oUQhYNTvKRIcdpuQ/GdhgZUyOjn8cfx8iWl2yN8a32afMU=
X-Received: by 2002:a1c:1906:: with SMTP id 6mr3356300wmz.87.1604997588429;
 Tue, 10 Nov 2020 00:39:48 -0800 (PST)
MIME-Version: 1.0
References: <20201109072930.14048-1-nusiddiq@redhat.com> <20201109115458.0590541b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201109115458.0590541b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Numan Siddique <nusiddiq@redhat.com>
Date:   Tue, 10 Nov 2020 14:09:37 +0530
Message-ID: <CAH=CPzpXfLLPWLgH07iEQQJQyWNCW2uv6hh7oFCe-1uVY825SQ@mail.gmail.com>
Subject: Re: [net-next] netfiler: conntrack: Add the option to set ct tcp flag
 - BE_LIBERAL per-ct basis.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     ovs dev <dev@openvswitch.org>, netdev <netdev@vger.kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 1:25 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  9 Nov 2020 12:59:30 +0530 nusiddiq@redhat.com wrote:
> > From: Numan Siddique <nusiddiq@redhat.com>
> >
> > Before calling nf_conntrack_in(), caller can set this flag in the
> > connection template for a tcp packet and any errors in the
> > tcp_in_window() will be ignored.
> >
> > A helper function - nf_ct_set_tcp_be_liberal(nf_conn) is added which
> > sets this flag for both the directions of the nf_conn.
> >
> > openvswitch makes use of this feature so that any out of window tcp
> > packets are not marked invalid. Prior to this there was no easy way
> > to distinguish if conntracked packet is marked invalid because of
> > tcp_in_window() check error or because it doesn't belong to an
> > existing connection.
> >
> > An earlier attempt (see the link) tried to solve this problem for
> > openvswitch in a different way. Florian Westphal instead suggested
> > to be liberal in openvswitch for tcp packets.
> >
> > Link: https://patchwork.ozlabs.org/project/netdev/patch/20201006083355.121018-1-nusiddiq@redhat.com/
> >
> > Suggested-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Numan Siddique <nusiddiq@redhat.com>
>
> Please repost Ccing Pablo & netfilter-devel.

Thanks. I will repost.

Numan

>

