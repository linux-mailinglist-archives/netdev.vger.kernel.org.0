Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2D94557D2
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 10:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245080AbhKRJSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 04:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245083AbhKRJRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 04:17:43 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B82BC0613B9
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 01:14:43 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id b12so10147316wrh.4
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 01:14:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b3S7OYyXOTGNtQK8jOgzcqC9ulA1poW0yLLID9bs/bI=;
        b=SlzTIRTo8/y9dND+G9vPX/FQnLJzWrNSaJdAU12gdRFiLFNkLFAMxubXGG6Ssn3uFf
         1lGvb+NgrBAqETSbTwSfHBpI5/0TZuuOQDmEqdlRCT2gpeM4GnLMHeyQQRqF5J/9HsnR
         hhuWK/QCuZ3x55j4gcqrciNv9k5W09LFIdkE+QDPO2V0IC+bbNWViiO4JRzcs0UWs0iE
         y5yxTD5zO+DQkaK8OIhCsf2wtCkY3pHRmvCFwSJlT1YDahCmW1ehobDX+q1/m6tvS6eY
         UkZ57Qkr+j6AYqB+LzP4czPDTvteaa3PMx6HKBcQZr3eb8MfdKeI2lBtmyV2mokBnPXI
         JY2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b3S7OYyXOTGNtQK8jOgzcqC9ulA1poW0yLLID9bs/bI=;
        b=Gjv0DvEYE8dB8vhl4zIfB5UcKejQfKJfDNHQYnExUDaIogi+09svN+D34Kiao8yCQL
         EYW1Tyrz+fFoV1t58xXHLS+nBj4JqXJH/A3Kf7oGObqJS9WYewJlvPyHj4pXaex4iGrN
         mSk+TM8NR17z6oc5PiZzraAAuaJ6gFRpWJIx+gwFHF0tFgaJaH6Mc8XmgO//yPBVps3b
         b+UJ6ugB+P9kqzSZFDBn5uiMgTLPhrxhB3rKD8AjrQlgmvOKNy9VDKRgDhUxBv0fBCa4
         uoP+D3ARQmFOyPu1j9c9phT04s/Q2A2WOafwCfdrn/wQ6haq/IfwLzrIWlBGSp2y9JJe
         mMvQ==
X-Gm-Message-State: AOAM533zYW8TENJ91PNW3aoxinzkZotq01coGlYMpxQLe9Jm0SDpNnhc
        i1yQMANVGYZqFYXk/Aa4RtcbKL8qlURTiFEpqDs=
X-Google-Smtp-Source: ABdhPJyFZ1fAdu9J83njCjUBFyOBP6tsyGARoUK1PAjpf9+558UTGO9ecjF3EV4ZiyL19xyoNbAtNTt9AJnJ4qxCpas=
X-Received: by 2002:adf:fe8b:: with SMTP id l11mr28535186wrr.228.1637226882129;
 Thu, 18 Nov 2021 01:14:42 -0800 (PST)
MIME-Version: 1.0
References: <20211117160718.122929-1-jonas.gorski@gmail.com> <YZUw4w3NsfuDO4qS@lunn.ch>
In-Reply-To: <YZUw4w3NsfuDO4qS@lunn.ch>
From:   Jonas Gorski <jonas.gorski@gmail.com>
Date:   Thu, 18 Nov 2021 10:14:31 +0100
Message-ID: <CAOiHx=kRQvOc59Xtxwa0R8XNdrSsjigPubGWiyon+Sf94s2i5g@mail.gmail.com>
Subject: Re: [PATCH] Revert "net: ethernet: bgmac: Use devm_platform_ioremap_resource_byname"
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, 17 Nov 2021 at 17:42, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Nov 17, 2021 at 05:07:18PM +0100, Jonas Gorski wrote:
> > This reverts commit 3710e80952cf2dc48257ac9f145b117b5f74e0a5.
> >
> > Since idm_base and nicpm_base are still optional resources not present
> > on all platforms, this breaks the driver for everything except Northstar
> > 2 (which has both).
> >
> > The same change was already reverted once with 755f5738ff98 ("net:
> > broadcom: fix a mistake about ioremap resource").
> >
> > So let's do it again.
>
> Hi Jonas
>
> It is worth adding a comment in the code about them being optional. It
> seems like bot handlers are dumber than the bots they use, but they
> might read a comment and not make the same mistake a 3rd time.

Sounds reasonable, will spin a v2 with a comment added.

Regards
Jonas
