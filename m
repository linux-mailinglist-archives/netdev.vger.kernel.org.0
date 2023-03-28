Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D398E6CCC65
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 23:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjC1V5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 17:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjC1V5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 17:57:10 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37FD273A;
        Tue, 28 Mar 2023 14:56:53 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id g7so9007970pfu.2;
        Tue, 28 Mar 2023 14:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680040611;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=odlvPMU0DvOEA8Zyoa7tw66A464oovwujJNAX+TA7BY=;
        b=Aes6vhsEHGl9+S+XBQ1os1tsS3ccUvB8Vita4tFZ1pTO8Af9yOSh8W66anrirzO8YW
         BEiB1YMjsACR2RCLeK9FGYolTyn1q9nZMbvG3XEKFJ04mcQ1btoAFAZFfLljBDWHNPsA
         mZ6nhf7GZIU7LIK4E1X1YBCLoETFl3odvFjARzZ+l/U0Y07GqXdDBPKOWNpneqNfN5vJ
         e+C4p8/bYY4jdlE3ZhkNg3a9heH+yrK4ayCw48cv30+kBHPopIxrI27sdTikY0eQvIhe
         x0T7eshz3ckZ+ggTu9/pTGUl+ItNPuKNdmhyhPoqFt3gxL3+yDJDOCWtGnYjUg059Nni
         MIMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680040611;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=odlvPMU0DvOEA8Zyoa7tw66A464oovwujJNAX+TA7BY=;
        b=1dyGDcLkveEbycXWoYEc5VqG7jNYmj2hM+36Ci13MGcDjV7+o9jY6poUPf8rOz4nvS
         GDgCRn8YvWrAidjNwwKqRXMxUy14tr12YF10+SY22/7gn3OMaCEM1rnh+0kTmYNbKZQA
         /Ai92CHEm7Gs2LYhfPrYwCia3u64a0Ffm4Q0M4jCZ6n0BxTuJyxutOg7O5+wv2aE/2m1
         OtS+JPzQfGZgyni5cX5fNR3b1wKdmJcMj1joxzZ8RoB+7+zzP33zgwC5SEOsgFN8sykv
         jxWSZ1jqnvxqk/GTId/U0Ag5obvLb1XE/S8p9bmZB/FGBMKF4xy8YCQ5qnk9+pzb7xUi
         3M7w==
X-Gm-Message-State: AAQBX9fREpLswKh/9AmcRAwXxEu2DWX1e4DW+1rIiYbza1aBGxZEfTE+
        E3IAJG1H2nxVHDo21VUZS78=
X-Google-Smtp-Source: AK7set+0JDGKHYDfUmhNiD24vp24TtBUrFDVWQi+4Ws2kUO77zPIcUUFH2UFrW8Whj6PnxUzdbcS7Q==
X-Received: by 2002:aa7:8f3c:0:b0:627:6328:79d7 with SMTP id y28-20020aa78f3c000000b00627632879d7mr13897242pfr.34.1680040611138;
        Tue, 28 Mar 2023 14:56:51 -0700 (PDT)
Received: from localhost ([98.97.117.131])
        by smtp.gmail.com with ESMTPSA id g13-20020a62e30d000000b0062a51587499sm10756999pfh.109.2023.03.28.14.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 14:56:50 -0700 (PDT)
Date:   Tue, 28 Mar 2023 14:56:49 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     cong.wang@bytedance.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        ast@kernel.org, andrii@kernel.org, will@isovalent.com
Message-ID: <642362a1403ee_286af20850@john.notmuch>
In-Reply-To: <87tty55aou.fsf@cloudflare.com>
References: <20230327175446.98151-1-john.fastabend@gmail.com>
 <20230327175446.98151-3-john.fastabend@gmail.com>
 <87tty55aou.fsf@cloudflare.com>
