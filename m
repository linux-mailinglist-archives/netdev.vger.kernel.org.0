Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03793250EF
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 14:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhBYNtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 08:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbhBYNtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 08:49:32 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8CEC061786;
        Thu, 25 Feb 2021 05:49:17 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id k2so451139ioh.5;
        Thu, 25 Feb 2021 05:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UJpMiDeR5e81SLjna5kQPFiv7DjhNpdh1mQ36CWKCU0=;
        b=d8JGs98H7pp/gCDG2m+l2j61WMZR/DLTYaw8mK4AwTDLq+eKyIAWdpZ78cbG60IOua
         fpN7QE/n/9uw8YEVnowSAaCgeABpWXq1Tz0Qe+QYOeTBtNxgxDrnk29KYpHc5Ohu75nz
         KCkH94n87xIv2kn7q4ePVkpGkRNUVENNSlfpqPGMW3RKPt/2um16vnR2ZLFOFiYpmK9d
         Zqmw1n6vVPPyy39AvLgQCldBnEHMbl8GVZUOxORVNes11BhYR/FizZ+xO5fPJsLjewpO
         2LuPN1TH6ZFzqevmfP6QrDgxlsy1npQxke4Qi3MvVV74Dif+u3fy83JdRqWYe0xz+BdB
         AH7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UJpMiDeR5e81SLjna5kQPFiv7DjhNpdh1mQ36CWKCU0=;
        b=Kr1QtDrWt+tCC3cL4dObXcliy68a6u1p+Qo32LW0LqFq2J6UYvYPrQ7Ll4WnDP6ud/
         2Svb0m9WB+CJM6HiFYgGosX5YNudkcLhIyGKe8gONlBZGdFHD65nQ6BuKdqdGSQ1WtYX
         jFhIO4nbH+1B+sVt124LD3y9lKn4ls97C6fwrcm41wQawFP0SPgY9G5/kXDoeCwnFLAz
         z0mC4QV7tnwm6Va/52aNXOoPCB7/9v1adHVxjXTJTl8lUJ1CSHVm9UxLswk3S6MvedZb
         rGycKjKOHSIXb6HYcjzfmWk2ZkpfkMgOtvaL1QFGqYHli+7VmMBb5TH4CaTsH0VT+JyV
         +qUw==
X-Gm-Message-State: AOAM530v9K97b8aHEGxTjK3Rbn8qcapncs89KpPLvcRbZZOrcyPQLWqx
        6EUfVWaFaUBPOijQUq28UZqrwNutoqL71gIgDA03lL7S528=
X-Google-Smtp-Source: ABdhPJwVRyG8wV2EWyGt2tFgntkYqMntju34OBdoXuzPxgMgogZZfkVIJDICRDHr95orvYU2Wiuh1tkQWVWTaXX0kr4=
X-Received: by 2002:a5e:dd46:: with SMTP id u6mr2744670iop.73.1614260957176;
 Thu, 25 Feb 2021 05:49:17 -0800 (PST)
MIME-Version: 1.0
References: <20210220065654.25598-1-heiko.thiery@gmail.com>
 <20210222190051.40fdc3e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEyMn7ZM7_pPor0S=dMGbmnp0hmZMrpquGqq4VNu-ixSPp+0UQ@mail.gmail.com>
 <20210223142726.GA4711@hoboy.vegasvil.org> <CAEyMn7Za9z9TUdhb8egf8mOFJyA3hgqX5fwLED8HDKw8Smyocg@mail.gmail.com>
 <20210223161136.GA5894@hoboy.vegasvil.org>
In-Reply-To: <20210223161136.GA5894@hoboy.vegasvil.org>
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Thu, 25 Feb 2021 14:49:04 +0100
Message-ID: <CAEyMn7YwvZD6T=oHp2AcmsA+R6Ho2SCYYkt2NcK8hZNUT7_TSQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: fec: ptp: avoid register access when ipg clock
 is disabled
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

Am Di., 23. Feb. 2021 um 17:11 Uhr schrieb Richard Cochran
<richardcochran@gmail.com>:
>
> On Tue, Feb 23, 2021 at 04:04:16PM +0100, Heiko Thiery wrote:
> > It is not only the PHC clock that stops. Rather, it is the entire
> > ethernet building block in the SOC that is disabled, including the
> > PHC.
>
> Sure, but why does the driver do that?

That is a good question. I tried to understand the clock
infrastructure of the imx8 but it looks quite complicated. I cannot
find the point where all the stuff is disabled.

-- 
Heiko
