Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 075F937F81
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbfFFV0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:26:02 -0400
Received: from mail-it1-f197.google.com ([209.85.166.197]:59301 "EHLO
        mail-it1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728163AbfFFV0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:26:01 -0400
Received: by mail-it1-f197.google.com with SMTP id l193so86455ita.8
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 14:26:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=8FLsmzT5fuRYDlPRpXfsHV8R+x45zmFIlbaKQu+jQrU=;
        b=W5p7tfl9wtBguvUiON0MdKAl4aXnImzfxieHzAQeiDJGQ0fF4MPCFzw9ZYlR2W65Yf
         HqYs+eH4bHAcOTwmKButDEJZxJp+02UPfV0QqiZt/BbhSnqu5cmv/sLEDov5cR1OA4Fv
         63MWLHIoL4wrvsWi6KWacRJIPqdyMyywYyik2bU1GtOZiDlmrF4EMC0HONe+Zd6gWwpT
         UZCv3YXZNaf4K/BHIngGO07hbjRWikPlsEhZKpTv1kP2r0AeJB6J2FUV7clvW6xMa+js
         N80DayxrzB4ci6nOnLyd3JYEet9+FL0hVE1HLDdRt5QWSpKkC4iygnKgzgdRAQDU1akY
         nRLw==
X-Gm-Message-State: APjAAAVQHdYgFNMYqZGc/NiTsUYaziCxQZGwIjTT1k9bshnY90vZQLvx
        4spGGNoEwxmtwHPGcdBdcH20aPgI3G2vq1NOAqUBPxyah0kT
X-Google-Smtp-Source: APXvYqxl7JOalyt2i6XIsXn7vQ0MIDr2sMsgZJhOcVtzOU7sAoQq0Rfvs8Y/n2P0+sXCktgx3+s7D4eQfn486z0A1OdlZGHlD5Za
MIME-Version: 1.0
X-Received: by 2002:a6b:1488:: with SMTP id 130mr29049755iou.304.1559856360982;
 Thu, 06 Jun 2019 14:26:00 -0700 (PDT)
Date:   Thu, 06 Jun 2019 14:26:00 -0700
In-Reply-To: <0000000000004945f1058aa80556@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004c11d6058aae5c30@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in corrupted (2)
From:   syzbot <syzbot+9a901acbc447313bfe3e@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, ast@kernel.org, cai@lca.pw,
        crecklin@redhat.com, daniel@iogearbox.net, dvyukov@google.com,
        john.fastabend@gmail.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit d40b0116c94bd8fc2b63aae35ce8e66bb53bba42
Author: Daniel Borkmann <daniel@iogearbox.net>
Date:   Thu Aug 16 19:49:08 2018 +0000

     bpf, sockmap: fix leakage of smap_psock_map_entry

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1137e90ea00000
start commit:   156c0591 Merge tag 'linux-kselftest-5.2-rc4' of git://git...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1337e90ea00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1537e90ea00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=60564cb52ab29d5b
dashboard link: https://syzkaller.appspot.com/bug?extid=9a901acbc447313bfe3e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11a4b01ea00000

Reported-by: syzbot+9a901acbc447313bfe3e@syzkaller.appspotmail.com
Fixes: d40b0116c94b ("bpf, sockmap: fix leakage of smap_psock_map_entry")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
