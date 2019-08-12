Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 827608AAA1
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 00:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfHLWk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 18:40:58 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36839 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbfHLWk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 18:40:58 -0400
Received: by mail-qk1-f196.google.com with SMTP id d23so3447549qko.3
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 15:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=kdeR2ekazPPacbcNxY/1Vu/Or4DQHYsQYtQCeaE7Fv8=;
        b=1Ukepgq5x/sRZRBTKuW2bpxHjMqNBl9lA3fZd6ACoiOUlZrodm76pXyqZQHI6GOx+D
         xbi8W+2Hpek7iJlTtNsJ0n/GY3d0zOO/+hMncALdkrptGAausq8GAz02qlSLFUyGOnSO
         YlvcdLw19C5ddbsT4NyTYU2Ys9pnHk36jh3IQReKoKYk4E0NuhOsQtW4YkAswNeM+hwN
         VQ5jcq+D4+praHjSGgxeQNEdusvSTHHhoJudTQrpbNmO6PDHYQwVHDsGqtPCqCxOoq0D
         Sms3GbZiZCRjwtbV69MHRoIsDh6VqW7czkwAZ7TA/aKeQ3Gm2/2OKK1kdBPY20t8Bp+v
         6xPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=kdeR2ekazPPacbcNxY/1Vu/Or4DQHYsQYtQCeaE7Fv8=;
        b=GlDQ3xQzjSNdYGcZlRazkJzhQHozLsiUpjTysqacNWuxCKnAKK4edKSWbjpKvPSJQs
         OcOe53uu3mlO7bSPZeb5yZ+kbrEwXN3NnRsdvlhWkHJnH4a9ZM3w07pPr+/dwQ13yZuP
         YON4Kw6T722dfxVHwqzgh1clslmp33W2GAPD6GnAHbRRDe0Xq/O9cqDGeanUcd9NJ3ts
         hWEHhELLjRxldTMyI74wuJ9J1sC2mEcJ7g5R4x4sMVJkTzxInKSNBfvRINpP+uRVT20+
         05cB9QUMnh5xjlFXZiL0hS6wXbq14qzp6fsWwejjH3BK+XnqBNkA3pvqv+N5hQNtrkr6
         9MtA==
X-Gm-Message-State: APjAAAW77x/1J8m/tu5NbG5w5dTWSlVrizw9iVycweKNXEdXWAMxVsvI
        JmXxqCTJCyN8QZxbUktW+m1FVA==
X-Google-Smtp-Source: APXvYqyxtPM7GqksDlKwbnRQDvRzu7ixT+BoGcvf6Isa5kkNd+JSjdxb275tOajGZo7sCTYRRLzmuQ==
X-Received: by 2002:a37:b982:: with SMTP id j124mr2940613qkf.251.1565649657128;
        Mon, 12 Aug 2019 15:40:57 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p23sm47935782qke.44.2019.08.12.15.40.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 15:40:57 -0700 (PDT)
Date:   Mon, 12 Aug 2019 15:40:47 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     syzbot <syzbot+193e29e9387ea5837f1d@syzkaller.appspotmail.com>
Cc:     arvid.brodin@alten.se, davem@davemloft.net, dhowells@redhat.com,
        dirk.vandermerwe@netronome.com, edumazet@google.com,
        jiri@mellanox.com, john.hurley@netronome.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: BUG: corrupted list in rxrpc_local_processor
Message-ID: <20190812154047.25d60679@cakuba.netronome.com>
In-Reply-To: <000000000000ac9048058ff3176e@google.com>
References: <000000000000492086058fad2979@google.com>
        <000000000000ac9048058ff3176e@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 15:32:00 -0700, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit 427545b3046326cd7b4dbbd7869f08737df2ad2b
> Author: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date:   Tue Jul 9 02:53:12 2019 +0000
> 
>      nfp: tls: count TSO segments separately for the TLS offload
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11d04eee600000
> start commit:   125b7e09 net: tc35815: Explicitly check NET_IP_ALIGN is no..
> git tree:       net
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=13d04eee600000
> console output: https://syzkaller.appspot.com/x/log.txt?x=15d04eee600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a4c9e9f08e9e8960
> dashboard link: https://syzkaller.appspot.com/bug?extid=193e29e9387ea5837f1d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159d4eba600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ba194a600000
> 
> Reported-by: syzbot+193e29e9387ea5837f1d@syzkaller.appspotmail.com
> Fixes: 427545b30463 ("nfp: tls: count TSO segments separately for the TLS  
> offload")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Is there a way perhaps to tell syzbot to discard clearly bogus
bisection results?
