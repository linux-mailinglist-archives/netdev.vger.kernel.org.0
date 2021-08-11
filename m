Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF943E92A7
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhHKNaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 09:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbhHKNaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 09:30:11 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A62BC061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 06:29:48 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id n6so4568162ljp.9
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 06:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+X0yTtKHNC1QHiC4TdwRsI4TRqekknXSqUNI6kHT6+s=;
        b=rTvOhlGAR1MHxp0c1gldy8giEP85iSPRRdinf6tH+tLYQ86Fl8DyUM01b1LBZMwK8E
         mCjkgQmMoDyfeqmK3/ZPFrKfGLd8p+rU+1V/BMwYe9g+T1exM9WHea8yPcBvc4gkXduT
         AKakVfoO4XmhlGRzghQfpr8+dS2Z1WAQsafYgVPb3YIqwFCOyc18MVM2EPeeoocyk/xb
         nICuC1x6PMJGytElpyBqP3ITl9sO8QjDCaC3cH1Z/sJfchPwZyVqv9wx+h4PBGQdcumy
         ukoUvmWp2hWd5LV8XZaxCxzKML078/pO21e3vXJe82K7RWh8TNQp9GS93eUYy3PuGMUX
         Co8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+X0yTtKHNC1QHiC4TdwRsI4TRqekknXSqUNI6kHT6+s=;
        b=AyQ3SF4Ym9JD9m1r5hMoHt4/ix284dHJHaDgfMaURljxd2P4zjRHU0oW/gfZPkg0LC
         /bEwOPE+yGuRrz+vx4UjTlAJUGQIZliCm6lcw1D+zIc0h+Bbew00ZZDsGr05yeC7fyud
         sIymmiOyXRnvUIoxwT+3Jri+1LKjCy48rS5LmYSPmmrDZdqyy8njJ7iqgPtsNERG8egZ
         mgLfISmnVqeXn56xIdXhs1XY7gznhM1RxgNtcQg8EUb4JkQlxZl7P9W/MuAbIlVZpCMf
         BXwr83KlV6AjVJmKkH1MKjn6gWl/TLSs7j3EHiZBrkYbP/8jCaIJaJqy8sjJOV9jOkfE
         xxsQ==
X-Gm-Message-State: AOAM5337g1hTXhzwfWyGpX+jLGUkREPXwA/vbjlOc2eGQ2faa919SdLp
        zC6Fn4geSf57WFlMdkwTQfKBS/RjiDrNNVkOWRws+w==
X-Google-Smtp-Source: ABdhPJwoljr3xOO+hMnf7G8n6BLUxTzr+3BexgpppvcpXg5N9o1tS91z4t/AWOEriSw8g9JycXkWLnzsm8guLA7TPYk=
X-Received: by 2002:a05:651c:1318:: with SMTP id u24mr23397688lja.200.1628688586450;
 Wed, 11 Aug 2021 06:29:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210810131356.1655069-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210810131356.1655069-1-vladimir.oltean@nxp.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 11 Aug 2021 15:29:35 +0200
Message-ID: <CACRpkdZc4S0nLgz=BP8H_3XBZa9NfiUaW5aXiRxR+whnDsCCaA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 0/4] DSA tagger helpers
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 3:14 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> The goal of this series is to minimize the use of memmove and skb->data
> in the DSA tagging protocol drivers. Unfiltered access to this level of
> information is not very friendly to drive-by contributors, and sometimes
> is also not the easiest to review.
>
> For starters, I have converted the most common form of DSA tagging
> protocols: the DSA headers which are placed where the EtherType is.
>
> The helper functions introduced by this series are:
> - dsa_alloc_etype_header
> - dsa_strip_etype_header
> - dsa_etype_header_pos_rx
> - dsa_etype_header_pos_tx
>
> This series is just a resend as non-RFC of v1.

The series:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
