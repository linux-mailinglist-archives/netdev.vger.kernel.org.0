Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FC83542A6
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 16:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237530AbhDEOQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 10:16:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56654 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237435AbhDEOQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 10:16:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617632159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3odf2vfILdNMkO2s2+U+l93jP5VUsQZO+yjT8s2izqE=;
        b=EcOrLEHLGL2ZVOsGu6Fu4z219k8G7clay8Xcrp/SrNfE+1FKObbcysoZ0RjbHs2BNKltK9
        wCMpLQpiybYa3pXRYoPAkGVJpymB/oPn0H81L3cpKv0CyY+6A5aePy+NIEYyW9WvhGoleI
        bwi5dr23Ea+jNjibDE7za+3jhux9YSs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-P4oHuKFnNhePfZgViosp7g-1; Mon, 05 Apr 2021 10:15:58 -0400
X-MC-Unique: P4oHuKFnNhePfZgViosp7g-1
Received: by mail-ed1-f72.google.com with SMTP id o24so8775875edt.15
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 07:15:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=3odf2vfILdNMkO2s2+U+l93jP5VUsQZO+yjT8s2izqE=;
        b=RuANTxgC6dYyacU9PEH7OMAiv6qmO7uCOFtIxCRUkU5z1pw60Av26ca88QVo7Yw4gy
         /nNrGKjTkVknGZCajFj4OqoV/aFC9gThdeljRTF7MhRheQxXZN+UlgMIC+cBy3eFugIb
         qDn/vixMGPyTwnwZehm/yLHxWYDNLvoTzvKKYAeg8XZ92OFjfvXV57OQtCRKnqC5M/og
         TT9OStsMYcKGergjZ6FzWM0QVcGcE0wuPhSMJXBVoHXG1s84o+fRs3xYzaUEZXnNVmnC
         aGf4+C841uLTh5m/53tIB/XxZBDzDHCcs31KAiIhQw5GTAHnMIMZ5Doa1e7YYi9xZl1h
         zVxA==
X-Gm-Message-State: AOAM531s7lNS+RkCtpthzBS4QaWkLe4AfaKK5VSM7MFgDCLGRgGfd7qQ
        wqy7s7t//88zM6rmgMDH/c5zx3vKGgh/q5M6JrlA7BCez5qiOCmdvdSysCgUqGzqzKrmDf8E6YQ
        U813bGBClSZgtalJ+
X-Received: by 2002:a05:6402:2786:: with SMTP id b6mr18247926ede.310.1617632157213;
        Mon, 05 Apr 2021 07:15:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/kaX4UTFfF7Bmv/p6D2RrzmNIRppR03nf0JaMtLdLykhr1IltaGNuDma3/1383pOHhJZ7pw==
X-Received: by 2002:a05:6402:2786:: with SMTP id b6mr18247907ede.310.1617632157072;
        Mon, 05 Apr 2021 07:15:57 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g22sm8920711ejm.69.2021.04.05.07.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 07:15:56 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C73AB1802E8; Mon,  5 Apr 2021 16:15:54 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC PATCH bpf-next 1/4] bpf: Allow trampoline re-attach
In-Reply-To: <YGsZ0VGMk/hBfr2y@krava>
References: <20210328112629.339266-1-jolsa@kernel.org>
 <20210328112629.339266-2-jolsa@kernel.org> <87blavd31f.fsf@toke.dk>
 <20210403182155.upi6267fh3gsdvrq@ast-mbp> <YGsZ0VGMk/hBfr2y@krava>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 05 Apr 2021 16:15:54 +0200
Message-ID: <87ft04rf51.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Olsa <jolsa@redhat.com> writes:

> On Sat, Apr 03, 2021 at 11:21:55AM -0700, Alexei Starovoitov wrote:
>> On Sat, Apr 03, 2021 at 01:24:12PM +0200, Toke H=C3=B8iland-J=C3=B8rgens=
en wrote:
>> > >  	if (!prog->aux->dst_trampoline && !tgt_prog) {
>> > > -		err =3D -ENOENT;
>> > > -		goto out_unlock;
>> > > +		/*
>> > > +		 * Allow re-attach for tracing programs, if it's currently
>> > > +		 * linked, bpf_trampoline_link_prog will fail.
>> > > +		 */
>> > > +		if (prog->type !=3D BPF_PROG_TYPE_TRACING) {
>> > > +			err =3D -ENOENT;
>> > > +			goto out_unlock;
>> > > +		}
>> > > +		if (!prog->aux->attach_btf) {
>> > > +			err =3D -EINVAL;
>> > > +			goto out_unlock;
>> > > +		}
>> >=20
>> > I'm wondering about the two different return codes here. Under what
>> > circumstances will aux->attach_btf be NULL, and why is that not an
>> > ENOENT error? :)
>>=20
>> The feature makes sense to me as well.
>> I don't quite see how it would get here with attach_btf =3D=3D NULL.
>> Maybe WARN_ON then?
>
> right, that should be always there
>
>> Also if we're allowing re-attach this way why exclude PROG_EXT and LSM?
>>=20
>
> I was enabling just what I needed for the test, which is so far
> the only use case.. I'll see if I can enable that for all of them

How would that work? For PROG_EXT we clear the destination on the first
attach (to avoid keeping a ref on it), so re-attach can only be done
with an explicit target (which already works just fine)...

-Toke

