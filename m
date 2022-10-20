Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7010A60557A
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 04:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiJTC0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 22:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiJTC0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 22:26:04 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB2618709F;
        Wed, 19 Oct 2022 19:26:02 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-1324e7a1284so22965643fac.10;
        Wed, 19 Oct 2022 19:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ptk7zp6IkNleKHwHubY4igTNtlfyPoJ7FlT7dwYbRpE=;
        b=ezD3a5Fd9yGQ/piZ2pLJk3QbPgGRKagMalO7MF/AUHHEJfm5Foc7OYjlBuLY2rfZxY
         ts3GvbEoDwi1+LnJq/fjt/g5GMo9i6CG4RhyQFnZrAorGusidNYI86UwOhs6Ia76rUAb
         hWlxPUgUaHikNAnwninh8ok3pzwhnM2NhTS0jX3xVttEyYwQGQgFpeudsF76VupgknoO
         nX0z9iBPNpy4dBasZoMIQyblxfc4O9tkZM20jtwDoN15MqU8kV4ffoJFOlA7q8C51gV1
         Y3+H0kF2QjqnauwbHGqIXx35z12tbzR54j6SsajLheQkWOZI8F2RwvehxNvFlQnDBD5g
         lhFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ptk7zp6IkNleKHwHubY4igTNtlfyPoJ7FlT7dwYbRpE=;
        b=6yQ/bNctDcfbKFoJ7O0bPHVFwDCa9EYHHs4ZF5WTNNbfHLwfb8GoZ6KPv9f2rBUUIW
         jul+UJZ/hPtE+wwbUhMJwnXoO13dQC7FjXWADEOlxukiJfu9Zaw+TSA/AoBdXWlU5c3+
         cWEUIMvK6XbtuFoumKcNKVwRiHgsqr957TZgm0uTTkSmVopOoFpXzWwoFY9hluLHmLiY
         Hf6JFVS3a9lWvn9tb16fS3chXciqyFzngWJahiyFDv0A9kdAAIFStq5VHXwwYQeTwRRt
         nTcV9DNrrO7GD1c3rVQTYLN+ltEBBJ/LI8/506HHsxBHXhguzq5SKk3ghN5aLsWfd13I
         4Mag==
X-Gm-Message-State: ACrzQf1UdVOicnb8DSD43B7DYqcWEuExkHbjGMasGYcjIKXP6M2f/lTz
        e6I3iUsq2EQq2hXCh667ppYKxajG6uNNMxSD1yU=
X-Google-Smtp-Source: AMsMyM57Fz6tHcq5MZql+TypZ7KQEoKOaPjePV9B4MTL02bhHuSjL9ZgU5qNUGaRzXlTJJCj+hcRayFE3TDmvBHXdkI=
X-Received: by 2002:a05:6870:523:b0:131:2d50:e09c with SMTP id
 j35-20020a056870052300b001312d50e09cmr24409054oao.129.1666232762024; Wed, 19
 Oct 2022 19:26:02 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000044139d05eb617b1c@google.com> <20221019153018.2ca0580d@kernel.org>
In-Reply-To: <20221019153018.2ca0580d@kernel.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 19 Oct 2022 22:25:47 -0400
Message-ID: <CADvbK_cXfDVFJ-eo-+uqXXPT1Xt7qf4bg0Cu6U5Zg7TCLeqoUw@mail.gmail.com>
Subject: Re: [syzbot] general protection fault in pse_prepare_data
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     syzbot <syzbot+81c4b4bbba6eea2cfcae@syzkaller.appspotmail.com>,
        andrew@lunn.ch, bagasdotme@gmail.com, davem@davemloft.net,
        edumazet@google.com, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, lkp@intel.com, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 6:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 19 Oct 2022 04:26:35 -0700 syzbot wrote:
> > HEAD commit:    55be6084c8e0 Merge tag 'timers-core-2022-10-05' of git://g..
> > git tree:       upstream
> > console+strace: https://syzkaller.appspot.com/x/log.txt?x=140d5a2c880000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=df75278aabf0681a
> > dashboard link: https://syzkaller.appspot.com/bug?extid=81c4b4bbba6eea2cfcae
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13470244880000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=146e88b4880000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/9d967e5d91fa/disk-55be6084.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/9a8cffcbc089/vmlinux-55be6084.xz
> >
> > Bisection is inconclusive: the first bad commit could be any of:
> >
> > 331834898f2b Merge branch 'add-generic-pse-support'
> > 66741b4e94ca net: pse-pd: add regulator based PSE driver
> > 2a4187f4406e once: rename _SLOW to _SLEEPABLE
> > f05dfdaf567a dt-bindings: net: pse-dt: add bindings for regulator based PoDL PSE controller
> > 18ff0bcda6d1 ethtool: add interface to interact with Ethernet Power Equipment
> > e52f7c1ddf3e Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
> > 681bf011b9b5 eth: pse: add missing static inlines
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11fc42b4880000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+81c4b4bbba6eea2cfcae@syzkaller.appspotmail.com
> >
> > general protection fault, probably for non-canonical address 0xdffffc0000000008: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: null-ptr-deref in range [0x0000000000000040-0x0000000000000047]
> > CPU: 1 PID: 3609 Comm: syz-executor227 Not tainted 6.0.0-syzkaller-09589-g55be6084c8e0 #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
> > RIP: 0010:pse_prepare_data+0x66/0x1e0 net/ethtool/pse-pd.c:67
>
> Yeah, looking at ethtool internals - info can be NULL :(
It seems that eeprom_prepare_data() doesn't check info before
accessing info->extack either.


>
> For reasons I haven't quite grasped yet myself we use a different
> structure for info on do and dump which makes getting to extack in
> generic code inconvenient.
