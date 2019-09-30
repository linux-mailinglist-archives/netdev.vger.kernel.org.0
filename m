Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD2EC1F90
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 12:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbfI3KxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 06:53:02 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:56835 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729094AbfI3KxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 06:53:01 -0400
Received: by mail-io1-f70.google.com with SMTP id a22so29221229ioq.23
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 03:53:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=hI5UiabcxF02JCdIXhKz7T8NGcvRDQ9zry7wX/9b2Wg=;
        b=mYI2lMbDvL2F590qyaSWrRKuIDrBKd/p+B0SA3vB+aYeuO/gZ1DoQYG7ne+Ktmxzl9
         tiDRmHQsBPD1xWiHwQibA0a/l+d85uc0dvHOt8BtRlMFOrRKK1zfNQgJP7LCaoIkvBsv
         9DJPjg5eqJoCyZghndlRY01Vl39xhZybc/dtoTn3frdU3dTA7ikfO3/LK1Yo0pqfOYAJ
         bs9MAx55EEWBmRjxKsg1/F0jW3vOZ1OZuHlraTy2WHWLSlnHE1XbnHW0lxRyYJ25wSxq
         o8b6Tx1yj3P/b6FQuvWAYX+3CL/17n2w6weeFEtvwZIYmB1PwD3bwUwbPIlJ/PrR5RO0
         1oDw==
X-Gm-Message-State: APjAAAVvTTMAVDI2YjFjljsVQ6xkVN2O9igT+2lt5lbl638MWHAWOg6b
        2xXvgDMuEy2uwhAFX0sijJxC/oFE5AFE3jULWDpvKWWdEzxj
X-Google-Smtp-Source: APXvYqxRYokbmnvyKs8m43W2eYhxiwwUbwWy13gugzMDjSun9tKIic+MOKtsA0/QDSj4eyEqMzAj3mnJOFEjdYOCIauwyEoJD8+B
MIME-Version: 1.0
X-Received: by 2002:a92:c0d2:: with SMTP id t18mr20022479ilf.239.1569840781088;
 Mon, 30 Sep 2019 03:53:01 -0700 (PDT)
Date:   Mon, 30 Sep 2019 03:53:01 -0700
In-Reply-To: <00000000000084fb070593bff0fb@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001c5e810593c30a8c@google.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in xsk_poll
From:   syzbot <syzbot+a5765ed8cdb1cca4d249@syzkaller.appspotmail.com>
To:     ast@kernel.org, bjorn.topel@intel.com, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        jonathan.lemon@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, maximmi@mellanox.com,
        netdev@vger.kernel.org, saeedm@mellanox.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tariqt@mellanox.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 77cd0d7b3f257fd0e3096b4fdcff1a7d38e99e10
Author: Magnus Karlsson <magnus.karlsson@intel.com>
Date:   Wed Aug 14 07:27:17 2019 +0000

     xsk: add support for need_wakeup flag in AF_XDP rings

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17848acd600000
start commit:   a3c0e7b1 Merge tag 'libnvdimm-fixes-5.4-rc1' of git://git...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14448acd600000
console output: https://syzkaller.appspot.com/x/log.txt?x=10448acd600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6ffbfa7e4a36190f
dashboard link: https://syzkaller.appspot.com/bug?extid=a5765ed8cdb1cca4d249
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1096d835600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=129f15f3600000

Reported-by: syzbot+a5765ed8cdb1cca4d249@syzkaller.appspotmail.com
Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP  
rings")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
