Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364AE1B93B3
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 21:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgDZTkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 15:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726171AbgDZTkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 15:40:52 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C97C061A0F;
        Sun, 26 Apr 2020 12:40:52 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id p25so7740436pfn.11;
        Sun, 26 Apr 2020 12:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=H3bSNoVE7kUEh9CP8BuePh5I5E+2JQHAHwnaXwmFeVY=;
        b=KCgMIiRVrBCOnzghlR2dsLJbbzYko6IrzAemhM7hdB3JyQiDwrdwz0UYFTYcr+bD9P
         VknO0MLDgb9dS5G7XKFRN/HlrAMb1lGQ8Z2OXBCvbLVEIFjY73fTgFGa8Kocb9aeX7yU
         Rh5k98TCNcRrT9TPEWoWReNLkMB/9vag8QWxtw4IFiOEkiDwAtxqLDwIBJhCpNNJ05r8
         mSROQTCjFglH+fF2axD7f2cSWxYrQlCffZRYOI2db5jaaulB4SIiJ3LS0uU59b+A/IQp
         PdBpmYXSaCr7sNaQn5W+q+apT4QwluPHqinC0tip5hsr86ifXw6wsatstvlAk16At/RG
         xI2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H3bSNoVE7kUEh9CP8BuePh5I5E+2JQHAHwnaXwmFeVY=;
        b=lMidh3HHKjtkbgVlGcymUe3+V+vOSdLTLLeb7jhl8lybHhVg0nX/Emt1Qn09geiX26
         UwEKFbelueyqPm2KIcnJua/4vrw4S2nBNa+SoU9XpIi2fuNZTgBF6dvPxR3N+3BcZ3q/
         iwegXXuH/NtfFHuMo/nGM5xRZRjaIoWZBaGtNlC7j30DGo46gWNWUlm5cJyI1X+FN/32
         Y9N/6SHzTOnolUNqBF1yHI6j9IsjYRx56Mg/BVH4GGfz1gfs7aJFMWqQzkh+Ccjw+WBh
         2dBPpxoxedu8ckE8YDsunjLblyqpNUyCzE5yf0HoWReIzZqJInwcXYBH8bQMMO74KLs1
         66uw==
X-Gm-Message-State: AGi0PuZLSGHVgDxCtxv3/votAJcsh++/JHvfZFNIqb6QKIk1Gq8ER0gL
        FUEETgq8LePGJEtmSq1mAcg=
X-Google-Smtp-Source: APiQypJLYJcz5LPgYCZyIiNMMLKSOhKclKuSQV3sLKlwdVUE6F0yEtlu+buCV+He/R5QndNxqMJWkQ==
X-Received: by 2002:a63:f91f:: with SMTP id h31mr19709057pgi.218.1587930050424;
        Sun, 26 Apr 2020 12:40:50 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id s199sm10825123pfs.124.2020.04.26.12.40.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Apr 2020 12:40:49 -0700 (PDT)
Subject: Re: INFO: rcu detected stall in wg_packet_tx_worker
To:     syzbot <syzbot+0251e883fe39e7a0cb0a@syzkaller.appspotmail.com>,
        Jason@zx2c4.com, davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, jhs@mojatatu.com, jiri@resnulli.us,
        krzk@kernel.org, kuba@kernel.org, kvalo@codeaurora.org,
        leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        shuah@kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vivien.didelot@gmail.com,
        xiyou.wangcong@gmail.com
References: <0000000000005fd19505a4355311@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e40c443e-74aa-bad4-7be8-4cdddfdf3eaf@gmail.com>
Date:   Sun, 26 Apr 2020 12:40:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <0000000000005fd19505a4355311@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/26/20 10:57 AM, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit e7096c131e5161fa3b8e52a650d7719d2857adfd
> Author: Jason A. Donenfeld <Jason@zx2c4.com>
> Date:   Sun Dec 8 23:27:34 2019 +0000
> 
>     net: WireGuard secure network tunnel
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15258fcfe00000
> start commit:   b2768df2 Merge branch 'for-linus' of git://git.kernel.org/..
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=17258fcfe00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=13258fcfe00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b7a70e992f2f9b68
> dashboard link: https://syzkaller.appspot.com/bug?extid=0251e883fe39e7a0cb0a
> userspace arch: i386
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f5f47fe00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11e8efb4100000
> 
> Reported-by: syzbot+0251e883fe39e7a0cb0a@syzkaller.appspotmail.com
> Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 

I have not looked at the repro closely, but WireGuard has some workers
that might loop forever, cond_resched() might help a bit.

diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index da3b782ab7d31df11e381529b144bcc494234a38..349a71e1907e081c61967c77c9f25a6ec5e57a24 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -518,6 +518,7 @@ void wg_packet_decrypt_worker(struct work_struct *work)
                                &PACKET_CB(skb)->keypair->receiving)) ?
                                PACKET_STATE_CRYPTED : PACKET_STATE_DEAD;
                wg_queue_enqueue_per_peer_napi(skb, state);
+               cond_resched();
        }
 }
 
diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
index 7348c10cbae3db54bfcb31f23c2753185735f876..f5b88693176c84b4bfdf8c4e05071481a3ce45b5 100644
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -281,6 +281,7 @@ void wg_packet_tx_worker(struct work_struct *work)
 
                wg_noise_keypair_put(keypair, false);
                wg_peer_put(peer);
+               cond_resched();
        }
 }
 
