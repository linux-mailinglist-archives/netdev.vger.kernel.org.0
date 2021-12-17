Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69734789B5
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 12:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbhLQLV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 06:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235133AbhLQLV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 06:21:57 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA39C06173F
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 03:21:56 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id n14-20020a7bcbce000000b00332f4abf43fso2616094wmi.0
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 03:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=b7wCHOvs45jhnC7XuyqmlLe/ZuZPVp+HAfTPI5Xa2rc=;
        b=IbGU0gXI3aj7M7rsWXaz58qc6sm5aCK8trwuh7TiyxQ05QF2Ev6sza9b8Cj1+fbjFw
         T1el7Hw5I/roOh8tCcK/IFLPsfPHyDstzzcGCo1uunaMyBktXw1wtZVPi/+vuwR5l5vO
         UaEl6idd2XIcfGLv1IlrUKn/Ai/TiMXHYFqwZ7mm6MsZFwKDsWlecYwwW5+ZZZMo92Lm
         bitqJcDRSEjY0Fj6kKk6yZEb9zEwGM52vHQ5bzlYRAOX75ur5zfEuqCro4tzyH1jEpY4
         jpAjeHUCzuNQXqwSrh0oPU0aBAd20bCxHT6MDs8jJWgmbMUimPl0Hle1Vzdst63QbdlQ
         TRUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=b7wCHOvs45jhnC7XuyqmlLe/ZuZPVp+HAfTPI5Xa2rc=;
        b=qprNI85Au+SdKXdItI7EsweN5J/jvcvbzo5OrnYGDEid0adF5x/lqAV6NaaNuOWp9z
         Ot62THiOcFGTI6Lxe4VBmeIAeh1KZnFIhoLyocYRxpB1jhngreDcbFhZRyiL9QhXqXab
         TgIGj2gkH/9bczH/FYY8ghpY/PRsOZTwGBinUTf5DQJTjKsjj4pRJb9+YE/kWfVi15tT
         PSMd3lV8u2RygwhIu5kGKbPIy8P1YHs8QWFinKrtmtJVT5iGxQONQ+ACSQOZ7+cA780e
         fYSQgmPLqT366j3z5RNLyqmKGYfs63yW+I9OiQwhtKGOm5DgCWzJCLAMAOBas9iFg56R
         smWQ==
X-Gm-Message-State: AOAM530I9NTF0wLWTsVvlRp+nB/GovMRZr6oxQrFstm2YN+W7duN4XWi
        WaeFd5/r1O6cX/UOc0xUTf1KUQ==
X-Google-Smtp-Source: ABdhPJyJc7u+feUS+x+soNm2i/bRHMLVWEnj454hUUTmnY+fjIXlM4qlznKBeLrAeEMn4fHfKRhvHQ==
X-Received: by 2002:a7b:c452:: with SMTP id l18mr2318480wmi.46.1639740115302;
        Fri, 17 Dec 2021 03:21:55 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id g3sm3725926wrp.79.2021.12.17.03.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 03:21:54 -0800 (PST)
Date:   Fri, 17 Dec 2021 11:21:52 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Xin Long <lucien.xin@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>,
        Karl Knutson <karl@athena.chicago.il.us>,
        Jon Grimm <jgrimm@us.ibm.com>,
        Xingang Guo <xingang.guo@intel.com>,
        Hui Huang <hui.huang@nokia.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Daisy Chang <daisyc@us.ibm.com>,
        Ryan Layer <rmlayer@us.ibm.com>,
        Kevin Gao <kevin.gao@intel.com>,
        network dev <netdev@vger.kernel.org>
Subject: Re: [RESEND 2/2] sctp: hold cached endpoints to prevent possible UAF
Message-ID: <Ybxy0HU5yfKm5sVF@google.com>
References: <20211214215732.1507504-1-lee.jones@linaro.org>
 <20211214215732.1507504-2-lee.jones@linaro.org>
 <20211215174818.65f3af5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADvbK_emZsHVsBvNFk9B5kCZjmAQkMBAx1MtwusDJ-+vt0ukPA@mail.gmail.com>
 <Ybtrs56tSBbmyt5c@google.com>
 <20211216124430.142a013c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211216124430.142a013c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021, Jakub Kicinski wrote:

> On Thu, 16 Dec 2021 16:39:15 +0000 Lee Jones wrote:
> > > > You should squash the two patches together.  
> > 
> > I generally like patches to encapsulate functional changes.
> > 
> > This one depends on the other, but they are not functionally related.
> > 
> > You're the boss though - I'll squash them if you insist.
> 
> Yes, please squash them.

I'm just about to make some changes to the patches.

Specifically, I'm going to make sctp_endpoint_hold() return the
endpoint it incremented, in order to prevent schedule related data
corruption before/after the increment of refcnt.

I'm going to keep the patches separate for the time being (since I'm
going to submit this before you get out of bed most likely).  Just let
me know if you still want them squashed, even with these additional
changes (along with their explanation in the commit message), or feel
free to squash them yourself if you choose to merge them.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
