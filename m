Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59E76776B7
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 07:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfG0FL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 01:11:26 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37007 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfG0FL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 01:11:26 -0400
Received: by mail-qk1-f195.google.com with SMTP id d15so40616232qkl.4;
        Fri, 26 Jul 2019 22:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x5dBIcrDDMYtNcOBmduwWStMLpvy3jG1mcAZnVCp3pc=;
        b=USq9XfSfUSLDuqDE+yd+211OjI0ZQGC2QHyH1eZ/huqBC3rVuyJs/pNO6DIEpgBEfc
         8cszAkTsVe9MU/6mWM43PAlZVRTlBl/KEQNjoLUj2LgNU7WsNW7OJCgaOi/hJfbDfwNz
         SUVi9Oppf/MR1J9vv7WXRjI5dWrvMrA/pK0GYzyR3rVVkNUqwaf1BQOTfEgseVQ2ZB42
         QccjH5wlViFvemhGfEWLaebxOpvp8Skyu3aEI8tfZEaNpAaVrRniIB3MfsX6+ew4OSSc
         QgdOum56lr0w4hQkiVgE3SGE8C0g4UkywD8PCNRjQvLK2v10PbRealhp2L0AOSfZUPYX
         5cAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x5dBIcrDDMYtNcOBmduwWStMLpvy3jG1mcAZnVCp3pc=;
        b=ENcglo47DToVcoeRvbw31moLl8PhQFX1sNJ876l8Fm2cyKRg1oSjFPXFWgYcNVbEWU
         B0TkrrhYgmxIylcLwKTAZn5KBKYo7zUihA+kOPb2pHT8sM1UdtYrUooN1yJEU+2Wgphz
         aqoa6W1iGM1K9TlOPUU+s2T+OICJnPvS8J/qQ17eg9qF2djkDuAtCeNHvDs05rc9vtvo
         d/QKbhytvqXrsr2RWZPwooB30qf3czk7OK9KJQKKs/Z2Nd/mJlDbPlie+Y7v6XUwXLhh
         uCfKQ9zeeYfRcOZ4460La4dGsTywrbNYtwcAx8VOEc2SggBBAWFKOFBj8414qad1d4mD
         anlw==
X-Gm-Message-State: APjAAAV6TRVCGO8gmFP0wmF5kA/IXzekH4LsrOy+ZB4rrd0ZRyIo4BTe
        Bjj9hV80ZYBsfDnJP3wINjyD2LJBWG2KM9oQMso=
X-Google-Smtp-Source: APXvYqwMiXPpYmRL27oP8CGNal2Denflseb2w8yxxgJHrjHK1Tl2t1HKEC+x8nU6xhw6Qif+s4t4v8hMU5PdgcH3Y2E=
X-Received: by 2002:a05:620a:16a6:: with SMTP id s6mr65137372qkj.39.1564204284994;
 Fri, 26 Jul 2019 22:11:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190724192742.1419254-1-andriin@fb.com> <20190724192742.1419254-2-andriin@fb.com>
 <B5E772A5-C0D9-4697-ADE2-2A94C4AD37B5@fb.com> <CAEf4BzZsU8qXa08neQ=nrFFTXpSWsxrZuZz=kVjS2BXNUoofUw@mail.gmail.com>
 <B01B98E5-CDFB-4E3A-BD58-DBA3113C3C3F@fb.com>
In-Reply-To: <B01B98E5-CDFB-4E3A-BD58-DBA3113C3C3F@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jul 2019 22:11:12 -0700
Message-ID: <CAEf4BzYgyAiPt0wVESrWSJ_tLheq0BRWLgrqMfLZsnp11+F77Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/10] libbpf: add .BTF.ext offset relocation
 section loading
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 10:20 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jul 24, 2019, at 5:37 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Jul 24, 2019 at 5:00 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Jul 24, 2019, at 12:27 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >>>
> >>> Add support for BPF CO-RE offset relocations. Add section/record
> >>> iteration macros for .BTF.ext. These macro are useful for iterating over
> >>> each .BTF.ext record, either for dumping out contents or later for BPF
> >>> CO-RE relocation handling.
> >>>
> >>> To enable other parts of libbpf to work with .BTF.ext contents, moved
> >>> a bunch of type definitions into libbpf_internal.h.
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>> ---
> >>> tools/lib/bpf/btf.c             | 64 +++++++++--------------
> >>> tools/lib/bpf/btf.h             |  4 ++
> >>> tools/lib/bpf/libbpf_internal.h | 91 +++++++++++++++++++++++++++++++++
> >>> 3 files changed, 118 insertions(+), 41 deletions(-)
> >>>
> >
> > [...]
> >
> >>> +
> >>> static int btf_ext_parse_hdr(__u8 *data, __u32 data_size)
> >>> {
> >>>      const struct btf_ext_header *hdr = (struct btf_ext_header *)data;
> >>> @@ -1004,6 +979,13 @@ struct btf_ext *btf_ext__new(__u8 *data, __u32 size)
> >>>      if (err)
> >>>              goto done;
> >>>
> >>> +     /* check if there is offset_reloc_off/offset_reloc_len fields */
> >>> +     if (btf_ext->hdr->hdr_len < sizeof(struct btf_ext_header))
> >>
> >> This check will break when we add more optional sections to btf_ext_header.
> >> Maybe use offsetof() instead?
> >
> > I didn't do it, because there are no fields after offset_reloc_len.
> > But now I though that maybe it would be ok to add zero-sized marker
> > field, kind of like marking off various versions of btf_ext header?
> >
> > Alternatively, I can add offsetofend() macro somewhere in libbpf_internal.h.
> >
> > Do you have any preference?
>
> We only need a stable number to compare against. offsetofend() works.
> Or we can simply have something like
>
>     if (btf_ext->hdr->hdr_len <= offsetof(struct btf_ext_header, offset_reloc_off))
>           goto done;
> or
>     if (btf_ext->hdr->hdr_len < offsetof(struct btf_ext_header, offset_reloc_len))
>           goto done;
>
> Does this make sense?

I think offsetofend() is the cleanest solution, I'll do just that.

>
> Thanks,
> Song
