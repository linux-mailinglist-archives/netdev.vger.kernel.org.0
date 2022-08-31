Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD8A5A7DCC
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 14:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbiHaMqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 08:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbiHaMqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 08:46:39 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF69A0318
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 05:46:38 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id a22so8126900qtw.10
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 05:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=JqDvAYAWxNNfpJuU5DEXVinXnDSsKAEMoGwhz7LjgBE=;
        b=tFjlkvzTslaF/oVWRbGxZYoJzuXJofXAUnX9cb6z31lYUxEIZy8onaXVdk95UGjQn0
         Vr9HqVGUQkXN3bZWb6epuSDYJ79EgYd/Swu2A1jHye/cpg/DY9ojmXXA6vn5xZLcmjrL
         1tuq8thm0uNz6kNQhmYoevO74JKEGW7M0bgV5pHR3jopHj1Yf8MUGBoHhLa1Bt1jTOzf
         araW2rSeEVG13XKG2umP7/kprqD2wereTVgQxgP32WvbLMEetIkcXx759i/W+CK2ui/g
         Ii159qE3Xq7kG0o7KZTzU4cCQWdJ6ne3QSuuEZbCkiYyEUu40QKiXqvKjm8CtyaAQj+B
         8p6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=JqDvAYAWxNNfpJuU5DEXVinXnDSsKAEMoGwhz7LjgBE=;
        b=b89q7U6DNn7M+hpArm9fIn75ZIQDwPtZG/NW9dh4ZZacMtY+R52+1LkPYvM/L0osLq
         DNs7vT0XE7rhpkEjaQ8x+8E9aXnK+YecXLUaQCZr4ar9+vLtGjJnbxO4ldbC+aruuG0/
         S2HO9rFQiZCgn/ZrBC53BFwcoR5aZAFUh6tPGMAJErlXVcDCNZmG8TKTD2oM3DDCLNxg
         6U/z/K6Mjq7dWZ6McIS9Wyx3wko8vt1DSpDFt8NPC+lJJ3RoOEWpAqMZRPVH49vsmd08
         j0OgdmpQcLi+jn+PWYJSz+a5RDOAF10LCEQCmuhXCKTrzZXe7pM5/+b9dg1QUiXQcJfC
         RO3g==
X-Gm-Message-State: ACgBeo2a0NG6lVNJblgKM/txWPlix2vh0Kwdd9hIuO3xM9T70cA1JvLg
        I8yJHXWgSbobgA2njZLeEzLpuLQzrAjRLkIgbjsAaQ==
X-Google-Smtp-Source: AA6agR7Tf1gpl7oDA8tESdlZfrFGNJ7Q1zMLgposSWhO0Kci8CqKo4uhX+v/O5K+Q3lRg3qfT+LVRH1EellrCTwNoBs=
X-Received: by 2002:a05:622a:40c:b0:344:5aba:a153 with SMTP id
 n12-20020a05622a040c00b003445abaa153mr19054261qtx.261.1661949997084; Wed, 31
 Aug 2022 05:46:37 -0700 (PDT)
MIME-Version: 1.0
References: <1661761242-7849-1-git-send-email-liyonglong@chinatelecom.cn>
 <CAK6E8=dJzNC7GFTikanKM48Uo5DFZBZGSUVoMy1dCfV0ttNe+g@mail.gmail.com>
 <CAK6E8=eNe8Ce9zKXx1rKBL48XuDVGntAOOtKVi6ywgMjafMWXg@mail.gmail.com> <43b8a024-2ab8-157d-92c2-7367f632c659@chinatelecom.cn>
In-Reply-To: <43b8a024-2ab8-157d-92c2-7367f632c659@chinatelecom.cn>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 31 Aug 2022 08:46:20 -0400
Message-ID: <CADVnQynrEer3EBcDe2jeK4GNFOdKMFLwFgiXqjFg5CgAiBOjFA@mail.gmail.com>
Subject: Re: [PATCH] tcp: del skb from tsorted_sent_queue after mark it as lost
To:     Yonglong Li <liyonglong@chinatelecom.cn>
Cc:     Yuchung Cheng <ycheng@google.com>, netdev@vger.kernel.org,
        davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 3:19 AM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
>
>
>
> On 8/31/2022 1:58 PM, Yuchung Cheng wrote:
> > On Mon, Aug 29, 2022 at 5:23 PM Yuchung Cheng <ycheng@google.com> wrote:
> >>
> >> On Mon, Aug 29, 2022 at 1:21 AM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
> >>>
> >>> if rack is enabled, when skb marked as lost we can remove it from
> >>> tsorted_sent_queue. It will reduces the iterations on tsorted_sent_queue
> >>> in tcp_rack_detect_loss
> >>
> >> Did you test the case where an skb is marked lost again after
> >> retransmission? I can't quite remember the reason I avoided this
> >> optimization. let me run some test and get back to you.
> > As I suspected, this patch fails to pass our packet drill tests.
> >
> > It breaks detecting retransmitted packets that
> > get lost again, b/c they have already been removed from the tsorted
> > list when they get lost the first time.
> >
> >
>
> Hi Yuchung,
> Thank you for your feelback.
> But I am not quite understand. in the current implementation, if an skb
> is marked lost again after retransmission, it will be added to tail of
> tsorted_sent_queue again in tcp_update_skb_after_send.
> Do I miss some code?

That's correct, but in the kind of scenario Yuchung is talking about,
the skb is not retransmitted again.

To clarify, here is an example snippet of a test written by Yuchung
that covers this kind of case:

----
`../common/defaults.sh`

    0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
   +0 bind(3, ..., ...) = 0
   +0 listen(3, 1) = 0

   +0 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 7>
   +0 > S. 0:0(0) ack 1 <mss 1460,nop,nop,sackOK,nop,wscale 8>
 +.02 < . 1:1(0) ack 1 win 257
   +0 accept(3, ..., ...) = 4
   +0 write(4, ..., 16000) = 16000
   +0 > P. 1:10001(10000) ack 1

// TLP (but it is dropped too so no ack for it)
 +.04 > . 10001:11001(1000) ack 1

// RTO and retransmit head
 +.22 > . 1:1001(1000) ack 1

// ACK was lost. But the (spurious) retransmit induced a DSACK.
// So total this ack hints two packets (original & dup).
// Undo cwnd and ssthresh.
 +.01 < . 1:1(0) ack 1001 win 257 <sack 1:1001,nop,nop>
   +0 > P. 11001:13001(2000) ack 1
   +0 %{
assert tcpi_snd_cwnd == 12, tcpi_snd_cwnd
assert tcpi_snd_ssthresh > 1000000, tcpi_snd_ssthresh
}%

// TLP to discover the real losses 1001:11001(10000)
 +.04 > . 13001:14001(1000) ack 1

// Fast recovery. PRR first then PRR-SS after retransmits are acked
 +.01 < . 1:1(0) ack 1001 win 257 <sack 11001:12001,nop,nop>
   +0 > . 1001:2001(1000) ack 1
----

In this test case, with the proposed patch in this thread applied, the
final 1001:2001(1000) skb is transmitted 440ms later, after an RTO.
AFAICT that's because the 1001:2001(1000) skb was removed from the
tsorted list upon the original (spurious RTO) but not re-added upon
the undo of that spurious RTO.

best regards,
neal
