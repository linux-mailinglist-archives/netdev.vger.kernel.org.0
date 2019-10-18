Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF77DCF41
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505956AbfJRT2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:28:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23269 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2502430AbfJRT2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 15:28:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571426899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ReGmZfxNLrIuLgZJ1ThEBBVuP3LStbYtdPYwtz23/vM=;
        b=T2VLUeBFxEfo9GhzmbSk211H297NOg9UAYY5rVu+lUZ3Eb347Vl0k3gFSv/Z7GurSRb0ES
        VXyLfdbC3GJMpIM7BZ7I8eLvwQWDkxiF204t+v18dsIHaqAmJUqiRskodJUdcnoojFTS5T
        /7ug7mpTLBmLroIIBUP2lGhErMRIlHs=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-Oh-okwwtP0yE8wmhe99mLQ-1; Fri, 18 Oct 2019 15:28:17 -0400
Received: by mail-lf1-f72.google.com with SMTP id c27so1446285lfj.19
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 12:28:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=8lD3afoo9Y+y5S3nT5ktvWu7wmYcHUcDBojvsLe+bew=;
        b=LhSGaYt3H/3p5wxmQC4T0tNknqOqLRKn5z5Jc6DFINXUp9Fi0vt14iWJhSMYQkxAb9
         +zkj+WXOeBKT+O+S4PRZPmbzCSSfA3FWzgdvpP87lHyVrnawiWvWmD8H8hYKh/poMAcj
         pKOcShMd+b2LQKTqy0Lfezi6hjz3q0RgdIpkuF1tfrnMNQOlrVBSium6MAZ23Z4KEfAQ
         2nD92orbqrFjevjo6kuhGwbz8O6wojmDsTCfUeegWRqD+eJAOalP8dlp4pzVFsxhSzyH
         LsYYMX6N6DoYz99EgCSgislTVTPOvj5po8fBKw+xoCcLdlTiJpw23FVm6IHGTONWe0zy
         LrCQ==
X-Gm-Message-State: APjAAAX8/YNh6Z5SlhACqESDoLwUZwug+3g01PGErVaMMlGQ0A3S2uC+
        5KklemaVKsgHBj+b83+9PKqEcn/9ruTX3H7tCP4k6e9BMU8wlaX2bt6i/5JVN/efikOXN4uhlp0
        7OHEMZVuvdWbBxmFR
X-Received: by 2002:a19:f107:: with SMTP id p7mr5544649lfh.91.1571426896260;
        Fri, 18 Oct 2019 12:28:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx4lubWUulL34gzxM41pSqL8vUg6UqCjnneyhVcYOLP6kmlk0Lt2/P31DSg0SBfU3TQloOZEw==
X-Received: by 2002:a19:f107:: with SMTP id p7mr5544638lfh.91.1571426896046;
        Fri, 18 Oct 2019 12:28:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id x5sm3927436lfg.71.2019.10.18.12.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 12:28:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9925D1804B6; Fri, 18 Oct 2019 21:28:14 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin Lau <kafai@fb.com>
Cc:     "daniel\@iogearbox.net" <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH bpf v2] xdp: Handle device unregister for devmap_hash map type
In-Reply-To: <20191018165049.rm6du3yq2e4vg45h@kafai-mbp>
References: <20191017105232.2806390-1-toke@redhat.com> <20191017190219.hpphf7jnyn6xapb6@kafai-mbp.dhcp.thefacebook.com> <87pniue4cw.fsf@toke.dk> <20191018165049.rm6du3yq2e4vg45h@kafai-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 18 Oct 2019 21:28:14 +0200
Message-ID: <87tv85dfap.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: Oh-okwwtP0yE8wmhe99mLQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Lau <kafai@fb.com> writes:

> On Fri, Oct 18, 2019 at 12:26:55PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Martin Lau <kafai@fb.com> writes:
>>=20
>> > On Thu, Oct 17, 2019 at 12:52:32PM +0200, Toke H=C3=B8iland-J=C3=B8rge=
nsen wrote:
>> >> It seems I forgot to add handling of devmap_hash type maps to the dev=
ice
>> >> unregister hook for devmaps. This omission causes devices to not be
>> >> properly released, which causes hangs.
>> >>=20
>> >> Fix this by adding the missing handler.
>> >>=20
>> >> Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up de=
vices by hashed index")
>> >> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >> ---
>> >> v2:
>> >>   - Grab the update lock while walking the map and removing entries.
>> >>=20
>> >>  kernel/bpf/devmap.c | 37 +++++++++++++++++++++++++++++++++++++
>> >>  1 file changed, 37 insertions(+)
>> >>=20
>> >> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>> >> index d27f3b60ff6d..a0a1153da5ae 100644
>> >> --- a/kernel/bpf/devmap.c
>> >> +++ b/kernel/bpf/devmap.c
>> >> @@ -719,6 +719,38 @@ const struct bpf_map_ops dev_map_hash_ops =3D {
>> >>  =09.map_check_btf =3D map_check_no_btf,
>> >>  };
>> >> =20
>> >> +static void dev_map_hash_remove_netdev(struct bpf_dtab *dtab,
>> >> +=09=09=09=09       struct net_device *netdev)
>> >> +{
>> >> +=09unsigned long flags;
>> >> +=09int i;
>> > dtab->n_buckets is u32.
>>=20
>> Oh, right, will fix.
>>=20
>> >> +
>> >> +=09spin_lock_irqsave(&dtab->index_lock, flags);
>> >> +=09for (i =3D 0; i < dtab->n_buckets; i++) {
>> >> +=09=09struct bpf_dtab_netdev *dev, *odev;
>> >> +=09=09struct hlist_head *head;
>> >> +
>> >> +=09=09head =3D dev_map_index_hash(dtab, i);
>> >> +=09=09dev =3D hlist_entry_safe(rcu_dereference_raw(hlist_first_rcu(h=
ead)),
>> > The spinlock has already been held.  Is rcu_deref still needed?
>>=20
>> I guess it's not strictly needed, but since it's an rcu-protected list,
>> and hlist_first_rcu() returns an __rcu-annotated type, I think we will
>> get a 'sparse' warning if it's omitted, no?
>>=20
>> And since it's just a READ_ONCE, it doesn't actually hurt since this is
>> not the fast path, so I'd lean towards just keeping it? WDYT?
>>
> Can hlist_for_each_safe() be used instead then?
> A bonus is the following long line will go away.
> I think the change will be simpler also.

Ohhh, yes it can! I was looking for that variant of the for_each macro
(the removal-safe one) and scratching my head as to why it wasn't there.
Dunno how I missed that; thanks, will fix and resend! :)

-Toke

