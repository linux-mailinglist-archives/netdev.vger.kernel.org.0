Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9F0423875
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 09:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237213AbhJFHB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 03:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233968AbhJFHB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 03:01:56 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5CFC061749
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 00:00:04 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id v4so1793097vsg.12
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 00:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y6Ya0Iom0fxMwaGpSp3HDf6YGcse7Fe25+Nz13nrbWY=;
        b=VvCV3SZATO5AnJkVVcERvnt+D6JsCzs2J5qtw6kndIJ0vFTrJtvfme2jsq5/dSpMPF
         8QAolP3ChiLOyJK6eBZiMB2PsiOfuLrqqyjpJEnbDZpk5TGgfGm21FrKKaMdwUFDx2Og
         kuEVlm6tb/C7o/aIFmbXdrdcJJajhoQ8T/5EJVwZqBYLPkOLACFztOxwBMKeObzV0nW2
         9TszfX3eiwE7OPmw7nJUWO27L0lOZ48FL2KJ+5qpOUCxtFR4Maqm79GBq7RTGiwPEXxF
         IfbCmSTYK3iMWCVOdNxGmmvNa39M6jEuq0dUDj/YW3fRUnrDGWvz0vHas2kSJjLKucR5
         ning==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y6Ya0Iom0fxMwaGpSp3HDf6YGcse7Fe25+Nz13nrbWY=;
        b=M8QZ/xx18cVHO/33OLLTrp1exGtRsiC5TGXNCcvqoTPFlwKNguq+kiLifQ8EaRIj+H
         FfqiRa/Rcg+IVCYxXnU/Rtirh6z9WxrRoAYjRBCxvMdbDRmwFoAlt4DOJCT6qQRGGU3x
         2O473lkK2vldZPlfyXaUGDqHtFfpx3r9OYBBVWmNZCDzlKlyb131azaqSOUAz85upxEz
         oDuE1lHPfkkrtXX6L/2D4hyJ4ccxz3Jpbwgm/nNs5EGjMB0ucgAQj2YK+Rc0iR9JubwD
         XLrByHy9uKMXkgsI+guhK723nsXno++EusVfnksaX7lUoKVKURlFZpcPfGnXSdXO/V/n
         /j2w==
X-Gm-Message-State: AOAM532mC7ARzHC5NDGuz/oi6XSSCf3AxRrvQ/EWHNokCT8NWRVUwQFR
        H/7AmgV4JjULnmHi1XmlVNDe7r/QE63NeiPvZsX+Q1ac
X-Google-Smtp-Source: ABdhPJzLqd+2wKk6BA1bnc5c/IYxtmvj51cBbVz2qIDBvfJ860bXdpDmBc0fRLXVHl938M+dIeIV57o008DOXXGsWwE=
X-Received: by 2002:a67:e416:: with SMTP id d22mr21845038vsf.41.1633503603581;
 Wed, 06 Oct 2021 00:00:03 -0700 (PDT)
MIME-Version: 1.0
References: <1633454136-14679-1-git-send-email-sbhatta@marvell.com>
 <1633454136-14679-3-git-send-email-sbhatta@marvell.com> <20211005181157.6af1e3e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211005181157.6af1e3e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Wed, 6 Oct 2021 12:29:51 +0530
Message-ID: <CALHRZupNJC7EJAir+0iN6p4UGR0oU0by=N2Hf+zWaj2U8RrE4A@mail.gmail.com>
Subject: Re: [net-next PATCH 2/3] octeontx2-pf: Add devlink param to vary cqe size
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Wed, Oct 6, 2021 at 6:46 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 5 Oct 2021 22:45:35 +0530 Subbaraya Sundeep wrote:
> > Completion Queue Entry(CQE) is a descriptor written
> > by hardware to notify software about the send and
> > receive completion status. The CQE can be of size
> > 128 or 512 bytes. A 512 bytes CQE can hold more receive
> > fragments pointers compared to 128 bytes CQE. This
> > patch adds devlink param to change CQE descriptor
> > size.
>
> nak, this belongs in ethtool -g

We do use ethtool -G for setting the number of receive buffers to
allocate from the kernel and give those pointers to hardware memory pool(NPA).

This patch is to specify hardware the completion queue descriptor size
it needs to use
while writing to memory. The CQE consists of buffer pointer/packet addresses.
Say a large packet is received then hardware splits that large packet
into buffers
and writes only one CQE consisting of all the buffer pointers which
makes a packet.
If hardware is configured to use 128 byte CQE then only 6 pointers can
be accomodated
and rest of packet data is truncated. If CQE is configured as 512 byte
then 42 pointers
can be accomodated hence large packets can be received.
ethtool -G can be used to change number of packets a ring can hold but
not number
of fragments a single packet can use. Since this is hardware related
am using devlink.
CN9XX series hardware max packet length is 9212 and a 128 byte CQE (6
buffer pointers)
with 2K receive buffer was sufficient to receive 9212 packet (2k * 6 =
12K). CN10XX series
max receive length is 65535 so 128 byte CQE was not enough.



Thanks,
Sundeep
