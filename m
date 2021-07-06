Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEAC3BD953
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 17:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhGFPFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 11:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbhGFPFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 11:05:32 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8408C061788;
        Tue,  6 Jul 2021 07:04:43 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id t3so28162311edc.7;
        Tue, 06 Jul 2021 07:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P2YpnvVFTcqnm3T4OIfBBmLwbYwnj6OekGoEs3hm+8A=;
        b=Pg7vg6d+zq8rYY/qr+eHDhCTW68T8Soz3s3tjrtXpNb1DV60YocaZhaQUk6ux+0p92
         ZTaLD7IB5BGvkRyqG8rh4abSfhPIOwU5QIKetcmvk6TH4zrhrRLIMeuQ72JdsVdAtva4
         hM6myJEG+5YU51IsKhEp8N/h3Vg3AGxC9waCWayc8KDBvAeCjv3IkA64YgI+RAkA3Md4
         5Cp2K2YjsRtIQMc2gDrWUywbgRtEI2cGW8cnRSPNFmF8ouObi0QGPKu9ECxHaj9FOB3J
         UrZoYqDs3vemaJJJsROfERcK1rX4kziCwUl4Ic5HaCQJms+8KJkeFDnDHhEoF7v2OjpH
         VZEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P2YpnvVFTcqnm3T4OIfBBmLwbYwnj6OekGoEs3hm+8A=;
        b=sw2TmDmDYoh6CyLrn1Ko/PJhhkNck5bnShaCgEvMYRIR8j6pUhfUKZXivwnxdztZnN
         +kQzVYeJbuuca3FPmRE2XsNobVygswoNEpVyYqqBzY2Zya4Btmw9IQzJjP7pjofWFBCK
         ZnEqGspDfCCBFo3X9gYjwUbz45Y4Lc6wYLtWHlxnmqvk04F33FsJszeoyCYUyn2lLXey
         0qS2HTse3vfXZ6mpAlxFwNa4OdLTrPgFsKVpB8e6asELnCpFxJf4v4MkGw0GaNiUqR29
         GnVFZ1L27p7XleSq5s647dLxY5zjHcIF3U2363LFeA+SNDENlVl1YrYu54rQGF7XEE40
         o20Q==
X-Gm-Message-State: AOAM530MtQ9tVS3Be4P5hX9q7eiBy5Is0306aJjySlDoLI/Bzk5UkO2o
        /h96D06HTR3x/rrTC3w9Ab9VqBB91a/UQKbZvZA=
X-Google-Smtp-Source: ABdhPJw8z0ZSaEn+fu6H7vuSFPmrvSZlGm3Ck8hqWZBKEnzeW15b5CXKFpd/vYCvqqjqkZSNNIZoDmv1RtM8i7kvyqA=
X-Received: by 2002:aa7:d554:: with SMTP id u20mr23354485edr.50.1625580282310;
 Tue, 06 Jul 2021 07:04:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1623674025.git.lorenzo@kernel.org> <1316f3ef2763ff4c02244fb726c61568c972514c.1623674025.git.lorenzo@kernel.org>
 <CAKgT0Ue7TsgwbQF+mfeDB-18Q-R29YZWe=y6Kgeg0xxbwds=vw@mail.gmail.com>
 <YNsVcy8e4Mgyg7g3@lore-desk> <CAKgT0Ucg5RbzKt63u5RfXee94kd+1oJ+o_qgUwCwnVCoQjDdPw@mail.gmail.com>
 <YOMq0WRu4lsGZJk2@lore-desk> <CAKgT0Udn90g9s3RYiGA0hFz7bXaepPNJNqgRjMtwjpdj1zZTDw@mail.gmail.com>
 <YORELD7ve/RMYsua@lore-desk>
In-Reply-To: <YORELD7ve/RMYsua@lore-desk>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 6 Jul 2021 07:04:31 -0700
Message-ID: <CAKgT0UceWvSzYrt=0cJTqjhTE6CHiuo0nXV+YG+1qc9Nr2bJZg@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 02/14] xdp: introduce flags field in xdp_buff/xdp_frame
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 6, 2021 at 4:53 AM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> > On Mon, Jul 5, 2021 at 8:52 AM Lorenzo Bianconi
> > <lorenzo.bianconi@redhat.com> wrote:
> > >
> > > > On Tue, Jun 29, 2021 at 5:43 AM Lorenzo Bianconi
> > > > <lorenzo.bianconi@redhat.com> wrote:
>
> [...]
> >
> > Hi Lorenzo,
> >
> > What about doing something like breaking up the type value in
> > xdp_mem_info? The fact is having it as an enum doesn't get us much
> > since we have a 32b type field but are only storing 4 possible values
> > there currently
> >
> > The way I see it, scatter-gather is just another memory model
> > attribute rather than being something entirely new. It makes as much
> > sense to have a bit there for MEM_TYPE_PAGE_SG as it does for
> > MEM_TYPE_PAGE_SHARED. I would consider either splitting the type field
> > into two 16b fields. For example you might have one field that
> > describes the source pool which is currently either allocated page
> > (ORDER0, SHARED), page_pool (PAGE_POOL), or XSK pool (XSK_BUFF_POOL),
> > and then two flags for type with there being either shared and/or
> > scatter-gather.
>
> Hi Alex,
>
> I am fine reducing the xdp_mem_info size defining type field as u16 instead of
> u32 but I think mb is a per-xdp_buff/xdp_frame property since at runtime we can
> receive a tiny single page xdp_buff/xdp_frame and a "jumbo" xdp_buff/xdp_frame
> composed by multiple pages. According to the documentation available in
> include/net/xdp.h, xdp_rxq_info (where xdp_mem_info is contained for xdp_buff)
> is "associated with the driver level RX-ring queues and it is information that
> is specific to how the driver have configured a given RX-ring queue" so I guess
> it is a little bit counterintuitive to add this info there.

It isn't really all that counterintuitive. However it does put the
onus on the driver to be consistent about things. So even a
single-buffer xdp_buff would technically have to be a scatter-gather
buff, but it would have no fragments in it. So the requirement would
be to initialize the frags and data_len fields to 0 for all xdp_buff
structures.

> Moreover we have the "issue" for devmap in dev_map_bpf_prog_run() when we
> perform XDP_REDIRECT with the approach you proposed and last we can reuse this
> new flags filed for XDP hw-hints support.
> What about reducing xdp_mem_info and add the flags field in xdp_buff/xdp_frame
> in order to avoid increasing the xdp_buff/xdp_frame size? Am I missing
> something?

The problem is there isn't a mem_info field in the xdp_buff. It is in
the Rx queue info structure.

Thanks,

- Alex
