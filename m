Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAF1635726
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 08:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfFEGrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 02:47:02 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:38806 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfFEGrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 02:47:01 -0400
Received: by mail-io1-f72.google.com with SMTP id h4so9103716iol.5
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 23:47:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=0DTPebv5NG8S97eb6NYfGtH6s2XhZbJcgpOSN9G3WRc=;
        b=fKAak/vqgbACwxPEZRjJU+Vaa53PKwleq18KKhwmfhqnLJQZo02K0Ds4kSoSOXZG2Q
         fjTLdc/sBo79c710QycFFq4tc7VxNdGEGJh2IaqXsNPnGNaUPokgP2Jm5I5u26m9iXbh
         59g4JxQWfUQRBg24jS19mYp2gRnIbfxTCcxPsfxqb6gLSOOPyqBAUopru+/5IJW/6KvY
         CESOtCqvdaPjkSJkrSpiOKukGCDhapACv4tClTwtP92gtiQL60ZS+d6VI/02ha8oJLYB
         yZfzdAwcbmKBngoN3ZaUl2Qj6p1RGS1QxVl/REKdr0jvfOML6vUX1M2KRo9vdgUmcLVo
         oDJw==
X-Gm-Message-State: APjAAAXYbWCk5BnjlsaOpJh+pglRBs1wFGY5Wp1jWPTCd1iG1bPuKmKu
        3T858afYX72iKb/69Dk1gFYjxzb1aBU5zL+YQ9w4KH0DfMwE
X-Google-Smtp-Source: APXvYqxcRwKznu5s/WF30ioOt1OAX+adyD0fCRP3X69hk9R87NnszpPYpCAzlAXH7mBu0a2hct/HG73f5mTEx1ANoDYrvg/aI0Iv
MIME-Version: 1.0
X-Received: by 2002:a24:2b8f:: with SMTP id h137mr7710740ita.162.1559717221001;
 Tue, 04 Jun 2019 23:47:01 -0700 (PDT)
Date:   Tue, 04 Jun 2019 23:47:00 -0700
In-Reply-To: <00000000000097025d058a7fd785@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e878a9058a8df684@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in css_task_iter_advance
From:   syzbot <syzbot+9343b7623bc03dc680c1@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org,
        daniel@iogearbox.net, hannes@cmpxchg.org, kafai@fb.com,
        linux-kernel@vger.kernel.org, lizefan@huawei.com,
        netdev@vger.kernel.org, oleg@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tj@kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit b636fd38dc40113f853337a7d2a6885ad23b8811
Author: Tejun Heo <tj@kernel.org>
Date:   Fri May 31 17:38:58 2019 +0000

     cgroup: Implement css_task_iter_skip()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1256fcd2a00000
start commit:   56b697c6 Add linux-next specific files for 20190604
git tree:       linux-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1156fcd2a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1656fcd2a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4248d6bc70076f7d
dashboard link: https://syzkaller.appspot.com/bug?extid=9343b7623bc03dc680c1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=102ab292a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15f0e27ca00000

Reported-by: syzbot+9343b7623bc03dc680c1@syzkaller.appspotmail.com
Fixes: b636fd38dc40 ("cgroup: Implement css_task_iter_skip()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
