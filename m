Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480033DA5E9
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 16:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239059AbhG2OKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 10:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239148AbhG2OI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 10:08:27 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C615C08EAF0;
        Thu, 29 Jul 2021 07:02:12 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id k1so7060250plt.12;
        Thu, 29 Jul 2021 07:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sC0RxXaBHF8bVVFQScILDosn557UeHIRNJqc1N05wY0=;
        b=s8cBYF+OaNkTtZszeh88AESli5UFUYhuH9jgv8uhgSSv37d/02MjOKKv5HdRn6zCGT
         MKk9cgj+ANjYjh3E4RalKiWJjbKKuwSPJuFtTvdVcY6pq2K7xQ8F3TgTNZ4HXccOTIG4
         /nq1fB/c1OJS+AdexjqfB7Rat1i6xut++TZRWE34XiEgV6taWwn2SzveP9GDK1EAMrna
         AUlkoEt/hMSfpED4DpgIdPJo/cCB+TQiP1Fdp5OH4YPlCUo7DxHhp3rjnecMlp6+tp8h
         rgbtl6Y8ENLOmEBtxb7+ubfkz2RpbBrkei0IVyELVNAv5jemUVzxa6anZCrBGrrmuOya
         dBcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sC0RxXaBHF8bVVFQScILDosn557UeHIRNJqc1N05wY0=;
        b=BiayIssB65m5UOy1nxTqUoxP3crNqC9C/bvLXz3f481PxahM1YqRMgVr9h7BsTIWiz
         4Ww2C6B6/tK8dfx0JRJ/pAOF7v1woYfMvT28E+i8H+wT2JtuJWR1sTTy7E8QiQNcmYkR
         5HqGRPmSXRyXf8+4cS5w427MUUh3PP8VFzpAwpjd33JM+jBClajPBTcpNEkbKppId0Ot
         AEpTR4y4TFR2HON/EeQxHvW7PqQ2s/Gfbk2SeblpjHJTneQemC79+H3dYx7LXxu4+pGE
         fa3VSxMHGJ45YRGtT1Z6d4Gv5m5kX5xYHV1U1wkWOvcabLz5MwQmYO+TRBtekPt+9YqC
         ugTA==
X-Gm-Message-State: AOAM53137OUvvLtiQqyLSvPtjoG10QWP2t2nAryiL1Fm96PobSUd1s5D
        IS0XwLcwTqEBB4g9aKcV04M=
X-Google-Smtp-Source: ABdhPJzB/FbzO+7bV94OfSl/6NiWIooTKaeoOoi0TVD8u1h5RkyvCzkMOGJCxC31R783LE+0iFwgOA==
X-Received: by 2002:a65:5a83:: with SMTP id c3mr2226286pgt.321.1627567332086;
        Thu, 29 Jul 2021 07:02:12 -0700 (PDT)
Received: from [192.168.1.237] ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id w11sm3501921pjr.44.2021.07.29.07.02.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 07:02:11 -0700 (PDT)
Subject: Re: [PATCH v4] Bluetooth: schedule SCO timeouts with delayed_work
To:     Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        skhan@linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
References: <20210728071721.411669-1-desmondcheongzx@gmail.com>
 <565F72A4-F9B6-430F-A35D-8EAC7545C141@holtmann.org>
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Message-ID: <3d665eac-2262-a618-2729-850de317c8ea@gmail.com>
Date:   Thu, 29 Jul 2021 22:02:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <565F72A4-F9B6-430F-A35D-8EAC7545C141@holtmann.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On 29/7/21 7:30 pm, Marcel Holtmann wrote:
> Hi Desmond,
> 
>> struct sock.sk_timer should be used as a sock cleanup timer. However,
>> SCO uses it to implement sock timeouts.
>>
>> This causes issues because struct sock.sk_timer's callback is run in
>> an IRQ context, and the timer callback function sco_sock_timeout takes
>> a spin lock on the socket. However, other functions such as
>> sco_conn_del, sco_conn_ready, rfcomm_connect_ind, and
>> bt_accept_enqueue also take the spin lock with interrupts enabled.
>>
>> This inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} lock usage could
>> lead to deadlocks as reported by Syzbot [1]:
>>        CPU0
>>        ----
>>   lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
>>   <Interrupt>
>>     lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
>>
>> To fix this, we use delayed work to implement SCO sock timouts
>> instead. This allows us to avoid taking the spin lock on the socket in
>> an IRQ context, and corrects the misuse of struct sock.sk_timer.
>>
>> Link: https://syzkaller.appspot.com/bug?id=9089d89de0502e120f234ca0fc8a703f7368b31e [1]
>> Reported-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
>> Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
>> ---
>>
>> Hi,
>>
>> As suggested, this patch addresses the inconsistent lock state while
>> avoiding having to deal with local_bh_disable.
>>
>> Now that sco_sock_timeout is no longer run in IRQ context, it might
>> be the case that bh_lock_sock is no longer needed to sync between
>> SOFTIRQ and user contexts, so we can switch to lock_sock.
>>
>> I'm not too certain about this, or if there's any benefit to using
>> lock_sock instead, so I've left that out of this patch.
> 
> I don’t see a reason why we can’t switch to lock_sock, but lets do that in a separate patch in case I missed something it is easier to revert.
> 

