Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D0762FC4E
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 19:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241706AbiKRSSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 13:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242597AbiKRSSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 13:18:01 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04014920B1
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 10:17:59 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id z18so8255078edb.9
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 10:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=lxvgxUWRBQpJ6o8x4dRg66NF8kTh2+oVjHW+HpxyKmA=;
        b=EffrL/45CpozM/UpJDSU/wg0kKX47B0FLhlrFBLSbEr83MOHfBLFxVJXGWEV9RDW7K
         G3mIP6pOTSMW2NSkGcAEMPlHin43QrPuTbU4Jla+8+Y9YSs7ge0bOSCBE5+l/RIZGTJZ
         Onw+BpabzsunV/t6U0LFUtr2wk2PU7hCyXycQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lxvgxUWRBQpJ6o8x4dRg66NF8kTh2+oVjHW+HpxyKmA=;
        b=Dno2od58ulscuUWIheQSKKRIsaxHVgLtoaO2T6yHIs8hco0Tc9FA4gwnwvaKEWJSVs
         MBfJHFF/HBhBFJHvLmlN5npOfubXi6n+4wb6kbqjLPZMJBGVa7l0IZC+MyqolI/vUd7v
         Swv8ZQqs/zYL+CJw4t1+ig0IgE5CPa78zkY/MpnWu6Q9jJ8BZu4BxMX5BRjaQ6mINEEl
         9+xQN8DMOT7bTDZuJ7KBLj23coU69wgmZcKTy0C+rQkOCPLI3nTa49RpBawGgLkwoApY
         xJ8t5Jm04jLVZGfmPiOGNrQy1IdcwBaaH9VwqQiGJVc9Fdzx1PF+UqrElSQfeQBUE9bw
         YADQ==
X-Gm-Message-State: ANoB5pn+hKpTUzEhM46/WZ4EEH7h5YWW0n73yRyYTSbp1lCImVhUWq7e
        vJE/EFQ89K2z61eRqoh7wsyifQ==
X-Google-Smtp-Source: AA0mqf6708NNo6PAyis1Ny1AbM8eVgYGcVrKi9RADYQ6FZ3R9QqW/U/6t4xzSzzk76UqKHpD0SM0Gg==
X-Received: by 2002:aa7:cd1a:0:b0:459:f897:7940 with SMTP id b26-20020aa7cd1a000000b00459f8977940mr7043230edw.168.1668795478528;
        Fri, 18 Nov 2022 10:17:58 -0800 (PST)
Received: from cloudflare.com (79.184.204.15.ipv4.supernova.orange.pl. [79.184.204.15])
        by smtp.gmail.com with ESMTPSA id mb22-20020a170906eb1600b0077f20a722dfsm1964840ejb.165.2022.11.18.10.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 10:17:58 -0800 (PST)
References: <0000000000004e78ec05eda79749@google.com>
 <00000000000011ec5105edb50386@google.com>
 <c64284f4-2c2a-ecb9-a08e-9e49d49c720b@I-love.SAKURA.ne.jp>
 <CANn89iJq0v5=M7OTPE8WGZ4bNiYzO-KW3E8SRHOzf_q9nHPZEw@mail.gmail.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Tom Parkin <tparkin@katalix.com>,
        syzbot <syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Haowei Yan <g1042620637@gmail.com>
Subject: Re: [PATCH 6.1-rc6] l2tp: call udp_tunnel_encap_enable() and
 sock_release() without sk_callback_lock
