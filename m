Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51116244022
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 22:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgHMUwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 16:52:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49482 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726499AbgHMUwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 16:52:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597351948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wxW06eavvjQE5S/miuSsmYpL0N+ppHpAk3tInVhZXVw=;
        b=BVJA63Ih5uk9ldKvEPeunRbTbu+FtI8Q9zjOKrcM0ckrjEdNR+9jyYL3XkEs5mSl8VjTSb
        jbqCbdE04MB+I1e/2o98PyaBIX3b0MGXf4lhOPEBrZfvL8EIPRy3d2HDgBTHuHIA/OaN5T
        KVWOfgMdSAW3OP+xdXHK8ioLNbmFSSw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-Fpuzu1rOMPOWACAMSiSINA-1; Thu, 13 Aug 2020 16:52:24 -0400
X-MC-Unique: Fpuzu1rOMPOWACAMSiSINA-1
Received: by mail-wr1-f70.google.com with SMTP id z12so2527795wrl.16
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 13:52:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=wxW06eavvjQE5S/miuSsmYpL0N+ppHpAk3tInVhZXVw=;
        b=ApIEQj7eYLBwrPJ+fX4Pltk1yPV3jdYjriC0ZEwSEQMmc9+E2/nMuGDTyGuPMrW3Tc
         lEE2qvChoQ1AncWreXYrvpmIgVUQ82qFzSXqLQw8OopsgmGj45JUjzo082h7uSizB6Mh
         aFRV2QdOiF5mmouVZVwet5upPELjT1fH8TaHKwodxu16oKNNLPlaZyz4lmFvZOl8FcgW
         RxhGatb3VXekOi76EPXeIuyfq5j44jLHARh1uWVYv3TQNO5/ZC6eUMU5HfVXV4BBCFLl
         zuXpCnS14chWpuGvw9fcxQ0OpsQnwo1E9fppzHlXBLBS/wr6HYgs7wClyZcikw9XqJgw
         ai5A==
X-Gm-Message-State: AOAM531FhVntI2g2D+6urfUhPcl/DGV24nouLDr00KXYB8D7ZNeudErw
        EvVFp86/3a4yzjpO8SXgX4BORZ0NchaAgxhPuxrCosmpn2iKtmqSE58wINDEMQff8bxlhWUPLDu
        j6wOqM7OkkaC/9omL
X-Received: by 2002:adf:e90f:: with SMTP id f15mr5777604wrm.18.1597351943681;
        Thu, 13 Aug 2020 13:52:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdRaaWG5XK/GB72XCdyO/ddbaB0kDUmcQI2wjL1g2kfocGA05c7/SyiiAki5Xo/nJX2Fbolg==
X-Received: by 2002:adf:e90f:: with SMTP id f15mr5777589wrm.18.1597351943457;
        Thu, 13 Aug 2020 13:52:23 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id r3sm11137607wro.1.2020.08.13.13.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2020 13:52:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 500A5180493; Thu, 13 Aug 2020 22:52:22 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf] libbpf: Prevent overriding errno when logging errors
In-Reply-To: <868b8e78-f0ae-8e59-1816-92051acba1f5@iogearbox.net>
References: <20200813142905.160381-1-toke@redhat.com>
 <CAEf4BzZ6yM_QWu0x4b51NAVzN6-EAoQN4ff4BNiof5CJ5ukhpg@mail.gmail.com>
 <87d03u1fyj.fsf@toke.dk>
 <868b8e78-f0ae-8e59-1816-92051acba1f5@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 13 Aug 2020 22:52:22 +0200
Message-ID: <87a6yy1d6h.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 8/13/20 9:52 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>> On Thu, Aug 13, 2020 at 7:29 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
>>>>
>>>> Turns out there were a few more instances where libbpf didn't save the
>>>> errno before writing an error message, causing errno to be overridden =
by
>>>> the printf() return and the error disappearing if logging is enabled.
>>>>
>>>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>>> ---
>>>
>>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>>>
>>>>   tools/lib/bpf/libbpf.c | 12 +++++++-----
>>>>   1 file changed, 7 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>>>> index 0a06124f7999..fd256440e233 100644
>>>> --- a/tools/lib/bpf/libbpf.c
>>>> +++ b/tools/lib/bpf/libbpf.c
>>>> @@ -3478,10 +3478,11 @@ bpf_object__probe_global_data(struct bpf_objec=
t *obj)
>>>>
>>>>          map =3D bpf_create_map_xattr(&map_attr);
>>>>          if (map < 0) {
>>>> -               cp =3D libbpf_strerror_r(errno, errmsg, sizeof(errmsg)=
);
>>>> +               ret =3D -errno;
>>>> +               cp =3D libbpf_strerror_r(-ret, errmsg, sizeof(errmsg));
>>>
>>> fyi, libbpf_strerror_r() is smart enough to work with both negative
>>> and positive error numbers (it basically takes abs(err)), so no need
>>> to ensure it's positive here and below.
>>=20
>> Noted. Although that also means it doesn't hurt either, I suppose; so
>> not going to bother respinning this unless someone insists :)
>
> Fixed up while applying, thanks!

Great, thanks!

-Toke

