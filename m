Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6534E2DE5
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 17:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351097AbiCUQ3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 12:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351104AbiCUQ3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 12:29:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC83DF47
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 09:28:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4FD2B8189B
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 16:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31ECBC340F2
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 16:28:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="SODin2tF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1647880083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3OOD2MfGfSggaNPfeCMOT5B6+t2ohiJDT109MO1Op8A=;
        b=SODin2tF44/WhFsXT4NsSm2CNI3WLJAP+LEVUKvF95tO3H8l7h0Q69SmAB/0yoX+VNNNzy
        9GIkxHmeid4ck6F9EmxoSwTYHtXUEXB9fLVxYlDIE8yeHvQ/MJWje5AfL0ohVt7LKlC8vk
        50VRTOumv1n3LpUXdSzAeCRL895DQOo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8e4c02e9 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 21 Mar 2022 16:28:03 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id j2so29136983ybu.0
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 09:28:03 -0700 (PDT)
X-Gm-Message-State: AOAM533Fx0/rO8rW/hS2zcZ8Z9BLqg4zsY+kcZqx2i4Pv+Hsptsrdel6
        oCU/NVPqWLEPTkq1Be1jjyaSst6ZVKzUD7LknFA=
X-Google-Smtp-Source: ABdhPJzAwnNXsC7CxbncboSkp/CbcNL0Wroq8xEXIvjpLTA6lrUxo75s5sKk4bww1UE44GL346rieL0iqozWjteRqWI=
X-Received: by 2002:a5b:6cf:0:b0:61e:1371:3cda with SMTP id
 r15-20020a5b06cf000000b0061e13713cdamr23302155ybq.235.1647880081252; Mon, 21
 Mar 2022 09:28:01 -0700 (PDT)
MIME-Version: 1.0
References: <YjhD3ZKWysyw8rc6@linutronix.de>
In-Reply-To: <YjhD3ZKWysyw8rc6@linutronix.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 21 Mar 2022 10:27:50 -0600
X-Gmail-Original-Message-ID: <CAHmME9r=NNaA1v55dHxy0Szsqp4PbbSDGUaOeKYtjyNXhGN7_Q@mail.gmail.com>
Message-ID: <CAHmME9r=NNaA1v55dHxy0Szsqp4PbbSDGUaOeKYtjyNXhGN7_Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Revert the softirq will run annotation in ____napi_schedule().
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sebastian,

On Mon, Mar 21, 2022 at 3:22 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> The lockdep annotation lockdep_assert_softirq_will_run() expects that
> either hard or soft interrupts are disabled because both guaranty that
> the "raised" soft-interrupts will be processed once the context is left.
>
> This triggers in flush_smp_call_function_from_idle() but it this case it
> explicitly calls do_softirq() in case of pending softirqs.
>
> Revert the "softirq will run" annotation in ____napi_schedule() and move
> the check back to __netif_rx() as it was. Keep the IRQ-off assert in
> ____napi_schedule() because this is always required.
>
> Fixes: fbd9a2ceba5c7 ("net: Add lockdep asserts to ____napi_schedule().")
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

I can confirm that this fixes the WireGuard splat, so:

Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>

Jason
