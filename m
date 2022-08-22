Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794EE59C017
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 15:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbiHVNFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 09:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbiHVNFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 09:05:31 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F47E1CB31;
        Mon, 22 Aug 2022 06:05:30 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id r14-20020a17090a4dce00b001faa76931beso13928372pjl.1;
        Mon, 22 Aug 2022 06:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=SqqUKybCNm5OY78yBFoExZfJpyRi1vlWaSZzNzjwOi4=;
        b=ZmnZOe98e9Pfi/OvTveAdMo+sx0IH2pkeNeix40MHIYIPNgAZEbEjGO3sVtWKFpSTj
         Uv2SCoH+AJQy+edkC31khKdnKzUAcYSQ0m95oJcAHIyQP5BAJ8D9HGovZkNCXA9de8d2
         tMNPm6titCzd2QRUccqmMmuNudBkmLckBPL2U+n+XfAdLW/9UGuqWR8TsyVVrFjC0byg
         /FXmhBk3PANHyv4/5NgEtgLDpVK63+ZhwszYyIJmBJyPReGtOf1AiJC3mKJ+QqdutUI7
         I/gmpDKT1CyQwvFcNaNdO4MVs4dOH381CwvbGT2lJNcZEcQqLIrR5qhT8IZTa8UFarKz
         8dnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=SqqUKybCNm5OY78yBFoExZfJpyRi1vlWaSZzNzjwOi4=;
        b=uh3qV1eBwOPy/2RoltC/15ED5qSnZRsJIG2EFh0+t8q/0KuI1T96wsTRS0HxvrUQcZ
         aeZj66m8COO0OOXe7HfelEShv7I9nt8SJjuZaS4+prwpvEAuum/BOSu3UqYJtNCIN32n
         mb+iQ8S1BvL0U42xWFEaUcp35xUkr0y9jel9cBcNib5XpXJ5O+QooEFxIwY/yWP/5dLy
         zUSecTrnM6XP3oCGBIkxa5xUcNKsQRgdqc9qIrMTCjaNJVhDiVw3FTkegzokHmWdiICr
         Jfu4sjg+S164SPVfJN5lrf84yBF1naRehHV7dD//V48J5Xac7NY7b8DX1+dt0z/IoyHS
         B07w==
X-Gm-Message-State: ACgBeo0gVRexmdbSqeONbhcjM2LvMH4SzEzC2oZaZALbPSCHo6LGZbDs
        wJyqjtEx+GvPhslGnY98rOM=
X-Google-Smtp-Source: AA6agR6d/4/NvGDCGAUKFRXIMuwufEzIWmrg/XULcAkHiKdXlmbYdcz1cNorX2/CKlfPYPNo4F0wcw==
X-Received: by 2002:a17:902:f684:b0:172:d54d:6f9e with SMTP id l4-20020a170902f68400b00172d54d6f9emr10317923plg.174.1661173529224;
        Mon, 22 Aug 2022 06:05:29 -0700 (PDT)
Received: from localhost ([36.112.86.8])
        by smtp.gmail.com with ESMTPSA id j5-20020a170903024500b0016be5f24aaesm8410010plh.163.2022.08.22.06.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 06:05:28 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     yin31149@gmail.com, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-afs@lists.infradead.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        paskripkin@gmail.com,
        syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] rxrpc: fix bad unlock balance in rxrpc_do_sendmsg
