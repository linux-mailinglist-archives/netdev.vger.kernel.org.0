Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEEB43C418C
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 05:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhGLDTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 23:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbhGLDTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 23:19:41 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA63C0613E5
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 20:16:53 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id cu14so3997710pjb.0
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 20:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tjGfKy7pAMTrksPVIsaESLHvNOPFDpSHSrgDwL+6kfY=;
        b=nOmWcB1+Jn73zGwTLM9AZT86Gik0kd6HUGGbBpV4dzwPlKz8xtCNYQX9CDKXYtoSYg
         9wlJiUU6hi91TA97YVXqfAh14Pq3nfYqPe8f9GsmOz4KDHugo2iCOurfIkVHZsejm8X5
         GGGv03oejeaEHZGFQmH7m/8dgmrwMhaclh4nAQjAp7H/Q2C9nAeIdj97iq7WWY1EWXYc
         VtmVOOlNE5vS4hyM23pmXakUJnvUG2uti/FYSLbRjPrRH3KrfzAJ9e6xvtxlCnl6Bmya
         K5qnDgdV86GKh2dtf/OUr13cX0HeOnlL+y8WE7Ha+k8AXVRr9FkVeQsojIfSoZhqXhb7
         F1+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tjGfKy7pAMTrksPVIsaESLHvNOPFDpSHSrgDwL+6kfY=;
        b=LyRekOk8g5BgvNDEBwX74wNui+TtBFJ/qLPzChghdnKaXuGmNNXzYvKbE95PpBNUYE
         ya+lxqcK51+DaOCr9ZT3aXUnduoZbXyHnLuBitO9DGl+93ICfvme0O1k+mR1MjvEfrHH
         xjDyn6uV/2WFulV8XW96/huRnL3kno23PLZVOo26jcF8Iy7bTkAK7/PlC9SL41tP3p2F
         jPeMhrZ4Ke7mMdB/g/TslJ9vQ6vKpgJxw83bjQYuWdrUPqPurg211lkMgQJUVMw8zimd
         ZiwYYw47MEOrsCaHZ+suHXP5LVhPklhUQYIKF+ozUGGSTmc9FnufrbXqcxTzrY4uYQVE
         kFAw==
X-Gm-Message-State: AOAM531HDhmQSH+HXFLqZTpfuJZZiLK+qfgaVj/VVCntwNwLCMmt9y7D
        uBlZx2oifk0lQgOxU0ESqRA=
X-Google-Smtp-Source: ABdhPJyQF+mjp3wb1q0svyzKPVpfVG9yUTPMoGpIFT2y63zSOvCP0ovWTK/nQkogzTbu5jR8Q1ZiXA==
X-Received: by 2002:a17:90a:a107:: with SMTP id s7mr11971151pjp.1.1626059813315;
        Sun, 11 Jul 2021 20:16:53 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id y10sm11706705pjy.18.2021.07.11.20.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 20:16:52 -0700 (PDT)
Date:   Sun, 11 Jul 2021 20:16:50 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     dariobin@libero.it, davem@davemloft.net, kernel-team@fb.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] ptp: Relocate lookup cookie to correct block.
Message-ID: <20210712031650.GA13283@hoboy.vegasvil.org>
References: <20210708180408.3930614-1-jonathan.lemon@gmail.com>
 <691638583.174057.1625922797445@mail1.libero.it>
 <20210710165630.kfuo6ffgi7es37zy@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710165630.kfuo6ffgi7es37zy@bsd-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 09:56:30AM -0700, Jonathan Lemon wrote:
> On Sat, Jul 10, 2021 at 03:13:17PM +0200, dariobin@libero.it wrote:
> > Hi Jonathan,
> > IMHO it is unfair that I am not the commit author of this patch.
> 
> Richard alerted me to the error, and I sent a fix on July 6th when
> I came back from vacation.  I saw your fix go by 2 days later - which
> was also for net-next, and tossed as well.

Vladimir Oltean found the bug (too).  He deserves credit for that!

Thanks,
Richard
