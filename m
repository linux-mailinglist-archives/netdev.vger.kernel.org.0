Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECEC69A7D7
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 10:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjBQJIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 04:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjBQJII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 04:08:08 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B03D2312A
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 01:08:04 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id y29so586434lfj.12
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 01:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RfM9Fm775FO73C4wq1PJTu9P8Vkzy8ULI4Ab5a8Ncz4=;
        b=PpPviwI3lHGXFLyM+OCt/++fXra1E0J05s5U/fcdr08Y0XkoOVP3hrENhdZ/uoAnD1
         Qvtbacp72jK5eDHcJoMsqXEJAgQi93Zo7tAqA5y1wfGeNjT/TJ0xRIciWS2A9rP2XkCh
         autPK0vENymMB3y+w+dqFjbymwE9dmF37ZYyhxW7dS+ANQLNUiifASCucLlD/vxovVtQ
         tLhfHr1TPEaoBlD2hMaCa5/aciMnIHOr3CKbSR4xnvc3/ycxrMJhvB3GreKX/YfPWgLx
         T+WvpoH5iHq0c5sCWxrY4xND4g6orlaIE2u1HqtR2kVStJ5lFvuh82LJEbqS0fxYPsNT
         nLMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RfM9Fm775FO73C4wq1PJTu9P8Vkzy8ULI4Ab5a8Ncz4=;
        b=dmFBhzDQlVYNM5vonbOq65Hi/9psem6D7LAK0UAgw15m+cORqKtd13zl0k5CUkBqzR
         hmO3I8+MMHYpTBHuyLOciF9nLkhXxbSaiHNHIgXdP7ID2we3MONGjodMKky4J4RNTe+E
         MRMNTfei2TFyok3JpjHlF/vMyTLNJN4R19yUP1iBjFycE8XnOeXgRnjkpTrGQOrrId6T
         +8GuV3mzZcNu1Wkvfiryd4ynqJ0sah7LwdTiWHmvqI/Z7K0ewk6J5UaUqeIE7dNX4O6t
         h+BeS6qhRH+zGl9jyaZF4ltwk52pXOD7hLiBuuq5naLBe6ScTW7MqCYz3PpOls6+LiuO
         48eg==
X-Gm-Message-State: AO0yUKUQrAj5h9QS8LA0JU71/es9ZIKYoyphhgNnC5Dg7Fwunt5vgrRt
        frvDejaeRqAJras/flkNONLjkuYtVA/ILUisw/sOtg==
X-Google-Smtp-Source: AK7set/4XkQNdaAe4juXUDARpBPnyKXe78wBAY2YzuOE/A0ZQDzokcKXJzjKwJtPJ8vrz5dWcR52RIDxD36P4Agq0j4=
X-Received: by 2002:ac2:5313:0:b0:4db:1a0d:f261 with SMTP id
 c19-20020ac25313000000b004db1a0df261mr139533lfh.3.1676624882118; Fri, 17 Feb
 2023 01:08:02 -0800 (PST)
MIME-Version: 1.0
References: <000000000000035bbc05f4ce4501@google.com> <CACT4Y+YzZb2vscjBLiJ-p-ghbu77o851gbESfE=nZebXqfgE4g@mail.gmail.com>
In-Reply-To: <CACT4Y+YzZb2vscjBLiJ-p-ghbu77o851gbESfE=nZebXqfgE4g@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 17 Feb 2023 10:07:50 +0100
Message-ID: <CACT4Y+arK9hQ=aov0z-ciX8=KRmcLhGec--KWAwoMx7wfcnmsw@mail.gmail.com>
Subject: Re: [syzbot] WARNING: stack going in the wrong direction? at __sys_setsockopt
To:     syzbot <syzbot+91c3651bb190d53b4d16@syzkaller.appspotmail.com>,
        jpoimboe@kernel.org, Ingo Molnar <mingo@kernel.org>
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com, syzkaller-bugs@googlegroups.com
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

On Thu, 16 Feb 2023 at 11:04, Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Thu, 16 Feb 2023 at 11:00, syzbot
> <syzbot+91c3651bb190d53b4d16@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    9d9019bcea1a Add linux-next specific files for 20230215
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11ad7710c80000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=60f48e09dc64b527
> > dashboard link: https://syzkaller.appspot.com/bug?extid=91c3651bb190d53b4d16
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/7a22fa9fb779/disk-9d9019bc.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/68851ce42fd7/vmlinux-9d9019bc.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/09be0a2c410b/bzImage-9d9019bc.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+91c3651bb190d53b4d16@syzkaller.appspotmail.com
> >
> > WARNING: stack going in the wrong direction? at __sys_setsockopt+0x2c6/0x5b0 net/socket.c:2271
>
> +Josh, Ingo,
>
> Yesterday we started seeing lots of "stack going in the wrong
> direction" all over the kernel.
>
> I see there is only your recent commit to ORC unwinder:
> "x86/unwind/orc: Add 'signal' field to ORC metadata"
>
> Can it be related?

#syz fix: objtool: Fix ORC 'signal' propagation
