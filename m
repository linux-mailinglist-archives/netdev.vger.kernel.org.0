Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8391E178356
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731095AbgCCTs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 14:48:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730546AbgCCTs3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 14:48:29 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98455208C3;
        Tue,  3 Mar 2020 19:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583264908;
        bh=ezsKnO5U7D++n31nUxCkZSpDvTns933a8baUSbkLa1I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R3gATZHz4oaoP0nREXBC2ZdbpcEm2QIilCVuEeyVLjqGScXwbxzbg6TQpS+KuWFXR
         JWt1MrYrWHjZfN+8zUqfEDv0ErU0cYxi4JzlA0u6nxULz2VGN4n/i40Dl8egdQ0IrJ
         l7uQyaaRHNTJE8VkV/6VvjUEvxi4aBcrUhrbK91s=
Date:   Tue, 3 Mar 2020 11:48:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 12/12] sched: act: allow user to specify
 type of HW stats for a filter
Message-ID: <20200303114825.66b7445e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200303132035.GH2178@nanopsycho>
References: <20200228172505.14386-1-jiri@resnulli.us>
        <20200228172505.14386-13-jiri@resnulli.us>
        <20200228115923.0e4c7baf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200229075209.GM26061@nanopsycho>
        <20200229121452.5dd4963b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200301085756.GS26061@nanopsycho>
        <20200302113933.34fa6348@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200303132035.GH2178@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Mar 2020 14:20:35 +0100 Jiri Pirko wrote:
> >> Also there would be no "any" it would be type0|type1|type2 the user
> >> would have to pass. If new type appears, the userspace would have to be
> >> updated to do "any" again :/ This is inconvenient.  
> >
> >In my proposal above I was suggesting no attr to mean any. I think in
> >your current code ANY already doesn't include disabled so old user
> >space should not see any change.  
> 
> Odd, no attribute meaning "any".

OTOH it does match up with old kernel behavior quite nicely, today
there is no attribute and it means "any".

> I think it is polite to fillup the attribute for dump if kernel
> supports the attribute. However, here, we would not fill it up in
> case of "any". That is quite odd.

I see, it does seem nice to report the attribute, but again, won't 
the user space which wants to run on older kernels have to treat
no attr as "any"?

> We can have a bit that would mean "any" though. What do you think?

It'd be a dead bit for the "stat types used" attribute, but I don't
mind it if you prefer to go this way.
