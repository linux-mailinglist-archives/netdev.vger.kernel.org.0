Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F3F3E3EA0
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 06:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhHIEE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 00:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhHIEE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 00:04:56 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84122C06175F;
        Sun,  8 Aug 2021 21:04:35 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so32492472pjr.1;
        Sun, 08 Aug 2021 21:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eNi4we5Lj3P0boB7zoQskLvhgnVQduuUdy+Ns6p58HE=;
        b=YDt9z6rLaccx1u0yUAfrM7DK/uxTQ6Nlp13+xA0vzNa1rTc7G1oj4vSqsx1ldYcHgB
         pabCS1FQy5SJkUUKH9mcG6cGpKFo7no5KxcT27/7sfjvL1mNhDsKssSWySolFmtgqah5
         PhCwOvLrUau44MOEhdILNGo8i2Jgr23ctRqplqYl3khcnea/T73tBYE6bMKtNgKJL2Rj
         z+ttB/IG8YD2GSVNEYh8stXB45APkW1F58VOT3DaSMg8l9tkjUrzvrM6ZHjD7cSxQAnh
         6cuzURAT/TvQxHn4+P9/h37xiV46u4V+xyo5DFwkX27xYiA/08/PZCPFfsMcu9uEFx+p
         z1ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eNi4we5Lj3P0boB7zoQskLvhgnVQduuUdy+Ns6p58HE=;
        b=S+8VLTh/FBUPWCzWayLpBJ6ahAW4S02LqwXum7rTqmObgkNJXqaTHhlOXW9YWnUBgJ
         D0J4KUL5SmrzluxZn5cjqhmnyno4KoQjIjzUIIvAeEp87SATVe4xHNTdctNOyLvtpZuQ
         XXBDXKkGl25RXPUeGgHPkx1GVJtYIOtZMAnTZZ/HbyADqyJ6+rVPd/w1k0/ezokvWGCz
         GH5NrCpVIbZZMAhO7qpZvkggJzaxcpaICVc1UnahfI3IBOKnJusFlCu4PPzKQSwBjQ8F
         ivWdne4ziY6S17OWPpd3BqEyHUE9qJl0KIyOHB0jvPh1uZd3qSLpRR0YqHR02mEMVmSv
         2GrA==
X-Gm-Message-State: AOAM532tGRISLMKn4O0bWlhDN0Hrmo5pZsVOCSIoiGaQKOXzgkFs2nXA
        7JP7KyNUlEKoJjgS1MvHeVI=
X-Google-Smtp-Source: ABdhPJzKsNieWaXKHjzR8XFdQkm3Z+XdF11LKiu478zAdzcIqvEfqrbUOjN22K2e8i3fhC5rJi0Hnw==
X-Received: by 2002:a17:90a:70c5:: with SMTP id a5mr17338389pjm.23.1628481874879;
        Sun, 08 Aug 2021 21:04:34 -0700 (PDT)