Sounds good to me.

After further investigation, I believe the switch to lock_sock is needed 
to prevent calls to sco_sock_set_timer while we're trying to remove a 
connection or socket.

Right now _set_timer is called under lock_sock, whereas _clear_timer is 
sometimes called under lock_sock, sometimes under bh_lock_sock, and 
sometimes under no lock. It seems to me that there's potential races 
here. For example:

         CPU0                    CPU1
         ----                    ----
    lock_sock();
                                 bh_lock_sock();
                                 sco_sock_clear_timer();
    sco_sock_set_timer();
                                 sco_chan_del();

So calls to _clear_timer and _set_timer need to be consolidated under 
lock_sock.

But before that there's a circular lock dependency that's currently 
hidden. When changing bh_lock_sock to lock_sock in sco.c, we get a chain 
of sk_lock-AF_BLUETOOTH-BTPROTO_SCO --> &hdev->lock --> hci_cb_list_lock

Assuming that the proper lock hierarchy (from outer to inner) should be 
&hdev->lock --> hci_cb_list_lock --> sk_lock-AF_BLUETOOTH-BTPROTO_SCO,
then the inversion happens in sco_sock_connect where we call lock_sock 
before hci_dev_lock.

So probably this fix needs to happen in a series like so:
- schedule SCO timeouts with delayed_work (which removes the SOFTIRQ)
- break the circular dependency (which enables the switch to lock_sock)
- switch to lock_sock while moving calls to _clear_timer under the lock

Thoughts?

