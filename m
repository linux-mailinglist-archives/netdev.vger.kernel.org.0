Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA0A012BC68
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 04:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfL1DQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 22:16:02 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:33083 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbfL1DQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 22:16:02 -0500
Received: by mail-il1-f198.google.com with SMTP id s9so1163052ilk.0
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 19:16:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=tENWWAE27YTP2yqe1cfIcG9EDWGCKbHOtQOZmBsBGGY=;
        b=OQbv+jGYpDaOPTLUvQrAPPz+vaS5NafgELY9aAnoSLyLq6BQnXJCUC6T0UfBit37Il
         CZfNTxVm1DZaGY85OnDYUrjrCfKt3w8S10/e6aLwvjKzOExi87hN3EQiG9KHlTxVm0vs
         vRbwvIa+ogIYy87ZDkXE420TLdEJvGpvdEqj7HRqkib+dpOWb1InBuOL1BhowumrFseb
         n2LwGBQI9EvD2RQtY37ZAGnF0Wp2ZqkDRqRdZGePjgZvH+cquy8vrv1kni9CbpVXoUo1
         nRkxEl2jOuXAzwBEs334q3Pe4DSUZeh0/vovPoi0oUOuI0wYmLAxL2tdWQxV7hvBz60E
         3OaQ==
X-Gm-Message-State: APjAAAUfOpjbE75i+QXqf6v6INUP7j2WvyiAEs/qBVIaJLU3rYj+n33O
        kZtU/jANFmPbpF/tFmcHulX5NGDqWSnN27QlTMFxqCRe61qn
X-Google-Smtp-Source: APXvYqxY9e4ExCKBaEkRVOc0Gz/ijRbw/6DBPk1AZLfsryIA7+WPJ0/IOYZQU5ZmHPFx8KUtYJLK3dewq52wTtd7Gg6W58geGSRn
MIME-Version: 1.0
X-Received: by 2002:a92:89c2:: with SMTP id w63mr46971728ilk.252.1577502961862;
 Fri, 27 Dec 2019 19:16:01 -0800 (PST)
Date:   Fri, 27 Dec 2019 19:16:01 -0800
In-Reply-To: <089e0825d4a4d2cb2a0562e878f1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ac9246059abb072c@google.com>
Subject: Re: possible deadlock in sch_direct_xmit
From:   syzbot <syzbot+29cc278357da941e304e@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, ecree@solarflare.com,
        edumazet@google.com, jhs@mojatatu.com, jiri@mellanox.com,
        jiri@resnulli.us, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, lucien.xin@gmail.com,
        mcroce@redhat.com, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 323ebb61e32b478e2432c5a3cbf9e2ca678a9609
Author: Edward Cree <ecree@solarflare.com>
Date:   Tue Aug 6 13:53:55 2019 +0000

     net: use listified RX for handling GRO_NORMAL skbs

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14647ab9e00000
start commit:   c92a9a46
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=46986c099cb53bc6
dashboard link: https://syzkaller.appspot.com/bug?extid=29cc278357da941e304e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=143636c9800000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16856849800000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: net: use listified RX for handling GRO_NORMAL skbs

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
