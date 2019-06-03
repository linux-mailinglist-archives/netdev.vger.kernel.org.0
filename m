Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 632E433BED
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 01:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfFCXar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 19:30:47 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45784 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfFCXar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 19:30:47 -0400
Received: by mail-io1-f68.google.com with SMTP id e3so15802070ioc.12
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 16:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lH3xeV4c3dfBhzfkKadHGNAJuMPmhttMBtiqsq/ogFc=;
        b=Y64DxNeFUeeYHCVWuoQGBAU+J4/qtQDzue6HVC1gR3kmKV0sUn34MyNb89Ox79zOA6
         1RT2ePDeYkN3WGuUsvfFITQmI26uB4pStY1eN8VOKebWkiAi3Z3PISNLieRj9cUOApWv
         23gwvQHdYvKbPzxmoBQ56mskeQsYdTcvDuUBccJ/UgxD0URc2AubIGyAOvTFa419G3ow
         A/S7we4rtYsfq0D0FBUYVLvvKbgoBy0GdLhv1emarAy0wNNYtuQAuPImymhsTDqe3DMD
         0x06vo2wTDwvsiMoHuMJqk84yaK/vmQZpCeM0GDoQqDVPiUbd+xiLwp5Tljc+vVa55l4
         TzjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lH3xeV4c3dfBhzfkKadHGNAJuMPmhttMBtiqsq/ogFc=;
        b=K8wzwwbwhX3z4aH3uTpJ1xYUzYVoXmn1JcagMEMzLqMdEuxeNs4dTSvHdjTPs6Wq5J
         tPlAEzFHc4nJhODxtKDU963i9597BFCyiSEms0bm9m4lZC2cI/3eTYdH4FC2/UAPbcGS
         zK6FSEiISiXJqRkCu3q2GMVEMg8qWhljbYlt8gp7+dJmySIfgu0kKMtrvIqK+4cUmURO
         LN6mqhZ8YouWitVuhT16z67hIrpBoDKxfbK205Vw5dLgkjPkaNPsM7+LcweuwKMIojSi
         Zf1Kg7egIkWhcF8zaPoPTCslhswQsGIip6ar6YdR0wPXASOQ5wQcg6a5z6G7jCXLQ4Za
         ofPg==
X-Gm-Message-State: APjAAAWRiTDG0yEmPkKOHLHaXcrV3qYQ1p7hbxPuJtP401vLrHZUeatm
        gfykta1+NNAGSLNZ5AW5GPm+KM/RamBPeAxOiodvBg==
X-Google-Smtp-Source: APXvYqy4LkO/AN6FMc6azS6+NO1xpwbgoHN0EhwciWhcwX6y49JE0yi/3lQxsIlzAnJ+JQAKSJZ79lxk+FSN/J0DIYE=
X-Received: by 2002:a6b:b206:: with SMTP id b6mr5995564iof.286.1559604646034;
 Mon, 03 Jun 2019 16:30:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190603040817.4825-1-dsahern@kernel.org> <20190603040817.4825-5-dsahern@kernel.org>
 <CAEA6p_AgK08iXuSBbMDqzatGaJj_UFbNWiBV-dQp2r-Y71iesw@mail.gmail.com>
 <dec5c727-4002-913f-a858-362e0d926b8d@gmail.com> <CAEA6p_Aa2eV+jH=H9iOqepbrBLBUvAg2-_oD96wA0My6FMG_PQ@mail.gmail.com>
 <5263d3ae-1865-d935-cb03-f6dfd4604d15@gmail.com> <CAEA6p_CixzdRNUa46YZusFg-37MFAVqQ8D09rxVU5Nja6gO1SA@mail.gmail.com>
 <4cdcdf65-4d34-603e-cb21-d649b399d760@gmail.com>
In-Reply-To: <4cdcdf65-4d34-603e-cb21-d649b399d760@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 3 Jun 2019 16:30:35 -0700
Message-ID: <CAEA6p_COGDOM7qhB=vh-AC=KnC+FCT6NyxX8amJ+DzUMEOXCkw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 4/7] ipv6: Plumb support for nexthop object in
 a fib6_info
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        idosch@mellanox.com, saeedm@mellanox.com,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 3, 2019 at 4:18 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 6/3/19 5:05 PM, Wei Wang wrote:
> > On Mon, Jun 3, 2019 at 3:35 PM David Ahern <dsahern@gmail.com> wrote:
> >>
> >> On 6/3/19 3:58 PM, Wei Wang wrote:
> >>> Hmm... I am still a bit concerned with the ip6_create_rt_rcu() call.
> >>> If we have a blackholed nexthop, the lookup code here always tries to
> >>> create an rt cache entry for every lookup.
> >>> Maybe we could reuse the pcpu cache logic for this? So we only create
> >>> new dst cache on the CPU if there is no cache created before.
> >>
> >> I'll take a look.
> >>
>
> BTW, I am only updating ip6_pol_route to use pcpu routes for blackhole
> nexthops.
>
> ip6_pol_route_lookup will continue as is. That function does not use
> pcpu routes and will stay as is.
>
That sounds reasonable to me. ip6_pol_route() seems to be what we care
about the most as all incoming/outgoing data path uses that.
Thanks David.
