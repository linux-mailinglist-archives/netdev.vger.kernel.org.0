Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C4641A010
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 22:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236966AbhI0UYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 16:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236910AbhI0UYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 16:24:46 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A36CC061575;
        Mon, 27 Sep 2021 13:23:08 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id n18so18826088pgm.12;
        Mon, 27 Sep 2021 13:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=V0i5nY3QH9iXcrKglZXlGRD0wtyYtp6y70pksa3skO4=;
        b=qwewqIBSaLhc/bs3fxJK++SG+QNUWBZtG/3GwuqDOKqPpyTUlbxVGJDNXSTW/ejr8C
         bapb2W9gCU8b/iQVZdRVUyw00zF8Y6HME1jl0H2Dzuj7PjsyfV46kIKpC4R8HMLvmiTW
         0BOmj1CEF5EKopUo46JNhSAcobXpnM96fkT1hlT4YjGwSwwtFOw5p7C3jV51KORAevwM
         a43/xmb5ytVpGG7KMJfq2pT3fkc2d+iiPZtbhC6Ebop1mE9vOc5wZ8/dQ2uMIIrn0BMk
         76XaWtahqlv/I7N3fHZkzEny62TX+fNyDbEZCJ36K+4rt/kyAv/PBp+lZzoRJgeBE/Rw
         Y4eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=V0i5nY3QH9iXcrKglZXlGRD0wtyYtp6y70pksa3skO4=;
        b=gOU8AgpT/NZOLJv8934BuQgnTmN7E4W78e20sHAg+KSlOgRwvksmFb6cQ+SYAHtBoJ
         0OdxFikawiatOYsCGk/EJ0PclAVoTAP6YMb4KB72IZ4MH00rs7ydtWXJ9w1Kq+jPF7fH
         YqV6qxH8szvYnhiW7/9Lf/jb6d/syhg9R78pr1b857iHB/2Cmo3Fz5zMMGq+5xY4BpjK
         rqaA8oxhsBR0M3ZhJcdXZQ3tyIHqSSeHzKh1KvO+ZrSDJUxQt1fk7YZZ8Suor0/hkqEK
         oYiPe3SkG95avrEhPXc8kzZZPnJVfew0QCbKRbtCgb/7gwx/Q3ZVPbroHK3O/8dgmFQG
         E5Hg==
X-Gm-Message-State: AOAM53282u5eNctdvPB3/vjcIi+k/nKl25nRdN5DB4RIpwzVGNdaFbbO
        TZDts8LnX10VkMDDxfuwNz4=
X-Google-Smtp-Source: ABdhPJxps7L5mrAo9cBFURpLQEOJJ3M/lpdPTfVDXKPcn6ITv/07nHWAGpB/imssYjn1RVIBDw5YRA==
X-Received: by 2002:a65:4209:: with SMTP id c9mr1210484pgq.399.1632774187555;
        Mon, 27 Sep 2021 13:23:07 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id n12sm10046806pff.166.2021.09.27.13.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 13:23:07 -0700 (PDT)
Date:   Mon, 27 Sep 2021 13:23:04 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Sebastien Laveze <sebastien.laveze@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, yannick.vignon@oss.nxp.com,
        rui.sousa@oss.nxp.com
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
Message-ID: <20210927202304.GC11172@hoboy.vegasvil.org>
References: <20210927093250.202131-1-sebastien.laveze@oss.nxp.com>
 <20210927145916.GA9549@hoboy.vegasvil.org>
 <b9397ec109ca1055af74bd8f20be8f64a7a1c961.camel@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9397ec109ca1055af74bd8f20be8f64a7a1c961.camel@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 06:00:08PM +0200, Sebastien Laveze wrote:
> The "typically" was more a reference to this possible implementation of
> AS-2020 using a common CMLDS layer and several domains using a single
> socket.
> 
> So, without this IOCTL the design would be 1 socket for CMLDS layer
> and 1 socket for each domain plus some specific filtering for each
> socket to avoid processing the unwanted traffic.
> 
> With this IOCTL, the design would be 1 socket and 1 conversion for the
> sync messages in the appropriate domain.

The ioctl solution is gross.  A program with eight vclocks should call
recvmsg and parse the CMSG, then go and call ioctl seven times?  Yuck.

What you really want is the socket to return more than one time stamp.
So why not do that instead?

Right now, the SO_TIMESTAMPING has an array of

   struct timespec ts[3] = 
   [0] SOFTWARE
   [1] LEGACY (unused)
   [2] HARDWARE

You can extend that to have

   [0] SOFTWARE
   [1] LEGACY (unused)
   [2] HARDWARE (vclock 0)
   [3] HARDWARE (vclock 1)
   [4] HARDWARE (vclock 2)
   ...
   [N] HARDWARE (vclock N-2)

You could store the selected vclocks in a bit mask associated with the socket.

Hm?

Thanks,
Richard
