Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D514CAB65
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389599AbfJCRVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:21:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47493 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388932AbfJCRVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 13:21:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570123265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z7rXGAQSbiGa4/7Bkctjr6dl8SSz5zO8pwOGZPcMe1w=;
        b=NU0NjsnYacZz1enidRUEoKwj3PyOFFhxijklWQirZv/IeVC2hmh0mmUip0q4qwfKyfyWIB
        5mYgvcnLZULfxeExF1ll7P94ua+TJXsl1GWZ9d9OiC/v3oGe2XFmj794/BdJU7TSeuaTpJ
        tUlb0fFqAjizOeeRvGrrq+ExCzJJnRM=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-t4KWp3iCOcWx9LTXeJC1iQ-1; Thu, 03 Oct 2019 13:21:04 -0400
Received: by mail-lf1-f71.google.com with SMTP id g24so335732lfh.4
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 10:21:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Z7rXGAQSbiGa4/7Bkctjr6dl8SSz5zO8pwOGZPcMe1w=;
        b=rHi7J7aEcmzQeG3rqQ9b+LtBMTT9uRkaauu+5z5asYi3+1OMZ5WWXuUUA7yU5pqkJ7
         0fFCjM1oSsxuxQW/or5E826DXBCZSGLKDCnAfe8qj7TbL3tAKhGcCJAvSYDcJwE+SQfH
         VEK/zplUy+pa86yFmhV8SNR0GxqG4WlWc2ofe8bXTS4uX4ZtHw9rw36IkUJ4TZLtbPE0
         0FzD66R2GTnYXITukxAIj2V5LgaT16TGH7Hq4hJpJ+77Ys7wuHJrKYKuqQCS4j96JOlV
         eWz93QCHTyl9InYCjUJZTCkTg5WN11Vvx97xX/RbnLBTThxn1Z199Aotb9Wszg0v+URA
         2G8w==
X-Gm-Message-State: APjAAAWFbssbLqqnyVSFym60YX6zyqTS0c4tTg80lDF8w7cfp/vgD94S
        iHE9mLRVbc9ZQu23nJo8/6qVJ4FNirGQk3D6zYpZbMzA5jWAfSKYfek7wVmufZkmb3a3B/qDiJB
        8qxpPffb+QiB7IzL9
X-Received: by 2002:a2e:301a:: with SMTP id w26mr6813884ljw.168.1570123262607;
        Thu, 03 Oct 2019 10:21:02 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxdVca8Nh/s/XnjRxYBzzGYfahRNbeqRheVUMUAoTyrgPFZWpEK8rXkXg5jaqOA/m79I5yRKA==
X-Received: by 2002:a2e:301a:: with SMTP id w26mr6813876ljw.168.1570123262441;
        Thu, 03 Oct 2019 10:21:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id i142sm571559lfi.5.2019.10.03.10.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 10:21:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C5D8E18063D; Thu,  3 Oct 2019 19:21:00 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 4/7] selftests/bpf: split off tracing-only helpers into bpf_tracing.h
In-Reply-To: <CAEf4BzZa9aSz_FXkexKWse_k-m0WvxZJZG6qOqacaKKxgHb1OA@mail.gmail.com>
References: <20191002215041.1083058-1-andriin@fb.com> <20191002215041.1083058-5-andriin@fb.com> <87imp6qo1o.fsf@toke.dk> <CAEf4BzZa9aSz_FXkexKWse_k-m0WvxZJZG6qOqacaKKxgHb1OA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 03 Oct 2019 19:21:00 +0200
Message-ID: <87ftk9pwxv.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: t4KWp3iCOcWx9LTXeJC1iQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Thu, Oct 3, 2019 at 12:35 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andriin@fb.com> writes:
>>
>> > +/* a helper structure used by eBPF C program
>> > + * to describe BPF map attributes to libbpf loader
>> > + */
>> > +struct bpf_map_def {
>> > +     unsigned int type;
>> > +     unsigned int key_size;
>> > +     unsigned int value_size;
>> > +     unsigned int max_entries;
>> > +     unsigned int map_flags;
>> > +};
>>
>> Why is this still here? There's already an identical definition in libbp=
f.h...
>>
>
> It's a BPF (kernel) side vs userspace side difference. bpf_helpers.h
> are included from BPF program, while libbpf.h won't work on kernel
> side. So we have to have a duplicate of bpf_map_def.

Ah, yes, of course. Silly me :)

-Toke

