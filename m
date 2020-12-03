Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E282B2CDA2A
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 16:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbgLCPev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 10:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbgLCPet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 10:34:49 -0500
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D88BC061A52
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 07:34:09 -0800 (PST)
Received: by mail-vk1-xa44.google.com with SMTP id r9so482023vkf.10
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 07:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h6bUmmhNs5Vo0iuri/gifDqZRZWxy1kGAo1J9lB1K5k=;
        b=D0ie8/h3FBLr6GsJocONE1JbQgocKTLMtMzcvLZ4m0y7cnANQLWYb2PicTVkU3CHWU
         0xhY3CUtX4DW0z+8e0aqlOnA0qQynUINmANChrlAvRpPTKilDW7S8pl1Ya7o5kR9BFVg
         gJdorF74HsyAZkpPn12nGzaqdkO24ic6ate64=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h6bUmmhNs5Vo0iuri/gifDqZRZWxy1kGAo1J9lB1K5k=;
        b=W57UOWndRkQZwdaxW0ExxbU8ZOEnuxeEG033Oxsb5ln+NKfPgmVfUP0Lv26t0WCkBM
         6195AmYqYE0+fNZTjV1pEiN4wm2rYKzjD7knc6NccRgufmgZtKQouI0CEKetu1/DF8rg
         przPPu/0my3obbUclO9AQGzvjMKsI0QOM1VHar15IPiFSvtqvnuCj9Y2TgSMpauhfzv5
         Elyak0fxB/Y/ux0VZLAfkSvu5dVA5T+KzEOibalAOrdsZwYq+dTQ2wt5pwnYUa23dsU+
         4MQc8jUwWjGXEUt1/hiQmMnRGPGEh6p22ZER7gjaXPfty5Jp/X80Z9JD86UVX4l5RnsP
         dmOw==
X-Gm-Message-State: AOAM533SAKRfAgj0xNz1Lu0LtvjTncGYY0aSGVkJ3WRD27J68x36uFEI
        49cXPfegkrMrEeX6Jjt/GEYjv86iJoqfJw==
X-Google-Smtp-Source: ABdhPJzD6Igpj8s4xmL6kVWJrw5o2jmPzWnRmem8bL3dtG5tHNaXp1JdzmVlNBgufMa9uqSmV0r/bA==
X-Received: by 2002:a1f:2c01:: with SMTP id s1mr2404337vks.11.1607009647619;
        Thu, 03 Dec 2020 07:34:07 -0800 (PST)
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com. [209.85.217.53])
        by smtp.gmail.com with ESMTPSA id u1sm127676uap.6.2020.12.03.07.34.05
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 07:34:05 -0800 (PST)
Received: by mail-vs1-f53.google.com with SMTP id u7so1436571vsq.11
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 07:34:05 -0800 (PST)
X-Received: by 2002:a67:8c41:: with SMTP id o62mr2741810vsd.49.1607009645158;
 Thu, 03 Dec 2020 07:34:05 -0800 (PST)
MIME-Version: 1.0
References: <20201112200906.991086-1-kuabhs@chromium.org> <20201112200856.v2.1.Ia526132a366886e3b5cf72433d0d58bb7bb1be0f@changeid>
 <CAD=FV=XKCLgL6Bt+3KfqKByyP5fpwXOh6TNHXAoXkaQJRzjKjQ@mail.gmail.com>
 <002401d6c242$d78f2140$86ad63c0$@codeaurora.org> <CAD=FV=UnecON-M9eZVQePuNpdygN_E9OtLN495Xe1GL_PA94DQ@mail.gmail.com>
 <002d01d6c2dd$4386d880$ca948980$@codeaurora.org> <CAD=FV=WQPMnor3oTefDHd6JP6UmpyBo7UsOJ1Sg4Ly1otxr6hw@mail.gmail.com>
 <004301d6c968$12ef1b10$38cd5130$@codeaurora.org>
In-Reply-To: <004301d6c968$12ef1b10$38cd5130$@codeaurora.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 3 Dec 2020 07:33:52 -0800
X-Gmail-Original-Message-ID: <CAD=FV=VCbjRUxUsmyk=64FLDGU=W41EXh5tdfQr1Lg83T8jiEA@mail.gmail.com>
Message-ID: <CAD=FV=VCbjRUxUsmyk=64FLDGU=W41EXh5tdfQr1Lg83T8jiEA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] ath10k: add option for chip-id based BDF selection
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     Abhishek Kumar <kuabhs@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Dec 3, 2020 at 3:33 AM Rakesh Pillai <pillair@codeaurora.org> wrote:
>
> > What I'm trying to say is this.  Imagine that:
> >
> > a) the device tree has the "variant" property.
> >
> > b) the BRD file has two entries, one for "board-id" (1) and one for
> > "board-id + chip-id" (2).  It doesn't have one for "board-id + chip-id
> > + variant" (3).
> >
> > With your suggestion we'll see the "variant" property in the device
> > tree.  That means we'll search for (1) and (3).  (3) isn't there, so
> > we'll pick (1).  ...but we really should have picked (2), right?
>
> Do we expect board-2.bin to not be populated with the bdf with variant field (if its necessary ?)

The whole fact that there is a fallback to begin with implies that
there can be a mismatch between the board-2.bin and the device tree
file.  Once we accept that there can be a mismatch, it seems good to
try all 3 fallbacks in order.


> Seems fine for me, if we have 2 fallback names if that is needed.

OK, sounds good.  So hopefully Abhishek can post a v3 based on what's
in <https://crrev.com/c/2556437> and you can confirm you're good with
it there?

-Doug