Date:   Mon, 22 Aug 2022 21:04:14 +0800
Message-Id: <20220822130414.28489-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220822112952.2961-1-yin31149@gmail.com>
References: <20220822112952.2961-1-yin31149@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Aug 2022 at 19:30, Hawkins Jiawei <yin31149@gmail.com> wrote:
>
> On Mon, 22 Aug 2022 at 16:48, David Howells <dhowells@redhat.com> wrote:
> >
> > Hawkins Jiawei <yin31149@gmail.com> wrote:
> >
> > > -             if (mutex_lock_interruptible(&call->user_mutex) < 0)
> > > +             if (mutex_lock_interruptible(&call->user_mutex) < 0) {
> > > +                     mutex_lock(&call->user_mutex);
> >
> > Yeah, as Khalid points out that kind of makes the interruptible lock
> > pointless.  Either rxrpc_send_data() needs to return a separate indication
> > that we returned without the lock held or it needs to always drop the lock on
> > error (at least for ERESTARTSYS/EINTR) which can be checked for higher up.
> Hi David,
>
> For second option, I think it may meet some difficulty, because we
> cannot figure out whether rxrpc_send_data() meets lock error.
> To be more specific, rxrpc_send_data() may still returns the number
> it has copied even rxrpc_send_data() meets lock error, if
> rxrpc_send_data() has successfully dealed some data.(Please correct me
> if I am wrong)
>
> So I think the first option seems better. I wonder if we can add an
> argument in rxrpc_send_data() as an indication you pointed out? Maybe:
>
> diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
> index 1d38e279e2ef..0801325a7c7f 100644
> --- a/net/rxrpc/sendmsg.c
> +++ b/net/rxrpc/sendmsg.c
> @@ -284,13 +284,18 @@ static int rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
>
>  /*
>   * send data through a socket
> + * @holding_mutex: rxrpc_send_data() will assign this pointer with True
> + * if functions still holds the call user access mutex when returned to caller.
> + * This argument can be NULL, which will effect nothing.
> + *
>   * - must be called in process context
>   * - The caller holds the call user access mutex, but not the socket lock.
>   */
>  static int rxrpc_send_data(struct rxrpc_sock *rx,
>                            struct rxrpc_call *call,
>                            struct msghdr *msg, size_t len,
> -                          rxrpc_notify_end_tx_t notify_end_tx)
> +                          rxrpc_notify_end_tx_t notify_end_tx,
> +                          bool *holding_mutex)
>  {
>         struct rxrpc_skb_priv *sp;
>         struct sk_buff *skb;
> @@ -299,6 +304,9 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
>         bool more;
>         int ret, copied;
>
> +       if (holding_mutex)
> +               *holding_mutex = true;
> +
>         timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
>
>         /* this should be in poll */
> @@ -338,8 +346,11 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
>                                 ret = rxrpc_wait_for_tx_window(rx, call,
>                                                                &timeo,
>                                                                msg->msg_flags & MSG_WAITALL);
> -                               if (ret < 0)
> +                               if (ret < 0) {
> +                                       if (holding_mutex)
> +                                               *holding_mutex = false;
>                                         goto maybe_error;
> +                               }
>                         }
>
>                         /* Work out the maximum size of a packet.  Assume that
> @@ -630,6 +641,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
>         struct rxrpc_call *call;
>         unsigned long now, j;
>         int ret;
> +       bool holding_user_mutex;
>
>         struct rxrpc_send_params p = {
>                 .call.tx_total_len      = -1,
> @@ -747,7 +759,9 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
>                 /* Reply phase not begun or not complete for service call. */
>                 ret = -EPROTO;
>         } else {
> -               ret = rxrpc_send_data(rx, call, msg, len, NULL);
> +               ret = rxrpc_send_data(rx, call, msg, len, NULL, &holding_user_mutex);
> +               if (!holding_user_mutex)
> +                       goto error_put;
>         }
>
>  out_put_unlock:
> @@ -796,7 +810,7 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
>         case RXRPC_CALL_SERVER_ACK_REQUEST:
>         case RXRPC_CALL_SERVER_SEND_REPLY:
>                 ret = rxrpc_send_data(rxrpc_sk(sock->sk), call, msg, len,
> -                                     notify_end_tx);
> +                                     notify_end_tx, NULL);
>                 break;
>         case RXRPC_CALL_COMPLETE:
>                 read_lock_bh(&call->state_lock);
>
> After applying the above patch, kernel still panic, but seems not the
> bad unlock balance bug before. yet I am not sure if this is the same bug you
> mentioned. Kernel output as below:
> [   39.115966][ T6508] ====================================
> [   39.116940][ T6508] WARNING: syz/6508 still has locks held!
> [   39.117978][ T6508] 6.0.0-rc1-00066-g3b06a2755758-dirty #186 Not tainted
> [   39.119353][ T6508] ------------------------------------
> [   39.120321][ T6508] 1 lock held by syz/6508:
> [   39.121122][ T6508]  #0: ffff88801f472b20 (&call->user_mutex){....}-{3:3}0
> [   39.123014][ T6508]
> [   39.123014][ T6508] stack backtrace:
> [   39.123925][ T6508] CPU: 0 PID: 6508 Comm: syz Not tainted 6.0.0-rc1-00066
> [   39.125304][ T6508] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)4
> [   39.125304][ T6508] Call Trace:
> [   39.125304][ T6508]  <TASK>
> [   39.125304][ T6508]  dump_stack_lvl+0x8e/0xdd
> [   39.125304][ T6508]  get_signal+0x1866/0x24d0
> [   39.125304][ T6508]  ? lock_acquire+0x172/0x310
> [   39.125304][ T6508]  ? exit_signals+0x7b0/0x7b0
> [   39.125304][ T6508]  arch_do_signal_or_restart+0x82/0x23f0
> [   39.125304][ T6508]  ? __sanitizer_cov_trace_pc+0x1a/0x40
> [   39.125304][ T6508]  ? __fget_light+0x20d/0x270
> [   39.125304][ T6508]  ? get_sigframe_size+0x10/0x10
> [   39.125304][ T6508]  ? __sanitizer_cov_trace_pc+0x1a/0x40
> [   39.125304][ T6508]  ? __sys_sendmsg+0x11a/0x1c0
> [   39.125304][ T6508]  ? __sys_sendmsg_sock+0x30/0x30
> [   39.125304][ T6508]  exit_to_user_mode_prepare+0x146/0x1b0
> [   39.125304][ T6508]  syscall_exit_to_user_mode+0x12/0x30
> [   39.125304][ T6508]  do_syscall_64+0x42/0xb0
> [   39.125304][ T6508]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [   39.125304][ T6508] RIP: 0033:0x44fbad
> [   39.125304][ T6508] Code: c3 e8 97 29 00 00 0f 1f 80 00 00 00 00 f3 0f 1e8
> [   39.125304][ T6508] RSP: 002b:00007f4b8ae22d48 EFLAGS: 00000246 ORIG_RAX:e
> [   39.125304][ T6508] RAX: fffffffffffffffc RBX: 0000000000000000 RCX: 0000d
> [   39.125304][ T6508] RDX: 0000000000000186 RSI: 0000000020000000 RDI: 00003
> [   39.125304][ T6508] RBP: 00007f4b8ae22d80 R08: 00007f4b8ae23700 R09: 00000
> [   39.125304][ T6508] R10: 00007f4b8ae23700 R11: 0000000000000246 R12: 0000e
> [   39.125304][ T6508] R13: 00007ffe483304af R14: 00007ffe48330550 R15: 00000
> [   39.125304][ T6508]  </TASK>
> ====================================
>
> I will make a deeper look and try to patch it.
The cause is that patch assigns False to pointer holding_mutex in
rxrpc_send_data() by only juding whether the return value from
rxrpc_wait_for_tx_window() is less than 0, yet this is not correct.

