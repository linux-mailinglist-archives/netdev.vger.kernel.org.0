Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12AF26D90D
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 12:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgIQKa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 06:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgIQKaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 06:30:15 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0326C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 03:30:15 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id y2so1756957ilp.7
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 03:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eIj7e3t/2LEnP8uq7RAznO9UoSe/WvEuOuC4CbDgvzk=;
        b=fndjdEXniqyyjEzYOASnozcVRrFkill2ITfkU8YmCkpepDg2bo+yT2uBCnzP7vRFBb
         b+B20r2zXu3UOea+sPnYu7WoqbTHULZf22LbCGSe/kYBkOMP2ycaGtayBzRSMq8cCg4p
         um/r3RkAk7Md4C8zzk2HE9m+nm8y+DrDXATiizDRwq8kccAWPVYAGMMnGyIhwCHyZQnL
         m2ycW9gNnLw3mcODv0dp2aY/uNpsn0HU+WJOp6ATzl21viTa9owDtasQpRndpzTM3Vhp
         Vi2BJYN9F6hVVUdBkYf17a8oVgZq5xBwDv2PeG71TJZFdWvEUZBNycEDVSSCbwCKBV9m
         +xDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eIj7e3t/2LEnP8uq7RAznO9UoSe/WvEuOuC4CbDgvzk=;
        b=ptrpE+LHuBnATeDZQjbgid6VbKKWiDCPJSdI+8A2L00KGYRIijoMG9pK4iC/2039Jl
         iZzSpxmtIUTwgND/eEqR5QdJCco5Bl8azZW3cWNPFTNvRwO31tGog36RettCLMpE4o3N
         BRV2u2ox+XqF3dhfgIRWKo3dSV3ejf/cKfG8aZHd4A+rlqANH+5/G+/9IZkV93YcFZ6u
         sbmP3U1ZiQCeznbHROf0xpW7Hudkh4AfHviUOcjpF3IdK2FzR54GRkcP8MBpZdU+8Vqb
         VDMxN4EEAuSylCpzr/VMvW2DCU9kwxE8LPyMhbJNWu/VmLQpiDTZ6Jmo70ET7RWgsF8R
         eOaw==
X-Gm-Message-State: AOAM531IWTcjUNJMJtpeYIjnErqRG2aF7xW4ZlMsRRR1yNwADAL3P8sS
        1loPalIImwAGhLEYrMwDdKfq9O1flCrcvqx4HYvAnKTR+N+qeA==
X-Google-Smtp-Source: ABdhPJzL3H7QnE90sctx/jNbkO6G3KR2DJC+7pqtnWnzb0AGpJHECzI4do0vkW0Md/RNezVWX6++tKZLCZ6LNZlichk=
X-Received: by 2002:a92:9145:: with SMTP id t66mr23811634ild.305.1600338614858;
 Thu, 17 Sep 2020 03:30:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200903121803.75fb0ade@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR18MB3298899BF15F266144EE8760C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904083709.GF2997@nanopsycho.orion> <BY5PR18MB3298EB53D2F869D64D7F534DC62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904121126.GI2997@nanopsycho.orion> <BY5PR18MB3298C4C84704BCE864133C33C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904133753.77ce6bc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALHRZuoa8crCaOAkEqyBq1DnmVqUgpv_jzQboMNZcU_3R4RGvg@mail.gmail.com>
 <20200916103430.GA2298@nanopsycho.orion> <CALHRZuru42FZUQ=8S8k2M7Xsp8_9Lh8HrDMxf8LPQmw=Svc15Q@mail.gmail.com>
 <20200917060445.GA2244@nanopsycho>
In-Reply-To: <20200917060445.GA2244@nanopsycho>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Thu, 17 Sep 2020 16:00:03 +0530
Message-ID: <CALHRZur56k2V9BMdz6DAwc4WGg=sunmWmk6ZcYHpNuNkJuaVVA@mail.gmail.com>
Subject: Re: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for Octeontx2
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 11:34 AM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Wed, Sep 16, 2020 at 07:19:36PM CEST, sundeep.lkml@gmail.com wrote:
> >On Wed, Sep 16, 2020 at 4:04 PM Jiri Pirko <jiri@resnulli.us> wrote:
> >>
> >> Mon, Sep 07, 2020 at 12:59:45PM CEST, sundeep.lkml@gmail.com wrote:
> >> >Hi Jakub,
> >> >
> >> >On Sat, Sep 5, 2020 at 2:07 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >> >>
> >> >> On Fri, 4 Sep 2020 12:29:04 +0000 Sunil Kovvuri Goutham wrote:
> >> >> > > >No, there are 3 drivers registering to 3 PCI device IDs and there can
> >> >> > > >be many instances of the same devices. So there can be 10's of instances of
> >> >> > > AF, PF and VFs.
> >> >> > >
> >> >> > > So you can still have per-pci device devlink instance and use the tracepoint
> >> >> > > Jakub suggested.
> >> >> > >
> >> >> >
> >> >> > Two things
> >> >> > - As I mentioned above, there is a Crypto driver which uses the same mbox APIs
> >> >> >   which is in the process of upstreaming. There also we would need trace points.
> >> >> >   Not sure registering to devlink just for the sake of tracepoint is proper.
> >> >> >
> >> >> > - The devlink trace message is like this
> >> >> >
> >> >> >    TRACE_EVENT(devlink_hwmsg,
> >> >> >      . . .
> >> >> >         TP_printk("bus_name=%s dev_name=%s driver_name=%s incoming=%d type=%lu buf=0x[%*phD] len=%zu",
> >> >> >                   __get_str(bus_name), __get_str(dev_name),
> >> >> >                   __get_str(driver_name), __entry->incoming, __entry->type,
> >> >> >                   (int) __entry->len, __get_dynamic_array(buf), __entry->len)
> >> >> >    );
> >> >> >
> >> >> >    Whatever debug message we want as output doesn't fit into this.
> >> >>
> >> >> Make use of the standard devlink tracepoint wherever applicable, and you
> >> >> can keep your extra ones if you want (as long as Jiri don't object).
> >> >
> >> >Sure and noted. I have tried to use devlink tracepoints and since it
> >> >could not fit our purpose I used these.
> >>
> >> Why exactly the existing TP didn't fit your need?
> >>
> >Existing TP has provision to dump skb and trace error strings with
> >error code but
> >we are trying to trace the entire mailbox flow of the AF/PF and VF
> >drivers. In particular
> >we trace the below:
> >    message allocation with message id and size at initiator.
> >    number of messages sent and total size.
> >    check message requester id, response id and response code after
> >reply is received.
> >    interrupts happened on behalf of mailboxes in the entire process
> >with source and receiver of interrupt along with isr status.
> >    error like initiator timeout waiting for response.
> >  All the above are relevant and are required for Octeontx2 only hence
> >used own tracepoints.
>
> You can still use devlink_hwmsg for the actual data exchanged between
> the driver and hw. For the rest, you can have driver-specific TPs.
>
>
I totally got your point and adding devlink to our drivers is work in progress
since we got a similar comment from Jakub for a patch previously:
https://www.mail-archive.com/netdev@vger.kernel.org/msg341414.html
All the errors in the drivers will be turned to devlink TP in future.
This patchset is a bit different since it traces mailbox messages state machine
at low level and does not even trace message data exchanged between
driver and hw.

Thanks,
Sundeep

> >
> >Thanks,
> >Sundeep
> >
> >> >
> >> >Thanks,
> >> >Sundeep
