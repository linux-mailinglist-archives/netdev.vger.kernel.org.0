Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098632FE236
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 07:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbhAUGCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 01:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728422AbhAUDDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 22:03:41 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C09C0613C1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 19:02:55 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id r4so455601pls.11
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 19:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wh2a2Xn39GYNgJZezJYHOvMLBQHaR5tyeVnHT5TJGCg=;
        b=MOcwkFzPtHDo1ypGdKhVB4HH1iW8wtq5gwit7Y6DQ+C31PgihJZh7k52Via1AFsre9
         Cz6YYgpzRO0CTpSzbIdw5zTdQnFDz3eRBbFZ0lKZufNROV0ab3Ew23xU8oJGxCB1HzaC
         If+XeAE/3sOtIHfmNE0N98LSH+6C6EnRrPqYh9lYSLo9KvvnQnw2PQSOa3kCO/gfyA4v
         Hupk5j6cJsu0KPkJQ5luKmGj0H0puPIpiZDQ9qHXnjktMlrJ13R4uIJXa6izDXelBMeo
         P6E3NVYoIvKx3g6qBmiVtcBVnbOZEyQGWzeePmWXtpQdDfFB7JHoTYzT0i5v32xC+XeE
         Tr5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wh2a2Xn39GYNgJZezJYHOvMLBQHaR5tyeVnHT5TJGCg=;
        b=X9RJlK4CfuqESpJpS222y/AAe8jhNdB/z44O/cqGLyXGe5x9kOSO4RyrlUA9qqF1Z0
         PUnVGYw2XDLkfTXuvknGhSqbtElavpp4bZrlfP7q9JCaIWwrpF8sCxyADS+VLgg4hojF
         oecd4SKn+ZhOqLk6N3fr7ido2Q2dbwg3AUkaoHw/ePDf7wK4MU8KjKZwGki8R0x8ydyL
         6Mqnwcs9D7MpsKGGyUoxvIcP92pQ/MVgf2N3+DnyMYHhtWD8Q3hgyiworrrH7lNR5EEi
         HlGHy9/hWuErvGfdyvK2rPVF+nYrIXv9IPrh17AFbjFV2HtuG5Vq1CR9krZ7eE7pyHfK
         4/eg==
X-Gm-Message-State: AOAM530vOdlYvd2ZP4yxKp/hYCamL9nAlXVRkLolQgTeLb3FRpMWXcmz
        KFbEQHtndk3otH6cQvD5t8k=
X-Google-Smtp-Source: ABdhPJxpKfaArfxzrLDnN2HyPBG2AYn5mTAKfUNsJnE3BG9pg8GeiRTko3guy04ZAhIVHGZqDAlLZA==
X-Received: by 2002:a17:90a:d990:: with SMTP id d16mr9075177pjv.16.1611198174737;
        Wed, 20 Jan 2021 19:02:54 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o190sm3642617pga.2.2021.01.20.19.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 19:02:54 -0800 (PST)
Date:   Thu, 21 Jan 2021 11:02:43 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] selftests/net: set link down before enslave
Message-ID: <20210121030243.GJ1421720@Leo-laptop-t470s>
References: <20210120102947.2887543-1-liuhangbin@gmail.com>
 <20210120104210.GA2602142@shredder.lan>
 <20210120143847.GI1421720@Leo-laptop-t470s>
 <20210120194328.GA2628348@shredder.lan>
 <20210120174644.083de7fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120174644.083de7fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 05:46:51PM -0800, Jakub Kicinski wrote:
> On Wed, 20 Jan 2021 21:43:28 +0200 Ido Schimmel wrote:
> > On Wed, Jan 20, 2021 at 10:38:47PM +0800, Hangbin Liu wrote:
> > > Hi Ido,
> > > 
> > > On Wed, Jan 20, 2021 at 12:42:10PM +0200, Ido Schimmel wrote:  
> > > > > diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
> > > > > index c9ce3dfa42ee..a26fddc63992 100755
> > > > > --- a/tools/testing/selftests/net/rtnetlink.sh
> > > > > +++ b/tools/testing/selftests/net/rtnetlink.sh
> > > > > @@ -1205,6 +1205,8 @@ kci_test_bridge_parent_id()
> > > > >  	dev20=`ls ${sysfsnet}20/net/`
> > > > >  
> > > > >  	ip link add name test-bond0 type bond mode 802.3ad
> > > > > +	ip link set dev $dev10 down
> > > > > +	ip link set dev $dev20 down  
> > > > 
> > > > But these netdevs are created with their administrative state set to
> > > > 'DOWN'. Who is setting them to up?  
> > > 
> > > Would you please point me where we set the state to 'DOWN'? Cause on my
> > > host it is init as UP:
> > > 
> > > ++ ls /sys/bus/netdevsim/devices/netdevsim10/net/
> > > + dev10=eth3
> > > ++ ls /sys/bus/netdevsim/devices/netdevsim20/net/
> > > + dev20=eth4
> > > + ip link add name test-bond0 type bond mode 802.3ad
> > > + ip link show eth3
> > > 66: eth3: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
> > >     link/ether 1e:52:27:5f:a5:3c brd ff:ff:ff:ff:ff:ff  
> > 
> > I didn't have time to look into this today, but I suspect the problem is
> > either:
> > 
> > 1. Some interface manager on your end that is setting these interfaces
> > up after they are created
> 
> This must be the case, the kernel doesn't open/up devices by itself.

Ah, yes, My bad. I found NetworkManager enabled it by default.

Thanks
Hangbin
