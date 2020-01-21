Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB041446A6
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 22:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgAUVuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 16:50:02 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:56330 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728988AbgAUVuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 16:50:02 -0500
Received: by mail-io1-f70.google.com with SMTP id d13so2628089ioo.23
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 13:50:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1nu34KWVojNJ0iYFVQZsR/2nmBumiBAt3h2LvuI970Y=;
        b=ftTMZmoz85wxyL1ZshsANIvDeVcRg2i7qFtQDPdJTuEoYfbbrPxuyGINZe6iekbFhH
         Z2yeVbmYwvHCGMc25uQK5CA+pq+hJYrYUcP0ch2BaJXRpxCQmvNjraWS7mYZXJ+sM1Y4
         704sJBV5hxMwHSCFWahZSaSrF3S/g88X2PQleuzFM5I0Pr5yS4qUlHVTSYWmRr71tyrl
         eLAMLwMymliGjkiJxY4/uou2WFmRoSMh4YdXZtt5S08dtLYDTMepNUaHtRcwh30I2ZFg
         8mZGq+vxO+HQ9BXeAsbTZZP0D5cOHXlwz1NSNouS6aslsAaNboGxVfQYaPEoJ2phX2FB
         mRLg==
X-Gm-Message-State: APjAAAVCSAA57FowFs49qPwGdlnNXuIqcx1YPpKqdbIZ/oJonGppoP73
        asMA3/s6H79WnCs81m/9JdevuzRWsBr3UkdacsO4pMcE6O7J
X-Google-Smtp-Source: APXvYqxQ4rOLGRXLTbwmviB3A/+GgBIvEUj4X8+0mXpwIfIkcZe7psrzASaNmKDPlT3fRnC4f73MzzR9V1/NkWOy3R3G2dY3dwD9
MIME-Version: 1.0
X-Received: by 2002:a6b:5503:: with SMTP id j3mr4657404iob.142.1579643401878;
 Tue, 21 Jan 2020 13:50:01 -0800 (PST)
Date:   Tue, 21 Jan 2020 13:50:01 -0800
In-Reply-To: <000000000000367175059c90b6bf@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d747bf059cad63b0@google.com>
Subject: Re: KASAN: use-after-free Read in __nf_tables_abort
From:   syzbot <syzbot+29125d208b3dae9a7019@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, dan.carpenter@oracle.com,
        davem@davemloft.net, fw@strlen.de, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit ec7470b834fe7b5d7eff11b6677f5d7fdf5e9a91
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Mon Jan 13 17:09:58 2020 +0000

    netfilter: nf_tables: store transaction list locally while requesting module

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14890721e00000
start commit:   d96d875e Merge tag 'fixes_for_v5.5-rc8' of git://git.kerne..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16890721e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12890721e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=83c00afca9cf5153
dashboard link: https://syzkaller.appspot.com/bug?extid=29125d208b3dae9a7019
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1203f521e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10a706a5e00000

Reported-by: syzbot+29125d208b3dae9a7019@syzkaller.appspotmail.com
Fixes: ec7470b834fe ("netfilter: nf_tables: store transaction list locally while requesting module")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
