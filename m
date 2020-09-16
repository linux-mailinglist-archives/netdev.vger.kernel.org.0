Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6814226CB26
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbgIPUWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbgIPR2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:28:42 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35ABBC061225
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 10:19:49 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id j2so9113880ioj.7
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 10:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z9QWQBLKVwzSm/Zoboscyj8Yu/BFKaHG3w3tS3Xur4A=;
        b=MfGfZc7554EHqtaqqURQcO03kTBY4K/81ul3FL5rihdGEQyB5MYacWy3ZCSBOLLnNN
         z0dOuO0cneQkUNI6OG22vjC1AOcsIW8I+qZB0w8DpZihY4JcZOjhnmCxCwBjzxknFYb/
         PaUoX1S5jume1bFq/LO/hq4FBT9as/e+AlbTUZZbdWTwCoxBe/tOBu1CSCyxtaxJYZUR
         xvMf+IekWrLEkZGNe+K+Chk7Zox45uzr/GESCUqHrA3h0KV9s9NC/3L557pS8gYklMRE
         Y5CowwV55Ib6PsZvZkRvgeVukvemPeP52Ttk+Ruql5QQoknq4KDVbekPxpPEUea197tr
         A36w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z9QWQBLKVwzSm/Zoboscyj8Yu/BFKaHG3w3tS3Xur4A=;
        b=Cd+IPNy7pLuEpsL6j2UN7FfablYvMgTHHrJCjQg5U6uhxS4DGdf36r0rZZ4uJmnpY5
         8y8z3pit26xL421VztKhCLZqFHeWbuoE+lD2RCYskXaqVaqzJwCy1BO5j3RjOk0ZKVuh
         t5OmFd56gRdxUY3IdgFz6GHSCI98tSheke8oZ4obXKLlFgML1gH2MbN2J5dkeklMgzMZ
         hLj0o3qLmFrzHkB93PKOQwBT451IOFfhlfKR4vuITGZb5mWfq5+r++YD/ZmXmmVcIFkY
         zWBDXz7KMt9fgAX2aUDzFC4JAFrdjJT33IQ5AkU04d4iHC/gphFUYFhmKRPE23HHO23b
         qwyw==
X-Gm-Message-State: AOAM5333pbdblNtFNWr/2CMBQ/9+JHl57hqSX6vb4CbVtjwZZqy7crjs
        e1vGQ5ukP3ZMvzjeAuaeMYHhxjtvG2qYjhaatvGRkq8gsuU=
X-Google-Smtp-Source: ABdhPJzCoCGJrG+yjgIiOUonIzew/SHAhRITgCSbZLYNnitYTTL10mtG8DGfMSFacoj5N+IyEPzb/SARFHytT5CNN4c=
X-Received: by 2002:a05:6602:2e89:: with SMTP id m9mr20356881iow.77.1600276787699;
 Wed, 16 Sep 2020 10:19:47 -0700 (PDT)
MIME-Version: 1.0
References: <1599117498-30145-1-git-send-email-sundeep.lkml@gmail.com>
 <20200903121803.75fb0ade@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR18MB3298899BF15F266144EE8760C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904083709.GF2997@nanopsycho.orion> <BY5PR18MB3298EB53D2F869D64D7F534DC62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904121126.GI2997@nanopsycho.orion> <BY5PR18MB3298C4C84704BCE864133C33C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904133753.77ce6bc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALHRZuoa8crCaOAkEqyBq1DnmVqUgpv_jzQboMNZcU_3R4RGvg@mail.gmail.com> <20200916103430.GA2298@nanopsycho.orion>
In-Reply-To: <20200916103430.GA2298@nanopsycho.orion>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Wed, 16 Sep 2020 22:49:36 +0530
Message-ID: <CALHRZuru42FZUQ=8S8k2M7Xsp8_9Lh8HrDMxf8LPQmw=Svc15Q@mail.gmail.com>
Subject: Re: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for Octeontx2
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 4:04 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Mon, Sep 07, 2020 at 12:59:45PM CEST, sundeep.lkml@gmail.com wrote:
> >Hi Jakub,
> >
> >On Sat, Sep 5, 2020 at 2:07 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >>
> >> On Fri, 4 Sep 2020 12:29:04 +0000 Sunil Kovvuri Goutham wrote:
> >> > > >No, there are 3 drivers registering to 3 PCI device IDs and there can
> >> > > >be many instances of the same devices. So there can be 10's of instances of
> >> > > AF, PF and VFs.
> >> > >
> >> > > So you can still have per-pci device devlink instance and use the tracepoint
> >> > > Jakub suggested.
> >> > >
> >> >
> >> > Two things
> >> > - As I mentioned above, there is a Crypto driver which uses the same mbox APIs
> >> >   which is in the process of upstreaming. There also we would need trace points.
> >> >   Not sure registering to devlink just for the sake of tracepoint is proper.
> >> >
> >> > - The devlink trace message is like this
> >> >
> >> >    TRACE_EVENT(devlink_hwmsg,
> >> >      . . .
> >> >         TP_printk("bus_name=%s dev_name=%s driver_name=%s incoming=%d type=%lu buf=0x[%*phD] len=%zu",
> >> >                   __get_str(bus_name), __get_str(dev_name),
> >> >                   __get_str(driver_name), __entry->incoming, __entry->type,
> >> >                   (int) __entry->len, __get_dynamic_array(buf), __entry->len)
> >> >    );
> >> >
> >> >    Whatever debug message we want as output doesn't fit into this.
> >>
> >> Make use of the standard devlink tracepoint wherever applicable, and you
> >> can keep your extra ones if you want (as long as Jiri don't object).
> >
> >Sure and noted. I have tried to use devlink tracepoints and since it
> >could not fit our purpose I used these.
>
> Why exactly the existing TP didn't fit your need?
>
Existing TP has provision to dump skb and trace error strings with
error code but
we are trying to trace the entire mailbox flow of the AF/PF and VF
drivers. In particular
we trace the below:
    message allocation with message id and size at initiator.
    number of messages sent and total size.
    check message requester id, response id and response code after
reply is received.
    interrupts happened on behalf of mailboxes in the entire process
with source and receiver of interrupt along with isr status.
    error like initiator timeout waiting for response.
  All the above are relevant and are required for Octeontx2 only hence
used own tracepoints.

Thanks,
Sundeep

> >
> >Thanks,
> >Sundeep
