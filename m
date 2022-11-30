Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7FE663D1E0
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 10:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbiK3Jao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 04:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233717AbiK3Jaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 04:30:39 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E2D5288E
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 01:30:34 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id p10-20020a9d76ca000000b0066d6c6bce58so10818969otl.7
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 01:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R4rzBLqhzVqPs1XSyOBs4RGvyvY1FfP4xPQ3lsEfP18=;
        b=iMUzv2B7vFyq9U1/isf6Pi1o7iYQUzvRZhXiCx0m7fjsv0OZIM/rgTKGUIprpPDiwt
         6es3AiQLEn0Eyq8eYSUaooE1EIPchFNwCAp1GXDjvAVQhDL/Mezo9WGsvpOTdtOP/r4d
         by8yMPFqzrH6vTDszQhha/s37IsgPg6tymT1oI5QNzxu1KfFmHe6Eawa/H16xel8GlqQ
         sHKH81DBMTCf08iXirB9CH/KuZgqBpuETFnRg9mbkkYj5r8slLTqzHU3iEhHbYk8nJTa
         E9xIdJ+lqe+uV1ibrz4jcF8HHQu/vt6EtV6vH6U7t1Pv6N4EJlBablbdbKOrXNznirvO
         h2Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R4rzBLqhzVqPs1XSyOBs4RGvyvY1FfP4xPQ3lsEfP18=;
        b=TujCK0d7gogzXsfi1S/6g79EzvwYFEkVO9GIjWbJrjHAWwNSqVSXlFWD8JvEl/gBfH
         FqR2ekVKGnZmlKosSj8eWLRACDpkalxDZzsr2+MVhk0YsGaI/tffdlUBFSOLmBH6JziU
         p/x7huzdDi/cEs3WgxXici/hddkG3x8vyZhO3MY0I7L5I5ZC1xrlqyhGw6T3OYWRe+ta
         +4bpOHv+jFsIDveEzWwGJlstf1tir3gOdeXv7CMWS5hH3Ot+neqPus0QMRiYShR+Y5tx
         vOW9xE/A7CE7lJhXl8rI357RcEbQ5dNNvrOwSpw8nP7W+cMvx1O9EDLCa34CO/zMpaKS
         itpw==
X-Gm-Message-State: ANoB5plPJyS+BpoWg0TI1k48sWl+Q4sEi1qt7IfrMOFl69F+3CYBC1eX
        tp9Bjrv7YtkfcnzJ0ufCJNvc//N98Suqo10gP7PVyg==
X-Google-Smtp-Source: AA0mqf7oYsFX939hyA25HvmNwprF22fZ6uf7xPd+W+NVMtlfg4wpNHuCTToXuhoYz0V0nBNWuOy1fgn9WDK5D3dk7Kg=
X-Received: by 2002:a05:6830:1b62:b0:66c:7982:2d45 with SMTP id
 d2-20020a0568301b6200b0066c79822d45mr19894908ote.123.1669800633226; Wed, 30
 Nov 2022 01:30:33 -0800 (PST)
MIME-Version: 1.0
References: <00000000000058983805ed944512@google.com> <000000000000be110905ed9fbf49@google.com>
In-Reply-To: <000000000000be110905ed9fbf49@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 30 Nov 2022 10:30:22 +0100
Message-ID: <CACT4Y+bjbJ4z_FbWednxQe=0J5m37f1v5yjDH4zDfQVgw1EWFA@mail.gmail.com>
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in nci_send_cmd
To:     syzbot <syzbot+4adf5ff0f6e6876c6a81@syzkaller.appspotmail.com>,
        =?UTF-8?B?6ams6bqf?= <kylin.formalin@gmail.com>,
        bongsu.jeon@samsung.com
Cc:     clement.perrochaud@nxp.com, krzysztof.kozlowski@linaro.org,
        linma@zju.edu.cn, linux-kernel@vger.kernel.org,
        michael.thalmeier@hale.at, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Nov 2022 at 01:34, syzbot
<syzbot+4adf5ff0f6e6876c6a81@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this issue to:
>
> commit e624e6c3e777fb3dfed036b9da4d433aee3608a5
> Author: Bongsu Jeon <bongsu.jeon@samsung.com>
> Date:   Wed Jan 27 13:08:28 2021 +0000
>
>     nfc: Add a virtual nci device driver
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1338e6e9880000
> start commit:   81e7cfa3a9eb Merge tag 'erofs-for-6.1-rc6-fixes' of git://..
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=10b8e6e9880000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1738e6e9880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a2318f9a4fc31ad
> dashboard link: https://syzkaller.appspot.com/bug?extid=4adf5ff0f6e6876c6a81
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f435be880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1134d295880000
>
> Reported-by: syzbot+4adf5ff0f6e6876c6a81@syzkaller.appspotmail.com
> Fixes: e624e6c3e777 ("nfc: Add a virtual nci device driver")
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz dup: WARNING in nci_send_cmd
