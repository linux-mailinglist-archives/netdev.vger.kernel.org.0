Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B33E61EB1D
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 07:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbiKGGjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 01:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbiKGGjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 01:39:15 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F876576;
        Sun,  6 Nov 2022 22:39:14 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id d20so14691044ljc.12;
        Sun, 06 Nov 2022 22:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YhxHSbVpdxUsgd8PqvbbYUKKhoaOXSotkm3CoyNxy14=;
        b=EYjNnJVCjk8/LdUHzXwZFV0g2SWgE278DLW9zsNC6TTCIBlzwupO9ieIMfGhu7rZ+u
         mWmJd3ruVLfoZRLQy8FwUkNT+BkB6aR1AGU14+6/9E3FSTMAmjDlr4xFHRJSukWwlLit
         bd4FwLRBJ4oRAsEDDWqxFVaKGSjsArqjCu0oA3bCvCrszJsJc9zuk0uKpqhSpHclSWgK
         cbgg6ftj3jrFnrtSRJE8oBEaLbNZeXkScG56D6bLKb1+xHHNRZIXOmaFQoirwSUVxjr8
         Pdk5w0av0n9fD41u5ACOn8A09kTtiQIsycNYp3hCBYNGeSBOt4vDtb4Mo3LKNM0k9tdk
         7sTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YhxHSbVpdxUsgd8PqvbbYUKKhoaOXSotkm3CoyNxy14=;
        b=vVk1ZnC+nYpfU2bVatiP7NL551EfD2UZAvY8Xv/WJPZUyn4Cwl9VogCq/52n2EJvkn
         AhT/yGKtNHUzATlBH64ea9qS9zRyNRvOUeWNdjtq08lHL1IhH4/grh119IbFRU7s8e6Q
         3ItC6L8lyjDN69l97ZEuXxev0yVylhR8+2mGf+coJ91lDlUWBB5laA2zGtMg8vEEUmXh
         o7elYaVPd4ieyshdvshqpvfp95biv6ERYeBxJOouJY1wA/ABEAi/ejMXibgEGcZ1s02z
         vuygHlK3NIgaKpWmtMBjxH8dW0c1hicdB6pcj08nozdSW5o9ink1/SG+l7adiyDTzZeI
         yh8w==
X-Gm-Message-State: ANoB5pn6sJblHUuJ+wMq9LldOJcbyVO9GD1HkBomqMsuVEcpRAXLJ8Iz
        Dq6PWxGW+5oFFRqLrW5w54JHpr/q0IYB4tHqyKw=
X-Google-Smtp-Source: AA0mqf5Jrlncit5ydl+cRhKGZZ8pY+GYr8SjNH41rgGyQ7Dc5I/SyQwZ19aqwveKZ+V9c3D/zRRBJY4HSdGwHOXWvTg=
X-Received: by 2002:a2e:2e12:0:b0:278:acaa:acda with SMTP id
 u18-20020a2e2e12000000b00278acaaacdamr365840lju.305.1667803152130; Sun, 06
 Nov 2022 22:39:12 -0800 (PST)
MIME-Version: 1.0
References: <0000000000000bab2c05e95a81a3@google.com> <000000000000946f3005eca8cafe@google.com>
 <CACT4Y+bX40TE_rx0SFnixoQVd_vHuGih9mtJA4TB7-dDOeguew@mail.gmail.com>
In-Reply-To: <CACT4Y+bX40TE_rx0SFnixoQVd_vHuGih9mtJA4TB7-dDOeguew@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Sun, 6 Nov 2022 22:39:00 -0800
Message-ID: <CABBYNZKyjFE_oVFDMj-U9uSax79bMimUCi1JyGBmyR_ufCNAUw@mail.gmail.com>
Subject: Re: [syzbot] BUG: corrupted list in hci_conn_add_sysfs
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+b30ccad4684cce846cef@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com,
        gregkh@linuxfoundation.org, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.von.dentz@intel.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        rafael@kernel.org, syzkaller-bugs@googlegroups.com,
        yin31149@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Nov 6, 2022 at 3:25 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Fri, 4 Nov 2022 at 10:56, syzbot
> <syzbot+b30ccad4684cce846cef@syzkaller.appspotmail.com> wrote:
> >
> > syzbot suspects this issue was fixed by commit:
> >
> > commit 448a496f760664d3e2e79466aa1787e6abc922b5
> > Author: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> > Date:   Mon Sep 19 17:56:59 2022 +0000
> >
> >     Bluetooth: hci_sysfs: Fix attempting to call device_add multiple times
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1052f8fe880000
> > start commit:   dc164f4fb00a Merge tag 'for-linus-6.0-rc7' of git://git.ke..
> > git tree:       upstream
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=122d7bd4fc8e0ecb
> > dashboard link: https://syzkaller.appspot.com/bug?extid=b30ccad4684cce846cef
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1110db8c880000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13e58aef080000
> >
> > If the result looks correct, please mark the issue as fixed by replying with:
> >
> > #syz fix: Bluetooth: hci_sysfs: Fix attempting to call device_add multiple times
> >
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>
>
> Looks reasonable based on subsystem and the patch:
>
> #syz fix: Bluetooth: hci_sysfs: Fix attempting to call device_add multiple times

Looks like I did add a different link when fixing it:

https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/commit/?id=448a496f760664d3e2e79466aa1787e6abc922b5

Or perhaps they are duplicated?

https://syzkaller.appspot.com/bug?id=da3246e2d33afdb92d66bc166a0934c5b146404a
https://syzkaller.appspot.com/bug?extid=b30ccad4684cce846cef

-- 
Luiz Augusto von Dentz
