Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52593362DE
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 19:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfFERk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 13:40:29 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36150 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbfFERk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 13:40:29 -0400
Received: by mail-pf1-f195.google.com with SMTP id u22so15255322pfm.3
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 10:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yX2JZSBmg3SzAR5+ZpuKpY/tgjzC5GZkNt7Mb1jmzyE=;
        b=mlkT3TmudhPDH0hhA24JssUIZFoiVqNixb3QGjle0dTbK6mYC4iiYHOkmEJzzcgf+6
         CdUW6a1yl9THNloa4vrA8DOdVc51TNSyS9qEKEClh5i1JSTbISWYfKS1i7BE7wf1HDpZ
         nReFRi5KlVWT6M+cDsH1nFoCG0Z0jx4kTLCrFNuEYi9YixAfXURlRbCvzCBjaLbnlsNW
         I3VSBVwnMuntZf9oi6NOgtPbazezKWHquXNrg8PAx3BBEU0X6r8s5NiUjh1BxNoJUJDn
         TxM3IrJMhN4t/642eG+GievVRh2RljKtwEYv4U7rgY9fw6Zw1ou4zBBGJm+2OQwveDtB
         Z8UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yX2JZSBmg3SzAR5+ZpuKpY/tgjzC5GZkNt7Mb1jmzyE=;
        b=LBTIyyoDwHacb35CncQLMvxu3UCO2jc18qWX4IFb0nUW/2A85eX4rlAPTiX4sWR14k
         3aCibQqYzcrJtC90W+/oElU3y23qW9D8ibfRdjg6iRJwJlUuYxiH3pibU1snCqsWW55t
         w3k1fOjA1tLPLBTYnu4U53Ic7KegX5SNQcBvnLtGYNZYwWLnKBM50F7hhdrhm6zpb7u/
         I2twg/GRnYkVyWuOaeN31ywUUnj7qq4giGW7JdSYT5k3EwGHnIqKx7dfaS+MgeAvef9w
         8Ntnb9JMkjnK/dZBrNjHxZth0EWbLXUveklYpiawf9xc42rcDsQADJ4mHCcMbFj6SwLh
         g0AA==
X-Gm-Message-State: APjAAAWs/cAPzIMR5nkrSbKQ6qjN3iDhlFkQWPvDQL0BxV1MbrkHF2dH
        i3+Ykq6Y3e9+eWRu8Xp7yfI=
X-Google-Smtp-Source: APXvYqzhEU214pwBMvFjopRyQCdylse/J/lTij5WWVPoP3TxY14j0Pys+6HIOK99RbXY2aZFUPPjcQ==
X-Received: by 2002:a62:1a8e:: with SMTP id a136mr10409869pfa.22.1559756428524;
        Wed, 05 Jun 2019 10:40:28 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id l13sm19828096pjq.20.2019.06.05.10.40.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Jun 2019 10:40:27 -0700 (PDT)
Date:   Wed, 5 Jun 2019 10:40:25 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Shalom Toledo <shalomt@mellanox.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 7/9] mlxsw: spectrum_ptp: Add implementation for
 physical hardware clock operations
Message-ID: <20190605174025.uwy2u7z55v3c2opm@localhost>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-8-idosch@idosch.org>
 <20190604142819.cml2tbkmcj2mvkpl@localhost>
 <5c757fb9-8b47-c03a-6b78-45ac2b2140f3@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c757fb9-8b47-c03a-6b78-45ac2b2140f3@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 11:44:21AM +0000, Shalom Toledo wrote:
> On 04/06/2019 17:28, Richard Cochran wrote:
> > Now I see why you did this.  Nice try.
> 
> I didn't try anything.
> 
> The reason is that the hardware units is in ppb and not in scaled_ppm(or ppm),
> so I just converted to ppb in order to set the hardware.

Oh, I thought you were adapting code for the deprecated .adjfreq method.
 
> But I got your point, I will change my calculation to use scaled_ppm (to get a
> more finer resolution) and not ppb, and convert to ppb just before setting the
> hardware. Is that make sense?

So the HW actually accepts ppb adjustment values?  Fine.

But I don't understand this:

> >> +	if (ppb < 0) {
> >> +		neg_adj = 1;
> >> +		ppb = -ppb;
> >> +	}
> >> +
> >> +	adj = clock->nominal_c_mult;
> >> +	adj *= ppb;
> >> +	diff = div_u64(adj, NSEC_PER_SEC);
> >> +
> >> +	spin_lock(&clock->lock);
> >> +	timecounter_read(&clock->tc);
> >> +	clock->cycles.mult = neg_adj ? clock->nominal_c_mult - diff :
> >> +				       clock->nominal_c_mult + diff;
> >> +	spin_unlock(&clock->lock);

You have a SW time counter here

> >> +	return mlxsw_sp1_ptp_update_phc_adjfreq(clock, neg_adj ? -ppb : ppb);

and a hardware method here?

Why not choose one or the other?

Thanks,
Richard
