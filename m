Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE4A9134704
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgAHQBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:01:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39593 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727152AbgAHQBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:01:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578499272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4xKVuM9nzEaeHEeZtkNiiZBSz9T76Ah6WfmYf30vCkQ=;
        b=ZnPUYdPxe9/+T9g3cQzrFR6Ezs7soRkVbIe8U5Yd5mFvtj6ybJQHOxH8oLw9BF2uOEd2mq
        QJwhbp74bYnSJ2Mt7DPTn/Chaf8bBTpTwof9D0Yts1m+NPj8DnuaZybNnahCcvCn6ykpK4
        jU2arsRBH3OiXl2VI0PLCE1XQd6NBHI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-yw3LmqfWMRm1mVtRrZzCNA-1; Wed, 08 Jan 2020 11:01:11 -0500
X-MC-Unique: yw3LmqfWMRm1mVtRrZzCNA-1
Received: by mail-wm1-f69.google.com with SMTP id s25so508560wmj.3
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 08:01:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=4xKVuM9nzEaeHEeZtkNiiZBSz9T76Ah6WfmYf30vCkQ=;
        b=dK1jaw50o6CzBTwKGOFDRW08kf9OEfV9F8qjWrCEjnuchncdYV2s27FrMbrRZlRAoP
         vjmHAyspvyfVEm7A1QJQro2QKPJoeL7fQvYeEPgZ7OLrM4teVoXC3lW8UKMW2EQfkc6u
         QqG5H1oPGSnapcf9k1MSIZSPG3qDBj7PiOdSFUIZGudANVgLjMWd2x31VPNkYV6hreVg
         dWrBXdz2xMRvbbhmF/7TtOa+41ZWFAnf7kDGAJCcURSSFjLT3ZCm0QOqMOeuNzBTtL2D
         ko5Os7ltT5PnpmPOfjI6PWmurlSq5sIK0uST9sMmZ+J0Fqf5Xakc2/qSeoOXdvNKvkr8
         Wpdw==
X-Gm-Message-State: APjAAAVRSwfUQ5PD2iz5gkoOkFjnAhOy3fa7oGr4VWa1CvZl4eeMxfzx
        2p1LxBeEfL5r+fleiYxk6IYkC8yeNRVQCcCzgvW2WDB8p80wTJwZ41Pi2BytPZmIe4NGRgds9FB
        2riZrOPYXYRz+/PVz
X-Received: by 2002:a1c:ddc5:: with SMTP id u188mr4471332wmg.83.1578499270581;
        Wed, 08 Jan 2020 08:01:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqz7XenpCkrRousPs3FwhO87GodymB5dcnjWrb2g5RKaBO6MSxTljmljmjgY3DBhlAnAkhIWLA==
X-Received: by 2002:a1c:ddc5:: with SMTP id u188mr4471306wmg.83.1578499270397;
        Wed, 08 Jan 2020 08:01:10 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t12sm4664010wrs.96.2020.01.08.08.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 08:01:08 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 69D17180ADD; Wed,  8 Jan 2020 17:01:08 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBl?= =?utf-8?B?bA==?= 
        <bjorn.topel@gmail.com>, John Fastabend <john.fastabend@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Karlsson\, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next v2 4/8] xsk: make xskmap flush_list common for all map instances
In-Reply-To: <5e15faaac42e7_67ea2afd262665bc44@john-XPS-13-9370.notmuch>
References: <20191219061006.21980-1-bjorn.topel@gmail.com> <20191219061006.21980-5-bjorn.topel@gmail.com> <5e14c5d4c4959_67962afd051fc5c062@john-XPS-13-9370.notmuch> <CAJ+HfNiQOpAbHHT9V-gcp9u=vVDoP6uSoz2f-diEFrfX_88pMg@mail.gmail.com> <5e15faaac42e7_67ea2afd262665bc44@john-XPS-13-9370.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 08 Jan 2020 17:01:08 +0100
Message-ID: <87lfqigcor.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Bj=C3=B6rn T=C3=B6pel wrote:
>> On Tue, 7 Jan 2020 at 18:54, John Fastabend <john.fastabend@gmail.com> w=
rote:
>> >
>> > Bj=C3=B6rn T=C3=B6pel wrote:
>> > > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>> > >
>> > > The xskmap flush list is used to track entries that need to flushed
>> > > from via the xdp_do_flush_map() function. This list used to be
>> > > per-map, but there is really no reason for that. Instead make the
>> > > flush list global for all xskmaps, which simplifies __xsk_map_flush()
>> > > and xsk_map_alloc().
>> > >
>> > > Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> > > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>> > > ---
>> >
>> > Just to check. The reason this is OK is because xdp_do_flush_map()
>> > is called from NAPI context and is per CPU so the only entries on
>> > the list will be from the current cpu napi context?
>>=20
>> Correct!
>>=20
>> > Even in the case
>> > where multiple xskmaps exist we can't have entries from more than
>> > a single map on any list at the same time by my reading.
>> >
>>=20
>> No, there can be entries from different (XSK) maps. Instead of
>> focusing on maps to flush, focus on *entries* to flush. At the end of
>> the poll function, all entries (regardless of map origin) will be
>> flushed. Makes sense?
>
> Ah OK. This would mean that a single program used multiple maps
> though correct? Because we can only run a single BPF program per
> NAPI context.

Yeah, there's nothing limiting each program to a single map (of any
type)...

-Toke

