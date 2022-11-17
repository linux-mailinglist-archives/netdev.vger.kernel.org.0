Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E28762CFC6
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 01:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbiKQAeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 19:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiKQAeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 19:34:18 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BF8DE9A
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 16:34:16 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id j7-20020a056e02154700b003025b3c0ea3so227998ilu.10
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 16:34:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C7fpKRtzxmuZr+pixes1vS//11B89ShTFWKOGGoP3bY=;
        b=0+2Wapp5pds42DaAfSXCbh6nePrsJ26gm+39Y3e4HTrX+LJ4qahh6P7Mvf1UIITKLm
         xZyEzHtwa1t9ymnb5VfG86/+ACh+ACL1UHwii8wGvI6sgKlDLAIh2a3WMf6IfbSNtAIx
         xxqpeczhhHJ91p5SAi4LMbjxjxCGD6RpCpoLCBsPt7IiDhjFRv63ggWFEwxDTLSRwt/j
         gVEembsuJT30kvGHr/BrPDD9l7yIbt7Gqwo/dCbO4bov5FwSrjNPN1kMM4kdQ/ldtVCt
         AhFKO1ZHSZZMHqsojKdFxU7ITfgKyt0IDQG0oNynLEgdPWQ7swj4gnVB2ffdFaFuWaLP
         iR2Q==
X-Gm-Message-State: ANoB5pl67H72r5dlxq+kimxG5Kymt4Al6bYoqbf2DUJEe1b+uje5/l1c
        s6Z1MgnCaZj+LqL2OfQDW7bf0yKQgQF8P9SYDDfB7PaBNuO4
X-Google-Smtp-Source: AA0mqf5Fv/E/JgjNAnqCkyuAiMmMi01LvbjF2o+YeCzfvfXdDg1r0D/72ROyAB0i/hDxy2hmfUqb6clFk0u135HlVI/OLpTGyQtn
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1918:b0:375:4dbf:6ca4 with SMTP id
 p24-20020a056638191800b003754dbf6ca4mr11160143jal.315.1668645256039; Wed, 16
 Nov 2022 16:34:16 -0800 (PST)
Date:   Wed, 16 Nov 2022 16:34:16 -0800
In-Reply-To: <00000000000058983805ed944512@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000be110905ed9fbf49@google.com>
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in nci_send_cmd
From:   syzbot <syzbot+4adf5ff0f6e6876c6a81@syzkaller.appspotmail.com>
To:     bongsu.jeon@samsung.com, clement.perrochaud@nxp.com,
        davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org,
        kylin.formalin@gmail.com, linma@zju.edu.cn,
        linux-kernel@vger.kernel.org, michael.thalmeier@hale.at,
        netdev@vger.kernel.org, pabeni@redhat.com, r.baldyga@samsung.com,
        robert.dolca@intel.com, sameo@linux.intel.com, shikha.singh@st.com,
        syzkaller-bugs@googlegroups.com, thierry.escande@linux.intel.com
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

commit e624e6c3e777fb3dfed036b9da4d433aee3608a5
Author: Bongsu Jeon <bongsu.jeon@samsung.com>
Date:   Wed Jan 27 13:08:28 2021 +0000

    nfc: Add a virtual nci device driver

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1338e6e9880000
start commit:   81e7cfa3a9eb Merge tag 'erofs-for-6.1-rc6-fixes' of git://..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10b8e6e9880000
console output: https://syzkaller.appspot.com/x/log.txt?x=1738e6e9880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a2318f9a4fc31ad
dashboard link: https://syzkaller.appspot.com/bug?extid=4adf5ff0f6e6876c6a81
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f435be880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1134d295880000

Reported-by: syzbot+4adf5ff0f6e6876c6a81@syzkaller.appspotmail.com
Fixes: e624e6c3e777 ("nfc: Add a virtual nci device driver")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