So we should just only assign False to holding_mutex when
unlocking the call->user_mutex in rxrpc_wait_for_tx_window_intr().
Maybe:
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 1d38e279e2ef..1050cc2f5c89 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -33,11 +33,16 @@ static bool rxrpc_check_tx_space(struct rxrpc_call *call, rxrpc_seq_t *_tx_win)
 }
 
 /*
+ * @holding_mutex: An indication whether caller can still holds
+ * the call->user_mutex when returned to caller.
+ * This argument can be NULL, which will effect nothing.
+ *
  * Wait for space to appear in the Tx queue or a signal to occur.
  */
 static int rxrpc_wait_for_tx_window_intr(struct rxrpc_sock *rx,
 					 struct rxrpc_call *call,
-					 long *timeo)
+					 long *timeo,
+					 bool *holding_mutex)
 {
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -53,8 +58,11 @@ static int rxrpc_wait_for_tx_window_intr(struct rxrpc_sock *rx,
 		trace_rxrpc_transmit(call, rxrpc_transmit_wait);
 		mutex_unlock(&call->user_mutex);
 		*timeo = schedule_timeout(*timeo);
-		if (mutex_lock_interruptible(&call->user_mutex) < 0)
+		if (mutex_lock_interruptible(&call->user_mutex) < 0) {
+			if (holding_mutex)
+				*holding_mutex = false;
 			return sock_intr_errno(*timeo);
+		}
 	}
 }
 
