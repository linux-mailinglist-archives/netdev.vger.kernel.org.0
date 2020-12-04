Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8504C2CE4E3
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 02:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731864AbgLDBTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 20:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729951AbgLDBTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 20:19:33 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AC3C061A4F;
        Thu,  3 Dec 2020 17:18:47 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id j13so2204368pjz.3;
        Thu, 03 Dec 2020 17:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6oVOCTQj6wif00H/TIxJjYDbEodmzk+M7JjYVfDH9xI=;
        b=vbA2vwoApuEQ6P+uaoP8LaakQHKo85Dr9FFsVcDqNv2dSYSqK3hYFwTN9kYoE/HCft
         /8yG6CcDRez5Bb2qJpDmE1bB0UyLGUKDWcG1idWrQgztkZ5dDqW/XBFcSeh9P3Xb779/
         H3sUCIEdWJouy1VyjuFoniv2fzEwW99odJ75aZQvjGmIFZRn+9hpFkG0/j//xCwi0v+S
         9r3oQhtroijV9FtYaQjhHlioDKDGJs6+ZEaKrf22GLt5dtcpGkK7lufPKMT6vNZo/CS9
         BUBCi0UfCSC7Cal0ALrMrBXgDlRYdTytQBwN7ZW1Xph9bNygGyjzXAFDa9q2RCm0kpv3
         2LWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6oVOCTQj6wif00H/TIxJjYDbEodmzk+M7JjYVfDH9xI=;
        b=GYYutN0P51bvq5jyQAxRZLSpyKo90KucjPf195qB/KtHk4+SNAUmwYMsdMkpQyVdbK
         PwAVpY5sCLGiqo8nD5W11Bn0YmI+eYBrGTFruoiQkLYVcKWwqMjAak5emg8LFOrq4VVV
         +eeb7FErMitw+AhvTsl+NbC3ZnSIjRaqj4DvtejQ+CT/Men6AfGt8LIpKfEAhi07hfu1
         J078pp0bQ3tiOG8mSbWTx7FIhLfEIrS+VsqgRBkwcIkzz0U+APOmG+qq+EJoIKF9p4Zz
         Jz+JvxVzx8RDPgQeNP1ka2O4IIICnFae4xsYzlCsEgFzVMwWd4Sid59IFuBcsQLxdox/
         pNQg==
X-Gm-Message-State: AOAM532IJrcgGj7Y+WLohyHZYXM8Pju6Hh7x2Dw9u+0S//RyU73AGnmK
        spBLSW9tY7gPJYAaiEMLJMU=
X-Google-Smtp-Source: ABdhPJxwf6hIUm5KzqFPA105RskiJdVBdi8zhheRfUX3Haxeb7AM8lcXcL9RA5AiJ4HozPLSnm0Trw==
X-Received: by 2002:a17:90b:a53:: with SMTP id gw19mr1771780pjb.216.1607044727326;
        Thu, 03 Dec 2020 17:18:47 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id z11sm496022pjn.5.2020.12.03.17.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 17:18:46 -0800 (PST)
Date:   Thu, 3 Dec 2020 17:18:43 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Christian Eggers <ceggers@arri.de>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5 9/9] net: dsa: microchip: ksz9477: add
 periodic output support
Message-ID: <20201204011843.GD18560@hoboy.vegasvil.org>
References: <20201203102117.8995-1-ceggers@arri.de>
 <20201203102117.8995-10-ceggers@arri.de>
 <20201203141255.GF4734@hoboy.vegasvil.org>
 <11406377.LS7tM95F4J@n95hx1g2>
 <20201204004556.GB18560@hoboy.vegasvil.org>
 <20201204010050.xbu23yynlwt7jskg@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204010050.xbu23yynlwt7jskg@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 03:00:50AM +0200, Vladimir Oltean wrote:
> On Thu, Dec 03, 2020 at 04:45:56PM -0800, Richard Cochran wrote:
> > Yes, that would make sense.  It would bring sysfs back to feature
> > parity with the ioctls.
> 
> Which is a good thing?

Yes, of course it is.  I'm sorry I didn't insist on it in the first place!
 
> Anyway, Christian, if you do decide to do that, here's some context why
> I didn't do it when I added the additional knobs for periodic output:
> https://www.mail-archive.com/linuxptp-devel@lists.sourceforge.net/msg04150.html

I think Christian is proposing a different sysfs file, not a flag in
the existing ones.  That makes sense to me.

Thanks,
Richard

