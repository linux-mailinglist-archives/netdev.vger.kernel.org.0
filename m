Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDF661761F
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 06:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiKCF0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 01:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiKCF0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 01:26:22 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DBE18B0C
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 22:26:18 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id f17-20020a5d8591000000b006bcbe59b6cdso459716ioj.14
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 22:26:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hubE5cXRc9JuQCcqWhxOGTFZ206SuvXNuCleiqfj7l0=;
        b=lWh9OUxFKBiJCG4rCxhDlLz912e0w+RX10PsFS37hTctTFL3Km0EPjgUKn+L2NGSwK
         ihFhCryolB+y7czj2QBsyTFhtQSsJn4cFq5ZaeSVGgOKJ5mc3er2zPCP+SGN2hh6ckf/
         bR0Nl/XIpBCiuFltmf22r1nK7es/INhuX87oxGGlxqCrokemrBDpMJEHV2XmsTsNMyln
         zHggs49r/+iTIauU/9LCJBGl8NR4CD239h/CjIUHclDMU8IFwMhOp9WQvyRgp2IzGzDc
         wKCiA/GxgEe7lGnkLZAiNnooW+RMl00sTEzkSpToisBJd/bXZA0L/i92h0kOo9Okzddp
         1e/g==
X-Gm-Message-State: ACrzQf1RpKASo71039MUurThwtQQU0J42FF1gUs4Pfvvh20l7MJdvieQ
        Ts16OAMmhd/WuMNmziQToDstpoBGRs3V8C7hbbR55itsyb/k
X-Google-Smtp-Source: AMsMyM7M+gbJ9p2WjkZ9tsLPHEN9g++/Bo3XU4yPT5uBfhfhLwrxINRWSCpGkuwwLFqDERYuy5PPDkBauLfSwc6aEbOSjHRRHa64
MIME-Version: 1.0
X-Received: by 2002:a92:cc49:0:b0:300:d9d7:fe36 with SMTP id
 t9-20020a92cc49000000b00300d9d7fe36mr860359ilq.225.1667453177891; Wed, 02 Nov
 2022 22:26:17 -0700 (PDT)
Date:   Wed, 02 Nov 2022 22:26:17 -0700
In-Reply-To: <000000000000e9df4305ec7a3fc7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005912d405ec8a329c@google.com>
Subject: Re: [syzbot] WARNING in __perf_event_overflow
From:   syzbot <syzbot+589d998651a580e6135d@syzkaller.appspotmail.com>
To:     acme@kernel.org, alex.williamson@redhat.com,
        alexander.shishkin@linux.intel.com, bpf@vger.kernel.org,
        cohuck@redhat.com, dvyukov@google.com, elver@google.com,
        jgg@ziepe.ca, jolsa@kernel.org, kevin.tian@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
        peterz@infradead.org, shameerali.kolothum.thodi@huawei.com,
        syzkaller-bugs@googlegroups.com, yishaih@nvidia.com
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

syzbot has bisected this issue to:

commit c1d050b0d169fd60c8acef157db53bd4e3141799
Author: Yishai Hadas <yishaih@nvidia.com>
Date:   Thu Sep 8 18:34:45 2022 +0000

    vfio/mlx5: Create and destroy page tracker object

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=136eb2da880000
start commit:   88619e77b33d net: stmmac: rk3588: Allow multiple gmac cont..
git tree:       bpf
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10eeb2da880000
console output: https://syzkaller.appspot.com/x/log.txt?x=176eb2da880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a66c6c673fb555e8
dashboard link: https://syzkaller.appspot.com/bug?extid=589d998651a580e6135d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11eabcea880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f7e632880000

Reported-by: syzbot+589d998651a580e6135d@syzkaller.appspotmail.com
Fixes: c1d050b0d169 ("vfio/mlx5: Create and destroy page tracker object")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
