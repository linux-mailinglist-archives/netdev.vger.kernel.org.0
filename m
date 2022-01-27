Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2AFA49E5F7
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236764AbiA0PZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbiA0PZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 10:25:03 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D19C061714;
        Thu, 27 Jan 2022 07:25:03 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id k17so2844843plk.0;
        Thu, 27 Jan 2022 07:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TcINCPBvZZnIlb1v0W7FD1yLYZgGIWjtm+qYyk+jHvI=;
        b=ORft9sssfk3gpt0aJHQNKhO+McSeQZT9T8IAhHmdu9D0mOUyvP+DG5Ip01Q89mvvPK
         GUQ7SZaSWJI7QWnuq/iWdh+DPCxphwdVxk49sU5Nv6fxuXWWYzoxUjoUoskeGQEbmNfY
         oQyxk5Qe2JIOgnniqRSf+aKFFceNjfOXwOzHGkJsKIRbnp3sMmlDfb9pyWaUmbI25HRV
         +8H2IRMBK2H6KXhdCGZKh15DZyiyPOTHxFLtC1b6H3ln6+z3i5vNN4Yg+fkzDGnV/D1l
         jwtKntQ8T1LUZvV37aTjVXVucTwzTPjiIrwWdwW7qF7r3q9EviY/xo0FrSNQ9FzThvtO
         WWdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TcINCPBvZZnIlb1v0W7FD1yLYZgGIWjtm+qYyk+jHvI=;
        b=0AAQ9jx2+uvtaXCk0brETevhBNnWkRos4vX6xAbLD+wKTpAQ1xJg02wnKGvUPfYCuJ
         hfSAmEHf1Ol1fvQuyfzvgfgzOzf4KdpZMJCpFXVFX/dyCIlMQxmY7X/pqXNRcrMcOYza
         FkwCbisptFsyrmLLr57UFOWoBzXET0Y9/xyyA58ivaHZt7MMy5qE4KujgDvTcvxRjITk
         Qk0ulAiF0mrx2/yhEtga9XkQ00To7fppGCdnb7PFURjTRw89JiBDIwqATXkQJe4I7CGT
         KLArStyOQwulhh4lTmU3UXTnka3w77MY6dgo7UQKT4JupvIj/delYnLdloebsMsAJyMC
         KSmg==
X-Gm-Message-State: AOAM531of5gz1QtNnk+h9ktNXYxqdOFQ4v2ud0CXi94n9w2NfKKGGsj8
        NXAV8jXvtJn6eNnGRGZ48LrkTMD0IQw=
X-Google-Smtp-Source: ABdhPJxdE08zr7LyZr3heg8HkuCZ2fWxrYT6uqVsdRM1xa1L+/v0fxIjbf2x2XZvoUAZ8t44BUVPsA==
X-Received: by 2002:a17:902:dacf:: with SMTP id q15mr3712540plx.76.1643297102871;
        Thu, 27 Jan 2022 07:25:02 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id mr21sm3158355pjb.12.2022.01.27.07.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 07:25:02 -0800 (PST)
Date:   Thu, 27 Jan 2022 07:25:00 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, vladimir.oltean@nxp.com, andrew@lunn.ch
Subject: Re: [PATCH net-next 3/7] net: lan966x: Add support for ptp clocks
Message-ID: <20220127152500.GB20642@hoboy.vegasvil.org>
References: <20220127102333.987195-1-horatiu.vultur@microchip.com>
 <20220127102333.987195-4-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127102333.987195-4-horatiu.vultur@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 11:23:29AM +0100, Horatiu Vultur wrote:
> The lan966x has 3 PHC. Enable each of them, for now all the
> timestamping is happening on the first PHC.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
