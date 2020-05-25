Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CE91E0ED0
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 14:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390595AbgEYM4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 08:56:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46961 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388770AbgEYM4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 08:56:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590411390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8+UU39F4E+uMqlLoqm3Jl4fNVXF7eXl0xA2y2ctv0OQ=;
        b=Mp27zAFzX6E/3bPBhHp73NdLf/ruKVBdVifJyGlclCdrpZEjWAHlDiPAhUQDtM1QaU+zEB
        j8YMH0D5JKdSfOQxPprrSKaojelODdpklLw89b4cb0zpZpEUGy9KgpDRK68fDGn3pQPCgE
        Z3rPsJDp3bagIQ7FOW7l2QEv4OasbBE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-FoMs0HxQP9uFUQMdTmYCBg-1; Mon, 25 May 2020 08:56:29 -0400
X-MC-Unique: FoMs0HxQP9uFUQMdTmYCBg-1
Received: by mail-ej1-f69.google.com with SMTP id bo19so2814550ejb.0
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 05:56:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=8+UU39F4E+uMqlLoqm3Jl4fNVXF7eXl0xA2y2ctv0OQ=;
        b=jnA9OLhGRq202nEOtHi9AGlevS5Kb1A9X7zhmAjOl9fIbue+3SufS9zaSti0PSbodW
         fLgYaf5L9Vg+srqfqHfxCQFow5w52fKgWuSV7sE8+slGbTtujEP+2CLeuIP/VwSomd6a
         ka7ObhgbSrKrfMUUExD21dDVYNaMBx+oqSrBHI8ZLLqRblBcxt9hAeEYQknZpTa/Mcab
         EtiiFd8g3SC34m3n9BL6ISmsSjyURRoRvwgxWf8tU6eNlsHcFH+GWGwPEE0uu+dIl0zq
         p67ZKOaY9/soKTPfJ0EhCxXt8ajxInpml1xw/sGAN1bOfObEkHXl/YX0h2SfQqsNe+uP
         4lmw==
X-Gm-Message-State: AOAM533ECO/1xAIopJyAXzR+yjNwZWBKTMpW4AeTbhPjZf49H/sEEjxh
        JVRd7qqU+ISv2eOT2seCXPq+1QWigXnuFPoDS347Uew3bcEQ9jZXJgDTGrWjjOPwUZhSgu8I0uH
        jgCllxZa3FYUA68Kg
X-Received: by 2002:aa7:c887:: with SMTP id p7mr14822841eds.269.1590411388049;
        Mon, 25 May 2020 05:56:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwkSEylustigZ9NkREuYBN0/ateToz4/05rxywQ1OvqnxlNu78BP5ZmEnbYcsLFP3PAR1Twrw==
X-Received: by 2002:aa7:c887:: with SMTP id p7mr14822821eds.269.1590411387777;
        Mon, 25 May 2020 05:56:27 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id c20sm15902155edy.41.2020.05.25.05.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 05:56:27 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6C5DD182C4B; Mon, 25 May 2020 14:56:26 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        brouer@redhat.com
Subject: Re: [PATCH RFC bpf-next 0/4] bpf: Add support for XDP programs in DEVMAPs
In-Reply-To: <20200525144752.3e87f8cd@carbon>
References: <20200522010526.14649-1-dsahern@kernel.org> <87lflkj6zs.fsf@toke.dk> <f94be4c8-c547-1be0-98c8-7e7cd3b7ee71@gmail.com> <87v9kki523.fsf@toke.dk> <20200525144752.3e87f8cd@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 25 May 2020 14:56:26 +0200
Message-ID: <87pnasi35x.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Mon, 25 May 2020 14:15:32 +0200
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>
>> David Ahern <dsahern@gmail.com> writes:
>>=20
>> > On 5/22/20 9:59 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:=20=20
>> >> David Ahern <dsahern@kernel.org> writes:
>> >>=20=20=20
>> >>> Implementation of Daniel's proposal for allowing DEVMAP entries to be
>> >>> a device index, program id pair. Daniel suggested an fd to specify t=
he
>> >>> program, but that seems odd to me that you insert the value as an fd=
, but
>> >>> read it back as an id since the fd can be closed.=20=20
>> >>=20
>> >> While I can be sympathetic to the argument that it seems odd, every
>> >> other API uses FD for insert and returns ID, so why make it different
>> >> here? Also, the choice has privilege implications, since the CAP_BPF
>> >> series explicitly makes going from ID->FD a more privileged operation
>> >> than just querying the ID.
>
> Sorry, I don't follow.
> Can someone explain why is inserting an ID is a privilege problem?

See description here:
https://lore.kernel.org/bpf/20200513230355.7858-1-alexei.starovoitov@gmail.=
com/

Specifically, this part:

> Consolidating all CAP checks at load time makes security model similar to
> open() syscall. Once the user got an FD it can do everything with it.
> read/write/poll don't check permissions. The same way when bpf_prog_load
> command returns an FD the user can do everything (including attaching,
> detaching, and bpf_test_run).
>=20
> The important design decision is to allow ID->FD transition for
> CAP_SYS_ADMIN only. What it means that user processes can run
> with CAP_BPF and CAP_NET_ADMIN and they will not be able to affect each
> other unless they pass FDs via scm_rights or via pinning in bpffs.


>> > I do not like the model where the kernel changes the value the user
>> > pushed down.=20=20
>>=20
>> Yet it's what we do in every other interface where a user needs to
>> supply a program, including in prog array maps. So let's not create a
>> new inconsistent interface here...
>
> I sympathize with Ahern on this.  It seems very weird to insert/write
> one value-type, but read another value-type.

Yeah, I do kinda agree that it's a bit weird. But it's what we do
everywhere else, so I think consistency wins out here. There might be an
argument that maps should be different (because they're conceptually a
read/write data structure not a syscall return value). But again, we
already have a map type that takes prog IDs, and that already does the
rewriting, so doing it different here would be even weirder...

-Toke

