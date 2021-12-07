Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D49946B668
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 09:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbhLGIwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 03:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbhLGIwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 03:52:47 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14CFC061746;
        Tue,  7 Dec 2021 00:49:17 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so1650445wme.4;
        Tue, 07 Dec 2021 00:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WR3XNH9hoK8ZtVWQA595RwwDV0SffmRjU6r2kR8gbWM=;
        b=kQebnwCH7l24ETjQEWS6ETLaiVltMx/2xrD+Hd5TCVjrdzPZLbQacQMzFxTU6ojtsO
         lFvYp96ic7EK6fe7pbLupFdLT1krMVhF2W8GBuFUz+fsuMlsoPQfpWsTDM4VGEC5A5yl
         DMBRu2d+vMFjz3wDBXT3BrF4bn7ig25xi/iwM5dwjhfA3YsTdosM/hBaljc+hrl29QH+
         rT6vN5+q2xp+UC1amlpQr54yIGx5hYRMFHHKGgDNpDGffIG7+3+iIigsYR2fPNCDECiK
         t3nQUDCsk6iCNACR56Ri/C/BzdFFtA5RtOxsmGrzqw/WgXdBPEOfPt7c23l5Hp1fJ/p0
         FGgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WR3XNH9hoK8ZtVWQA595RwwDV0SffmRjU6r2kR8gbWM=;
        b=FCVmAMlJkzM71vhgeQWXb7y33MtJzgIDWTAr3NJEONg5f8w4By7wZvYKjZGOv95x3a
         GEo4fDQHeosQmiTsRYbotYZlQ8C17IOH+mz6ahQfw6o2jBnYUwC/bXHCLIjEQ0E7tVRd
         VIslRW9QfBEHpGt6w8SSm5mQ9SpNMJudlWa84d4cu9xrRqK8h2zvlI5XBEV1ao28ggSt
         K+43NolsJuT3KMgcqLkDKciPd6rn5o39RevEYcgVJSHHKi6uqr28GPySpcqLcOt9b+4W
         tgfx/4x5vUQKYvSrwrGclXRS+E9QroZTpjAvrMxwYhS7Ikb4AMjfIN+WQ8Dk/MlOki2h
         xhLQ==
X-Gm-Message-State: AOAM533wq+Epq6ou4CrEDNas8P4vEoVwMF3lLL/Ap5RaExODtpeZwrL1
        fxOSBO03PfJUin9AgIy7Hau/HjVjAnT8hRKZJE+xWCM9tSw=
X-Google-Smtp-Source: ABdhPJwve9J1pQZGydGBAGL8WOj+b4TYduyJ0O1EmFrjdQKnY9LXuWq+0YuwBGI9qH/lmSFUDjqp/sFsPGPZ49vn0ZE=
X-Received: by 2002:a1c:7f43:: with SMTP id a64mr5329973wmd.133.1638866956371;
 Tue, 07 Dec 2021 00:49:16 -0800 (PST)
MIME-Version: 1.0
References: <000000000000a3571605d27817b5@google.com>
In-Reply-To: <000000000000a3571605d27817b5@google.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 7 Dec 2021 09:49:04 +0100
Message-ID: <CAJ+HfNhyfsT5cS_U9EC213ducHs9k9zNxX9+abqC0kTrPbQ0gg@mail.gmail.com>
Subject: Re: [syzbot] WARNING: kmalloc bug in xdp_umem_create (2)
To:     syzbot <syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs@googlegroups.com, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Dec 2021 at 11:55, syzbot
<syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    a51e3ac43ddb Merge tag 'net-5.16-rc4' of git://git.kernel=
...
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D17f04ebeb0000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D5b0eee8ab3ea1=
839
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D11421fbbff99b98=
9670e
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binuti=
ls for Debian) 2.35.2
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com
>

This warning stems from mm/utils.c:
    /* Don't even allow crazy sizes */
    if (WARN_ON_ONCE(size > INT_MAX))
        return NULL;

The structure that is being allocated is the page-pinning accounting.
AF_XDP has an internal limit of U32_MAX pages, which is *a lot*, but
still fewer than what memcg allows (PAGE_COUNTER_MAX is a
LONG_MAX/PAGE_SIZE on 64b systems).

The (imo hacky) workaround to silence the warning is to decrease the
U32_MAX limit to something that is less than "sizeof householding
struct".

Note that this is a warning, and not an oops/bug.

Thoughts?


Bj=C3=B6rn
