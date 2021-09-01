Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4493FD193
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 04:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241743AbhIAC4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 22:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241726AbhIAC4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 22:56:50 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E627C061760;
        Tue, 31 Aug 2021 19:55:53 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id y23so1280882pgi.7;
        Tue, 31 Aug 2021 19:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=llYzk35WFyxnRcjOXeC5MzMhaQqeb3RL9qYQToUkrs0=;
        b=SsmztjF2i/COYT4VHYxIR+YJQvaMtkZoolQUhKhvfZWN/N742VdpBU2GAqXBuV+2p6
         RIAfyoRG+c7L0l80SoC8AbM/WnuwgZULZHEBIeFjbD2KfVz/VPy+WSOPnPllYJYktKlL
         tANR0DEc1hSydMuusQaLiyZ2tcVFGKjkSMGPqOFUkYTQYqGYZk0aAF+0pzD+9x55AgkW
         Gbn27SRgCN5zPd2jyQVz+M7No2QA9fwOHNSVaVmTSWgfeWmZbHCSBx+PBVt6G7X0AtBn
         HrzvFMWia+V3RJHm2XlpJXKGi7CgSZV5o+IN9CzjYnMy87cWRFB5cPUuKpQlPPHu0eeU
         9IfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=llYzk35WFyxnRcjOXeC5MzMhaQqeb3RL9qYQToUkrs0=;
        b=cBNnqsuGmfnDZxLbt4NdvnbBf/dKsPdHgRJ/pISrx+h8ZerVl0Hpce9IOz/xT35dVU
         ZFG8en6btxM10TIhIJgQhF6y4tbY7hZ+vbKa0TSv8CWdWM7XWYjdnZcXONmtjyE+Eccf
         ZuiAIlOuEqUCVhlcZ5SbAMIqqleHZbjmNoO76QovRIMagE2ltZlzOEuZBwbyDPpSLGkL
         o0Yduo8bzC7a4BaRw6dxaZhMpZzndai0HmLXSBukVjbU+CaiLysWd+c2DgahRHaG/X7O
         X0t+IOXH7YuQegi0Wd0HcOIZ0yjdvMKEbdKCO+lZiM5To/kmkzo90PbFOxPPz1iel+/3
         G7OQ==
X-Gm-Message-State: AOAM531uHa0zrlKjyc0rqwNobopXU6MICrUHt45tH8C1+geTft9v73Lz
        zF3XoCeOI/a2nmAeoRNUWF8=
X-Google-Smtp-Source: ABdhPJxDlMgVj2bC6+E8FbE6iG2xUI6Pu+alYjfUIGR3u/dlTOt3UugeGOoDufPaWfdvHnkWCWH/YQ==
X-Received: by 2002:a63:1025:: with SMTP id f37mr22108960pgl.116.1630464952974;
        Tue, 31 Aug 2021 19:55:52 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 126sm1042362pgi.86.2021.08.31.19.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 19:55:52 -0700 (PDT)
Date:   Tue, 31 Aug 2021 19:55:49 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        bsd@fb.com
Subject: Re: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
 message to get SyncE status
Message-ID: <20210901025549.GA18779@hoboy.vegasvil.org>
References: <20210829080512.3573627-1-maciej.machnikowski@intel.com>
 <20210829080512.3573627-2-maciej.machnikowski@intel.com>
 <20210829151017.GA6016@hoboy.vegasvil.org>
 <PH0PR11MB495126A63998DABA5B5DE184EACA9@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210830205758.GA26230@hoboy.vegasvil.org>
 <20210830162909.110753ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210831161927.GA10747@hoboy.vegasvil.org>
 <20210831185824.5021e847@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210831185824.5021e847@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 06:58:24PM -0700, Jakub Kicinski wrote:
> On Tue, 31 Aug 2021 09:19:27 -0700 Richard Cochran wrote:
> > As you said later on in this thread, any API we merge now will have to
> > last.  That is why I'm being so picky here.  We want new APIs to cover
> > current HW _and_ be reasonable for the future.
> > 
> > I don't see a DPLL as either a PTP Hardware Clock or a Network
> > Device.  It is a PLL.
> > 
> > The kernel can and should have a way to represent the relationship
> > between these three different kind of IP block.  We already have a
> > way to get from PHC to netdev interface.
> 
> Makes sense to me. I was wondering how to split things at high level
> into the areas you mentioned, but TBH the part I'm struggling with is
> the delineation of what falls under PTP. PLL by itself seems like an
> awfully small unit to create a subsystem for, and PTP already has aux
> stuff like PIN control.

These pins are a direct HW interface to the posix dynamic clock that
also generates time stamps on the PTP frames.  They can either
generate time stamps on external signals, or produce output signals
from the very same clock.  So the pins are rather tightly coupled to
the PTP clock itself.

But the pins do NOT cover input clock sources into the IP cores.  This
kind of thing is already covered by the DTS for many SoCs (for a
static input clock choice, not changeable at run time)

> Then there's the whole bunch of stuff that Jonathan
> is adding via driver specific sysfs interfaces [1]. I was hoping the
> "new API" would cover his need but PLL would be a tiny part of it.
> 
> IOW after looking at the code I'm not so sure how to reasonably divide
> things.

Right, me neither.  It is a big topic, and we needn't over engineer it
now, but I still think this DPLL is not part of the PTP clock.  There
has to be a better place for it.

Thanks,
Richard
