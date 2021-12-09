Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818FC46F5D6
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 22:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbhLIV0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 16:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhLIV0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 16:26:36 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B011C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 13:23:02 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id z6so4860202plk.6
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 13:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sibIdkupC+dr/2zVEuRruDt5lqH4tvD0m4FeVXUv6os=;
        b=J5rYdCvYu00w3ocZGut2XFpRjMKmYZUfGu7yRwTFT9nKiyXY4VvFjNNp+bqkItJRLF
         SORNNYh6B67zVb1BFLO74xz27ChrFmEhUVL4Q0Abu/kKtzDOUuRJOV3fqkF566pFBtNj
         h8nIfgDj8yIBv/vhAzZRSrJLtRfBjoobq3sbIn+orjVfTKETGJk1pHFE/vyGjLZJLnHC
         nUaU4HAEqUeK9RpJa46LJDIPOxE7eUWWC85ymy3qducTzqWeC0VmiGSndKsPG+cNa8Ni
         a7wm1iB91sbe5Lmpz7cvJsY+JWpC2/9A4GA4Uk4CaB8bgvf7vuyiBtJUuoCzrXfPur6W
         lNoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sibIdkupC+dr/2zVEuRruDt5lqH4tvD0m4FeVXUv6os=;
        b=5xSaFJytGLaxIY2KU5t1NC87kos+6jD1omvU1ZvKFWSeQpxB96SYep6WBddQl7tixD
         jbHyN+TSou9/eEN2AAFwZnabYrz9uM7okgtpUXqz/33XfpYx8Aj0jvrUAA4ejDNEYISn
         rCEzpiNBQfyVZii3FiQMIQMEOS38dTpQS0LjeFYMyyYXLYeuaOYiGPKa1ADk7KQDF86p
         x4dZA53b4qiHQC9joIm+dItegwDVSBAGgiD+FyGOI4lNXor1TV2QxbcWX9pKFJVAyYRd
         OxuqJzX/V+KE8jF7gWKF6LIU+t4nOupSgdXD8cg8IrE0cMyvdifwjZaFt2w6RmAAQdqH
         ruHg==
X-Gm-Message-State: AOAM532QJ5UocWVSqsbLX3PhhSIvWlQIPk19tK7wQslk041N+XKjHcrk
        kC+OGixqFK4r5Naxtxjcks+MPS8Snh8=
X-Google-Smtp-Source: ABdhPJxgxCu8cpsv2LqL9rerFMlWyJ7v/EbJp0ThTMikGYD1VJ+8+XeSdEUsRZXhpp5ckvH+sRr9RQ==
X-Received: by 2002:a17:90b:4b01:: with SMTP id lx1mr18929493pjb.38.1639084981809;
        Thu, 09 Dec 2021 13:23:01 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id f4sm605660pfg.34.2021.12.09.13.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 13:23:01 -0800 (PST)
Date:   Thu, 9 Dec 2021 13:22:58 -0800
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
Message-ID: <20211209212258.GB21819@hoboy.vegasvil.org>
References: <20211208044224.1950323-1-liuhangbin@gmail.com>
 <20211208044224.1950323-2-liuhangbin@gmail.com>
 <20211208152022.GB18344@hoboy.vegasvil.org>
 <YbGGosXXCvBAJEx4@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbGGosXXCvBAJEx4@Laptop-X1>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 12:31:30PM +0800, Hangbin Liu wrote:
> On Wed, Dec 08, 2021 at 07:20:22AM -0800, Richard Cochran wrote:
> > I guess that the original intent of hwtstamp_config.flags was for user
> > space to SET flags that it wanted. 
> > Now this has become a place for drivers to return values back.
> 
> I think it's a flag that when uses want phc index of bond.
> There is no affect for other drivers. It only affect bond interfaces.
> When this flag set, it means users want to get the info from bond.
> 
> Do I missed something?

No, I simply mean that the input/output direction of the bit in the
flags should be clear.

- User space will not set this bit, only read it.
- Drivers may set this bit, but if user sets it, it is an error.

Thanks,
Richard
