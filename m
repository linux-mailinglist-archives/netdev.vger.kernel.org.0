Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A84696E37
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 20:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjBNT7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 14:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBNT7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 14:59:42 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE342D161
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 11:59:41 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-501c3a414acso221834127b3.7
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 11:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J46d+mY3wXMo1KZ5M6zYFPdJL7vcAoDANupASROEt20=;
        b=BEu32WwrqObLNoIxKA5LG5lH+cmyStp1HBJeHhNYHNjgIYYiOYpbGA5q/h8djaI2jV
         uAHehORtcXuXwtDMiM4edB4XahVmCBsLqOXcOmhNKgjcFj/Rcwb2xDzGXZkOQSJn/EIP
         eBovtcK/R6Am5n6ZkwsfUkBNndYthgGlmTUICAXF4ygaAERoMRuE/DY3/MDreJeI3DN1
         HXjG2je9/Qmuphs8hTvuU5usKtYmXMU9nEpNAzpID/LDS5ABww+OcKlLv3X5L9RKhoqU
         0HZI9s3vsbel9xR5HOUjx03AT8NaTPC8sFbxBOqBqNZ8b+ZQBiKVenmj7Siehuk78JuW
         HAdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J46d+mY3wXMo1KZ5M6zYFPdJL7vcAoDANupASROEt20=;
        b=3GL+/Fi3rdlsb6we5CDHSwQQ1LPU2lHdbQUIayZD7idAHOVxG8voRcx7j5GiDLdS9z
         z913lMmLkYKC5MUIqtp3eyQT6eLwS0RFQMsDxrWcqcKEoEzponu5SQksymstHWdqo669
         g/eLfIaZqCbJvj33P+hOCNTFamcmirBeNxsdv8pzTtAcke6ByT+J6b21Kb2mRNRPcTXu
         bjnidPAQ2zYbJ2sXIIVRhsPOkxwwQ98LTkOmmkEjW59IDWxNKHXntSyOcn74eqb2x009
         cjbjz1RP2VZhnsSSE2d/x0nhbZ8nUlHosRnbaZfLR17ydR+Y1G+fe7PHhl6BiHgSwW8m
         Yjtg==
X-Gm-Message-State: AO0yUKVK22kIPkgaYt0enYOjf0daGuRhUB5hJOGK+iGOOAdDAIAfhP4p
        8IL3hB1gl0O85+xT4Vc/no4QCJzlZP4aeUChHe36UYg9zVuDEltZKaA=
X-Google-Smtp-Source: AK7set/FD6bxFapIiKzRVU+ti1zDQPGezYDeJ/a6yTv36U52T0zyGX072q2DEA3CYooXEBlKmFKinfqlYNlrrN7MvzY=
X-Received: by 2002:a05:690c:e8f:b0:52e:ca4a:746b with SMTP id
 cq15-20020a05690c0e8f00b0052eca4a746bmr390280ywb.436.1676404780563; Tue, 14
 Feb 2023 11:59:40 -0800 (PST)
MIME-Version: 1.0
References: <2d2ad1e5-8b03-0c59-4cf1-6a5cc85bbd94@cloudflare.com>
 <CANn89iJvOPH9rJ4YjRP-i99beY3g+moLnRQH2ED-CQX7QnDYpA@mail.gmail.com>
 <fd9d9040-1721-b882-885f-71a4aeef9454@cloudflare.com> <CANn89iLMUP8_HnmmstGHxh7iR+EqPdEAUNM7OfyDdHJFNdBu3g@mail.gmail.com>
 <CABEBQimj8Jk659Xb+gNgW_dVub+euLwM6XGrPvkrPaEb=9GH+A@mail.gmail.com>
