Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D103068D3
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 01:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhA1AvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 19:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhA1Au6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 19:50:58 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8BFC061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 16:50:17 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id gx5so5287708ejb.7
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 16:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aBmgVcfdPIaantWmgZIdSlL9t6JIJXh4r5jRHNZXcjo=;
        b=dJpyHWIBfMiLiR7wwtuzAriVYZ87gnZwRMM08wsHWRN58sfRrNdhHCuaM+7AVCzME5
         UuXNZ+JRL6XTLeapf//jLJg4TwZZkpf8Knvu5HHvEKNOCuor3l+9AvMW4EsuQgzkPhuE
         4KJXAh8rpFHjYp01gFvUcpGzw5b4cotJGO+lypO68emEP3R78nIDrulqJ1TFyjQ5uEMj
         i5zG4c4pzu8FN8Jt2rHf0ETOnoMPp5Kzs+0xT3wArMOS2QORUmV71DTT5KhVYZ8G50qp
         cc8VLWA20doj4bE1ujsDKfiw3MppFOqnJG5N3IMiCIIWMyZvHcLZmPvR676Ht0I0QjGd
         Xosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aBmgVcfdPIaantWmgZIdSlL9t6JIJXh4r5jRHNZXcjo=;
        b=j1VwHnzWzNKoYSu0HfxfAbMOGyPCtTc4X23CVKy1xf+Mrh3Na/gXD41/tItbJS9lNZ
         cwcqY4NFWSqqusCFDapU7O8vYJu0cMnjJE5rRgOuRR+GG+XRDjravQHtQNY/p3WO/2gv
         uSYx25q9P84fhpZGR7XYzjm2u7wQCuKfETUXGXJMTckmfejrXA+FVmvayGDGUNznbMnz
         BiZam885LQ3xSsy9LSlacO2i17cni92gW5lSqheJUoUnylqPnNPS8LzGVPnN85NxgkZy
         Lpl4uZc9uPDgUCw4P8eoa3alqYPYsm7gJ5DNLi4kQ8BdzoSUQjDmvOvQxvQVVRKio4gU
         UFLg==
X-Gm-Message-State: AOAM530liX/OtS0nnkkg/fT402So72mksKAv86gCwKbADWVsLeFtPxIh
        7dWWkd0o2/6Gucq0xyRF8m0=
X-Google-Smtp-Source: ABdhPJxpYs2TG9cGpXCK0VoSyt9z1KipEmIGmPfARxkCqwF53wK90yYp4nuXjYOAQsyQ8Ful6yvZgA==
X-Received: by 2002:a17:906:48f:: with SMTP id f15mr8924353eja.392.1611795016405;
        Wed, 27 Jan 2021 16:50:16 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id s1sm1576026ejx.25.2021.01.27.16.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 16:50:15 -0800 (PST)
Date:   Thu, 28 Jan 2021 02:50:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net-next 2/4] net: dsa: automatically bring user ports
 down when master goes down
Message-ID: <20210128005014.z6bteom6qkmopzf4@skbuf>
References: <20210127010028.1619443-1-olteanv@gmail.com>
 <20210127010028.1619443-3-olteanv@gmail.com>
 <YBIJZuy6iXeNQpxm@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBIJZuy6iXeNQpxm@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 01:46:30AM +0100, Andrew Lunn wrote:
> > +	case NETDEV_GOING_DOWN: {
> > +		struct dsa_port *dp, *cpu_dp;
> > +		struct dsa_switch_tree *dst;
> > +		int err = 0;
> > +
> > +		if (!netdev_uses_dsa(dev))
> > +			return NOTIFY_DONE;
> > +
> > +		cpu_dp = dev->dsa_ptr;
> > +		dst = cpu_dp->ds->dst;
> > +
> > +		list_for_each_entry(dp, &dst->ports, list) {
> > +			if (!dsa_is_user_port(dp->ds, dp->index)) {
>
> !dsa_is_user_port() ??
>
> That ! seems odd.

Oops, that's something that I refactored at the last minute after I
prototyped the idea from:
			if (!dsa_is_user_port(dp->ds, dp->index))
				continue;
because it looked uglier that way.
