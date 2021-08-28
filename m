Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5C83FA312
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 04:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbhH1CMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 22:12:09 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:53860 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbhH1CMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 22:12:08 -0400
Received: by mail-io1-f71.google.com with SMTP id n189-20020a6b8bc6000000b005b92c64b625so5130741iod.20
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 19:11:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=76HdtwbOVuUSM0zGrd3e0OmR58hv5g+WaLxPr1hL0E4=;
        b=BEVI16aYSyFA4LxADRwe29OjcKy9aogoa1qsjSMpblWxzoVoOa2NRLaEla4JHDagQX
         kKzY8pSEWZetGov2s6lqwWPZrrRAfT3nOq8wHsBzgXqVRC3Q/vracbTY5WgSMpu6sadF
         ykVKUSptfaJ4PvqlNLCiG5nqK+AYA5VhXTGFp/mZwzRQXuBj4EQyh8Ticdb4F6Wz+LA0
         vw31wPaa/hINigX3EJaaMCihL2xw0Td6a4w1QRDy8Kpk2GkMrgwVRRkuDK1jku9810cw
         6snGfUP1YH08rkSXCx3Ij/dJqRE/BiwOGfzSkawW+n0/qBatSLmvYI96qP1z+Klz1bth
         UfEg==
X-Gm-Message-State: AOAM5326KMaAlKaIf7aAiq1iM5mVk7d/zhQDlLqLazjbfQ45pX3csrW1
        8I5aSzn44Tyj8X6ePM9vAE6aspvrNWJkpDlRa0/b7ia09haU
X-Google-Smtp-Source: ABdhPJwxHKu7FuMPwsV3/K93KbzrQVZacplDFFF1AqhALknBpGVJrTL9S9TggZdWzsPWSAJamrYeqbYL7FXnvQQ5smEHI6uIWlTf
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d9e:: with SMTP id h30mr8559944ila.195.1630116678280;
 Fri, 27 Aug 2021 19:11:18 -0700 (PDT)
Date:   Fri, 27 Aug 2021 19:11:18 -0700
In-Reply-To: <0000000000004e5ec705c6318557@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008d2a0005ca951d94@google.com>
Subject: Re: [syzbot] general protection fault in legacy_parse_param
From:   syzbot <syzbot+d1e3b1d92d25abf97943@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        casey@schaufler-ca.com, christian.brauner@ubuntu.com,
        daniel@iogearbox.net, dhowells@redhat.com, dvyukov@google.com,
        jmorris@namei.org, kafai@fb.com, kpsingh@google.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        paul@paul-moore.com, selinux@vger.kernel.org,
        songliubraving@fb.com, stephen.smalley.work@gmail.com,
        syzkaller-bugs@googlegroups.com, tonymarislogistics@yandex.com,
        viro@zeniv.linux.org.uk, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 54261af473be4c5481f6196064445d2945f2bdab
Author: KP Singh <kpsingh@google.com>
Date:   Thu Apr 30 15:52:40 2020 +0000

    security: Fix the default value of fs_context_parse_param hook

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=160c5d75300000
start commit:   77dd11439b86 Merge tag 'drm-fixes-2021-08-27' of git://ano..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=150c5d75300000
console output: https://syzkaller.appspot.com/x/log.txt?x=110c5d75300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2fd902af77ff1e56
dashboard link: https://syzkaller.appspot.com/bug?extid=d1e3b1d92d25abf97943
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126d084d300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16216eb1300000

Reported-by: syzbot+d1e3b1d92d25abf97943@syzkaller.appspotmail.com
Fixes: 54261af473be ("security: Fix the default value of fs_context_parse_param hook")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
