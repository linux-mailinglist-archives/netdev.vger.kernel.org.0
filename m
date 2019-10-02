Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA53DC4868
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 09:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfJBHVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 03:21:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37048 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726101AbfJBHVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 03:21:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570000907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZXKoJ1jbuJ+ks0dSg3TRhQiKe5OUNHwJKm984nzXgMI=;
        b=Z5WUZPt2S3oL32gHFeEARep2SA21mbgvUzZS4bf72Hym/oF/lxjXQ04MAhNRAJGx3z/76f
        JN01W03kW8LAVVckdlKpPGDewWS68yLMbG3yEGLVeiRxhqZ/Fw/C5QAOMz37JivzYMtpdA
        I6PUwL0by9ubsvK+o+3NU9y+ZOfgGo4=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-5lVmZQKyOQ28Rv6FEjth8g-1; Wed, 02 Oct 2019 03:21:45 -0400
Received: by mail-lj1-f199.google.com with SMTP id 205so4548277ljf.13
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 00:21:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ZXKoJ1jbuJ+ks0dSg3TRhQiKe5OUNHwJKm984nzXgMI=;
        b=cOazh91qV7dD6qrpQTJNB1PYJTy/ZACAuo55IngPtKzGeGU3KnSQUK1NtN9q+IKRTj
         EL1mq/hjz8SKin35xUSd0u+RXmWz4/g+W5mdpcEAg8HhKG7nXG9UvcVrPM5z8CsrhwGM
         LJwB2yEM+JYlg6StxDBAEkiGFNBiOAubvhfJ2gHIEBr8d+CAh44If1U9R1wk/I8j6aU8
         SIPVR3crc8pbTgwFPMEsS3n8oMh92RjaJOWLaPiXso01Hz+NWeKBMovwj+cuNOyG4c38
         Z7i5F+8Xq5ytxgrqJu1cBtk1Oa0LYP5O74UFhpFVZcP9FQyx/auX3e6SkK86lO4OrO25
         xVag==
X-Gm-Message-State: APjAAAUcwoj1SMKQs2XjxIIDgtmgtUAmF3T1rLcPxDB2wJTdne7xxFKV
        PgXhuNM/ZNA+P+JwL2SksI7Q310ltXx07t/vVozQrgfIJ+9EBgODInrstI1cIGd1Cgg/BCPqqdj
        mcz9qKJdPOgFB3VXj
X-Received: by 2002:ac2:5464:: with SMTP id e4mr1278055lfn.102.1570000903668;
        Wed, 02 Oct 2019 00:21:43 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzQPU+F+tlnzzzTShi4AS+eN2MOMLc/gx+x3gRIKe2v0XtfmW5KzhrpkSLC+StZ5+LIeSra0g==
X-Received: by 2002:ac2:5464:: with SMTP id e4mr1278044lfn.102.1570000903515;
        Wed, 02 Oct 2019 00:21:43 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id 3sm4464958ljs.20.2019.10.02.00.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 00:21:42 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DE8FC18063D; Wed,  2 Oct 2019 09:21:41 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h into libbpf
In-Reply-To: <CAEf4Bza789NPSx0FksudY7J0D9Q-+EsTDvvAJXJyrcTNka=sag@mail.gmail.com>
References: <20190930185855.4115372-1-andriin@fb.com> <20190930185855.4115372-3-andriin@fb.com> <87d0fhvt4e.fsf@toke.dk> <CAEf4Bza789NPSx0FksudY7J0D9Q-+EsTDvvAJXJyrcTNka=sag@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 02 Oct 2019 09:21:41 +0200
Message-ID: <87a7ajtxx6.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: 5lVmZQKyOQ28Rv6FEjth8g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Oct 1, 2019 at 12:10 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>>
>> > +struct bpf_map_def {
>> > +     unsigned int type;
>> > +     unsigned int key_size;
>> > +     unsigned int value_size;
>> > +     unsigned int max_entries;
>> > +     unsigned int map_flags;
>> > +     unsigned int inner_map_idx;
>> > +     unsigned int numa_node;
>> > +};
>>
>> Didn't we agree on no new bpf_map_def ABI in libbpf, and that all
>> additions should be BTF-based?
>
> Oh yes, we did, sorry, this is an oversight. I really appreciate you
> pointing this out ;)
> I'll go over bpf_helpers.h carefully and will double-check if we don't
> have any other custom selftests-only stuff left there.

Great, thanks!

-Toke

