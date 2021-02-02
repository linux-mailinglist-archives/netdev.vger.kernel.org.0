Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D38430CF77
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 23:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbhBBWzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 17:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbhBBWzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 17:55:45 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55696C061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 14:55:05 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id x81so21616719qkb.0
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 14:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5yaG608wQmqHaJSn2JjM2UB9iAVHtkgT98hUjwQKAd0=;
        b=ErM3kpUAZ+ANiUOSnbuVSxkqvQ9aZgPA9qs0C3jmT+iW2qAzP1n444ud9zBHlAHDZ1
         g4r0eCtXRrP2CRpHWPHPnTdqJVjzDmRvrKcyv6QHGPnG5pmT/4Jc8QIc/ZdWtgB/Ob3p
         bG6huWVeoMH8gxTSTQ2VNTSVS4ADj6kUcl6W+66jMCvSKMqNZzTaTG81m+iq3t132uLW
         EOsKZHpnvPIk1NCcc+EjcS4enxRh1zcBBnvIpmlf+Zg2iVHuLJOYBrBJvBO61WevLLbK
         Xc98fed2Dez3xaMe1tRnTcRHv/H4HIEvX844IPEh0JkgwiKFEpY9Ec8VWOA8Bc0sSGf3
         YC4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5yaG608wQmqHaJSn2JjM2UB9iAVHtkgT98hUjwQKAd0=;
        b=UbIl0i1MO6JtTYxk86MtXgXGTe4dEOljqHo8AW8deM/fRsZGfVPjU8apdgbiZ2R9dz
         i/Jd38/uGx7pmhwQgNO62eoA2iLLxvpuLIrdNotlNeeaAMyi894pm3EjKhPEfDg4qcoL
         /STmMOpdBQRwL60rPmuW9DDe75FA4DrVwtMRfUvy5C8Ot4tdIYfHtUpECDlQ5WteHbdx
         Z2PQTVIZG6ylNddzvjtokzjdzFGM4/ZXaEDoQNvvzPoA4GYPmjJ1kRpudMWq69xJkHBY
         8XWSr9gFt8NchaxtwG/hU3HM2hN1HshtLjTSkCXawpGVO6wxbLMw5r0msLRlcafDTD06
         5VGA==
X-Gm-Message-State: AOAM530CrHH3OuZ5VgKX5VzYNemloh47tpU0whvVAWxM2uTP33n2vxaR
        L1XEiWn3PCUCkjrAq/lSKRqW2pXyjP19kbxZQ+IS3uSSXXY=
X-Google-Smtp-Source: ABdhPJz0zuy8flfZ0s+hhxRgX4ozPyUBu3gIWuf8mGC/+p0JmTfp2FeHozZ3FHSK13X6qZyPS2TuMz4qKRApFpWDZ/Y=
X-Received: by 2002:a37:5a45:: with SMTP id o66mr23199114qkb.446.1612306504540;
 Tue, 02 Feb 2021 14:55:04 -0800 (PST)
MIME-Version: 1.0
References: <20210123195916.2765481-1-jonas@norrbonn.se> <20210123195916.2765481-16-jonas@norrbonn.se>
 <bf6de363-8e32-aca0-1803-a041c0f55650@norrbonn.se> <CAOrHB_DFv8_5CJ7GjUHT4qpyJUkgeWyX0KefYaZ-iZkz0UgaAQ@mail.gmail.com>
 <9b9476d2-186f-e749-f17d-d191c30347e4@norrbonn.se> <CAOrHB_Cyx9Xf6s63wVFo1mYF7-ULbQD7eZy-_dTCKAUkO0iViw@mail.gmail.com>
 <20210130104450.00b7ab7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAOrHB_DQTsEPEWpPVEcpSnbkLLz8eWPFvvzzO8wjuYsP4=9-QQ@mail.gmail.com>
 <20210201124414.21466bff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <03621476-ed9b-a186-3b9a-774c703c207a@norrbonn.se> <CAOrHB_D101x6H3U1e0gUZZd5-VqmPMbaczPwJY1GA=6LXGafDw@mail.gmail.com>
 <6abf8cac-becf-de6c-acf2-1c8e0c7376ca@norrbonn.se>
