Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C541F3A3803
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 01:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhFJXnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:43:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27592 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230351AbhFJXnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 19:43:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623368481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AR0ush4P46QAA/VTr4sxcEcbJnlOs/9qEWXHNYSYYUQ=;
        b=Y3Q2JmryRvG9sc602XNmPb4l6vzWb/PV7hZBPdNFdFgGJrUJRkRZTCx7pXQfzFcX17eEuO
        SYrRxbindGbyHmh59QXQtxJdQz6K/G+0jRTHJk3oclAcnrLyXsg5i9hxwtMnPe/O5U3lVY
        PRpR+65djJsVob9jr01AuVV/tJPf0uM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-2jtcd9BhNRag6rxJaPxzfQ-1; Thu, 10 Jun 2021 19:41:19 -0400
X-MC-Unique: 2jtcd9BhNRag6rxJaPxzfQ-1
Received: by mail-ej1-f70.google.com with SMTP id a25-20020a1709064a59b0290411db435a1eso335485ejv.11
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 16:41:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=AR0ush4P46QAA/VTr4sxcEcbJnlOs/9qEWXHNYSYYUQ=;
        b=kQXGpn6DjKzVrcFXSnBjo0O2YIj2OOI9F01FjM85CczcchN+ZZafvgUtH1BkNggXsF
         dG9H2Xv4IkJ3Gbr1bGq9Jf9UEI8SRWF7UOdrdq3sBNIGMkMmTrazFeqcgRuRVHRKwzeR
         nM3UYKMN7Tis5NqrPgKodh9oggNnyY9Mi98bn6FhUHW2yqXOFh06IQGs120dbMe9bG28
         quSHM8vmdp0njQ4RgtLYOxv1Fte5EsxQ96ydw58KUf111vzVes5nWws+o18LR21q8GQw
         L/qlgeP0pngEhk6C4ya8Z8FctKzcViRNE/odKLyvRDOkkVGdNB8PsDOZal1A9AsbruBZ
         rk7w==
X-Gm-Message-State: AOAM532mI8mzceyNLNpyO29+ZcM7/kNvk6ldP2BdsEhOt8ij3BmMobd5
        Yq0JuUNp4WyFo8BJWqkq2MqoNQwQsV80DaK8JxcqnZn7KYF3qFY97UQsP3IZtcGcjTzNc+LtzT1
        dk8u91DzpILhOE7VV
X-Received: by 2002:a17:906:5593:: with SMTP id y19mr804340ejp.195.1623368478609;
        Thu, 10 Jun 2021 16:41:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfAVO4j19hF8iHvKpB3Qu7rdUUGFfFgZC6tpT4QpPjBqlLyhJfjXi+mQHXRw8tGerKkBYXwg==
X-Received: by 2002:a17:906:5593:: with SMTP id y19mr804327ejp.195.1623368478286;
        Thu, 10 Jun 2021 16:41:18 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id bd3sm1979645edb.34.2021.06.10.16.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 16:41:17 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2100F18071E; Fri, 11 Jun 2021 01:41:17 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH bpf-next 04/17] xdp: add proper __rcu annotations to
 redirect map entries
In-Reply-To: <20210610233250.pef2dwo2r5atluwt@kafai-mbp>
References: <20210609103326.278782-1-toke@redhat.com>
 <20210609103326.278782-5-toke@redhat.com>
 <20210610210907.hgfnlja3hbmgeqxx@kafai-mbp> <87h7i5ux3r.fsf@toke.dk>
 <20210610233250.pef2dwo2r5atluwt@kafai-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 11 Jun 2021 01:41:17 +0200
Message-ID: <875yyluw2q.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> writes:

> On Fri, Jun 11, 2021 at 01:19:04AM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> >> @@ -149,7 +152,8 @@ static int xsk_map_update_elem(struct bpf_map *ma=
p, void *key, void *value,
>> >>  			       u64 map_flags)
>> >>  {
>> >>  	struct xsk_map *m =3D container_of(map, struct xsk_map, map);
>> >> -	struct xdp_sock *xs, *old_xs, **map_entry;
>> >> +	struct xdp_sock __rcu **map_entry;
>> >> +	struct xdp_sock *xs, *old_xs;
>> >>  	u32 i =3D *(u32 *)key, fd =3D *(u32 *)value;
>> >>  	struct xsk_map_node *node;
>> >>  	struct socket *sock;
>> >> @@ -179,7 +183,7 @@ static int xsk_map_update_elem(struct bpf_map *ma=
p, void *key, void *value,
>> >>  	}
>> >>=20=20
>> >>  	spin_lock_bh(&m->lock);
>> >> -	old_xs =3D READ_ONCE(*map_entry);
>> >> +	old_xs =3D rcu_dereference_check(*map_entry, rcu_read_lock_bh_held(=
));
>> > Is it actually protected by the m->lock at this point?
>>=20
>> True, can just add that to the check.
> this should be enough
> rcu_dereference_protected(*map_entry, lockdep_is_held(&m->lock));

Right, that's what I had in mind as well :)

-Toke

