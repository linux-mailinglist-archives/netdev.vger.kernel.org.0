Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A8C1B4304
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 13:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgDVLTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 07:19:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28648 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725787AbgDVLT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 07:19:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587554366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3adrceupXKyLIJE05IQbOejDBq5MFoIz0/34EbiMoJY=;
        b=PGk7I5cKQw34pz13IzpAkZy8ZucbtiapSKWbzfHGhgTgTH+tHeb3ABF6PG0jBVgvFMx1qT
        UjvlR93L6AsuGsF2Fcpj3LMtqRXEGzRLSYBY4yBAI8GPBfItqZgMcwT3AE8ut35Rp4cZr0
        s8unYf/N5XRjKwc5fGhFkeHVzYm6lW4=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-Pcqzdz_HPRiBYpsTzQGSjg-1; Wed, 22 Apr 2020 07:19:24 -0400
X-MC-Unique: Pcqzdz_HPRiBYpsTzQGSjg-1
Received: by mail-lj1-f199.google.com with SMTP id d25so292994ljo.4
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 04:19:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=3adrceupXKyLIJE05IQbOejDBq5MFoIz0/34EbiMoJY=;
        b=NrkeTCGVsSzPSHUS9ubmVJFXnI/Ph/X/jbjx8tY1pdNNV1fu+H5VTf+a6lkrjUEt+Y
         C9ZQxRMmZJig8XZ0llRW0mVQ7u77dusAFilDVsw6ZKv1bMNn7m9/kN+sYlsIWzdMcVO3
         wkDTmf695kPL04nJrLw/b3fKimb9c4L98KZwyU4xzfP8PyyMEtD/C/lLQzMs2wGjcRUP
         XjdJA5X7vnFG0k2Swkh9ekrlKY5FfCN/1qS+fxuY4rWonEY96bgiSI1coEs7gkaGtXDq
         TdMA3eVCEnoyq5ZRjQ6EN3rBJhQKqjk6wlbY5CAzVM7uNfhJMbQGJF/GF4JCplYEbpwt
         Uycg==
X-Gm-Message-State: AGi0PuZktJ3Yybpgli+aFKfd49qo8jfUYqphgACG4wO/MJbz1uSUYvjl
        AOj8ya4hPLfSgHvfy4xfZVSa65JAeGX38vheuqHV9lWJ46YU5qGvcEszuY7pQl21APaIJE7taw8
        3+ZKbPeG4BAa7H1so
X-Received: by 2002:a2e:3a0a:: with SMTP id h10mr14858575lja.54.1587554362434;
        Wed, 22 Apr 2020 04:19:22 -0700 (PDT)
X-Google-Smtp-Source: APiQypKgTKXtFT05R5dgb80W+Fuy9drBsDeICtlv+U2YLMTUHhv1QoWmXiMqwE8E5fRKbb5CBf3WbA==
X-Received: by 2002:a2e:3a0a:: with SMTP id h10mr14858565lja.54.1587554362199;
        Wed, 22 Apr 2020 04:19:22 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id u16sm4194094ljk.9.2020.04.22.04.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:19:21 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B7315181586; Wed, 22 Apr 2020 13:19:18 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: add BTF-defined map-in-map support
In-Reply-To: <20200422051006.1152644-1-andriin@fb.com>
References: <20200422051006.1152644-1-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 22 Apr 2020 13:19:18 +0200
Message-ID: <87mu737op5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> As discussed at LPC 2019 ([0]), this patch brings (a quite belated) support
> for declarative BTF-defined map-in-map support in libbpf. It allows to define
> ARRAY_OF_MAPS and HASH_OF_MAPS BPF maps without any user-space initialization
> code involved.
>
> Additionally, it allows to initialize outer map's slots with references to
> respective inner maps at load time, also completely declaratively.
>
> Despite a weak type system of C, the way BTF-defined map-in-map definition
> works, it's actually quite hard to accidentally initialize outer map with
> incompatible inner maps. This being C, of course, it's still possible, but
> even that would be caught at load time and error returned with helpful debug
> log pointing exactly to the slot that failed to be initialized.
>
> Here's the relevant part of libbpf debug log showing pretty clearly of what's
> going on with map-in-map initialization:
>
> libbpf: .maps relo #0: for 6 value 0 rel.r_offset 96 name 260 ('inner_map1')
> libbpf: .maps relo #0: map 'outer_arr' slot [0] points to map 'inner_map1'
> libbpf: .maps relo #1: for 7 value 32 rel.r_offset 112 name 249 ('inner_map2')
> libbpf: .maps relo #1: map 'outer_arr' slot [2] points to map 'inner_map2'
> libbpf: .maps relo #2: for 7 value 32 rel.r_offset 144 name 249 ('inner_map2')
> libbpf: .maps relo #2: map 'outer_hash' slot [0] points to map 'inner_map2'
> libbpf: .maps relo #3: for 6 value 0 rel.r_offset 176 name 260 ('inner_map1')
> libbpf: .maps relo #3: map 'outer_hash' slot [4] points to map 'inner_map1'
> libbpf: map 'inner_map1': created successfully, fd=4
> libbpf: map 'inner_map2': created successfully, fd=5
> libbpf: map 'outer_arr': created successfully, fd=7
> libbpf: map 'outer_arr': slot [0] set to map 'inner_map1' fd=4
> libbpf: map 'outer_arr': slot [2] set to map 'inner_map2' fd=5
> libbpf: map 'outer_hash': created successfully, fd=8
> libbpf: map 'outer_hash': slot [0] set to map 'inner_map2' fd=5
> libbpf: map 'outer_hash': slot [4] set to map 'inner_map1' fd=4
>
> See also included selftest with some extra comments explaining extra details
> of usage.

Could you please put an example of usage in the commit message as well?
Easier to find that way, especially if the selftests are not handy (such
as in the libbpf github repo).

-Toke

