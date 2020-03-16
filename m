Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90DAE1865DD
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 08:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729921AbgCPHtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 03:49:03 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:51349 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729662AbgCPHtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 03:49:03 -0400
Received: by mail-io1-f72.google.com with SMTP id d1so8131737iod.18
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 00:49:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ouibFrPDWjCxL4FEpaUkFRuLLdmqeyOHLoLDagTo38s=;
        b=bRPP14BcllzYfNducdHgIK/+bRLo3rSe6qeaJgBPSxddsiWwM+nxJ9nm+u42daSZqw
         4BexhupiLW6Fz7cIwfM6g6HymSB16KDhNmjf7Eim3S9j2ChTtM3Ja/nIRHvIVaZOZ6gK
         drnWQxVFGOksgI0SOvV4HqwGsWIQnqY93TXY/kuxTCe0ozi3zEIn0PD2jkFvO2+DnmbG
         ylgjnAOgGfcUvB7n+n/1P2Nvfl+mSMZaaCVcacCrpfh86lkFVkhE79xsCN4csGqTezZn
         l0O6cSZX5+P1tG/0wXNfI2mBUDG6LwOkLoZYI3w50KboCdLgQF8dJOVLjAmSwmMVQRrS
         XkQA==
X-Gm-Message-State: ANhLgQ1sdjJetD7A5/EdRf2eT2Qqy9J67HWG2p0U7XmXzEQEfdHDFaBh
        qKGrpqNSSd0eXBVKgXnlK8t2m7MlbBzBB/vjsOpt4GS1YlGH
X-Google-Smtp-Source: ADFU+vuDRuPOxa1IDImesiTPozC5o7HpVN8zsZ8bX3G8vsFE+prdAIwJ0Rw4kazKiRUzVPk45zL965SLV5YZQfZX51CMEkoS3u30
MIME-Version: 1.0
X-Received: by 2002:a6b:dd14:: with SMTP id f20mr22452258ioc.32.1584344942619;
 Mon, 16 Mar 2020 00:49:02 -0700 (PDT)
Date:   Mon, 16 Mar 2020 00:49:02 -0700
In-Reply-To: <000000000000c08f2005a0ed60d4@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000081b1df05a0f40d13@google.com>
Subject: Re: general protection fault in erspan_netlink_parms
From:   syzbot <syzbot+1b4ebf4dae4e510dd219@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        petrm@mellanox.com, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit e1f8f78ffe9854308b9e12a73ebe4e909074fc33
Author: Petr Machata <petrm@mellanox.com>
Date:   Fri Mar 13 11:39:36 2020 +0000

    net: ip_gre: Separate ERSPAN newlink / changelink callbacks

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=101477fde00000
start commit:   0fda7600 geneve: move debug check after netdev unregister
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=121477fde00000
console output: https://syzkaller.appspot.com/x/log.txt?x=141477fde00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2e311dba9a02ba9
dashboard link: https://syzkaller.appspot.com/bug?extid=1b4ebf4dae4e510dd219
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1627f955e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111ac52de00000

Reported-by: syzbot+1b4ebf4dae4e510dd219@syzkaller.appspotmail.com
Fixes: e1f8f78ffe98 ("net: ip_gre: Separate ERSPAN newlink / changelink callbacks")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
