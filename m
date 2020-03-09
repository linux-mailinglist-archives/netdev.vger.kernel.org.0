Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4626C17D97B
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 07:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgCIG6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 02:58:05 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:57225 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgCIG6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 02:58:05 -0400
Received: by mail-il1-f198.google.com with SMTP id b17so6719981iln.23
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 23:58:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=3vbHTdYQ67mib1pqhw7RfSE7n4B7fPNmRK2m1Cb8iPU=;
        b=t1hEC6ePBrwBms0ICxm0YgxATQ/+YRHPXX2q3VPauZU/DdeZv6jh5nUwvqWQHSnthZ
         7+giyIPc6VATgdnBxHL2mE1/FdK1Nfr7lJ6k10SgjQPgVUZUvCqLdcEdxLev4ptgIC/q
         V5MOnMjY3GSJtzI4Vpn0dAiEeElPBlZrfRiMLxcUKxTUfYn+uPiWtJN9hGRxyeX6ouOl
         9aU6JEZ15nA/IsVsXtXPIp/3u27iVTWChTe3iazlhpxILThawMW0TkwF2o09mmfvChee
         TB2FSNsrYkvcQt3JRDXWWj1Xzf+foZ/99dx8f3AM5qJoY2NwPXXFf980bdRTSsauHi7e
         yLKg==
X-Gm-Message-State: ANhLgQ3d5SHRa1fsbSzfB7v83q4cLcvRA0ZLoyC77Osz/oggCkPp7+wL
        Eq2dtVQ1i1Lw1e9AMG92wX4573ZxT7Mm03XATP+fkdX6SuU0
X-Google-Smtp-Source: ADFU+vtRpURm6U4wUgm5w3Q/LMCwhNNEMjTRsTn2XqAL2qLJHVJT0lEdDhwiPvd5cYSVN+QMhS0AUF7kTWiMSzfA+d9Rg3PvE9EA
MIME-Version: 1.0
X-Received: by 2002:a5d:9bc8:: with SMTP id d8mr12563436ion.142.1583737083027;
 Sun, 08 Mar 2020 23:58:03 -0700 (PDT)
Date:   Sun, 08 Mar 2020 23:58:03 -0700
In-Reply-To: <000000000000161ee805a039a49e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000406a7f05a066861d@google.com>
Subject: Re: possible deadlock in siw_create_listen
From:   syzbot <syzbot+3fbea977bd382a4e6140@syzkaller.appspotmail.com>
To:     ast@kernel.org, bmt@zurich.ibm.com, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dledford@redhat.com,
        dsahern@gmail.com, hawk@kernel.org, jakub.kicinski@netronome.com,
        jgg@ziepe.ca, jiri@mellanox.com, johannes.berg@intel.com,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        mkubecek@suse.cz, netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit bfcccfe78b361f5f6ef48554aed5bcd30c72f67f
Author: Jakub Kicinski <jakub.kicinski@netronome.com>
Date:   Tue Nov 5 21:26:11 2019 +0000

    netdevsim: drop code duplicated by a merge

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=166d11c3e00000
start commit:   425c075d Merge branch 'tun-debug'
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=156d11c3e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=116d11c3e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=598678fc6e800071
dashboard link: https://syzkaller.appspot.com/bug?extid=3fbea977bd382a4e6140
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e3df31e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=163d0439e00000

Reported-by: syzbot+3fbea977bd382a4e6140@syzkaller.appspotmail.com
Fixes: bfcccfe78b36 ("netdevsim: drop code duplicated by a merge")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
