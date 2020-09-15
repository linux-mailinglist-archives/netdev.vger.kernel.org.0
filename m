Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E6A26B160
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbgIOW3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727628AbgIOQSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 12:18:23 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D5EC061797
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 08:52:33 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t13so3446956ile.9
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 08:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5bN4Gitx2t/7jk6xB5oQmdQ699PApOvwciF8USGYv3M=;
        b=jMLorCYJPV2tkld/VNrA3E/c4Fpy9S8AawsX0mWVsXqNrXY9VoeRnRfgERJNcHVMCa
         bU+5rDAzYGzCY6V3MkniEqABpM/FEbHGVz8bSLAfZjgZBQHkYyyGkDlHZOvaITa8sUdW
         M5S+3nseQCPbHeKNE1TB44ZrfOGq4PSCikQEbdVtmTtFAhOIAFMaOflp7p8gI2cbTCWz
         4ygZQfgPF0bVgG/TkMdsAKRKalCPdFvW1XR7XK6HEgPpw3b+meDrXatYnEmXfwltJQTD
         4ubdtjC6i+H55Wv4TPIWnT++fo/gbsVOPu3RlakmCFIQ6UpbvX1oL6Ot+Btn3/1p34B2
         7Rsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5bN4Gitx2t/7jk6xB5oQmdQ699PApOvwciF8USGYv3M=;
        b=cLr9Y/6r4yoEGUq7NLiR31bPSubuN0mg71EcGEA+giPGe6upxLamTWA4V/SPdEurps
         KSiqgLtWcSLJyzsVOKVUbZLu3esSsafR04XMElpoppK4mLD6596tVPedWAXA5dbfgIhO
         wuQcpPt3Xm5alrWmtputq1FeFZRDPO1Ibws6Jht6B/chBkExrJMdpN5foeZGx07a74UO
         s/mx2p7Uh9+8GC2IYnlX9f1k4Q+oEl41TRVf0Rby7dYTHwd8GSdm1FxB9kSwlv3ilUjy
         FpXykbeyUMBBeFjgR+5UJmhBwxd9qY8RCenVh57vDJdaGDwfEuTUZmkZ/Wla/sxxE+92
         TlHg==
X-Gm-Message-State: AOAM531mSr6Ie601bYq2B4YxElC5i8n2DfJhFWqhKZTcrP7tFIi63Nrc
        2ahQf/2NOUmHN2a4HYs209HmSkna7dvKfBYaocHeOwMx/+Y=
X-Google-Smtp-Source: ABdhPJwogM0lvds/ahwJWzGq++Q1zaEQNFmFH7c5be5WOV20csm9MS4iG3klAEyFC8XnJMweicAsK1GmAmj/qvv0QDU=
X-Received: by 2002:a92:8b52:: with SMTP id i79mr17538689ild.177.1600185152537;
 Tue, 15 Sep 2020 08:52:32 -0700 (PDT)
MIME-Version: 1.0
References: <1599117498-30145-1-git-send-email-sundeep.lkml@gmail.com>
 <20200903121803.75fb0ade@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR18MB3298899BF15F266144EE8760C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904083709.GF2997@nanopsycho.orion> <BY5PR18MB3298EB53D2F869D64D7F534DC62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904121126.GI2997@nanopsycho.orion> <BY5PR18MB3298C4C84704BCE864133C33C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904133753.77ce6bc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CALHRZuoa8crCaOAkEqyBq1DnmVqUgpv_jzQboMNZcU_3R4RGvg@mail.gmail.com>
In-Reply-To: <CALHRZuoa8crCaOAkEqyBq1DnmVqUgpv_jzQboMNZcU_3R4RGvg@mail.gmail.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Tue, 15 Sep 2020 21:22:21 +0530
Message-ID: <CALHRZuo9w=NJ4B6hw4afhoY21rAbqxBTZnLKN4+A=q21wNPPjQ@mail.gmail.com>
Subject: Re: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for Octeontx2
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Mon, Sep 7, 2020 at 4:29 PM sundeep subbaraya <sundeep.lkml@gmail.com> wrote:
>
> Hi Jakub,
>
> On Sat, Sep 5, 2020 at 2:07 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri, 4 Sep 2020 12:29:04 +0000 Sunil Kovvuri Goutham wrote:
> > > > >No, there are 3 drivers registering to 3 PCI device IDs and there can
> > > > >be many instances of the same devices. So there can be 10's of instances of
> > > > AF, PF and VFs.
> > > >
> > > > So you can still have per-pci device devlink instance and use the tracepoint
> > > > Jakub suggested.
> > > >
> > >
> > > Two things
> > > - As I mentioned above, there is a Crypto driver which uses the same mbox APIs
> > >   which is in the process of upstreaming. There also we would need trace points.
> > >   Not sure registering to devlink just for the sake of tracepoint is proper.
> > >
> > > - The devlink trace message is like this
> > >
> > >    TRACE_EVENT(devlink_hwmsg,
> > >      . . .
> > >         TP_printk("bus_name=%s dev_name=%s driver_name=%s incoming=%d type=%lu buf=0x[%*phD] len=%zu",
> > >                   __get_str(bus_name), __get_str(dev_name),
> > >                   __get_str(driver_name), __entry->incoming, __entry->type,
> > >                   (int) __entry->len, __get_dynamic_array(buf), __entry->len)
> > >    );
> > >
> > >    Whatever debug message we want as output doesn't fit into this.
> >
> > Make use of the standard devlink tracepoint wherever applicable, and you
> > can keep your extra ones if you want (as long as Jiri don't object).
>
> Sure and noted. I have tried to use devlink tracepoints and since it
> could not fit our purpose I used these.
>
Can you please comment.

> Thanks,
> Sundeep
