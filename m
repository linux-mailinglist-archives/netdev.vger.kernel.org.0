Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5259B11396C
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 02:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbfLEBzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 20:55:01 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:40076 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728374AbfLEBzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 20:55:01 -0500
Received: by mail-io1-f69.google.com with SMTP id d1so1334023ioe.7
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 17:55:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=4FLc7BuR7w3spPKHAoaSawNb5C2SfyMpTNFxv+oG8mk=;
        b=smk7iVES1dWV0VVfn+j3udJMR+5pvGeF2n84l0qTuxbQqjJOqv4JEX9nTL9AiGDNSI
         +zpZATRUo+TZSbxXmDCq6mKREq8Y+iNaVumejCq6B7mRSxSldvOOlsh8mrx6frjmwmZx
         vJlBWUft/fO/KuN22VWuPLfyb6Mu+19EX4/43eD9wIWnM+zWasypvIEB4zrkcDIdFeJr
         uLgvmsh8S5hwpi6nhVueKo/dqAKpFDNCGORnOG5aCiGT/FHzLioNCBlbUJq5g35T9nRw
         Cgmylh+c7LZQmFgukMr45T46QSwj/MVV3eA8/55VolmVyvk+dZIwudvBy+Do7Wq0U5Nu
         n8fQ==
X-Gm-Message-State: APjAAAUCiyGvoMJpHujHEtHGXy/THLVlCXh3pKsujwxOpfxtzfNXgf8i
        B4pWnSrj8bB2V7f4QGGWc4qZzj4S6lEAmlRZPei0OkyQ/Ts8
X-Google-Smtp-Source: APXvYqzjP5/pIC/q5gNc7zKo2jBv47pzxF64WSrgioGICxedl/zZ1B9K/JruZLRezQwWnrssF3NgLpBc60Xng6Z/+9lTWhY+cHrY
MIME-Version: 1.0
X-Received: by 2002:a92:4818:: with SMTP id v24mr6139534ila.96.1575510900571;
 Wed, 04 Dec 2019 17:55:00 -0800 (PST)
Date:   Wed, 04 Dec 2019 17:55:00 -0800
In-Reply-To: <0000000000008399d40598d8a34d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000918b470598eb37b7@google.com>
Subject: Re: KASAN: vmalloc-out-of-bounds Write in pcpu_alloc
From:   syzbot <syzbot+59b7daa4315e07a994f1@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andriin@fb.com, aryabinin@virtuozzo.com,
        ast@kernel.org, bpf@vger.kernel.org, christophe.leroy@c-s.fr,
        daniel@iogearbox.net, dja@axtens.net, dvyukov@google.com,
        glider@google.com, gor@linux.ibm.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 0609ae011deb41c9629b7f5fd626dfa1ac9d16b0
Author: Daniel Axtens <dja@axtens.net>
Date:   Sun Dec 1 01:55:00 2019 +0000

     x86/kasan: support KASAN_VMALLOC

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10c70f36e00000
start commit:   b3c424eb sch_cake: Add missing NLA policy entry TCA_CAKE_S..
git tree:       bpf
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12c70f36e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14c70f36e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7d8ab2e0e09c2a82
dashboard link: https://syzkaller.appspot.com/bug?extid=59b7daa4315e07a994f1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=140df641e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147dcc2ae00000

Reported-by: syzbot+59b7daa4315e07a994f1@syzkaller.appspotmail.com
Fixes: 0609ae011deb ("x86/kasan: support KASAN_VMALLOC")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
