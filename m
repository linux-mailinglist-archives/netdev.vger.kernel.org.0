Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8C02A6332
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 12:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbgKDLVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 06:21:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30648 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728969AbgKDLVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 06:21:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604488860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kVJFexBYORK6LujKRJ/7Ae6OMTPvLiGlGkCyVBuOcDM=;
        b=aOyiKTpa6Zlbry86oFuoWsNzmi63G1QyNg8ismlOmY01au9k4U7Kmsl77/e/ohcXqzAZPe
        tpSMTEzHjH5AuIpDw+nwcKWLsPGPftm3OmhHKpc0ERD5dgYTNQzxwzcFbHqyp5nuYtMjmw
        tUqkwtkeGNvLc+aiMFg810iVesDkl4c=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-vPXyw1dBP6uMIIYxNYIe2g-1; Wed, 04 Nov 2020 06:20:59 -0500
X-MC-Unique: vPXyw1dBP6uMIIYxNYIe2g-1
Received: by mail-il1-f197.google.com with SMTP id f8so8313249ilj.18
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 03:20:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=kVJFexBYORK6LujKRJ/7Ae6OMTPvLiGlGkCyVBuOcDM=;
        b=OJdowIuS69sDDDk6ZCEIBQuYT0SWVQ5A3+VSFMsTY0RfUS0Ysu5b7bn5Zdvbrdq47Z
         JURFqNamZCKQCINH45t5gClC05aoWyP8yeNyBS86cUh/JNAJnwwNR9rTseYnKMQ3/FvQ
         3Yxnt1s/+kCCAwfabO25AbBK4q10v1kmTGkq9jdiVBKhvETqFmhOaK7vAQRUMG0+wnva
         mFdx1hSSEzR2NbNYa5tidDJZzuNrL4OwTDvDBTzS3IvaqoT3sT9KumnBIKN0jI+DR9mE
         ISYuDJRn3+VriE405Ft9vnhCKt39Ejdc/5YMM3OWehdTQUAkAn+7dPYm20cWIqGLgx9U
         iEpQ==
X-Gm-Message-State: AOAM533V7HrLqswpOoXiS6eFp9TGgoNC3B8LNlU5IY5uYFZSiCvElaxK
        JMKg++h8s9NiNqi3dx+jMIM2yufLToM0vRbO1O8VvCqE7IBid3mhyesWCrLaxY7neiJKxIp0lVQ
        E0GbcFUpbq4BhWBXj
X-Received: by 2002:a92:cd0e:: with SMTP id z14mr17714477iln.135.1604488858214;
        Wed, 04 Nov 2020 03:20:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwkj71aBOqrF8EWkX1F2oYxOUtX4FAv6s4KPWoix8aCQRdFgu+SsBNfZPQny7ZaVL/MovtwYA==
X-Received: by 2002:a92:cd0e:: with SMTP id z14mr17714451iln.135.1604488857773;
        Wed, 04 Nov 2020 03:20:57 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id p6sm1319598ilc.26.2020.11.04.03.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 03:20:57 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2502E181CED; Wed,  4 Nov 2020 12:20:55 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
In-Reply-To: <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
 <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
 <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
 <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com>
 <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 04 Nov 2020 12:20:55 +0100
Message-ID: <87zh3xv04o.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> Back in the days when developing lib/bpf.c, it was explicitly done as
> built-in for iproute2 so that it doesn't take years for users to
> actually get to the point where they can realistically make use of it.
> If we were to extend the internal lib/bpf.c to similar feature state
> as libbpf today, how is that different in the bigger picture compared
> to sync or submodule... so far noone complained about lib/bpf.c.

Except that this whole effort started because lib/bpf.c is slowly
bitrotting into oblivion? If all the tools are dynamically linked
against libbpf, that's only one package the distros have to keep
up-to-date instead of a whole list of tools. How does that make things
*worse*?

-Toke

