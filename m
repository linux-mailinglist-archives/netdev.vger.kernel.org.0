Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4802D2A4BA9
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 17:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgKCQgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 11:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbgKCQgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 11:36:17 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74ACEC0613D1;
        Tue,  3 Nov 2020 08:36:17 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id h62so16501070oth.9;
        Tue, 03 Nov 2020 08:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qOjuB9yQXP7C641wWPryW22kq2BalJ5tPu+GIQifkY4=;
        b=hmqVKyWvHooVnj/4kZHvh/H6joHado2yvZt1Djo+bE5z44+ra3hDj5WQzOPf5NOnAJ
         roMvmZojrXqwwoDXGBCvpz7eDXZ2NpukfXypP4LzjxMKVJi2QwTsZ9GQmL5szBHZCf3u
         jmUkKOSPFRk07A+cj8gHnAjGP6PHN3rZUgS6dZngsqKKU6rn9iiw/9ccfRK2/dqjlK4r
         DW3SU0yZcWy2p/JJVTVmARsZd1W/dj8ghYelMQ4NiqBz5LHQo4PchTajUI1GNoQD4O2f
         HclFIz+iX/2LqJqe7iwv7i1krd/lEzCiFAnqGmV8qcO1LyJyE4DowT3mdyBSIN6iICO6
         rUeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qOjuB9yQXP7C641wWPryW22kq2BalJ5tPu+GIQifkY4=;
        b=EqTk5m8+XSXG31QSRnK5EOFZrcPnlLPNj1gwcXjW8FlctaD4p5DQkDvZHhSrceO83s
         kEUnKqm9cLHuf9LPX86OnlZsWmkmS6oXwtrDOFDBR2B9AcFk1kKeX9n7XhM8OQMvgx7I
         c1lOwPy88sbkKlofSLEYBCifPt09ztlNe1uK5nPT/6q1qnREVDTnjUOUNeh8cgHGPyJR
         613nbNJuLgwYQ1i35z/bgGmYEnjedAQlj0R3pR0bLNSUz7fIOg/SPazNGgQj/sBVS8mu
         H0Zz0kuwvnBVuzMDx9PMmkOPj6R1bC1En6ELm0+kJSR8QS19+d8Pq9c81W83QKWUg10s
         wBHw==
X-Gm-Message-State: AOAM530T8qsOfArirh5DXNNekF1zkMafUNhXWqlSfdb1Ow0uGBD5YysM
        tfr7bf6PFgSo6Rmfe1V8YEhX5EmRXQfOQNJztRI=
X-Google-Smtp-Source: ABdhPJwYrtXU7g2SczGLnlQDB9IF5CshbaxR9gpK1/W5xkG0eIDW5YcvMSsB4SQnWRBA7VjWHf2lqwzEA+gELnMEozY=
X-Received: by 2002:a9d:2487:: with SMTP id z7mr15277413ota.133.1604421376593;
 Tue, 03 Nov 2020 08:36:16 -0800 (PST)
MIME-Version: 1.0
References: <20201030202727.1053534-1-cezarsa@gmail.com> <9140ef65-f76d-4bf1-b211-e88c101a5461@ssi.bg>
In-Reply-To: <9140ef65-f76d-4bf1-b211-e88c101a5461@ssi.bg>
From:   =?UTF-8?Q?Cezar_S=C3=A1_Espinola?= <cezarsa@gmail.com>
Date:   Tue, 3 Nov 2020 13:36:05 -0300
Message-ID: <CA++F93jp=6mfVm9brGOMeBE0EKoJhg4EAuN04jeBnXKsC-rTag@mail.gmail.com>
Subject: Re: [PATCH RFC] ipvs: add genetlink cmd to dump all services and destinations
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        "open list:IPVS" <netdev@vger.kernel.org>,
        "open list:IPVS" <lvs-devel@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> > +     if (ctx->idx_svc =3D=3D ctx->start_svc && ctx->last_svc !=3D svc)
> > +             return 0;
> > +
> > +     if (ctx->idx_svc > ctx->start_svc) {
> > +             if (ip_vs_genl_dump_service(skb, svc, cb) < 0) {
> > +                     ctx->idx_svc--;
> > +                     return -EMSGSIZE;
> > +             }
> > +             ctx->last_svc =3D svc;
> > +             ctx->start_dest =3D 0;
> > +     }
> > +
> > +     ctx->idx_dest =3D 0;
> > +     list_for_each_entry(dest, &svc->destinations, n_list) {
> > +             if (++ctx->idx_dest <=3D ctx->start_dest)
> > +                     continue;
> > +             if (ip_vs_genl_dump_dest(skb, dest, cb) < 0) {
> > +                     ctx->idx_dest--;
>
>         At this point idx_svc is incremented and we
> stop at the middle of dest list, so we need ctx->idx_svc-- too.
>
>         And now what happens if all dests can not fit in a packet?
> We should start next packet with the same svc? And then
> user space should merge the dests when multiple packets
> start with same service?

My (maybe not so great) idea was to avoid repeating the svc on each
packet. It's possible for a packet to start with a destination and
user space must consider then as belonging to the last svc received on
the previous packet. The comparison "ctx->last_svc !=3D svc" was
intended to ensure that a packet only starts with destinations if the
current service is the same as the svc we sent on the previous packet.

>
>         The main points are:
>
> - the virtual services are in hash table, their order is
> not important, user space can sort them
>
> - order of dests in a service is important for the schedulers
>
> - every packet should contain info for svc, so that we can
> properly add dests to the right svc

Thanks, I will rework the patch with these points in mind. It does
sound safer to ensure every packet starts with service information.

> > +nla_put_failure:
> > +     mutex_unlock(&__ip_vs_mutex);
> > +     cb->args[0] =3D ctx.idx_svc;
> > +     cb->args[1] =3D ctx.idx_dest;
> > +     cb->args[2] =3D (long)ctx.last_svc;
>
>         last_svc is used out of __ip_vs_mutex region,
> so it is not safe. We can get a reference count but this
> is bad if user space blocks.

I thought it would be relatively safe to store a pointer to the last
svc since I would only use it for pointer comparison and never
dereferencing it. But in retrospect it does look unsafe and fragile
and could probably lead to errors especially if services are modified
during a dump causing the stored pointer to point to a different
service.

>         But even if we use just indexes it should be ok.
> If multiple agents are used in parallel it is not our
> problem. What can happen is that we can send duplicates
> or to skip entries (both svcs and dests). It is impossible
> to keep any kind of references to current entries or even
> keys to lookup them if another agent can remove them.

Got it. I noticed this behavior while writing this patch and even
created a few crude validation scripts running parallel agents and
checking the diff in [1].

[1] - https://github.com/cezarsa/ipvsadm-validate/blob/37ebd39785b1e835c6d4=
b5c58aaca7be60d5e194/test.sh#L86-L87

Thanks a lot for the review,
--
Cezar S=C3=A1 Espinola
