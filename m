Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776461D4226
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 02:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgEOAhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 20:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727123AbgEOAhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 20:37:09 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441C4C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 17:37:09 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id g11so240621plp.1
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 17:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Zi1TgPTXqz8ohJMTbr08wXLnlhUdD2TTrRYLy0+pQ+k=;
        b=MdOpVAcaCaVbGQOwnYvwZ33NYpEpo1bQx6LUhjc1MwtR2m8S9sP9GqFojIKCR3JRnY
         siUiGpvigbx63XIkI4GHv3VbQiOp/ZNYnjTNXOskpwaaz67efBu9uVtA/5wrq2C6lpr7
         RB1U09ed98Pu2Z5RO7hmEWtBcfLcV9/Q7mkrhMdPIgwXGhToNudYMB9R8EQ8JubpAW4F
         GSnxcVoynD8ERRKR+cSx4/wz1NqwYCVTC9enRuN/A29KegXicpUi9Cjfx3LUQ8Dy0plq
         u0wMMJbRpaUMjLvrd41YB4n/gawOteDcAFWCrpsZN6HPsit9UvgDdlfCZdPszNpEiopD
         RVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Zi1TgPTXqz8ohJMTbr08wXLnlhUdD2TTrRYLy0+pQ+k=;
        b=Yvzn8uHbCKAVuHvn0FH/nwucelAS3Db+MjObCLUds1dkSQk08SwKNiMveX9rNtRnkL
         sEtI5hZBcIAjbsQt5ltikLhbEuJd7GsrzqJyeLYRi7BrJcGmaLgVxoFspoo4KawSZkHG
         lfcqw8CUYy3S8bzQlSRKtZ8TX5oUyBadG9hwmtpNk3wBTrEPzz6am60DCtSoCfUA0CGL
         O75B9hoRvOQZD5UKuIsocyGtMNmFmb+X0NUGcisTb/MQYhl2i+exxtxBSVeJdacpRtGN
         8kxQrjqvCAJGPBmulXXACb1+fOu4qM9YhkxErl5St6Unj8l81+eawolgbLkO8eFotTUb
         oZFA==
X-Gm-Message-State: AOAM531SJsl133Lkz3DABkYFYP5aYWqcLwH02FW8Gqap/wAmawOYQ1Mw
        X3fp4hfVsCtMfa4bU7m+heLGqSURsFs=
X-Google-Smtp-Source: ABdhPJwIM44w6or14/H030e8LrraaXpX6nJAjlIZ4m4Kc+ym/BJAePrlmeq+Tk3dstLXAMw730uc2g==
X-Received: by 2002:a17:90a:7e4:: with SMTP id m91mr627989pjm.155.1589503028773;
        Thu, 14 May 2020 17:37:08 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 16sm163111pjg.56.2020.05.14.17.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 17:37:08 -0700 (PDT)
Date:   Thu, 14 May 2020 17:37:06 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Olivier Dautricourt <olivier.dautricourt@orolia.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] Patch series for a PTP Grandmaster use case using
 stmmac/gmac3 ptp clock
Message-ID: <20200515003706.GB18192@localhost>
References: <20200514102808.31163-1-olivier.dautricourt@orolia.com>
 <20200514135325.GB18838@localhost>
 <20200514150900.GA12924@orolia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514150900.GA12924@orolia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 05:09:01PM +0200, Olivier Dautricourt wrote:
>   My issue is that the default behavior of the stmmac driver is to
>   set the mac into fine mode which implies to continuously do frequency
>   adjustment, So if i'm not mistaken using the nullf servo will not address
>   that issue even if we are not doing explicit clock_adjtime syscalls.

Why not use the external time stamps from your GPS to do one of the
following?

A) Feed them into a user space PI controller and do frequency
   correction, or

B) Feed the offsets into the hardware PLL (if that is present) using
   the new PHC ADJ_OFFSET support (found in net-next).

I don't see a need for changing any kernel interfaces at all.  If you
think there is such a need, then you will have to make some kind of
argument or justification for it.

BTW, support for B has been implemented in linuxptp, and the patches
will appear soon.  We can also add it into the ts2phc program if you
like.

Thanks,
Richard
