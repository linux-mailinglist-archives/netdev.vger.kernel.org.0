Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 886ADC486E
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 09:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfJBHZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 03:25:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24691 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725799AbfJBHZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 03:25:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570001126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JmZV823gGdTvbCQLqNBmGsxwm1rMY79XyCXkVHS7R/k=;
        b=H4PZtfJS6as0uCLzahmjmnAnLwiUggk527QsHP7dBFISnR+n6prMgWDNdTZdRzIu9ZlND1
        J+jxeGGQydYASaInnWGxr8oY+DFh/jO1pldRsLSTzDgooCHnlHd1qNzQB4XtY5rFB6NbNx
        4R34RQc3qNulkpG6QJYmxmHoiVNankg=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-u7lPr75dOmy_FAZaA1-71w-1; Wed, 02 Oct 2019 03:25:24 -0400
Received: by mail-lj1-f198.google.com with SMTP id r22so4575305ljg.15
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 00:25:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=JmZV823gGdTvbCQLqNBmGsxwm1rMY79XyCXkVHS7R/k=;
        b=j6u7ambocFqd/ZbjeAP/Ubxrv9r59ilurqpD654M+I3Ayh0Q3bzY5Ag1Fl5I8M5G6i
         ZtgzNLP+dcqDrUHhwp1ZFdhu9ATIqQxEXclfWCimzQjPCkUHXWDgO9h3Htf2pSKdHp95
         qsZNZh422Vd7CnnSAcyucpADGHTUtlXWpcSHSAxCz+JjQm4rHBrU5ljPrUfOBXu1EMa/
         R/NUO7yqEpcERfgPa8WRmTjZexm+S/UKRgZJBjtv/h40/ChOqnPm4l4VUTTT+n1HLNca
         uy5B99kBDl/v+JGIvS53+7jjYnSC/YAk4qyvDGIO4oDyT5DGvukWm6+BLcEhGPOax3rr
         DsAQ==
X-Gm-Message-State: APjAAAVDQtzWhLWdUwxq0XrHMnsEjsZtFMGDYxD8gT0CMdzH93lCHowH
        4v4QXjTp0Dy7WJjCXiUa8KZfHz0+sGVnTWlLoiT30DDXfgQgG9E/M7zTf/oG3McX7w5o7L0Y49y
        LHpu9iEex12QW5D8f
X-Received: by 2002:a2e:7502:: with SMTP id q2mr1309240ljc.202.1570001122958;
        Wed, 02 Oct 2019 00:25:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzlVPLoTMS162SDTzASO2Zz8YVYZQU+kVwH0npGAOwDTRq/RIz/G24+vFRSztp+g3WNhuWO8A==
X-Received: by 2002:a2e:7502:: with SMTP id q2mr1309230ljc.202.1570001122807;
        Wed, 02 Oct 2019 00:25:22 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id z21sm4415599lfq.79.2019.10.02.00.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 00:25:21 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1A0D118063D; Wed,  2 Oct 2019 09:25:21 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h into libbpf
In-Reply-To: <CAEf4Bzb8Q5nUppqBqnXH93U1con3895BJFHP88hQi5r6wohR6Q@mail.gmail.com>
References: <20190930185855.4115372-1-andriin@fb.com> <20190930185855.4115372-3-andriin@fb.com> <87d0fhvt4e.fsf@toke.dk> <5d93a6713cf1d_85b2b0fc76de5b424@john-XPS-13-9370.notmuch> <CAEf4Bzb8Q5nUppqBqnXH93U1con3895BJFHP88hQi5r6wohR6Q@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 02 Oct 2019 09:25:21 +0200
Message-ID: <875zl7txr2.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: u7lPr75dOmy_FAZaA1-71w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Oct 1, 2019 at 12:18 PM John Fastabend <john.fastabend@gmail.com>=
 wrote:
>>
>> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >
>> > > +struct bpf_map_def {
>> > > +   unsigned int type;
>> > > +   unsigned int key_size;
>> > > +   unsigned int value_size;
>> > > +   unsigned int max_entries;
>> > > +   unsigned int map_flags;
>> > > +   unsigned int inner_map_idx;
>> > > +   unsigned int numa_node;
>> > > +};
>> >
>> > Didn't we agree on no new bpf_map_def ABI in libbpf, and that all
>> > additions should be BTF-based?
>> >
>> > -Toke
>> >
>>
>> We use libbpf on pre BTF kernels so in this case I think it makes
>> sense to add these fields. Having inner_map_idx there should allow
>> us to remove some other things we have sitting around.
>
> We had a discussion about supporting non-BTF and non-standard BPF map
> definition before and it's still on my TODO list to go and do a proof
> of concept how that can look like and what libbpf changes we need to
> make. Right now libbpf doesn't support those new fields anyway, so we
> shouldn't add them to public API.

This was the thread; the context was libbpf support in iproute2:
https://lore.kernel.org/netdev/20190820114706.18546-1-toke@redhat.com/

Basically, we agreed that rather than adding more fields to bpf_map_def
in libbpf itself, we'd support BTF definitions natively, and provide
applications the right callbacks to support custom formats as they see
fit.

-Toke

