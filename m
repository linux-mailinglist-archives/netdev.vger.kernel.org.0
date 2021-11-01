Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4682A441E3E
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbhKAQez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbhKAQez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:34:55 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DADC061764
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 09:32:21 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id d204so46012839ybb.4
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 09:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g5ol0AYm2sAGfq8l97ZO11WDDIt00r58oC9POqY6YEE=;
        b=eSroFXBdDrgEh2Wq3xG9Hu3HcSWqx2dvFraeGErB18NX0IcrJsUVyDkuneLP4HEO2w
         IufgizEsj/eElTRygLuF7+n3Iy0BrU809zefJtyCE3Zyfk6qKM7n3F0TF/P7eAZ1j8Tv
         6bG518PofuS3JQruLR7HWeVPjB5hxSOIU3NcbSOlaFggr9d4hBuywrYwjM/q4bgC/vPl
         B2AiGu5tpl+IGAnfAaZGf74lUIWVTHZgrYZvbDK/IitrASzTjN3MiURS7bndl67syadW
         937G2NYEVc5Vzdre8st70XRjj+NKLvUxZsh4kdkT6YcJHtAjNaBNBigP28sWokP87Qhz
         mV+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g5ol0AYm2sAGfq8l97ZO11WDDIt00r58oC9POqY6YEE=;
        b=xlv8CqfwcVZxmDGWzAnAnxJtw6kUAIPHtOOkdGPJhD7R7mqpr8AQYfyAKpQt1KUYxc
         uyq0jFa+3CVRbpru6ZURevAnbKSD2r1+jRFrJ3ca9HaabDBH/hfJQallLUuvaJFZ/T/j
         yOQ1sjEanxBw/gv60t9X43qwsslYZL8Fk+viKDmqFKtdlXwSiTNRb6QbLh++nZRQmhA3
         zPJmNc7L7Dfvgagf7uLZeoqs+9pYLJaCZfxK8mAgkpb0Pf/wP6PIYBfADU3UTjPEcJYq
         50OsKExohtD8WoGKGRnLluR8InrHTl2Rev83WSc9xDHVC8kecsq928gy9dhr3FR5gBPK
         Blzw==
X-Gm-Message-State: AOAM530u6w7jzNfgZg/vCgQmIhbvDTzzcfoTcTnn+YHIzIF+5szrPiXr
        8+uUzC9UY0xjH5dbVZA2h25rz1q9g/MOgjQ044i1jQ==
X-Google-Smtp-Source: ABdhPJwysFx3gFj8nEH4bDUiMYFdq3fr94iVph31pmlE+6cd1+WaxNxps8mq5qRDKABBzwRkrYrWkpknIW1pJgoXEg8=
X-Received: by 2002:a25:6b4d:: with SMTP id o13mr30707825ybm.291.1635784340525;
 Mon, 01 Nov 2021 09:32:20 -0700 (PDT)
MIME-Version: 1.0
References: <20211031171353.4092388-1-eric.dumazet@gmail.com> <c735d5a9-cf60-13ba-83eb-86cbcd25685e@fb.com>
In-Reply-To: <c735d5a9-cf60-13ba-83eb-86cbcd25685e@fb.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 1 Nov 2021 09:32:07 -0700
Message-ID: <CANn89iLY7etQxhQa06ea2FThr6FyR=CNnQcig65H4NhE3fu0FQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: add missing map_delete_elem method to bloom
 filter map
To:     Yonghong Song <yhs@fb.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
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

On Sun, Oct 31, 2021 at 9:01 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> LGTM with a suggestion below.
>
> Acked-by: Yonghong Song <yhs@fb.com>
>

> There is a pending patch
> https://lore.kernel.org/bpf/20211029224909.1721024-2-joannekoong@fb.com/T/#u
> to rename say lookup_elem to bloom_map_lookup_elem.
> I think we should change
> this delete_elem to bloom_map_delete_elem as well.
>

Thanks for letting me know.
I can rebase my patch after yours is merged, no worries.
