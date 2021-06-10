Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F4D3A37BF
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 01:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhFJXVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:21:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52563 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230212AbhFJXVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 19:21:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623367149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aD2LL3NxQAPf5GU2IavUhu+JCNdlw6JkWCN21CEpMvM=;
        b=N2qLKV0ioxQNH2Fq6NyKdN562ErJYg3wibEf5k1GaHgeylQrcUP2tGXTq6DMmo7ng21FaG
        KaBiFE97G/taqgmt189zRAY9ZDiaT0iT3IXG24N3DhrRa5chDZ2bhPYKF23p8XsdtQvkHs
        LIVSkatPvmZ3LD4ZpKpNac7IccLG8o8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-ubI5g64fMYazxwnPJogD5Q-1; Thu, 10 Jun 2021 19:19:08 -0400
X-MC-Unique: ubI5g64fMYazxwnPJogD5Q-1
Received: by mail-ed1-f70.google.com with SMTP id ch5-20020a0564021bc5b029039389929f28so7256960edb.16
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 16:19:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=aD2LL3NxQAPf5GU2IavUhu+JCNdlw6JkWCN21CEpMvM=;
        b=pb2W+Q4TOgN8SNhqGmeuzVsD3zxRXGCFn/s1W8INfd+f5zFD0QpEAgQTmkhSJfASuB
         kodKwAZ62k7hS1Qx5xSPu2C5d1w1kMIDR2rzcK43DGaqx5X5NXRSRKMZu9TD7c0w6Btj
         njnjgxouueRFyON7wOVERG8CJhIILvdxUtw73qLC/yCeFno1gkYP9xWtUSPMmm/TXXFO
         x4wId7k7uaW9oOXdNcHqWZMOz3zeKajPa4+lT32nfWszc78irrPSCowEuqp8KQQACz2F
         mLeKCjK4QTZosTbb/GjgJZsFFJO847JK3CkxkYaedHXu6R3dyapLxH7rTuBuAqynkILW
         06rw==
X-Gm-Message-State: AOAM531ucyeyDTcsQtDnkNgM4ESpVJfk1eA25QON6H0XmO+6Z1e4te3R
        QGVFYmC9u1MFBpKzi3bPK88iJEJl28OEFbjgnGFr1xp3XPDWpWhNN2pHRqLxIEaDO6fewzQEQFb
        3LOf6PQaTtr2902TJ
X-Received: by 2002:a05:6402:543:: with SMTP id i3mr813015edx.173.1623367147339;
        Thu, 10 Jun 2021 16:19:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJcQHadF+yyqcRV1h5SBOoobAmF9eGTr/BROLCWcwTjLdMTEy2ywy8fwdMBnCkASCzU23cSQ==
X-Received: by 2002:a05:6402:543:: with SMTP id i3mr813002edx.173.1623367147217;
        Thu, 10 Jun 2021 16:19:07 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id f10sm1951780edx.60.2021.06.10.16.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 16:19:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BFCD618071E; Fri, 11 Jun 2021 01:19:04 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH bpf-next 04/17] xdp: add proper __rcu annotations to
 redirect map entries
In-Reply-To: <20210610210907.hgfnlja3hbmgeqxx@kafai-mbp>
References: <20210609103326.278782-1-toke@redhat.com>
 <20210609103326.278782-5-toke@redhat.com>
 <20210610210907.hgfnlja3hbmgeqxx@kafai-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 11 Jun 2021 01:19:04 +0200
Message-ID: <87h7i5ux3r.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> writes:

> On Wed, Jun 09, 2021 at 12:33:13PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> [ ... ]
>
>> @@ -551,7 +551,8 @@ static void cpu_map_free(struct bpf_map *map)
>>  	for (i =3D 0; i < cmap->map.max_entries; i++) {
>>  		struct bpf_cpu_map_entry *rcpu;
>>=20=20
>> -		rcpu =3D READ_ONCE(cmap->cpu_map[i]);
>> +		rcpu =3D rcu_dereference_check(cmap->cpu_map[i],
>> +					     rcu_read_lock_bh_held());
> Is rcu_read_lock_bh_held() true during map_free()?

Hmm, no, I guess not since that's called from a workqueue. Will fix!

>> @@ -149,7 +152,8 @@ static int xsk_map_update_elem(struct bpf_map *map, =
void *key, void *value,
>>  			       u64 map_flags)
>>  {
>>  	struct xsk_map *m =3D container_of(map, struct xsk_map, map);
>> -	struct xdp_sock *xs, *old_xs, **map_entry;
>> +	struct xdp_sock __rcu **map_entry;
>> +	struct xdp_sock *xs, *old_xs;
>>  	u32 i =3D *(u32 *)key, fd =3D *(u32 *)value;
>>  	struct xsk_map_node *node;
>>  	struct socket *sock;
>> @@ -179,7 +183,7 @@ static int xsk_map_update_elem(struct bpf_map *map, =
void *key, void *value,
>>  	}
>>=20=20
>>  	spin_lock_bh(&m->lock);
>> -	old_xs =3D READ_ONCE(*map_entry);
>> +	old_xs =3D rcu_dereference_check(*map_entry, rcu_read_lock_bh_held());
> Is it actually protected by the m->lock at this point?

True, can just add that to the check.

>>  void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
>> -			     struct xdp_sock **map_entry)
>> +			     struct xdp_sock __rcu **map_entry)
>>  {
>>  	spin_lock_bh(&map->lock);
>> -	if (READ_ONCE(*map_entry) =3D=3D xs) {
>> -		WRITE_ONCE(*map_entry, NULL);
>> +	if (rcu_dereference(*map_entry) =3D=3D xs) {
> nit. rcu_access_pointer()?

Yup.

