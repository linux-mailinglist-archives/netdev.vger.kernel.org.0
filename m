Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065ED4D92C7
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 04:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344524AbiCODEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 23:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbiCODEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 23:04:12 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D77D2BEB;
        Mon, 14 Mar 2022 20:03:01 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id d10-20020a17090a7bca00b001c5ed9a196bso881255pjl.1;
        Mon, 14 Mar 2022 20:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=A455krXMhhy8/LLYYm9vWAWvlzZHEKZiVzhbnonkNws=;
        b=jhcAENCFBWZcmbZIoMa4IBixoqkt2DRSnQnBe9VESilKn4CEEqf3AYoyR3vIQxCdYT
         pJ+KMvc61kTkjENj0c10iWam3OS9WYzsndLB5E34Ru/pUPujcpJbqVYOLXqfKhvd4fot
         XgGUmP9Cr1T5I1WTZkKbsF1ffq004PWTUxMhwfC5XLQsCoShyIrrHRJGUZlHhMfsVEsv
         rmkth4GoRFsGnAcqW5wn6vwbBocXG/NjFw/ENW+cBadja5I4eFnsFvyFcsdz5TixPIcB
         Hl3+OhGXuMwXX84KMLTToAUySmj2HtArumZLaOGNxGf8xnVP6qSTN3A2OkEZFq6OdrfE
         DJDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=A455krXMhhy8/LLYYm9vWAWvlzZHEKZiVzhbnonkNws=;
        b=qQihNDoEpg8sL6a1Znwdl/KZMCeypuGTxQJUSlpVx6D6Fzec5XxR4ZKS2JaPu7VHgT
         5W7F7PUCbAmxw5vt23v4lSbfvykqNf9JbYFus9k313OBxfcyqe9d30tmN/B9FfyyH1v/
         wTbH9H0XwbFIrbgEmmzbOc6jMejaHAJ1GRn2DWePukEOEYrcPlgT+znHF5rdp9dVKxB/
         3xdhYPWmtDCeTUkg19n1cbdNnL+e0Zc3nQJKstYuBMfg1i2Enu4/O3OnfXHs9Tqa9lQP
         z1GPqRMRkc2w6mzSB8YOWmBSHTgm8yGFPDN04pVwQSws2/OsC9fqti+wCgv7FbsOS2GG
         wATg==
X-Gm-Message-State: AOAM532WcS0qe8HgTCxzIWlEOtgauZ27PaVudcHR4H0tgGQ03sQjyzQr
        v29j5CeLB3/YgKb/2sEbnHc=
X-Google-Smtp-Source: ABdhPJxqfei84nWaWhmazei5KQRCXRBg/w+OzFuE2RAB+U8R7E8cDTc51FKfTxQjkb3idYtcSGwKdw==
X-Received: by 2002:a17:902:8a85:b0:151:b3c6:87f8 with SMTP id p5-20020a1709028a8500b00151b3c687f8mr26208994plo.129.1647313380664;
        Mon, 14 Mar 2022 20:03:00 -0700 (PDT)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id w3-20020a63af03000000b00381309eb407sm6290291pge.68.2022.03.14.20.02.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 20:03:00 -0700 (PDT)
Message-ID: <c6052f5c-c1c4-18a0-a04f-e48f366200e4@gmail.com>
Date:   Mon, 14 Mar 2022 20:02:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net V4 2/2] ax25: Fix NULL pointer dereferences in ax25
 timers
Content-Language: en-US
To:     Duoming Zhou <duoming@zju.edu.cn>, linux-hams@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, ralf@linux-mips.org,
        jreuter@yaina.de, dan.carpenter@oracle.com
