Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0A52A0606
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 13:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgJ3M5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 08:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgJ3M5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 08:57:41 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F02C0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 05:57:40 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id g21so3365650vsp.0
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 05:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JUx9uIiu2tCRTnXPuJZyo4v9bmIqQhVMjRZOhSyqRjs=;
        b=BVxFL7LGvAjl3ryWkDoTDiakcJjQHQ0NeB5JbQTmOwsLDsxoYqzgxkSlQM/+AojY6v
         7zMnLtB5D3jBCEm4KQenHGKd8o1xeZVKZDRXVViUHv65qqvEa5QEeL0Bxzhf1eeCbV4J
         rZfurLE05Vxmsp4MQuCV+ANGl4yvgfS7wakba+0yzgQGE9WnJas3vue7JRezRHoDHqXM
         LCOuK7CZ0+Tthrj6tSlBmqKzxhcbH49qtNb9OwJFcSVVabCE5AvKzN6FPXVloNGwQRWc
         taLncWHwpWOP7OdMDItdA20lQs40FdeArCyohjSmemRMFt/3E/9gb4m3Tbe66xr/nY9k
         WuZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JUx9uIiu2tCRTnXPuJZyo4v9bmIqQhVMjRZOhSyqRjs=;
        b=Um7zRzEx9Lz/qo1H4snwfHD5wkJTzeiSIf3Xu5dwExrfdpOboZVUyBddKtHQ9SM5xk
         ULEKG163BAqMrPl/ANHt+9B/TwBwK8aUVrIddQG/FmCPVZLzLcjnK5A9VMHz9mKXTVVq
         Xh/7kTbZ3pc838XIlnGxdCLs4jKtb1U6q7mrCs1Nx6UgJkFg76cJOibHCtiJwHhngNcy
         1BnxmVz+kqnJh2jSO3eOccSeA4+CsSBIBAeM1K4m9P+hDcwm5ifZ1SDzjURvOaiw8Sii
         cmgGXu2II54dqTaSUdrRBEU+iOsdiTrKgDO53XvGs09P5MBP3ZBebG+lQ1KlLyQ+yuA1
         rRJA==
X-Gm-Message-State: AOAM531XLe3FTVXtUuDnFLONIEDy9ZyE7W4IZmZOb5mMPOouYdcxvMLc
        aWZXZLxrMTp70F0reay7H2p35ojLGUs=
X-Google-Smtp-Source: ABdhPJzxzzMPsvHv3fXbXqM96BqKbuw/1sU61sO95KsNfkNmP2a3K0ZwVcHoLLvAt1CWtwsrlVTaww==
X-Received: by 2002:a67:f954:: with SMTP id u20mr7036345vsq.5.1604062658945;
        Fri, 30 Oct 2020 05:57:38 -0700 (PDT)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com. [209.85.217.51])
        by smtp.gmail.com with ESMTPSA id u185sm700164vke.14.2020.10.30.05.57.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 05:57:38 -0700 (PDT)
Received: by mail-vs1-f51.google.com with SMTP id g21so3365584vsp.0
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 05:57:37 -0700 (PDT)
X-Received: by 2002:a67:c981:: with SMTP id y1mr6515751vsk.14.1604062657302;
 Fri, 30 Oct 2020 05:57:37 -0700 (PDT)
MIME-Version: 1.0
References: <72671f94d25e91903f68fa8f00678eb678855b35.1603907878.git.gnault@redhat.com>
 <20201028183416.GA26626@pc-2.home> <CA+FuTSfs1ZsEuu4vKojEU_Bo=DibWDbPPXrw3f=2L6+UAr6UZw@mail.gmail.com>
 <20201030093903.GA5719@pc-2.home>
In-Reply-To: <20201030093903.GA5719@pc-2.home>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 30 Oct 2020 08:57:00 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe2GYxxX2hckeYwiDjBfCdF-ZXXqizRF=ATboLZAAdaJQ@mail.gmail.com>
Message-ID: <CA+FuTSe2GYxxX2hckeYwiDjBfCdF-ZXXqizRF=ATboLZAAdaJQ@mail.gmail.com>
Subject: Re: [PATCH net] selftests: add test script for bareudp tunnels
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Martin Varghese <martin.varghese@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 5:39 AM Guillaume Nault <gnault@redhat.com> wrote:
>
> On Thu, Oct 29, 2020 at 02:11:38PM -0400, Willem de Bruijn wrote:
> > On Wed, Oct 28, 2020 at 10:27 PM Guillaume Nault <gnault@redhat.com> wrote:
> > >
> > > On Wed, Oct 28, 2020 at 07:05:19PM +0100, Guillaume Nault wrote:
> > > > Test different encapsulation modes of the bareudp module:
> > >
> > > BTW, I was assuming that kselftests were like documentation updates,
> > > and therefore always suitable for the net tree. If not, the patch
> > > applies cleanly to net-next (and I can also repost of course).
> >
> > I think that's where it belongs.
>
> Hum, do you mean to net or to net-next?

Sorry, that wasn't very clear. I meant net-next
