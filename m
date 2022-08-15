Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0366B592987
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 08:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiHOGUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 02:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241102AbiHOGU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 02:20:26 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFBDBF3;
        Sun, 14 Aug 2022 23:20:25 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so5996346pjl.0;
        Sun, 14 Aug 2022 23:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=0N7v9NB+zTITlHWV38WKP0+2fjDBev38GBS55IA2ids=;
        b=fyFXjepqrbVTTf31vj6dOwSICEmjcGXa1iPUgBHBvWoLpD+XNvexGFSmw2V1ZP583n
         oig5zMrvuSeUC33XgWLbbroKmk2DGaY3PPuXWIOGxfkeUD/EQV5H42d7PX+CcUDVwwos
         kMDaiAPimFJcuiVLn2fT8YF2gz0Oo/JEBt2dWRXhA0TtSwYH3kTvOe6umoysg+esD4T2
         McidQjaTB7pmoAsZC/ADwic7bqO+hIPgyv7g5v3fu446ZMWtkDblTBf80XG4vsKa6F3c
         guScsx+MB+SNqfmfj6G7Mv5xpt9ygn+TuGGgtRWmwtb7z0gcAnSnw+sm8sol4OpeLFlI
         c+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=0N7v9NB+zTITlHWV38WKP0+2fjDBev38GBS55IA2ids=;
        b=xCuQy1PePo6pyTfZYLK2mrx4BGFvPaxHuEGvUlIpbYGdvbTUxKLcHzehuO6InvtrIR
         08/OyhCS2v4ov9PxO4IBiZ6wzwxMUO7abbVZ7Fr17C4oAihqPoMn62Y87xP9NLF85AlG
         GP75JGIHdqK5W5n42EUrK/be9IYgs6Hi+Aa9K8fwuAgfnxpHA/938Xn2jS3PdTc4LOZl
         NTIMUYnNFOE/0EPlmTzorCEmHNLWWDDQhdY8QKPZzRa080BrHANwsJzHAsG6wFFIz65W
         H/8COAuQLVOncwhNd72In3kSUg6Rs9OMrvDTXx/5Rad6dpoAHHl/oeaCSa7ekyArqjna
         L0iQ==
X-Gm-Message-State: ACgBeo1TiDlOo9RxES0jkLoMVIDfeBwLnyhkqBsY3D2BH1e4OSAB+uve
        ZmIYSFfKCxeUVA2lxi3C84xqf4HoRy0sJDB8R28=
X-Google-Smtp-Source: AA6agR5ISkU9FJmuQxr1fdmidmW/QagHEgVCAHh4YZYowTGfLH07zrBnhp0epw6GhJIzw8bUnLbxfuk3deRAzJxmC2M=
X-Received: by 2002:a17:902:e394:b0:171:3f46:1f13 with SMTP id
 g20-20020a170902e39400b001713f461f13mr14977436ple.174.1660544425121; Sun, 14
 Aug 2022 23:20:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220812025015.316609-1-imagedong@tencent.com> <CANiq72kgF-UAzvUVTgg9mh9RZ6sYwVxGpERzvCkueh1z2PeqTg@mail.gmail.com>
In-Reply-To: <CANiq72kgF-UAzvUVTgg9mh9RZ6sYwVxGpERzvCkueh1z2PeqTg@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Mon, 15 Aug 2022 14:20:14 +0800
Message-ID: <CADxym3aD-7Yek75RzAPuwgib+6UOKukcVqGz4bDCY8HPfop_mQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: skb: prevent the split of
 kfree_skb_reason() by gcc
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     kuba@kernel.org, ojeda@kernel.org, ndesaulniers@google.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
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

Hello,

On Fri, Aug 12, 2022 at 4:50 PM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Fri, Aug 12, 2022 at 4:50 AM <menglong8.dong@gmail.com> wrote:
> >
> >  #define __noreturn                      __attribute__((__noreturn__))
> >
> > +#define __nofnsplit                     __attribute__((__optimize__("O1")))
>
> This is still in the wrong place...
>
> Also, from what the bot says, Clang does not support it. I took a
> look, and that seems to be the case. ICC doesn't, either. Thus you
> would need to guard it and also add the docs as needed, like the other
> attributes.
>
> (Not saying that solving the issue with the attribute is a good idea,
> but if you really wanted to add one, it should be done properly)
>

I have dug it deeper, and found that this function-split optimization
is only used by GCC. Therefore, I think I need only to consider it
for GCC.

I'll send a V3, thanks~

Menglong Dong

> Cheers,
> Miguel
