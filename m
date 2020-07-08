Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D4B218A67
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 16:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730008AbgGHOsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 10:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729652AbgGHOsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 10:48:07 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FF3C061A0B;
        Wed,  8 Jul 2020 07:48:07 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id t11so15203443pfq.11;
        Wed, 08 Jul 2020 07:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WhGgrGKcd7sGWY9MzL2leiUQIrs2+2qjPvCl1NLx+eY=;
        b=gXw+UlKIVhowiPQKdVS4aInpk5zM1TnuTdyvF8oGC2sgOsMw5CHGCisRVIeVXdUyrQ
         ONKjgFEjgNnx3/pGHceBvJIh3xs+JniaqJznQHQ1iRu6uoif0q5EvgYYgnxMjRnPqbSj
         3Uy/KxLnHnYQdL6y2R5IVeG96O0zbo3DFtDOYaPglw3KI/MsbvnGzjX+KjbV3CfPeCzk
         prp6L0Dim38Uvvaw6mQUDFw87arHWIPReRBpMwGKWTBC6bvfpaZtjyu8lDn1fsszZWqm
         15r3eg/yiBA2rNo0+ymLtqZeeOvhR/czLYYbD3uAX790nDHtczpb20kll8Oijh5I7vf5
         I79w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WhGgrGKcd7sGWY9MzL2leiUQIrs2+2qjPvCl1NLx+eY=;
        b=ajdkSatanbfy+H2Zk7HxYmp/vPBX9R5MYjmrR7S49f0KRabPFfmn5ea/ev51bk/8Ep
         6o70phFHEqywnZSvqmt2qCH3IPhOgtiHJhdfW7ic4dk/u0xZNPelQNGVg6cvMQ6CAksG
         xuWJZYzr135wLeG6rW5+4r2Ar7IGEhDZn90q1snR88A26AFtq6h+vM1qW2J35kFn4SfO
         adcPQPhqiVvSalO23EwHpL2sf4IfZNRVwSBCspR3mR+5li460uzy1JTkoZb7NkjhANpe
         hLNlD4SqAf9QVyqa3j3680cIxoJY2xMj8z8C+ThYvhVxJ+uJdStZDsw0JFb79AGf/3zt
         JsfA==
X-Gm-Message-State: AOAM530aEdx0j14xnvL39mZAOi0onaLsQL4W0zrus1W/AwoCFHlqoLgv
        s1SfXNO66sq+LXz20Zs2s70=
X-Google-Smtp-Source: ABdhPJyFaDf6vZi+hjhnezcD8cztHjByr8YfgEIcBPmqO77EJZtJjLg8R5usAx0gVhNf8VGxVYV2AA==
X-Received: by 2002:a65:60ce:: with SMTP id r14mr50169456pgv.85.1594219686688;
        Wed, 08 Jul 2020 07:48:06 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id e191sm152808pfh.42.2020.07.08.07.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 07:48:05 -0700 (PDT)
Date:   Wed, 8 Jul 2020 07:48:03 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH  3/5] net: fec: initialize clock with 0 rather than
 current kernel time
Message-ID: <20200708144803.GB13374@hoboy>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200706142616.25192-4-sorganov@gmail.com>
 <20200706152721.3j54m73bm673zlnj@skbuf>
 <20200708110444.GD9080@hoboy>
 <87mu4a9o8m.fsf@osv.gnss.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mu4a9o8m.fsf@osv.gnss.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 08, 2020 at 03:37:29PM +0300, Sergey Organov wrote:
> Richard Cochran <richardcochran@gmail.com> writes:
> 
> > On Mon, Jul 06, 2020 at 06:27:21PM +0300, Vladimir Oltean wrote:
> >> There's no correct answer, I'm afraid. Whatever the default value of the
> >> clock may be, it's bound to be confusing for some reason, _if_ the
> >> reason why you're investigating it in the first place is a driver bug.
> >> Also, I don't really see how your change to use Jan 1st 1970 makes it
> >> any less confusing.
> >
> > +1
> >
> > For a PHC, the user of the clock must check the PTP stack's
> > synchronization flags via the management interface to know the status
> > of the time signal.
> 
> Actually, as I just realized, the right solution for my original problem
> would rather be adding PTP clock ID that time stamped Ethernet packet to
> the Ethernet hardware time stamp (see my previous reply as well).

I think you misunderstood my point.  I wasn't commenting on the
"stacked" MAC/PHY/DSA time stamp issue in the kernel.

I am talking about the question of whether to initialize the PHC time
to zero (decades off from TAI) or ktime (likely about 37 seconds off
from TAI).  It does not really matter, because the user must not guess
whether the time is valid based on the value.  Instead, the user
should query the relevant PTP data sets in a "live" online manner.

For example, to tell whether a PHC is synchronized to anything at all,
you need to check PORT_DATA_SET.portState and probably also
CURRENT_DATA_SET.offsetFromMaster depending on your needs.

In addition, if you care about global time, you need to check:

TIME_PROPERTIES_DATA_SET
  currentUtcOffset
  currentUtcOffsetValid
  ptpTimescale
  timeTraceable
  frequencyTraceable

Thanks,
Richard
