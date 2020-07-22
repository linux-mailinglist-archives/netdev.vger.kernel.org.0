Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE51922A0B8
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 22:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgGVU3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 16:29:05 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:41124 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgGVU3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 16:29:05 -0400
Received: by mail-io1-f72.google.com with SMTP id n3so2584252iob.8
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 13:29:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=J+35V1GhRYpImLMMK2GI/sO17Jyt3p/2anYHKeEsSGE=;
        b=HcAn+W6jUBB1kxyxsgxi5iHOogzsSDN7FoBrVGqI963gLwPAbPNWFi/EyiUXoi1R9e
         KTixmbXbSgroTrHwvDrSOJCo0uYijDSI40FxB27kvFILqcG1cb+bXNReLsyWPj+8NGD/
         7we6zc21l/OGBHmnSDvpIPr6K5YQOdjTSoI9ECzzmtOUk20DNFsKCdXuPOYBdYyQI0Rk
         PRdCbkNF215jm6KKczl07jFs3ybm/DlqWNAXjc0yq5tjM5LH/g3/Xf9Axqh6d4l5PchU
         tCpWo6+ShmlNhZeoBkqFafxUnuEK1wD2DRx1+TzWmqxEZwRJioNhTK+f0Gudy++mHD0B
         JFKw==
X-Gm-Message-State: AOAM531Auf4iJM25KTxEQQ3nUzPUihu7fQk3K2OGJuTjhrtr62oUgBm3
        auPqLs4J668NsqpRlCTI8eQvdzhHQUKBO8yVoOMZevoMV6ng
X-Google-Smtp-Source: ABdhPJxHK6WbX/I4a7/yMyShEPLIR0Q9QECWtZRgxeRHjQAiPmIUBL9QFevmt3eA7WbXHH2iZgv3Tq89tpWot0N8y5MnqAgDQh6w
MIME-Version: 1.0
X-Received: by 2002:a92:8b45:: with SMTP id i66mr1708429ild.19.1595449744109;
 Wed, 22 Jul 2020 13:29:04 -0700 (PDT)
Date:   Wed, 22 Jul 2020 13:29:04 -0700
In-Reply-To: <0000000000005b9fca05aa0af1b9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000041388e05ab0d97aa@google.com>
Subject: Re: KASAN: use-after-free Read in netdevice_event_work_handler
From:   syzbot <syzbot+20b90969babe05609947@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, davem@davemloft.net, dledford@redhat.com,
        f.fainelli@gmail.com, hkallweit1@gmail.com, jgg@ziepe.ca,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, rkovhaev@gmail.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit d70c47c8dc6902db19555b7ff7e6eeb264d4ac06
Author: Heiner Kallweit <hkallweit1@gmail.com>
Date:   Thu Apr 23 19:34:33 2020 +0000

    net: phy: make phy_suspend a no-op if PHY is suspended already

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16b2aad8900000
start commit:   0bddd227 Documentation: update for gcc 4.9 requirement
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15b2aad8900000
console output: https://syzkaller.appspot.com/x/log.txt?x=11b2aad8900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=66ad203c2bb6d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=20b90969babe05609947
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a8edff100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167d3bb7100000

Reported-by: syzbot+20b90969babe05609947@syzkaller.appspotmail.com
Fixes: d70c47c8dc69 ("net: phy: make phy_suspend a no-op if PHY is suspended already")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