>>
>> v3 -> v4:
>> - Switch to using delayed_work to schedule SCO sock timeouts instead
>> of using local_bh_disable. As suggested by Luiz Augusto von Dentz.
>>
>> v2 -> v3:
>> - Split SCO and RFCOMM code changes, as suggested by Luiz Augusto von
>> Dentz.
>> - Simplify local bh disabling in SCO by using local_bh_disable/enable
>> inside sco_chan_del since local_bh_disable/enable pairs are reentrant.
>>
>> v1 -> v2:
>> - Instead of pulling out the clean-up code out from sco_chan_del and
>> using it directly in sco_conn_del, disable local softirqs for relevant
>> sections.
>> - Disable local softirqs more thoroughly for instances of
>> bh_lock_sock/bh_lock_sock_nested in the bluetooth subsystem.
>> Specifically, the calls in af_bluetooth.c and rfcomm/sock.c are now made
>> with local softirqs disabled as well.
>>
>> Best wishes,
>> Desmond
>>
>> net/bluetooth/sco.c | 39 ++++++++++++++++++++++++---------------
>> 1 file changed, 24 insertions(+), 15 deletions(-)
>>
>> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
>> index 3bd41563f118..b6dd16153d38 100644
>> --- a/net/bluetooth/sco.c
>> +++ b/net/bluetooth/sco.c
>> @@ -48,6 +48,8 @@ struct sco_conn {
>> 	spinlock_t	lock;
>> 	struct sock	*sk;
>>
>> +	struct delayed_work	sk_timer;
>> +
> 
> I don’t like the sk_timer name. That is confusing. Maybe better use timeout_work or to_work. The sk_* are really more struct sock fields (hence the sk->sk_xyz naming schema).
> 

Thanks for the feedback. timeout_work sounds good to me, I'll make the 
update.

>> 	unsigned int    mtu;
>> };
>>
>> @@ -74,9 +76,11 @@ struct sco_pinfo {
>> #define SCO_CONN_TIMEOUT	(HZ * 40)
>> #define SCO_DISCONN_TIMEOUT	(HZ * 2)
>>
>> -static void sco_sock_timeout(struct timer_list *t)
>> +static void sco_sock_timeout(struct work_struct *work)
>> {
>> -	struct sock *sk = from_timer(sk, t, sk_timer);
>> +	struct sco_conn *conn = container_of(work, struct sco_conn,
>> +					     sk_timer.work);
>> +	struct sock *sk = conn->sk;
>>
>> 	BT_DBG("sock %p state %d", sk, sk->sk_state);
>>
>> @@ -89,16 +93,18 @@ static void sco_sock_timeout(struct timer_list *t)
>> 	sock_put(sk);
>> }
>>
>> -static void sco_sock_set_timer(struct sock *sk, long timeout)
>> +static void sco_sock_set_timer(struct sock *sk, struct delayed_work *work,
>> +			       long timeout)
>> {
> 
> I don’t get the extra variable here. Can we not just pass in struct hci_conn.
> 
> 

Right, the extra variable isn't needed.

I think either struct hci_conn or struct sock should go in there. But as 
Luiz suggested in another email, perhaps struct sock would be a better 
candidate.

This is because sometimes we need to check whether sock has been added 
to a connection before calling sco_sock_clear_timer, e.g. in 
sco_sock_shutdown or sco_sock_close. So might as well consolidate all 
the checks and dereferences into sco_sock_{set/clear}_timer.

>> 	BT_DBG("sock %p state %d timeout %ld", sk, sk->sk_state, timeout);
>> -	sk_reset_timer(sk, &sk->sk_timer, jiffies + timeout);
>> +	cancel_delayed_work(work);
>> +	schedule_delayed_work(work, timeout);
>> }
>>
>> -static void sco_sock_clear_timer(struct sock *sk)
>> +static void sco_sock_clear_timer(struct sock *sk, struct delayed_work *work)
>> {
>> 	BT_DBG("sock %p state %d", sk, sk->sk_state);
>> -	sk_stop_timer(sk, &sk->sk_timer);
>> +	cancel_delayed_work(work);
> 
> Same as above, we pass in struct sock just for the debug message.
> 
>> }
>>
>> /* ---- SCO connections ---- */
>> @@ -174,7 +180,7 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
>> 	if (sk) {
>> 		sock_hold(sk);
>> 		bh_lock_sock(sk);
>> -		sco_sock_clear_timer(sk);
>> +		sco_sock_clear_timer(sk, &conn->sk_timer);
>> 		sco_chan_del(sk, err);
>> 		bh_unlock_sock(sk);
>> 		sco_sock_kill(sk);
>> @@ -193,6 +199,8 @@ static void __sco_chan_add(struct sco_conn *conn, struct sock *sk,
>> 	sco_pi(sk)->conn = conn;
>> 	conn->sk = sk;
>>
>> +	INIT_DELAYED_WORK(&conn->sk_timer, sco_sock_timeout);
>> +
>> 	if (parent)
>> 		bt_accept_enqueue(parent, sk, true);
>> }
>> @@ -260,11 +268,11 @@ static int sco_connect(struct sock *sk)
>> 		goto done;
>>
>> 	if (hcon->state == BT_CONNECTED) {
>> -		sco_sock_clear_timer(sk);
>> +		sco_sock_clear_timer(sk, &conn->sk_timer);
>> 		sk->sk_state = BT_CONNECTED;
>> 	} else {
>> 		sk->sk_state = BT_CONNECT;
>> -		sco_sock_set_timer(sk, sk->sk_sndtimeo);
>> +		sco_sock_set_timer(sk, &conn->sk_timer, sk->sk_sndtimeo);
>> 	}
>>
>> done:
>> @@ -419,7 +427,8 @@ static void __sco_sock_close(struct sock *sk)
>> 	case BT_CONFIG:
>> 		if (sco_pi(sk)->conn->hcon) {
>> 			sk->sk_state = BT_DISCONN;
>> -			sco_sock_set_timer(sk, SCO_DISCONN_TIMEOUT);
>> +			sco_sock_set_timer(sk, &sco_pi(sk)->conn->sk_timer,
>> +					   SCO_DISCONN_TIMEOUT);
>> 			sco_conn_lock(sco_pi(sk)->conn);
>> 			hci_conn_drop(sco_pi(sk)->conn->hcon);
>> 			sco_pi(sk)->conn->hcon = NULL;
>> @@ -443,7 +452,8 @@ static void __sco_sock_close(struct sock *sk)
>> /* Must be called on unlocked socket. */
>> static void sco_sock_close(struct sock *sk)
>> {
>> -	sco_sock_clear_timer(sk);
>> +	if (sco_pi(sk)->conn)
>> +		sco_sock_clear_timer(sk, &sco_pi(sk)->conn->sk_timer);
>> 	lock_sock(sk);
>> 	__sco_sock_close(sk);
>> 	release_sock(sk);
>> @@ -500,8 +510,6 @@ static struct sock *sco_sock_alloc(struct net *net, struct socket *sock,
>>
>> 	sco_pi(sk)->setting = BT_VOICE_CVSD_16BIT;
>>
>> -	timer_setup(&sk->sk_timer, sco_sock_timeout, 0);
>> -
>> 	bt_sock_link(&sco_sk_list, sk);
>> 	return sk;
>> }
>> @@ -1036,7 +1044,8 @@ static int sco_sock_shutdown(struct socket *sock, int how)
>>
>> 	if (!sk->sk_shutdown) {
>> 		sk->sk_shutdown = SHUTDOWN_MASK;
>> -		sco_sock_clear_timer(sk);
>> +		if (sco_pi(sk)->conn)
>> +			sco_sock_clear_timer(sk, &sco_pi(sk)->conn->sk_timer);
>> 		__sco_sock_close(sk);
>>
>> 		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
>> @@ -1083,7 +1092,7 @@ static void sco_conn_ready(struct sco_conn *conn)
>> 	BT_DBG("conn %p", conn);
>>
>> 	if (sk) {
>> -		sco_sock_clear_timer(sk);
>> +		sco_sock_clear_timer(sk, &conn->sk_timer);
>> 		bh_lock_sock(sk);
>> 		sk->sk_state = BT_CONNECTED;
>> 		sk->sk_state_change(sk);
> 
> Other than these minor cleanups, this looks great.
> 
> Regards
> 
> Marcel
> 

