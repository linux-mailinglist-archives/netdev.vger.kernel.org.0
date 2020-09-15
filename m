Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6157326B02B
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgIOWD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728085AbgIOWDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 18:03:34 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3785EC06178B
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 15:03:33 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id z18so2542434qvp.6
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 15:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JOLtYWV5k43t7zSbOIgN7n22Qeg30cuT8X6VukPd788=;
        b=bTy/eiUmBRcA2datxSAmLf8APHcXrKNfoi7DcoTegfryY5ZEBzTSirUErrimu584Xu
         AsJiAXThsmidhIga+KvkysynDV//n6c8F76aN2aWK5X74oq8Tdqda2TlWY90JgCDlBps
         yFKqjqfrdq1nDgRkno7HvOeSEIs1GvhGnslTR/fuitSEJ6k1N/MDIv2R2ADIYcQf2MdX
         r7O1U9WYHSm49mk/0uubwoTZPPrfrQb/FkPjU03FiYcSAB106SC03LnKbimvvbWzYAJ2
         thtEsoE74MaII0EE1Yl4Bw2PrQJpNR7CD0baI4AqKIz1cqz9H7p/K3hVwCtMMoU20/Yd
         yu4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JOLtYWV5k43t7zSbOIgN7n22Qeg30cuT8X6VukPd788=;
        b=SBW206c4Z0Ul9enImXFwNLg82XW0627zj+aHXG6qK/AB5LM+y9+Rik2ah5ee4pTl+a
         FbJXVLa5Oj4v6QIJGLhFGMjPh1GKGMHukuDX9nSNV3ZATQOrjr9Z7FnVdHojmWp3AQ/D
         UB0Yer9Ino6tWsXf27b6wuDv4kN0A+4wTXxXveOsRONJRamNUUsplVuzFK4CAOJwIqc3
         jquJ5emrvua0MxIdyAf1vhc8JkZkKiQ/+G61ASpm6bPhd63SKN0nybS0ww+PXs6GAFAd
         nKAf8Z/HHsFao0CCaLs6FwhPqJ0TfR84VFHI0SAoPcDFhDSWkUXZUKx7CWgHUpC6ggzN
         ELDA==
X-Gm-Message-State: AOAM533FjBk3mDytz5JbXJ0LYOSPKh4bwOnM/T5DDB+l4PaxQAeHmLT8
        Ih5l+N1kWN1qe1nvUSWF8+scwhWoD5AA48OxZyl7ao7Ownc=
X-Google-Smtp-Source: ABdhPJwal7ruFnyisaxC3ZAEvhE3qWh1qncCnYQR8nf232vyk+NFYH/WW1mOYb3sZlPKJFIGdOLDTLlDCcNUgmuNHJ0=
X-Received: by 2002:a05:6214:b2a:: with SMTP id w10mr3940821qvj.33.1600207411895;
 Tue, 15 Sep 2020 15:03:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200914183615.2038347-1-sdf@google.com> <20200914183615.2038347-5-sdf@google.com>
 <CAEf4BzZUS1Ht9mu3R+RY=CYbkdLt7k-xG5r35hUkeSDr_sjnFQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZUS1Ht9mu3R+RY=CYbkdLt7k-xG5r35hUkeSDr_sjnFQ@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 15 Sep 2020 15:03:21 -0700
Message-ID: <CAKH8qBuCGiRCj=ju5XZpuHvVBqLme6pgfpH0JV+2jgr30j0idA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 4/5] bpftool: support dumping metadata
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 4:39 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Sep 14, 2020 at 11:37 AM Stanislav Fomichev <sdf@google.com> wrote:
> > +               if (map_info.type != BPF_MAP_TYPE_ARRAY)
> > +                       continue;
> > +               if (map_info.key_size != sizeof(int))
> > +                       continue;
> > +               if (map_info.max_entries != 1)
> > +                       continue;
> > +               if (!map_info.btf_value_type_id)
> > +                       continue;
> > +               if (!strstr(map_info.name, ".rodata"))
> > +                       continue;
> > +
> > +               *map_id = map_ids[i];
>
> return value_size here to avoid extra syscall below; or rather just
> accept bpf_map_info pointer and read everything into it?
Good idea, will just return bpf_map_info.

> > +       value = malloc(map_info->value_size);
> > +       if (!value)
> > +               goto out_close;
> > +
> > +       if (bpf_map_lookup_elem(map_fd, &key, value))
> > +               goto out_free;
> > +
> > +       close(map_fd);
> > +       return value;
> > +
> > +out_free:
> > +       free(value);
> > +out_close:
> > +       close(map_fd);
> > +       return NULL;
> > +}
> > +
> > +static bool has_metadata_prefix(const char *s)
> > +{
> > +       return strstr(s, BPF_METADATA_PREFIX) == s;
>
> this is a substring check, not a prefix check, use strncmp instead
Right, but I then compare the result to the original value (== s).
So if the substring starts with 0th index, we are good.

"strncmp(s, BPF_METADATA_PREFIX, BPF_METADATA_PREFIX_LEN) == 0;" felt
a bit clunky, but I can use it anyway if it helps the readability.

> > +}
> > +
> > +static void show_prog_metadata(int fd, __u32 num_maps)
> > +{
> > +       const struct btf_type *t_datasec, *t_var;
> > +       struct bpf_map_info map_info = {};
>
> it should be memset
Sounds good.

>
> > +       } else {
> > +               json_writer_t *btf_wtr = jsonw_new(stdout);
> > +               struct btf_dumper d = {
> > +                       .btf = btf,
> > +                       .jw = btf_wtr,
> > +                       .is_plain_text = true,
> > +               };
>
> empty line here?
Sure.
