Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00ED06327AC
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 16:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiKUPSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 10:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiKUPSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 10:18:25 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15AEBC9004;
        Mon, 21 Nov 2022 07:15:03 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669043701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lQs41vOGOvnHYar/SBs/fIZbe2lCGZcidC+QpnC5+YA=;
        b=XgZX/EawdUnHd2MXtEoy87d6nt+KM389bWtRrqoe0XFZHtITdDNk4hVa5QwgIBOuehV0Sz
        lQht1CKPRzB/l4FD4+xLb5StknGESbNfWg2Dm9KazLmvnr3ed/JI4zN39kfgPCGxYB8okH
        grNhg0KAbltwcAsSTLsvIhJZ0BxohXGTbIB9ne9OnAjLrNfRA0ZX4ULQr2wPoT36+cZnKO
        4SGTwJDocHdyyD/Auq7blBlhbtVsf/0QPszag7uI39CPfavtspZhsfrlpWcyfyCtBBJFTj
        x/Ek32HhUuWYUEi4hYeMOguUeIGIUMCjLgDTRjpnyYXLL/I2jh8VZODfaojb3g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669043701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lQs41vOGOvnHYar/SBs/fIZbe2lCGZcidC+QpnC5+YA=;
        b=7KRj+LiX/2jRIeYeQzj84IQ0G08p2TBQ3wjPtKuSvCYPFz5aHUno33L+nDPus4CvCeeNAK
        XbrEhVyN27ccJIDA==
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [patch 00/15] timers: Provide timer_shutdown[_sync]()
In-Reply-To: <20221115195802.415956561@linutronix.de>
References: <20221115195802.415956561@linutronix.de>
Date:   Mon, 21 Nov 2022 16:15:00 +0100
Message-ID: <87mt8kibkb.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15 2022 at 21:28, Thomas Gleixner wrote:
>
> As Steven is short of cycles, I made some spare cycles available and
> reworked the patch series to follow the new semantics and plugged the races
> which were discovered during review.

Any opinions on this pile or should I just declare it's perfect and
queue it for 6.2?

Thanks,

        tglx
