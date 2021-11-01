Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58D044229B
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 22:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhKAV1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 17:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhKAV1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 17:27:42 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E6BC061714;
        Mon,  1 Nov 2021 14:25:09 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id x5so8515167pgk.11;
        Mon, 01 Nov 2021 14:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+E7meb6AM3Up3QgOQ21XHUsiWwwWzfkf0vIwdCxOKxs=;
        b=a7kBtimU8uOuU++ibPOj46yFdPczMO/8F2W0Iqd8QqCjv6b0yUaa/ZdZUF/ZWqmJ6s
         nIlFfgWPQ6uNbc7QmwU7J/V1FIHZck1YXFEFcgOuH2r86SrXriV/gB1geESjvtzg9fUe
         ybGtTyC5TPWUOIoCUed18/thGQ0JpWA57agtHfjFl+NRlawE746M573fdAPdpmIgVAAt
         YRpTnBZ0bvEaI8IPJxsSXt3ty7eD1prJD8POQpcZVbpkl43tNT9A24F87OPLvjFCeLdC
         A8HnXf5aQUWU4EVt9yaGgH+omQ6GlxkZMkWqPmlEcaRovXfNhESZEBJ5Hzd2JyK0gOTJ
         URJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+E7meb6AM3Up3QgOQ21XHUsiWwwWzfkf0vIwdCxOKxs=;
        b=iBLRs4k3aG0Um7dVUQSNBq9PEfVWdeGYJ9dnd8cJhZIT+JkqwJud/Py01xl4POcUqI
         v8cAbCPcBWrtMy9kOeNvrn10WzGbydQo3wJmL1sJAYDUKQTgwoDeXYaHoLxaW3vElPe3
         6vc50t0blR1cVgEI0Qr4UDiTeeca9T19oMbGy+W0ewq3mRibF8uxtZVp0t2A6x64ZYOy
         uNc2JWaBISefJ9ilJlOHJlShbGlkEsuAz9gT9t6ubb2UBEY4gO4VAqDLRhjxqo6GYjyS
         eRZ3PuX2+mfmCtyKVFKnQTqKGxXqALO64STNeYoK9SxzIBFS3TaXgAWcm/iYNzZVLpNs
         hYXw==
X-Gm-Message-State: AOAM5327qVCjqBi+h0NqywG2VUJvZNZQ9k9kXx/0xuYgv4Q1AgDEH7U1
        OEQjOlcwOTVeCe4VrHV6ehahuNEUux+Lutwg5Ow=
X-Google-Smtp-Source: ABdhPJwlbzsn5pZrwPu6J1tIK5VojJ7VQNmlVgEyBePXSaYtHAgjbNERb2FWQcffcSp3hmBixHd6WqcncUDWvvGDQ/4=
X-Received: by 2002:a63:374c:: with SMTP id g12mr23874315pgn.35.1635801908608;
 Mon, 01 Nov 2021 14:25:08 -0700 (PDT)
MIME-Version: 1.0
References: <20211031171353.4092388-1-eric.dumazet@gmail.com>
 <c735d5a9-cf60-13ba-83eb-86cbcd25685e@fb.com> <CANn89iLY7etQxhQa06ea2FThr6FyR=CNnQcig65H4NhE3fu0FQ@mail.gmail.com>
In-Reply-To: <CANn89iLY7etQxhQa06ea2FThr6FyR=CNnQcig65H4NhE3fu0FQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 1 Nov 2021 14:24:57 -0700
Message-ID: <CAADnVQLLKF_44QabyEZ0xbj+LxSssT9_gd3ydjL036E4+erG9Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: add missing map_delete_elem method to bloom
 filter map
To:     Eric Dumazet <edumazet@google.com>
Cc:     Yonghong Song <yhs@fb.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Joanne Koong <joannekoong@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 1, 2021 at 9:32 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sun, Oct 31, 2021 at 9:01 PM Yonghong Song <yhs@fb.com> wrote:
> >
> >
> >
> > LGTM with a suggestion below.
> >
> > Acked-by: Yonghong Song <yhs@fb.com>
> >
>
> > There is a pending patch
> > https://lore.kernel.org/bpf/20211029224909.1721024-2-joannekoong@fb.com/T/#u
> > to rename say lookup_elem to bloom_map_lookup_elem.
> > I think we should change
> > this delete_elem to bloom_map_delete_elem as well.
> >
>
> Thanks for letting me know.
> I can rebase my patch after yours is merged, no worries.

I rebased and patched it manually while applying.
Thanks!
