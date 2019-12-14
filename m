Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 730C611EF78
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 02:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfLNBVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 20:21:08 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:43907 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbfLNBVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 20:21:08 -0500
Received: by mail-qv1-f65.google.com with SMTP id p2so492360qvo.10;
        Fri, 13 Dec 2019 17:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E0H9301ghdZ2dylpyDzeCJfxCEGT/ww6jQxz2tHkrTc=;
        b=nJ7HlDS+AiFo59FVlQnaK1j7I3sEsgB3OaoH93ZdOAv9T0520PlZWijxhd6x7WgxGG
         08bR4tKajuStRNsUVyqtexQQGczSaFFAmPFoa4qaez1gjUvp4Qme81AWGv4TG75n10QP
         LTN/QMLwDzHQD2tFEcVgrHWx2roiMsn3AYjY0JXHNlfI4kU1NhWDmra7cRBmSUF/25V+
         PifzhHkNmBUDkQ0eUBNsK7iR8bwoDi1+SF1Gsam+ZZPKC0AwpKOWPo9iErhEkR2o4O1X
         xLnVpxeX5YgeksvYjxxeKVKB3TClrocHhwdpNo/YsoOgg7ju7XbWflm7BUZE07ay49+N
         8iRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E0H9301ghdZ2dylpyDzeCJfxCEGT/ww6jQxz2tHkrTc=;
        b=iEVSwuB0M8NERhJ/MZncCZkF9GCDxtB3IJ8Yz+4Hg/0Gv6HR9o91h7UvWIe1IiMCWB
         uTs0HzBEG1it48rxJrO6Rsr0squ6IHvftooCgLnyMspqOIzr33VJ6ijuAgF/P3X3xyvK
         N2j5OpvSx/r6jvC67ZQ3HyH4IR8US5hWbXlDgb9yLRmnMY6g+lAijG/tBZz0oZAB0aef
         A/Xik1+/Y3+vOL5hINdUsHw+uqHSf3HmwJcRu34XrPJlShEZEKxoExg7Wj6556tkrSEf
         wtm27IL/dHdAD8En7Og7ezHRgCX9jQz2zSwFSEbeimweaq6VOGFyYRbLJLO343X8kGsM
         p+eA==
X-Gm-Message-State: APjAAAWBiCahRGZPDrq06g9ClzXN8zuUMy5+NOpUjYJdaHax+KtrYrg9
        DQqFTyVdqyD1qSAoH3uYRMRggP7AT10hXoj3LxEUug==
X-Google-Smtp-Source: APXvYqykp1DuThBvMHQudWFHe1i5LDutX+DSoMUZJhvgmyjw83s4vjPFLrSJvhmne+VfIJCDmQ01E4r7RzMGu2GKdoM=
X-Received: by 2002:a05:6214:38c:: with SMTP id l12mr16328651qvy.224.1576286467044;
 Fri, 13 Dec 2019 17:21:07 -0800 (PST)
MIME-Version: 1.0
References: <20191213235144.3063354-1-andriin@fb.com> <20191213235144.3063354-3-andriin@fb.com>
 <e612995b-ee80-5d22-512c-dfe700c97865@fb.com>
In-Reply-To: <e612995b-ee80-5d22-512c-dfe700c97865@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Dec 2019 17:20:55 -0800
Message-ID: <CAEf4BzZO0RH4sYcEznEH7yacB+343NNTOtcCs6Xi9GHqO4EnsA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/4] libbpf: support libbpf-provided extern variables
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 4:20 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 12/13/19 3:51 PM, Andrii Nakryiko wrote:
> >   static int
> >   bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
> > -                           int sec_idx, Elf_Data *data)
> > +                           int sec_idx, void *data, size_t data_sz)
>
> the previous patch set did:
>   bpf_object__init_internal_map(struct bpf_object *obj, enum
> libbpf_map_type type,
> -                             int sec_idx, Elf_Data *data, void **data_buff)
> +                             int sec_idx, Elf_Data *data)
>
> and now this patch set refactors it again from Elf_Data into
> two individual arguments.
> Could you do this right away in the previous set and avoid this churn?

no problem, will do

> Not a strong opinion though.
> Just odd to see the function being changed back to back.
> Thankfully that's internal in .c file.