Received: from [192.168.1.237] ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id p17sm20181911pjg.54.2021.08.08.21.04.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Aug 2021 21:04:34 -0700 (PDT)
Subject: Re: [RESEND PATCH v5 1/6] Bluetooth: schedule SCO timeouts with
 delayed_work
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, sudipm.mukherjee@gmail.com,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        skhan@linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
References: <20210804154712.929986-1-desmondcheongzx@gmail.com>
 <20210804154712.929986-2-desmondcheongzx@gmail.com>
 <CABBYNZ+5-wEyLJDUU0fC3fogAkJiXD+8np_8c_M0yfYZVUYbww@mail.gmail.com>
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Message-ID: <0fc64ddd-45f0-667f-b8cb-bd958280586f@gmail.com>
Date:   Mon, 9 Aug 2021 12:04:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CABBYNZ+5-wEyLJDUU0fC3fogAkJiXD+8np_8c_M0yfYZVUYbww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/8/21 3:06 am, Luiz Augusto von Dentz wrote:
> Hi Desmond,
> 
> On Wed, Aug 4, 2021 at 8:48 AM Desmond Cheong Zhi Xi
> <desmondcheongzx@gmail.com> wrote:
>>
>> struct sock.sk_timer should be used as a sock cleanup timer. However,
>> SCO uses it to implement sock timeouts.
>>
>> This causes issues because struct sock.sk_timer's callback is run in
>> an IRQ context, and the timer callback function sco_sock_timeout takes
>> a spin lock on the socket. However, other functions such as
>> sco_conn_del and sco_conn_ready take the spin lock with interrupts
>> enabled.
>>
>> This inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} lock usage could
>> lead to deadlocks as reported by Syzbot [1]:
>>         CPU0
>>         ----
>>    lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
>>    <Interrupt>
>>      lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
>>
>> To fix this, we use delayed work to implement SCO sock timouts
>> instead. This allows us to avoid taking the spin lock on the socket in
>> an IRQ context, and corrects the misuse of struct sock.sk_timer.
>>
>> As a note, cancel_delayed_work is used instead of
>> cancel_delayed_work_sync in sco_sock_set_timer and
>> sco_sock_clear_timer to avoid a deadlock. In the future, the call to
>> bh_lock_sock inside sco_sock_timeout should be changed to lock_sock to
>> synchronize with other functions using lock_sock. However, since
>> sco_sock_set_timer and sco_sock_clear_timer are sometimes called under
>> the locked socket (in sco_connect and __sco_sock_close),
>> cancel_delayed_work_sync might cause them to sleep until an
>> sco_sock_timeout that has started finishes running. But
>> sco_sock_timeout would also sleep until it can grab the lock_sock.
>>
>> Using cancel_delayed_work is fine because sco_sock_timeout does not
>> change from run to run, hence there is no functional difference
>> between:
>> 1. waiting for a timeout to finish running before scheduling another
>> timeout
>> 2. scheduling another timeout while a timeout is running.
>>
>> Link: https://syzkaller.appspot.com/bug?id=9089d89de0502e120f234ca0fc8a703f7368b31e [1]
>> Reported-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
>> Tested-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
>> Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
>> ---
>>   net/bluetooth/sco.c | 41 +++++++++++++++++++++++++++++++++++------
>>   1 file changed, 35 insertions(+), 6 deletions(-)
>>
>> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
>> index ffa2a77a3e4c..89cb987ca9eb 100644
>> --- a/net/bluetooth/sco.c
>> +++ b/net/bluetooth/sco.c
>> @@ -48,6 +48,8 @@ struct sco_conn {
>>          spinlock_t      lock;
>>          struct sock     *sk;
>>
>> +       struct delayed_work     timeout_work;
>> +
>>          unsigned int    mtu;
>>   };
>>
>> @@ -74,9 +76,20 @@ struct sco_pinfo {
>>   #define SCO_CONN_TIMEOUT       (HZ * 40)
>>   #define SCO_DISCONN_TIMEOUT    (HZ * 2)
>>
>> -static void sco_sock_timeout(struct timer_list *t)
>> +static void sco_sock_timeout(struct work_struct *work)
>>   {
>> -       struct sock *sk = from_timer(sk, t, sk_timer);
>> +       struct sco_conn *conn = container_of(work, struct sco_conn,
>> +                                            timeout_work.work);
>> +       struct sock *sk;
>> +
>> +       sco_conn_lock(conn);
>> +       sk = conn->sk;
>> +       if (sk)
>> +               sock_hold(sk);
>> +       sco_conn_unlock(conn);
>> +
>> +       if (!sk)
>> +               return;
>>
>>          BT_DBG("sock %p state %d", sk, sk->sk_state);
>>
>> @@ -91,14 +104,27 @@ static void sco_sock_timeout(struct timer_list *t)
>>
>>   static void sco_sock_set_timer(struct sock *sk, long timeout)
>>   {
>> +       struct delayed_work *work;
> 
> Minor nitpick but I don't think using a dedicated variable here makes
> much sense.
> 

Thanks for the feedback, Luiz. Agreed, I can make the change in the next 
version of the series after the other patches are reviewed.

Best wishes,
Desmond

>> +       if (!sco_pi(sk)->conn)
>> +               return;
>> +       work = &sco_pi(sk)->conn->timeout_work;
>> +
>>          BT_DBG("sock %p state %d timeout %ld", sk, sk->sk_state, timeout);
>> -       sk_reset_timer(sk, &sk->sk_timer, jiffies + timeout);
>> +       cancel_delayed_work(work);
>> +       schedule_delayed_work(work, timeout);
>>   }
>>
>>   static void sco_sock_clear_timer(struct sock *sk)
>>   {
>> +       struct delayed_work *work;
> 
> Ditto.
> 
>> +       if (!sco_pi(sk)->conn)
>> +               return;
>> +       work = &sco_pi(sk)->conn->timeout_work;
>> +
>>          BT_DBG("sock %p state %d", sk, sk->sk_state);
>> -       sk_stop_timer(sk, &sk->sk_timer);
>> +       cancel_delayed_work(work);
>>   }
>>
>>   /* ---- SCO connections ---- */
>> @@ -179,6 +205,9 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
>>                  bh_unlock_sock(sk);
>>                  sco_sock_kill(sk);
>>                  sock_put(sk);
>> +
>> +               /* Ensure no more work items will run before freeing conn. */
>> +               cancel_delayed_work_sync(&conn->timeout_work);
>>          }
>>
>>          hcon->sco_data = NULL;
>> @@ -193,6 +222,8 @@ static void __sco_chan_add(struct sco_conn *conn, struct sock *sk,
>>          sco_pi(sk)->conn = conn;
>>          conn->sk = sk;
>>
>> +       INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
>> +
>>          if (parent)
>>                  bt_accept_enqueue(parent, sk, true);
>>   }
>> @@ -500,8 +531,6 @@ static struct sock *sco_sock_alloc(struct net *net, struct socket *sock,
>>
>>          sco_pi(sk)->setting = BT_VOICE_CVSD_16BIT;
>>
>> -       timer_setup(&sk->sk_timer, sco_sock_timeout, 0);
>> -
>>          bt_sock_link(&sco_sk_list, sk);
>>          return sk;
>>   }
>> --
>> 2.25.1
>>
> 
> 

