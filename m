Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12564150EA
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 22:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbhIVUDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 16:03:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237316AbhIVUDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 16:03:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632340902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dvr83e1n2Fgw45ulUi7a8YcLHtn9mb8DbDGNHYwss94=;
        b=QFEYD1rM0S/bfQSuiHIOGPu+m3jrQn3EjGB1XBDOKBJOePm3Pm+qPHOfx9mjFWi/OWiDHE
        nkjWkIlT+8lQtBvuU787zVKxk1YMrAai+qlMQRFeJorewmxP7x9+NTi4Y5EPjBkr2GvLpk
        6VVliWuyENtr09hxdq3EHgPmFh6El6M=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-gIjrmrdWO8-rHRmerxIT-A-1; Wed, 22 Sep 2021 16:01:40 -0400
X-MC-Unique: gIjrmrdWO8-rHRmerxIT-A-1
Received: by mail-ed1-f70.google.com with SMTP id b7-20020a50e787000000b003d59cb1a923so4418302edn.5
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 13:01:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=dvr83e1n2Fgw45ulUi7a8YcLHtn9mb8DbDGNHYwss94=;
        b=mKF5FpUerVExPgk28jZ7DbismZYgLeHxik7IR1XTJ5Z8yCsV7vQlAJrApXR2M4MdRC
         6X7NG6b04tMq28LSSgT2qBSxRCsWL861hoDjEk0lqMKoDfx97J5eISAQE44FTaBq7+a9
         KynX6m1hgwN+BiTywckEkiYVYQa73I7uCcZ9Behsaq1n6Z67dwPxaX+arvK4s6Y97nL2
         Ni5obM0IZdc5JGghIqYzpZ7vLdKerFtqGkbHL0G0PiEE/zK/n08TSmpERd2U2B5sUwWF
         2gtc6Y4xpiHUVVw5XKGiqWu0Fxx1mY1kEsp26bYt5sumPqocXt2PRdefgYmLkQIdb0I5
         X6QQ==
X-Gm-Message-State: AOAM532aOIe62GnUviTTnvCvqsO8tptxSyMBhQN6vAwOmIf1EGZ47IdS
        3BUoXWqddCmkI+OBmAvOdN9wnC78fnD6LCRISna2ikC9zjzU1cR+ybdK+PyveEvMYD2bzSOkJcz
        lu1HU67dG6afkpP77
X-Received: by 2002:a17:907:2624:: with SMTP id aq4mr1129317ejc.448.1632340897910;
        Wed, 22 Sep 2021 13:01:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzMzo127CmB7Voy0uTktBHCOW4IdwdLeoczJa9wnK3UJ8FoYXIbVWcfZXy6NhU4j/VrNfTl7w==
X-Received: by 2002:a17:907:2624:: with SMTP id aq4mr1129080ejc.448.1632340895635;
        Wed, 22 Sep 2021 13:01:35 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g10sm1503581ejj.44.2021.09.22.13.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 13:01:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3447218034A; Wed, 22 Sep 2021 22:01:17 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Zvi Effron <zeffron@riotgames.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Lorenzo Bianconi <lbianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: Redux: Backwards compatibility for XDP multi-buff
In-Reply-To: <20210921155118.439c0aa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <87o88l3oc4.fsf@toke.dk>
 <CAC1LvL1xgFMjjE+3wHH79_9rumwjNqDAS2Yg2NpSvmewHsYScA@mail.gmail.com>
 <87ilyt3i0y.fsf@toke.dk>
 <CAADnVQKi_u6yZnsxEagNTv-XWXtLPpXwURJH0FnGFRgt6weiww@mail.gmail.com>
 <87czp13718.fsf@toke.dk>
 <20210921155118.439c0aa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 22 Sep 2021 22:01:17 +0200
Message-ID: <87mto41isy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 22 Sep 2021 00:20:19 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >> Neither of those are desirable outcomes, I think; and if we add a
>> >> separate "XDP multi-buff" switch, we might as well make it system-wid=
e?=20=20
>> >
>> > If we have an internal flag 'this driver supports multi-buf xdp' canno=
t we
>> > make xdp_redirect to linearize in case the packet is being redirected
>> > to non multi-buf aware driver (potentially with corresponding non mb a=
ware xdp
>> > progs attached) from mb aware driver?=20=20
>>=20
>> Hmm, the assumption that XDP frames take up at most one page has been
>> fundamental from the start of XDP. So what does linearise mean in this
>> context? If we get a 9k packet, should we dynamically allocate a
>> multi-page chunk of contiguous memory and copy the frame into that, or
>> were you thinking something else?
>
> My $.02 would be to not care about redirect at all.
>
> It's not like the user experience with redirect is anywhere close=20
> to amazing right now. Besides (with the exception of SW devices which
> will likely gain mb support quickly) mixed-HW setups are very rare.
> If the source of the redirect supports mb so will likely the target.

It's not about device support it's about XDP program support: If I run
an MB-aware XDP program on a physical interface and redirect the (MB)
frame into a container, and there's an XDP program running inside that
container that isn't MB-aware, bugs will ensue. Doesn't matter if the
veth driver itself supports MB...

We could leave that as a "don't do that, then" kind of thing, but that
was what we were proposing (as the "do nothing" option) and got some
pushback on, hence why we're having this conversation :)

-Toke

