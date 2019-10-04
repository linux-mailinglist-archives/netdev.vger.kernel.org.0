Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2488CBE93
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 17:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389652AbfJDPHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 11:07:54 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37704 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389378AbfJDPHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 11:07:52 -0400
Received: by mail-qt1-f193.google.com with SMTP id l3so9016020qtr.4;
        Fri, 04 Oct 2019 08:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FvxIqPZHfYy0lbcU7SrdV2tBJ6wQQiMjuW0t3DLykX0=;
        b=r9FX3CBBu/pe3dJXSvgC9gU3PqZUDz154CBBsWItJrp7Q/qqmWJxdeYpphdG54zJYP
         PQkcfYk6khIbXpPjDHtiDTCCnt0mM7ss5I63twTwDnKUfvZp1D1PSF0JS03ilwfqrhqZ
         uQYZq9LzLOoEVamBZXxTnXIiMJLkI+MVWzs+e68tVYG/7iVHAZE4+qw1Mj2/C+Xwx0Ee
         5rcp0nYrr2y5dRN2kgRxHquKZYehs73CTDL47rxNq0wAyU8KjmQMFafUcc/ZtmbBB/Mg
         N/w8tcqLLiSs2Avq8eQYJ/PgtcdS2U7FlEnpmqMtOgwESDi+zasTEzdtzYggAC+3fYpE
         QuVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FvxIqPZHfYy0lbcU7SrdV2tBJ6wQQiMjuW0t3DLykX0=;
        b=rhQHSSY0rmLNJeWj0ZWxn9VDyE3l+4bujKVNeigiKsMbgyW9npYl467YuWVkdMwyDM
         XlsQhbz66Rs7P35A6AymXNzfSoTnh4CR04dRR7YdINg/dXfZsdg4NS4V/mx0QS4AStoB
         jVWXsWZ/he8rYyQw3PLNZSwoCGqdSj80Ue+3k2IiQU+YyXeiyfEsRo91O2IQhTTM+xiD
         xkDaZtzgFprozo9Kvj79VZVGRIkrFYCKubD7Hxv+G50bkefvPkHhF7ggimKa1ZHCeOeB
         chwBMtEnEmATbvJK0af4Nmj4dcOZsIn2HwaMTaAPonBB3OdHwOcp8jEYO/gZXUM3GIdw
         Jnnw==
X-Gm-Message-State: APjAAAV2VUBKCMfeggqEsbby+dPFqRangOsAyujJH+qzLX+CGWDqJctq
        NVhUewOgevne+0JVViYU636TlY3OYoVm46+bweE=
X-Google-Smtp-Source: APXvYqzipKdcf9sweUI0APw8dkwezeEWtU3GLHvWykRbCPhPAXDbnGoIMnK5dhUmphYX6rcizsEPOF0xEppuSTeOJ1M=
X-Received: by 2002:a0c:d284:: with SMTP id q4mr14034802qvh.228.1570201671689;
 Fri, 04 Oct 2019 08:07:51 -0700 (PDT)
MIME-Version: 1.0
References: <20191004030058.2248514-1-andriin@fb.com> <20191004030058.2248514-2-andriin@fb.com>
 <5d97519e9e7f3_4e6d2b183260e5bcbf@john-XPS-13-9370.notmuch>
 <CAEf4BzbP=k72O2UXA=Om+Gv1Laj+Ya4QaTNKy7AVkMze6GqLEw@mail.gmail.com> <fb67f98a-08b4-3184-22f8-7d3fb91c9515@fb.com>
In-Reply-To: <fb67f98a-08b4-3184-22f8-7d3fb91c9515@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Oct 2019 08:07:40 -0700
Message-ID: <CAEf4BzbUSQdYqce+gyjO7-VSrF45nqXuLBMU6qRd63LHD+-JLg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] libbpf: stop enforcing kern_version,
 populate it for users
To:     Alexei Starovoitov <ast@fb.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 7:36 AM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 10/4/19 7:32 AM, Andrii Nakryiko wrote:
> >> If we are not going to validate the section should we also skip collect'ing it?
> > Well, if user supplied version, we will parse and use it to override
> > out prepopulated one, so in that sense we do have validation.
> >
> > But I think it's fine just to drop it altogether. Will do in v3.
> >
>
> what about older kernel that still enforce it?
> May be populate it in bpf_attr while loading, but
> don't check it in elf from libbpf?

That's what my change does. I pre-populate correct kernel version in
bpf_object->kern_version from uname(). If ELF has "version" section,
we still parse it and override bpf_object->kern_version.
bpf_object->kern_version then is always specified as part of
bpf_prog_load->kern_version.

So what we are discussing here is to not even look at user-provided
version, but just always specify correct current kernel version. So I
don't think we are going to break anything, except we might allow to
pass some programs that were failing before due to unspecified or zero
version.

So with that, do you think it's ok to get rid of version section altogether?
