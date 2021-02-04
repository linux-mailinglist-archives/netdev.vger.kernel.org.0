Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357FF310074
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 00:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBDXEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 18:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbhBDXEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 18:04:33 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82937C0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 15:03:52 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id s23so3165449pgh.11
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 15:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WUUjWtZ+NjDrJFHchP9JIG7PVuJnvm0S4eG98c6ZEEY=;
        b=okYfroV9+CcBS4IFxBKGinpXUijU3lXd77wGLcUAGWGUB2Y8UNQjO6w8O8c6iEV7Te
         nbrlVW9aftCnOIrwk5ESgxRfPsONu/YqiU0x592tI7V4sLdsuHHBoy2BSVc3GF0O5HSx
         hxHIyvBsF1zWJQvonWDvQPoKlpMEQWAYbKJHTt8ngVh4ObP5SBx7g3XnJanXLt1c/ufW
         RsPijDRayr8Yl96UlBSyrfb5mdqx7L1hcqkDuRnjxZTbhbEVx/A1+WQ6Or2Ppa07c+zL
         MSNWZwsAqReVzwcWglBubbcPvRmXmX9vi1Xw6WAddNL0Xb3qjyBuytKv2NMWZ960onmF
         8zfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WUUjWtZ+NjDrJFHchP9JIG7PVuJnvm0S4eG98c6ZEEY=;
        b=TCDLWrnOkBuNBrdL1vd81DKEiKO42SvbIUIqx8omXcoFz7D0QkDrypcrRs0nUfXNWp
         xycv5YZ39YT1tf6C2qJtADzFvzIVIKWz0rVEn1Wc401OLBlKpiTE2lhBIr/grBT7xtNc
         FsmlhOlv0LDrpj/1QVHfh+5ZiHhXnG5LB03tP3dGU1d6r/XcV1LUFCZHWH5wyNqxo2dA
         9Ee6EyTOlVNPUS5ThoyaeVC3XT/H+2w9MBSxaVwODa4H0vpOW/rQGwik+/Ok20awYyAH
         41KEcSHLgXO/pxs4eMyVq92/HF+ihGs7lzOWiCiLqwbiD3PJHrh6S5cgkyJVqRaWaNp2
         sW6Q==
X-Gm-Message-State: AOAM531k/L3h+4SuFP9FfR/Qc9y14ypzvtJEJXC43aTDd8oevYaWH3hd
        MEWQIgD/eCpERHUuXNVzL7lc+Gy1kExlU2MQrroTPw==
X-Google-Smtp-Source: ABdhPJz3fyPMmwzZ2h5t2ERdhVeAWVAo0YKS67KsB+GSojtJjMbTKHJ9Ce/w0GhfNxagvhPGuySJEZbEGAuBcSNs0Rg=
X-Received: by 2002:a63:9517:: with SMTP id p23mr1275523pgd.253.1612479831810;
 Thu, 04 Feb 2021 15:03:51 -0800 (PST)
MIME-Version: 1.0
References: <20210121004148.2340206-1-arjunroy.kdev@gmail.com>
 <20210121004148.2340206-3-arjunroy.kdev@gmail.com> <20210122200723.50e4afe6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a18cbf73-1720-dec0-fbc6-2e357fee6bd8@gmail.com> <20210125061508.GC579511@unreal>
 <ad3d4a29-b6c1-c6d2-3c0f-fff212f23311@gmail.com> <CAOFY-A2y20N9mUDgknbqM=tR0SA6aS6aTjyybggWNa8uY2=U_Q@mail.gmail.com>
 <20210202065221.GB1945456@unreal>
In-Reply-To: <20210202065221.GB1945456@unreal>
From:   Arjun Roy <arjunroy@google.com>
Date:   Thu, 4 Feb 2021 15:03:40 -0800
Message-ID: <CAOFY-A0_MU3LP2HNY_5a1XZLZHDr3_9tDq6v-YB-FSJJb7508g@mail.gmail.com>
Subject: Re: [net-next v2 2/2] tcp: Add receive timestamp support for receive zerocopy.
To:     Leon Romanovsky <leon@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 10:52 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Mon, Feb 01, 2021 at 06:20:23PM -0800, Arjun Roy wrote:
> > On Mon, Feb 1, 2021 at 6:06 PM David Ahern <dsahern@gmail.com> wrote:
> > >
> > > On 1/24/21 11:15 PM, Leon Romanovsky wrote:
> > > > On Fri, Jan 22, 2021 at 10:55:45PM -0700, David Ahern wrote:
> > > >> On 1/22/21 9:07 PM, Jakub Kicinski wrote:
> > > >>> On Wed, 20 Jan 2021 16:41:48 -0800 Arjun Roy wrote:
> > > >>>> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> > > >>>> index 768e93bd5b51..b216270105af 100644
> > > >>>> --- a/include/uapi/linux/tcp.h
> > > >>>> +++ b/include/uapi/linux/tcp.h
> > > >>>> @@ -353,5 +353,9 @@ struct tcp_zerocopy_receive {
> > > >>>>    __u64 copybuf_address;  /* in: copybuf address (small reads) */
> > > >>>>    __s32 copybuf_len; /* in/out: copybuf bytes avail/used or error */
> > > >>>>    __u32 flags; /* in: flags */
> > > >>>> +  __u64 msg_control; /* ancillary data */
> > > >>>> +  __u64 msg_controllen;
> > > >>>> +  __u32 msg_flags;
> > > >>>> +  /* __u32 hole;  Next we must add >1 u32 otherwise length checks fail. */
> > > >>>
> > > >>> Well, let's hope nobody steps on this landmine.. :)
> > > >>>
> > > >>
> > > >> Past suggestions were made to use anonymous declarations - e.g., __u32
> > > >> :32; - as a way of reserving the space for future use. That or declare
> > > >> '__u32 resvd', check that it must be 0 and makes it available for later
> > > >> (either directly or with a union).
> > > >
> > > > This is the schema (reserved field without union) used by the RDMA UAPIs from
> > > > the beginning (>20 years already) and it works like a charm.
> > > >
> > > > Highly recommend :).
> > > >
> > >
> > > agreed.
> > >
> > > Arjun: would you mind following up with a patch to make this hole
> > > explicit and usable for the next extension? Thanks,
> >
> > Will do.
>
> Please pay attention that all "in" and "out" fields that marked as reserved
> should be zeroed and kernel must check "in" field to ensure future compatibility.
>
> Thanks
>

A question about the approach where we mandate it as a reserved field;
assuming in the future it is only used as an OUT field where 0 is a
meaningful no-op value, then just setting it to 0 works just fine.

But, if it's an IN or IN-OUT field, it seems like mandating that the
application set it to 0 could break the case where a future
application sets it to some non-zero value and runs on an older
kernel. And allowing it to be non-zero can maybe yield an unexpected
outcome if an old application that did not zero it runs on a newer
kernel.

So: maybe the right move is to mark it as reserved, not care what the
input value is, always set it to 0 before returning to the user, and
explicitly mandate that any future use of the field must be as an
OUT-only parameter?


Thanks,
-Arjun


> >
> > -Arjun
