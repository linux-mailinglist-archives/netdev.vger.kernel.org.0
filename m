Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E7DE1854
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 12:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391126AbfJWKyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 06:54:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45166 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390379AbfJWKyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 06:54:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571828063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o8RImXd6KMXv5pjUQ2Eec3anNMeMpMspjOnmOYWmf/E=;
        b=QSOuozB9+W+yEw2iPkLPnx1AQBJQ3+i2wUc+AIjeS6aDF7x9DWBZBgWhlQnAX6NyJp0YSp
        eY9xpxskR1ErnvlcBvO4hwNaHFwJoaI6H/dJ0Rn/SBzPKqI95rR/mP0C7p41INlSE72RYO
        j46RQg1bhKibNN5wtVEGEXNtpGXd0kw=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-8ElqtFPLPdGlxIR1LPcR2w-1; Wed, 23 Oct 2019 06:54:16 -0400
Received: by mail-lf1-f69.google.com with SMTP id 23so3867509lft.15
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 03:54:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G1qDVGDD2hGEYDHk/bXX/vmWsyzIpERx2yni4ElYYOw=;
        b=ppW4xmrzYsV97hmjUJmBsk+gwUYnrGUzOJ81Ht1M+VeOVzagiyWkEdZ2VSUbmtO4rA
         qqXixw+siL+AQQ5cDYd00m2Nc7IIfUH3h6Ik187S+zfjN1uztQnHSR4wK3vEcFQWtPKA
         a46ggYm2DgeI9dPVYLixQNeReImyEeX4P3Swp1dyrTlH6XZJ/gYroNN07zb2+IVA3AeI
         D8cEzT2E+jJ2+5Trl/0EpS+MGIwIGmtFQUEJQ5OamRGcIdwi0MehTbOG//1mOu+8GZgD
         e6b1UCB3iWbMzXslhwk0LqL9BsX+ZWG214+NGCvnN9+Vypv/fD8yIXL/dr4nTDnHFhML
         c+Qg==
X-Gm-Message-State: APjAAAWLkKgnFJQP6MdXy8EK8ZtqYsnhQizVICQw+qVGOKts9WpDQs3B
        6HOnectE59c4uPAQMdzKQ36R1vQ4O1rJ0XPow0TiaHWeYoU19Uy9oVqMufeF0fSXK/u527iGqw/
        ePyF3T2tr8zr5OE5I1g0kWsivVX1O+GRk
X-Received: by 2002:a2e:9890:: with SMTP id b16mr21660791ljj.181.1571828054503;
        Wed, 23 Oct 2019 03:54:14 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw0EJ3201DeC5P5Ty9eQ1hPJqAuy8TFfoz8iKKFgkYSvJKqJJi1FELYHSEZbbew23ZlUZWlvFSHBfxWie7IbHw=
X-Received: by 2002:a2e:9890:: with SMTP id b16mr21660771ljj.181.1571828054190;
 Wed, 23 Oct 2019 03:54:14 -0700 (PDT)
MIME-Version: 1.0
References: <20191021200948.23775-1-mcroce@redhat.com> <20191021200948.23775-4-mcroce@redhat.com>
 <20191023100009.GC8732@netronome.com>
In-Reply-To: <20191023100009.GC8732@netronome.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Wed, 23 Oct 2019 12:53:37 +0200
Message-ID: <CAGnkfhxg1sXkmiNS-+H184omQaKbp_+_Sy7Vi-9W9qLwGGPU6g@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] flow_dissector: extract more ICMP information
To:     Simon Horman <simon.horman@netronome.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        LKML <linux-kernel@vger.kernel.org>
X-MC-Unique: 8ElqtFPLPdGlxIR1LPcR2w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 12:00 PM Simon Horman
<simon.horman@netronome.com> wrote:
> On Mon, Oct 21, 2019 at 10:09:47PM +0200, Matteo Croce wrote:
> > +     switch (ih->type) {
> > +     case ICMP_ECHO:
> > +     case ICMP_ECHOREPLY:
> > +     case ICMP_TIMESTAMP:
> > +     case ICMP_TIMESTAMPREPLY:
> > +     case ICMPV6_ECHO_REQUEST:
> > +     case ICMPV6_ECHO_REPLY:
> > +             /* As we use 0 to signal that the Id field is not present=
,
> > +              * avoid confusion with packets without such field
> > +              */
> > +             key_icmp->id =3D ih->un.echo.id ? : 1;
>
> Its not obvious to me why the kernel should treat id-zero as a special
> value if it is not special on the wire.
>
> Perhaps a caller who needs to know if the id is present can
> check the ICMP type as this code does, say using a helper.
>

Hi,

The problem is that the 0-0 Type-Code pair identifies the echo replies.
So instead of adding a bool is_present value I hardcoded the info in
the ID field making it always non null, at the expense of a possible
collision, which is harmless.


--
Matteo Croce
per aspera ad upstream

