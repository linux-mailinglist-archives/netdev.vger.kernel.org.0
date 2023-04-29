Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE3A6F270D
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 00:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbjD2Wyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 18:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbjD2Wya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 18:54:30 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF7AE7A
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 15:54:29 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-32b4607696aso17077135ab.1
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 15:54:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682808869; x=1685400869;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EIRWs04g8ZoJm6CieeH8gXHcikugX3NlQwgnDthdPx4=;
        b=IyPdxmepW3N+IjGH3ks1bnLMP1D/7ilazk3b32B+wQZnOgMN8L0n22VmLBPgd73Nch
         SisNREiOmYxLgrk75pjGb7HUJOy0kAyxNkMxqZWxC1d7kNiZQd3BqmXjlnUSIHcjx8t0
         wv5qM4Dd9Dqbet2ESSXDgJxx1QiViEjeUqBJiS/xJeUzEmLT69OntjiXtqbukIdHFXen
         ODhLpSFsiY2Wa8MSVZ62wDudxufo5O/mUjr7A2/QttHGIsiM3Ns8OlUa30cwGsnzdqWo
         6434CBxykMLltLFUIlH7ufsZ8S12hjJezsIEk7TP06mbeUdabVX/Bvqp13D+L/0tbi1M
         elzw==
X-Gm-Message-State: AC+VfDwjd9froXMq1v1BOtbBPCnUdjW8XR33tFt3hgjfnZ0YKf/Fl/sl
        gl7j10ULlF4miv+MP1oPhhnKWn3mW0uExxyQt5UQ2KOwT4ii
X-Google-Smtp-Source: ACHHUZ6q6tCAObTqNYFe4Z3JPgMW55/a5SUlKQk4uTbKCrGAa2NrKDNpA9gPZsRW4lxFJkTX4gtvpVthncvAeVqUeKrgA4Q8lHgM
MIME-Version: 1.0
X-Received: by 2002:a92:c9cb:0:b0:32f:8970:2a66 with SMTP id
 k11-20020a92c9cb000000b0032f89702a66mr1248583ilq.4.1682808868929; Sat, 29 Apr
 2023 15:54:28 -0700 (PDT)
Date:   Sat, 29 Apr 2023 15:54:28 -0700
In-Reply-To: <000000000000e5ee7305f0f975e8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000db8c6605fa8178df@google.com>
Subject: Re: [syzbot] [net?] WARNING in print_bfs_bug (2)
From:   syzbot <syzbot+630f83b42d801d922b8b@syzkaller.appspotmail.com>
To:     broonie@kernel.org, davem@davemloft.net, edumazet@google.com,
        groeck@chromium.org, jiri@resnulli.us, kuba@kernel.org,
        linmq006@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        tzungbi@kernel.org, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 0a034d93ee929a9ea89f3fa5f1d8492435b9ee6e
Author: Miaoqian Lin <linmq006@gmail.com>
Date:   Fri Jun 3 13:10:43 2022 +0000

    ASoC: cros_ec_codec: Fix refcount leak in cros_ec_codec_platform_probe

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13d40608280000
start commit:   042334a8d424 atlantic:hw_atl2:hw_atl2_utils_fw: Remove unn..
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10340608280000
console output: https://syzkaller.appspot.com/x/log.txt?x=17d40608280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7205cdba522fe4bc
dashboard link: https://syzkaller.appspot.com/bug?extid=630f83b42d801d922b8b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=147328f8280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1665151c280000

Reported-by: syzbot+630f83b42d801d922b8b@syzkaller.appspotmail.com
Fixes: 0a034d93ee92 ("ASoC: cros_ec_codec: Fix refcount leak in cros_ec_codec_platform_probe")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