Date:   Fri, 18 Nov 2022 18:50:43 +0100
In-reply-to: <CANn89iJq0v5=M7OTPE8WGZ4bNiYzO-KW3E8SRHOzf_q9nHPZEw@mail.gmail.com>
Message-ID: <87zgconn3g.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 04:36 AM -08, Eric Dumazet wrote:
> On Fri, Nov 18, 2022 at 3:51 AM Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
>>
>> syzbot is reporting sleep in atomic context at l2tp_tunnel_register() [1],
>> for commit b68777d54fac ("l2tp: Serialize access to sk_user_data with
>> sk_callback_lock") missed that udp_tunnel_encap_enable() from
>> setup_udp_tunnel_sock() might sleep.
>>
>> Since we don't want to drop sk->sk_callback_lock inside
>> setup_udp_tunnel_sock() right before calling udp_tunnel_encap_enable(),
>> introduce a variant which does not call udp_tunnel_encap_enable(). And
>> call udp_tunnel_encap_enable() after dropping sk->sk_callback_lock.
>>
>> Also, drop sk->sk_callback_lock before calling sock_release() in order to
>> avoid circular locking dependency problem.
>
> Please look at recent discussion, your patch does not address another
> fundamental problem.
>
> Also, Jakub was working on a fix already. Perhaps sync with him to
> avoid duplicate work.
>
> https://lore.kernel.org/netdev/20221114191619.124659-1-jakub@cloudflare.com/T/
>
> Thanks.

Thanks for the patch, Tetsuo.

As Eric has pointed out [1], there is another problem - in addition to
sleeping in atomic context, I have also failed to use the write_lock
variant which disabled BH locally.

The latter bug can lead to dead-locks, as reported by syzcaller [2, 3],
because we grab sk_callback_lock in softirq context, which can then
block waiting on us if:

1) it runs on the same CPU, or

       CPU0
       ----
  lock(clock-AF_INET6);
  <Interrupt>
    lock(clock-AF_INET6);

2) lock ordering leads to priority inversion

       CPU0                    CPU1
       ----                    ----
  lock(clock-AF_INET6);
                               local_irq_disable();
                               lock(&tcp_hashinfo.bhash[i].lock);
                               lock(clock-AF_INET6);
  <Interrupt>
    lock(&tcp_hashinfo.bhash[i].lock);

IOW, your patch works if we also s/write_\(un\)\?lock/write_\1lock_bh/.

But, I also have an alternative idea - instead of pulling the function
call that might sleep out of the critical section, I think we can make
the critical section much shorter by rearranging the tunnel
initialization code slightly. That is, a change like below.

-jkbs

[1] https://lore.kernel.org/netdev/CANn89iLQUZnyGNCn2GpW31FXpE_Lt7a5Urr21RqzfAE4sYxs+w@mail.gmail.com/
[2] https://lore.kernel.org/netdev/000000000000e38b6605eda76f98@google.com
[3] https://lore.kernel.org/netdev/000000000000dfa31e05eda76f75@google.com/


--8<--

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 754fdda8a5f5..07454c0418e3 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1474,11 +1474,15 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	}
 
 	sk = sock->sk;
-	write_lock(&sk->sk_callback_lock);
+	write_lock_bh(&sk->sk_callback_lock);
 
 	ret = l2tp_validate_socket(sk, net, tunnel->encap);
 	if (ret < 0)
 		goto err_sock;
+	if (tunnel->encap != L2TP_ENCAPTYPE_UDP)
+		rcu_assign_sk_user_data(sk, tunnel);
+
+	write_unlock_bh(&sk->sk_callback_lock);
 
 	tunnel->l2tp_net = net;
 	pn = l2tp_pernet(net);
@@ -1507,8 +1511,6 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 		};
 
 		setup_udp_tunnel_sock(net, sock, &udp_cfg);
-	} else {
-		rcu_assign_sk_user_data(sk, tunnel);
 	}
 
 	tunnel->old_sk_destruct = sk->sk_destruct;
@@ -1522,7 +1524,6 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	if (tunnel->fd >= 0)
 		sockfd_put(sock);
 
-	write_unlock(&sk->sk_callback_lock);
 	return 0;
 
 err_sock:
@@ -1530,8 +1531,6 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 		sock_release(sock);
 	else
 		sockfd_put(sock);
-
-	write_unlock(&sk->sk_callback_lock);
 err:
 	return ret;
 }
