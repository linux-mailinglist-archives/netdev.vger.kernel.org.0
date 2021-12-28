Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB6C480B07
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 17:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbhL1QAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 11:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbhL1QAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 11:00:54 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF70FC061574
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 08:00:53 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so21971944pjj.2
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 08:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+EErxxyRGrc3fIcdCuA+M5TmuzvvFgyPQfNF+QKyEJA=;
        b=bypY8ngWBwcgkxdKMtgGYXT7/IQ6MPDnRPU3k2FPRYMvuHE/T/g5/vqEKlXAXxqXhl
         CwA9Iwd8GXMX2X0JZhYtE+1Y/Me3/NA2GV90YN5+YqRbLO2Rl0YcPw9VCnt5Ne1pQwDK
         hmK6xGdHcm8GAP48+QR8jfwsiE+9Nt6Xl9W9OSW30xr6eGd0xko4p+5vB0vRNZ/BEBB2
         zGWXR+bzk7zsX7hEyjVdu/UP3H0gBsol7Lnry3o7obAQLrRQ24msI/SrONpBbbo+0NQv
         ZeyU591cQeTIbxx6UjOMnsij0HE/RtkBTCKJ0BvizDDNPhXTkcykHr6hlmVQACArUL+n
         vB2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+EErxxyRGrc3fIcdCuA+M5TmuzvvFgyPQfNF+QKyEJA=;
        b=alT0XVjXdezbLe+zjLYIIXNkywp1PAjOhhvtdGRPHvhmTqabvGUR4oVpXlMoNvfOmN
         rBi1y1ARXYYIUQpKTt/FAAcIUqqgHzixg7nkzOIV5Ax6uSARLa2lDwwCOAhkcJMJ/dWD
         y1UWTCopTn/lE2wVr5Bp8JF6aUR8pdvRLPVpMLnCwXrtBhn2TPFlGcYySxqLqTrJUtc9
         pbz8G64UNL3nqSOT7TS0UWmg05KIzzDOCNeFFvuYdV6k9U2ZN7+jg7dbCIb/PJvDi8tT
         YligklkRLECNgg5CcyGGo+sSVV+1OiBT+LEmx4Df2rrzx/SrvNLUd7Z5xO/WDp74jiVA
         WsqQ==
X-Gm-Message-State: AOAM532XvXa631+WlAzR3e21bGT51WoS3ccnqJYrBqkFzg8RsRNLE9pV
        qpvSvwiGzM96nsFMWWgth7A=
X-Google-Smtp-Source: ABdhPJyaFLrmxEzAEEKLqm3HuivOclWe8MAdl09XDL5dvVerhd+Ai2TOUa9lkRYCrYG57TikhPDU2g==
X-Received: by 2002:a17:902:bb8c:b0:149:8f60:a526 with SMTP id m12-20020a170902bb8c00b001498f60a526mr4786862pls.25.1640707253239;
        Tue, 28 Dec 2021 08:00:53 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id y8sm22980755pjt.25.2021.12.28.08.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 08:00:52 -0800 (PST)
Date:   Tue, 28 Dec 2021 08:00:50 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCHv3 net-next 1/2] net_tstamp: add new flag
 HWTSTAMP_FLAG_BONDED_PHC_INDEX
Message-ID: <20211228160050.GA13274@hoboy.vegasvil.org>
References: <20211210085959.2023644-1-liuhangbin@gmail.com>
 <20211210085959.2023644-2-liuhangbin@gmail.com>
 <Ycq2Ofad9UHur0qE@Laptop-X1>
 <20211228071528.040fd3e3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211228071528.040fd3e3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 28, 2021 at 07:15:28AM -0800, Jakub Kicinski wrote:
> On Tue, 28 Dec 2021 15:01:13 +0800 Hangbin Liu wrote:
> > When implement the user space support for this feature. I realized that
> > we can't use the new flag directly as the user space tool needs to have
> > backward compatibility. Because run the new tool with this flag enabled
> > on old kernel will get -EINVAL error. And we also could not use #ifdef
> > directly as HWTSTAMP_FLAG_BONDED_PHC_INDEX is a enum.
> > 
> > Do you think if we could add a #define in linux/net_tstamp.h like
> > 
> > #define HWTSTAMP_FLAGS_SUPPORT 1
> > 
> > So that the user space tool could use it like
> > 
> > #ifdef HWTSTAMP_FLAGS_SUPPORT
> >        cfg->flags = HWTSTAMP_FLAG_BONDED_PHC_INDEX;
> > #endif
> 
> We could set it on SIOCGHWTSTAMP to let user space know that it's
> necessary for a given netdev.

What about adding matching #defines into the enum declaration?

enum hwtstamp_flags {
	HWTSTAMP_FLAG_BONDED_PHC_INDEX = (1<<0),
#define HWTSTAMP_FLAG_BONDED_PHC_INDEX (1<<0)
};

IIRC I have seen this pattern used in the kernel, but ATM I can't find any example :(

Thanks,
Richard
