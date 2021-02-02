Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4778530B52D
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 03:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhBBCVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 21:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbhBBCVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 21:21:15 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC226C06174A
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 18:20:34 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id i63so13309577pfg.7
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 18:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aoi4STGhC7DqfLvUrDO0L774tM40LtkIhK/fvs2jegk=;
        b=JKifz4n4SmcWWC2N97vf9QKzdX7YgjfPI2Hh9vP7RQlvgw83vpg6LlunN3Hxu8fRSn
         PaZpYDNFplRfC0fbl1o3HjgxInfgNm2ZMWtFgNywKCzIgZSkjV6hbaCShwDXe3DBspg2
         DVr4SSXT/8sqd3TuhzIkQSzahBjNItepueKe/3xWT5NGy4i9wjxuID7YHEhXjGOIJ8V/
         VlYaQaWes5tmxM6bXDeEjG3d66vcPKPdFSKXeW/te/GATbs4DY9b/0qmqiHaqDHZ7uJd
         8ySdbsxwbqpY5d1oR4L6UJuytIq6OD1lfV3XRsI0Fz3OLFrAZICOCaZhX8bSUAGSwOnh
         9A5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aoi4STGhC7DqfLvUrDO0L774tM40LtkIhK/fvs2jegk=;
        b=ONbFo9vqTf7hni2adw92pfjFarXTXgYTJTQUe7oVv8b20UaDLG87Oxg3D4CzPee6ZK
         Ew8KrvEa2b/cSSz3eYq1chZfIjAvROwd6gftYTHJA6dPPZHPtMyKmfiognPZTA0usfA+
         awuLNzkFv2W/ym1ocQK6I+8lyhD9VEBf6A4DQYSxlWjm89rmLsgYsmKcqpvFXYC74toS
         3WeS9xeZ7Rd7P+rSCU+C6ritqikOvmWKX/Uww75PVFiFv5uFepH45of+lHFpHd7cWmXu
         RBb2F9uM3dUroukt6K9oH2XIPd9HIhecDdXCysLoBXhb7fVv5jkqSKbkNFIr1JHE9gN5
         O5+w==
X-Gm-Message-State: AOAM533EH01AQUQM0UMpJzH3+Mjq9fqqjiiYxod/o2ILNhqbQHjX7Q+L
        0dvw3bELUJpWVSFJFrDHFLe73QChUR9ve4Pz6ZzbZQ==
X-Google-Smtp-Source: ABdhPJyjZYKOFqwgOKNoLdgXlCoEftrCERKzucRdWiPXokDAT+gHP0FQZl8iwuAY+XFPzNhk4BJEruGccZN3mGzDRtM=
X-Received: by 2002:a65:418b:: with SMTP id a11mr19844661pgq.231.1612232434287;
 Mon, 01 Feb 2021 18:20:34 -0800 (PST)
MIME-Version: 1.0
References: <20210121004148.2340206-1-arjunroy.kdev@gmail.com>
 <20210121004148.2340206-3-arjunroy.kdev@gmail.com> <20210122200723.50e4afe6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a18cbf73-1720-dec0-fbc6-2e357fee6bd8@gmail.com> <20210125061508.GC579511@unreal>
 <ad3d4a29-b6c1-c6d2-3c0f-fff212f23311@gmail.com>
In-Reply-To: <ad3d4a29-b6c1-c6d2-3c0f-fff212f23311@gmail.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Mon, 1 Feb 2021 18:20:23 -0800
Message-ID: <CAOFY-A2y20N9mUDgknbqM=tR0SA6aS6aTjyybggWNa8uY2=U_Q@mail.gmail.com>
Subject: Re: [net-next v2 2/2] tcp: Add receive timestamp support for receive zerocopy.
To:     David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 6:06 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/24/21 11:15 PM, Leon Romanovsky wrote:
> > On Fri, Jan 22, 2021 at 10:55:45PM -0700, David Ahern wrote:
> >> On 1/22/21 9:07 PM, Jakub Kicinski wrote:
> >>> On Wed, 20 Jan 2021 16:41:48 -0800 Arjun Roy wrote:
> >>>> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> >>>> index 768e93bd5b51..b216270105af 100644
> >>>> --- a/include/uapi/linux/tcp.h
> >>>> +++ b/include/uapi/linux/tcp.h
> >>>> @@ -353,5 +353,9 @@ struct tcp_zerocopy_receive {
> >>>>    __u64 copybuf_address;  /* in: copybuf address (small reads) */
> >>>>    __s32 copybuf_len; /* in/out: copybuf bytes avail/used or error */
> >>>>    __u32 flags; /* in: flags */
> >>>> +  __u64 msg_control; /* ancillary data */
> >>>> +  __u64 msg_controllen;
> >>>> +  __u32 msg_flags;
> >>>> +  /* __u32 hole;  Next we must add >1 u32 otherwise length checks fail. */
> >>>
> >>> Well, let's hope nobody steps on this landmine.. :)
> >>>
> >>
> >> Past suggestions were made to use anonymous declarations - e.g., __u32
> >> :32; - as a way of reserving the space for future use. That or declare
> >> '__u32 resvd', check that it must be 0 and makes it available for later
> >> (either directly or with a union).
> >
> > This is the schema (reserved field without union) used by the RDMA UAPIs from
> > the beginning (>20 years already) and it works like a charm.
> >
> > Highly recommend :).
> >
>
> agreed.
>
> Arjun: would you mind following up with a patch to make this hole
> explicit and usable for the next extension? Thanks,

Will do.

-Arjun