@@ -121,13 +129,18 @@ static int rxrpc_wait_for_tx_window_nonintr(struct rxrpc_sock *rx,
 }
 
 /*
+ * @holding_mutex: An indication whether caller can still holds
+ * the call->user_mutex when returned to caller.
+ * This argument can be NULL, which will effect nothing.
+ *
  * wait for space to appear in the transmit/ACK window
  * - caller holds the socket locked
  */
 static int rxrpc_wait_for_tx_window(struct rxrpc_sock *rx,
 				    struct rxrpc_call *call,
 				    long *timeo,
-				    bool waitall)
+				    bool waitall,
+				    bool *holding_mutex)
 {
 	DECLARE_WAITQUEUE(myself, current);
 	int ret;
@@ -142,7 +155,7 @@ static int rxrpc_wait_for_tx_window(struct rxrpc_sock *rx,
 		if (waitall)
 			ret = rxrpc_wait_for_tx_window_waitall(rx, call);
 		else
-			ret = rxrpc_wait_for_tx_window_intr(rx, call, timeo);
+			ret = rxrpc_wait_for_tx_window_intr(rx, call, timeo, holding_mutex);
 		break;
 	case RXRPC_PREINTERRUPTIBLE:
 	case RXRPC_UNINTERRUPTIBLE:
@@ -284,13 +297,19 @@ static int rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 
 /*
  * send data through a socket
+ *
+ * @holding_mutex: An indication whether caller can still holds
+ * the call->user_mutex when returned to caller.
+ * This argument can be NULL, which will effect nothing.
+ *
  * - must be called in process context
  * - The caller holds the call user access mutex, but not the socket lock.
  */
 static int rxrpc_send_data(struct rxrpc_sock *rx,
 			   struct rxrpc_call *call,
 			   struct msghdr *msg, size_t len,
-			   rxrpc_notify_end_tx_t notify_end_tx)
+			   rxrpc_notify_end_tx_t notify_end_tx,
+			   bool *holding_mutex)
 {
 	struct rxrpc_skb_priv *sp;
 	struct sk_buff *skb;
@@ -299,6 +318,13 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 	bool more;
 	int ret, copied;
 
+	/*
+	 * The caller holds the call->user_mutex when calls
+	 * rxrpc_send_data(), so initial it with True
+	 */
+	if (holding_mutex)
+		*holding_mutex = true;
+
 	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 
 	/* this should be in poll */
@@ -337,7 +363,8 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 					goto maybe_error;
 				ret = rxrpc_wait_for_tx_window(rx, call,
 							       &timeo,
-							       msg->msg_flags & MSG_WAITALL);
+							       msg->msg_flags & MSG_WAITALL,
+							       holding_mutex);
 				if (ret < 0)
 					goto maybe_error;
 			}
@@ -630,6 +657,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 	struct rxrpc_call *call;
 	unsigned long now, j;
 	int ret;
+	bool holding_user_mutex;
 
 	struct rxrpc_send_params p = {
 		.call.tx_total_len	= -1,
@@ -747,7 +775,9 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 		/* Reply phase not begun or not complete for service call. */
 		ret = -EPROTO;
 	} else {
-		ret = rxrpc_send_data(rx, call, msg, len, NULL);
+		ret = rxrpc_send_data(rx, call, msg, len, NULL, &holding_user_mutex);
+		if (!holding_user_mutex)
+			goto error_put;
 	}
 
 out_put_unlock:
@@ -796,7 +826,7 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 	case RXRPC_CALL_SERVER_ACK_REQUEST:
 	case RXRPC_CALL_SERVER_SEND_REPLY:
 		ret = rxrpc_send_data(rxrpc_sk(sock->sk), call, msg, len,
-				      notify_end_tx);
+				      notify_end_tx, NULL);
 		break;
 	case RXRPC_CALL_COMPLETE:
 		read_lock_bh(&call->state_lock);


Reproducer did not trigger any issue locally. I will propose a test by
syzbot. Maybe I will send v2 patch if patch can pass the syzbot tesing.
