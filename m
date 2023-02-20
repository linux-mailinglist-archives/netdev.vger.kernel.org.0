Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC8569C577
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 07:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjBTGwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 01:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbjBTGwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 01:52:36 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED5DEB6E
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 22:52:33 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id m7so387823lfj.8
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 22:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6CWW5uGUlAt6Sd8nKZj5npU45hxB5kJkdPJ1fT9sd6E=;
        b=HhDvLYpHdjrALFMb5xlqKhWe9yGcFu5oU2QNjnJWD2wRBlenuRENihTwmVFGGr0cDw
         6Gh/mT85lH/EFBC7p3aC4uGMGxL4TW8wFzRZNALajqXXMW8hJkRwRRH4gMKgxzRRNVD+
         IA8nbh6f76/4MkiJLQlUWkf0cQuo5fm2bJ93So7L0zkCnhAHpBCAfW6PV+X72hUomvEM
         qCrha5ZgXEo8ytn037Mvq1wXzMsGSzqwKfwa0Bmss0n7LGFbZB0r795eXn8i2ElUgdG3
         7lFz8newb/Ol1wnh1B4xl/QQ1K/3zok2FqtToQLyitNkBnR7LF9M525EhcJYLeo5CD/Z
         j54w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6CWW5uGUlAt6Sd8nKZj5npU45hxB5kJkdPJ1fT9sd6E=;
        b=hTOakheOQLcjz2voAnliSi67CclY3b6yx7fxUA2v0z6n/IL9QElyzgnWYyZkErJsCY
         bpai7Hi75Xcz5FWHkZZQkV38UVJ8kkTfklNl2WII7RP6/ga+o/lj07oBd18Tv8P333RG
         5sfuStVZTBeRydac3WAe0NjYGScuWZ31RwdX5oH441iuLwc2mwDQP+TAn7+XIEWSC8DN
         20frt8EwrKqFMYG1bE+/P5DiUK1rzf8c680gUL9rx6QKireoGl9AmjP3L8I94BlKQRrA
         JfRfOJBXve6bz8fcft91uZ6kCGEKVDmrlYS8Pd+tg9MBfPJ+ZDcNJX6aKT5QHh88UDvr
         4p8A==
X-Gm-Message-State: AO0yUKXxsQV3gWF9JOswODKqPEeD1A4Z6cTgqtXE7l3/jc0j2U9CUvs4
        xsrk+NuiFviygzQ6yh+icDmC+LMKDyEj8sE399mpRw==
X-Google-Smtp-Source: AK7set/FzkeRlCVFqlhSE4tboJRsOG7fcq2tajzcz2a+xN6YH+d4hlwiy9+UW4wTwa0/G7MThUOwOqFUTAPHI81esdk=
X-Received: by 2002:a05:6512:3d90:b0:4dc:7e56:9839 with SMTP id
 k16-20020a0565123d9000b004dc7e569839mr867321lfv.5.1676875951338; Sun, 19 Feb
 2023 22:52:31 -0800 (PST)
MIME-Version: 1.0
References: <0000000000008f00f7058ad13ec8@google.com> <0000000000009fddba05f500c785@google.com>
In-Reply-To: <0000000000009fddba05f500c785@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 20 Feb 2023 07:52:18 +0100
Message-ID: <CACT4Y+asA1zb6A4SJTDgF+rpNyZoHmE27xjfQd5pqg2_wyhErA@mail.gmail.com>
Subject: Re: [syzbot] [net?] [ntfs3?] KMSAN: uninit-value in bcmp
To:     syzbot <syzbot+d8b02c920ae8f3e0be75@syzkaller.appspotmail.com>
Cc:     almaz.alexandrovich@paragon-software.com, davem@davemloft.net,
        edward.lo@ambergroup.io, glider@google.com, idosch@mellanox.com,
        ivan.khoronzhuk@linaro.org, jiri@mellanox.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, ntfs3@lists.linux.dev, petrm@mellanox.com,
        phind.uet@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Feb 2023 at 23:16, syzbot
<syzbot+d8b02c920ae8f3e0be75@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 4f1dc7d9756e66f3f876839ea174df2e656b7f79
> Author: Edward Lo <edward.lo@ambergroup.io>
> Date:   Fri Sep 9 01:04:00 2022 +0000
>
>     fs/ntfs3: Validate attribute name offset
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=149cdbcf480000
> start commit:   b7b275e60bcd Linux 6.1-rc7
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2325e409a9a893e1
> dashboard link: https://syzkaller.appspot.com/bug?extid=d8b02c920ae8f3e0be75
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164c4a4b880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=152bfbc9880000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: fs/ntfs3: Validate attribute name offset

Looks reasonable to me"

#syz fix: fs/ntfs3: Validate attribute name offset
