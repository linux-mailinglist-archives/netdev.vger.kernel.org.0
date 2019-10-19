Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC20DD86A
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 13:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfJSLQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 07:16:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28623 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725792AbfJSLQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 07:16:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571483788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+7fbKVeSWcbXgDC3MEOuz0AdAiOJEELMeHJySZkRGvc=;
        b=FUk3+g7IU8Wrxxa/GOWgHLeRjUUFqKm2vjLx06FlGhcxtbRx4mgeWFFZzVO6BvLL52LrQG
        YUIA9YszdPaVeTfJpBAA6v5kjgAhcmYYRoIGfuMjYIZ3BIYHUlWgv630rTkl/5vy046V3O
        25Op3c5+v7+kan+OjZ2vyHYEq21/Dqg=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-xSRy2DapOC6TdIF-uT_oaw-1; Sat, 19 Oct 2019 07:16:26 -0400
Received: by mail-lj1-f197.google.com with SMTP id x13so1604301ljj.18
        for <netdev@vger.kernel.org>; Sat, 19 Oct 2019 04:16:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=8e2RX7mkywkH9VLpLqT/BzelBgq7RWrd0p72p44VYYE=;
        b=aZ3LB7RK8263DvJgwds4ZNzlQFKVQABc6h6kvUwGuUr5wnjq7uukhh6eAqhJw11yQc
         KzAz076SPbhW9IChJXAZ08rwq/46D9kEAKONJu1k0AJZptEq/5jp+bhvyHqU4XR7aNrm
         c753N22HHRUV8y/lQOwhxPK1QEmwY35zLl5aQvWocgtpEKcjDrn08UdIRvEfbHMNMpk5
         E0zKmfKv2Ch+zWGn6TRIyhCbEvMEpnPzGLf/+PqR9aho0MeQQn2AB4lHXpy98mSrmrUl
         o0DS/ZEc5fIEBwgVNAa9pwdBV2dRX6qFviphh/Brp/9Sf/2g5Rt/vmf1P8feWVMpJT4F
         X6pQ==
X-Gm-Message-State: APjAAAUet7scArTcXJfe9kkkHRW08HS4xmCVvPLxGwb4qab8M1axhAW7
        dyqpZfBko3JCaspEgahnYhP8lc3fOozERuFS40gPEJ0V1w4N/k5plG2qYjo7l5Oygor77ZgYDT/
        bB+OM7jXUdUaxlWlY
X-Received: by 2002:a2e:b527:: with SMTP id z7mr3062105ljm.245.1571483785139;
        Sat, 19 Oct 2019 04:16:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqymUOlkHP2HOXh6nJCmzgkHzc1S/hDLPfKztkrB3A/TKmeC8cMQyJBpypGdRlBbMBR6viD5aQ==
X-Received: by 2002:a2e:b527:: with SMTP id z7mr3062097ljm.245.1571483784955;
        Sat, 19 Oct 2019 04:16:24 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id r19sm4153103ljd.95.2019.10.19.04.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 04:16:24 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A93D51804C8; Sat, 19 Oct 2019 13:16:23 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin Lau <kafai@fb.com>
Cc:     "daniel\@iogearbox.net" <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH bpf v3] xdp: Handle device unregister for devmap_hash map type
In-Reply-To: <20191018211818.5e6gfdjwq4zefnez@kafai-mbp>
References: <20191018194418.2951544-1-toke@redhat.com> <20191018211818.5e6gfdjwq4zefnez@kafai-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 19 Oct 2019 13:16:23 +0200
Message-ID: <87lfthc7eg.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: xSRy2DapOC6TdIF-uT_oaw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Lau <kafai@fb.com> writes:

> On Fri, Oct 18, 2019 at 09:44:18PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> It seems I forgot to add handling of devmap_hash type maps to the device
>> unregister hook for devmaps. This omission causes devices to not be
>> properly released, which causes hangs.
>>=20
>> Fix this by adding the missing handler.
>>=20
>> Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up devic=
es by hashed index")
>> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>> v3:
>>   - Use u32 for loop iterator variable
>>   - Since we're holding the lock we can just iterate with hlist_for_each=
_entry_safe()
>> v2:
>>   - Grab the update lock while walking the map and removing entries.
>>=20
>>  kernel/bpf/devmap.c | 30 ++++++++++++++++++++++++++++++
>>  1 file changed, 30 insertions(+)
>>=20
>> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>> index c0a48f336997..012dbfb0f54b 100644
>> --- a/kernel/bpf/devmap.c
>> +++ b/kernel/bpf/devmap.c
>> @@ -719,6 +719,31 @@ const struct bpf_map_ops dev_map_hash_ops =3D {
>>  =09.map_check_btf =3D map_check_no_btf,
>>  };
>> =20
>> +static void dev_map_hash_remove_netdev(struct bpf_dtab *dtab,
>> +=09=09=09=09       struct net_device *netdev)
>> +{
>> +=09unsigned long flags;
>> +=09u32 i;
>> +
>> +=09spin_lock_irqsave(&dtab->index_lock, flags);
>> +=09for (i =3D 0; i < dtab->n_buckets; i++) {
>> +=09=09struct bpf_dtab_netdev *dev;
>> +=09=09struct hlist_head *head;
>> +=09=09struct hlist_node *next;
>> +
>> +=09=09head =3D dev_map_index_hash(dtab, i);
>> +
>> +=09=09hlist_for_each_entry_safe(dev, next, head, index_hlist) {
>> +=09=09=09if (netdev !=3D dev->dev)
>> +=09=09=09=09continue;
>> +
>> +=09=09=09hlist_del_rcu(&dev->index_hlist);
> There is another issue...
> "dtab->items--;"

Right, of course. Thanks for your diligence in spotting my silly
mistakes! Will send a v4 :)

-Toke

