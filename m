Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7F728D4D2
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 21:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgJMTnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 15:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbgJMTnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 15:43:06 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17619C0613D2
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 12:43:06 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s9so760734wro.8
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 12:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=rJwsepZBWYhxq62vufFoGeztf8zxwm4eD+MUavFU97M=;
        b=Nru/fu4SfHGesWuxDVA6eMnJ7v033oQeDepII6EpexnNRt9F9VrMDaRtX4mDU7n0KY
         KbhmqjETqtLQ5puaczk0CbL2MrDx3kE0Q8OPFIrJJY8YUIPRgu3f7uCbcfpGGurd/ONY
         Bn5mqOeJiNgXz2vsyfKwMcuSQFUuflYMNC6Fg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=rJwsepZBWYhxq62vufFoGeztf8zxwm4eD+MUavFU97M=;
        b=O7REKEgCFGA7U6ld2xA4ev4yFfyjb8i40JXCoAfz7MP5jdib48vDWeXaVSc8MzEpxo
         EFNv54dOLTSrP4VHz8rxSrpfy7Lg9ISNXHlnOnxWvwS0fZT4qjr7ECXSxRghQdCbQ1p3
         UEUg/N5PTElOKTrYjFxzgyoP5oTHc2srrX61BKM3GqPS/WkKryMdKJYBxZ3wDETKaeMZ
         jSD/I78OowNIaHP9yVOTdOR03Q6ktJ68FixsDEN2HrSRLL7QvwmlNYT66BeNSCfgYLQe
         xhEzeUKnUH1DkXHmepqjZ5UVEtmXDetQWaMMMk1hKCavmW7yID7+iIMLOY7q4FwBB8K6
         TvgQ==
X-Gm-Message-State: AOAM532LKvpQeGPgg27Ak9tLpcLtGoIYfI3+KA1IAAL1Tv207Mme4FQ8
        dQ9xpXWV6G78PkK2mhA2mnZ38g==
X-Google-Smtp-Source: ABdhPJwvCueY0bo+O4KnnmLkYJrNSs5kuzkZEbfb2z5DhZL0ryFuRAYGcc8Lv9Opebo9Fognr8j19A==
X-Received: by 2002:adf:e38f:: with SMTP id e15mr1387531wrm.294.1602618184735;
        Tue, 13 Oct 2020 12:43:04 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id v8sm909742wmb.20.2020.10.13.12.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 12:43:04 -0700 (PDT)
References: <160226839426.5692.13107801574043388675.stgit@john-Precision-5820-Tower> <160226859704.5692.12929678876744977669.stgit@john-Precision-5820-Tower> <87h7qzrf3c.fsf@cloudflare.com> <5f8477448f66e_370c208e4@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, lmb@cloudflare.com
Subject: Re: [bpf-next PATCH v3 2/6] bpf, sockmap: On receive programs try to fast track SK_PASS ingress
In-reply-to: <5f8477448f66e_370c208e4@john-XPS-13-9370.notmuch>
Date:   Tue, 13 Oct 2020 21:43:03 +0200
Message-ID: <87blh5rjy0.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 05:33 PM CEST, John Fastabend wrote:
> Jakub Sitnicki wrote:

[...]

>> On Fri, Oct 09, 2020 at 08:36 PM CEST, John Fastabend wrote:
>> > When we receive an skb and the ingress skb verdict program returns
>> > SK_PASS we currently set the ingress flag and put it on the workqueue
>> > so it can be turned into a sk_msg and put on the sk_msg ingress queue.
>> > Then finally telling userspace with data_ready hook.
>> >
>> > Here we observe that if the workqueue is empty then we can try to
>> > convert into a sk_msg type and call data_ready directly without
>> > bouncing through a workqueue. Its a common pattern to have a recv
>> > verdict program for visibility that always returns SK_PASS. In this
>> > case unless there is an ENOMEM error or we overrun the socket we
>> > can avoid the workqueue completely only using it when we fall back
>> > to error cases caused by memory pressure.
>> >
>> > By doing this we eliminate another case where data may be dropped
>> > if errors occur on memory limits in workqueue.
>> >
>> > Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
>> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
>> > ---
>> >  net/core/skmsg.c |   17 +++++++++++++++--
>> >  1 file changed, 15 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
>> > index 040ae1d75b65..4b160d97b7f9 100644
>> > --- a/net/core/skmsg.c
>> > +++ b/net/core/skmsg.c
>> > @@ -773,6 +773,7 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
>> >  {
>> >  	struct tcp_skb_cb *tcp;
>> >  	struct sock *sk_other;
>> > +	int err = -EIO;
>> >
>> >  	switch (verdict) {
>> >  	case __SK_PASS:
>> > @@ -784,8 +785,20 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
>> >
>> >  		tcp = TCP_SKB_CB(skb);
>> >  		tcp->bpf.flags |= BPF_F_INGRESS;
>> > -		skb_queue_tail(&psock->ingress_skb, skb);
>> > -		schedule_work(&psock->work);
>> > +
>> > +		/* If the queue is empty then we can submit directly
>> > +		 * into the msg queue. If its not empty we have to
>> > +		 * queue work otherwise we may get OOO data. Otherwise,
>> > +		 * if sk_psock_skb_ingress errors will be handled by
>> > +		 * retrying later from workqueue.
>> > +		 */
>> > +		if (skb_queue_empty(&psock->ingress_skb)) {
>> > +			err = sk_psock_skb_ingress(psock, skb);
>>
>> When going through the workqueue (sk_psock_backlog), we will also check
>> if socket didn't get detached from the process, that is if
>> psock->sk->sk_socket != NULL, before queueing into msg queue.
>
> The sk_socket check is only for the egress path,
>
>   sk_psock_handle_skb -> skb_send_sock_locked -> kernel_sendmsg_locked

Oh, okay. I thought it was because we want to forwarding into the socket
as soon as there is no process to read from the queue.

> Then the do_tcp_sendpages() uses sk_socket and I don't see any checks for
> sk_socket being set. Although I think its worth looking through to see
> if the psock/sk state is always such that we have sk_socket there I
> don't recall off-hand where that is null'd.

It's in sock_orphan().

> But, to answer your question this is ingress only and here we don't
> use sk_socket for anything so I don't see any reason the check is
> needed. All that is done here is converting to skmsg and posting
> onto ingress queue.

Queued skb won't be read out, but I don't see a problem with it.

[...]
