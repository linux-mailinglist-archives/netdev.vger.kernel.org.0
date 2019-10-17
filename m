Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A78FDA9F2
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 12:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408765AbfJQK2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 06:28:12 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:47887 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405814AbfJQK2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 06:28:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571308091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SUrbnQiqmpqS/YlT1VuyBnuaYpXOzD+Q3aYbuct/XkI=;
        b=Qd6QEuaX9CXLrEKq4iOMZZyIy/9mXUsDayVAsyXR0sEJ2cVSs183R0F5P+HlWSVoiiPo3j
        jpBBRnnA0eaGfCTWcRY2v1TKsGucGtayvQfiyyFs9Wywk3GB73kPh/93pAEdHEGzBP8Mn1
        3RCrYb4tVl8EcYSg2HIE4jAJayEGd0o=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-0cwlvFclN5yFTYXzSlEl8Q-1; Thu, 17 Oct 2019 06:28:08 -0400
Received: by mail-lj1-f200.google.com with SMTP id y28so334290ljn.2
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 03:28:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=SUrbnQiqmpqS/YlT1VuyBnuaYpXOzD+Q3aYbuct/XkI=;
        b=cr+cuDx/GBGDoeN6hCG31haXkd8QnM3LaLl8IA7YTekS2ck8Fi1gkPPJRhWWwgnq10
         a49GR3NJKWyiRfLUrQJ6p8P0WH02v1b78fx5EGK5cnCvNUz31XIeTju68+OpbebBaHNe
         J9cFUgyAyeXYaa53FPytUG++YrA4ZBgwdAw50H5tu3gqJN1/Lq0JmrvpjjjdkLtKNDsh
         caGXMOxCnUvJci5L33yeh8dIfEKixBJDkoJ8QE3ncWtkuoECf8JmgOcflKidbN2/uUrP
         q26bH/ONrr25RAwQjS0WmZSpTKD/zrkuxfi01oJfFisi/uF/yDfCaelR7Wo3QTZazgBB
         m9Kw==
X-Gm-Message-State: APjAAAX4WU5PV5MZ3VTXyxWQCE1ETJfcAKME3VRaYPj1qQU2jJq7MRXe
        xwoUQtmx/iJdZCPEASRcZwp00vwnHQfR6FK2zb9iyhZ0/13rBH1YEbQRTvVf71fsLSZaqfopvCv
        w9KeK6/8smgbZG7sz
X-Received: by 2002:a2e:9a88:: with SMTP id p8mr1806380lji.249.1571308087115;
        Thu, 17 Oct 2019 03:28:07 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxyBztTJDKmj6PcLaxgXYLtGs9TS2JLgmdk8pt41jJm1scVvVFX6e5E/w+XHIcT1Em6yVLZMg==
X-Received: by 2002:a2e:9a88:: with SMTP id p8mr1806365lji.249.1571308086893;
        Thu, 17 Oct 2019 03:28:06 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id q19sm2599515lfj.9.2019.10.17.03.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 03:28:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id ABEDC1804C9; Thu, 17 Oct 2019 12:28:05 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     daniel@iogearbox.net, ast@fb.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf] xdp: Handle device unregister for devmap_hash map type
In-Reply-To: <2d516208-8c46-707c-4484-4547e66fc128@i-love.sakura.ne.jp>
References: <20191016132802.2760149-1-toke@redhat.com> <2d516208-8c46-707c-4484-4547e66fc128@i-love.sakura.ne.jp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 17 Oct 2019 12:28:05 +0200
Message-ID: <87ftjrfyyy.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: 0cwlvFclN5yFTYXzSlEl8Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> writes:

> On 2019/10/16 22:28, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
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
>
> Well, regarding 6f9d451ab1a3, I think that we want explicit "(u64)" cast
>
> @@ -97,6 +123,14 @@ static int dev_map_init_map(struct bpf_dtab *dtab, un=
ion bpf_attr *attr)
>         cost =3D (u64) dtab->map.max_entries * sizeof(struct bpf_dtab_net=
dev *);
>         cost +=3D sizeof(struct list_head) * num_possible_cpus();
>
> +       if (attr->map_type =3D=3D BPF_MAP_TYPE_DEVMAP_HASH) {
> +               dtab->n_buckets =3D roundup_pow_of_two(dtab->map.max_entr=
ies);
> +
> +               if (!dtab->n_buckets) /* Overflow check */
> +                       return -EINVAL;
> +               cost +=3D sizeof(struct hlist_head) * dtab->n_buckets;
>
>                                                     ^here
>
> +       }
> +
>         /* if map size is larger than memlock limit, reject it */
>         err =3D bpf_map_charge_init(&dtab->map.memory, cost);
>         if (err)
>
> like "(u64) dtab->map.max_entries * sizeof(struct bpf_dtab_netdev *)" doe=
s.
> Otherwise, on 32bits build, "sizeof(struct hlist_head) * dtab->n_buckets"=
 can become 0.

Oh, right. I kinda assumed the compiler would be smart enough to figure
that out based on the type of the LHS; will send a separate fix for this.

-Toke