References: <20220315015654.79941-1-duoming@zju.edu.cn>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220315015654.79941-1-duoming@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/14/22 18:56, Duoming Zhou wrote:
> There are race conditions that may lead to null pointer dereferences in
> ax25_heartbeat_expiry(), ax25_t1timer_expiry(), ax25_t2timer_expiry(),
> ax25_t3timer_expiry() and ax25_idletimer_expiry(), when we use
> ax25_kill_by_device() to detach the ax25 device.
>
> One of the race conditions that cause null pointer dereferences can be
> shown as below:
>
>        (Thread 1)                    |      (Thread 2)
> ax25_connect()                      |
>   ax25_std_establish_data_link()     |
>    ax25_start_t1timer()              |
>     mod_timer(&ax25->t1timer,..)     |
>                                      | ax25_kill_by_device()
>     (wait a time)                    |  ...
>                                      |  s->ax25_dev = NULL; //(1)
>     ax25_t1timer_expiry()            |
>      ax25->ax25_dev->values[..] //(2)|  ...
>       ...                            |
>
> We set null to ax25_cb->ax25_dev in position (1) and dereference
> the null pointer in position (2).
>
> The corresponding fail log is shown below:
> ===============================================================
> BUG: kernel NULL pointer dereference, address: 0000000000000050
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.17.0-rc6-00794-g45690b7d0
> RIP: 0010:ax25_t1timer_expiry+0x12/0x40
> ...
> Call Trace:
>   call_timer_fn+0x21/0x120
>   __run_timers.part.0+0x1ca/0x250
>   run_timer_softirq+0x2c/0x60
>   __do_softirq+0xef/0x2f3
>   irq_exit_rcu+0xb6/0x100
>   sysvec_apic_timer_interrupt+0xa2/0xd0
> ...
>
> This patch uses ax25_disconnect() to delete timers before we set null to
> ax25_cb->ax25_dev in ax25_kill_by_device().The function ax25_disconnect()
> will not return until all timers are stopped, because we have changed
> del_timer() to del_timer_sync(). What`s more, we add condition check in
> ax25_destroy_socket(), because ax25_stop_heartbeat() will not return,
> if there is still heartbeat.
>
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>

Missing FIxes: tag ?


> ---
> Changes in V4:
>    - Based on [PATCH net V4 1/2] ax25: Fix refcount leaks caused by ax25_cb_del().
>
>   net/ax25/af_ax25.c    |  7 ++++---
>   net/ax25/ax25_timer.c | 10 +++++-----
>   2 files changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
> index 0886109421a..dc6161a75a1 100644
> --- a/net/ax25/af_ax25.c
> +++ b/net/ax25/af_ax25.c
> @@ -89,20 +89,20 @@ static void ax25_kill_by_device(struct net_device *dev)
>   			sk = s->sk;
>   			if (!sk) {
>   				spin_unlock_bh(&ax25_list_lock);
> -				s->ax25_dev = NULL;
>   				ax25_disconnect(s, ENETUNREACH);
> +				s->ax25_dev = NULL;
>   				spin_lock_bh(&ax25_list_lock);
>   				goto again;
>   			}
>   			sock_hold(sk);
>   			spin_unlock_bh(&ax25_list_lock);
>   			lock_sock(sk);
> +			ax25_disconnect(s, ENETUNREACH);
>   			s->ax25_dev = NULL;
>   			if (sk->sk_wq) {
>   				dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
>   				ax25_dev_put(ax25_dev);
>   			}
> -			ax25_disconnect(s, ENETUNREACH);
>   			release_sock(sk);
>   			spin_lock_bh(&ax25_list_lock);
>   			sock_put(sk);
> @@ -307,7 +307,8 @@ void ax25_destroy_socket(ax25_cb *ax25)
>   
>   	ax25_cb_del(ax25);
>   
> -	ax25_stop_heartbeat(ax25);
> +	if (!ax25->sk || !sock_flag(ax25->sk, SOCK_DESTROY))
> +		ax25_stop_heartbeat(ax25);
>   	ax25_stop_t1timer(ax25);
>   	ax25_stop_t2timer(ax25);
>   	ax25_stop_t3timer(ax25);
> diff --git a/net/ax25/ax25_timer.c b/net/ax25/ax25_timer.c
> index 85865ebfdfa..99af3d1aeec 100644
> --- a/net/ax25/ax25_timer.c
> +++ b/net/ax25/ax25_timer.c
> @@ -78,27 +78,27 @@ void ax25_start_idletimer(ax25_cb *ax25)
>   
>   void ax25_stop_heartbeat(ax25_cb *ax25)
>   {
> -	del_timer(&ax25->timer);
> +	del_timer_sync(&ax25->timer);
>   }
>   
>   void ax25_stop_t1timer(ax25_cb *ax25)
>   {
> -	del_timer(&ax25->t1timer);
> +	del_timer_sync(&ax25->t1timer);
>   }
>   
>   void ax25_stop_t2timer(ax25_cb *ax25)
>   {
> -	del_timer(&ax25->t2timer);
> +	del_timer_sync(&ax25->t2timer);
>   }
>   
>   void ax25_stop_t3timer(ax25_cb *ax25)
>   {
> -	del_timer(&ax25->t3timer);
> +	del_timer_sync(&ax25->t3timer);
>   }
>   
>   void ax25_stop_idletimer(ax25_cb *ax25)
>   {
> -	del_timer(&ax25->idletimer);
> +	del_timer_sync(&ax25->idletimer);
>   }
>   
>   int ax25_t1timer_running(ax25_cb *ax25)



Are you sure calling del_time_sync() wont deadlock ?


If the timer handlers need a lock owned by the thread calling 
del_timer_sync(),

then this will block forever.


Usually, we make sure each active timer owns a reference 
(sk_stop_timer() for example)




