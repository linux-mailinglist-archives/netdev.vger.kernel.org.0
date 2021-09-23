Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DBD4167D9
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 00:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235630AbhIWWNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 18:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232145AbhIWWNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 18:13:35 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711A5C061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 15:12:03 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id g8so28457890edt.7
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 15:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7tIIlep2yoDdtzPr18hxaRs7YF9bAFi1nuVBH57oNMw=;
        b=JOJ2xIAeuv1q1UemZ6tvzISM/Nj/1FbxRtbwAt2qZGPNzmY9+Y4I5OVQzu0bNB4BWm
         XoQjEhIdeJ40m2JA8bKnUofRmWwaSH70dYBZeZI/4J4X1lqUxPxEJium9ZSpKTZAUY11
         SgDuD94abCw/c+zk7Iiye+VbN6dHaxE9x/qjnpChpzm0yoKu8S29DRN9qIZIsRurGRzA
         mEMYiU/A0mjDUyzaRhxOcujcEeMgJjDOBIetCN9248qCUsn3UAAMBfDjL4bmJ9vWfWxO
         P48RKOff3tUicT0TIP4CH8ZICexCC1MiKXB6nxUsxdIwExt8jzJJ7b22Yt8kJVTL+X6g
         XBIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7tIIlep2yoDdtzPr18hxaRs7YF9bAFi1nuVBH57oNMw=;
        b=45xh6+FRuSpB3U0x+CXJJ4mzloYzBwhASNMvwoqFeyoTqZZ6mXLoVbjk/jqfULmlQm
         70+zQwRGdMMulF7LIKML0hQ3mz/kgw1WVkYl8XjU9/6LZoIV1KDW3e81N40DWP0+iyHG
         WGi949hxm8Ni655wSsei4cXyWZlDCc7mobb4kB//oHybE9XeICQVDpMZtJuBL+FcIBn0
         /JXhZ19ZyhVRiE+fHPSbmxMrSP5eh/Kc55TCQs3ycTDm6jH+cyAcRgrbwO9JEOVuXCEa
         BV0/c6XQPdwTxlIk36kdXBiZnzBpTletGNXboVhKUn6W3mg9ApKeKi9KpKOIvHizMpXh
         QaRA==
X-Gm-Message-State: AOAM530QgfNyQZQc46BgNIkjCh8Cz3+xUP+hJpgA+AZ4qU1cCq3udjOr
        3AhZaBXYpLNUQPXhpEGttpQJaAQ1e/4=
X-Google-Smtp-Source: ABdhPJyG0SavczT9zZXrvh4Qeyb5glIVcHWu9w9vdZPTZ8/1J5Qrph1Tr5sSFfnNnvVwo+9MXUW+4w==
X-Received: by 2002:a05:6402:16d9:: with SMTP id r25mr1479895edx.80.1632435121929;
        Thu, 23 Sep 2021 15:12:01 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id s4sm3808882eja.23.2021.09.23.15.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 15:12:01 -0700 (PDT)
Date:   Fri, 24 Sep 2021 01:12:00 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: tag_rtl4_a: Drop bit 9 from egress
 frames
Message-ID: <20210923221200.xygcmxujwqtxajqd@skbuf>
References: <20210913143156.1264570-1-linus.walleij@linaro.org>
 <20210915071901.1315-1-dqfext@gmail.com>
 <CACRpkdYu7Q5Y88YmBzcBBGycmW92dd0jVhJNUpDFyd65bBq52A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYu7Q5Y88YmBzcBBGycmW92dd0jVhJNUpDFyd65bBq52A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 11:59:36PM +0200, Linus Walleij wrote:
> On Wed, Sep 15, 2021 at 9:20 AM DENG Qingfang <dqfext@gmail.com> wrote:
> > On Mon, Sep 13, 2021 at 04:31:56PM +0200, Linus Walleij wrote:
> 
> > > This drops the code setting bit 9 on egress frames on the
> > > Realtek "type A" (RTL8366RB) frames.
> >
> > FYI, on RTL8366S, bit 9 on egress frames is disable learning.
> >
> > > This bit was set on ingress frames for unknown reason,
> >
> > I think it could be the reason why the frame is forwarded to the CPU.
> 
> Hm I suspect it disable learning on RTL8366RB as well.

Suspicion based on what?

> Do we have some use for that feature in DSA taggers?

Yes.
