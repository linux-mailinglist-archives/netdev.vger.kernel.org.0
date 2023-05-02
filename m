Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0A76F3FC1
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 11:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbjEBJDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 05:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbjEBJDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 05:03:43 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA6E30C6
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 02:03:41 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-32f4e0f42a7so53095ab.1
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 02:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683018221; x=1685610221;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NKVfIlBvsYHMWDxi0uBcvmDgbiWUYMz6a+J28iJYmJA=;
        b=2ad2cOPQIGv+I5wDpt6S7LzAQBXSlVZJ+z6YhICzmFlUutg4zMkL7TI279sxH540G8
         H+P7CZUZpNY1va1AxKMtQw6bX607072FfV/9Tx0qXqIiZKWOvuYFAgV53OPKsvvNOjSw
         sjB4CPq+byYze/jaktc2S/yGEZprfGz0ENy9in4n5OXSwYe01FnroZwhSHXilCTjBBZT
         nnCyYjkvLmrJfvnxmxtlDZmJAvXWoxrwT5vzAoqf5b6Rc1DkLGFMeMrmeO1I8cl9xlyH
         +zahBxiZp7+eCu1P3hgE4IO2jKqatDPLmAIL1S05RXMfmQ23FFFC/0stZWr4f+gdGk0l
         EXAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683018221; x=1685610221;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NKVfIlBvsYHMWDxi0uBcvmDgbiWUYMz6a+J28iJYmJA=;
        b=QHJiiH3ULWzscNeTF6iD7Tpz+feUhRJC+YGBsEUmxcVOmKS6UcXCPDXX19x/Lg18gm
         jxoaCl408vqXlWqune7MK8Vd0jMIPO8I78bICNnWMdEPYGBLK+NPqCBMnX2an1tlK7p3
         hxEt/furVVbS+0YrZo8SmAH+3bVNtH4lmUJNjoPghGIFtOpMiyc4Bv4dYZFzO6XIWKMf
         FV/3MbDD638Lo7rlci/Ii6BwWKT+4DWGbjf27N2wZ6dXCQJEd6m4/7J2+eMou9qMSyQ4
         La0emOJwFKSWS6FNYntwZ+Tsxv+yIznpGkC7EIJo3iPNA21d+Y+hGiUSAZEqGGfQ0Gof
         lp5g==
X-Gm-Message-State: AC+VfDwbMkndjAtH8KpFzy/vw+12JXAp+xQBMNjXVcuaAED1WZxM7p49
        Vnoy5wihM/Yrvu76iRZOBOpnAHa6xdDRQ7C81L8jmQ==
X-Google-Smtp-Source: ACHHUZ747jLD/GDpZ0wLuJpv/ONcTgaCC5dR/I/K0IsHqe5jU64l+X+v7KsS7HlXQ828WToieUmI/aWMNaqocZ39qVc=
X-Received: by 2002:a05:6e02:1e06:b0:32b:7232:dac6 with SMTP id
 g6-20020a056e021e0600b0032b7232dac6mr231658ila.18.1683018220705; Tue, 02 May
 2023 02:03:40 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000002e8a7c05fa9e1a7a@google.com> <bdb29f17-dac3-20a3-c726-963259b95208@gmail.com>
In-Reply-To: <bdb29f17-dac3-20a3-c726-963259b95208@gmail.com>
From:   Aleksandr Nogikh <nogikh@google.com>
Date:   Tue, 2 May 2023 11:03:29 +0200
Message-ID: <CANp29Y6UGNweLS7kDx+nji9z2hUi8wXVfioKwpYftQmE4ueJZQ@mail.gmail.com>
Subject: Re: [syzbot] Monthly wireguard report (Apr 2023)
To:     "J.F. Samuels - K2CIB" <radiowhiz@gmail.com>
Cc:     syzbot <syzbot+listded2f47f5f1d416c4059@syzkaller.appspotmail.com>,
        Jason@zx2c4.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello John,

Do you mean only these monthly reports or all messages from the mailing lis=
ts?

You received this specific email because you're subscribed to one of
the following lists:

linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
wireguard@lists.zx2c4.com (the email was also sent to
syzkaller-bugs@googlegroups.com, but you're not a member of it -- I've
just checked).

You could determine the exact one by looking at the "Mailing-list"
header in the raw message.

--
Aleksandr

On Mon, May 1, 2023 at 5:56=E2=80=AFPM J.F. Samuels - K2CIB <radiowhiz@gmai=
l.com> wrote:
>
> I don't know how I subscribed to this - wish I knew enough to be of help!
>
> Please unsubscribe me from all related lists.
>
> Thanks,
>
> John
>
>
>
> On 5/1/2023 5:03 AM, syzbot wrote:
>
> Hello wireguard maintainers/developers,
>
> This is a 31-day syzbot report for the wireguard subsystem.
> All related reports/information can be found at:
> https://syzkaller.appspot.com/upstream/s/wireguard
>
> During the period, 1 new issues were detected and 0 were fixed.
> In total, 4 issues are still open and 13 have been fixed so far.
>
> Some of the still happening issues:
>
> Ref Crashes Repro Title
> <1> 620     No    KCSAN: data-race in wg_packet_send_staged_packets / wg_=
packet_send_staged_packets (3)
>                   https://syzkaller.appspot.com/bug?extid=3D6ba34f16b98fe=
40daef1
> <2> 440     No    KCSAN: data-race in wg_packet_decrypt_worker / wg_packe=
t_rx_poll (2)
>                   https://syzkaller.appspot.com/bug?extid=3Dd1de830e4ecda=
ac83d89
> <3> 6       No    KASAN: slab-use-after-free Write in enqueue_timer
>                   https://syzkaller.appspot.com/bug?extid=3Dc2775460db0e1=
c70018e
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> To disable reminders for individual bugs, reply with the following comman=
d:
> #syz set <Ref> no-reminders
>
> To change bug's subsystems, reply with:
> #syz set <Ref> subsystems: new-subsystem
>
> You may send multiple commands in a single email message.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller-bugs/bdb29f17-dac3-20a3-c726-963259b95208%40gmail.com.
