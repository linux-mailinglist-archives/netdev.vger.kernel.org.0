Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4203FD199
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 04:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241740AbhIAC56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 22:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241485AbhIAC55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 22:57:57 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5042C061575;
        Tue, 31 Aug 2021 19:57:01 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id u6so959893pfi.0;
        Tue, 31 Aug 2021 19:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u7p4mg6NKghg3cKJ3dCfxdhdxCfpMBcRYX0ibCXG1nM=;
        b=r7+5i8DLfKV2FWLzr1+P1diMy+R2Fk6PjZJ98fe4q9BMMgMmYbOQCNZqdQvxYNrvBe
         XLWnyNAM2hcSh27DL9fQjXFk6Cmx4228sOwf4Ng7S6HQxALmQL6E3WIfiyIm9u9UnzS0
         lhsSdgVuhxea2vvw7EDRbBebJKmY0Hr9LQ4IoXaOJrqn+BjUqvXLD+q6IF/8aJO4UgqO
         J8NXIsTy9EOO4gMvs99q91vN5smGqCa9eyDkS/ijs3MeLWBrvYufQPxynJFmrmHtI0S6
         PRQSLjy+41+rPnBy8MOG0i6CH7oAb+uftz8rQsUkSaf8hDA3VEq6Czv2H29lN353QAxK
         IJbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=u7p4mg6NKghg3cKJ3dCfxdhdxCfpMBcRYX0ibCXG1nM=;
        b=IW7M93pA4kHOmDDb464OfvjVnDOLF28TEUOokBfWIcmVGL7RqEIkz9shg3y/rpVmil
         /spGAHLf04wLjU2kUY1DKCULKmGHUkVm3d+vdZ1IxrHMY5yeog61GKBx4aHiQ1CrgfgN
         96oN4L5D6beg9C3WCLA92aVH7Wa3JtZf+1qqo6BeKTfSAeLLvDqB1I/gjqrVj/0SU8bX
         pO9g3bFor8j++o8gjcv6g/RTnCBz/JnM3tBjM1L132aqwaEWpJvgylodiZk0C6UotXPO
         P0SJByFlno8WO192c+Wc/RiK88xPPPVyNWQPNX3fXIURD7c30hLtYDwX6WBvtZUFafYF
         qkUg==
X-Gm-Message-State: AOAM533spCLgKD0OCMPGWEKMm2+K+RvvH13acAgz0rzv7TV6tsgqB9dY
        RyG4WX8i1p16mbvenRu30Qc=
X-Google-Smtp-Source: ABdhPJytdnYXQQqln+Cx1IlJxVik860QOtkbaKurvcvvMZVEkx9r1BgLQG5hiaa9ZGc8Iki5IhRY5g==
X-Received: by 2002:a65:62c1:: with SMTP id m1mr30109534pgv.339.1630465021367;
        Tue, 31 Aug 2021 19:57:01 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 141sm22312568pgg.16.2021.08.31.19.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 19:57:00 -0700 (PDT)
Date:   Tue, 31 Aug 2021 19:56:58 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "bsd@fb.com" <bsd@fb.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
 message to get SyncE status
Message-ID: <20210901025658.GB18779@hoboy.vegasvil.org>
References: <20210829080512.3573627-1-maciej.machnikowski@intel.com>
 <20210829080512.3573627-2-maciej.machnikowski@intel.com>
 <20210829151017.GA6016@hoboy.vegasvil.org>
 <PH0PR11MB495126A63998DABA5B5DE184EACA9@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210830205758.GA26230@hoboy.vegasvil.org>
 <20210830162909.110753ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210831161927.GA10747@hoboy.vegasvil.org>
 <SJ0PR11MB4958D55CB9EDD459AF076525EACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
 <20210831190235.00fa780b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210831190235.00fa780b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 07:02:35PM -0700, Jakub Kicinski wrote:
> On Tue, 31 Aug 2021 22:09:18 +0000 Machnikowski, Maciej wrote:
> > OK I can strip down the RTNL EEC state interface to only report 
> > the state without any extras, like pin. Next step would be to add 
> > the control over recovered clock also to the netdev subsystem.
> > 
> > The EEC state read is needed for recovered/source clock validation
> > and that's why I think it belongs to the RTNL part as it gates the QL
> > for each port.
> 
> If you mean just reporting state and have a syncE on/off without any
> option for other sources that's fine by me.

Yeah, that is what I also imagined for a generic SyncE interface.

Thanks,
Richard
