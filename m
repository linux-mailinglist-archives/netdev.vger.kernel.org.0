Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543F357DDAB
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 11:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236212AbiGVJT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 05:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235875AbiGVJS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:18:27 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25DF6394
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 02:13:02 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id p132so7044758yba.3
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 02:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pY6RYACA/ULUo6I7wnptWPJYg1qoS6xaWm5YeN0citg=;
        b=pEb5JzGqzTvgvByNalUPVUN3m/BVCeu/C30RexjQkruBBxoL+D60zJgK5nk+fnNHDH
         S46hSQCroQq0qiljBtwEnbwiQR2t6tshMh9X/dmIcFXSroqbQWBjBjQFTS9D4cdOj2xy
         Edu5w2lDzE41GRq6SJYsnHeunwx3jgERio5NoDdDpCcepr+u1Nm4Tqj32RJL6h9llW1s
         vZPIJlPXv7kTrFCSk7to/5U2JBzVD5Eb2SMeCf2SsffXoTaaEXsGFi9S3AEN1yG9hPJI
         rWqQWV8NGe7FkR4KX8eG6lL05IpL6JC048L605HvN1xKJjR2CpBd4nCqFzNsJvl1m5R1
         706Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pY6RYACA/ULUo6I7wnptWPJYg1qoS6xaWm5YeN0citg=;
        b=EEMSRgfwz4bYnvJUjB655eBoFYKmROCji++DKHYGLCQxpVrxARGpBXhBlLN6eMfCS3
         /q/JHuKx4ZeCNWeqRh/LtOUrfivEovfVIvw56ZeC6zBxV9Cka3wvrvG4dAYGyWD5zLr4
         knuaLMTUXrgU1H/iBYlhcIpQm55MvBEFi82p2wjvnNemz66VfifLL2veA3osQugsLJTC
         kwIS2eTx+Kxe8tl3LK/4VL5CxpELX9uceCJM90RmjMZZh85aig3u7TZnX2uaQs8hqvs3
         Q1tkXjpD2FGBJGLmg00xSIk3OodOM5cSpug1P3Bqpb8l7Aj/z1d0qWoe+dxjcs/x4kYi
         XZ9Q==
X-Gm-Message-State: AJIora/8iz2MzzqALtYce5iw90mdiOXl9jxYhn//ZQ9beBAyMd96q257
        ffIL3Wpxhk0SzJP3pL+Oag2e0M5qeG3+Q+0yp8xKdg==
X-Google-Smtp-Source: AGRyM1ve7jVGM/fdaOdduOi9GpyML7/bUNfWCu0QbhXbvuDdCfLnzuQ+xLvX/dN+QLxYQ/ZFqetAvMTsoIzo0q+3Vj0=
X-Received: by 2002:a05:6902:114b:b0:66f:d0:57c7 with SMTP id
 p11-20020a056902114b00b0066f00d057c7mr2077046ybu.55.1658481181693; Fri, 22
 Jul 2022 02:13:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220721204404.388396-1-weiwan@google.com> <CADVnQy=5VzKqUSyQG48rfYPsS1cyHAW3_bZpvJfCs6AAxjPVQA@mail.gmail.com>
In-Reply-To: <CADVnQy=5VzKqUSyQG48rfYPsS1cyHAW3_bZpvJfCs6AAxjPVQA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 22 Jul 2022 11:12:49 +0200
Message-ID: <CANn89iKjee+1CEHbBPWTUw=ndW_0HtxQo_duMj9K0Dr11pcm+A@mail.gmail.com>
Subject: Re: [PATCH net v2] Revert "tcp: change pingpong threshold to 3"
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Wei Wang <weiwan@google.com>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>, LemmyHuang <hlm3280@163.com>
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

On Thu, Jul 21, 2022 at 10:56 PM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Thu, Jul 21, 2022 at 4:44 PM Wei Wang <weiwan@google.com> wrote:
> >
> > This reverts commit 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.
> >
> > This to-be-reverted commit was meant to apply a stricter rule for the
> > stack to enter pingpong mode. However, the condition used to check for
> > interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
> > jiffy based and might be too coarse, which delays the stack entering
> > pingpong mode.
> > We revert this patch so that we no longer use the above condition to
> > determine interactive session, and also reduce pingpong threshold to 1.
> >
> > Fixes: 4a41f453bedf ("tcp: change pingpong threshold to 3")
> > Reported-by: LemmyHuang <hlm3280@163.com>
> > Suggested-by: Neal Cardwell <ncardwell@google.com>
> > Signed-off-by: Wei Wang <weiwan@google.com>
> >
> > ---
> > v2: added Fixes tag
>
> Acked-by: Neal Cardwell <ncardwell@google.com>
>
> Looks great to me. Thanks, Wei!

Reviewed-by: Eric Dumazet <edumazet@google.com>
