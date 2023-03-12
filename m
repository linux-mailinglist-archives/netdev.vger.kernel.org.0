Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B26D6B6BF2
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 23:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbjCLW12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 18:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjCLW11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 18:27:27 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C802B9EF
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 15:27:23 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id q8-20020a92ca48000000b00320ed437f04so5517512ilo.19
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 15:27:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678660043;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B5fqhJIjpirLrsA3xG4o21nLBL/g/rnnNghPQIsHEss=;
        b=lW0142jlMQOCW3ExPvSqvx7FUkZrxyQ+JufszPplDK2KeR3/aGAwlYk6cGfxEb1Ayu
         r8qBjh0jIL+NAOBKWUll689IVXyQsm4t7Fy7OHm0slSVSgWokfASGo2c8u9356vID+8v
         ixge3vAJCvD9cDz12kGwotPl4gFYV6iVsQ3n2KYR1jhD4T4VYzVp0+sYEe2s4oYhNXx1
         tGdztq/fi4nZOPuMlu5VUVdikqX0ybrxEsXzvirfo4mU0ZehvW0/wYIbq+/zJaVSTpSK
         ZvFmBfXodbXzxb30aajZT30j/uoKEsTKOWOoS7g5cEX+ZaZ34J2xRmFdX9spgnoYcADx
         CHNA==
X-Gm-Message-State: AO0yUKVz2SOwg1Ibe4/G/wQ5yaS85iePhoFFLRsYB1TydsvGiw8EuZWJ
        fXJ0S6w282jds92MiRu0ZhjiXhbuUidn1uN7lo105jnxOrtL
X-Google-Smtp-Source: AK7set8RxLuX+r2WrfitVnbkOx83kJ8KZ5ejK4b9706CYKAUI3x7/QchSBcyPABxjAwH8lZan3Cy80i9r6cBgLW5xqLjJhOXbqqH
MIME-Version: 1.0
X-Received: by 2002:a5e:8e49:0:b0:745:a851:1619 with SMTP id
 r9-20020a5e8e49000000b00745a8511619mr14614913ioo.3.1678660042917; Sun, 12 Mar
 2023 15:27:22 -0700 (PDT)
Date:   Sun, 12 Mar 2023 15:27:22 -0700
In-Reply-To: <000000000000a798f305ef2aeed9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008e918105f6bb7ff2@google.com>
Subject: Re: [syzbot] [net?] KASAN: use-after-free Write in
 l2tp_tunnel_del_work (2)
From:   syzbot <syzbot+57d48d64daabde805330@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, hdanton@sina.com,
        jakub@cloudflare.com, jiri@nvidia.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

syzbot suspects this issue was fixed by commit:

commit d772781964415c63759572b917e21c4f7ec08d9f
Author: Jakub Kicinski <kuba@kernel.org>
Date:   Fri Jan 6 06:33:54 2023 +0000

    devlink: bump the instance index directly when iterating

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12e69652c80000
start commit:   355479c70a48 Merge tag 'efi-fixes-for-v6.1-4' of git://git..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=cc4b2e0a8e8a8366
dashboard link: https://syzkaller.appspot.com/bug?extid=57d48d64daabde805330
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1731caf3880000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: devlink: bump the instance index directly when iterating

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