In-Reply-To: <CABEBQimj8Jk659Xb+gNgW_dVub+euLwM6XGrPvkrPaEb=9GH+A@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 14 Feb 2023 20:59:29 +0100
Message-ID: <CANn89iJvoqq=X=9Kr7GYf=YtBFBOrOkGboKsd7FLdMqYV0PE=A@mail.gmail.com>
Subject: Re: BUG: using __this_cpu_add() in preemptible in tcp_make_synack()
To:     Frank Hofmann <fhofmann@cloudflare.com>
Cc:     Frederick Lawler <fred@cloudflare.com>, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 6:14 PM Frank Hofmann <fhofmann@cloudflare.com> wrote:
>
> Hi Eric,
>
> On Mon, Jan 23, 2023 at 3:49 PM 'Eric Dumazet' via
> kernel-team+notifications <kernel-team@cloudflare.com> wrote:
> >
> > > On 1/18/23 11:07 AM, Eric Dumazet wrote:
> > [ ... ]
> > > > Thanks for the report
> > > >
> > > > I guess this part has been missed in commit 0a375c822497ed6a
> > > >
> > > > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > > > index 71d01cf3c13eb4bd3d314ef140568d2ffd6a499e..ba839e441450f195012a8d77cb9e5ed956962d2f
> > > > 100644
> > > > --- a/net/ipv4/tcp_output.c
> > > > +++ b/net/ipv4/tcp_output.c
> > > > @@ -3605,7 +3605,7 @@ struct sk_buff *tcp_make_synack(const struct
> > > > sock *sk, struct dst_entry *dst,
> [ ... ]
>
> we're still seeing this with a preempt-enabled kernel, in
> tcp_check_req() though, like:
>
> BUG: using __this_cpu_add() in preemptible [00000000] code: nginx-ssl/186233
> caller is tcp_check_req+0x49a/0x660
> CPU: 58 PID: 186233 Comm: nginx-ssl Kdump: loaded Tainted: G
> O       6.1.8-cloudflare-2023.1.16 #1
> Hardware name: ...
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x34/0x48
>  check_preemption_disabled+0xdd/0xe0
>  tcp_check_req+0x49a/0x660
>  tcp_rcv_state_process+0xa3/0x1020
>  ? tcp_sendmsg_locked+0x2a4/0xc50
>  tcp_v4_do_rcv+0xc6/0x280
>  __release_sock+0xb4/0xc0
>  release_sock+0x2b/0x90
>  tcp_sendmsg+0x33/0x40
>  sock_sendmsg+0x5b/0x70
>  sock_write_iter+0x97/0x100
>  vfs_write+0x330/0x3d0
>  ksys_write+0xab/0xe0
>  ? syscall_trace_enter.constprop.0+0x164/0x170
>  do_syscall_64+0x3b/0x90
>  entry_SYSCALL_64_after_hwframe+0x4b/0xb5
>
> There's a notable number of "__"-marked stats updates in
> tcp_check_req(); I can't claim to understand the code well enough if
> all would have to be changed.
> The occurence is infrequent (we see about two a week).
>
> Thanks for any pointers!
> Frank Hofmann

Thanks for the report.

I think the following patch should help, please let me know if any
more issues are detected.

diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index e002f2e1d4f2de0397f2cc7ec0a14a05efbd802b..9a7ef7732c24c94d4a01d5911ebe51f21371a457
100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -597,6 +597,9 @@ EXPORT_SYMBOL(tcp_create_openreq_child);
  * validation and inside tcp_v4_reqsk_send_ack(). Can we do better?
  *
  * We don't need to initialize tmp_opt.sack_ok as we don't use the results
+ *
+ * Note: If @fastopen is true, this can be called from process or BH context.
+ *       Otherwise, this is only called from BH context.
  */

 struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
@@ -748,7 +751,7 @@ struct sock *tcp_check_req(struct sock *sk, struct
sk_buff *skb,
                                          &tcp_rsk(req)->last_oow_ack_time))
                        req->rsk_ops->send_ack(sk, skb, req);
                if (paws_reject)
-                       __NET_INC_STATS(sock_net(sk),
LINUX_MIB_PAWSESTABREJECTED);
+                       NET_INC_STATS(sock_net(sk),
LINUX_MIB_PAWSESTABREJECTED);
                return NULL;
        }

@@ -767,7 +770,7 @@ struct sock *tcp_check_req(struct sock *sk, struct
sk_buff *skb,
         *         "fourth, check the SYN bit"
         */
        if (flg & (TCP_FLAG_RST|TCP_FLAG_SYN)) {
-               __TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
+               TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
                goto embryonic_reset;
        }
