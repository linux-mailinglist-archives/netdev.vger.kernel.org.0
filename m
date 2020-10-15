Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D7B28FA11
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 22:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730355AbgJOUWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 16:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729554AbgJOUWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 16:22:40 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DF3C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 13:22:38 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id r1so160631vsi.12
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 13:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2PsYXnuIrN/1pEpqRN9Bs20xAJnJl1Iv2V0NVJ9tavo=;
        b=lnSGCXtVqUBamHEMzJ3TvZkrTeMmlWh/vks4Yi5R+J7ALSqRIwSWQfhxPh4+gIPDpD
         r+UTzkr+bn2qqCBsF/qzqttVFfFpXojqtvU8GHdEK3e48OW/jvDNrYWLXE7IlBR7kWhc
         /CvMrw3HSAAmhFnyuofFZsIpcm9mmh9+U6Bj3KFQysFHWctYnPT+OHDl7Oo1thrz4cc2
         NsOlVQLRIPfoz9MwOjOEAXPG/NFLxDJ46ff6g4iT12kWR5XVxGZCEGoBhmAW7BHSvjPq
         GUc1YIkf20SIpjCP10Pil9CaZUKVMTowrVfoTA1KH/MaUxYp20Py+tLKb3pE4ESLHpEo
         Ih+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2PsYXnuIrN/1pEpqRN9Bs20xAJnJl1Iv2V0NVJ9tavo=;
        b=POBAi1UutxMPP9oH8VEW6JtMy9KZ9WfnABAVJ2WQ8wSFUk8wxkVYGcV+cr9k4HB17e
         licCCFr1J010HXdvzSkOXXXg+K3iMs9JttMaE0PniEkILUuX7waHZXh50JVBcBIBPnGF
         3WL/+pzC1aoa2ZrahSTN63QscRU68RBKujLYRia3boBktih0Ati84Y0m+2HS1r8C/fP1
         02DoVTzf95GrR0AMDuUO4Yu7jifLuU+jxfx2qYHXIQjNm993HT7xqpfeo60lmambqq2x
         L11OuC2XmKK9z+D8CsYrz6Z7DFQzV4hVTRS9OznEYrRVOLYoftOdQDaftaAUywFHLSfI
         oi7g==
X-Gm-Message-State: AOAM532vcOKI8RUIxAQZzJopgKebXgWQnrn664gHZbITymPwBdqTeVJM
        CLgrJdpH2oWwO+6glWhsRDWqYBQcxUNspmEgti6dZj1DrIZ8uA==
X-Google-Smtp-Source: ABdhPJxkJWuS9r6lIMvoQHnYjwHsQnZXW5Hqgezk2wKpUSP5mZMngSiXCrAhc6nftbTMZADbFClWYBWj+7RBPL9d15c=
X-Received: by 2002:a67:ffc1:: with SMTP id w1mr142271vsq.52.1602793357263;
 Thu, 15 Oct 2020 13:22:37 -0700 (PDT)
MIME-Version: 1.0
References: <87eelz4abk.fsf@marvin.dmesg.gr>
In-Reply-To: <87eelz4abk.fsf@marvin.dmesg.gr>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 15 Oct 2020 16:22:21 -0400
Message-ID: <CADVnQym6OPVRcJ6PdR3hjN5Krcn0pugshdLZsrnzNQe1c52HXA@mail.gmail.com>
Subject: Re: TCP sender stuck in persist despite peer advertising non-zero window
To:     Apollon Oikonomopoulos <apoikos@dmesg.gr>
Cc:     Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 2:31 PM Apollon Oikonomopoulos <apoikos@dmesg.gr> wrote:
>
> Hi,
>
> I'm trying to debug a (possible) TCP issue we have been encountering
> sporadically during the past couple of years. Currently we're running
> 4.9.144, but we've been observing this since at least 3.16.
>
> Tl;DR: I believe we are seeing a case where snd_wl1 fails to be properly
> updated, leading to inability to recover from a TCP persist state and
> would appreciate some help debugging this.

Thanks for the detailed report and diagnosis. I think we may need a
fix something like the following patch below.

Eric/Yuchung/Soheil, what do you think?

commit 42b37c72aa73aaabd0c01b8c05c2205236279021
Author: Neal Cardwell <ncardwell@google.com>
Date:   Thu Oct 15 16:06:11 2020 -0400

    tcp: fix to update snd_wl1 in bulk receiver fast path

    In the header prediction fast path for a bulk data receiver, if no
    data is newly acknowledged then we do not call tcp_ack() and do not
    call tcp_ack_update_window(). This means that a bulk receiver that
    receives large amounts of data can have the incoming sequence numbers
    wrap, so that the check in tcp_may_update_window fails:
       after(ack_seq, tp->snd_wl1)

    The fix is to update snd_wl1 in the header prediction fast path for a
    bulk data receiver, so that it keeps up and does not see wrapping
    problems.

    Signed-off-by: Neal Cardwell <ncardwell@google.com>
    Reported-By: Apollon Oikonomopoulos <apoikos@dmesg.gr>

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b1ce2054291d..75be97f6a7da 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5766,6 +5766,8 @@ void tcp_rcv_established(struct sock *sk, struct
sk_buff *skb)
                                tcp_data_snd_check(sk);
                                if (!inet_csk_ack_scheduled(sk))
                                        goto no_ack;
+                       } else {
+                               tcp_update_wl(tp, TCP_SKB_CB(skb)->seq);
                        }

                        __tcp_ack_snd_check(sk, 0);

neal
