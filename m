Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBB92821FB
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 09:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgJCH0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 03:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgJCH0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 03:26:15 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056B0C0613D0;
        Sat,  3 Oct 2020 00:26:14 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id q9so3701797wmj.2;
        Sat, 03 Oct 2020 00:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BELL9OoNcXE7vFvIM0+V6h2J2U58fDgj9JrIKNQjOWg=;
        b=JBva6+18BX5y/ctxY64VPdv7pyhgo4Crj2dJbzk1MxlCTgvecyoo6+F82dgSw184nf
         6if67i1df+ng/9aQ48stvSQrbSZ4XHR+y/l+VImiv0o1lYWweq9Vla8dQo7eMRVdZQTQ
         i98thWZzKF7aVaK7ss6RWr1zv/Mf/p9L8ciPBNI8v/6hEURZmgf776Oh9rsZDpZuIp7o
         LfjL3GNkbZ2rKay/sxAw5R4RJ+GBTybsxArAnL0Mb57CBhAbqPJpaa2yO7GsibKkMVZR
         eFZe7kWyptcfw7tXlPZFvRaFnB+VAB4VlfyuNtdJVf44FX9wyA2G1AvGc+2DyU/3eimC
         vNXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BELL9OoNcXE7vFvIM0+V6h2J2U58fDgj9JrIKNQjOWg=;
        b=i34EbMo0Tuq93PVf0W+LSbqNZ0t3Ta/bvkFpG5tSzzmm4ZahEYzUYB4YqggmNVyaBa
         FUyzWbB47UmAQImPtE7gM3KlUpRBFMmgk2oW8cIKuSOtBoDEgs5UwTeADfBcmGrzlwnq
         oTQZqVQhi7KOhXbWg+qomjMScAkKxxuUPMdo+c+TbT0K9VA6GQ8VdfL5zre+MbxNsSXf
         CchillE+eUEGTdhSijxhKzJx/SDaASfsHpN5A5ToYVhAo9GAeCDCk3wPSe0NOFWlHHJy
         l/ynxK1uhtud9mvO1uSUGy8kIq7J8BzZ+Dvai+vKDJusCcg7BIR8mlulPDeS4Q+v0jV7
         Udog==
X-Gm-Message-State: AOAM533k2ehRnW2ihu8FdVafbcSsNsR+Bjb1EMAXS5z6a2s3HZSr9Wit
        w7meg6mFuT9+mlM/KAmxP2yxORxVuYN33twBTdg=
X-Google-Smtp-Source: ABdhPJyK+JXLxmIUdaLgZ0JxjZI2DBI/+Ws24SBJFj0FBBWtL2cRNzQba+smOVJgBOl3ehgxnlkp7wPrKjh4IGBkJig=
X-Received: by 2002:a1c:7e90:: with SMTP id z138mr6431804wmc.122.1601709972778;
 Sat, 03 Oct 2020 00:26:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1601387231.git.lucien.xin@gmail.com> <ff57fb1ff7c477ff038cebb36e9f0554d26d5915.1601387231.git.lucien.xin@gmail.com>
 <20201003040550.GD70998@localhost.localdomain>
In-Reply-To: <20201003040550.GD70998@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 3 Oct 2020 15:41:39 +0800
Message-ID: <CADvbK_cWfwSryOZLsW_CEkn5MJUHOhh8AmV2fn4OAUomHthQfA@mail.gmail.com>
Subject: Re: [PATCH net-next 09/15] sctp: add SCTP_REMOTE_UDP_ENCAPS_PORT sockopt
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 3, 2020 at 12:05 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Tue, Sep 29, 2020 at 09:49:01PM +0800, Xin Long wrote:
> ...
> > +struct sctp_udpencaps {
> > +     sctp_assoc_t sue_assoc_id;
> > +     struct sockaddr_storage sue_address;
> > +     uint16_t sue_port;
> > +};
> ...
> > +static int sctp_setsockopt_encap_port(struct sock *sk,
> > +                                   struct sctp_udpencaps *encap,
> > +                                   unsigned int optlen)
> > +{
> > +     struct sctp_association *asoc;
> > +     struct sctp_transport *t;
> > +
> > +     if (optlen != sizeof(*encap))
> > +             return -EINVAL;
> > +
> > +     /* If an address other than INADDR_ANY is specified, and
> > +      * no transport is found, then the request is invalid.
> > +      */
> > +     if (!sctp_is_any(sk, (union sctp_addr *)&encap->sue_address)) {
> > +             t = sctp_addr_id2transport(sk, &encap->sue_address,
> > +                                        encap->sue_assoc_id);
> > +             if (!t)
> > +                     return -EINVAL;
> > +
> > +             t->encap_port = encap->sue_port;
>                    ^^^^^^^^^^          ^^^^^^^^
>
> encap_port is defined as __u16 is previous patch, but from RFC:
>   sue_port:  The UDP port number in network byte order...
>
> asoc->peer.port is stored in host order, so it makes sense to follow
> it here. Then need a htons() here and its counter parts.  It is right
> in some parts of the patches already.
Good catch! thank you!
