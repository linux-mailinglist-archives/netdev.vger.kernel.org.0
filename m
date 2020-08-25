Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57BFC251892
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 14:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgHYMbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 08:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgHYMba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 08:31:30 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F6DC061755
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 05:31:30 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id 2so1366872wrj.10
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 05:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fooishbar-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+HLPhy+qXHIinU4+E7TS6jEdPNtNrgqFPzcA0O6t5kU=;
        b=wEO9WqPQBcLwZUKcvqXvWeTQyatZBnoj8MNgvqBl3wXtPJizAT/oQ/SdGZfZ4EMq/E
         eyFKyYTJISm+DV330UA3npw7Dk0YMydTsCuYN9jpA+MHjIs/adfjauEBoaNXRZ0HI9Le
         JDdxy0U/s9OnS3u2btlKuWA8skzmnHXl+FdDvALKESloVFY3kHERMGM8vAtLPvLngs7q
         pN4QuFCkbyvSu3wmqoe19Atprq/sp9hCBmKWOpw9qfETRsv0KPDoH2X3ZJsbn1hKBRKu
         pSMBFzyQPBylG6jIRY2gLJ9lFIrCS6nd9xiUy1RuilZMNT57weEJFi5aBrdPQmLzGZTH
         70ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+HLPhy+qXHIinU4+E7TS6jEdPNtNrgqFPzcA0O6t5kU=;
        b=btq0b091o9+s9UFVMq/SN2IYoPM4FFLP1ziCHy78hK+eBROhqKpgNcHKax3YBKPgKe
         Ad5dIflq0nPfHmFSDvqeYMeaNMowPw8ThOVB2Gmvirtx7njLafpvS0jtJcxvfagSVa0s
         8V/Wp+I1Oq01CjDk3MpKhh6dfnuyLAftW6P+BNs7xHhpyQNcKWR5MgRVG5hbxrStzYyF
         MG5LwgGrKgziLWoEYRnlQdeNfvlNcBIb3qazHTnVQm9DqDKxONLhQM06A+4SbSPMAN4I
         yLUhoq6t7s/fFR5xhJNSw0jtumOG4tQ9tbHmY8IYdVpnaK6BfW4wyO5BgyL0CqGhZxCu
         IruA==
X-Gm-Message-State: AOAM531L9gXpBr4FbUBOx8HyWUu8YT4tWckipOB9OeWVB37qs4F5RcCt
        kY1yVc1lV4sgKNsGhtlqtuMaK9luTA2aN13kjybGIw==
X-Google-Smtp-Source: ABdhPJz1mB4Fdo1aDIpEuz/ea4FV6oUPMILZjNgY202nHhhVQ2y6zu7/a0D9cIzuEsl4KQKXulFb7/NPn2fB9IdTTE0=
X-Received: by 2002:a5d:644b:: with SMTP id d11mr10206039wrw.373.1598358688698;
 Tue, 25 Aug 2020 05:31:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
 <20200819152120.GA106437@ravnborg.org> <20200819153045.GA18469@pendragon.ideasonboard.com>
 <CALAqxLUXnPRec3UYbMKge8yNKBagLOatOeRCagF=JEyPEfWeKA@mail.gmail.com>
 <20200820090326.3f400a15@coco.lan> <20200820100205.GA5962@pendragon.ideasonboard.com>
 <CAPM=9twzsw7T=GD6Jc1EFenXq9ZhTgf_Nuo71uLfX2W33oa=6w@mail.gmail.com> <20200825133025.13f047f0@coco.lan>
In-Reply-To: <20200825133025.13f047f0@coco.lan>
From:   Daniel Stone <daniel@fooishbar.org>
Date:   Tue, 25 Aug 2020 13:31:16 +0100
Message-ID: <CAPj87rNkqp0hDEv63jhJsMzsQ0qMLucjWE4KVByCFoMRrnfUKA@mail.gmail.com>
Subject: Re: [PATCH 00/49] DRM driver for Hikey 970
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Dave Airlie <airlied@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        David Airlie <airlied@linux.ie>,
        Wanchun Zheng <zhengwanchun@hisilicon.com>,
        linuxarm@huawei.com, dri-devel <dri-devel@lists.freedesktop.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Xiubin Zhang <zhangxiubin1@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>,
        Xinliang Liu <xinliang.liu@linaro.org>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bogdan Togorean <bogdan.togorean@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Laurentiu Palcu <laurentiu.palcu@nxp.com>,
        linux-media <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, Liwei Cai <cailiwei@hisilicon.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Chen Feng <puck.chen@hisilicon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>, Rob Herring <robh+dt@kernel.org>,
        mauro.chehab@huawei.com, Rob Clark <robdclark@chromium.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Liuyao An <anliuyao@huawei.com>,
        Network Development <netdev@vger.kernel.org>,
        Rongrong Zou <zourongrong@gmail.com>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mauro,

On Tue, 25 Aug 2020 at 12:30, Mauro Carvalho Chehab
<mchehab+huawei@kernel.org> wrote:
> Sorry, but I can't agree that review is more important than to be able
> to properly indicate copyrights in a valid way at the legal systems that
> it would apply ;-)

The way to properly indicate copyright coverage is to insert a
copyright statement in the file. This has been the accepted way of
communicating copyright notices since approximately the dawn of time.
The value of the 'author' field within a chain of git commits does not
have privileged legal value.

If what you were saying is true, it would be impossible for any
project to copy code from any other project, unless they did git
filter-branch and made sure to follow renames too. As others have
noted, it would also be impossible for any patches to be developed
collaboratively by different copyright holders, or for maintainers to
apply changes.

This is accepted community practice and has passed signoffs from a
million different lawyers and copyright holders. If you wish to break
with this and do something different, the onus is on you to provide
the community with _specific_ legal advice; if this is accepted, the
development model would have to drastically change in the presence of
single pieces of code developed by multiple distinct copyright
holders.

Cheers,
Daniel
