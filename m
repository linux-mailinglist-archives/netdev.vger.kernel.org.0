Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762C027BB91
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 05:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgI2Day (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 23:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgI2Day (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 23:30:54 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225FFC061755;
        Mon, 28 Sep 2020 20:30:54 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 133so2538231ybg.11;
        Mon, 28 Sep 2020 20:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sLMvUto+o6tyT6B9ZRGNVB2YVLrE5KRP5IeJEFWRrVk=;
        b=evrjgEC9T2TBp4OG9ZHlhkiaN7SjPl+8msoGuXbMvIbVdoagqucfatI/4tNIU+UwUH
         LdRYfkM9Fz8ostuZYq+c8f+H9umKDwnMR6Q2JD3eQ1FWd/2piiHSd55S8SaIsrDue9pg
         NuOfDMr9i+O8ZJfwqdk5Jzu8ZrkvSlqBSyYWKLEVUurg3a+K3g7/nS+tKe+RQlU0aEQ4
         MWZeDmefygeYQxgk8Igd0YQ2RnKdseqYJx4pm+6L6M5WuOzsvL9O6K9TM8GXjXtIgzMJ
         ZT9LUmYNZ6wTvIpmeF/v9vYgE9jPsAsnPzNziL6Sn7CRjN1euiZW1ctlbFCVBjf8WHHh
         bLig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sLMvUto+o6tyT6B9ZRGNVB2YVLrE5KRP5IeJEFWRrVk=;
        b=F9nMCvRLlpYHvzRxYFYZzuDCBX+UiD0WpRVZi04IFrxH65nn602DcK+IkjsnW7ewUI
         GOY+iNcOS5RqK7eGQJSo753qvF4PghQSZdSEtqvuCa/f5s2P36ezBj0abO1rLUQ3JSas
         EXmqT3zWPBIZerwXZsiEd4h2nde4XjplyCq2h2NRfF+C7vsEjwJVbp3KnLjS3+esieTy
         MEMVdjdD7kXzjShXW41f5AWzTxhII4PXlwHabm27i4JKa0un7gtSTlVLDivBqMGUS1uK
         0jlEWBpdkbam6xoVxrXcsp+JSiwwfpQEeDlnCixukWnWBl7MH0hHtAwz10zSuAKwXwqC
         yJZw==
X-Gm-Message-State: AOAM532Uwd15cG7I/D7w7FtP7RadKqR+JlOcFEAmFZqTyGWJORFmd5g5
        16aPgXMh1364DCbB7Hm9rPZKBCridxOjJmQ7W950RVANhbnS3Q==
X-Google-Smtp-Source: ABdhPJyVm5aNMEvKYxK7dLXQRcqaxzmSeuC4HldFxCrm8WF8Gc/PzxeVMC7w0MjyBuppHJjSax6BmJTXvugNWJunqfM=
X-Received: by 2002:a25:6644:: with SMTP id z4mr3539545ybm.347.1601350253272;
 Mon, 28 Sep 2020 20:30:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200929031845.751054-1-liuhangbin@gmail.com>
In-Reply-To: <20200929031845.751054-1-liuhangbin@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 28 Sep 2020 20:30:42 -0700
Message-ID: <CAEf4BzYKtPgSxKqduax1mW1WfVXKuCEpbGKRFvXv7yNUmUm_=A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: export bpf_object__reuse_map() to libbpf api
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 8:20 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Besides bpf_map__reuse_fd(), which could let us reuse existing map fd.
> bpf_object__reuse_map() could let us reuse existing pinned maps, which
> is helpful.
>
> This functions could also be used when we add iproute2 libbpf support,
> so we don't need to re-use or re-implement new functions like
> bpf_obj_get()/bpf_map_selfcheck_pinned() in iproute2.
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/lib/bpf/libbpf.c | 3 +--
>  tools/lib/bpf/libbpf.h | 1 +
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 32dc444224d8..e835d7a3437f 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4033,8 +4033,7 @@ static bool map_is_reuse_compat(const struct bpf_map *map, int map_fd)
>                 map_info.map_flags == map->def.map_flags);
>  }
>
> -static int
> -bpf_object__reuse_map(struct bpf_map *map)
> +int bpf_object__reuse_map(struct bpf_map *map)
>  {
>         char *cp, errmsg[STRERR_BUFSIZE];
>         int err, pin_fd;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index a750f67a23f6..4b9e615eb393 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -431,6 +431,7 @@ bpf_map__prev(const struct bpf_map *map, const struct bpf_object *obj);
>  /* get/set map FD */
>  LIBBPF_API int bpf_map__fd(const struct bpf_map *map);
>  LIBBPF_API int bpf_map__reuse_fd(struct bpf_map *map, int fd);
> +LIBBPF_API int bpf_object__reuse_map(struct bpf_map *map);

It's internal function, which doesn't check that map->pin_path is set,
for one thing. It shouldn't be exposed. libbpf exposes
bpf_map__set_pin_path() to set pin_path for any map, and then during
load time libbpf with "reuse map", if pin_path is not NULL. Doesn't
that work for you?

>  /* get map definition */
>  LIBBPF_API const struct bpf_map_def *bpf_map__def(const struct bpf_map *map);
>  /* get map name */
> --
> 2.25.4
>
