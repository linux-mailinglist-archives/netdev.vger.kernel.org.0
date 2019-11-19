Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B72C1029D7
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 17:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbfKSQxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 11:53:36 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42741 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbfKSQxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 11:53:36 -0500
Received: by mail-pl1-f194.google.com with SMTP id j12so12046233plt.9;
        Tue, 19 Nov 2019 08:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0ikEmW1Uo4O0wTwEpbsw1vK5uaPUtxj8nWEOCJAitRY=;
        b=QeA77eS6veKPZIsveG+jfcWwHV5debSGbGZJ1W14Wq82ggxzASoK28i/diQ7gbK4kl
         h9Jc04PxNHmr527ewTCO94EU/wosCb3x9UXFXudKwnLMTp/v1o3tQ+0PfIbw+EXVwdbp
         33QVUIdZPTVrDePLgB8KvLgIonuH19FhjXA31t4ZxhXtiTr7BNPCN04oelDG5pgKObTM
         M5Toh7Q9ymkkgT6UvMoLgfC9sitLbTkDw0h78F7XvanRQtQs1Uml2zX29tQGqGA/e05d
         WLTNWVxl8T7tHEntbz/iYGVRKDGLGhtQqYMuU4JTTYiNMmzFBniAlZIN+sbwDtpDSsbq
         WsGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0ikEmW1Uo4O0wTwEpbsw1vK5uaPUtxj8nWEOCJAitRY=;
        b=dBoLqCv3zXUM2clTvqnSYaQNIVNOzMD9CPBTj7pxR4LU2mBEVWyFxFzi3BqLGbyxTm
         uJsoocevINa3RzHuquiLQPGLPpXO1/0LHCwXUzTQWhui7F8Tnv/E3WN5xaJC2zmez9NS
         WRoapJt96ewKY8LHRLONvaW0DnIztlt1CyEfCdlNMu2zIizapWBzb0CkLhpmvr0eppYA
         XaP7wfA6qRxKDK8U+aN33dBYO7OJdw89W16B0ksXIWQtljydPaVcF4XMe3+nZ3Vr1E5e
         lQKlo+C5d1WkBLiWc5W3f4TNFlEHdWXXaIBZl7VrKiQQ7ALSevzpBA9zlBg8Nf8COC+9
         hKbQ==
X-Gm-Message-State: APjAAAVx33wjz5hxrVILoWsBJhy3ArMv3pUx38ITINItCA6q0Od6TXse
        WdXVYeLGA+MkjYqPmq6fA8Y=
X-Google-Smtp-Source: APXvYqygJkmb3ADs33SkUCsYqyMgEU1MYC1EWxOPKO8Eu1XEONdfouHXmzYzmNtpFSyFYX23ceHM1g==
X-Received: by 2002:a17:90a:8401:: with SMTP id j1mr7728686pjn.39.1574182415755;
        Tue, 19 Nov 2019 08:53:35 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id u65sm25969583pfb.35.2019.11.19.08.53.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 08:53:34 -0800 (PST)
Subject: Re: KMSAN: uninit-value in can_receive
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        syzbot <syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com>,
        davem@davemloft.net, glider@google.com, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000005c08d10597a3a05d@google.com>
 <a5f73d92-fdf2-2590-c863-39a181dca8e1@hartkopp.net>
 <deedd609-6f3b-8035-47e1-252ab221faa1@pengutronix.de>
 <7934bc2b-597f-0bb3-be2d-32f3b07b4de9@hartkopp.net>
 <7f5c4546-0c1a-86ae-581e-0203b5fca446@pengutronix.de>
 <1f7d6ea7-152e-ff18-549c-b196d8b5e3a7@hartkopp.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <9e06266a-67f3-7352-7b87-2b9144c7c9a9@gmail.com>
Date:   Tue, 19 Nov 2019 08:53:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1f7d6ea7-152e-ff18-549c-b196d8b5e3a7@hartkopp.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/19 11:35 PM, Oliver Hartkopp wrote:
> 

> 
> See ioctl$ifreq https://syzkaller.appspot.com/x/log.txt?x=14563416e00000
> 
> 23:11:34 executing program 2:
> r0 = socket(0x200000000000011, 0x3, 0x0)
> ioctl$ifreq_SIOCGIFINDEX_vcan(r0, 0x8933, &(0x7f0000000040)={'vxcan1\x00', <r1=>0x0})
> bind$packet(r0, &(0x7f0000000300)={0x11, 0xc, r1}, 0x14)
> sendmmsg(r0, &(0x7f0000000d00), 0x400004e, 0x0)
> 
> We only can receive skbs from (v(x))can devices.
> No matter if someone wrote to them via PF_CAN or PF_PACKET.
> We check for ETH_P_CAN(FD) type and ARPHRD_CAN dev type at rx time.

And what entity sets the can_skb_prv(skb)->skbcnt to zero exactly ?

> 
>>> We additionally might think about introducing a check whether we have a
>>> can_skb_reserve() created skbuff.
>>>
>>> But even if someone forged a skbuff without this reserved space the
>>> access to can_skb_prv(skb)->skbcnt would point into some CAN frame
>>> content - which is still no access to uninitialized content, right?
> 
> So this question remains still valid whether we have a false positive from KMSAN here.

I do not believe it is a false positive.

It seems CAN relies on some properties of low level drivers using alloc_can_skb() or similar function.

Why not simply fix this like that ?

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 128d37a4c2e0ba5d8db69fcceec8cbd6a79380df..3e71a78d82af84caaacd0ef512b5e894efbf4852 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -647,8 +647,9 @@ static void can_receive(struct sk_buff *skb, struct net_device *dev)
        pkg_stats->rx_frames_delta++;
 
        /* create non-zero unique skb identifier together with *skb */
-       while (!(can_skb_prv(skb)->skbcnt))
+       do {
                can_skb_prv(skb)->skbcnt = atomic_inc_return(&skbcounter);
+       } while (!(can_skb_prv(skb)->skbcnt));
 
        rcu_read_lock();
 


