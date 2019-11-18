Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE0B100D15
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 21:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfKRUZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 15:25:36 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:27857 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbfKRUZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 15:25:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1574108731;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=F0kDM7lnQGgAN875FMuKPjY93rcF9qMeT5dy/Yhy1tY=;
        b=A/QjOpbkgSAg54YA2VcfvY9OJSi1VK8UKTJ3CLtDbf6Rynq99ENfCl5o9Rmok8ChFx
        2DRYP3jHgQUiV04eSbF+bNxsQA0cuWnPRs9JlCrsVbvyYizBUsKQ+ba/+ieaJGdfyTHs
        hQwEhpnhlTriebQmBloYCy3RqJR0mzTDx8vHyjhcrWzflqk7V/XWrNzJg+h5CBaPjqRy
        X1bRxqPolN52t8WdHPA/+pIj7P4ZAuGDAvQuQVsThZtxAK9eQQ3gci9/jXdjf3XkyzOC
        ombjwNBG9YpR76GayQS/F2lWzTtmUmadKg5oyUCxIeZ1oKJiUiMsT4FyNppt+jXPAyBI
        fiKA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJV8h+lCA="
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.177]
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id C03a03vAIKPN15S
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Mon, 18 Nov 2019 21:25:23 +0100 (CET)
Subject: Re: KMSAN: uninit-value in can_receive
To:     syzbot <syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com>,
        davem@davemloft.net, glider@google.com, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000005c08d10597a3a05d@google.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <a5f73d92-fdf2-2590-c863-39a181dca8e1@hartkopp.net>
Date:   Mon, 18 Nov 2019 21:25:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <0000000000005c08d10597a3a05d@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/11/2019 20.05, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    9c6a7162 kmsan: remove unneeded annotations in bio
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=14563416e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9e324dfe9c7b0360
> dashboard link: 
> https://syzkaller.appspot.com/bug?extid=b02ff0707a97e4e79ebb
> compiler:       clang version 9.0.0 (/home/glider/llvm/clang 
> 80fee25776c2fb61e74c1ecb1a523375c2500b69)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com
> 
> =====================================================
> BUG: KMSAN: uninit-value in can_receive+0x23c/0x5e0 net/can/af_can.c:649
> CPU: 1 PID: 3490 Comm: syz-executor.2 Not tainted 5.4.0-rc5+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS 
> Google 01/01/2011
> Call Trace:
>   <IRQ>
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x191/0x1f0 lib/dump_stack.c:113
>   kmsan_report+0x128/0x220 mm/kmsan/kmsan_report.c:108
>   __msan_warning+0x73/0xe0 mm/kmsan/kmsan_instr.c:245
>   can_receive+0x23c/0x5e0 net/can/af_can.c:649
>   can_rcv+0x188/0x3a0 net/can/af_can.c:685

In line 649 of 5.4.0-rc5+ we can find a while() statement:

while (!(can_skb_prv(skb)->skbcnt))
	can_skb_prv(skb)->skbcnt = atomic_inc_return(&skbcounter);

In linux/include/linux/can/skb.h we see:

static inline struct can_skb_priv *can_skb_prv(struct sk_buff *skb)
{
	return (struct can_skb_priv *)(skb->head);
}

IMO accessing can_skb_prv(skb)->skbcnt at this point is a valid 
operation which has no uninitialized value.

Can this probably be a false positive of KMSAN?

Regards,
Oliver
