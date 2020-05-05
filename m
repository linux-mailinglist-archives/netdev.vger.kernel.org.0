Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593081C4E7B
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 08:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgEEGuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 02:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725320AbgEEGuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 02:50:05 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7572C061A0F;
        Mon,  4 May 2020 23:50:05 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id u22so398508plq.12;
        Mon, 04 May 2020 23:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0aXe94VU2WISTIlufs3bfltwqE1JuV8SHwsemLcdlPY=;
        b=VUb2ebxOqBa2eX4HEwAC4TSnsr/67cFpLtQ50LMIHcpva39QnEzqr3yXtnu7GqNhLy
         GiYXsq6zUdUoFWZ2h7UJ3R/DiNoyvrfOrfxftC5aatZu2vlRb2Yft3CRkqMTmyTYE5lK
         teCTSmflsWScuw39WtRUWBqMXzzLLUfoROuZkcafhKA7tXysUa1wAyk6joVC1rOxmagY
         tpETTtS/+i/Ll1BapImmBp5CymTjHToomA4PbsA9FXr9BcSBBqGcSxmHwmHZBidA7C25
         M+zICsV0+WdGLyfL6k1w49IBwFxM0DCbgmkHkZ5Eh+r/Sk/zsAKjgDeefng+1NSBEBxb
         pKCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0aXe94VU2WISTIlufs3bfltwqE1JuV8SHwsemLcdlPY=;
        b=lQ2c1V9qHEe+CH/NCdExqb7z3VbhPOsowSF8VqZpOAtVlml7HzsM+xALMKgl5yDVeP
         EvoOiPY7l9VqFO4D+HZrRIT3C0j88L3Kd+2f9IKvVo5Sy1bU3cwAfpBIHJYGLf4KJEyA
         U4cnN4gpGFKrS18YJAYb+2iJjEg7GQOwRpRFBjneo7vRpwVachhoJCqsP3KBrYeTjoVY
         +GC5snmj/kMPiLS7RaZggH+s/PuA+juUsKkEGUPBDIJWlNimB5Hxt1tcoRG/y9c2enlL
         z+8dxOmXewCF8hyF6wi8LORgt2QHvUY6H0/NLYwMdhaq5/0GwfbVZbppTLvSIVdOxpsg
         eOFw==
X-Gm-Message-State: AGi0PuZPgjhulvIKVj8ZAXCdXT/H4KH4/fvFXoyy2k9TKXj1WJizC9Qr
        6lUmG7ZcS+8Ozl9hNtDDKKg=
X-Google-Smtp-Source: APiQypI3URDDfdNNVIPkHt00KJRYSHOJH+UmM+3WQVkcv4oKDPy1TMORpL06DWRPurmnD5TWKsN1Nw==
X-Received: by 2002:a17:902:a701:: with SMTP id w1mr1333852plq.165.1588661405149;
        Mon, 04 May 2020 23:50:05 -0700 (PDT)
Received: from localhost ([162.211.220.152])
        by smtp.gmail.com with ESMTPSA id z7sm1036273pff.47.2020.05.04.23.50.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 May 2020 23:50:04 -0700 (PDT)
Date:   Tue, 5 May 2020 14:49:58 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, swboyd@chromium.org, ynezz@true.cz,
        netdev@vger.kernel.org, jonathan.richardson@broadcom.com,
        linux-kernel@vger.kernel.org,
        Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>
Subject: Re: [PATCH net v1] net: broadcom: fix a mistake about ioremap
 resource
Message-ID: <20200505064958.GA1357@nuc8i5>
References: <20200505020329.31638-1-zhengdejin5@gmail.com>
 <8b71b3ba-edc8-ce78-27ba-ce05230efc31@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b71b3ba-edc8-ce78-27ba-ce05230efc31@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 08:28:52PM -0700, Florian Fainelli wrote:
> 
> 
> On 5/4/2020 7:03 PM, Dejin Zheng wrote:
> > Commit d7a5502b0bb8b ("net: broadcom: convert to
> > devm_platform_ioremap_resource_byname()") will broke this driver.
> > idm_base and nicpm_base were optional, after this change, they are
> > mandatory. it will probe fails with -22 when the dtb doesn't have them
> > defined. so revert part of this commit and make idm_base and nicpm_base
> > as optional.
> > 
> > Fixes: d7a5502b0bb8bde ("net: broadcom: convert to devm_platform_ioremap_resource_byname()")
> > Reported-by: Jonathan Richardson <jonathan.richardson@broadcom.com>
> > Cc: Scott Branden <scott.branden@broadcom.com>
> > Cc: Ray Jui <ray.jui@broadcom.com>
> > Cc: Florian Fainelli <f.fainelli@gmail.com>
> > Cc: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> 
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Florian, Thank you very much for helping me as always!

BR,
Dejin

> -- 
> Florian
