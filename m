Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F3FDC2C1
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 12:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408162AbfJRK1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 06:27:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30960 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2408091AbfJRK1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 06:27:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571394421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BeuDCkbdjZd6gdyc51v/qmoowy/+/1wpGOjuQg10uPM=;
        b=ESgn+DWTB1E/AuJgeJhEsD67pS9W05+jdkCB+52DgjZI0SJjEWOhSgGpmMiR1JPlPH/R8Y
        pm2z5OahVUxr5VVMsniAsoe5hF9sUDnifzu7kumybeAD/XZsKtZEzPYvvGg8YWqWao+QGm
        vCxP9FCTO86Lr/ONN+qyDzFvLERdpF8=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-tRnWbWWwMXGCpa9em7Q2sQ-1; Fri, 18 Oct 2019 06:26:59 -0400
Received: by mail-lf1-f69.google.com with SMTP id a14so1173533lfk.18
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 03:26:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=2AS9tqInMOMb87CSgWhEcDmJ3qwg0GuS/t1fAuKflFE=;
        b=LDo1NLK3AvOd1JRq/1vgh86vcoFBUfnCwuKS6lrt1AmnKUEB3ozHbC0F4ak5Hee0yk
         zuqm9kd4ceVkQZshL5g/x0pViAi9b5afGGsjd+Eoap6FQi2BIg1w3RVhlHXWAfDaxE2b
         jt4faRB+4U/qrq1B+lwy2VWt/hNvdghJ5TmbAHITcv6pJ8TOobUj/ZiQZeuVVSZG50Yt
         oNYx0NvLQetBLLai7UXqaf6cHo+njjqic38B/x9z3SxnFOSXc6As7dya8oXdaFkwLmVj
         gZqTtK3V9eoBFRBArnKrAl6vW2PoGSx2UIa8U8q23xSRsHMySGYkyf16fYhxqZEHhRQz
         GXlA==
X-Gm-Message-State: APjAAAWcyv8rMNeV3zzhwAHuPwxYBHDyaWGCw7SV+EBNbr4Mg7/YiGJ3
        xDUaPFWwMkmQ1t5WZ2S0M2/5Wqum8Gewot8TRX7g5bTyiDdQthmSpdlIxRRVECu2d3qTvUMBdS2
        QKg8te1P0cz0kuC6o
X-Received: by 2002:a2e:5354:: with SMTP id t20mr5684209ljd.227.1571394418363;
        Fri, 18 Oct 2019 03:26:58 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzj3vTLDeqZ78LJGnOeTUdLg+O2fC0g9lKw7X7HPwg4L0aG1vOczF5ThEUhrXLt48hpMF3+Xw==
X-Received: by 2002:a2e:5354:: with SMTP id t20mr5684189ljd.227.1571394417969;
        Fri, 18 Oct 2019 03:26:57 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id h10sm2229304ljb.14.2019.10.18.03.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 03:26:56 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DC3D21804C9; Fri, 18 Oct 2019 12:26:55 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin Lau <kafai@fb.com>
Cc:     "daniel\@iogearbox.net" <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH bpf v2] xdp: Handle device unregister for devmap_hash map type
In-Reply-To: <20191017190219.hpphf7jnyn6xapb6@kafai-mbp.dhcp.thefacebook.com>
References: <20191017105232.2806390-1-toke@redhat.com> <20191017190219.hpphf7jnyn6xapb6@kafai-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 18 Oct 2019 12:26:55 +0200
Message-ID: <87pniue4cw.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: tRnWbWWwMXGCpa9em7Q2sQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Lau <kafai@fb.com> writes:

> On Thu, Oct 17, 2019 at 12:52:32PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
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
>> v2:
>>   - Grab the update lock while walking the map and removing entries.
>>=20
>>  kernel/bpf/devmap.c | 37 +++++++++++++++++++++++++++++++++++++
>>  1 file changed, 37 insertions(+)
>>=20
>> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>> index d27f3b60ff6d..a0a1153da5ae 100644
>> --- a/kernel/bpf/devmap.c
>> +++ b/kernel/bpf/devmap.c
>> @@ -719,6 +719,38 @@ const struct bpf_map_ops dev_map_hash_ops =3D {
>>  =09.map_check_btf =3D map_check_no_btf,
>>  };
>> =20
>> +static void dev_map_hash_remove_netdev(struct bpf_dtab *dtab,
>> +=09=09=09=09       struct net_device *netdev)
>> +{
>> +=09unsigned long flags;
>> +=09int i;
> dtab->n_buckets is u32.

Oh, right, will fix.

>> +
>> +=09spin_lock_irqsave(&dtab->index_lock, flags);
>> +=09for (i =3D 0; i < dtab->n_buckets; i++) {
>> +=09=09struct bpf_dtab_netdev *dev, *odev;
>> +=09=09struct hlist_head *head;
>> +
>> +=09=09head =3D dev_map_index_hash(dtab, i);
>> +=09=09dev =3D hlist_entry_safe(rcu_dereference_raw(hlist_first_rcu(head=
)),
> The spinlock has already been held.  Is rcu_deref still needed?

I guess it's not strictly needed, but since it's an rcu-protected list,
and hlist_first_rcu() returns an __rcu-annotated type, I think we will
get a 'sparse' warning if it's omitted, no?

And since it's just a READ_ONCE, it doesn't actually hurt since this is
not the fast path, so I'd lean towards just keeping it? WDYT?

-Toke

