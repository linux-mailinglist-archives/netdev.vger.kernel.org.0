Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97260D8E00
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 12:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392471AbfJPKet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 06:34:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41078 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390389AbfJPKes (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 06:34:48 -0400
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B2AE63680A
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 10:34:48 +0000 (UTC)
Received: by mail-lf1-f70.google.com with SMTP id o9so4670199lfd.7
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 03:34:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=SgWpfY5Xz4zDxp0MpMcVzJx2JBdy4PlhQXGqbdLqW1c=;
        b=nB1VpxMLVZ/SbyoszGWJ9E13BKBK6pKSf3psGkj1JmnPbNWDJXF4oeuLZ8rnFeKF3s
         icNP8JcTA1N8Gu+yvYvAKPT1fZXr3GoPuuaOdADR+jWsJrd0xxhlpQJ5zhnzWuXdDNSP
         /MorkPG9msAwYEkkknt7yO7grxhHOeT1Q7mHCFu2augKPJhnq+SS+0YiUnoziyW1Vw74
         PSeJgXKjCU82820GNDEepIeJ2GR3aMTVKi2iXF6XNJpsRP1nhNQCSH3ry2/aVE05WL5+
         ZOg7WEkWw0lYzaoPT8p7kPQaX1tv68og1lzDc8/qBxoWzprM6J6Ozqbd7HVn5bprAmHI
         YzxQ==
X-Gm-Message-State: APjAAAVJoXiJtIsUxXtA2xIXYag9/wNAFxoLcJcJe7PtynfKdpggLCSD
        lAtv7BayQkKyTXOXdSbTvkzUuVEzKYwqcta8dPdq8O1DYgoejnXLdC50J7AZP9jZmhsABam7i4S
        QeU8gSlrJIwtH9+OH
X-Received: by 2002:a2e:8908:: with SMTP id d8mr25165959lji.197.1571222087131;
        Wed, 16 Oct 2019 03:34:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx4XYHDPAfrBOTyCsdEH7wCjKz6XyRUDaC+zt/SS3g8SNH7/oIXHGkUSk//39pfT1paBIYsMQ==
X-Received: by 2002:a2e:8908:: with SMTP id d8mr25165952lji.197.1571222086968;
        Wed, 16 Oct 2019 03:34:46 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id v1sm6234517lfq.89.2019.10.16.03.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 03:34:45 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 174401800F4; Wed, 16 Oct 2019 12:34:45 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>,
        ddstreet@ieee.org, Dmitry Vyukov <dvyukov@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: unregister_netdevice: waiting for DEV to become free (2)
In-Reply-To: <CAADnVQJ7BZMVSt9on4updWrWsFWq6b5J1qEGwTdGYV+BLqH7tg@mail.gmail.com>
References: <00000000000056268e05737dcb95@google.com> <0000000000007d22100573d66078@google.com> <063a57ba-7723-6513-043e-ee99c5797271@I-love.SAKURA.ne.jp> <CAADnVQJ7BZMVSt9on4updWrWsFWq6b5J1qEGwTdGYV+BLqH7tg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 16 Oct 2019 12:34:45 +0200
Message-ID: <87imopgere.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Fri, Oct 11, 2019 at 3:15 AM Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
>>
>> Hello.
>>
>> I noticed that syzbot is reporting that refcount incremented by bpf(BPF_MAP_UPDATE_ELEM)
>> syscall is not decremented when unregister_netdevice() is called. Is this a BPF bug?
>
> Jesper, Toke,
> please take a look.

Yeah, that unregister notification handler definitely looks broken for
hashmaps; I'll send a patch :)

-Toke
