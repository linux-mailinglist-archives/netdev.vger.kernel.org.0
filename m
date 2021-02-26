Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8263264A8
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 16:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhBZPYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 10:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhBZPYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 10:24:16 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0716FC06174A;
        Fri, 26 Feb 2021 07:23:35 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id e9so5471761plh.3;
        Fri, 26 Feb 2021 07:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KJuay+IZ+1N+1Y1/y/2UF7sO86HdqKbbyx571Yc0XCk=;
        b=qQIZRwAQkkH/lCc+oNsgACw3PtZvESQwyx/r94RXlZXUN9qrwvzXbT9ArHolpsp1rM
         OuHz2dBq+xb15a4XK4I9ugB2wyHVcuJ6Bm3zZgVMR368xxlvpAjOaow+ICrsnb/Z0RzT
         fXKet2SWvpu4shrUDs3x0CR7xUbxfhjnPpPoZaGn/L3y0xHOJhrLFOm2ne7AGkJDv0OH
         V93YhO2ah2ElfwS8QTusI6v1ycWWju3yQFGpj0o7OxkCg54sXEn1m0RqBDKit0WZcElF
         eEIGape+JbKHPk/7cvUYG20+4EvkeSm39KTI4z0OVsacIHoG9BhjFidX9apDfTcM1GxY
         HQ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KJuay+IZ+1N+1Y1/y/2UF7sO86HdqKbbyx571Yc0XCk=;
        b=Yg9D9QLsiwbOGoQ5CjZCzhvZkWQkFpWM65Q9kgZgsTffoGXbcjLUdNOyVkmLbmyQFu
         6kKBKHHaTqWcN7SxVIffr4sCHhLEoWhrWFLpxynMDCpRQWVvLs9Pe1U9N7r31sJtLQEG
         uzidYoCImdACytNrY85/C44JJuKRaFTu+sA+33yD3aEL3wNm4c0rIK7SLg/o5EHoww5U
         1PsbiBI5oRvwqIKghruWVyH9+VE9r3BxlaJmS6G+2VRQzEFic4/jgF/NTAcS1XYZZD6q
         8XaRd/TrBrRHA8Q0+zhMguDwO46yB3EBvcQgdLJq3wnMp8d2DDHEBLrT+/Uyi1FLAGq5
         Ht1g==
X-Gm-Message-State: AOAM532tqDED2wnCwfpKr2NuW7m7B1nebDlhFpYUBWvZvLK7+8w3drwh
        8RPeavEthqwq910BkSPdAwQ=
X-Google-Smtp-Source: ABdhPJx84Iq7lvc08dPpwLD5xVytmNOWduKHSiUjv5wiFPO+vrke6nAjIs3OI+4DdWZDjkVMCe/WOQ==
X-Received: by 2002:a17:90a:b28b:: with SMTP id c11mr3955608pjr.62.1614353014614;
        Fri, 26 Feb 2021 07:23:34 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id w17sm7691746pgg.41.2021.02.26.07.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 07:23:33 -0800 (PST)
Date:   Fri, 26 Feb 2021 07:23:31 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Heiko Thiery <heiko.thiery@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 1/1] net: fec: ptp: avoid register access when ipg
 clock is disabled
Message-ID: <20210226152331.GD26140@hoboy.vegasvil.org>
References: <20210225211514.9115-1-heiko.thiery@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225211514.9115-1-heiko.thiery@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 10:15:16PM +0100, Heiko Thiery wrote:
> When accessing the timecounter register on an i.MX8MQ the kernel hangs.
> This is only the case when the interface is down. This can be reproduced
> by reading with 'phc_ctrl eth0 get'.
> 
> Like described in the change in 91c0d987a9788dcc5fe26baafd73bf9242b68900
> the igp clock is disabled when the interface is down and leads to a
> system hang.
> 
> So we check if the ptp clock status before reading the timecounter
> register.
> 
> Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
> ---
> v2:
>  - add mutex (thanks to Richard)
> 
> v3:
> I did a mistake and did not test properly
>  - add parenteses
>  - fix the used variable

Acked-by: Richard Cochran <richardcochran@gmail.com>
