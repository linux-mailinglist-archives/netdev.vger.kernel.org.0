Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED13E14C8
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 10:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390314AbfJWIyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 04:54:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40784 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390034AbfJWIyC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 04:54:02 -0400
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com [209.85.208.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 45AE27FDF0
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 08:54:02 +0000 (UTC)
Received: by mail-lj1-f197.google.com with SMTP id v24so3469010ljh.23
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 01:54:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=SiOV7Z57BQOyO4TO81ImQ+ZItl6n4Wr0rKFozym1WTA=;
        b=MYIusOgkNsDSZ1He2amyChDV/ZVHk1auNVxQALUNU+mGpRZfRKVfv0jV1KtUE2+1Go
         2Rfyawopa0Ls8K4U/hTC2jFzLfToXkfFBt197IhYFJKNHccKhX8ltrghViXIeysO+zjx
         1PekP7AejZf8dg9fYiuurdI0eED0Dw0eKvFlIcfmycyPteJ9loXFj5edQJ7lR0PgAA8u
         PBAk0XsTqfmBvKrtQEbX7NCHbN00isYY5LjFx2CQPhus0YWtSw/NFmNhXqUc2LE/DBtw
         cuWfm6G8fksN/9XQUvHhN9eq9QC18+6dPuoRI3VlArmUEPHD6M+LahXfWjuGLhbGEzee
         H8+Q==
X-Gm-Message-State: APjAAAW5u/KuuAlzLLhlc0KS8J5UDaUReuuuVIhbPBwfX3+imlwsMzoR
        3QTSS+YUhL7mvygpAD08ZBNM/klPkBXHEHXu0ZF79hLgx6wiTBfJoZXf9TR8YkALMx5UL13HMp5
        +6pH5OTOGUcVzRGs/
X-Received: by 2002:a2e:b813:: with SMTP id u19mr12953890ljo.23.1571820840810;
        Wed, 23 Oct 2019 01:54:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyobnfOcMs9qyrsH6twatdI07hRD8+v4F8xIsrtdZGqRcE6ZD2vOM4RLnQMb2iT92smAPx2LA==
X-Received: by 2002:a2e:b813:: with SMTP id u19mr12953875ljo.23.1571820840604;
        Wed, 23 Oct 2019 01:54:00 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id e8sm5898469ljf.1.2019.10.23.01.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 01:53:59 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 13BA01804B1; Wed, 23 Oct 2019 10:53:59 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/3] libbpf: Support configurable pinning of maps from BTF annotations
In-Reply-To: <CAEf4BzY-buKFadzzAKpCdjAZ+1_UwSpQobdRH7yQn_fFXQYX0w@mail.gmail.com>
References: <157175668770.112621.17344362302386223623.stgit@toke.dk> <157175668991.112621.14204565208520782920.stgit@toke.dk> <CAEf4BzaM32j4iLhvcuwMS+dPDBd52KwviwJuoAwVVr8EwoRpHA@mail.gmail.com> <875zkgobf3.fsf@toke.dk> <CAEf4BzY-buKFadzzAKpCdjAZ+1_UwSpQobdRH7yQn_fFXQYX0w@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 23 Oct 2019 10:53:58 +0200
Message-ID: <87r233n8pl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

>> > 4. Once pinned, map knows its pinned path, just use that, I don't see
>> > any reasonable use case where you'd want to override path just for
>> > unpinning.
>>
>> Well, unpinning may need to re-construct the pin path. E.g.,
>> applications that exit after loading and are re-run after unloading,
>> such as iproute2, probably want to be able to unpin maps. Unfortunately
>> I don't think there is a way to get the pin path(s) of an object from
>> the kernel, though, is there? That would be kinda neat for implementing
>> something like `ip link set dev eth0 xdp off unpin`.
>
> Hm... It seems to me that if application exits and another instance
> starts, it should generate pin path using the same logic, then check
> if map is already pinned. Then based on settings, either reuse or
> unpin first. Either way, pin_path needs to be calculated from map
> attributes, not "guessed" by application.

Yeah, ideally. However, the bpf object file may not be available (it's
not for iproute2, for instance). I'm not sure there's really anything we
*can* do about that, though, other than have the application guess.
Unless we add more state to the kernel.

Would it make sense to store the fact that a map was auto-pinned as a
flag in the kernel map info? That way, an application could read that
flag along with the name and go looking in /sys/fs/bpf.

Hmm, but I guess it could do that anyway; so maybe what we need is just
a "try to find all pinned maps of this program" function? That could
then to something like:

- Get the maps IDs and names of all maps attached to that program from
  the kernel.

- Look for each map name in /sys/fs/bpf

- If a pinned map with the same name exists, compare the IDs, and unlink
  if they match

I don't suppose it'll be possible to do all that in a race-free manner,
but that would go for any use of unlink() unless I'm missing something?

-Toke