Subject: Re: [PATCH bpf v2 02/12] bpf: sockmap, convert schedule_work into
 delayed_work
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Mon, Mar 27, 2023 at 10:54 AM -07, John Fastabend wrote:
> > Sk_buffs are fed into sockmap verdict programs either from a strparser
> > (when the user might want to decide how framing of skb is done by attaching
> > another parser program) or directly through tcp_read_sock. The
> > tcp_read_sock is the preferred method for performance when the BPF logic is
> > a stream parser.
> >
> > The flow for Cilium's common use case with a stream parser is,
> >
> >  tcp_read_sock()
> >   sk_psock_verdict_recv
> >     ret = bpf_prog_run_pin_on_cpu()
> >     sk_psock_verdict_apply(sock, skb, ret)
> >      // if system is under memory pressure or app is slow we may
> >      // need to queue skb. Do this queuing through ingress_skb and
> >      // then kick timer to wake up handler
> >      skb_queue_tail(ingress_skb, skb)
> >      schedule_work(work);
> >
> >
> > The work queue is wired up to sk_psock_backlog(). This will then walk the
> > ingress_skb skb list that holds our sk_buffs that could not be handled,
> > but should be OK to run at some later point. However, its possible that
> > the workqueue doing this work still hits an error when sending the skb.
> > When this happens the skbuff is requeued on a temporary 'state' struct
> > kept with the workqueue. This is necessary because its possible to
> > partially send an skbuff before hitting an error and we need to know how
> > and where to restart when the workqueue runs next.
> >
> > Now for the trouble, we don't rekick the workqueue. This can cause a
> > stall where the skbuff we just cached on the state variable might never
> > be sent. This happens when its the last packet in a flow and no further
> > packets come along that would cause the system to kick the workqueue from
> > that side.
> >
> > To fix we could do simple schedule_work(), but while under memory pressure
> > it makes sense to back off some instead of continue to retry repeatedly. So
> > instead to fix convert schedule_work to schedule_delayed_work and add
> > backoff logic to reschedule from backlog queue on errors. Its not obvious
> > though what a good backoff is so use '1'.
> >
> > To test we observed some flakes whil running NGINX compliance test with
> > sockmap we attributed these failed test to this bug and subsequent issue.
> >
> > Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> > Tested-by: William Findlay <will@isovalent.com>
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---

[...]

> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -481,7 +481,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
> >  	}
> >  out:
> >  	if (psock->work_state.skb && copied > 0)
> > -		schedule_work(&psock->work);
> > +		schedule_delayed_work(&psock->work, 0);
> >  	return copied;
> >  }
> >  EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
> > @@ -639,7 +639,8 @@ static void sk_psock_skb_state(struct sk_psock *psock,
> >  
> >  static void sk_psock_backlog(struct work_struct *work)
> >  {
> > -	struct sk_psock *psock = container_of(work, struct sk_psock, work);
> > +	struct delayed_work *dwork = to_delayed_work(work);
> > +	struct sk_psock *psock = container_of(dwork, struct sk_psock, work);
> >  	struct sk_psock_work_state *state = &psock->work_state;
> >  	struct sk_buff *skb = NULL;
> >  	bool ingress;
> > @@ -679,6 +680,10 @@ static void sk_psock_backlog(struct work_struct *work)
> >  				if (ret == -EAGAIN) {
> >  					sk_psock_skb_state(psock, state, skb,
> >  							   len, off);
> > +
> > +					// Delay slightly to prioritize any
> > +					// other work that might be here.
> > +					schedule_delayed_work(&psock->work, 1);
> 
> Do IIUC that this means we can back out changes from commit bec217197b41
> ("skmsg: Schedule psock work if the cached skb exists on the psock")?

Yeah I think so this is a more direct way to get the same result. I'm also
thinking this check,

       if (psock->work_state.skb && copied > 0)
               schedule_work(&psock->work)

is not correct copied=0 which could happen on empty queue could be the
result of a skb stuck from this eagain error in backlog.

I think its OK to revert that patch in a separate patch. And ideally we
could get some way to load up the stack to hit these corner cases without
running long stress tests.

WDYT?

> 
> Nit: Comment syntax.

Yep happy to fix.
