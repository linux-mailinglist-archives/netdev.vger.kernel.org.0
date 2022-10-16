Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002B6600278
	for <lists+netdev@lfdr.de>; Sun, 16 Oct 2022 19:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiJPReb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 13:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiJPRe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 13:34:26 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8672513CCC
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 10:34:24 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id 23-20020a5d9c57000000b006bbd963e8adso5671041iof.19
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 10:34:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9HnUcMrpaOy4ZoL5ypHWvjmoyr0LqAIz7W4hYAK2fiI=;
        b=fA1yI+mYUQ+mOWOuoQtTLrkSz+b8+R5e5o7Nb2KFoW9o10THvZ/hM9FSBR0OszPVwM
         pE7l+LDCc9qnbvdH5bQ0vE01tJSR5Zf5sNiGYNEjWBFUBYisArX60kIwpurFkeHj2Emw
         rm0uVUxfZUNW3CrVmN+svumBMtZfNCCambWl6LJSzRT0eVuYDDRHAkpc4uhvV0JTx2iX
         POXjiVZ8XKuJrSmJthmyhN4IU02hD1ebfvXEVfNkzHY8Tl+/J29UGc5LMuY7kQq16ZOZ
         2NEEW6lCwiqNn5jNMXRess0xuv6Z2uW0UbxwWjptTIV628yAVoWO7dVIuwfcXVpbe3ns
         Mv9w==
X-Gm-Message-State: ACrzQf0xQZ2c3e6/svRGgKOZZ9Zu5LG+s5OQypEHdv0WJKb9GjBlhzur
        MkEjHQ6KyOtGO6JX07HqQwDseqGHgo37+n4jQAt1s32QTZ3W
X-Google-Smtp-Source: AMsMyM7qspteAsrK5Mgq3OaCHRR/wYcZjGnfTnfsk7GdfkdP3jG+nm1SS/vzaXgUf0BQGOpO5QgR8XlS8g1zTVGBw7BHfTVjcerF
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:184c:b0:2fc:4f65:9dee with SMTP id
 b12-20020a056e02184c00b002fc4f659deemr3194230ilv.154.1665941663602; Sun, 16
 Oct 2022 10:34:23 -0700 (PDT)
Date:   Sun, 16 Oct 2022 10:34:23 -0700
In-Reply-To: <0000000000009d327505b0999237@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000013612005eb2a4525@google.com>
Subject: Re: [syzbot] INFO: rcu detected stall in batadv_nc_worker (3)
From:   syzbot <syzbot+69904c3b4a09e8fa2e1b@syzkaller.appspotmail.com>
To:     a@unstable.cc, alsa-devel@alsa-project.org,
        b.a.t.m.a.n@lists.open-mesh.org, broonie@kernel.org,
        davem@davemloft.net, dvyukov@google.com, edumazet@google.com,
        hdanton@sina.com, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        pabeni@redhat.com, perex@perex.cz, povik+lin@cutebit.org,
        steve@sk2.org, sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        tiwai@suse.com, tonymarislogistics@yandex.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit f8a4018c826fde6137425bbdbe524d5973feb173
Author: Mark Brown <broonie@kernel.org>
Date:   Thu Jun 2 13:53:04 2022 +0000

    ASoC: tas2770: Use modern ASoC DAI format terminology

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=164d4978880000
start commit:   55be6084c8e0 Merge tag 'timers-core-2022-10-05' of git://g..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=154d4978880000
console output: https://syzkaller.appspot.com/x/log.txt?x=114d4978880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=df75278aabf0681a
dashboard link: https://syzkaller.appspot.com/bug?extid=69904c3b4a09e8fa2e1b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16e2e478880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=149ca17c880000

Reported-by: syzbot+69904c3b4a09e8fa2e1b@syzkaller.appspotmail.com
Fixes: f8a4018c826f ("ASoC: tas2770: Use modern ASoC DAI format terminology")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
