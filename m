Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A09294E59
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 16:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443366AbgJUOQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 10:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408411AbgJUOQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 10:16:15 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199CFC0613CE;
        Wed, 21 Oct 2020 07:16:15 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id h10so2228340oie.5;
        Wed, 21 Oct 2020 07:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xUmNqNf011uR7tg0J0IGY/1uNWCq3cTFpXxi+e1PlcE=;
        b=oFuUqrcQu2/VexDMPJ4hNqPPO70JMTIirpAZAlzCxd6vJTunI5JlqWoEhF6ZCytlIF
         KsNmRlFiZt+V9AXnca3CWmiXKYDzsuWvi6MIOWvaRYrLoG0VwM5yw/BkcAmYvUxHoJLP
         J4owwMshxFW40QHvT4pg+8SatIS/YOGsAOW6zM4IucTI8vQ8VK+AvWFssU9bxoiXMj+J
         brMZ5TUjVrsMN4D47GTTLLAvwvAM/lgIQf1/2VXc/tXEPU82tI+DSXhZj2LDjeo6I/ww
         k/uOxKUo7kUjCb+iNYcdnw5W4+WhPAEfIeWrC6Nnk0uqWuiVaJ3vd+EBX7GThXg2dEIA
         W24Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xUmNqNf011uR7tg0J0IGY/1uNWCq3cTFpXxi+e1PlcE=;
        b=mchIX/leqlKiwAEtDKpUJY6KwG0BYhqibcKJIhxLqH/V7VawsWzc033Hu6dssHVvqu
         KSCGdPK6yr4BLxo+jhExEe4RIAIq5cbWBoTIB8C/yAugbzh+I2OqR3XmCvy3wS8FUMCn
         bl8ICu8Z0aQJrvj0Eod24AP6deh9ggf1dgMyKSHrCSNo90ZeBzkAKqXYlsuJVLJD+LGQ
         TLYMQaQ4BhzY3uehnzNpLVuXTGkJWderHG7zbN2f0bPn8y4iG3SVAI/aF1TvxDMK+3pB
         prJ8EMmiaZYSxQXkse/pNJKgfJ83B7+7II7u05pHFQoreBN4m+J7evvf98mTLZiUjmqu
         UWjQ==
X-Gm-Message-State: AOAM533uRHOW/QdOpvXF+kCRHh+fgiRWAnaZ4kcDYhSWBEqcYupMqkTF
        sm7BJ2N4+M4yLZALlQoPxac7QwrONtaaiFlJ0sk=
X-Google-Smtp-Source: ABdhPJz5cRGLf834K6Hy1EmFtbZU8SqqdgCI0HHvn1Y+w4kFcU1UtNqw2/ZupbkiNH1O5H5/JL59Tq+g9eR5jqPpMQY=
X-Received: by 2002:aca:420a:: with SMTP id p10mr2301545oia.117.1603289774390;
 Wed, 21 Oct 2020 07:16:14 -0700 (PDT)
MIME-Version: 1.0
References: <20201021135140.51300-1-alexandru.ardelean@analog.com>
 <20201021135140.51300-2-alexandru.ardelean@analog.com> <20201021140852.GN139700@lunn.ch>
In-Reply-To: <20201021140852.GN139700@lunn.ch>
From:   Alexandru Ardelean <ardeleanalex@gmail.com>
Date:   Wed, 21 Oct 2020 17:16:03 +0300
Message-ID: <CA+U=DsrZM4gRpmez6KqT8XTEBYwA-gwHjHQWa3Pn+G1nsYD3CA@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: phy: adin: implement cable-test support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        David Miller <davem@davemloft.net>, kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 5:09 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
>

removed my typo-ed email

> Hi Alexandru
>
> Overall, this looks good.
>
> > +static int adin_cable_test_report_trans(int result)
> > +{
> > +     int mask;
> > +
> > +     if (result & ADIN1300_CDIAG_RSLT_GOOD)
> > +             return ETHTOOL_A_CABLE_RESULT_CODE_OK;
> > +     if (result & ADIN1300_CDIAG_RSLT_OPEN)
> > +             return ETHTOOL_A_CABLE_RESULT_CODE_OPEN;
> > +
> > +     /* short with other pairs */
> > +     mask = ADIN1300_CDIAG_RSLT_XSHRT3 |
> > +            ADIN1300_CDIAG_RSLT_XSHRT2 |
> > +            ADIN1300_CDIAG_RSLT_XSHRT1;
> > +     if (result & mask)
> > +             return ETHTOOL_A_CABLE_RESULT_CODE_CROSS_SHORT;
>
> The nice thing about the netlink API is that it is extendable without
> breaking backwards compatibility. You could if you want add another
> attribute, indicating what pair it is shorted to.

That would be an idea.

Actually, I'd also be interested [for this PHY], to report a
"significance impedance" detection, which is similar to the
short-detection that is already done.
At first, this report would sound like it could be interesting; but
feel free to disagree with me.

And there's also some "busy" indicator; as-in "unknown activity during
diagnostics"; to-be-honest, I don't know what this is yet.
I'd need to check, but odds are that I'd need to also ask about it.
So, I don't think I'd implement this.

>
>         Andrew
