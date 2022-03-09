Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7900C4D3C7C
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 23:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbiCIWBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 17:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbiCIWBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 17:01:41 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B43C49C93
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 14:00:41 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id z26so5153789lji.8
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 14:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nkF/iAt7zQngwBQGSbZNJUlDE3bsx9bdWRBJLw2V900=;
        b=HWF5hASJARawgpaXNdI6Rb8Y2dnh8FtUoity9ZalUzXki0GHKn7T93NZ9gESilsiEA
         rP4cwB5l/0+eyEEREAbd9MR5NcBhH61zpaLexYiZ+kFiQKNvZLfaJo8SITCui2eOnN01
         71gAsK+2pqIn3KKgzOdX2DQY9MNUVzzkf794vnhEkiTeCyR+isySENMQ6wRpv2+WixZM
         fWW3L/EPVUiB/C1+nBto4jO7jLVJ02I9FT8ZS1G7dykKkI3R/DUiIFQZl+N8obMkNdjK
         Z1hDPtxh9inQYnmaztz595XjBVqlrgZvuqa3ea+zHvAVs5eUdn5NqqcExpNIYBO8eMmH
         SdQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nkF/iAt7zQngwBQGSbZNJUlDE3bsx9bdWRBJLw2V900=;
        b=3he2uyILj8qwv3y+bNEjHeXk32aqKdXc+akUF25r5ZkfLo8KT0lXcurNUX+2+rcYua
         3EXs7SZGwYO1g2tmTPytIZCSMu/gRmTBOe9NA1Ts5dvSX9r2Ef18W6QlPqxYluupssIH
         Uj6FH4XUrAce2a9vguntVNmwNvvmTDN3iWLGyBoYR2wYkS+Xeo+SDaOWjKAOy0fbgC8D
         3BzoxZHn7sj/y+Affqu2i/LrGVZ+YH+1ajA8Z7AzodM3ONOcVvb+1+jtaqEQpqfPBA52
         7DkRtWJD4jcrVohdyi4JVbGRowhsgZ3iWWY1q7NrBtixvROvcctoGWSdG3z4xnHY6xY0
         AEoQ==
X-Gm-Message-State: AOAM5312Uhj6EB7ESbfe/U/oenMJ9NqC8/+waDbMQC8063OLTQBESs70
        yEL5xkZkoDWVwi7uaTlKzfJGkw2Mkk/AtPshx0w2xQ==
X-Google-Smtp-Source: ABdhPJx6xOe5ei64ARYmclCCFnjVyVn1oteujF3Vz0+vuDEiNo9jJq09Mg3PJmSMRbng0sXDgaUTN+VU/37y+JMmXzs=
X-Received: by 2002:a05:651c:1989:b0:247:933b:3938 with SMTP id
 bx9-20020a05651c198900b00247933b3938mr1025154ljb.228.1646863239488; Wed, 09
 Mar 2022 14:00:39 -0800 (PST)
MIME-Version: 1.0
References: <20220309211808.114307-1-eric.dumazet@gmail.com> <20220309134341.6037bb1d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220309134341.6037bb1d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Wed, 9 Mar 2022 14:00:27 -0800
Message-ID: <CAMzD94TGoiH=pvxTYnGfkR+F-mfGYVBn4SZyo=_CHjqxUPWQDw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: add per-cpu storage and net->core_stats
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        jeffreyji <jeffreyji@google.com>
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

Thanks for the patch Eric!

Reviewed-by: Brian Vazquez <brianvv@google.com>

On Wed, Mar 9, 2022 at 1:43 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed,  9 Mar 2022 13:18:08 -0800 Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Before adding yet another possibly contended atomic_long_t,
> > it is time to add per-cpu storage for existing ones:
> >  dev->tx_dropped, dev->rx_dropped, and dev->rx_nohandler
> >
> > Because many devices do not have to increment such counters,
> > allocate the per-cpu storage on demand, so that dev_get_stats()
> > does not have to spend considerable time folding zero counters.
> >
> > Note that some drivers have abused these counters which
> > were supposed to be only used by core networking stack.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: jeffreyji <jeffreyji@google.com>
> > Cc: Brian Vazquez <brianvv@google.com>
>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
>
> Things to mention in passing, in case there is a v2:
>  - we could use a different header for this, netdevice.h is a monster
>  - netdev_core_stats_alloc() could have the last if inverted to keep
>    success path unindented
