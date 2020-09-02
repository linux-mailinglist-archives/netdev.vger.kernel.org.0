Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3456125B5EC
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 23:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgIBVdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 17:33:14 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38639 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726926AbgIBVdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 17:33:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599082389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H368D3ZjVszsjbdmoLuZGFudZhOJwJboSRtKlrtcivk=;
        b=Acb+rWH6SzYcv/stPlMv4sTOtHT8sC9p4rBKgNRB9wXdt2pLZNq0km460EydSE1iLfM8ot
        8jlZ5ihAaB/Ubl5SxjKJN3EllpXCxuZpR5Ae683SERk/ZcyxkxhJXxTVsTVP6AYVCkZi1C
        6MNIqcVpV2493J0Z+9xe/j9GuBrwnQM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-8yhK8SR-MMG660Jofu-DbA-1; Wed, 02 Sep 2020 17:33:08 -0400
X-MC-Unique: 8yhK8SR-MMG660Jofu-DbA-1
Received: by mail-wm1-f69.google.com with SMTP id a7so249502wmc.2
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 14:33:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=H368D3ZjVszsjbdmoLuZGFudZhOJwJboSRtKlrtcivk=;
        b=qTM62y5lyFDH5n5c8zYU86rEjAkthfwe+5iHXUTvIHy4ULq2BOG2RpcGtk3fBmYY1q
         m8J0R89R9gT+joI1isq7dGf1dFsG1HIuGTA/+cSOaMWv8TRE46KvOd6trC2OIdD/kxOG
         BPIesQp+OQBgRulvgP8/VbvrvbFoWwJXhxuGDCQsePgEaOg5BYZCqEo6GihgQJYF7xGO
         ibV+QPeFXUHZfhvUnapoYFaD/IsfRaZzaJ9e+qZEmEdnWcS+egfW/sQOr5ls+cRL32aN
         eGSixpQPHyA6Q+n+uyL2+Y/qI0Bon2l/6OCbtC4KqmLzIwVwW/mdCpdjHA0gWHmwk8PY
         cZlw==
X-Gm-Message-State: AOAM531BlaXMsmP9TOKItqvy3lYrSPgBJ83DascL+fQ4iZPQCGUWOBjd
        +yDzpYm8qudm9lijQ48buvbLgugnnK9dYT1EoygyyuJnEA0cj/pqB8XPLbcN6HI/nsPkz3GKeo0
        jDEdiuywSl/QOcU11
X-Received: by 2002:adf:fed1:: with SMTP id q17mr150051wrs.85.1599082387244;
        Wed, 02 Sep 2020 14:33:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqjl/bk2vtNzUV5BZ+vtYlr0do4LkWozLBdXJxVrkZrd+zoFCCub4riumE9gvW2BKew1UZ3g==
X-Received: by 2002:adf:fed1:: with SMTP id q17mr150031wrs.85.1599082386990;
        Wed, 02 Sep 2020 14:33:06 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id l126sm1217435wmf.39.2020.09.02.14.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 14:33:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 03798182009; Wed,  2 Sep 2020 23:33:05 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     sdf@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        YiFei Zhu <zhuyifei1999@gmail.com>, andriin@fb.com
Subject: Re: [PATCH bpf-next v3 4/8] libbpf: implement bpf_prog_find_metadata
In-Reply-To: <20200902210838.7a26mfi54dufou5a@ast-mbp.dhcp.thefacebook.com>
References: <20200828193603.335512-1-sdf@google.com>
 <20200828193603.335512-5-sdf@google.com> <874koma34d.fsf@toke.dk>
 <20200831154001.GC48607@google.com>
 <20200901225841.qpsugarocx523dmy@ast-mbp.dhcp.thefacebook.com>
 <874kogike9.fsf@toke.dk>
 <20200902210838.7a26mfi54dufou5a@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 02 Sep 2020 23:33:05 +0200
Message-ID: <87mu27hnji.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Wed, Sep 02, 2020 at 11:43:26AM +0200, Toke H=C3=83=C6=92=C3=82=C2=B8i=
land-J=C3=83=C6=92=C3=82=C2=B8rgensen wrote:
>> >
>> > I don't feel great about this libbpf api. bpftool already does
>> > bpf_obj_get_info_by_fd() for progs and for maps.
>> > This extra step and extra set of syscalls is redundant work.
>> > I think it's better to be done as part of bpftool.
>> > It doesn't quite fit as generic api.
>>=20
>> Why not?=20
>
> It's a helper function on top of already provided api and implemented
> in the most brute force and inefficient way.
> bpftool implementation of the same will be more efficient.

Right, certainly wouldn't mind something more efficient. But to me, the
inefficiency is outweighed by convenience of having this canonical
reference for 'this is the metadata map'.

>> so. If we don't have it, people will have to go look at bpftool code,
>> and we'll end up with copied code snippets, which seems less than ideal.
>
> I'd like to see the real use case first before hypothesising.

For me, that would be incorporating support for this into
libxdp/xdp-tools; which was the reason I asked for this to be split into
a separate API in the first place. But okay, not going to keep arguing
about this, I can copy-paste code as well as the next person.

-Toke

