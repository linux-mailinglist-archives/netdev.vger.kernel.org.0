Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767112F53D9
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 21:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbhAMUHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 15:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728804AbhAMUHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 15:07:10 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA7CC061795;
        Wed, 13 Jan 2021 12:06:30 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id s75so3494664oih.1;
        Wed, 13 Jan 2021 12:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lv1Kbmm4YHPjDW6jxGU7xhxNaDP025bj9EsoV9E8pOE=;
        b=cRPm9pZPSknFMMW6crH2FgRrxmhcQ+9YGAlUaON/y/ybThM0pf/7uptAjn2AMJT8fg
         WwPzkkD+u39tegiwh6mZ/7DlW7JRJ17EG6DMTTcBLCxIpsx4yd0DuEJBa+BI8GVR0iYE
         ATNGoQzT0/d5/Fe+SneQV2JnBG3GLHa0lBIQHNsOUXYR8alYsQmrU/TKpwelf8XAl0P5
         eZ6LiFxDatmCPUK+1yQx9wmra+nhMDLmNImNCASOeuxppbXiCpdFqVrJEnzlC1bg3kw8
         Prb9U0fyqhZVzuuek2g8XAKWO4j50FAbQnhTDpRa04z3m4o42BAy6msoM9nRUhKUSBGX
         iPzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lv1Kbmm4YHPjDW6jxGU7xhxNaDP025bj9EsoV9E8pOE=;
        b=A6+pJNP4GiUZ4zXQY/ilQOlKXMTuOCRFOAA2OBDCAr2RH+JgXJcwVivftRVcz0iEy0
         QPcwhaNKqmV1HANKt8WxmVpsf6Ye8LyS7SJW5nnsMj8TIcGOrS59tXA+6rcY2gFIl4m9
         OIrMsMyaq1sjrYWwbNjZBCCRMlScg3ZRjwM/es6i2OQoVF5mugJikYWVc59QJLapBf4G
         hawTLz4EFtiiRJj/9HvZF93cXIb04gObtznJkRHjeRn6P4PoUQj7reqR7T9WLzAShOaC
         91B5o93wyGHcGNmlV0813nAlaUFIdVAcrx11mVcku4YeoHoSRpLHbzpVNzHp+nUBEEBG
         HxDg==
X-Gm-Message-State: AOAM5321dFbN/8AQPXA+bFojq5B2xdpGJ0buKRFXPFZ+59YPikUehAVl
        7ZrcetnaYskK1JQKqAaR+6tIQvj6ANI=
X-Google-Smtp-Source: ABdhPJzoFRcRa704M1sWroE2BwDPq8dQvtRz8H0YTrXDy4cVEGBeiMhCV157HqoLFcuVHtupz/u24w==
X-Received: by 2002:aca:b06:: with SMTP id 6mr610373oil.74.1610568389622;
        Wed, 13 Jan 2021 12:06:29 -0800 (PST)
Received: from localhost.localdomain (99-6-134-177.lightspeed.snmtca.sbcglobal.net. [99.6.134.177])
        by smtp.gmail.com with ESMTPSA id m7sm621454oou.11.2021.01.13.12.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 12:06:29 -0800 (PST)
Date:   Wed, 13 Jan 2021 12:06:27 -0800
From:   Enke Chen <enkechen2020@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>
Subject: Re: [PATCH] tcp: keepalive fixes
Message-ID: <20210113200626.GB2274@localhost.localdomain>
References: <20210112192544.GA12209@localhost.localdomain>
 <CAK6E8=fq6Jec94FDmDHGWhsmjtZQmt3AwQB0-tLcpJpvJ=oLgg@mail.gmail.com>
 <CANn89i+w-_caN+D=W9Jv1VK4u8ZOLi-WzKJXi1pdEkr_5c+abQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+w-_caN+D=W9Jv1VK4u8ZOLi-WzKJXi1pdEkr_5c+abQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Eric:

Just to clarify: the issues for tcp keepalive and TCP_USER_TIMEOUT are
separate isues, and the fixes would not conflict afaik.

Thanks.  -- Enke

On Tue, Jan 12, 2021 at 11:52:43PM +0100, Eric Dumazet wrote:
> On Tue, Jan 12, 2021 at 11:48 PM Yuchung Cheng <ycheng@google.com> wrote:
> >
> > On Tue, Jan 12, 2021 at 2:31 PM Enke Chen <enkechen2020@gmail.com> wrote:
> > >
> > > From: Enke Chen <enchen@paloaltonetworks.com>
> > >
> > > In this patch two issues with TCP keepalives are fixed:
> > >
> > > 1) TCP keepalive does not timeout when there are data waiting to be
> > >    delivered and then the connection got broken. The TCP keepalive
> > >    timeout is not evaluated in that condition.
> > hi enke
> > Do you have an example to demonstrate this issue -- in theory when
> > there is data inflight, an RTO timer should be pending (which
> > considers user-timeout setting). based on the user-timeout description
> > (man tcp), the user timeout should abort the socket per the specified
> > time after data commences. some data would help to understand the
> > issue.
> >
> 
> +1
> 
> A packetdrill test would be ideal.
> 
> Also, given that there is this ongoing issue with TCP_USER_TIMEOUT,
> lets not mix things
> or risk added work for backports to stable versions.
