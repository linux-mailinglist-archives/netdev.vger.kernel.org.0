Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8B0249AE3
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 12:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgHSKsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 06:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728013AbgHSKs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 06:48:29 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910FCC061757;
        Wed, 19 Aug 2020 03:48:28 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id h22so18666179otq.11;
        Wed, 19 Aug 2020 03:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JFCS1wWCaky01GdCrS5KhBNLCXiKvx8eu/9Q1CWY57o=;
        b=SAlnLFGsaJJ2xUQvXdp6/REunLAQzaLpmNpCPkhdMyKVNOL4zXoJc+uTpvFb1PLXQe
         nN8aQpwx9KlR0QpjA0U0Eq9qCAcvJ1BkG1Pmvfae+wF16AUCkU8W0GDQheD/o4B1VrUX
         PelVL5WwDQloIppGpod8O4LcRauK/SLT0vBKv+BhPM4L1DU+6rZBrJ0Dt0oV8Ce4u200
         wfYajuI8k/buRZ/KOQgJS9xFj6qU+vsS6Mi/Pic5cr7hyqCbNaPaM64dCQ32B92C7zpm
         twdkgIcY8FJxVqqD5N4bDX/Yu8aavznJiTYE5JD98MkyaozlEe8FkOVjNVcv9NBfu1pV
         5Fgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JFCS1wWCaky01GdCrS5KhBNLCXiKvx8eu/9Q1CWY57o=;
        b=uV1mk1B8VaF8tL03zX+JPDnTfyoDnCNxK3gH+iz+/rwHDaDH4hm566X1iC7oIitBQH
         76P+QolpXTnIPEpqoQakVKdpGCMLf9musvyF1ESa7fTgxLvxsLlpc9mPgIglJ6Kdla24
         N8C0ll+EATzolfkBKVJR3Th4rTUbCZNC/XglL/+byfkSD3y7hRaxWENgiDBdmfdfIh7U
         Y8u1VPbZ6UuIL0gQsEiUx/i0BCYo7UPKLblql0q/72bOZsBHTbT7d2E3QZ0r9u5OlQ0m
         V+td2rohBLQWIW0bo8naZ0z3+W9oIiIEvVpYQg8JLKwoORrOSoCIb7L0Ar3cWHzKVTZN
         wXTA==
X-Gm-Message-State: AOAM532ZQXvxDI/UlAajImfHfGl6AguDlbcNSDwj79tVy7i26jUl5ncm
        IzmhgbQKiBsqdofNGeV5Bj3KUQ6wrj+EC22/IMQ=
X-Google-Smtp-Source: ABdhPJwYTK+IRxToH0hqhLtJ7NIIqDs8lKmtEJkzNzElCKB5MQaF3rOwIOaAYWCB8rMlfnOVuvrNcqGFlbqr+yW4gKM=
X-Received: by 2002:a9d:128c:: with SMTP id g12mr17527086otg.242.1597834108000;
 Wed, 19 Aug 2020 03:48:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200817091617.28119-1-allen.cryptic@gmail.com>
 <20200817091617.28119-2-allen.cryptic@gmail.com> <b5508ca4-0641-7265-2939-5f03cbfab2e2@kernel.dk>
 <202008171228.29E6B3BB@keescook> <161b75f1-4e88-dcdf-42e8-b22504d7525c@kernel.dk>
 <202008171246.80287CDCA@keescook> <df645c06-c30b-eafa-4d23-826b84f2ff48@kernel.dk>
 <1597780833.3978.3.camel@HansenPartnership.com> <202008181309.FD3940A2D5@keescook>
In-Reply-To: <202008181309.FD3940A2D5@keescook>
From:   Allen <allen.lkml@gmail.com>
Date:   Wed, 19 Aug 2020 16:18:16 +0530
Message-ID: <CAOMdWSLi-aUeKDN8Xn-X2uW_LmWsp2n=NL3dPGiUbQKm_MxcAg@mail.gmail.com>
Subject: Re: [PATCH] block: convert tasklets to use new tasklet_setup() API
To:     Kees Cook <keescook@chromium.org>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        Allen Pais <allen.cryptic@gmail.com>, jdike@addtoit.com,
        richard@nod.at, anton.ivanov@cambridgegreys.com, 3chas3@gmail.com,
        stefanr@s5r6.in-berlin.de, airlied@linux.ie, daniel@ffwll.ch,
        sre@kernel.org, kys@microsoft.com, deller@gmx.de,
        dmitry.torokhov@gmail.com, jassisinghbrar@gmail.com,
        shawnguo@kernel.org, s.hauer@pengutronix.de,
        maximlevitsky@gmail.com, oakad@yahoo.com,
        Ulf Hansson <ulf.hansson@linaro.org>,
        mporter@kernel.crashing.org, alex.bou9@gmail.com,
        broonie@kernel.org, martyn@welchs.me.uk, manohar.vanga@gmail.com,
        mitch@sfgoth.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-um@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        linux1394-devel@lists.sourceforge.net,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-hyperv@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-s390@vger.kernel.org,
        linux-spi@vger.kernel.org, devel@driverdev.osuosl.org,
        Romain Perier <romain.perier@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > > > > >
> > > > > > > > In preparation for unconditionally passing the
> > > > > > > > struct tasklet_struct pointer to all tasklet
> > > > > > > > callbacks, switch to using the new tasklet_setup()
> > > > > > > > and from_tasklet() to pass the tasklet pointer explicitly.
> > > > > > >
> > > > > > > Who came up with the idea to add a macro 'from_tasklet' that
> > > > > > > is just container_of? container_of in the code would be
> > > > > > > _much_ more readable, and not leave anyone guessing wtf
> > > > > > > from_tasklet is doing.
> > > > > > >
> > > > > > > I'd fix that up now before everything else goes in...
> > > > > >
> > > > > > As I mentioned in the other thread, I think this makes things
> > > > > > much more readable. It's the same thing that the timer_struct
> > > > > > conversion did (added a container_of wrapper) to avoid the
> > > > > > ever-repeating use of typeof(), long lines, etc.
> > > > >
> > > > > But then it should use a generic name, instead of each sub-system
> > > > > using some random name that makes people look up exactly what it
> > > > > does. I'm not huge fan of the container_of() redundancy, but
> > > > > adding private variants of this doesn't seem like the best way
> > > > > forward. Let's have a generic helper that does this, and use it
> > > > > everywhere.
> > > >
> > > > I'm open to suggestions, but as things stand, these kinds of
> > > > treewide
> > >
> > > On naming? Implementation is just as it stands, from_tasklet() is
> > > totally generic which is why I objected to it. from_member()? Not
> > > great with naming... But I can see this going further and then we'll
> > > suddenly have tons of these. It's not good for readability.
> >
> > Since both threads seem to have petered out, let me suggest in
> > kernel.h:
> >
> > #define cast_out(ptr, container, member) \
> >       container_of(ptr, typeof(*container), member)
> >
> > It does what you want, the argument order is the same as container_of
> > with the only difference being you name the containing structure
> > instead of having to specify its type.
>
> I like this! Shall I send this to Linus to see if this can land in -rc2
> for use going forward?
>

Cool, I shall wait for it to be accepted and then spin out V2 with cast_out()

-- 
       - Allen
