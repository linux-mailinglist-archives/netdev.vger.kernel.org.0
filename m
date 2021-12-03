Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F7C466EB4
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 01:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350191AbhLCAuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 19:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238220AbhLCAuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 19:50:20 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF46C06174A;
        Thu,  2 Dec 2021 16:46:57 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id r26so2616031oiw.5;
        Thu, 02 Dec 2021 16:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=F9YxeZiJ+WKn4fcYHsHDT9P9am1xvNy0JY5/QKITgX4=;
        b=e2ZLv2WBNhT3RK/eb+1EqoiBAjfYomOMDdjt++zFyOs+IUaGbZAxFnnCrKkwWbJf4R
         wjxJCkJJZarsKXseA9yXtww72J5j8NS3eEmUS5viFfHC310pPuSHLum2KUJglhPDYBgJ
         iTolOB3W+gcWMk0xqC7ebrDi23zKdhe5CEi4kI8ooayzah/+2MNWvMtIVQQknwaPH1ep
         Jo3Z99WnGmzkAAlYe29qOFUMyQLuFFkhasN/Ej2tv8kJcKXJkrn1ZbOSPzhun3X0/RF5
         JUVMV6I7jxGkF74CWEgqsVwJhYZYAfmvr8tf3uS/1b+YayFBv1Tw4qIGofGUVL0wl0sf
         JS3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=F9YxeZiJ+WKn4fcYHsHDT9P9am1xvNy0JY5/QKITgX4=;
        b=C26aZvpMj5QQZAJIL8U2LSbZw949Omo8CUpFwuMbwbFW2xYCKQGuqyn6Ljyof5eCbv
         ZZohghTIuBMH5n6BTfPHH0wHujO/xqhWXcwTd+UnyB00xmN3GjuUXNuOtcu7jclQeAC0
         KXpqbWgSHIaCYCIXUf0fjbdeDO499y05prhRuXdHaDN6z1R8f5e8GdZmTTbpuYLwb9Qe
         E/4MQ+3fjbzMBkNp9RI9eyC2HNRgQYv0whFvPRlRvYmVoX9v73ds9OfViKtvatnoQhus
         Lix/ZTLu2AazIckBLzMdomwZWJv9qPuje1dVDwiyfkhKi3Gr5b3/4W1uQClQQztnLSm+
         XHKA==
X-Gm-Message-State: AOAM5310RcxIJ4HihWY6CLpeCMqY8EQ6fM3MVItm+U4TPTJ41aU6zyey
        JMA0vBNEOZoKh0sEcw3ZqQf7tl2JRTpusznh
X-Google-Smtp-Source: ABdhPJzmgwanPP5Q+Rn2Uf546Q8FxlzzuoCxLFr83vlBmlTCxY1U7uDOwkWv1BhDxrQIBwo9NPWwVQ==
X-Received: by 2002:aca:4307:: with SMTP id q7mr6968573oia.3.1638492416473;
        Thu, 02 Dec 2021 16:46:56 -0800 (PST)
Received: from [10.62.118.101] (cpe-24-31-246-181.kc.res.rr.com. [24.31.246.181])
        by smtp.gmail.com with ESMTPSA id bd6sm473671oib.53.2021.12.02.16.46.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 16:46:55 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <0db18565-6309-06d3-474a-88b5410072b3@lwfinger.net>
Date:   Thu, 2 Dec 2021 18:46:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [syzbot] WARNING in rtl92cu_hw_init
Content-Language: en-US
To:     syzbot <syzbot+cce1ee31614c171f5595@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pkshih@realtek.com, syzkaller-bugs@googlegroups.com
References: <000000000000630d8505d2326961@google.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <000000000000630d8505d2326961@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/21 17:47, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    c4bc515d73b5 usb: dwc2: gadget: use existing helper
> git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
> console output: https://syzkaller.appspot.com/x/log.txt?x=12c7d311b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1fa54650ce78e6dc
> dashboard link: https://syzkaller.appspot.com/bug?extid=cce1ee31614c171f5595
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+cce1ee31614c171f5595@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> raw_local_irq_restore() called with IRQs enabled
> WARNING: CPU: 1 PID: 1206 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
> Modules linked in:
> CPU: 1 PID: 1206 Comm: dhcpcd Not tainted 5.16.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
> Code: d3 ff cc cc cc cc cc cc cc cc cc cc cc 80 3d e7 4e dc 02 00 74 01 c3 48 c7 c7 a0 85 27 86 c6 05 d6 4e dc 02 01 e8 fd 13 d3 ff <0f> 0b c3 44 8b 05 75 05 e7 02 55 53 65 48 8b 1c 25 80 6f 02 00 45
> RSP: 0018:ffffc90000f0f6a8 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 0000000000000200 RCX: 0000000000000000
> RDX: ffff8881100f1c00 RSI: ffffffff812bae78 RDI: fffff520001e1ec7
> RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffffff812b4c4e R11: 0000000000000000 R12: ffff88814b2047c0
> R13: 0000000000000000 R14: 0000000000000000 R15: 00000000ffffffff
> FS:  00007f0d4252e740(0000) GS:ffff8881f6900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fd8c7ba7718 CR3: 0000000117bd2000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   <TASK>
>   rtl92cu_hw_init.cold+0x119f/0x34c5 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c:1003

I think I understand this warning:

The routine in question is the following comment and code:

         /* As this function can take a very long time (up to 350 ms)
          * and can be called with irqs disabled, reenable the irqs
          * to let the other devices continue being serviced.
          *
          * It is safe doing so since our own interrupts will only be enabled
          * in a subsequent step.
          */
         local_save_flags(flags);
         local_irq_enable();
...
exit:
         local_irq_restore(flags);
         return err;

It seems to me that this would lead to the "raw_local_irq_restore() called with 
IRQs enabled" warning.

A brute-force method would be to insert a "local_irq_disable()" call just before 
the local_irq_restore() call. Would that work? Is there a more elegant solution?

Thanks,

Larry

