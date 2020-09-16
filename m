Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A84A26CEBA
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgIPW1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:27:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50442 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726187AbgIPW11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:27:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600295245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hQxDf8JFFogGWBF/VUiJ5CChMgFQy7XyAzV/ZZzgvOY=;
        b=bcBUT33Yq4dfOeH5VuF8Iitk/qCgdRK8iFZ6NxAjS/uftydBTJpFrel5T2Z+PGzwCLRzgA
        kw+huil1SKNr/NCG6S6sTbaguDwGWURA+R6uzoq58Uf2etZmzujPPUii/SZbkzdwkMsKOx
        CSdHT9oHlSq7F2oMfecIzWPy+F/8xWQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-dm91wSHbOMytOpAjx-QrjA-1; Wed, 16 Sep 2020 17:27:07 -0400
X-MC-Unique: dm91wSHbOMytOpAjx-QrjA-1
Received: by mail-wr1-f69.google.com with SMTP id 33so3073895wre.0
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 14:27:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=hQxDf8JFFogGWBF/VUiJ5CChMgFQy7XyAzV/ZZzgvOY=;
        b=EtXt3oulVw3G9ZLnKtsTc/ldGvGLkJrB3dydYHwb8o9IyeDU8owDOXUJYzhFVnU6Ec
         tkIw26LwGSSrrFg4CxGAP4t6y8B1r4OfQw55ee7ey83R6bx1Jawvfmcu17BCkFQtIgWO
         UWM0280VdnUmZFkch/isUPEvLUqELt0MWIKOkt6xNh5r02C1T2ChMSek5CtUFmB49bY8
         LgV795Ls/+mcXVrDQjoYaAPqkXCJRHWAOfW45YpyS0uXutonKI6SVyMODpGwbwBYrUX1
         FAMvbvzZwXcU6lBbDn/+7JjTSGd7cjX6ALVk+fgSy3ydhBY/Okp5IVb1XotWr7lC+W2x
         xB5g==
X-Gm-Message-State: AOAM530AWscX4GZewwnfVaRZzZ1Onv9bHcLaBusQHjbPpfUa+j7IoKZN
        ROAMqyW6dezNdBZstm698V76foSvO2usnO09LkjsEVLANq7AYG36gOt7iTyIk1u+3Eu3+1Qs3s/
        XIFirMRYBLqTX6TZj
X-Received: by 2002:a7b:c341:: with SMTP id l1mr6867924wmj.80.1600291625773;
        Wed, 16 Sep 2020 14:27:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/SkXRCKaZasukIexmx8qH+ipJwS/1Eihx9dlzAbJ4izLrfzMv9BtsY4zH1JWxRmOHLuFNfw==
X-Received: by 2002:a7b:c341:: with SMTP id l1mr6867893wmj.80.1600291625439;
        Wed, 16 Sep 2020 14:27:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t22sm8919184wmt.1.2020.09.16.14.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 14:27:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 86742183A90; Wed, 16 Sep 2020 23:27:04 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v5 4/8] bpf: support attaching freplace
 programs to multiple attach points
In-Reply-To: <CAEf4BzY+nMbye8wkQjiUra7wHtWZ14aWO5kNwkQFQaj=6-qp9w@mail.gmail.com>
References: <160017005691.98230.13648200635390228683.stgit@toke.dk>
 <160017006133.98230.8867570651560085505.stgit@toke.dk>
 <CAEf4BzYP6MpVEqJ1TVW6rcfqJjkBi9x9U9F8MZPQdGMmoaUX_A@mail.gmail.com>
 <87r1r1pgr5.fsf@toke.dk>
 <CAEf4BzY+nMbye8wkQjiUra7wHtWZ14aWO5kNwkQFQaj=6-qp9w@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 16 Sep 2020 23:27:04 +0200
Message-ID: <87een1pg47.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Wed, Sep 16, 2020 at 2:13 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>>
>> [ will fix all your comments above ]
>>
>> >> @@ -3924,10 +3983,16 @@ static int tracing_bpf_link_attach(const unio=
n bpf_attr *attr, struct bpf_prog *
>> >>             prog->expected_attach_type =3D=3D BPF_TRACE_ITER)
>> >>                 return bpf_iter_link_attach(attr, prog);
>> >>
>> >> +       if (attr->link_create.attach_type =3D=3D BPF_TRACE_FREPLACE &&
>> >> +           !prog->expected_attach_type)
>> >> +               return bpf_tracing_prog_attach(prog,
>> >> +                                              attr->link_create.targ=
et_fd,
>> >> +                                              attr->link_create.targ=
et_btf_id);
>> >
>> > Hm.. so you added a "fake" BPF_TRACE_FREPLACE attach_type, which is
>> > not really set with BPF_PROG_TYPE_EXT and is only specified for the
>> > LINK_CREATE command. Are you just trying to satisfy the link_create
>> > flow of going from attach_type to program type? If that's the only
>> > reason, I think we can adjust link_create code to handle this more
>> > flexibly.
>> >
>> > I need to think a bit more whether we want BPF_TRACE_FREPLACE at all,
>> > but if we do, whether we should make it an expected_attach_type for
>> > BPF_PROG_TYPE_EXT then...
>>
>> Yeah, wasn't too sure about this. But attach_type seemed to be the only
>> way to disambiguate between the different link types in the LINK_CREATE
>> command, so went with that. Didn't think too much about it, TBH :)
>
> having extra attach types has real costs in terms of memory (in cgroup
> land), which no one ever got to fixing yet. And then
> prog->expected_attach_type !=3D link's expected_attach_type looks weird
> and wrong and who knows which bugs we'll get later because of this.
>
>>
>> I guess an alternative could be to just enforce attach_type=3D=3D0 and l=
ook
>> at prog->type? Or if you have any other ideas, I'm all ears!
>
> Right, we have prog fd, so can get it (regardless of type), then do
> switch by type, then translate expected attach type to prog type and
> see if it matches, but only for program types that care (which right
> now is all but tracing, where it's obvious from prog_type alone, I
> think).

Right, makes sense; will do that in the next version!

-Toke

