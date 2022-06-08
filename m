Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC715542E06
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 12:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbiFHKjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 06:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238258AbiFHKjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 06:39:10 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CBF2B4B1D
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 03:38:08 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id r3so1613502ybr.6
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 03:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YAsn2Kamdur/wyMjzFIMoTewzULGEBOBJlCnfEY9/KU=;
        b=iAvHzZqbwWPUgP067apGAzSJZDGvizwZp11bgjXcLL4XdMRT2qEQn6ud53qxjX3T+M
         /YgSyaIOTmY6sAMgX6BFv8T2dlCcGZ3xZant1FXkxmiBUaQ7lqdFNW53mC9OSvVfRSdo
         W/i+ZrtBT+HZ+r0coZuWBFnF4c27q93GHZDlfoDLFVu2BNEpZnVwKjold62Bsd70E1ZZ
         TQdmkpnBUOFGog81OBYBmDJKYpd+lN22u0dEST/AgALT6tntuLF7sQRcXyBZZRket8tj
         elSARFMAVIOi2PUWObRMuDckQE158nsf+HoaSzGk9VlRajk192FSQf/6d4VYAqYvuDJT
         mB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YAsn2Kamdur/wyMjzFIMoTewzULGEBOBJlCnfEY9/KU=;
        b=6o9JiljqfWH0LAvMiJzUBfD+OFUEr68+CFy6991v7KtrsZvMerFxfE6V2s0DIotb79
         Q4EFxHFd8FWXGpYky4k+gYTL4Ey6I+RrtHfuzcWpZWBU7iQ4tmPSMKPkKoEeS9C61qWE
         nIdClfbNiJ5kTmG3xskkt9WUqcDCVKsbXn0kUcNUzMXqfNE097/A4Cn++E6YUV0m0t9t
         BrDsFAMzviO381xRBivlRSww7oFRbbzEOt2RYCKGgPFBe6W8swrSUuheYPHKO3JQ19rH
         VtpJyo4Qx6m+xMqShuNyE81Dd0iKRTBKxYC0SEnxHhUbjXWqk+Ea4BlcsPVW/4NDiyEI
         7EEg==
X-Gm-Message-State: AOAM531o3A4t9N3dWxhaovkxvtlnvHQmSO7ZeOEk+LrNAhd5Lsohbkf/
        PEDBQZ/NmJCfi05vf1HO828a8px8xXIwRckVj1o3xg==
X-Google-Smtp-Source: ABdhPJyDzB78dlspkdv57D6lKhP1k8ztqHFo2E7C5fHa59ebKwfwL56Ur4uD3VuTWGZxksc+6Nv5R5JzT9OdFO7ANbY=
X-Received: by 2002:a5b:148:0:b0:650:15bd:97ab with SMTP id
 c8-20020a5b0148000000b0065015bd97abmr34942976ybp.231.1654684687126; Wed, 08
 Jun 2022 03:38:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220607233614.1133902-1-eric.dumazet@gmail.com>
 <20220607233614.1133902-2-eric.dumazet@gmail.com> <cea2c2c39d0e4f27b2e75cdbc8fce09d@AcuMS.aculab.com>
In-Reply-To: <cea2c2c39d0e4f27b2e75cdbc8fce09d@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 8 Jun 2022 03:37:55 -0700
Message-ID: <CANn89iJ8o+D86tOuO-ctPbaieNGOSM1dbfOYjMJERWH=r1P6Xw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/9] vlan: adopt u64_stats_t
To:     David Laight <David.Laight@aculab.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
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

On Wed, Jun 8, 2022 at 3:18 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Eric Dumazet
> > Sent: 08 June 2022 00:36
> >
> > As explained in commit 316580b69d0a ("u64_stats: provide u64_stats_t type")
> > we should use u64_stats_t and related accessors to avoid load/store tearing.
> >
> > Add READ_ONCE() when reading rx_errors & tx_dropped.
>
> Isn't this all getting entirely stupid?

Be careful about using these kinds of words, some people get offended
quite easily.

>
> AFAICT nearly every 'memory' access in the kernel is going
> to get wrapped in READ/WRITE_ONCE() to avoid something
> that really never actually happens?
>

When needed, yes. KCSAN can catch real bugs, thank you.

> It might be better to just mark everything 'volatile'.
> Although perhaps that ought to be a compiler option.
>
> OTOH I've seen gcc generate extra instructions for 'volatile'
> accesses - to the point where I used 'barrier()' to optimise
> code.
> I think the volatile casts in READ_ONCE() can generate worse
> code than volatile variables.

For these patches, code generation on x86 is actually exactly the same.

 Read https://lwn.net/Articles/793253

Then if you really think Jade Alglave, Will Deacon, Boqun Feng, David Howells,
 Daniel Lustig, Luc Maranget, Paul E. McKenney, Andrea Parri, Nicholas Piggin,
Alan Stern, Akira Yokosawa, and Peter Zijlstra were stupid, please
start a conversation
with them.

Thank you.
