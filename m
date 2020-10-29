Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC0629EEAE
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 15:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgJ2Oqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 10:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgJ2Oqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 10:46:51 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBB0C0613D2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 07:46:49 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id n15so3100770wrq.2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 07:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nQ7clTgWwPd3xxC2NM7XgSgNbPLic4mmtwZKZDvTe/E=;
        b=CkL5JkrUfT7kNZQKF84NiuHkFR2UkOahhRnL8+v3My2qqe9EDhpQaV27la0jPlD3vd
         n9w1FuMAz4Q5v4i/gjo5pLVVqhTgmXtrhKkEab79TJuUmW0E1lX3fswlVZ/yonAo4RG4
         2nU3W1y6ZB0Ra9INrG27mho0FdN3tsOutOzt6Vug/0zMozVO+L3b36M8Kz3+BGLxgJ93
         ytgmlwyJWe53o5s4jFYO1lDhxXsUc7xHzd4fRAG9W+W5SVVWUFUKbs/kQXJ8D39zdAVQ
         cHh7epgv8CIM9WLOm4TLGrL1A6hDaKbuVXLN37hDR6SIXF1Cwk3u7wi++3uC6gmaZQ8M
         hAqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nQ7clTgWwPd3xxC2NM7XgSgNbPLic4mmtwZKZDvTe/E=;
        b=RJBYykfDrHOBeDVi14SnSUJ1h7DiO0pw5mapiJcq38bnkvYsfrAu65lXZrcZYBqL0e
         x9D++d/xtPsRDqrZWZiNECQ9Rrt1Ce986RdrLIuugIv3jlPuvr36MAzcdV3owcgZdPDi
         niFQ9ShSSf9vmNLORmYN2IKPtk/cyFHzcPjC4cWcl//fixIA5CBXxgeJBN9iVHWp/BMG
         lCoFq/Av5rQui0c7EtIEIaCEDHfjWsLlTEOx4+kaQr0PxaB0QFzj0OcW0Nonkp0I+epk
         +at6m8cRUwT4iCN7Ci+esz3XI18jujPWo/ojTuaUdl6dH/hhg5fKdQpULrT8KcZO0VL/
         B9Uw==
X-Gm-Message-State: AOAM530EwJGzWb7lFisRMIZu+XFKiKhPL4G5lQSp628LDhgibFRHFYUl
        LukHa+V9UkTa0lQmm1eeLeWTPA==
X-Google-Smtp-Source: ABdhPJzodEssURVxHjTtWNm/ol+G/tNwSYRO/QqfpNppUtj49ryjLgTtYiDS0juTc+TY1C5bMi65Aw==
X-Received: by 2002:adf:c3c2:: with SMTP id d2mr6272349wrg.191.1603982808276;
        Thu, 29 Oct 2020 07:46:48 -0700 (PDT)
Received: from apalos.home (athedsl-246545.home.otenet.gr. [85.73.10.175])
        by smtp.gmail.com with ESMTPSA id t19sm83525wmj.42.2020.10.29.07.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 07:46:47 -0700 (PDT)
Date:   Thu, 29 Oct 2020 16:46:44 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steve McIntyre <steve@einval.com>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
Message-ID: <20201029144644.GA70799@apalos.home>
References: <20201017230226.GV456889@lunn.ch>
 <CAMj1kXGO=5MsbLYvng4JWdNhJ3Nb0TSFKvnT-ZhjF2xcO9dZaw@mail.gmail.com>
 <CAMj1kXF_mRBnTzee4j7+e9ogKiW=BXQ8-nbgq2wDcw0zaL1d5w@mail.gmail.com>
 <20201018154502.GZ456889@lunn.ch>
 <CAMj1kXGQDeOGj+2+tMnPhjoPJRX+eTh8-94yaH_bGwDATL7pkg@mail.gmail.com>
 <20201025142856.GC792004@lunn.ch>
 <CAMj1kXEM6a9wZKqqLjVACa+SHkdd0L6rRNcZCNjNNsmC-QxoxA@mail.gmail.com>
 <20201025144258.GE792004@lunn.ch>
 <20201029142100.GA70245@apalos.home>
 <20201029143934.GO878328@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029143934.GO878328@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 03:39:34PM +0100, Andrew Lunn wrote:
> > What about reverting the realtek PHY commit from stable?
> > As Ard said it doesn't really fix anything (usage wise) and causes a bunch of
> > problems.
> > 
> > If I understand correctly we have 3 options:
> > 1. 'Hack' the  drivers in stable to fix it (and most of those hacks will take 
> >    a long time to remove)
> > 2. Update DTE of all affected devices, backport it to stable and force users to
> > update
> > 3. Revert the PHY commit
> > 
> > imho [3] is the least painful solution.
> 
> The PHY commit is correct, in that it fixes a bug. So i don't want to
> remove it.

Yea I meant revert the commit from were ever it was backported, not on current 
upstream. I agree it's correct from a coding point of view, but it never 
actually fixes anything functionality wise of the affected platforms. 
On the contrary, it breaks platforms without warning.

> 
> Backporting it to stable is what is causing most of the issues today,
> combined with a number of broken DT descriptions. So i would be happy
> for stable to get a patch which looks at the strapping, sees ID is
> enabled via strapping, warns the DT blob is FUBAR, and then ignores
> the requested PHY-mode. That gives developers time to fix their broken
> DT.

(Ard replied on this while I was typing)

> 
> 	  Andrew

Cheers
/Ilias
