Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1FF6C7AEF
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbjCXJNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbjCXJNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:13:33 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101391EFCA
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:13:32 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id a21-20020a5d9595000000b0074c9dc19e16so789071ioo.15
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:13:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679649211;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QExb/T1F8/XoorTxuEKbTqt2ECV6VnSe+3ISxG21XUQ=;
        b=3FqF3FyY3xF/v8IMMFf5qJ0S5IS9f+bg9uCXxUl+PZAIffbOPA3F4mRCNjbwV9HEmo
         c55+Xd8uUXONBpKmnogWZJPNR9nByCIlgBpz83CHb6fYTxbU71oxr0A+Yvi75/5dKdFC
         Y/JmbpAAfDn2UXr48uPMmcJ7OOcuxwLv/0blariShmhr1h6jhyM75LbekldjLf+ccZ5U
         mrCGnN2/UVIHzmWtSH0illbgjQFHkqPJrbNYjO5QbjiU8SEMPq6/kpLO93/5ibLjwfXE
         6Kukr7G1Xr2riNHWH9k5Ffz8ymFlSPDdBlQ5qBibOB+5A7osvsj0SV+oAH98SdQWDzhQ
         kB6A==
X-Gm-Message-State: AO0yUKX2gdGHbm8RbNhH6/RzJ2l+4wVlQKjF3WMCNm7BRE4Q93c+aCBi
        5rM4QCYR32CiaA7iR5P36+tVEp5W/h4oxhKFgUZP3xufslOA
X-Google-Smtp-Source: AK7set+u9V3h/lFnpss+6vSzDvV1hDPTiWdu/52VHEtBts1JBVTxyLHO1pbJZyyllLB5e3fSkCqgmE/v2lcGcZ6C+6WU1l4vDvHu
MIME-Version: 1.0
X-Received: by 2002:a02:a189:0:b0:3c5:14cb:a83a with SMTP id
 n9-20020a02a189000000b003c514cba83amr639266jah.2.1679649211430; Fri, 24 Mar
 2023 02:13:31 -0700 (PDT)
Date:   Fri, 24 Mar 2023 02:13:31 -0700
In-Reply-To: <CAGxU2F7XjdKgdKwfZMT-sdJ+JK10p_2zNdaQeGBwm3jpEe1Xaw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000098457705f7a1ce42@google.com>
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in virtio_transport_purge_skbs
From:   syzbot <syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com>
To:     avkrasnov@sberdevices.ru, bobby.eshleman@bytedance.com,
        bobby.eshleman@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, oxffffaa@gmail.com, pabeni@redhat.com,
        sgarzare@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file net/vmw_vsock/vsock_loopback.c
patch: **** unexpected end of file in patch



Tested on:

commit:         fff5a5e7 Merge tag 'for-linus' of git://git.armlinux.o..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
dashboard link: https://syzkaller.appspot.com/bug?extid=befff0a9536049e7902e
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16b4bba1c80000

