Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC7ACE584
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 16:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfJGOms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 10:42:48 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52635 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbfJGOms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 10:42:48 -0400
Received: by mail-wm1-f68.google.com with SMTP id r19so12991654wmh.2
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 07:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0kl+DAj1oCg+aQcQu6D5DV3XjvnFcsuot+q3ncQGbNg=;
        b=1APETO5dW5o/P6Bf0/LysOTzFrtKEin7/g+Es/v671W7F2gfUXc5xQ/UqZvhegttkQ
         Q9qHf/nCa2w6h2TBH6GiIpmYBeGKbQf704cUluye9KUV1/ZFscSqtebTOC857bbLoV9i
         bFqJaKz/xGcly7fkB3JpVz6EI5DJT2oYMmO6eMtFUtzjCvheQS5tlg94nfrbvBaqobjK
         qKKaIi+OzCbRD/NO6Y0mki7kQQ/iT993PFbtZrkkGeZhS2KLDZDORxECOgdLFUDnWoBd
         Ozygifu9Aiouwto0rx5J7wLAy4U6naxGLp9lARRKoU/yOUBJ3a99PsYRu17vHd2kPz0+
         MIVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0kl+DAj1oCg+aQcQu6D5DV3XjvnFcsuot+q3ncQGbNg=;
        b=fK2GAR/efY+GwYDzY3PpTn1tBAOLxqVkC3cv2dmMxZy3M/gRhzcobH2z3UB1q611yc
         LofqIcCi7mn0w6a4di5wjtnn6r0zgfDgZeFW+BIIC75RfKk12SosxCZzO7M55b54SZf0
         TB0avhgrIRy2moRiB4gE/qVFyKcW/zsrAOInJxARpc7P8bXXthlbCLBXBvtDN0ax4R0F
         xxJYRd/UGjLTWADNOqUx42aQLIZJMiXwRfaBwIuV/rYueyjsZ9nim+Cdgjb20r2WgMdd
         FI5tUZNhQ72U4lCnwFQgLuGMVEvnOVMLCNSAY+f2MkXBvB0lCySU8p/nAvqn8HIcw5s+
         I2kA==
X-Gm-Message-State: APjAAAXtXFJwFL9gw1A0tGDmJcPY/WyLCbSZHIXERb3+sjsgpe9XIJQD
        0OPs6JyiSUCmoZWbgzWwcWYwyA==
X-Google-Smtp-Source: APXvYqzGiEZjoZdI1oEjJFuGvM2gE1Fi2waku98ts48QCWrm+IFggCsmK6LJTaueX3QZI/RfatXNuw==
X-Received: by 2002:a7b:c7d4:: with SMTP id z20mr20958580wmk.49.1570459366588;
        Mon, 07 Oct 2019 07:42:46 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id q15sm31743144wrg.65.2019.10.07.07.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 07:42:46 -0700 (PDT)
Date:   Mon, 7 Oct 2019 16:42:45 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     syzbot <syzbot+9cb7edb2906ea1e83006@syzkaller.appspotmail.com>
Cc:     alex.aring@gmail.com, davem@davemloft.net, jiri@mellanox.com,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, stefan@datenfreihafen.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in __cfg8NUM_wpan_dev_from_attrs
Message-ID: <20191007144245.GC2326@nanopsycho>
References: <00000000000035a04b059452bc21@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000035a04b059452bc21@google.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Oct 07, 2019 at 04:19:09PM CEST, syzbot+9cb7edb2906ea1e83006@syzkaller.appspotmail.com wrote:
>Hello,
>
>syzbot found the following crash on:
>
>HEAD commit:    056ddc38 Merge branch 'stmmac-next'
>git tree:       net-next
>console output: https://syzkaller.appspot.com/x/log.txt?x=125aaafd600000
>kernel config:  https://syzkaller.appspot.com/x/.config?x=d9be300620399522
>dashboard link: https://syzkaller.appspot.com/bug?extid=9cb7edb2906ea1e83006
>compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1232bb3f600000
>C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=162d0d0b600000
>
>The bug was bisected to:
>
>commit 75cdbdd089003cd53560ff87b690ae911fa7df8e
>Author: Jiri Pirko <jiri@mellanox.com>
>Date:   Sat Oct 5 18:04:37 2019 +0000
>
>    net: ieee802154: have genetlink code to parse the attrs during dumpit
>
>bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11be5d0b600000
>final crash:    https://syzkaller.appspot.com/x/report.txt?x=13be5d0b600000
>console output: https://syzkaller.appspot.com/x/log.txt?x=15be5d0b600000
>
>IMPORTANT: if you fix the bug, please add the following tag to the commit:
>Reported-by: syzbot+9cb7edb2906ea1e83006@syzkaller.appspotmail.com
>Fixes: 75cdbdd08900 ("net: ieee802154: have genetlink code to parse the attrs
>during dumpit")
>
>netlink: 'syz-executor134': attribute type 6 has an invalid length.
>==================================================================
>BUG: KASAN: use-after-free in nla_memcpy+0xa2/0xb0 lib/nlattr.c:572

I'm on this.
