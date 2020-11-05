Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5662A8A0F
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 23:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732329AbgKEWrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 17:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKEWrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 17:47:16 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F371C0613CF;
        Thu,  5 Nov 2020 14:47:15 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id u2so1483086pls.10;
        Thu, 05 Nov 2020 14:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NiwtAJxk3DiCJ+r4eVQGFjV0z1XntuCtQoo0S11y+7A=;
        b=MMGpnr3PrDRqR5Ke0YO8vYcdGQ+FkiVx3KR7DkpSgGM3+QVniVa8szs5Qx/Mc7YvOA
         Vwh8bpM4SH8Z57535YhR8nfWNNNFKVxHAvzNKZkMRYZrWjSR8wQaSB1mnXbBq8IbB3Zn
         hpAQJIeFouOiSJhaYA0JqS6qsJ78xneUemI+QZy7LEOXPBSLLXSVQ7JC/t8xVZFytNVU
         YqbxiwZDf6yvhG08lSuN/QlNsVJ9FkElX1ChzZ3/fLJQTbt5IXNEGphpIVvjQbjvWjsp
         4DN0yY3Wnlqr4T05ROW9UwhtSWlRT754FNJbIsLD0BwdKWMYfRNJOYCdZi5D82VwZKXh
         Ivqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NiwtAJxk3DiCJ+r4eVQGFjV0z1XntuCtQoo0S11y+7A=;
        b=RHtc4sjT4k/w0qYfvdn58uRQvns+9gZAjan0RosHyiLaWKBKPEyQINasxhG7vtMVnr
         ik281kERpJ5z+AdqWlsku+kariQ2iacXzVUCc6hbcLmAMV1XA1HjI+JRutmnv7pMBNoi
         02sXyEB2lIWMwXPt8mLEw6TjlRjKzBFQP/v3f1qDQw4VB9FcKfzfKmIFREHUuWQkPjI3
         DTSQ72mMcV63sWTe7A0mDMu+qNEGLiqRT2u/V9O4RzEtFKi+WpGO5d2rxqhrBFgiLusp
         vGtBYZKK7nV8m6GA0vA6LoQTs+U9Jh3TkvrjRHqA6pZqnvx7n+/pVsh6tV7M735dWEbZ
         nZMA==
X-Gm-Message-State: AOAM531HlokqLXglfmCawM2WkglYlts9RzcNlymijsXobbzTjMNMKjmz
        SLe3aWgKM43/2T8p9/NEH0BQm0+eyYdpnDRl369C9bc6Ed4=
X-Google-Smtp-Source: ABdhPJzzX2fpSgqZ/nz1pwpxUWWTCeJ2U245UUdRooO1TtbCzRlyakgbCRMHyABoyASjxNZyNvVuhxFdAtG6MoneWdA=
X-Received: by 2002:a17:902:c410:b029:d6:ad08:baa0 with SMTP id
 k16-20020a170902c410b02900d6ad08baa0mr4267552plk.78.1604616434882; Thu, 05
 Nov 2020 14:47:14 -0800 (PST)
MIME-Version: 1.0
References: <20201105073434.429307-1-xie.he.0141@gmail.com>
 <CAK8P3a2bk9ZpoEvmhDpSv8ByyO-LevmF-W4Or_6RPRtV6gTQ1w@mail.gmail.com>
 <CAJht_EPP_otbU226Ub5mC_OZPXO4h0O2-URkpsrMBFovcdDHWQ@mail.gmail.com> <CAK8P3a2jd3w=k9HC-kFWZYuzAf2D4npkWdrUn6UBj6JzrrVkpQ@mail.gmail.com>
In-Reply-To: <CAK8P3a2jd3w=k9HC-kFWZYuzAf2D4npkWdrUn6UBj6JzrrVkpQ@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 5 Nov 2020 14:47:04 -0800
Message-ID: <CAJht_EPAqy_+Cfh1TXoNeC_j7JDgPWrG-=mMMmQ3ot2gNZuB8A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: x25_asy: Delete the x25_asy driver
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Martin Schiller <ms@dev.tdt.de>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        Linux X25 <linux-x25@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 12:40 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> > I think this driver never worked. Looking at the original code in
> > Linux 2.1.31, it already has the problems I fixed in commit
> > 8fdcabeac398.
> >
> > I guess when people (or bots) say they "tested", they have not
> > necessarily used this driver to actually try transporting data. They
> > may just have tested open/close, etc. to confirm that the particular
> > problem/issue they saw had been fixed.
>
> It didn't sound like that from the commit message, but it could be.
> For reference:
> https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/commit?id=aa2b4427c355acaf86d2c7e6faea3472005e3cff

I see. The author of this commit said "I tested by bringing up an x.25
async line using a modified version of slattach." Maybe he only
switched TTY ports from the N_TTY line discipline to the N_X25 line
discipline. To actually test transporting data, we need to either use
AF_PACKET sockets, or use AF_X25 sockets with the X.25 routing table
properly set up. The author of this commit didn't clearly indicate
that he did these.
