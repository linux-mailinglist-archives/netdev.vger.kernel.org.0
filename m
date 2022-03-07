Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF564D05D0
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 18:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244103AbiCGSAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 13:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236338AbiCGSAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 13:00:43 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F246E5C343;
        Mon,  7 Mar 2022 09:59:48 -0800 (PST)
Date:   Mon, 7 Mar 2022 18:59:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646675986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QPqZCsSMUpT1klICkBMJK4cJGdzAgay2cyjOQSPKVqE=;
        b=k+wFjnO44RUwF9VUiX0v6wQyJEFLm0Yn9RN8rFsInRQ/Sj5+/8F9+I/IYAU9aFLY3Cng2i
        EfbVZCXwCOBQ5ap49Ym+f3rm6jVIuK3GLvehlso6JJvhflXjfi6PoqJ0+gyhqafwlyzxvY
        p+lRQHKkPWyEJ2EgTjqeofp0sWbgcq1dg36hjgtsjhxkfvfztHgASPvaU37vbF4vxDTLee
        GvvJW2D4xECNma4v3H05oRu5cmjogrssJMWBNOzSTPqQ4UAnn5EezLz9f8Lg87S6xnizle
        vdrhXsG/vyaj9/JM1fPzca7Nf3Mt+u23/6UoS6JQ6b9rMhGjmsChfFKjtEY+sg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646675986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QPqZCsSMUpT1klICkBMJK4cJGdzAgay2cyjOQSPKVqE=;
        b=f5ECwViYfCQYjtP37gcgMZpTeRhBAdRTkLmSl6tjntJWhcw37TZV4HDkte0xA3zp53HeSr
        Mze1eER0KxCXRjCw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH net] xdp: xdp_mem_allocator can be NULL in
 trace_mem_connect().
Message-ID: <YiZIEVTRMQVYe8DP@linutronix.de>
References: <YiC0BwndXiwxGDNz@linutronix.de>
 <875yovdtm4.fsf@toke.dk>
 <YiDM0WRlWuM2jjNJ@linutronix.de>
 <87y21l7lmr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <87y21l7lmr.fsf@toke.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-07 17:50:04 [+0100], Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>=20
> Right, looking at the code again, the id is only assigned in the path
> that doesn't return NULL from __xdp_reg_mem_model().
>=20
> Given that the trace points were put in specifically to be able to pair
> connect/disconnect using the IDs, I don't think there's any use to
> creating the events if there's no ID, so I think we should fix it by
> skipping the trace event entirely if xdp_alloc is NULL.

This sounds like a reasonable explanation. If nobody disagrees then I
post a new patch tomorrow and try to recycle some of what you wrote :)

> -Toke

Sebastian
