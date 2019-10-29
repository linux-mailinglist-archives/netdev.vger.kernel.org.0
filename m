Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDAAE9343
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbfJ2XET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:04:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59355 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfJ2XET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 19:04:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572390257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lC6RkTPds4S9HR6LQLQv9YuO8abma8vmlimyl+6x1u8=;
        b=SsABcgksX3E4h14V67FzeZXyHATCOczELnWYNVz4i+YNZwe2pyq28HR3yd0yChwnUqWniF
        UQbH2sFLS4OwIE7JUHiYt9kZIUOcRuHbsUuAMPQuDFGBMIN8Q9gz3Dk8uDO7MT9YbfIEU7
        41se61WkM4MOH0k1i1Ik5bVhESkQIYg=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-bPP3veGAMKSNUJ9-B_hnZg-1; Tue, 29 Oct 2019 19:04:16 -0400
Received: by mail-oi1-f198.google.com with SMTP id b2so184166oie.21
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 16:04:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wl7YIQbPAgHE/Mh/x+ZbND7svWyQMZORYikb1F19SjY=;
        b=JpbnL2SwBuDcukLBARj9Z3elUxbI5xJxC3OERL/UoyNyg/lUa6oePWtSWETSTsy1Af
         57aCMtcTZuuafCVT+D1O+jLfQwkKnqyvOP9mWzGCdY9GjuRIMttVGH90LvJQtkbO9rwT
         ljncnGJNf01ImSKJpxoNZ2K57jB16m3OkLYT8PNCNjGfd9e5txYePmwdAKQCPOeLp0hp
         g5+oD/fsVxyZxuxM9ykEmrFI89AyHIH3n5sbuvMOQGVB1VA4/cRch4FCe41eTIfa8yMw
         KX0Z57yumLgsB+z9P1ykINBOsWqhQkOLLAy6YIKqz43Ne0HhUTT4ht6bLA4ISfOn82Cf
         2MQQ==
X-Gm-Message-State: APjAAAWAqmSHzbz/dssXb9SHVi8zF65NinpX8YA3VvfqiZxtJ+CQdVb9
        bTQYrv51FsW5elecSjFnhzHc2dXSmHf5E/Drm5WZBEKZwKt0uh++1cE5K8cN6mNbcsS+zrCj2Id
        WO5e9ja0aNxnEPCvyrLWfQ9T2aqjm8Ucy
X-Received: by 2002:aca:5148:: with SMTP id f69mr6344026oib.159.1572390255131;
        Tue, 29 Oct 2019 16:04:15 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyrOvo2ebV8RyPvfdiZT6nEJRpNOU3bEpPZCDUbj09hF/s+Zdz/zPptHOhdj4P6FjVeiauQvnuRwh7Ip1+jFHU=
X-Received: by 2002:aca:5148:: with SMTP id f69mr6344005oib.159.1572390254853;
 Tue, 29 Oct 2019 16:04:14 -0700 (PDT)
MIME-Version: 1.0
References: <20191029135053.10055-1-mcroce@redhat.com> <20191029135053.10055-5-mcroce@redhat.com>
 <5be14e4e-807f-486d-d11a-3113901e72fe@cumulusnetworks.com> <576a4a96-861b-6a86-b059-6621a22d191c@gmail.com>
In-Reply-To: <576a4a96-861b-6a86-b059-6621a22d191c@gmail.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Wed, 30 Oct 2019 00:03:38 +0100
Message-ID: <CAGnkfhzEgaH1-YNWw1_HzB5FOhZHjKewLD9NP+rnTP21Htxnjw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/4] bonding: balance ICMP echoes in layer3+4 mode
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
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
X-MC-Unique: bPP3veGAMKSNUJ9-B_hnZg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 10:03 PM Eric Dumazet <eric.dumazet@gmail.com> wrot=
e:
>
>
>
> On 10/29/19 11:35 AM, Nikolay Aleksandrov wrote:
>
> > Hi Matteo,
> > Wouldn't it be more useful and simpler to use some field to choose the =
slave (override the hash
> > completely) in a deterministic way from user-space ?
> > For example the mark can be interpreted as a slave id in the bonding (s=
hould be
> > optional, to avoid breaking existing setups). ping already supports -m =
and
> > anything else can set it, this way it can be used to do monitoring for =
a specific
> > slave with any protocol and would be a much simpler change.
> > User-space can then implement any logic for the monitoring case and as =
a minor bonus
> > can monitor the slaves in parallel. And the opposite as well - if peopl=
e don't want
> > these balanced for some reason, they wouldn't enable it.
> >
>
> I kind of agree giving user more control. But I do not believe we need to=
 use the mark
> (this might be already used by other layers)
>
> TCP uses sk->sk_hash to feed skb->hash.
>
> Anything using skb_set_owner_w() is also using sk->sk_hash if set.
>
> So presumably we could add a generic SO_TXHASH socket option to let user =
space
> read/set this field.
>

Hi Eric,

this would work for locally generated echoes, but what about forwarded pack=
ets?
The point behind my changeset is to provide consistent results within
a session by using the same path for request and response,
but avoid all sessions flowing to the same path.
This should resemble what happens with TCP and UDP: different
connections, different port, probably a different path. And by doing
this in the flow dissector, other applications could benefit it.

Also, this should somewhat balance the traffic of a router forwarding
those packets. Maybe it's not so much in percentage, but in some
gateways be a considerable volume.

Regards,
--=20
Matteo Croce
per aspera ad upstream

