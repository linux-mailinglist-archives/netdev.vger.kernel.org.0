Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F985AC5DD
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 20:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbiIDSOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 14:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiIDSOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 14:14:45 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822BD1274E;
        Sun,  4 Sep 2022 11:14:42 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id b196so6302885pga.7;
        Sun, 04 Sep 2022 11:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=bj5XN602+hiptH7aHwGIrNTa2b8KYuJTdSlb9Mz17hY=;
        b=VOxPxvFP3m+1IMJ0KqbmfpvX2JNijn+rKAca6iE8P8OFXZmFQ211KdYPLzL2lVcZBI
         axCBdg5p8IAKxSbYx4iZ6W4TLRfpc1a8rOsbRvzIBuvm33Q7RqUcEgV4iFaf6ymFnNjm
         HPW1VScCmP/kiTMZNITREyLhre5PhZDLTUEAUnBOxp4ggxE/eaT4m0687QM62R7v+u3j
         J/9nEhiQ3mFFl47udPaJ+nZc754iWWHf4Qs4O4+BlUu3wm/c+sJbngsg1+LlI59ngbPN
         MeZLklTPBxzy+pxoI9Lp70IK780vukJGD7748Ja9k50ClsVmJKX4NxrZU5m84m73QK4y
         kYRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=bj5XN602+hiptH7aHwGIrNTa2b8KYuJTdSlb9Mz17hY=;
        b=UmQnjcH+npj/3oKNMsedhfZXRyUOXEvNoY6CZb8rtflFBPkZS3TCY8eBLScIfBQ9+i
         WzToftGCYX2YD7Ut5Wv7dwJ4iXJWak41YsuZc8YKZeljScOWCW8hFSwB/haZoE0fTvZM
         OjdvJo6ElU0yZvq1pnryhEBQjc01rz5ZbYcf5715nRI3XXPLX731QzDEJJRlzJuEA8Hl
         tWzSO0vft4mlRxq/j8UihCP8yHP7Auk3+xxwhNgQCQimNNeHzEllpU+b+mw5xZhamzTt
         Kn9+u5rFjpIHH2Ew37yjSlQfjas8tz1Dkk7y2WENdpKzpuF8MfZLWsXD62ptex8waysd
         eT8g==
X-Gm-Message-State: ACgBeo1mWTqzX6gWSSIpSGHiLQmOJDnTJ2aGuPUNC704c7OCAXnN1E3R
        +Dj7BKeoIMdeLiDWm0qkfrrd00l1cxysb77/s1ktFrrrwG4=
X-Google-Smtp-Source: AA6agR6hcpt/Tj1zKSx3Cf3qZBhgYSG4tma2fBEWiZziG3H4/r+Qqyi/FP8U7kx7iTLI/QzIPS31zvEZJx9f3HzBxAk=
X-Received: by 2002:a62:7b4f:0:b0:537:dcaf:acf1 with SMTP id
 w76-20020a627b4f000000b00537dcafacf1mr42730817pfc.58.1662315281884; Sun, 04
 Sep 2022 11:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <CABG=zsBEh-P4NXk23eBJw7eajB5YJeRS7oPXnTAzs=yob4EMoQ@mail.gmail.com>
 <20220831230157.7lchomcdxmvq3qqw@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220831230157.7lchomcdxmvq3qqw@kafai-mbp.dhcp.thefacebook.com>
From:   Aditi Ghag <aditivghag@gmail.com>
Date:   Sun, 4 Sep 2022 11:14:30 -0700
Message-ID: <CABG=zsCQBVga6Tjcc-Y1x0U=0xAjYHH_j8ncFJPOG2XvxSP2UQ@mail.gmail.com>
Subject: Re: [RFC] Socket termination for policy enforcement and load-balancing
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 4:02 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Aug 31, 2022 at 09:37:41AM -0700, Aditi Ghag wrote:
> > - Use BPF (sockets) iterator to identify sockets connected to a
> > deleted backend. The BPF (sockets) iterator is network namespace aware
> > so we'll either need to enter every possible container network
> > namespace to identify the affected connections, or adapt the iterator
> > to be without netns checks [3]. This was discussed with my colleague
> > Daniel Borkmann based on the feedback he shared from the LSFMMBPF
> > conference discussions.
> Being able to iterate all sockets across different netns will
> be useful.
>
> It should be doable to ignore the netns check.  For udp, a quick
> thought is to have another iter target. eg. "udp_all_netns".
> From the sk, the bpf prog should be able to learn the netns and
> the bpf prog can filter the netns by itself.
>
> The TCP side is going to have an 'optional' per netns ehash table [0] soon,
> not lhash2 (listening hash) though.  Ideally, the same bpf
> all-netns iter interface should work similarly for both udp and
> tcp case.  Thus, both should be considered and work at the same time.
>
> For udp, something more useful than plain udp_abort() could potentially
> be done.  eg. directly connect to another backend (by bpf kfunc?).
> There may be some details in socket locking...etc but should
> be doable and the bpf-iter program could be sleepable also.

This won't be effective for connected udp though, will it? Interesting thought
around using bpf kfunc!

> fwiw, we are iterating the tcp socket to retire some older
> bpf-tcp-cc (congestion control) on the long-lived connections
> by bpf_setsockopt(TCP_CONGESTION).
>
> Also, potentially, instead of iterating all,
> a more selective case can be done by
> bpf_prog_test_run()+bpf_sk_lookup_*()+udp_abort().

Can you elaborate more on the more selective iterator approach?

On a similar note, are there better ways as alternatives to the
sockets iterator approach.
Since we have BPF programs executed on cgroup BPF hooks (e.g.,
connect), we already know what client
sockets are connected to a backend. Can we somehow store these socket
pointers in a regular BPF map, and
when a backend is deleted, use a regular map iterator to invoke
sock_destroy() for these sockets? Does anyone have
experience using the "typed pointer support in BPF maps" APIs [0]?

[0] https://lwn.net/ml/bpf/20220424214901.2743946-1-memxor@gmail.com/
