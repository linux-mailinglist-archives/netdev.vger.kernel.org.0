Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4352F63FFD6
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 06:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbiLBFea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 00:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbiLBFe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 00:34:28 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05F1D159C
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 21:34:27 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-3bf4ade3364so38779927b3.3
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 21:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZGWt4CfUwAU9seMXwyyFcV9jbw0N3UPxY4xRafk6DjA=;
        b=aTd36vs4Utb9q3nP81XFoiHEuNpDzKX8fZMhvIxRuDivxebm6qNkaMXY9Qebmi4Db6
         LvGUwKogxDopEguMBk/pJM2EVKlGt6QdPyfvBRranHqATqHUyXhvltiIlh6VSAqL9PF0
         /kAj8dCDseZUILrsIHBLL1uxLIRiGA9c4SKETt98PN9GFsg9tegsvLNEuQmyzpeFXKvq
         jZtVBlu9mkpwC3WdFDC40ZO/jcCRpS2MsCtJTlZrTmKAtsYS9DEwATnzvPJ8i3jb5Nsz
         jld6dsXz610+aqDcq01Ks5WOp1tv9mJeqvXR6nQ9OYLk6UQrjhzfPhf/UutxUlfnf3Vp
         V6HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZGWt4CfUwAU9seMXwyyFcV9jbw0N3UPxY4xRafk6DjA=;
        b=ZVeqTMxZZEtsegssPwYifNyCnOdxFyPdxzQq7tYGZY3DHxETOImbxQX8CpSlhFa6nS
         e9Q4Q5Vaku5cS4qrCB8X7FYKPHMfTTlsiBTmxcyRNleAC/dfyYI/v7lVKZWMxjwKFfyv
         Dou/l8xIFMUc7NycUbRlBkdi8lIM3yUaXRXYft1Wa9BQCSUTRCcQQPDGqnJKCXOv0fq7
         Gddd3h3x1dJGIJqN7h6Gn5VJVI0vHklDZQLzKx7HWYa8cp/CrbZ+RXh8Iant4XPvE6dr
         Z4ui0bHh+w7BRa77AQajQMMgDxbfoE8qhE+i8uYPocseENY+P6/k5CWd06ynCdSeWMXa
         /GcA==
X-Gm-Message-State: ANoB5pmJRU+V0THyPrOhqfZJtm4IA4MUTLS2Cvs9phchRxw5FqaQYOjr
        TuDqI4Me8ofmLkDtpKmIX3XqshS1E9GNQQWoPDisag==
X-Google-Smtp-Source: AA0mqf6lbtp4pfw4gb606wdmfhmoZjhXTB3DgAkqmSfrGI4Hud7BpEae5+YfRZRxX8StoMirKfg2CzmwBkzqrEF0T1k=
X-Received: by 2002:a81:5f04:0:b0:393:ab0b:5a31 with SMTP id
 t4-20020a815f04000000b00393ab0b5a31mr65374467ywb.55.1669959266617; Thu, 01
 Dec 2022 21:34:26 -0800 (PST)
MIME-Version: 1.0
References: <20221123173859.473629-1-dima@arista.com> <20221123173859.473629-4-dima@arista.com>
 <CANn89iJEYhTFsF8vqe6enE7d107HfXZvgxN=iLGQj21sx9gwcQ@mail.gmail.com> <CANn89i+6dKFvBRHNyfSbZ6e+Azjz-x48D1um0qrKVRw0xoUquA@mail.gmail.com>
In-Reply-To: <CANn89i+6dKFvBRHNyfSbZ6e+Azjz-x48D1um0qrKVRw0xoUquA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 2 Dec 2022 06:34:14 +0100
Message-ID: <CANn89iLBOaEFezGidVsyLb6uw=9eKUnvH10WvNW7RYfkTiESkg@mail.gmail.com>
Subject: Re: [PATCH v6 3/5] net/tcp: Disable TCP-MD5 static key on
 tcp_md5sig_info destruction
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 2, 2022 at 6:05 AM Eric Dumazet <edumazet@google.com> wrote:
>
> Hmm, I missed two kfree_rcu(key) calls, I will send the following fix:
>

https://patchwork.kernel.org/project/netdevbpf/patch/20221202052847.2623997-1-edumazet@google.com/
