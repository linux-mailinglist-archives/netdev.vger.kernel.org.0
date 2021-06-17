Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19393ABDD5
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 23:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhFQVQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 17:16:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50789 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231679AbhFQVQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 17:16:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623964434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gvcjlBEvHeWuTjxP8E3cv/s4SZ5Slc2G2g3da4eluAI=;
        b=cNwAql75tvD/ZmguCK0CBXWVlGzi9sVWyBlBcvKev2p4CvxlbPfKWfMzoFbWfXUnrMYZiL
        rIch6etUvWr+bpoCUAlgHl+L9j2bB+eUyvAP6g1Dcz9KAUSx7wSNJKP5HDzf3WwSig6n76
        rFJ8W06GaBAIzifua8tVT+sFFcIIl6w=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-M-lypVjdOlmWy71UgoBhVA-1; Thu, 17 Jun 2021 17:13:53 -0400
X-MC-Unique: M-lypVjdOlmWy71UgoBhVA-1
Received: by mail-ed1-f71.google.com with SMTP id y7-20020aa7ce870000b029038fd7cdcf3bso2351747edv.15
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 14:13:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=gvcjlBEvHeWuTjxP8E3cv/s4SZ5Slc2G2g3da4eluAI=;
        b=JwdHactGkdBU5Ev7vqt/0gwO6V4N9giOEAUoKz+8ufpsucIdNRNxY/+b/JGtrGBULU
         9SI4bcD4vnAOj9e/RTICK4PfOxiVlq2M1r2xZ1td5sVGYfIXNNZgtoMGE8ieDabrd684
         MNMv9iBvFrHGBLt6CAhAjrMT4pP2irD5+cvv31vu4VdEEApWVNzCUtO9EtBowV55QwVQ
         WuBBNT59RZYzUsXoXiLtRY+RhNVOCCTA/k43N7l3byjGFhwuocx8vlgJtNurBcXBkf2Q
         8Gxc4E0KvlwKkPIqM2pD+nqMbzO3+saeRI20+0txAUtyCkR3LnP8fl0L0DIK1XGv5q5Y
         EuAg==
X-Gm-Message-State: AOAM531COKbqyc5NzWaPSGWLlM4QIy91LWzeuun5Pjpr8Es0lDuScdkB
        B/qyCC9VQIliVU5PMeAbLnG50a9CJdJ72WI5IF4JF1VQtYjHwsKjTJOzwenF+OSGOF5xminJtua
        sR8GVZfx/2TmseUEC
X-Received: by 2002:a17:907:2642:: with SMTP id ar2mr7403685ejc.391.1623964432381;
        Thu, 17 Jun 2021 14:13:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJgTzSgJN7Vwr5cV0KUJCXbUnYuSmlFDeTdQTiylbTgEQLSZJrOhBB9vBBUggKwM2heDGctQ==
X-Received: by 2002:a17:907:2642:: with SMTP id ar2mr7403675ejc.391.1623964432199;
        Thu, 17 Jun 2021 14:13:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w8sm5026698edc.39.2021.06.17.14.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 14:13:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6030E180350; Thu, 17 Jun 2021 23:13:49 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next v2 03/16] xdp: add proper __rcu annotations to
 redirect map entries
In-Reply-To: <20210617194155.rkfyv2ixgshuknt6@kafai-mbp.dhcp.thefacebook.com>
References: <20210615145455.564037-1-toke@redhat.com>
 <20210615145455.564037-4-toke@redhat.com>
 <20210617194155.rkfyv2ixgshuknt6@kafai-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 17 Jun 2021 23:13:49 +0200
Message-ID: <87czskdwj6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> writes:

> On Tue, Jun 15, 2021 at 04:54:42PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> [ ... ]
>
>>  static void *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key)
>>  {
>>  	struct bpf_dtab *dtab =3D container_of(map, struct bpf_dtab, map);
>> @@ -266,7 +270,8 @@ static void *__dev_map_hash_lookup_elem(struct bpf_m=
ap *map, u32 key)
>>  	struct bpf_dtab_netdev *dev;
>>=20=20
>>  	hlist_for_each_entry_rcu(dev, head, index_hlist,
>> -				 lockdep_is_held(&dtab->index_lock))
>> +				 (lockdep_is_held(&dtab->index_lock) ||
>> +				  rcu_read_lock_bh_held()))
> This change is not needed also.

Ah yes, of course - my bad for forgetting to remove that as well. Will
send a v3!

-Toke

