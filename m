Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5208E5A056E
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 02:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiHYA4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 20:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiHYA4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 20:56:38 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C53144540;
        Wed, 24 Aug 2022 17:56:37 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id r4so24141391edi.8;
        Wed, 24 Aug 2022 17:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Fb8xGD4kaa92dvVnQPrRFtkQAV3xtlSQACdU3g7w0Yo=;
        b=OrYgLPE69cuXrh8bm5isYc18fYjBF2hdQdbz+PZ6qzP1YKTeUMrFrv69AgJXZM4XyC
         7DksdJb97ITyn4r0kKmuv77uIP+h0edJeuSoVPqeZelsFQczF4TIEOrPp0geqRY0k1n5
         5zVLxs9ck0E7hDRGNZYdvlr83XGYat+sECsSfn/du1TJ4hZi5YUajOq0z4DozqzadTzA
         XRt5OXJpkiXgOB4zuBpZUC9GGwDMHR+JE1ImeKsOFmNp9VU3gzTPOiOf7a/4yrmVcW78
         mnEuVc1WSggGWrmqd1oKxppmNI61xMGqt+WPCj1I58DkSF/jazpyyrH0WXubYIP0QLGv
         nCJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Fb8xGD4kaa92dvVnQPrRFtkQAV3xtlSQACdU3g7w0Yo=;
        b=fzixKzimTo+s6AcD9s0sSwyEBi1awnuxj0X6p5Zdi77GMYdhBWtsIvAX2LfH0bAyw4
         +b6EKqlg+Mtym7rw9beBqwUCe21UIV5kaeMxEMuWZ/sMVkSOXkT3DikzXM4XbcG3xH8n
         8UVWvJs8TrOsUQg6DIYy1v2fsbJiE2iq5160jbDIzvatVBzD+YeYJDI/rcdKxuITtCT7
         mgp08dxUpZWiKTmiBT+p8Al3USVYP3BYA53GoLarq6x2+TKHyWd2da8KibFZSsJywS9Q
         3PiMmONvIY+GBtK2iXcBsSF7UiW2/Fz8h73gDrcEhcwpCUyZ+D8MIkpiSBeg4kX9EIlX
         e7PQ==
X-Gm-Message-State: ACgBeo1a031yF+Aup5qvuNZ2KkplusJcqmmDSBbKIg/SMEumcmQIstM4
        SOhMsk2Rc2Ii9pGIpK+6+nEK5dL//O335hxplk8aB3z6
X-Google-Smtp-Source: AA6agR5Vptc/+u0DKWCDlF23ms6GUEpk7kcZM3dVULL9AL7cqxrFGEiy/U1dRol/prPYEdh8P8YsN8uPAugncZRu9IY=
X-Received: by 2002:a05:6402:28cb:b0:43b:c6d7:ef92 with SMTP id
 ef11-20020a05640228cb00b0043bc6d7ef92mr1188312edb.333.1661388996135; Wed, 24
 Aug 2022 17:56:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220824150051.54eb7748@canb.auug.org.au> <CAP01T74GyRjXRZaDA-E5CXeaoKaf+FegQFxNP9k6kt8cvbt+EA@mail.gmail.com>
In-Reply-To: <CAP01T74GyRjXRZaDA-E5CXeaoKaf+FegQFxNP9k6kt8cvbt+EA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 24 Aug 2022 17:56:24 -0700
Message-ID: <CAADnVQJsGudS7W=GcJGQyrzwsZ26=uCDQUW7MGDZ-RVpdsOH6A@mail.gmail.com>
Subject: Re: linux-next: Fixes tag needs some work in the bpf-next tree
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
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

On Wed, Aug 24, 2022 at 10:05 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Wed, 24 Aug 2022 at 07:00, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Hi all,
> >
> > In commit
> >
> >   2e5e0e8ede02 ("bpf: Fix reference state management for synchronous callbacks")
> >
> > Fixes tag
> >
> >   Fixes: 69c87ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
> >
> > has these problem(s):
> >
> >   - Target SHA1 does not exist
> >
> > Maybe you meant
> >
> > Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
> >
>
> Ugh, really sorry, I must have fat fingered and pressed 'x' in vim
> while editing the commit message. I always generate these using a git
> fixes alias.

Since that was caught quickly there weren't that many commits on top.
Fixed and force pushed bpf-next.

We actually have a script that checks such sha-s. Not sure how we missed it.
