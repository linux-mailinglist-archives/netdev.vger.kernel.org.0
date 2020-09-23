Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E857C2762A2
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 22:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgIWU60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 16:58:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49487 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726460AbgIWU60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 16:58:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600894704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CbvhTKklclsI9zCmQ1AhhPMI2tbrWk7sY+kWgVzvbmI=;
        b=b48sP14k17wwn3D6MKTIrkJ7dAooxIhg/o2Kmz0Mw90+WrVCy4Ch/swE8xwxlhfLEnJ6Ac
        84tnIohQeYQY9AW72jHpLw0UOemiWTA8IG7s8SSl6yopJNQUGFXPg7mUE/8GpuMgkTFWfg
        kbOiscQR1mWtk9tTySiaIPBkng6V7GI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-K8l5M8DTOgOIbZ1Z5zb9iw-1; Wed, 23 Sep 2020 16:58:22 -0400
X-MC-Unique: K8l5M8DTOgOIbZ1Z5zb9iw-1
Received: by mail-wr1-f71.google.com with SMTP id v5so306703wrs.17
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 13:58:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=CbvhTKklclsI9zCmQ1AhhPMI2tbrWk7sY+kWgVzvbmI=;
        b=ZQgwqttIeDcR9RykzcTXMYLvssv9jV8dqChqFBc8klflh5ee6qlws6Uwh6Ue+kMoM6
         2fKehJexM1AzUZHmQs68ldx1Aw+97YayvBUKWPuwT8jGXPnDL6ZcbGbV9Wi3p7tiZq3P
         Bpf6GoJqfgIY9vVNn+qWI7yZxUJ43OhuquApBEAffNtk0a4Q4nB3lIxYL/JmzscRp/Ql
         6dyPh1BhLmx8lJvT/sdb2FYf0+6lWAUEzqIeiQhR1Ose6CFP3XfsI1ON0HxSEL4XM0h1
         qdH2ZsxlNGu7Pzrb4Q16igvMnKE2JnDVZSG6Q8eQJh7Eyems734YV8SzZmG+LltlDbbM
         TB+Q==
X-Gm-Message-State: AOAM533PjNQDdXIul2nKOdrGSO12E4Q55YRXxfGdcNOQe8ekikqSE4yv
        II/ej1xFI0tJXNJ6JPz0C9qhd1u4bFZCd88tzgAGvG1elUO2DXIvoHcsSUlfzdXk4kpqvlWpfth
        6fSsmmDEKa6fsJbwO
X-Received: by 2002:adf:ec0a:: with SMTP id x10mr1445970wrn.47.1600894701140;
        Wed, 23 Sep 2020 13:58:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKIi4o1DnWBrnf7v3xh/SLjRJqh2QPYcFIZypc466O2I1YM5azEUnr24a+Og9abmTi1cOHfg==
X-Received: by 2002:adf:ec0a:: with SMTP id x10mr1445938wrn.47.1600894700595;
        Wed, 23 Sep 2020 13:58:20 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id u63sm947897wmb.13.2020.09.23.13.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 13:58:20 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8AF54183A90; Wed, 23 Sep 2020 22:58:19 +0200 (CEST)
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
Subject: Re: [PATCH bpf-next v8 07/11] libbpf: add support for freplace
 attachment in bpf_link_create
In-Reply-To: <CAEf4BzZuMUA2B+Nz+7GfpoW2SGF3tyUpjRsjP2cX3VGH34OHgw@mail.gmail.com>
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
 <160079992129.8301.9319405264647976548.stgit@toke.dk>
 <CAEf4BzZuMUA2B+Nz+7GfpoW2SGF3tyUpjRsjP2cX3VGH34OHgw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 23 Sep 2020 22:58:19 +0200
Message-ID: <87ft78nrbo.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Sep 22, 2020 at 11:39 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>>
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>
>> This adds support for supplying a target btf ID for the bpf_link_create()
>> operation, and adds a new bpf_program__attach_freplace() high-level API =
for
>> attaching freplace functions with a target.
>>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>
> LGTM.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Awesome! Thanks again for your (as always) thorough review (for the
whole series, of course) :)

-Toke

