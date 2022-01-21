Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579DA495DE2
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 11:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350082AbiAUKma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 05:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234910AbiAUKm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 05:42:29 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35665C061574;
        Fri, 21 Jan 2022 02:42:29 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id r10so10244693edt.1;
        Fri, 21 Jan 2022 02:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zZhYAYN3n5WcZz7HwZEIgORGsu/PwseBwSd+OLunQyw=;
        b=AZkri8tJKbxLBr2pMTKNZbbeX2q6oRSbHn/oCnZUnw3il4iNUAPXd0tpjydiyoPepj
         H9eIHMz7F6+1mtpWkLyntJiRcO54bNPWuWpTKhYkZCXp/hfFqIWZRBE4h0xW4SZudxkY
         4fiH2jHbp/EzHlyier9rBbAbln+YDkR/Oezl6q51r4tg94s2rQXDXKC+xKCjCtK2AlZr
         f8yvobllJ45pMVuRZ+OQ5RH8oK3ybkp1YreB1iuwNd6XedJn4Ukz7i+9XBMylQmN1Cny
         a+7w/TYLTpwseTj8dIrhCXu1Ia6IlI6tqLlvMGWmT9dmN7pQu7EuOl40c9J0obSpz3XP
         2J8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zZhYAYN3n5WcZz7HwZEIgORGsu/PwseBwSd+OLunQyw=;
        b=nizbspt0RSi4erlhnkbynOnhFCA26E/Wq48la5xSo4t9khCgGpIVeJu52EVWR/jxAB
         1W9jaUpqXCK6htgXruGJSPgJl/xfTHkyNQlGeidRKW/wJ/SdnbMBwQQcJj43bxf0n5xQ
         cxmav6W/9d4oCRXEfUuRqcPCCTNO/755pNh9TYAf0axTD7xu/12zPzWv8hM0zNsNDKNM
         9w+RFgGLr8Su9RkIso3Lny49qrmWDptzXjEbaHG3zFfGzSjH3UBUg++YTCy7SEtnULJL
         skwwMjOcxjDsF9qxhe6ly6IXVXNgx/Z+rrs/Z1o579Eao0o9hgeKr51PUAGWB9ll99ic
         8moA==
X-Gm-Message-State: AOAM532NPpJOHN9DRFNwCBdfHCaDAoy1HGAkRz3OINe4BrHFBrh+E0fN
        Pxum8Ft4QC4wvtsrOQ4DTXtRFnZ0BysHnkPj+oc=
X-Google-Smtp-Source: ABdhPJw7d/LF3frtLFtj3ko/qDw6dxnIG0GOLJlFyQl8D2J/p8srr1uyy4U1jX75suhpUUJ2hmEkbiuh9An3U1GrCBY=
X-Received: by 2002:a17:907:948d:: with SMTP id dm13mr2790824ejc.497.1642761747389;
 Fri, 21 Jan 2022 02:42:27 -0800 (PST)
MIME-Version: 1.0
References: <20220121041428.6437-1-josright123@gmail.com> <20220121041428.6437-3-josright123@gmail.com>
 <CAHp75Vc9pJMNfW2roUbdrcxCSvyGboTsJC0oTDCcTAS5bmF08w@mail.gmail.com>
In-Reply-To: <CAHp75Vc9pJMNfW2roUbdrcxCSvyGboTsJC0oTDCcTAS5bmF08w@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 21 Jan 2022 12:41:50 +0200
Message-ID: <CAHp75VcV4F_qLJXW_dZ3t2MGLt0ddKX6m6NzapLtVwvNXaH19A@mail.gmail.com>
Subject: Re: [PATCH v12, 2/2] net: Add dm9051 driver
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 12:37 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Fri, Jan 21, 2022 at 6:15 AM Joseph CHAMG <josright123@gmail.com> wrote:

...

> > correctly use regmap bulk read/write/update_bits APIs
> > use mdiobus to work to phylib and to this driver
> > fine tune to arrange the source code to better usage
>
> This is not tagged properly. Also, I specifically removed everything
> else to point out, please, read finally the article [1] and write a
> proper commit message. And move changelog under the cutter '--- '
> line. Without doing these two things nobody can do anything with your
> contribution.

Next comment, remove all those `unlickely()` calls. Otherwise you have
to justify their appearance.

> [1]: https://cbea.ms/git-commit/


-- 
With Best Regards,
Andy Shevchenko
