Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D3F46F5F5
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 22:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhLIVel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 16:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbhLIVeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 16:34:31 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D72EC0617A1
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 13:30:57 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id k64so6577706pfd.11
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 13:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4bSfNnt3pQHgrCp4l3BL89LcNqI2ZvMGSV9huZ/Grv4=;
        b=WIHpK8/1o2oS8sG+8A/qBPAkfeip+PDgI0IzGWJ8a+3uF2By+v1/ZRoqyvJEzGh0+w
         EblFzhoFHVaRjYOAuTfQX4wt1YNqzUjKIN9obgJO3vSJZpGjF1+LkJrHJ6QSfvUcYAeU
         JVMfQB0jBzLVI6vnCVzWOjHFCgtRkQFiPJnNJUzqgyWPXvCsicU4e6BIo5OQqSrAlTaH
         /93/0NXM9Uwno6tCNzoHrd2glywVsjXxZrhEuJWmVqzYRLoVUzNJawVGR9yyMXgkVvJa
         B2R2dQX10esNXNpe7NG0i/TYQvtM/WsM+kL0U9ADGZmsLWZ/2AGzEZ+ZF5+el2ys/qQ6
         xrwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4bSfNnt3pQHgrCp4l3BL89LcNqI2ZvMGSV9huZ/Grv4=;
        b=794ttBJQEfJgZFVJlXTCq0MpcEWQLsRJmHIYB8GbPZx/sXOJ55XD5O400EDAyV/k9o
         ZFLJI634UOAKYyoPbpOvmkl+dSL0XgdIzAD6U0MjF1zBSjYxZDhdfDP6fRPGksv9g1Ry
         L8P622M3JgJIge/6v/U8ooGNoqJceB+4bsMPwCS/Ux9bAyccnbZLjMZKMsTI9zfci9Q1
         u1nmE0MLlP5YGrvi35remjBZqU+kHV3yxRl+mOBzra3KglCHSh7F62QMaP0Tj/Msuri2
         atWy5loooeoT46TmkpZnJgm7XswMldr70Nat8ZpkIkQEVUyTof0GgyVleMovv9/tWYDb
         +9FQ==
X-Gm-Message-State: AOAM5336rVRnV1BsXbsIyWRqnGMr7DQV9L2T4gtugGPHhRGxXyS1Vj8E
        +k80wUDluJ00FIepOTJLvSg=
X-Google-Smtp-Source: ABdhPJziNCUo4WM7NHQROf9Va4cwNYrLxkAQJLXw34X8yJxzlDeHmOGVrSP4WKPae3a0xcKMI0K0WQ==
X-Received: by 2002:a62:1c0e:0:b0:4a0:3492:37b5 with SMTP id c14-20020a621c0e000000b004a0349237b5mr13910158pfc.33.1639085457103;
        Thu, 09 Dec 2021 13:30:57 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id f7sm38041pfj.41.2021.12.09.13.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 13:30:56 -0800 (PST)
Date:   Thu, 9 Dec 2021 13:30:53 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 1/2] net_tstamp: add new flag
 HWTSTAMP_FLAGS_UNSTABLE_PHC
Message-ID: <20211209213053.GD21819@hoboy.vegasvil.org>
References: <20211208044224.1950323-1-liuhangbin@gmail.com>
 <20211208044224.1950323-2-liuhangbin@gmail.com>
 <20211208152022.GB18344@hoboy.vegasvil.org>
 <YbGGosXXCvBAJEx4@Laptop-X1>
 <20211209212258.GB21819@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209212258.GB21819@hoboy.vegasvil.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 01:22:58PM -0800, Richard Cochran wrote:
> On Thu, Dec 09, 2021 at 12:31:30PM +0800, Hangbin Liu wrote:
> > On Wed, Dec 08, 2021 at 07:20:22AM -0800, Richard Cochran wrote:
> > > I guess that the original intent of hwtstamp_config.flags was for user
> > > space to SET flags that it wanted. 
> > > Now this has become a place for drivers to return values back.
> > 
> > I think it's a flag that when uses want phc index of bond.
> > There is no affect for other drivers. It only affect bond interfaces.
> > When this flag set, it means users want to get the info from bond.
> > 
> > Do I missed something?
> 
> No, I simply mean that the input/output direction of the bit in the
> flags should be clear.
> 
> - User space will not set this bit, only read it.
> - Drivers may set this bit, but if user sets it, it is an error.

Oh, I am confused.  Your patch does this:

- if user sets bit, then return bonded index
- otherwise, return EOPNOTSUPP

That is fine with me.

Thanks,
Richard
