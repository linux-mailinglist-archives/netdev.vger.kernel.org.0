Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799704A9F71
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377729AbiBDSqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377723AbiBDSqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:46:45 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D5BC061401
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 10:46:44 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id 124so20714546ybw.6
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 10:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E5IqHdRqOH58EvmQmiv1heLKaoB5zdzTs0MGfgNcprE=;
        b=AxlWy810ku0QzeEt9j6ydx3xpW+heVy+MVyOoVCRrdo537hNw31i/JU9jMTISIojKl
         VLNYG0tsw4NMi3j785UkRIxIgnMqEaazhuHvuzpWG0VDPjgcjkgLlGSIRWDqy7z+uzi+
         BF4Dixlbe7SXu4tf0BZWTZ4f9nyAmCcC1xJ8Z7Al6dso/vyZaFsgdseY/PA6vR3RJn2O
         mQd4KRC+2nJFXvuOU300AhkLQBOaTXVOpr+QMDZN6+XtanULlk+GAYkkNTcBOHlWuw3A
         7y1XT2hZYGbRP0++yqseu865tTTH+pmrqCH0Xyd4XkBEa/z2WLN+p7BoKRWIsgMv/wkJ
         yeXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E5IqHdRqOH58EvmQmiv1heLKaoB5zdzTs0MGfgNcprE=;
        b=gsfGQHEDPe/3FiFKlQPIAl8RL1FS4fCpUl2+4rghI1vv4TrhbvoTCXOaVHpL15W04v
         DjvVMSIPAqDAA+I5dW548J+ohpLYIhKhKzdmQsxENDhdwOdi7lvAc1ESeTeHIYrrO+we
         dbQXiROnKUf8D1scEoixuszuBLUfGxPq47B7xOA2dSnXZreEs6S+M9CeJWSsN8Ywt0Dr
         vPWB7eEvKOg2FF5VBA41vxB14M6YKsOKnrHT7jrwo7XoR+NWBURGkenpyOZ3rcXZgMCi
         DUu6677gjMOLzf/vOAoVLGcWIIkZ8zqeWExaSirlEQJDQFUZFEcqgI+14dg5G6AOcYSi
         +ToA==
X-Gm-Message-State: AOAM533VCGYLCQ/lb0MyAt49Lpa15peZJ9pBKSiRKCIJn8I91+sLgEV+
        m3xi3qxLZtzl3ZWm8RVbiOrBQlXFIywTVm7V5l8qtw==
X-Google-Smtp-Source: ABdhPJwXLPk+kA8jFN4oekhtgfibKwxEN+Y4Lyzh/9f9UPojXnc5w7kqdcPVMpqfINcYim4G82qrecnb1zshBq3UNBs=
X-Received: by 2002:a25:3444:: with SMTP id b65mr526514yba.5.1644000403680;
 Fri, 04 Feb 2022 10:46:43 -0800 (PST)
MIME-Version: 1.0
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-4-bigeasy@linutronix.de> <CANn89iLVPnhybrdjRh6ccv6UZHW-_W0ZHRO5c7dnWU44FUgd_g@mail.gmail.com>
 <YfvwbsKm4XtTUlsx@linutronix.de> <CANn89i+66MvzQVp=eTENzZY6s8+B+jQCoKEO_vXdzaDeHVTH5w@mail.gmail.com>
 <Yfv3c+5XieVR0xAh@linutronix.de> <CANn89i+t4TgrryvSBmBMfsY63m6Fhxi+smiKfOwHTRAKxvcPLQ@mail.gmail.com>
 <Yf0jWtF2/0pYcjXI@linutronix.de>
In-Reply-To: <Yf0jWtF2/0pYcjXI@linutronix.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Feb 2022 10:46:32 -0800
Message-ID: <CANn89iJcK8+3uJm+ikKUnpAqSeWDYhuTXKBMnriRzZfT7wwprg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/4] net: dev: Makes sure netif_rx() can be
 invoked in any context.
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 4, 2022 at 5:00 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> Dave suggested a while ago (eleven years by now) "Let's make netif_rx()
> work in all contexts and get rid of netif_rx_ni()". Eric agreed and
> pointed out that modern devices should use netif_receive_skb() to avoid
> the overhead.
> In the meantime someone added another variant, netif_rx_any_context(),
> which behaves as suggested.
>
> netif_rx() must be invoked with disabled bottom halves to ensure that
> pending softirqs, which were raised within the function, are handled.
> netif_rx_ni() can be invoked only from process context (bottom halves
> must be enabled) because the function handles pending softirqs without
> checking if bottom halves were disabled or not.
> netif_rx_any_context() invokes on the former functions by checking
> in_interrupts().
>
> netif_rx() could be taught to handle both cases (disabled and enabled
> bottom halves) by simply disabling bottom halves while invoking
> netif_rx_internal(). The local_bh_enable() invocation will then invoke
> pending softirqs only if the BH-disable counter drops to zero.
>
> Eric is concerned about the overhead of BH-disable+enable especially in
> regard to the loopback driver. As critical as this driver is, it will
> receive a shortcut to avoid the additional overhead which is not needed.
>
> Add a local_bh_disable() section in netif_rx() to ensure softirqs are
> handled if needed. Provide the internal bits as __netif_rx() which can
> be used by the loopback driver. This function is not exported so it
> can't be used by modules.
> Make netif_rx_ni() and netif_rx_any_context() invoke netif_rx() so they
> can be removed once they are no more users left.
>
> Link: https://lkml.kernel.org/r/20100415.020246.218622820.davem@davemloft.net
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>

Nice, thanks !

Reviewed-by: Eric Dumazet <edumazet@google.com>