In-Reply-To: <6abf8cac-becf-de6c-acf2-1c8e0c7376ca@norrbonn.se>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Tue, 2 Feb 2021 14:54:53 -0800
Message-ID: <CAOrHB_DV7ygkZFSxSrHG5cEbq4UkpV5Kg89g7nj-90+ZnY=83Q@mail.gmail.com>
Subject: Re: [RFC PATCH 15/16] gtp: add ability to send GTP controls headers
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Harald Welte <laforge@gnumonks.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pravin B Shelar <pbshelar@fb.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 2, 2021 at 12:03 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>
>
>
> On 02/02/2021 07:56, Pravin Shelar wrote:
> > On Mon, Feb 1, 2021 at 9:24 PM Jonas Bonn <jonas@norrbonn.se> wrote:
> >>
> >> Hi Jakub,
> >>
> >> On 01/02/2021 21:44, Jakub Kicinski wrote:
> >>> On Sat, 30 Jan 2021 12:05:40 -0800 Pravin Shelar wrote:
> >>>> On Sat, Jan 30, 2021 at 10:44 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >>>>> On Fri, 29 Jan 2021 22:59:06 -0800 Pravin Shelar wrote:
> >>>>>> On Fri, Jan 29, 2021 at 6:08 AM Jonas Bonn <jonas@norrbonn.se> wrote:
> >>>>>> Following are the reasons for extracting the header and populating metadata.
> >>>>>> 1. That is the design used by other tunneling protocols
> >>>>>> implementations for handling optional headers. We need to have a
> >>>>>> consistent model across all tunnel devices for upper layers.
> >>>>>
> >>>>> Could you clarify with some examples? This does not match intuition,
> >>>>> I must be missing something.
> >>>>
> >>>> You can look at geneve_rx() or vxlan_rcv() that extracts optional
> >>>> headers in ip_tunnel_info opts.
> >>>
> >>> Okay, I got confused what Jonas was inquiring about. I thought that the
> >>> extension headers were not pulled, rather than not parsed. Copying them
> >>> as-is to info->opts is right, thanks!
> >>>
> >>
> >> No, you're not confused.  The extension headers are not being pulled in
> >> the current patchset.
> >>
> >> Incoming packet:
> >>
> >> ---------------------------------------------------------------------
> >> | flags | type | len | TEID | N-PDU | SEQ | Ext | EXT.Hdr | IP | ...
> >> ---------------------------------------------------------------------
> >> <--------- GTP header ------<<Optional GTP elements>>-----><- Pkt --->
> >>
> >> The "collect metadata" path of the patchset copies 'flags' and 'type' to
> >> info->opts, but leaves the following:
> >>
> >> -----------------------------------------
> >> | N-PDU | SEQ | Ext | EXT.Hdr | IP | ...
> >> -----------------------------------------
> >> <--------- GTP header -------><- Pkt --->
> >>
> >> So it's leaving _half_ the header and making it a requirement that there
> >> be further intelligence down the line that can handle this.  This is far
> >> from intuitive.
> >>
> >
> > The patch supports Echo, Echo response and End marker packet.
> > Issue with pulling the entire extension header is that it would result
> > in zero length skb, such packets can not be passed on to the upper
> > layer. That is the reason I kept the extension header in skb and added
> > indication in tunnel metadata that it is not a IP packet. so that
> > upper layer can process the packet.
> > IP packet without an extension header would be handled in a fast path
> > without any special handling.
> >
> > Obviously In case of PDU session container extension header GTP driver
> > would need to process the entire extension header in the module. This
> > way we can handle these user data packets in fastpath.
> > I can make changes to use the same method for all extension headers if needed.
> >
>
> The most disturbing bit is the fact that the upper layer needs to
> understand that part of the header info is in info->opts whereas the
> remainder is on the SKB itself.  If it is going to access the SKB
> anyway, why not just leave the entire GTP header in place and let the
> upper layer just get all the information from there?  What's the
> advantage of info->opts in this case?
>
> Normally, the gtp module extracts T-PDU's from the GTP packet and passes
> them on (after validating their IP address) to the network stack.  For
> _everything else_, it just passes them along the socket for handling
> elsewhere.
>
> It sounds like you are trying to do exactly the same thing:  extract
> T-PDU and inject into network stack for T-PDU's, and pass everything
> else to another handler.
>
> So what is different in your case from the normal case?
> - there's metadata on the packet... can't we detect this and set the
> tunnel ID from the TEID in that case?  Or can't we just always have
> metadata on the packet?
> - the upper layer handler is in kernel space instead of userspace; but
> they are doing pretty much the same thing, right?  why does the kernel
> space variant need something (info->opts) that userspace can get by without?
>
This is how OVS/eBPF abstracts tunneling implementation. Tunnel
context is represented in tunnel metadata. I am trying to integrate
GTP tunnel with LTW framework. This way we can make use of GTP tunnel
as any other LWT device.

I am fine with the GTP extension header handling that passes GTP
packet as is in case extension header. Can you make those changes in
this series and post Non RFC Patch Set.
