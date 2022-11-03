Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929BB6177AC
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 08:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiKCH11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 03:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiKCH1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 03:27:24 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3384155BD
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 00:27:24 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id b16so1263280yba.2
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 00:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6ly+G7+lyR2tgEVR1WMOK4EJ7N76yR8l41oUG1sHf9c=;
        b=HrG2x4rNnb4SGZ4hQdH5OcFnrmKg4dnJ93AURRjRRNhh/t7Y5qGudWyzIHd8YDrtRa
         DObcY/k3auLnQaAuraUBk82c/Wwpwgm+xk3l17J96W+F+acGu6yV4gei0zhQOC6O1R66
         jWQaf1lExl1/9VVnmXSbJd4WpqqqIQie3+Sb9B1i/CyD6+momFmz2mYCMI3q094loyli
         fDWk0RkkWEFNieHjdo73T4VNq71CAzD832G+/goGZxI/efxl9R7TGepZrtRN27fMHIo+
         ZzcRFBpXAgam+vl+RSjHaefBGv00Mty/1OPE66QJwQdW65lYDVJhg3AsZ3zAOZMB9XAh
         t/Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6ly+G7+lyR2tgEVR1WMOK4EJ7N76yR8l41oUG1sHf9c=;
        b=EJ1v9sbO3pPD8Gzgv1XLaocBHa5Oe3Usz4EOsFjIx98R/22t/o50fk649uDExLGLp7
         rd3SU+K5kHvJfqY5oF7mQtjP22lzNKFaI7eYr3lKAbCQHwzVwHatIVAjDSz2leyr/y3L
         AfC0aWLy5W80LFzXOPd0hqo+bNuZpsAQ4WqROM3Tid2X7pjdpFM/Z9OTcZRsP7RX7KEY
         YfGw1m5mO0vg/+eyfiDGAC6lCdZQmIMETWYRPblk920PNGGp9K+PpeD7Q9iODDDYcuNT
         JQDqXi8+lGfN9u4pYKAAaMM9XWEfHBupAbO7w+xts4PxewlXupueqZe/XQ510KjBoGrx
         JXqw==
X-Gm-Message-State: ACrzQf3YljO0QbPngtZIphyWQM3ziMQwHEgKhvHUSy3/8f/crRpaxjZw
        mjx5QlNgRDleTI2bKrt0GuILIJzhR26UUb2bq6D3kQ==
X-Google-Smtp-Source: AMsMyM707h3+vIMmk1iKOcN3+xAYZCYrZqaa6FBSFeXjdm/4+xJAoqfaOX6vvY2T22hmyCyRhvlXxzQ+GytACfWctBk=
X-Received: by 2002:a25:7b42:0:b0:6ca:1d03:2254 with SMTP id
 w63-20020a257b42000000b006ca1d032254mr26098678ybc.584.1667460443279; Thu, 03
 Nov 2022 00:27:23 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000e9df4305ec7a3fc7@google.com> <0000000000005912d405ec8a329c@google.com>
In-Reply-To: <0000000000005912d405ec8a329c@google.com>
From:   Marco Elver <elver@google.com>
Date:   Thu, 3 Nov 2022 08:26:47 +0100
Message-ID: <CANpmjNNwjCWa0TX4CYShB5KrErWEd-z0BgpZTrpofnJNx-MkvA@mail.gmail.com>
Subject: Re: [syzbot] WARNING in __perf_event_overflow
To:     syzbot <syzbot+589d998651a580e6135d@syzkaller.appspotmail.com>
Cc:     acme@kernel.org, alex.williamson@redhat.com,
        alexander.shishkin@linux.intel.com, bpf@vger.kernel.org,
        cohuck@redhat.com, dvyukov@google.com, jgg@ziepe.ca,
        jolsa@kernel.org, kevin.tian@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
        shameerali.kolothum.thodi@huawei.com,
        syzkaller-bugs@googlegroups.com, yishaih@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Nov 2022 at 06:26, syzbot
<syzbot+589d998651a580e6135d@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this issue to:
>
> commit c1d050b0d169fd60c8acef157db53bd4e3141799
> Author: Yishai Hadas <yishaih@nvidia.com>
> Date:   Thu Sep 8 18:34:45 2022 +0000
>
>     vfio/mlx5: Create and destroy page tracker object
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=136eb2da880000
> start commit:   88619e77b33d net: stmmac: rk3588: Allow multiple gmac cont..
> git tree:       bpf
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=10eeb2da880000
> console output: https://syzkaller.appspot.com/x/log.txt?x=176eb2da880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a66c6c673fb555e8
> dashboard link: https://syzkaller.appspot.com/bug?extid=589d998651a580e6135d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11eabcea880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f7e632880000
>
> Reported-by: syzbot+589d998651a580e6135d@syzkaller.appspotmail.com
> Fixes: c1d050b0d169 ("vfio/mlx5: Create and destroy page tracker object")
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

The bisection is wrong - see
https://lore.kernel.org/all/20221031093513.3032814-1-elver@google.com/
