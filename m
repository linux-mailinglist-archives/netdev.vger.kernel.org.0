Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F392A101A
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 22:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbgJ3V0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 17:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgJ3V0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 17:26:33 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50276C0613CF;
        Fri, 30 Oct 2020 14:26:33 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id gr24so1654637ejb.9;
        Fri, 30 Oct 2020 14:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aeDij2hBtAcqIZYXSNzwSePE8yUhcbkeHfOgMWi0Q/w=;
        b=WmVqm44dXr9sye9JTIF29QYUWnE7gb6DGtM0eVPHaLJB12zdUOTD6XItJHx6wqeQjr
         sTTdcfe1rkWTmhaN2u1N6D6KIwtqM3oh61WOr95DtW+HTaPSssoU8PFqDBWNDBGuy13w
         p4bXQuz38YKh8y0I2WpsnXmXCMBv2RxfzIsyazLaAnF2iqEAM0fJ2tNQcH01576Gzkdx
         61o4raeC/wFomz9sx/h1x4EZrGa33tYU67iqT7D5A5ZefhRY9HHjBkkauY1pXsvttInG
         kcx/6zEk1b98OmUahtnGAWXVdcx9uUJRg9bwj7NywoRaemtcNCfXv/6QueC1DymL1558
         K0og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aeDij2hBtAcqIZYXSNzwSePE8yUhcbkeHfOgMWi0Q/w=;
        b=GRY8rRP63gZDO5XKSoC1HIclYauuOqFBt8IZPfc8in4g55Kt6S3OLk7UFInrFlGZTK
         TtirKT/17qwciQcN/FEYbxFjEy2ZR2JVAdrjb6LuEwmcB20VO1MfXNQXljgcon196gO0
         0idSJZfz3I7aqkFGuniqELH5XF0ZrR9IiLUT8TeJsq968Lzcup/wkb4SH6CkQDP31M1o
         56jo6ByasIrYdzxjU+TNogongcpQDckKCmCPnuwIVKupnnOrtKlOAprD0jxYwL/9BSs+
         psnNxBZEQ5jbOIyKAWJjj0w9t20t4EsbVCrO/jt2i6LicFXi5iDgL85bQVxeVSMjUenj
         oKSQ==
X-Gm-Message-State: AOAM530kTQQCuYAwkgJLCnSJHNjttnkbk04rYhLmQgwkQZTdQ2/BdzgX
        oBNTAto89+OIqu++3z+VRwcINh/TDg99LYu6Mc8=
X-Google-Smtp-Source: ABdhPJwNEydi1kMZUjf1lFeYnZw2/j/tmQwMZYN47IdGfrXlNZnAyHP8bC+LqH6XuhkJPSqucxx2oCVC42PIildM6GQ=
X-Received: by 2002:a17:906:f151:: with SMTP id gw17mr4438191ejb.119.1604093191906;
 Fri, 30 Oct 2020 14:26:31 -0700 (PDT)
MIME-Version: 1.0
References: <20201030022839.438135-1-xie.he.0141@gmail.com>
 <20201030022839.438135-6-xie.he.0141@gmail.com> <CA+FuTSdS86GtG15y17G0nNaqHjHTeYzFn+0N5+nTjXM8u=hpJw@mail.gmail.com>
 <CAJht_EMgWwAdo5Z3ZMs50k5tYnFetLa=zKO6unoU2mdOuXkU5g@mail.gmail.com>
In-Reply-To: <CAJht_EMgWwAdo5Z3ZMs50k5tYnFetLa=zKO6unoU2mdOuXkU5g@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 30 Oct 2020 17:25:55 -0400
Message-ID: <CAF=yD-L4S590AN5q4WJF9ttmu4n5rx=7TnofoJp5JSj90bUrrA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 5/5] net: hdlc_fr: Add support for any Ethertype
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

On Fri, Oct 30, 2020 at 3:29 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Fri, Oct 30, 2020 at 9:33 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > Should this still check data[5] == FR_PAD?
>
> No, the 6th byte (data[5]) is not a padding field. It is the first
> byte of the SNAP header. The original code is misleading. That is part
> of the reasons why I want to fix it with this patch.

Oh, good point. In that case

Acked-by: Willem de Bruijn <willemb@google.com>

> The frame format is specified in RFC 2427
> (https://tools.ietf.org/html/rfc2427). We can see in Section 4.1 and
> 4.2 that the 6th byte is the first byte of the SNAP header.
