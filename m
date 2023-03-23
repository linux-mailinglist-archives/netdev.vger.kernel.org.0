Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F372B6C7294
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 22:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjCWVvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 17:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjCWVvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 17:51:15 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D78CE181;
        Thu, 23 Mar 2023 14:51:14 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id i7so125147ybt.0;
        Thu, 23 Mar 2023 14:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679608273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vWGzwKfmQ8YcB4xPR2K7LbYdFkNoBqkDdULTLqBuFYc=;
        b=MCEdKoRgX+p2BO+yFR8tXTiCMW2HmyOXC1tYXjvTQzSlDMFUw+COGfN03fD6g6j5W4
         9lRt6BdrQCGusPH3bQeBo5pFfi5uhDRYSLSsNuLHgGH129nBwBfX/bXUE/Pj7IvfMoZQ
         CH92IsoGwE+jB26ap7gyjsUPry6KQAeZbgfwSrJStDl8VYzZZjl4uEeulFx0c7q6wyVB
         Bxm/UCPBuXt/4tfhpaip13R4XLh5bX5gWebaW1ZhES4YIZvBaCBw/k/jxB9v14P6tkC7
         RQmo5AZY6lE9/ZZGhIjyISKVV+myO9aTpuF0ryTjWFM3sehGJjsybErRoFdIAIF0NCzr
         ufdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679608273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vWGzwKfmQ8YcB4xPR2K7LbYdFkNoBqkDdULTLqBuFYc=;
        b=GiQWej17+zlsiJIz12leRmVVuEdaKVgfJsRD9W1VajuXRO5R4y/glW/gjYy78KG5lH
         ALcdytRf0JabUDXQT8vhrBX383di7Q5N/ESVkMr6BUHiZD1juejF7ea86dhUtqDl9CHt
         oVBHL260G5rhfqJ4ExL9W7aeUJCa1UhXsdF5hpoxaXGSJVaMHafrDvNuQl9zPmdFHyay
         J/HfkVzjB/H8dmqWgJ7AGNhwknn1SUMvrg71vOm8OI6GIRaXBs/duVxXP6yUTPtbJK6B
         mLsvR2jaFaaQqxB1FvogTKSjWpTwzdf0xxvNn+IC0+PYTqxfZ/VRA0d3djCn0K4WjjwM
         6ZqA==
X-Gm-Message-State: AAQBX9dpAc8RdDPikB/tKDamKLfQQAHX+akYTRlhC3yG0m/JZ4703cnR
        5OxAQbeGEP/RYw+nKNkpPeLsi7zCSDRjp0UHILo=
X-Google-Smtp-Source: AKy350ZQnmm1RgM4DIQsZatmx62Fkd8K2kQHe7Puo4INe2mLhOpukfbp8mHPhKG5AQxc+/FsMNZFS57RLClRHE+v8Sw=
X-Received: by 2002:a25:c78f:0:b0:b31:34ab:5ca0 with SMTP id
 w137-20020a25c78f000000b00b3134ab5ca0mr16303ybe.11.1679608273214; Thu, 23 Mar
 2023 14:51:13 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000e03bc805f78683cd@google.com>
In-Reply-To: <000000000000e03bc805f78683cd@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 23 Mar 2023 17:50:34 -0400
Message-ID: <CADvbK_e5+Ujn+yyATPEjqwT0TG6KEJrU9CvWk7VC3Hfz-m2ykQ@mail.gmail.com>
Subject: Re: [syzbot] [sctp?] general protection fault in sctp_outq_tail
To:     syzbot <syzbot+47c24ca20a2fa01f082e@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 8:39=E2=80=AFPM syzbot
<syzbot+47c24ca20a2fa01f082e@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    cdd28833100c net: microchip: sparx5: fix deletion of exis=
t..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1588fe92c8000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dcab35c936731a=
347
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D47c24ca20a2fa01=
f082e
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binuti=
ls for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D15d80ff4c80=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D17f6e90ac8000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/2fb6257d1131/dis=
k-cdd28833.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/a3025d79117c/vmlinu=
x-cdd28833.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/8e6d670a5fed/b=
zImage-cdd28833.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+47c24ca20a2fa01f082e@syzkaller.appspotmail.com
>
> general protection fault, probably for non-canonical address 0xdffffc0000=
000007: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000038-0x000000000000003f]
> CPU: 1 PID: 5783 Comm: syz-executor825 Not tainted 6.2.0-syzkaller-12889-=
gcdd28833100c #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 03/02/2023
> RIP: 0010:list_add_tail include/linux/list.h:102 [inline]
> RIP: 0010:sctp_outq_tail_data net/sctp/outqueue.c:91 [inline]
The null-ptr-deref is 'SCTP_SO(&q->asoc->stream, stream)->ext' in
sctp_outq_tail_data(). It should be set in sctp_sendmsg_to_asoc(),
unless the out stream got shrunk by:

  sctp_stream_update() -> sctp_stream_outq_migrate() ->
sctp_stream_shrink_out().

When sending msgs on a closed association, it will first do handshakes.
During the handshake, send more data with a big stream_num N until the
tx buffer is full and the sending is waiting for more buffer, then
after the handshakes are over and the big stream N is freed during the
handshakes(which may happen when peer doesn't support so many streams),
and the sending waiting for the tx buffer will try to enqueue data on a
freed out stream, then this issue occurred.

I will confirm this and give a fix.

Thanks.
