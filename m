Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F2D612F08
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 03:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJaCgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 22:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaCgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 22:36:04 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16826547;
        Sun, 30 Oct 2022 19:36:01 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id h12so8449706ljg.9;
        Sun, 30 Oct 2022 19:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5PfdcaHbK409/PjJykKyVzJZf3xmCOMU8c25nhLHBxY=;
        b=SKcG3AFVwF4hYcc/EE2IjWL74lIAZlX/a65EZnlWHZ6J6J2KsfbclaguNsoddUdU8m
         gabJU53NoZpbtSUoZr9zpdUSI6onTf/Ei4SeI13yfLrzZgxHEff57ca/qRw0YqM24hz0
         Hw5DHOR+IZQsGyNZVZ1ZAErmlZJmG0WrbblGoyfKb/O5zEYoGRfHjwJDE4bahcoQWv41
         5W4Hy1m0kGda0ak9heyZgLckCwQNrA4ORuzyy0MEyBQyt1LrA7hacBaOjKBeo3/w3sfy
         DFs8jA9fXYASvVtH8f/AJr+p9Qc17lkvPwqCmHUE/hb4qcv/Ivy5tUM9sH7MUUv4yghs
         FX8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5PfdcaHbK409/PjJykKyVzJZf3xmCOMU8c25nhLHBxY=;
        b=TTewCiHXo2ScjPAd/ERJCLdqRkKBuGxEiDHPmd9mljCDFqy8JM2RLb2nDzUGqrGon9
         H0FSkYOLhc6DbgtwJgq/qRE3L5Wi7yD+PpPxiAMk35tNwh39H29oGw38WmlqJilK6Lsd
         +jSW66LeQQyo5FX37nhoOkCA0bRedYCXxoOwxub4dLZIV/g9VtIvY6gNvdQJPXsvIakl
         VY4KdtBGjiWMC2GKe+t2M18JiJML/3eAINKQmyIJ4AtKqVbFzRF4GN3ilf2Lp6jp7Lbf
         WL8vHZweOCgpK1K2gEqsmYR2EnQpWfZ3y0CK+042xVjw3/1WJE0QlQXqoP1h2xCGXgW4
         lP8g==
X-Gm-Message-State: ACrzQf1nxX1cS1kUYk+YoxgB9Ou7N1qipf4updlCb35quJKu9d9Ih6+4
        Kr3GO3sMdn4qlkrXLLFOWm3cITrm1Mu8lPyRT7k=
X-Google-Smtp-Source: AMsMyM7kV6hCwzToOKN2TCB/tUpz9cIitxH41CZ9m9wDB2ZiyTdi+ftKXzhhTKVILXgh4SQ9ZHn9bNOzqAKpA0gVoeY=
X-Received: by 2002:a2e:bf23:0:b0:277:f54:f0fe with SMTP id
 c35-20020a2ebf23000000b002770f54f0femr4333886ljr.440.1667183760269; Sun, 30
 Oct 2022 19:36:00 -0700 (PDT)
MIME-Version: 1.0
References: <20221029130957.1292060-1-imagedong@tencent.com>
 <20221029130957.1292060-2-imagedong@tencent.com> <CANn89iK60VLmy3Y_7TZC-pXMZCho=W=uKPV2uf2tUmLdzJ1oFg@mail.gmail.com>
In-Reply-To: <CANn89iK60VLmy3Y_7TZC-pXMZCho=W=uKPV2uf2tUmLdzJ1oFg@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Mon, 31 Oct 2022 10:35:48 +0800
Message-ID: <CADxym3b1mj8pNO0RG_A=bWCyg0GDNDTZaTj3GPqtQFSRb8CZxg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/9] net: skb: introduce try_kfree_skb()
To:     Eric Dumazet <edumazet@google.com>
Cc:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, imagedong@tencent.com,
        kafai@fb.com, asml.silence@gmail.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
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

On Sat, Oct 29, 2022 at 11:30 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, Oct 29, 2022 at 6:11 AM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > In order to simply the code, introduce try_kfree_skb(), which allow
> > SKB_NOT_DROPPED_YET to be passed. When the reason is SKB_NOT_DROPPED_YET,
> > consume_skb() will be called to free the skb normally. Otherwise,
> > kfree_skb_reason() will be called.
> >
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  include/linux/skbuff.h | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 59c9fd55699d..f722accc054e 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -1236,6 +1236,15 @@ static inline void consume_skb(struct sk_buff *skb)
> >  }
> >  #endif
> >
> > +static inline void try_kfree_skb(struct sk_buff *skb,
> > +                                enum skb_drop_reason reason)
> > +{
> > +       if (reason != SKB_NOT_DROPPED_YET)
> > +               kfree_skb_reason(skb, reason);
> > +       else
> > +               consume_skb(skb);
> > +}
> > +
>
> My proposal looks better IMO
>
> https://patchwork.kernel.org/project/netdevbpf/patch/20221028133043.2312984-2-edumazet@google.com/

Hnn...yeah, your idea seems fine, which wont
affect the existing code.
