Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE19356050
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242052AbhDGA3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241974AbhDGA3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 20:29:42 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EF8C06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 17:29:32 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id t140so11661555pgb.13
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 17:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LLarwwKAs0HSVvbZ8ib9VIb2FoujGLWDIrjWhL74VOg=;
        b=CRsuUXJyBFVH6f5rSu0H8wMN6kFOT6a2PfWbe7WECf5IcvP2JYmHsJSKiMGab+9+eu
         nnMLZYessHIs2c7Z6xCpZO5SJV6dRjGDK3EDd1WN+4YjHNwdq8YHoNEUhJ5PbrP4MKwb
         qJDjmtyTrCUrJZuItGS98XjLv5t0PsX6Tzg7NN6Uu0sa8WQxy7I5qloE5fj2sBM0iIXg
         cyLHudco0eqv347i4rixKB3JCJr6gIpZjrp+JPOFe6r04BaVNgKWkBs2yRmH4HD0cdMd
         A4dMSCxsvHn+ab05q1Rj16X6LX2RSjWqTQUtVPOO6CXpr2wKghDrXblWF8kG76+Gr+Qm
         flCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LLarwwKAs0HSVvbZ8ib9VIb2FoujGLWDIrjWhL74VOg=;
        b=EijVU4IaoNV9QdEqQbzXCLulwadDszCPygHP0GZ4617ldwMrSNejvAQ5mIIZaNrfST
         gX78tAymurdaIae1mKUXbXiHIeVVMSo1uIzA2BA8ujKBppyTeXOPgDO/x2ZgwG1CQ4DY
         mqrL3eGhDM1h7lSxz83065uBbMLPfwlGwdw3sxNMk85WgWydP1xInMrWa2i7lqtxZkcY
         EJHzu8MaLBetDdHlO3kVkpJlcvv2Yn/fMNVe1krefOrz5zwWwlWEm4006JotA3nXrF9b
         xVYnA/+JJJ+nEmtSUHF6MtWN4HP0zpfepME8A0Qulay2BeNx/8j3z0hwq5fzWQUADZDG
         fk8A==
X-Gm-Message-State: AOAM531agrbd2hr5WDNKj0pfLo7HOwga2Z06fLKsgWCBauKUYvgpiOtS
        55Y8NW1airjXU8Pol8XIoQk=
X-Google-Smtp-Source: ABdhPJzqG7wRLmULvsNg/b+TFko0JJNirZ8cl/94eqhBscnVtL4AtYnHBoD1eCO4jmtoIjEcsPK1eQ==
X-Received: by 2002:a62:ee0c:0:b029:214:7a61:6523 with SMTP id e12-20020a62ee0c0000b02902147a616523mr686293pfi.59.1617755371999;
        Tue, 06 Apr 2021 17:29:31 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id v1sm2885118pjv.0.2021.04.06.17.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 17:29:31 -0700 (PDT)
Date:   Tue, 6 Apr 2021 17:29:29 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Allen Hubbe <allenbh@pensando.io>
Subject: Re: [PATCH net-next 09/12] ionic: add and enable tx and rx timestamp
 handling
Message-ID: <20210407002929.GB30525@hoboy.vegasvil.org>
References: <20210401175610.44431-1-snelson@pensando.io>
 <20210401175610.44431-10-snelson@pensando.io>
 <20210404234107.GD24720@hoboy.vegasvil.org>
 <6e0e4d73-f436-21c0-59fe-ee4f5c133f95@pensando.io>
 <20210405182042.GB29333@hoboy.vegasvil.org>
 <d9f49805-e1da-23ab-110f-75e3e514f2a1@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9f49805-e1da-23ab-110f-75e3e514f2a1@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 04:06:09PM -0700, Shannon Nelson wrote:
> Interesting... I doubt that our particular MAC and PHY will ever be
> separate, but it makes sense to watch for this in the general case. I've got
> an update coming for this.

Even if your HW can never support stacked MAC/PHY HW time stamping,
still your driver should conform to the correct pattern.

Why?  Because new driver authors copy/paste stuff they find in the tree.

Thanks,
Richard
