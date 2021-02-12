Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF75F31A0CC
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 15:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhBLOlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 09:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbhBLOlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 09:41:37 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8603C061574;
        Fri, 12 Feb 2021 06:40:56 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id g10so11181462eds.2;
        Fri, 12 Feb 2021 06:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XtDi0MBEwrkwGMq8hjer8LJhgp1YzuDVXdwRv+z+ZLg=;
        b=iU1Inb9VFPF3NTBWyuFt6Kixh9kNctCuRZ8NktXv+oGPVDU1I/FlflMtneS10uKAUK
         oF0dl1800p0nfL+bbVbQcopyUhiqeXZmLaI9JJKMq+/zjImrrET8rwUhkZSjdINFRamr
         8hTlIzp2yCEsDch2VLZKAEOxuv3tf/Ykl8bZJ1vFgypXxJTp+k0yl6kqqi3fBoDog8fT
         M96MdnPkx/mCj6V9E2qiAx0Y8LrvQeD40bm0+8os6PbXuyk+8tysKSyfWQ86SwsqHDa9
         HKLNRWPefZFLAUoMiJFb/ohwJX86qEvK9YhooOWY1EvVtvn9UtC/IS3DbsDJIW18LRw2
         dILg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XtDi0MBEwrkwGMq8hjer8LJhgp1YzuDVXdwRv+z+ZLg=;
        b=iAiiu/w/qMSnNZj/kapo6PPWMq4HltmLyZGoXys2ZN+dfKgwIDc523CAbN3eAAHXVZ
         oWa7s3CLNC2V4IlmyJXucDzpOyhxv9YrjggwZSnj65kwRXulxOnUcDaHM9Id5bp00N2q
         cNW4gakUJSMBhsgAxUdQSQf+nU27zag9rm/FaUr/FRRGCROhkE44VRWXXM0wPpsGn5qE
         gmnxdootvfbqedzOXvT1Lg7KPjBbmik+SmM+kQZ20QlIZBW7Lfc0iYiUKjhedtVjzF9g
         onlPktUkP+C5kGsZtFFlN/MjOuJTusZDI+04iIM7d0+aJ8IiyWk5qo0TRqScSJUVHVrf
         1WQQ==
X-Gm-Message-State: AOAM532+ia4edfaHM+Zbx9tABnI1zX0N9t4BNCuLP8JT6yNfINCzknTq
        CCdbUELCb/J4ucnil7wxLGs=
X-Google-Smtp-Source: ABdhPJz+AXgLzH7mgMsrvooJIgmH23vOS4s5UyRQEU9NhLWKLE+tLUwEiOQNPD5zc+uaUI5o8ANfjA==
X-Received: by 2002:a05:6402:1113:: with SMTP id u19mr3621498edv.205.1613140855639;
        Fri, 12 Feb 2021 06:40:55 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h15sm6271339ejj.43.2021.02.12.06.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 06:40:54 -0800 (PST)
Date:   Fri, 12 Feb 2021 16:40:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vignesh Raghavendra <vigneshr@ti.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v4 net-next 0/9] Cleanup in brport flags switchdev
 offload for DSA
Message-ID: <20210212144053.2pumwc6mlt4l2gcj@skbuf>
References: <20210212010531.2722925-1-olteanv@gmail.com>
 <97ae293a-f59d-cc7c-21a6-f83880c69c71@ti.com>
 <ba7350f1-f9ff-b77e-65c9-cd5a4ae652d8@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba7350f1-f9ff-b77e-65c9-cd5a4ae652d8@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 08:01:33PM +0530, Vignesh Raghavendra wrote:
> Hi Vladimir,
> 
> On 2/12/21 7:47 PM, Grygorii Strashko wrote:
> > 
> > 
> > On 12/02/2021 03:05, Vladimir Oltean wrote:
> >> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> [...]
> > 
> > Sorry, but we seems just added more work for you.
> > https://lore.kernel.org/patchwork/cover/1379380/
> > 
> 
> Could you squash these when you post new version:
> Sorry for not noticing earlier.

Hey, thanks for the fixup patch and congrats on the new driver support
for the AM65 NUSS! What's functionally different compared to the other
CPSW instantiations?

Also, do I get it right that you also tested the bridge port flags
passed in the new format and that they still work ok? May I add your
Tested-by tag?
