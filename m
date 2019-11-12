Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC046F869D
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 03:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKLCBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 21:01:20 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41044 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbfKLCBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 21:01:20 -0500
Received: by mail-qk1-f196.google.com with SMTP id m125so13094989qkd.8;
        Mon, 11 Nov 2019 18:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6QHfjEMIm9urGXzP9jnnx6VoybT/fMEP6wIaodxgVPw=;
        b=EurjmYjxpbuV8ghL4eiYHXNhCWh9st/DLHN1PXeHD2lamfdww2ufSez/EDoYiHyKWG
         MigpwA4okUDgqM25ErFmX/njSh03swEW+9Fucq1c5T4sL+f1941EXJNMQmh+F3owAnPG
         VTt8ERXQvOZaLg6AX0HGwIStKgK1aYeJZ4dE2erXiWxwEssyWloCmY0JygjFVtdMDrdj
         Kn2Nb7XG3rgCgS33JgsqXDq71G9XEBCEgrm3lKN+U2hDE6USZ5YFeIFu89bFSAvcIw2/
         /XgGAG5uhOnjRJMeQyXdi5Ar26KIcQTgqfcD7RFazgJEAJQCQWGlYrTeHV2F8+FTMgH5
         7jqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6QHfjEMIm9urGXzP9jnnx6VoybT/fMEP6wIaodxgVPw=;
        b=eLT6DSa5cCLfvzUBqKCwYdgj7oL8j45xhIPI76Ou4j5GK4itVw5eUeuI6h4HG/PiK6
         +6Vf5/zU/JoRaFqD1wH1+GYtUcRuENil9M5jsnVNquRM4anu28oMQ3+c7oYYyNWXR1KF
         IfzFHnm7w6pZq72j+ZW4PH6D/PUrxQKRYJIwd9Ahenaca12vpoVJqJ33y/bMSKy1Jcap
         /RNDmWmr3jbVsbRugZh9W7fUCCOVODKMxLwmlASUNgyuuvFP2eURW79dR3ewO8xwBjPo
         snCWENOf+caUUmjyz6C1/Igskx9TELTmIrdnHHGQEeIJ3AORGTWdR/Z+OKQivVZH+ai4
         lEkg==
X-Gm-Message-State: APjAAAUpsJKwvsd1s9r3A8yTybl3qMMNiEDQO3p9ykt+Y7yIRCSjsDV+
        GcHdJT4vT2NhWKpmRC1jbM5TrEq3s8OlHEi3Jv4=
X-Google-Smtp-Source: APXvYqwF9GoCLMkJf2Th24nG1MqMbDFv+BhkSfh2hB8MBlQHCkg1dmSuVKWzck4jq8cmXQaYG++hwzFRZSd+4+/NY4U=
X-Received: by 2002:a37:b3c4:: with SMTP id c187mr13752989qkf.36.1573524079217;
 Mon, 11 Nov 2019 18:01:19 -0800 (PST)
MIME-Version: 1.0
References: <20191109080633.2855561-1-andriin@fb.com> <20191109080633.2855561-2-andriin@fb.com>
 <20191111103916.0af3ac5b@cakuba>
In-Reply-To: <20191111103916.0af3ac5b@cakuba>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Nov 2019 18:01:07 -0800
Message-ID: <CAEf4BzbuBYOqkf2DwKEFU9yBs0ot_NPNUyr7wCc--jqpBB56qQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: add mmap() support for BPF_MAP_TYPE_ARRAY
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Rik van Riel <riel@surriel.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 10:39 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Sat, 9 Nov 2019 00:06:30 -0800, Andrii Nakryiko wrote:
> > @@ -74,7 +78,7 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
> >       int ret, numa_node = bpf_map_attr_numa_node(attr);
> >       u32 elem_size, index_mask, max_entries;
> >       bool unpriv = !capable(CAP_SYS_ADMIN);
> > -     u64 cost, array_size, mask64;
> > +     u64 cost, array_size, data_size, mask64;
> >       struct bpf_map_memory mem;
> >       struct bpf_array *array;
> >
>
> Please don't break reverse xmas tree where it exists.

alright, will move it up
