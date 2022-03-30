Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E2C4ECD3B
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 21:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350723AbiC3TaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 15:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350728AbiC3TaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 15:30:21 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBFE30550
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 12:28:33 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id p10so31709813lfa.12
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 12:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jVig4TMXo4XXW+YYHFnVZTCO1uSpbm2NwpusO0nWM20=;
        b=eoAarFYSq60lhcO0YE7U6h8l1TAYLsyl0mwxA7kyk0Yf1FEPtAz0UDJNugw0CuGySz
         QC8AA8LwEOz7YnhM5H8EYLCMgvcySHe66L0/u6GiqQheodoMrPENraETAYN9xc6fW/5d
         ftWAS0w3hXHYM0Ao8IqqpFHIl/DI2GyDW9+nk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jVig4TMXo4XXW+YYHFnVZTCO1uSpbm2NwpusO0nWM20=;
        b=dBe8A8wM5CrB1KDedGffUeqEkvXURel6s8tZo5Gdsma7rSk4yH/tDknvPyDoYatObJ
         tRML7aUhim2D0PXmEiYAqxQc2som6uGreqXdZ4yWbS3bmUmypXsGASTfK9kwh1HERJ8u
         8tSK3hV2mHvsjwdsRhYUNQYk+HKC/ojI4NhhpPfFKfIYOYLPyeG+iMwgKbRi3YInkIhe
         8/1xrlWMrSBt0r/G44wIzssHtczErsrluXDotDGiYvzNxhZLj71QeDv/Ve75dM4LO5Xf
         2A5z3jVub6Y/WIN9r6PZcp/pCLmxTqt6oBkwnrbk9K5wbnAHEoG9gs6aPqxhjvfJPlFU
         tdjA==
X-Gm-Message-State: AOAM531eLk956CFmt58Q4XukFnXsmCEFyUXIiAyJCCSNsR9n2Il0fAzy
        /vioAuDg7+3uwPnUvOlX0MauW6cLepnA1bZy
X-Google-Smtp-Source: ABdhPJygwXb9qOIqD9F+cuBFKPtRIbYcBAz+MrxEb+M/yLPa7kSqN8S6TZt3fQOZyjGldhdezBff9A==
X-Received: by 2002:a05:6512:12c3:b0:44a:27c2:b0a2 with SMTP id p3-20020a05651212c300b0044a27c2b0a2mr8252897lfg.325.1648668508998;
        Wed, 30 Mar 2022 12:28:28 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id bp3-20020a056512158300b0044318361eedsm2429506lfb.204.2022.03.30.12.28.27
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 12:28:28 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id e16so37542987lfc.13
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 12:28:27 -0700 (PDT)
X-Received: by 2002:a05:6512:3055:b0:44a:3914:6603 with SMTP id
 b21-20020a056512305500b0044a39146603mr8015065lfb.435.1648668507455; Wed, 30
 Mar 2022 12:28:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220329222514.51af6c07@gandalf.local.home> <1546405229.199729.1648659253425.JavaMail.zimbra@efficios.com>
In-Reply-To: <1546405229.199729.1648659253425.JavaMail.zimbra@efficios.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 30 Mar 2022 12:28:11 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgZ0RccFsUhgKpdh130ydsY57bqaCGRQS7w3-ckgHP=OA@mail.gmail.com>
Message-ID: <CAHk-=wgZ0RccFsUhgKpdh130ydsY57bqaCGRQS7w3-ckgHP=OA@mail.gmail.com>
Subject: Re: [PATCH] tracing: Set user_events to BROKEN
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     rostedt <rostedt@goodmis.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 9:54 AM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> If we are not ready to commit to an ABI, perhaps it would be safer to ensure
> that include/uapi/linux/user_events.h is not installed with the uapi headers
> until it's ready.

I don't th8ink the uapi matters if the code then cannot be used.
There's no regression in that.

That said, if we leave the code in the kernel source tree, I feel like
we should probably at least compile-test it.

So maybe it should be marked as

        depends on BROKEN || COMPILE_TEST

instead?

             Linus
