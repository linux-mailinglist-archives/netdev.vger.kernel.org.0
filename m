Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83687DA9EE
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 12:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404947AbfJQK1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 06:27:17 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45405 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391295AbfJQK1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 06:27:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571308035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5HbCUndysV3LVxxKa9QjLpBPu7lfw69q9iON3i9EPWI=;
        b=ThL0xBymWDcN9vFauZ/SL+WnqpEaE30Ilai9Jqf8DZziScVmo3iil/XD9vqbs6sycoFoy/
        V17QWs+62TjUoUCAIA9WApjySJzg4Gl8tH/EC3KU2O5MlTC8/PUNHcNJQCTh4wZWet1dJR
        FfzBKRYMRTxs4G0F9CcnCis7BVFtb9s=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-ibLYi1s8OBq-3KFlWVkhEg-1; Thu, 17 Oct 2019 06:27:14 -0400
Received: by mail-lj1-f199.google.com with SMTP id l13so332005lji.7
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 03:27:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=mtI1tQKCQhTsfvHX3dwJ+I86Ajrl7tuPkb4U57R05Mc=;
        b=lLjaaqbI0B13FoT4DwSlg4mbH4zKsm00ky/O8AoscFoEHR8TYOqqJgJgcAZ9KP6hLU
         Go7ho3TSR/lnoyToDEcjtRU7ScpnL+JK1EOiKAYg9hyZ0E6/+wtf5wWPKstFlqif9pz3
         7oADHWxCLfoIhorymD0G76Df7mieLqpcvilUoANBuvAj99tJaEAPZ8ufjmDZ9thZS1Nf
         e7yzirH/MzVIbfNNfy1+KH7nAkDcPaEHg5iq7otfS33y+G6dzpNJZd/AMzTU9k4w3dis
         zmDEd6yKzsrDMIgz4yVHmEgUzUGnymPcGaKL7FhtodjAbQI/G1OCnAycSBQ3KxVmV8L7
         L4sg==
X-Gm-Message-State: APjAAAVVnF0/x9gCd7TDuEhYteckxEBt2oXYLixfPPT0QJ2kEVQycqq8
        j6tt8IDu+CIJpoOvaP0jeIxweae6oWw8GDOQCZEp8ssphcJLJs1wxrWJnEhktQp4uXNxIXvpK/v
        Xfk0cojyffHRlCeLm
X-Received: by 2002:a2e:9a99:: with SMTP id p25mr1927574lji.171.1571308032923;
        Thu, 17 Oct 2019 03:27:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwADMJzLI125M9qegqVCbIuUwb+ZoQXdESooj8W8kLhrEeAHiJCSM2PWTOavnc8zuxoNwOpsg==
X-Received: by 2002:a2e:9a99:: with SMTP id p25mr1927554lji.171.1571308032484;
        Thu, 17 Oct 2019 03:27:12 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id i17sm1064714lfj.35.2019.10.17.03.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 03:27:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 52C9A1804C9; Thu, 17 Oct 2019 12:27:11 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin Lau <kafai@fb.com>
Cc:     "daniel\@iogearbox.net" <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH bpf] xdp: Handle device unregister for devmap_hash map type
In-Reply-To: <20191016162357.b2kdf6cflw3c5gzb@kafai-mbp.dhcp.thefacebook.com>
References: <20191016132802.2760149-1-toke@redhat.com> <20191016162357.b2kdf6cflw3c5gzb@kafai-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 17 Oct 2019 12:27:11 +0200
Message-ID: <87imonfz0g.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: ibLYi1s8OBq-3KFlWVkhEg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Lau <kafai@fb.com> writes:

> On Wed, Oct 16, 2019 at 03:28:02PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
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
>>  kernel/bpf/devmap.c | 34 ++++++++++++++++++++++++++++++++++
>>  1 file changed, 34 insertions(+)
>>=20
>> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>> index d27f3b60ff6d..deb9416341e9 100644
>> --- a/kernel/bpf/devmap.c
>> +++ b/kernel/bpf/devmap.c
>> @@ -719,6 +719,35 @@ const struct bpf_map_ops dev_map_hash_ops =3D {
>>  =09.map_check_btf =3D map_check_no_btf,
>>  };
>> =20
>> +static void dev_map_hash_remove_netdev(struct bpf_dtab *dtab,
>> +=09=09=09=09       struct net_device *netdev)
>> +{
>> +=09int i;
>> +
>> +=09for (i =3D 0; i < dtab->n_buckets; i++) {
>> +=09=09struct bpf_dtab_netdev *dev, *odev;
>> +=09=09struct hlist_head *head;
>> +
>> +=09=09head =3D dev_map_index_hash(dtab, i);
>> +=09=09dev =3D hlist_entry_safe(rcu_dereference_raw(hlist_first_rcu(head=
)),
>> +=09=09=09=09       struct bpf_dtab_netdev,
>> +=09=09=09=09       index_hlist);
>> +
>> +=09=09while (dev) {
>> +=09=09=09odev =3D (netdev =3D=3D dev->dev) ? dev : NULL;
>> +=09=09=09dev =3D hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(&d=
ev->index_hlist)),
>> +=09=09=09=09=09       struct bpf_dtab_netdev,
>> +=09=09=09=09=09       index_hlist);
>> +
>> +=09=09=09if (odev) {
>> +=09=09=09=09hlist_del_rcu(&odev->index_hlist);
> Would it race with the dev_map_hash's update/delete side?

Oh, right, seems I forgot to grab the lock; will send a v2!

-Toke

