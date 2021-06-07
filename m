Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E165639D55C
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 08:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhFGGwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 02:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhFGGwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 02:52:02 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0FBC061766
        for <netdev@vger.kernel.org>; Sun,  6 Jun 2021 23:50:11 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id n12so17463250lft.10
        for <netdev@vger.kernel.org>; Sun, 06 Jun 2021 23:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UEtZdFOxi2WohaLJrH6hnLr6MFGZSRIDHi+R4JvrIcI=;
        b=W13HojxSWvO241Su+Gj2Zdl7yjy4mC/bUOJljN3tTGNc5NchSgpfwCUoKxSN0q7zL8
         wUvamevQLsxu5IoPY0kiozcMWxiAQqT6CmdLMIdR5GLbjIHNRd2J3MRK1r6i5IoODKoo
         n+l0tJKS8NMG2Xd8UlZHrfnG1FlIJBhPpZudimkO+YsmXcrHIDwJf3Je7t/UQPMQxDq5
         yyDs6zVMCX7D78sts/nVaifjODzU7AfTBfxy2tB8BzQGa+xdIJpda7QyNa25RLgpv6OD
         kC/qbxorMU+UvxpFZUsgwgFDFVgKW9lFWXirgKztBnGYxThuAcKk0jshW0lYc+LT0S8M
         UgHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UEtZdFOxi2WohaLJrH6hnLr6MFGZSRIDHi+R4JvrIcI=;
        b=aDVWRdD7LXJ5FZzaU2Yj3HS66qPHX8MlKkOOlWmG/gKk0WFmSNL/WGF3qz7b7v0tFK
         A824F53qpnzwrO3cwzfrjrBDEfh9Y4waFNmteSKuBhYbsRLae6ND1yuCRCbth2Qg/Tp3
         uPAp8NjTdzLxP245/vxwBhW7AxQ4VAfkVTwkCX8U5gc+lfwt/TvR7peezCEX+PebHm3r
         ymDJ8+4M+1GXPKg/5O8BcfSQDjXgqYm5tKU2fAxTVmw0N6kqSW1K8StaopoGequ1bpX0
         Z8Oro7pKestix6PdQ2JaDVeoUwiz2roM1WtTwnQujyYWzbf4DMbQfykL95eoIR2ccXPA
         ffXA==
X-Gm-Message-State: AOAM530V8qW/TJKyM8DJ2DuFGUSWiTiHXkwK8KwZnZeghkzvySRNUith
        RnoSmzih8cLok7HRJtTyUdUGX+TDkI067Mmmsgj6TA==
X-Google-Smtp-Source: ABdhPJxu0u67u8AL1sud+fd7Es11M7bae85Zz9n0rMoRUq2L4YQijpaghyC6ARdY0MlCXGAlBRt8yQjkHtHHBhhELFE=
X-Received: by 2002:a05:6512:3241:: with SMTP id c1mr11381576lfr.29.1623048609542;
 Sun, 06 Jun 2021 23:50:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210605123636.2485041-1-yangyingliang@huawei.com>
 <CACRpkdZi-W-vnCH05C4CkQdnYtUKuD4NWoBTh8hGXmok_=Dsfw@mail.gmail.com> <da671768-64b8-e658-20bb-c536df8c1aae@huawei.com>
In-Reply-To: <da671768-64b8-e658-20bb-c536df8c1aae@huawei.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 7 Jun 2021 08:49:58 +0200
Message-ID: <CACRpkdZ+sT=YMZbvYmArZB50CPObsKe3CiBW=KysVubPt1-+_A@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: gemini: Use devm_platform_get_and_ioremap_resource()
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 7, 2021 at 3:05 AM Yang Yingliang <yangyingliang@huawei.com> wrote:
> On 2021/6/5 23:17, Linus Walleij wrote:
> > On Sat, Jun 5, 2021 at 2:32 PM Yang Yingliang <yangyingliang@huawei.com> wrote:
> >
> >> Use devm_platform_get_and_ioremap_resource() to simplify
> >> code.
> >>
> >> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> > (...)
> >> -       dmares = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> -       gmacres = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> > Should you not also delete the local variables
> > dmares and gmacres? I doubt they are used
> > after this.
>
> They are used to print message before returning gemini_ethernet_port_probe()
> static int gemini_ethernet_port_probe(struct platform_device *pdev)

Yes and after this they will print something undefined since you never
assign them anything, so the dmares and gmacres prints need to be
removed too. (Which is fine.)

Yours,
Linus Walleij
