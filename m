Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753F0211B29
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 06:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgGBEeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 00:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGBEeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 00:34:04 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C524C08C5C1;
        Wed,  1 Jul 2020 21:34:04 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id 145so22006702qke.9;
        Wed, 01 Jul 2020 21:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4SM5CtvYDYhH2pQU+e1jD0HrHrlR+fUjehzgj8bKweg=;
        b=ptjexy95C+Yjvc2nQi6jJfqeich2hYJtZ9fLxHMTyRbDXt0FAQyuNTkeyuOVYkKpIW
         TTrHzTjsA6E1e9M/f5DbmtZL+zk8T6/M3dCiGpWvdLAMv0E0f0XgtZSpMnO3RHVb51el
         PIn5cjiArQXJl8qP/Co9c8F32LWMUGWbNi84mioQezKmk2J8Rep72ZnacB4p1eoH4uVt
         rnzPZjShMb01AXq98kvKLWVdGxU0nEhvptw7P3ZBXzBd6MdHoad5407GX1pZqo2vdkN5
         2j6JuGnC5yU/sZsaSJhe/x9dncMAOK9IDF/sbfHpnHV9OmUOlUwHVn2VQHuxbPppcrnO
         Gfuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4SM5CtvYDYhH2pQU+e1jD0HrHrlR+fUjehzgj8bKweg=;
        b=jeTEqgpUscWaJhx4hkdzXZIYkb5XY08A0cQo5zqytze7z8eLdqqgOHMxJxfMc/36NZ
         z2b4Qo3MpapT7zklySnajEZ5s+NkR96HX1U+LXcpu5JaYJ7X5mav53RRtvhiWMKVlHnk
         7iSRERcXeFfmyuGXYB6FY2+JZYsGQ+qb0nizovdO2A83RNlqkRMNbkJK6DIrwzM3IpsQ
         v+AW2dc789+GseK9qsCu4RAOghcCW51TNDEJZ5qW2/OWqw0aXj6H7cROG9up0so1rS81
         bm6DbL/Ya/d41LVqHlysuulR9PJBeAcoepm4jJyqsEqHUCBEpDlYb1GxgzdlFWAU0B9u
         VH5g==
X-Gm-Message-State: AOAM5305ZIOdb/IPPFMenFNOVoRDipbcuGmCfUAIIg3HwESkgqi76dkX
        aZRGryrnsxP53/049oqUabcWM+74q1AIY2uI1SzjM0pP7fY=
X-Google-Smtp-Source: ABdhPJziR+6aoMrxpbgTWmt/ADKvPlWYLh6U7mvVeDtTMmjCCZ7vnNIN1zOrsQ9NFbuRqfa3DeMmC2SQN+svHGVSsf8=
X-Received: by 2002:a05:620a:2409:: with SMTP id d9mr29588694qkn.36.1593664443352;
 Wed, 01 Jul 2020 21:34:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200702021646.90347-1-danieltimlee@gmail.com> <20200702021646.90347-4-danieltimlee@gmail.com>
In-Reply-To: <20200702021646.90347-4-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 1 Jul 2020 21:33:52 -0700
Message-ID: <CAEf4BzZsx+pkkdjhJt1AHaUy6=B=nqZdpR+TrRrjreNa0GMWug@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/4] samples: bpf: refactor BPF map performance
 test with libbpf
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 7:17 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Previously, in order to set the numa_node attribute at the time of map
> creation using "libbpf", it was necessary to call bpf_create_map_node()
> directly (bpf_load approach), instead of calling bpf_object_load()
> that handles everything on its own, including map creation. And because
> of this problem, this sample had problems with refactoring from bpf_load
> to libbbpf.
>
> However, by commit 1bdb6c9a1c43 ("libbpf: Add a bunch of attribute
> getters/setters for map definitions"), a helper function which allows
> the numa_node attribute to be set in the map prior to calling
> bpf_object_load() has been added.
>
> By using libbpf instead of bpf_load, the inner map definition has
> been explicitly declared with BTF-defined format. And for this reason
> some logic in fixup_map() was not needed and changed or removed.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/bpf/Makefile             |   2 +-
>  samples/bpf/map_perf_test_kern.c | 180 +++++++++++++++----------------
>  samples/bpf/map_perf_test_user.c | 130 +++++++++++++++-------
>  3 files changed, 181 insertions(+), 131 deletions(-)
>

[...]

> +struct inner_lru {
> +       __uint(type, BPF_MAP_TYPE_LRU_HASH);
> +       __type(key, u32);
> +       __type(value, long);
> +       __uint(max_entries, MAX_ENTRIES);
> +       __uint(map_flags, BPF_F_NUMA_NODE); /* from _user.c, set numa_node to 0 */
> +} inner_lru_hash_map SEC(".maps");

you can declaratively set numa_node here with __uint(numa_node, 0),
which is actually a default, but for explicitness it's better

> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
> +       __uint(max_entries, MAX_NR_CPUS);
> +       __uint(key_size, sizeof(u32));
> +       __array(values, struct inner_lru); /* use inner_lru as inner map */
> +} array_of_lru_hashs SEC(".maps");
> +

[...]

> -static void fixup_map(struct bpf_map_data *map, int idx)
> +static void fixup_map(struct bpf_object *obj)
>  {
> +       struct bpf_map *map;
>         int i;
>
> -       if (!strcmp("inner_lru_hash_map", map->name)) {
> -               inner_lru_hash_idx = idx;
> -               inner_lru_hash_size = map->def.max_entries;
> -       }
> +       bpf_object__for_each_map(map, obj) {
> +               const char *name = bpf_map__name(map);
>
> -       if (!strcmp("array_of_lru_hashs", map->name)) {

I'm a bit too lazy right now to figure out exact logic here, but just
wanted to mention that it is possible to statically set inner map
elements for array_of_maps and hash_of_maps. Please check
tools/testing/selftests/bpf/progs/test_btf_map_in_map.c and see if you
can use this feature to simplify this logic a bit.

> -               if (inner_lru_hash_idx == -1) {
> -                       printf("inner_lru_hash_map must be defined before array_of_lru_hashs\n");
> -                       exit(1);
> +               /* Only change the max_entries for the enabled test(s) */
> +               for (i = 0; i < NR_TESTS; i++) {
> +                       if (!strcmp(test_map_names[i], name) &&
> +                           (check_test_flags(i))) {
> +                               bpf_map__resize(map, num_map_entries);
> +                               continue;
> +                       }
>                 }
> -               map->def.inner_map_idx = inner_lru_hash_idx;
> -               array_of_lru_hashs_idx = idx;
>         }
>

[...]
