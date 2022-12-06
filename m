Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A49644DE4
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 22:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiLFVWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 16:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiLFVWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 16:22:31 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4994733F
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 13:22:30 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id x18so8603423qki.4
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 13:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uk+uaDV+BDB+QhFJnl5l+DPsVYmcEGuoy53cTYmhCpY=;
        b=ZmowREvExAh4bzTMqqHd0YDtiY1cwKkkycDTdNexE6ZPF9JomOLycYFs8aWf0Y9ji4
         wElTandIFoxvo+a7wiZ1fEEZie9P2uU5Aa8vmVR/8A1R1IrLy0ScDd1v6ermKYzXsCtZ
         C6ZLjoHmUlCuzI5q6zz8aR9P/qefqsh6fpCQ7/rjqve2FPHMJ9+JrLAs8720Z1TU4TP8
         F6a9c8IEva0S33kujvy0jirsu0i7kZzlGw/hCWxkzyNfipFdVd/lZkPpJ6dMdtKO3k+b
         z9qm/vFAA4DjXpavpBzwG4Chfpt4zBGHRituoMyqJjd1DWMTPEOjKF1LZ4hv8S4HkZSN
         h3DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uk+uaDV+BDB+QhFJnl5l+DPsVYmcEGuoy53cTYmhCpY=;
        b=DdxlgaGfXjw+GwsHtlrA9z5Qrp8eX/x/iQwQ58rppO9b+AOVxZmnBTOJjnsjmfePn1
         7GSEXt2WnE0RpuTfP+/Dsip1h9+FxFFzws72kl6goatOcoHhvQy4QsVf7MdImJHfuWw0
         OboIC+yLYKpocjKGCHpb/kR3D4mHhIBB/x6xEvP4dSv4bd1fetW+ZCHgvJ+CHtmuzIAz
         2PPQKu3ZR60OjTAwpESTohR/eIH6NsWOg0p9wXOnOjZ7LbL3V9RNXduwr+9fo4G2wQ5C
         TXkd3ZzeQNwORW/q+Yj/auVsfnXIoXp7s12HhzEspnm1BpxJQW1wrCd/6+VleZWFrPAZ
         2I/Q==
X-Gm-Message-State: ANoB5pnYTAyhcSFuqIv4O7R2vPDaATKxSEB/oOWXUpk2S8KSzYXsY6Bz
        Y27RiPQf92FwcLtE1VjH6Ip0ExzpHns=
X-Google-Smtp-Source: AA0mqf5s344YIMSdVcmWgTzY6ULdr+y2UTNlNX6moAYhPpLZRhrGKfIeYCgepHzSbecohT86EVpdMA==
X-Received: by 2002:a05:620a:2228:b0:6ec:51ea:33f3 with SMTP id n8-20020a05620a222800b006ec51ea33f3mr61776872qkh.325.1670361749156;
        Tue, 06 Dec 2022 13:22:29 -0800 (PST)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id y26-20020a37f61a000000b006fc62eabcc9sm14775737qkj.134.2022.12.06.13.22.28
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 13:22:28 -0800 (PST)
Received: by mail-yb1-f182.google.com with SMTP id y135so15718870yby.12
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 13:22:28 -0800 (PST)
X-Received: by 2002:a25:da11:0:b0:707:75:6dac with SMTP id n17-20020a25da11000000b0070700756dacmr1950301ybf.85.1670361748189;
 Tue, 06 Dec 2022 13:22:28 -0800 (PST)
MIME-Version: 1.0
References: <20221205230925.3002558-1-willemdebruijn.kernel@gmail.com>
 <20221206122239.58e16ae4@kernel.org> <CA+FuTScpBNEDy6D+dBaj3avMzXCQBRMUQib_gkono4V5k+Ke9w@mail.gmail.com>
 <20221206125801.21203419@kernel.org>
In-Reply-To: <20221206125801.21203419@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 6 Dec 2022 16:21:50 -0500
X-Gmail-Original-Message-ID: <CA+FuTSec2e8iPFAWrwB14=aC+99G2fD2GmCnmz4MkW2EW-rK_w@mail.gmail.com>
Message-ID: <CA+FuTSec2e8iPFAWrwB14=aC+99G2fD2GmCnmz4MkW2EW-rK_w@mail.gmail.com>
Subject: Re: [PATCH net-next] net_tstamp: add SOF_TIMESTAMPING_OPT_ID_TCP
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, soheil@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 6, 2022 at 3:58 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 6 Dec 2022 15:46:25 -0500 Willem de Bruijn wrote:
> > > We can't just copy back the value of
> > >
> > >         tcp_sk(sk)->snd_una - tcp_sk(sk)->write_seq
> > >
> > > to the user if the input of setsockopt is large enough (ie. extend the
> > > struct, if len >= sizeof(new struct) -> user is asking to get this?
> > > Or even add a bit somewhere that requests a copy back?
> >
> > We could, but indeed then we first need a way to signal that the
> > kernel is new enough to actually write something meaningful back that
> > is safe to read.
>
> It should be sufficient to init the memory to -1.
> (I guess I'm not helping my own "this is less hacky" argument? :)
>
> > And if we change the kernel API and applications, I find this a
> > somewhat hacky approach: why program the slightly wrong thing and
> > return the offset to patch it up in userspace, if we can just program
> > the right thing to begin with?
>
> Ah, so you'd also switch all your apps to use this new bit?
>
> What wasn't clear to me whether this is a
>  1 - we clearly did the wrong thing
> or
>  2 - there is a legit use case for un-packetized(?) data not being
>      counted
>
> In case of (1) we should make it clearer that the new bit is in fact
> a "fixed" version of the functionality.
> For (2) we can view this as an extension of the existing functionality
> so combining in the same bit with write back seems natural (and TBH
> I like the single syscall probing path more than try-one-then-the-other,
> but that's 100% subjective).
>
> Anyway, don't wanna waste too much of your time. If you prefer to keep
> as is the doc change is good enough for me.

It's definitely 1. I'll be more explicit in the documentation and
commit message about that.

I would have just made the one line 's/snd_una/write_seq/' change if I
could be certain that no existing code relies on the current behavior.
But I already came across it in one test and production. It's too
risky.
