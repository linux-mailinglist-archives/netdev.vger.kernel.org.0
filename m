Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B012A1014
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 22:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgJ3VUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 17:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbgJ3VUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 17:20:49 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BCFC0613CF;
        Fri, 30 Oct 2020 14:20:48 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id a71so2731416edf.9;
        Fri, 30 Oct 2020 14:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZKTu+SyOym00jlZmBEEbyAXxFoTFInAe8yTP8rWjHtk=;
        b=qwneroqlmVG8apuxqKIq+QFIdLS1j1wzEsu/in6YQ11niQ1HNGYk/EWPkTrce2aL6u
         S7O540UNT36IIfhg5aSfbyf1gIuRCxIyxTO99d/ZUCT9Y414TYRHzTeNgZ1D8tTlJbSm
         4PbDvZfY1GhIQaH8yp5IwHJey7nKQAS+oDA9ps/INCSSjutTC65Z/6/F198cGAUEXoky
         hwRH5mYevuCCsbQnI8JQCnkHvZ2hDAh+JdYmgmqbbofP5vpNbTp3LYex1i191aGw5nNC
         cPSXM20HyyIxpARZ2HKFj2tXn1qBl+Gtq8pnnCgWGblfFZiuYrYElNhUBCFgi4tEB7C2
         ZVZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZKTu+SyOym00jlZmBEEbyAXxFoTFInAe8yTP8rWjHtk=;
        b=RNoWs04aQHSu+FdxFKv1VVZ0m+u+psoQV2+ZmacaE9/DRaZ8i5YcZQl0xpqODRjB2+
         x/P0R54sbfo98pHgAHiLj2LXJtHmqz32Dxx+iZwL10NhdDI63QHqVdga4TsA58oHfsbE
         DgZKEOTIrbQaWSjvbHCXwTPMITC8KluH7X9CT2z3Vh+9QqUozPHSnV0h2mJaaBnHR2sS
         Mbv6dvgVsJXlwAN50AKnOKsSjbdFSJZw8aZk8TZa+KduHKwJhrAK4EuK7/jpWIxM4zeg
         KTzYO8/LUoUFOyDqqCwiPgr9SbSeQ1sx5wJMuCAgcW5EnTCu2ixtFG4F3+gVb38aWJjR
         mzDA==
X-Gm-Message-State: AOAM533btfB74wQ+hJZsiq+39+4Icr+7AzaDMCZfe33CfmD5RNg7lUNA
        gSlW2rUt2dVOrrbbDXcjakijYIp/Llq6D/8zeVg=
X-Google-Smtp-Source: ABdhPJyEZOI8WvfrGv12dvPPgMU6LbgDHWeelJI9PsIWWwPCqTj+ms9mJv6AYBX4hkPHi2jyUXv2VCVfBOAhRxJCQW4=
X-Received: by 2002:a50:8adb:: with SMTP id k27mr4471824edk.254.1604092846788;
 Fri, 30 Oct 2020 14:20:46 -0700 (PDT)
MIME-Version: 1.0
References: <20201030022839.438135-1-xie.he.0141@gmail.com>
 <20201030022839.438135-4-xie.he.0141@gmail.com> <CA+FuTSe4yGowGs2ST5bDYZpZ-seFCziOmA8dsMMwAukJMcRuQw@mail.gmail.com>
 <CAJht_EOCba57aFarDYWU=Mhzn+k1ABn8HwgYt=Oq+kXijQPGvA@mail.gmail.com>
In-Reply-To: <CAJht_EOCba57aFarDYWU=Mhzn+k1ABn8HwgYt=Oq+kXijQPGvA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 30 Oct 2020 17:20:04 -0400
Message-ID: <CAF=yD-+fQMZxSWT-_XLvdO9bQA_8xTMry49WA-ZsrcOQcz6H2A@mail.gmail.com>
Subject: Re: [PATCH net-next v4 3/5] net: hdlc_fr: Improve the initial checks
 when we receive an skb
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 3:21 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Fri, Oct 30, 2020 at 9:31 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > > Add an fh->ea2 check to the initial checks in fr_rx. fh->ea2 == 1 means
> > > the second address byte is the final address byte. We only support the
> > > case where the address length is 2 bytes.
> >
> > Can you elaborate a bit for readers not intimately familiar with the codebase?
> >
> > Is there something in the following code that has this implicit
> > assumption on 2-byte address lengths?
>
> Yes, the address length must be 2 bytes, otherwise the 3rd and 4th
> bytes would not be the control and protocol fields as we assumed in
> the code.
>
> The frame format is specified in RFC 2427
> (https://tools.ietf.org/html/rfc2427). We can see the overall frame
> format on Page 3. If the address length is longer than 2 bytes, all
> the following fields will be shifted behind.

Thanks for that context. If it's not captured in the code, it would be
great to include in the commit message.

From a quick scan, RFC 2427 does not appear to actually define the
Q.922 address. For that I ended up reading ITU-T doc "Q.922 : ISDN
data link layer specification for frame mode bearer services", section
3.2.
