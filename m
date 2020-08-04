Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370BC23B49B
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 07:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgHDFxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 01:53:06 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:47045 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728603AbgHDFxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 01:53:06 -0400
Received: by mail-io1-f70.google.com with SMTP id n1so15040016ion.13
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 22:53:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=BRdtTRPOEaQKBrhbJMVyVg8f+gg0wNhNpfaLQFbDwIc=;
        b=XVn82etSQGntUrlYmTNSkWXRVmTTZoj9X+EaUua1uzzqGEiypVrl9xEJkT1Ys4x0O8
         XeBsJPA4Ve6zXHH2z1Ad7skr0O6QoVw06BLvRMM9Phg3rid6tHKr8ot6a0Sp5u72leIA
         06c0cKXobTiHFBjt7+p5VI5f1Obf2VcDmBYOCMif0WnpcQ4WbDIdTV/gfm52hVqH7nZp
         /dF0T1U7v1w9XtFN60El0phEOiIXZp4v2e/MmQfuk93Qxwrg+xSmEcBwmIcuNIT3NX0K
         jhKmDzAqhrObGA5/fGX1UsvPXVn2V67pfdN3UFv6SROhGV4pYPuVycEyp9ZzssdruCo1
         7tuA==
X-Gm-Message-State: AOAM532uPWR/HaBK7xv1svBMgB/BcF3lERrXhYLoVrFmBN133rKC3RWk
        MgY4Zdcy0gDVebprlDKXNxamqeN3KBxaIPPsHMSVIQX0A/x/
X-Google-Smtp-Source: ABdhPJzEkoMCbnNdFUe97FE5HM517BQ0ax1yAE9KKbwZVWX1mKbnq4Vi7DM1AkTvDXzbANiqrkZroxhk4raf2RYgrw3J8jVZ61+P
MIME-Version: 1.0
X-Received: by 2002:a6b:e216:: with SMTP id z22mr3305588ioc.97.1596520385235;
 Mon, 03 Aug 2020 22:53:05 -0700 (PDT)
Date:   Mon, 03 Aug 2020 22:53:05 -0700
In-Reply-To: <0000000000003d6e8405abeb1da7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000070529b05ac06deaa@google.com>
Subject: Re: KASAN: use-after-free Read in hci_send_acl
From:   syzbot <syzbot+98228e7407314d2d4ba2@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, mareklindner@neomailbox.ch,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 4ffcd582301bd020b1f9d00c55473af305ec19b5
Author: Michael Chan <michael.chan@broadcom.com>
Date:   Mon Sep 19 07:58:07 2016 +0000

    bnxt_en: Pad TX packets below 52 bytes.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=167b0f04900000
start commit:   ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=157b0f04900000
console output: https://syzkaller.appspot.com/x/log.txt?x=117b0f04900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c0cfcf935bcc94d2
dashboard link: https://syzkaller.appspot.com/bug?extid=98228e7407314d2d4ba2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=152f1904900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1482dfca900000

Reported-by: syzbot+98228e7407314d2d4ba2@syzkaller.appspotmail.com
Fixes: 4ffcd582301b ("bnxt_en: Pad TX packets below 52 bytes.")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
