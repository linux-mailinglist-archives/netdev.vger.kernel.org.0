Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C73D91562D6
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 05:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgBHEGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 23:06:03 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:40399 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbgBHEGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 23:06:03 -0500
Received: by mail-il1-f197.google.com with SMTP id m18so1576344ill.7
        for <netdev@vger.kernel.org>; Fri, 07 Feb 2020 20:06:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=YdmzA7D11PRTJN9WOgeGykpVtC5L5hrmQEgxtcYNPyo=;
        b=lIR+uivwIwD1PmoqtCpe1bWYcFcaNIiD6Vq0EEIdi4DwVjetCmXY2vIj+sr1Yt1po5
         0B8qv0jPy1EXtIGC9ndgE6MaOkOlV/SriKPmUUQt+WUvhJkh6LMKTyFxgF5dRRzrywyb
         DU4elNcFTPlMaBJ9j9Cnwdl9rgwEK39DJIsTvcmBB5HI+iUoLBsz1FDqiZN3U05dmr/u
         8SGGVYHUWX911Le27hVErJQtLS0UsDJybl4CjCjXS7OULr1qA6jEyR06He9+ubGwrjah
         UNBPfY5bvoKqDLUOCYm5RTlbH0Thq9RFojLmQmViO1+PyDHdGCSOU5rQI1oWAfApr6VN
         l2yA==
X-Gm-Message-State: APjAAAWng6WCM2KPp2icpkMhzlodQTJCy3+JZEb+1KfqZSxvXiCR1v93
        RnM9Dz0Zzep34eikYOOla2I/Ix8F78ZIWLm9XFJlPNeRLvX7
X-Google-Smtp-Source: APXvYqx6+g7SHOZaaddW/1HIQIDO4JPcYx9LGs3vtbUQW2sQVYO85DabjDjhW9x29TzuvSOjB3EzxFCGFghJ6FpaAZ4nvi+3pD+q
MIME-Version: 1.0
X-Received: by 2002:a6b:92d4:: with SMTP id u203mr1503471iod.288.1581134761739;
 Fri, 07 Feb 2020 20:06:01 -0800 (PST)
Date:   Fri, 07 Feb 2020 20:06:01 -0800
In-Reply-To: <000000000000861441059e047626@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d0cac6059e089f5a@google.com>
Subject: Re: INFO: task hung in tls_sw_cancel_work_tx
From:   syzbot <syzbot+ba431dd9afc3a918981a@syzkaller.appspotmail.com>
To:     airlied@linux.ie, andriin@fb.com, ast@kernel.org,
        aviadye@mellanox.com, borisp@mellanox.com, bpf@vger.kernel.org,
        chris@chris-wilson.co.uk, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, dri-devel@lists.freedesktop.org,
        ilyal@mellanox.com, intel-gfx@lists.freedesktop.org,
        jani.nikula@linux.intel.com, john.fastabend@gmail.com,
        joonas.lahtinen@linux.intel.com, kafai@fb.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rodrigo.vivi@intel.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tvrtko.ursulin@intel.com,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit f75f91574617a3c6fbc821c6b156f5777a59d0ed
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Tue May 15 14:31:49 2018 +0000

    drm/i915: Shrink search list for active timelines

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=121dc6b5e00000
start commit:   90568ecf Merge tag 'kvm-5.6-2' of git://git.kernel.org/pub..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=111dc6b5e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=161dc6b5e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=69fa012479f9a62
dashboard link: https://syzkaller.appspot.com/bug?extid=ba431dd9afc3a918981a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1036b6b5e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1651f6e9e00000

Reported-by: syzbot+ba431dd9afc3a918981a@syzkaller.appspotmail.com
Fixes: f75f91574617 ("drm/i915: Shrink search list for active timelines")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
