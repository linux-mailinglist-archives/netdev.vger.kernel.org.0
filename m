Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC502F541C
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 21:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbhAMU25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 15:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728842AbhAMU24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 15:28:56 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B06C061794;
        Wed, 13 Jan 2021 12:28:16 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id d20so3175052otl.3;
        Wed, 13 Jan 2021 12:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jLUkwOEZZymFceGAr0IzTr+GxfxreGrJDbxkHS4zq74=;
        b=tlDHxSM2utOECZ2jXUxVIwv7eiLTlvDuI6TdNu/mYi+VyZpy5ktEvuzKtPJu+KlFNb
         rB9IoFPn3iiSKM5nd2OX81f1hwLlQ8PwwrQOWoaypAJluOqZycGO1v234IUs1MDGYElc
         ajpZ6xLiYZu7hbtaIf4t7Bzh1d8X1ONklu60X/92OJR8CSKXr6e3GVm4+ve/vBSWv4JK
         NGmaLb/TTYtpLF83pTBY5pAN+OHBr3bNMkll0SkXN8iJo7z+xHT9QdtdAYW4n/+ofqFy
         0vqBFsOJhcstoRE/VoNRL9LOht5uV2RnEKK0unxpbpgGjU+N1qCNtJw/lbkaVwk5njjP
         FyNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jLUkwOEZZymFceGAr0IzTr+GxfxreGrJDbxkHS4zq74=;
        b=KgV6lM81CSYCU+bF0VipgzqnAWka7vWVsbMWEEvg3XGu0V8ZbeX5ehLFF70jDQij8R
         rNzMc6EQd5ZY17TEWaewRGXboYJ/2CIPFi+2BOKg4JCZJ+fkRIQYrdHyzVgf0bcT0uKQ
         OOGU8cUnd360RpLmAq+jTYzh8pbno7DxiGUt49wCxArD2QjPVsf4rutrdEKNxFY1W2H9
         rHEbLRaV0+4oU4bVTivN3cHHqx9IFHMsfRhbx+nMpLHTl9RE8a1ffpjZvqn/j4C3tlJO
         qVvb7sA6TGlYAyPf2n6G3ZmMPGLfeAEKXgi27aWd4D/w1hn9Fjwv99M4eLPKN/WaaTqo
         yf9w==
X-Gm-Message-State: AOAM530v12OOGNEiDrrZGkc0DKO9ZyCsp37RmL0BntxxMNP7beKFvLVx
        wQcZH7BM4XRqKwjY8o/EmNY=
X-Google-Smtp-Source: ABdhPJxHGKCERQPNJFDJNIheC9+ncaoOI2QQQsV+nB3QYdld23m76nOr0TtBj7GrH+A/rmluGraJXQ==
X-Received: by 2002:a9d:65d7:: with SMTP id z23mr2459397oth.131.1610569695835;
        Wed, 13 Jan 2021 12:28:15 -0800 (PST)
Received: from localhost.localdomain (99-6-134-177.lightspeed.snmtca.sbcglobal.net. [99.6.134.177])
        by smtp.gmail.com with ESMTPSA id c18sm619625oib.31.2021.01.13.12.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 12:28:15 -0800 (PST)
Date:   Wed, 13 Jan 2021 12:28:12 -0800
From:   Enke Chen <enkechen2020@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>, enkechen2020@gmail.com
Subject: Re: [PATCH] tcp: keepalive fixes
Message-ID: <20210113202812.GA2746@localhost.localdomain>
References: <20210112192544.GA12209@localhost.localdomain>
 <CAK6E8=fq6Jec94FDmDHGWhsmjtZQmt3AwQB0-tLcpJpvJ=oLgg@mail.gmail.com>
 <CANn89i+w-_caN+D=W9Jv1VK4u8ZOLi-WzKJXi1pdEkr_5c+abQ@mail.gmail.com>
 <20210113200626.GB2274@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113200626.GB2274@localhost.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 12:06:27PM -0800, Enke Chen wrote:
> Hi, Eric:
> 
> Just to clarify: the issues for tcp keepalive and TCP_USER_TIMEOUT are
> separate isues, and the fixes would not conflict afaik.
> 
> Thanks.  -- Enke

I have posted patches for both issues, and there is no conflict between
the patches.

Thanks.  -- Enke

> 
> On Tue, Jan 12, 2021 at 11:52:43PM +0100, Eric Dumazet wrote:
> > On Tue, Jan 12, 2021 at 11:48 PM Yuchung Cheng <ycheng@google.com> wrote:
> > >
> > > On Tue, Jan 12, 2021 at 2:31 PM Enke Chen <enkechen2020@gmail.com> wrote:
> > > >
> > > > From: Enke Chen <enchen@paloaltonetworks.com>
> > > >
> > > > In this patch two issues with TCP keepalives are fixed:
> > > >
> > > > 1) TCP keepalive does not timeout when there are data waiting to be
> > > >    delivered and then the connection got broken. The TCP keepalive
> > > >    timeout is not evaluated in that condition.
> > > hi enke
> > > Do you have an example to demonstrate this issue -- in theory when
> > > there is data inflight, an RTO timer should be pending (which
> > > considers user-timeout setting). based on the user-timeout description
> > > (man tcp), the user timeout should abort the socket per the specified
> > > time after data commences. some data would help to understand the
> > > issue.
> > >
> > 
> > +1
> > 
> > A packetdrill test would be ideal.
> > 
> > Also, given that there is this ongoing issue with TCP_USER_TIMEOUT,
> > lets not mix things
> > or risk added work for backports to stable versions.
