Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEA7612797
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 06:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiJ3FlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 01:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiJ3FlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 01:41:18 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9632124E
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 22:41:16 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id y10-20020a5d914a000000b00688fa7b2252so6431902ioq.0
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 22:41:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LMH67DLr37XpWQPukqCW0d3TMkMjMRPPe5mLQsfeTPc=;
        b=aBjxIPbgIrLez8je6tS9lLFB5BFF2HHyxa2AUTENaSFf1qfM8i2Bwwr12THikseaof
         AtHJCb6MswOgY5pkxxtvzDF7cPbsnG4JMrcXnklzsOKqigZC9sm+jfLnnomDmyg5eXsc
         cjkLp3e2aNHg8rJjFFPe2hYVOYmsLYa4MeMq81oXNNOfJwuSbeUVb/Js3vIJZ+Ow0sE6
         I+jon0riSDlh+xkAU0sciGU+fX/q6Lpo5kTT7P50cr20cPwk/h3OGx9DjwEjZj/8AI26
         +zY6m8Ru8Qzg6EdNF3kcvzE8kiylgt0Sz2Tyc2R6Nkgk1iI7c/Y8GIcuGqugHWIrIf5i
         Rq7Q==
X-Gm-Message-State: ACrzQf1i2RpaCaKGWvm+eW+1ZwWbQd56WzL05+Rsl+nzZfavFtGovH4r
        hfpBexsEGQs96FUEbijXDNZa46zCKR2PNy6vV0NYd6tuqlM6
X-Google-Smtp-Source: AMsMyM4Vg/JTXGJ2tlZP/1A9x78LOefhNVYfz+G7wXL5hIJJt/uRM82/OoOhLIQgR8TJN+TmbJzpKwZG0EGK+pa1VLm4ypUCJ96p
MIME-Version: 1.0
X-Received: by 2002:a5d:8913:0:b0:6a4:71b5:8036 with SMTP id
 b19-20020a5d8913000000b006a471b58036mr3521632ion.171.1667108475731; Sat, 29
 Oct 2022 22:41:15 -0700 (PDT)
Date:   Sat, 29 Oct 2022 22:41:15 -0700
In-Reply-To: <20221029161418.2709-1-yin31149@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007fa5c805ec39f00a@google.com>
Subject: Re: [syzbot] memory leak in regulatory_hint_core
From:   syzbot <syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com>
To:     18801353760@163.com, davem@davemloft.net, edumazet@google.com,
        jhs@mojatatu.com, jiri@resnulli.us, johannes@sipsolutions.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com, yin31149@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
SYZFATAL: executor failed NUM times: executor NUM: exit status NUM

2022/10/30 05:33:05 SYZFATAL: executor failed 11 times: executor 0: exit status 67
SYZFAIL: wrong response packet
 (errno 16: Device or resource busy)
loop exited with status 67

SYZFAIL: wrong response packet
 (errno 16: Device or resource busy)
loop exited with status 67


Tested on:

commit:         aae703b0 Merge tag 'for-6.1-rc1-tag' of git://git.kern..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=12e3a3e2880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2f454d7d3b63980
dashboard link: https://syzkaller.appspot.com/bug?extid=232ebdbd36706c965ebf
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10eb44b6880000

