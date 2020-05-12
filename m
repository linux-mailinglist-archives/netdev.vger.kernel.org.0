Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E1A1CF52B
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 15:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbgELNCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 09:02:51 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33084 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgELNCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 09:02:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589288569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FHy5uGJufwajym7rdjrv9kV8JNPYEhlwWl3JM7PucCY=;
        b=INjbV2fMDNIYtQnfaT6Mrqfjc46DhqlS8JZgQJvveq7QW8G97zCEiZ0e7Vezwdd84U9fkB
        2kcILxS4Clu8vktQsSmWKavnRBadA34Q2b9txwkiXXLysj1eytubroxWNQp6C+hARnz/7H
        gXL/O/HsQ7FQbcFfO6qKxOvdSnV8Hdc=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-dFLU8sZRPCK6G1SdYqF5lw-1; Tue, 12 May 2020 09:02:47 -0400
X-MC-Unique: dFLU8sZRPCK6G1SdYqF5lw-1
Received: by mail-lj1-f197.google.com with SMTP id q2so1870247ljq.16
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 06:02:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=FHy5uGJufwajym7rdjrv9kV8JNPYEhlwWl3JM7PucCY=;
        b=hngq66h2X7RFYBfARk9vh0OHeBaQXJKajrDepPdbN2I8Oc4Sxd4jzGyAMbD6sRtKph
         T3Cp3i/ayptK+ctROa8pXzGOogrJaAJBXCxpiolx1HILlI4v+2UyqUKlA7OkTAzcyitt
         SDtQsm52eT+9kqSMp6uWSRA8psiwADmdWGi/yaeR5yt2mUjf7Sx4i7BPjXbkVreoVeZh
         eoXb5msnHb+rX9S59MtzDVghalQ0+eGivChVBYS8tvydIQSywKxy773kuXEVtWSra9yj
         axt8xdxvkyky/SXQjCjwbVF2vS/L0nePcPcOR3Pz1NY2FgabLwAru8yhB/lxiTyoWZd4
         cYRg==
X-Gm-Message-State: AOAM532UqVuLyfw+ErmeEW4vdNfv5FiwFkMm8nMEFD2lbzLbVnLVJnWb
        PLHXay274lxaUHrUCufSSQb0dsjU8zB3bRfCfuLmWVd3jT6weA74O8uNtyLhBLhfsC04CjpivMu
        gZYeCytzTyZp6+Lem
X-Received: by 2002:a2e:7d12:: with SMTP id y18mr14072018ljc.211.1589288565980;
        Tue, 12 May 2020 06:02:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw//hj7tAEVjb/rIsYU5rJTYqMEdazOE6/ECf5hTxekXy1ChR/FmjGiMg3QXRzt8dMPWQkstg==
X-Received: by 2002:a2e:7d12:: with SMTP id y18mr14071998ljc.211.1589288565675;
        Tue, 12 May 2020 06:02:45 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id y9sm12667048ljy.31.2020.05.12.06.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 06:02:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0E1D9181509; Tue, 12 May 2020 15:02:43 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: bpf: ability to attach freplace to multiple parents
In-Reply-To: <alpine.LRH.2.21.2005121009220.22093@localhost>
References: <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com> <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com> <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com> <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com> <20200326195340.dznktutm6yq763af@ast-mbp> <87o8sim4rw.fsf@toke.dk> <20200402202156.hq7wpz5vdoajpqp5@ast-mbp> <87o8s9eg5b.fsf@toke.dk> <20200402215452.dkkbbymnhzlcux7m@ast-mbp> <87h7wlwnyl.fsf@toke.dk> <alpine.LRH.2.21.2005121009220.22093@localhost>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 12 May 2020 15:02:42 +0200
Message-ID: <87r1vpuwzx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alan Maguire <alan.maguire@oracle.com> writes:

> On Tue, 12 May 2020, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>=20
>> >> > Currently fentry/fexit/freplace progs have single prog->aux->linked=
_prog pointer.
>> >> > It just needs to become a linked list.
>> >> > The api extension could be like this:
>> >> > bpf_raw_tp_open(prog_fd, attach_prog_fd, attach_btf_id);
>> >> > (currently it's just bpf_raw_tp_open(prog_fd))
>> >> > The same pair of (attach_prog_fd, attach_btf_id) is already passed =
into prog_load
>> >> > to hold the linked_prog and its corresponding btf_id.
>> >> > I'm proposing to extend raw_tp_open with this pair as well to
>> >> > attach existing fentry/fexit/freplace prog to another target.
>> >> > Internally the kernel verify that btf of current linked_prog
>> >> > exactly matches to btf of another requested linked_prog and
>> >> > if they match it will attach the same prog to two target programs (=
in case of freplace)
>> >> > or two kernel functions (in case of fentry/fexit).
>> >>=20
>> >> API-wise this was exactly what I had in mind as well.
>> >
>> > perfect!
>>
>
> Apologies in advance if I've missed a way to do this, but
> for fentry/fexit, if we could attach the same program to
> multiple kernel functions, it would be great it we could
> programmatically access the BTF func proto id for the
> attached function (prog->aux->attach_btf_id I think?).

Yes! I pushed for adding this to the GET_LINK_INFO operation, but it
wasn't included the first time around; I still think it ought to be added.

Actually in general, getting the btf_id of the currently running
function for any type of BPF program would be good; e.g., for xdpdump we
want to attach to a running XDP program, but we need the btf_id of the
main function. And because the name can be truncated to BPF_OBJ_NAME_LEN
when returned from the kernel, we have to walk the BTF info for the
program, and basically guess...

-Toke

