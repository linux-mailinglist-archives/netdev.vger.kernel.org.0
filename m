Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7830214E82E
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 06:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgAaFRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 00:17:39 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40389 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgAaFRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 00:17:39 -0500
Received: by mail-pl1-f194.google.com with SMTP id y1so2244788plp.7;
        Thu, 30 Jan 2020 21:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cuvjx7AIX7khPCGW/ptRVwlIZDS34QDntRrzehyOm+c=;
        b=JPSyKWy9qHkV8mRn/mKXpRX9fPNxeWAUkeyQUljqrmFMNMBVGYH0mDwyBiw3JYEuaf
         BxUW1ysmpenEAHtUlwB68rNF9Ot8Ry1QnWaeCvPbxjP8mjePW3k4kILGWxfumjbKlAvy
         1FdcsoN9A+8e7JfZYF0Oc38aeu/d7hE2CMSNMVq+4adzzynRfXCylN8QELeE8p6gJbti
         NcAx+aL2IV41q9M2B8QlEpfdRVOhHFnB9/kyAP2mRGpb7vgIgqrcGus109XLVKFvqDRU
         IwYh2t/98I1I6e21Ka/hOxWMjhBgY3A5N9kZlduKMoWuRjjEQ04j5bIDMtzx0YtWA0dD
         oLog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cuvjx7AIX7khPCGW/ptRVwlIZDS34QDntRrzehyOm+c=;
        b=Zget1uQmnYv2fEhvqMh2Rvc3PnA8055H68l6c7tjxySOByXC+0GumHi+J2rtmRWrS1
         Ov0svHJQT4wDm9AwgDOwTlZTyN1ziCKEEghmnwj7G1L4BY73lzk5yI5KGtICV+MOf+1p
         WNEK/uvzOqNPxSjvlo09M6wEL59gN1XDt968RtbD8nkN0+Gk75J1p0UxDzf+z9djNY0y
         Q5v9QUe7z9ZL/bZSF+zaMjnrlgVOI0r/jIM4DE/EqMpDCVIOuuB0qQjM414qqmbIkypV
         Ai+dhS2cMu7gh6UuvU4WmQFOa0QOusU05e48FQDX5WEMmCfurYagOhvPSEBlP4kBeF2Z
         H1hA==
X-Gm-Message-State: APjAAAXKUmZKjXXZnU0Ct+5v8UCbTAOByih7e/CWeHzlZezPPk/Oe8Ot
        0cniIBbGfIIDmWSinbE31pM=
X-Google-Smtp-Source: APXvYqxM/tb3AZ/vDuSE3psHOgDMaAK027AaKFytF2+aRK1w+U0tH98RUMlTAQ3OYJeKfgs6KeoB1A==
X-Received: by 2002:a17:902:5a85:: with SMTP id r5mr8614531pli.222.1580447857238;
        Thu, 30 Jan 2020 21:17:37 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id q21sm8902132pfn.123.2020.01.30.21.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2020 21:17:36 -0800 (PST)
Date:   Thu, 30 Jan 2020 21:17:34 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 1/2] net: mdio: of: fix potential NULL pointer
 derefernce
Message-ID: <20200131051734.GA1398@localhost>
References: <20200130174451.17951-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130174451.17951-1-michael@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 06:44:50PM +0100, Michael Walle wrote:
> of_find_mii_timestamper() returns NULL if no timestamper is found.
> Therefore, guard the unregister_mii_timestamper() calls.
> 
> Fixes: 1dca22b18421 ("net: mdio: of: Register discovered MII time stampers.")
> Signed-off-by: Michael Walle <michael@walle.cc>

Good catch.

Acked-by: Richard Cochran <richardcochran@gmail.com>
