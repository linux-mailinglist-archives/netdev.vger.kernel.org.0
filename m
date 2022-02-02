Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB0E4A7350
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 15:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344906AbiBBOgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 09:36:10 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:33322 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiBBOgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 09:36:10 -0500
Received: by mail-il1-f197.google.com with SMTP id h9-20020a92d849000000b002bc4b7993fbso6129224ilq.0
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 06:36:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Eymh4pHURRqeuFwS8adn0p8QhOCEykcqbl9dEc138NY=;
        b=AhJC5FpocAJaIwELrCmRaomDt+HQZbU9ZaY8BCR3tChipzWrPhrVnkk8isqNkW5kzB
         RJVhs55ht8DTvsrRjEYn7twniD/Hi5Zwuvo4/E+TGn2WMx+nLvvlKdPBcEZXFSpEQp0I
         pZg47EVJ3DN57C8ZNX2omgB+TVp+zaX18NuVjoVY/0DD7L0AZH+R5VFul85rHw2ynhUC
         sdOvZYVa3VLEEDVrlmuZwsbFomk61kylZwDpXyoN+NcgZU1Vv0OQWvPlnwM2GHd182jn
         b05Y1S617Leh0wqKZuVrfKYwGtnUla4SA8YornVQwco4hygUfz4qyrUOe0+fNQYxNvP3
         +/2w==
X-Gm-Message-State: AOAM531SmiLhOcM+3bfeI5eC+BOL0lcylIY1ZJOtmmamftPcX9iPYldp
        s/zZsS6UaZ53TVE95O70nd2ljf2a/y+SL8dJ2jjRqr0UcuEX
X-Google-Smtp-Source: ABdhPJwGogskVKanVKmmmO1deCNQWTYAR4unUVwG5nX2dggT73jsD2XxfgJcLs4y20Iwprc8IHZ1DEukzWl+iHfMi84JlWn5xHSa
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2e90:: with SMTP id m16mr16733470iow.74.1643812569793;
 Wed, 02 Feb 2022 06:36:09 -0800 (PST)
Date:   Wed, 02 Feb 2022 06:36:09 -0800
In-Reply-To: <0000000000000a9b7d05d6ee565f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004cc7f905d709f0f6@google.com>
Subject: Re: [syzbot] KASAN: vmalloc-out-of-bounds Write in ringbuf_map_alloc
From:   syzbot <syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, elver@google.com,
        glider@google.com, hotforest@gmail.com, houtao1@huawei.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, sfr@canb.auug.org.au,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit c34cdf846c1298de1c0f7fbe04820fe96c45068c
Author: Andrey Konovalov <andreyknvl@google.com>
Date:   Wed Feb 2 01:04:27 2022 +0000

    kasan, vmalloc: unpoison VM_ALLOC pages after mapping

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=128cb900700000
start commit:   6abab1b81b65 Add linux-next specific files for 20220202
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=118cb900700000
console output: https://syzkaller.appspot.com/x/log.txt?x=168cb900700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8d8750556896349
dashboard link: https://syzkaller.appspot.com/bug?extid=5ad567a418794b9b5983
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1450d9f0700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=130ef35bb00000

Reported-by: syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com
Fixes: c34cdf846c12 ("kasan, vmalloc: unpoison VM_ALLOC pages after mapping")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
