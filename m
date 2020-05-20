Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757D21DBEE7
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgETT5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728408AbgETT5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:57:04 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3734BC061A0E;
        Wed, 20 May 2020 12:57:04 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id e10so2573618vsp.12;
        Wed, 20 May 2020 12:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GxUaUN6vf454eItYUVZAvSrj24SmWPAgZaZXKMh5Yug=;
        b=NkuQMa3+qk+cwSKLMQHjDUMihNnfu8ASd4srzMFcz5fqGDfPRTQJUa2Zn1ugKnEZxU
         4AzfewKWyjsNvvXedLrAYUPoOOsIViuodHsZy7CqXBqR84jh2LHN1tH9ioY5oFQ6HABI
         f2NYUmC18J9NXQLJzum5m6pKOM61ONrOPNKWuUC/jYBQ3PpAHwFRLFYSO+C86QF08WmN
         dG1IScdNzix/57AJNwkfUCfgLZWecCAoE1po9d2vZB5ziCkKW5gxOIwl2cLf96mTh0s4
         X5/NfYNQlAbObwv1ld9ERjOQ04Ssidxz1yGeiSA+kNZ0zxomGcL2Fu42B9tcBfApb3Q4
         JIgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GxUaUN6vf454eItYUVZAvSrj24SmWPAgZaZXKMh5Yug=;
        b=MPco5b+pnNurwz9hEICcPLk+xySws20tUsNTvauCUJF4t5tBXcbxHoSUI4BG1YyYrE
         sMkVU2an5G1TpA9PG7FZ+RESFRPBQYu7JJ2QzSbw6FN9nJxYHErFp50VXGgRkK6UcJoj
         LcEfcEUojn0hPxgTFdL1XBKUT0rpojwxuM75gTh4wANH4dDoyhUaRb9njT1qhWz3sDIr
         uAKuq9QQkhAQZYOmr8hULiYR+c6HLjb8PujFpbMKAGq7cGaQqKtdrskfi6f75bsvrGai
         WU1/4RpEen+9TJecW6Qx2AyEf0qyrgiaUhYSe6LUoW0E4DJqgcjwgxYpIOfEFBlYBCwz
         zE/w==
X-Gm-Message-State: AOAM532ZEeRmUw3QvfEWeZvFZEawrZVntT7+3/guAyhkOYJ+Q/KNvZJN
        tezXV9jdXOhDUfyx095+V1Hfg5AgwRFDk8hrE3o=
X-Google-Smtp-Source: ABdhPJzp5CiaN6eGlE+TLMUT0TPhfpKr6Th8x2kCTQ10fToEbrGM0DUM2rRlex+18RhqrR9+garadSSMFvH8arbCtjQ=
X-Received: by 2002:a67:1903:: with SMTP id 3mr4552339vsz.22.1590004623277;
 Wed, 20 May 2020 12:57:03 -0700 (PDT)
MIME-Version: 1.0
References: <1589732796-22839-1-git-send-email-pooja.trivedi@stackpath.com>
 <20200518155016.75be3663@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAOrEds=Mo4YHm1CPrgVmPhsJagUAQ0PzyDPk9Cq3URq-7vfCWA@mail.gmail.com> <20200519144255.3a7416c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200519144255.3a7416c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Pooja Trivedi <poojatrivedi@gmail.com>
Date:   Wed, 20 May 2020 15:56:56 -0400
Message-ID: <CAOrEds=e62EnDiB5b-5Btukp83OASVaVgBG28GkxSBw1F8sLSQ@mail.gmail.com>
Subject: Re: [PATCH net] net/tls(TLS_SW): Fix integrity issue with
 non-blocking sw KTLS request
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        davem@davemloft.net, vakul.garg@nxp.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        mallesham.jatharkonda@oneconvergence.com, josh.tway@stackpath.com,
        Pooja Trivedi <pooja.trivedi@stackpath.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 5:43 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 19 May 2020 13:21:56 -0400 Pooja Trivedi wrote:
