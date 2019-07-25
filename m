Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53A847513B
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 16:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388463AbfGYOcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 10:32:54 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35561 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387460AbfGYOcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 10:32:53 -0400
Received: by mail-pl1-f194.google.com with SMTP id w24so23502639plp.2;
        Thu, 25 Jul 2019 07:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:message-id:in-reply-to:references:subject:mime-version
         :content-transfer-encoding;
        bh=xm8d/0YfDzg76rS/2jeIvZM2R2Un/4lb3VxpQFQctug=;
        b=W/wDJVvogxkRVbI+MBul+Vj8vYFPif2iJebEc0qEydEmNYXQREc+0jh/MmSco8Brka
         NTu1L3dYeNBcuXHN0MTlJypFjDZQGdqrr6fWDjUogxev8QDWkRbQGcmFiicrL8NAEXMf
         fqEIN0jQx0J0JTu1BniJyLQgNZ6PO9Bn1ezjZgfCePaqi92NEV+t8aGGf29AjDebZG/O
         qUOH6UycYL8lP6Wz9H9KFoHDKX/0MDateQRy/v8+2SaqHTCWL+yIq1NoilbnsQwZZv+f
         CZVSruUhTsIraR/bEuRurMiAArl+m2mplkcYcNj9z2NZ/ZiQaYQXpLInEDa0lu+K3Rwi
         +QDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:message-id:in-reply-to:references
         :subject:mime-version:content-transfer-encoding;
        bh=xm8d/0YfDzg76rS/2jeIvZM2R2Un/4lb3VxpQFQctug=;
        b=kO7gAbpPD7XQXs2rnKpbwbDgNXtmpHOtrCxR1/JabH6NgI/SAHyJ1EC9xVMF1PSWAv
         iwXtGGv1f8UTDsmLywJkdjPnqzmn4mOEdtIofzvm+PZTp73fD+rL//yfNpKnhndMg5mS
         gctMlQyke37lTJAzs4Y8H1QffkHrnlLQKqcnZ99mkxs+kkgK568lHP8t9dRjFCz767VE
         lvE4K6CbBFgc5PEJjRehtbd4vrlkWxBzPEL+hycWlD8DCSzRf9OtnpufQ6qX1cfjXwOf
         gqxjKDbNzD+0iJQ6QYB8k+SLXUbZTtrEp0Rxefvcgeubvk3RtxQvmAAYAUADatiB4hU8
         QwSA==
X-Gm-Message-State: APjAAAU5yQiMMuWV7Ov9MT0XoYmE0hCZr8HJ2XytadoNsdFF8Tf/wBPK
        BFNazWJVIS59pUqkmfLUFD8=
X-Google-Smtp-Source: APXvYqz9R21IUe71J35orWe8ThXzVkpGpJYUM9T65lEUe34h6Ohju3sRgs0hBkVxWbLmVxpx49fd4w==
X-Received: by 2002:a17:902:361:: with SMTP id 88mr92710604pld.123.1564065172566;
        Thu, 25 Jul 2019 07:32:52 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id d2sm45941096pjs.21.2019.07.25.07.32.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 07:32:51 -0700 (PDT)
Date:   Thu, 25 Jul 2019 07:32:44 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     syzbot <syzbot+e67cf584b5e6b35a8ffa@syzkaller.appspotmail.com>,
        arvid.brodin@alten.se, aviadye@mellanox.com, borisp@mellanox.com,
        daniel@iogearbox.net, davejwatson@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        john.hurley@netronome.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, simon.horman@netronome.com,
        syzkaller-bugs@googlegroups.com, willemb@google.com,
        xiyou.wangcong@gmail.com
Message-ID: <5d39bd8c17d6e_3ccf2b1636f025b8c4@john-XPS-13-9370.notmuch>
In-Reply-To: <000000000000e8c654058e7576ef@google.com>
References: <000000000000464b54058e722b54@google.com>
 <000000000000e8c654058e7576ef@google.com>
Subject: Re: BUG: spinlock recursion in release_sock
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit 8822e270d697010e6a4fd42a319dbefc33db91e1
> Author: John Hurley <john.hurley@netronome.com>
> Date:   Sun Jul 7 14:01:54 2019 +0000
> 
>      net: core: move push MPLS functionality from OvS to core helper
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13ca5a5c600000
> start commit:   9e6dfe80 Add linux-next specific files for 20190724
> git tree:       linux-next
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=102a5a5c600000
> console output: https://syzkaller.appspot.com/x/log.txt?x=17ca5a5c600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6cbb8fc2cf2842d7
> dashboard link: https://syzkaller.appspot.com/bug?extid=e67cf584b5e6b35a8ffa
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13680594600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b34144600000
> 
> Reported-by: syzbot+e67cf584b5e6b35a8ffa@syzkaller.appspotmail.com
> Fixes: 8822e270d697 ("net: core: move push MPLS functionality from OvS to  
> core helper")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

This commit is wrong, it appears to be introduced by some other fixes we
pushed last couple days for tls/bpf. I'll look into it. Thanks.
