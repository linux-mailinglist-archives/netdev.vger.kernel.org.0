Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2390D1FD81
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 03:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfEPBqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 21:46:23 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40439 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfEPACh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 20:02:37 -0400
Received: by mail-pg1-f196.google.com with SMTP id d30so588882pgm.7
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 17:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FGTcz6za9/O2YtwebkiIWGUyHrRcdq0R2Yfa8Auyk3Q=;
        b=bC1YQQfpUXZHwp+VqRqeTQ/Rd3PLi1ltMHudh0Z3SRccjhR3tuY9etO8w17jrHsNel
         uNWZTiB3gaRYN0dR+BAZRtotENJbJebYfix5QZi0iVut/KlLe+kBzLyvzdWLvVLuOuGc
         5oP1Z4WiSz0IOB5vwj016S3jdmA4PQxuk2M606QOTwMWiStvEyeWwJjyLRLSDm4Nbt0l
         mWR7Bwrrff4iBcdrhDKMDkE9uymIjxVkA9FjAiuQdxQ2z69uE0MedPL/Or0Ze03yZKaS
         O1i802Xi6/hul65roIDOFP2IYBtwR3cXwV/sjgmjzC1TZtUzmFxXOUxvJkwh4cgQ1bZE
         la3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FGTcz6za9/O2YtwebkiIWGUyHrRcdq0R2Yfa8Auyk3Q=;
        b=Nu9m9Khes8DHJqmsytH3bojjFEbfjJSY3b+WM+Z1pf+UPWOPM5ymkKi4UtUZrQSoTy
         bsRyVgWY+PQMHMbwB+Uo3npBA740p1flqwx6lJLWbhatNG8ZorP/kBlzokHLjVecwoc+
         2hTPYGkbFYOWeIQhMmtayKhJp4mUp84jtWpj28P1jtdrXGlnkkYklCD2vSMlwWTTl+v3
         crUTCVowe7H5UNypLlf9iATOGnuL4WyD53mVReRqk8pq+8fObERqyOcFVFDEl7kx629k
         UGCZAevj5ofJAE5LqUxe9bVRSUnn0V3Iltit9AaLgtupdMRfyD2AL9ZzB8mtzYPGugoi
         HMDw==
X-Gm-Message-State: APjAAAVER3zwtXmffLCZO1O7Cl/d7qTjHE99t/wKJSlAQkphJCzmvVB5
        v9BHVphHilLZsu4daA1eCqCqtwVw
X-Google-Smtp-Source: APXvYqzZVaaIBX/zEqJwqeCVHiv0kEW+A9miBQmyUhEiFOUpsH5eys+ZEwsJwiT2Jq6F5M8/pToFYA==
X-Received: by 2002:a63:5d3:: with SMTP id 202mr45588380pgf.363.1557964956189;
        Wed, 15 May 2019 17:02:36 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id q128sm4027874pfb.164.2019.05.15.17.02.34
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 17:02:34 -0700 (PDT)
Subject: Re: [RFC] folding socket->wq into struct socket
To:     David Miller <davem@davemloft.net>, viro@zeniv.linux.org.uk
Cc:     netdev@vger.kernel.org
References: <20190502163223.GW23075@ZenIV.linux.org.uk>
 <20190505.100421.2250762717881638194.davem@davemloft.net>
 <20190505175943.GC23075@ZenIV.linux.org.uk>
 <20190505.112531.600819597326525048.davem@davemloft.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0e61fa9e-fec6-5579-76f4-317b77ce80aa@gmail.com>
Date:   Wed, 15 May 2019 17:02:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190505.112531.600819597326525048.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/19 11:25 AM, David Miller wrote:
> From: Al Viro <viro@zeniv.linux.org.uk>
> Date: Sun, 5 May 2019 18:59:43 +0100
> 
>> On Sun, May 05, 2019 at 10:04:21AM -0700, David Miller wrote:
>>> From: Al Viro <viro@zeniv.linux.org.uk>
>>> Date: Thu, 2 May 2019 17:32:23 +0100
>>>
>>>> it appears that we might take freeing the socket itself to the
>>>> RCU-delayed part, along with socket->wq.  And doing that has
>>>> an interesting benefit - the only reason to do two separate
>>>> allocation disappears.
>>>
>>> I'm pretty sure we looked into RCU freeing the socket in the
>>> past but ended up not doing so.
>>>
>>> I think it had to do with the latency in releasing sock related
>>> objects.
>>>
>>> However, I might be confusing "struct socket" with "struct sock"
>>
>> Erm...  the only object with changed release time is the memory
>> occupied by struct sock_alloc.  Currently:
>> final iput of socket
>> 	schedule RCU-delayed kfree() of socket->wq
>> 	kfree() of socket
>> With this change:
>> final iput of socket
>> 	schedule RCU-delayed kfree() of coallocated socket and socket->wq
>>
>> So it would have to be a workload where tons of sockets are created and
>> torn down, where RCU-delayed freeing of socket_wq is an inevitable evil,
>> but freeing struct socket_alloc itself must be done immediately, to
>> reduce the memory pressure.  Or am I misreading you?
> 
> I think I was remembering trying to RCU "struct sock" release because
> those 'sk' refer to SKBs and stuff like that.
> 
> So, what you are proposing looks fine.
> 

It will also allow us to no longer use sk_callback_lock in some cases since sock,
and file will both be rcu protected.

Random example :

diff --git a/net/netfilter/nf_log_common.c b/net/netfilter/nf_log_common.c
index 3a0d6880b7c9f4710f27840c9119b48982ce201c..62fae9d9843befe95b6de1610e9d6f4baa011201 100644
--- a/net/netfilter/nf_log_common.c
+++ b/net/netfilter/nf_log_common.c
@@ -135,17 +135,22 @@ EXPORT_SYMBOL_GPL(nf_log_dump_tcp_header);
 void nf_log_dump_sk_uid_gid(struct net *net, struct nf_log_buf *m,
                            struct sock *sk)
 {
+       struct socket *sock;
+
        if (!sk || !sk_fullsock(sk) || !net_eq(net, sock_net(sk)))
                return;
 
-       read_lock_bh(&sk->sk_callback_lock);
-       if (sk->sk_socket && sk->sk_socket->file) {
-               const struct cred *cred = sk->sk_socket->file->f_cred;
+       rcu_read_lock();
+       /* could use rcu_dereference() if sk_socket was __rcu annotated */
+       sock = READ_ONCE(sk->sk_socket);
+       if (sock && sock->file) {
+               const struct cred *cred = sock->file->f_cred;
+
                nf_log_buf_add(m, "UID=%u GID=%u ",
                        from_kuid_munged(&init_user_ns, cred->fsuid),
                        from_kgid_munged(&init_user_ns, cred->fsgid));
        }
-       read_unlock_bh(&sk->sk_callback_lock);
+       rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(nf_log_dump_sk_uid_gid);
 


