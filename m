Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709885F3AC8
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 02:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiJDAoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 20:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJDAoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 20:44:08 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284C52AE25
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 17:44:07 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id 3so5646619vsh.5
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 17:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=93G0HG3RfKm4r5i70WUjUQ57IVRyqt13+I6tSjUL1sY=;
        b=S7F8uQg+qZsvqxHrEZyofolJTHztZct0LS9lwnz+Rhg4kELp39BzodFNNwuGmELh6P
         u3Vq5K6q7H6X8p97eiMwRhkH7LoCySbDx0zXkK5hsVFNn3Czle7QVeSn2u2kSGWvTjma
         MTWFL2nOj3pwYKwBmkpMrWdHKKvCsbQAk9VYrcJkewR1lNeMA+Y7P/racoWfsTo2GD/y
         zFIkd/zCk+3qAjzWpdh15qSC/cGpAaO0qQZS+bK29oAJEUmFGGOP21V6vd5tZmfJma4t
         /SPW/uRd9qZXUsbRKFbTv2NaK2+AeKllACCR0QA6stYlxx5D1lpVNaHuGU1ikrv2SILF
         46Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=93G0HG3RfKm4r5i70WUjUQ57IVRyqt13+I6tSjUL1sY=;
        b=N7s+XiYD8hfe9c3zMlHGoyjauk5946F13VBTfO1IftOYxeU2bCuVDQ1iJ/c6YWMcCI
         UtQy5/Xtp88DqbrPHUDVf/MoFptOcdaHFrWPLkAgbJ6/hSDSmtR8JCWEtxFPRKU+uaTC
         uNYA2+4o1BuNJ3f5g77uJ/AMDywoZu/HbKXSu38H8SSyunMPsVT638k9HKdxxymV9Ude
         7YQN7e1QvL1atP+FP4RxjdMyaDz8Y5ev6hJhNmHex9HY97OKIS7AfhtIL4F40/Qbfva7
         ya1jQSLLwwqZBWiQE874LFd1HcVwwkYdUextxtEX+NFAKtjgkOs+FCLZKybmJ56aJbtZ
         PTiA==
X-Gm-Message-State: ACrzQf3ohevvuaEzmVexdU34uz5ELP5aSPccdemMrXSN1n+BHcUWXbTa
        hO9OJCEg4Z2NX6D3obAujK78qQjRi7olwdteotI=
X-Google-Smtp-Source: AMsMyM4MIf+rbQN4UB+hwvN9c5xwXDmtN0Hir2n3mKihz5nPowxvmjIKjV++zSwK84FdNFbSk0yf39srli/a/CkhahA=
X-Received: by 2002:a67:e10c:0:b0:3a6:6945:1d20 with SMTP id
 d12-20020a67e10c000000b003a669451d20mr3236499vsl.57.1664844246192; Mon, 03
 Oct 2022 17:44:06 -0700 (PDT)
MIME-Version: 1.0
References: <20221002151702.3932770-1-yury.norov@gmail.com>
 <20221003095048.1a683ba7@kernel.org> <YzsluT4ET0zyjCtp@yury-laptop>
 <20221003162556.10a80858@kernel.org> <Yzt5Q6G8v5xuYD7s@yury-laptop> <20221003172953.128735bf@kernel.org>
In-Reply-To: <20221003172953.128735bf@kernel.org>
From:   Yury Norov <yury.norov@gmail.com>
Date:   Mon, 3 Oct 2022 17:43:55 -0700
Message-ID: <CAAH8bW-6iS4bdfCGHSZa4U9=g8rWb78fA80dfQjyuGpAkY5bzQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] net: drop netif_attrmask_next*()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>
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

On Mon, Oct 3, 2022 at 5:29 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 3 Oct 2022 17:07:31 -0700 Yury Norov wrote:
> > > I see. Is that patch merged and on it's way?
> >
> > This patch is already in pull request.
> >
> > > Perhaps we can just revert it and try again after the merge window?
> >
> > I don't understand this. To me it looks fairly normal - the check has
> > been fixed and merged (likely) in -rc1. After that we have 2 month to
> > spot, fix and test all issues discovered with correct cpumask_check().
> >
> > I'm not insisting in moving this series in -rc1. Let's give it review
> > and careful testing, and merge in -rc2, 3 or whatever is appropriate.
> >
> > Regarding cpumask_check() patch - I'd like to have it in -rc1 because
> > it will give people enough time to test their code...
>
> AFAIU you can keep the cpumask_check() patch, we just need to revert
> the netdev patch from your earlier series?

Yeah, I meant the "net: fix cpu_max_bits_warn() usage in
netif_attrmask_next{,_and}".

> If so I strongly prefer that we revert the broken cleanup rather than
> try to pile on more re-factoring.

What do you mean by broken cleanup? Netdev patch is acked by you,
and this series didn't receive negative feedback so far.

> The trees are not going anywhere, we can queue the patches for 6.2.

Sure, 6.2 is OK as well, but I think any 6.1-rc would be more appropriate.
