Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735211A6F70
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 00:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389717AbgDMWtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 18:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389720AbgDMWqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 18:46:42 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E492EC0A3BDC;
        Mon, 13 Apr 2020 15:47:45 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id b10so8605548qtt.9;
        Mon, 13 Apr 2020 15:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h+DdmF0NCCrRn7Hgd79ggGYVwYbvBubuzbfq6+NRA6c=;
        b=e39erTqpTo/GqHzA3BrQvYuGupcqmMyw7G2VqRRtkQM7UaxMBn51dCLLEB+1tgu574
         lPhC0QxfehXIeafe2gdDl/azG7g2alKBicIVUcbbAgU42lK+AYkriXl4a+qwakEuD/VF
         LTUx/0hQInl7hqdlyO0KqyFS08mBCTDA8ArFi9QgfYeFQ+fYXZ5scMEGFbw3EoGrpK/M
         Gjg2Gcnf4nzW4LSbsMnORfbMDMFr0Je3ksk1EQVRb1a7qzlhcyDpNtAWvaRnWB7Ir/yB
         uUe+yvxuyPTQIkoYesIIEy2RoSWW3yweZWl9UelWq3YGHpjgsQEjrE70gujgTeLLXQZl
         5moA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h+DdmF0NCCrRn7Hgd79ggGYVwYbvBubuzbfq6+NRA6c=;
        b=nKs8ZNG3BG/x70aV+HFc0mHQqhZRb2/+3i/+b89NGPzVb/pvo5P046elkbIoqCCPqk
         duGQtbAdNBKWaSVE2daK/Hilyy52E4ux7zNTA6H/L6n2hJJQUN7G85PcpvncEmmY4L8N
         w0gS4ThisGMpJNsdxKC2H2nXYJqWYCsYzIQR5AxizLe2KzViSHPOtcTL8eQi1gHQ2Vkg
         5HfAYaBMsPWUtHvCAamopgP11AjDQIhgUoXUclJYrdXcHuyWSoFQ7uJ/pSYZAGHaUq2Q
         67lvKGKXtyoK8OZfuaxd7bw9dL58BhJihVhDO6L5JJkbbGCVq6IwaGstLQo0Lw8be/2L
         Y0dQ==
X-Gm-Message-State: AGi0PubiNQOSZ7cxIvbylj1SEmFkMYRft0+CEsVHx53Pq88Qpa//DgkF
        Qe4+c/PucX9tDzz26iYzVWnzCEPxPHlMZ8LobpE=
X-Google-Smtp-Source: APiQypLXZJZ1d05B2yb4IEsjh9UBmSDr1t8CaG69xPZQSmXsN+KbLGYfUXHI//rYgPrwOyHQUCRbADexoO0oq6/nZHc=
X-Received: by 2002:ac8:468d:: with SMTP id g13mr13246082qto.59.1586818065133;
 Mon, 13 Apr 2020 15:47:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232528.2675856-1-yhs@fb.com>
 <CAEf4BzaBA_t9HUzTpnHFfqyxP0u-4hFJ0V9KW5DE1Tm6KOC9Kg@mail.gmail.com>
In-Reply-To: <CAEf4BzaBA_t9HUzTpnHFfqyxP0u-4hFJ0V9KW5DE1Tm6KOC9Kg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Apr 2020 15:47:34 -0700
Message-ID: <CAEf4BzbpU02rXZDx3Re8nR5iuPebQcvPkcui9m9r+nDyDVt2uw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 07/16] bpf: add bpf_map target
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 3:18 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
> >
> > This patch added bpf_map target. Traversing all bpf_maps
> > through map_idr. A reference is held for the map during
> > the show() to ensure safety and correctness for field accesses.
> >
> > Signed-off-by: Yonghong Song <yhs@fb.com>
> > ---
> >  kernel/bpf/syscall.c | 104 +++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 104 insertions(+)
> >
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index b5e4f18cc633..62a872a406ca 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -3797,3 +3797,107 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
> >
> >         return err;
> >  }
> > +
> > +struct bpfdump_seq_map_info {
> > +       struct bpf_map *map;
> > +       u32 id;
> > +};
> > +
> > +static struct bpf_map *bpf_map_seq_get_next(u32 *id)
> > +{
> > +       struct bpf_map *map;
> > +
> > +       spin_lock_bh(&map_idr_lock);
> > +       map = idr_get_next(&map_idr, id);
> > +       if (map)
> > +               map = __bpf_map_inc_not_zero(map, false);
> > +       spin_unlock_bh(&map_idr_lock);
> > +
> > +       return map;
> > +}
> > +
> > +static void *bpf_map_seq_start(struct seq_file *seq, loff_t *pos)
> > +{
> > +       struct bpfdump_seq_map_info *info = seq->private;
> > +       struct bpf_map *map;
> > +       u32 id = info->id + 1;
>
> shouldn't it always start from id=0? This seems buggy and should break
> on seq_file restart.

Actually never mind this, from reading fs/seq_file.c code I've been
under impression that start is only called for full restarts, but
that's not true.


>
> > +
> > +       map = bpf_map_seq_get_next(&id);
> > +       if (!map)
>
> bpf_map_seq_get_next will return error code, not NULL, if bpf_map
> refcount couldn't be incremented. So this must be IS_ERR(map).
>
> > +               return NULL;
> > +
> > +       ++*pos;
> > +       info->map = map;
> > +       info->id = id;
> > +       return map;
> > +}
> > +
> > +static void *bpf_map_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> > +{
> > +       struct bpfdump_seq_map_info *info = seq->private;
> > +       struct bpf_map *map;
> > +       u32 id = info->id + 1;
> > +
> > +       ++*pos;
> > +       map = bpf_map_seq_get_next(&id);
> > +       if (!map)
>
> same here, IS_ERR(map)
>
> > +               return NULL;
> > +
> > +       __bpf_map_put(info->map, true);
> > +       info->map = map;
> > +       info->id = id;
> > +       return map;
> > +}
> > +
>
> [...]