> > On Mon, May 18, 2020 at 6:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Sun, 17 May 2020 16:26:36 +0000 Pooja Trivedi wrote:
> > > > In pure sw ktls(AES-NI), -EAGAIN from tcp layer (do_tcp_sendpages for
> > > > encrypted record) gets treated as error, subtracts the offset, and
> > > > returns to application. Because of this, application sends data from
> > > > subtracted offset, which leads to data integrity issue. Since record is
> > > > already encrypted, ktls module marks it as partially sent and pushes the
> > > > packet to tcp layer in the following iterations (either from bottom half
> > > > or when pushing next chunk). So returning success in case of EAGAIN
> > > > will fix the issue.
> > > >
> > > > Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption")
> > > > Signed-off-by: Pooja Trivedi <pooja.trivedi@stackpath.com>
> > > > Reviewed-by: Mallesham Jatharkonda <mallesham.jatharkonda@oneconvergence.com>
> > > > Reviewed-by: Josh Tway <josh.tway@stackpath.com>
> > >
> > > This looks reasonable, I think. Next time user space calls if no new
> > > buffer space was made available it will get a -EAGAIN, right?
> >
> > Yes, this fix should only affect encrypted record. Plain text calls from
> > user space should be unaffected.
>
> AFAICS if TCP layer is full next call from user space should hit
> sk_stream_wait_memory() immediately and if it has MSG_DONTWAIT set
> exit with EAGAIN. Which I believe to be correct behavior.
>

The flow is tls_sw_sendmsg/tls_sw_do_sendpage --> bpf_exec_tx_verdict -->
tls_push_record --> tls_tx_records --> tls_push_sg --> do_tcp_sendpages

do_tcp_sendpages() sends partial record, 'retry:' label is exercised wherein
do_tcp_sendpages gets called again and returns -EAGAIN.
tls_push_sg sets partially_sent_record/partially_sent_offset and
returns -EAGAIN. -EAGAIN bubbles up to bpf_exec_tx_verdict.
In bpf_exec_tx_verdict, the following code causes 'copied' variable to
get updated to a negative value and returns -EAGAIN.

                err = tls_push_record(sk, flags, record_type);
                if (err && err != -EINPROGRESS) {
                        *copied -= sk_msg_free(sk, msg);
                        tls_free_open_rec(sk);
                }
                return err;

-EAGAIN returned by bpf_exec_tx_verdict causes
tls_sw_sendmsg/tls_sw_do_sendpage to 'continue' in the while loop and
call sk_stream_wait_memory(). sk_stream_wait_memory returns -EAGAIN
also and control reaches the 'send_end:' label. The following return
statement causes a negative 'copied' variable value to be returned to the
user space.

        return copied ? copied : ret;

User space applies this negative value as offset for the next send, causing
part of the record that was already sent to be pushed again.

Hope this clarifies it.


>
> > > Two questions - is there any particular application or use case that
> > > runs into this?
> >
> > We are running into this case when we hit our kTLS-enabled homegrown
> > webserver with a 'pipeline' test tool, also homegrown. The issue basically
> > happens whenever the send buffer on the server gets full and TCP layer
> > returns EAGAIN when attempting to TX the encrypted record. In fact, we
> > are also able to reproduce the issue by using a simple wget with a large
> > file, if/when sndbuf fills up.
>
> I see just a coincidence, then, no worries.
>
> > > Seems a bit surprising to see a patch from Vadim and
> > > you guys come at the same time.
> >
> > Not familiar with Vadim or her/his patch. Could you please point me to it?
>
> http://patchwork.ozlabs.org/project/netdev/patch/20200517014451.954F05026DE@novek.ru/
>

Ah, looks like Vadim ran into the exact issue!

>
> > > Could you also add test for this bug?
> > > In tools/testing/selftests/net/tls.c
> > >
> >
> > Sure, yes. Let me look into this.
>
> Thanks!
