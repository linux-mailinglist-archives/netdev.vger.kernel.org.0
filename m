Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC682E2E2
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfE2RK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:10:57 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34516 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfE2RK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:10:56 -0400
Received: by mail-qk1-f195.google.com with SMTP id t64so2002105qkh.1;
        Wed, 29 May 2019 10:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=ATwDtoWjOVCXqu7sDl5IFgBGFnm6OEQYsxPD7GTeoMc=;
        b=oHev3x4UP07zZR6uklQz+WyfaygMFayVK0/pOOe/pxBYqFnpW2avxA8jdbrw2ec65W
         Fri3ISzB/akPeGIMprylsCMCCx8sHzuVu4eNHbpdITWYrEpHw5qD5XbFDeQ9Cqi1ioiD
         CGVgjriD6UQRaxDCUJedk6qttislYXsjJDPylVbmst8P4WG5udgOhh2bBJ2T2rwaGWE4
         SgzTixruWECBXlr62RtmK0MPPkvhJzaWGqImigCCNnAUlN8eCEwuxtQhIY6TDfLxaaZS
         gNmcmf4vCIEWIxKivec8u8CCXVfFwrugj3LJBbfCWRqhYdwmnVZi3FlLGsuxphFw0ZHW
         vsxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=ATwDtoWjOVCXqu7sDl5IFgBGFnm6OEQYsxPD7GTeoMc=;
        b=Adrbd8J19JLfNUfrRSQjPmLOhLI+yq01Rb6Gb7+P78lGFPFG3f7q/ANuhxh+UeN8J/
         4RIOke8M4eWiGL6mQlbQAeEY+InnyFFJHxmMhWM3wpVHiNXdCmlELcE9w5iaBGWsFq3J
         rw+D4Mc0uNU5xJMe8gc0MPBTEi4sVRLXcmpcxH3B69fLC3p5DBhsPdUgLKXNc2jm7qeD
         Fi9vaupzLag9PJQZ6Djp3X9XXZt4OmmCUYoZOf9FCkgSUpC38JQpUZhr1ZxY2eejep4a
         Ok30g49xABR1EEHSA3ZCtA4NBAk4RjxllFdM3LUpoToaHFnHfvoE2AvcHLzFLgqBBuJU
         Za1Q==
X-Gm-Message-State: APjAAAU3IXidGnRIYfQG9XNRH9cIFAsVwQcUlK2FrYD3ZAl0W2N1iut6
        am7pAdeiqB8Aovm3VSWDcb0=
X-Google-Smtp-Source: APXvYqyeW6k25mRsF7Bd54dp+F8mXgY7O82FSWRBEYEVm0CW4OafpVBvgoLxo7tWtGCNoYId7VXTgg==
X-Received: by 2002:a37:6112:: with SMTP id v18mr12656693qkb.126.1559149855109;
        Wed, 29 May 2019 10:10:55 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id h128sm17009qkc.27.2019.05.29.10.10.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 May 2019 10:10:54 -0700 (PDT)
Date:   Wed, 29 May 2019 13:10:53 -0400
Message-ID: <20190529131053.GB13966@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: fix handling of upper half of
 STATS_TYPE_PORT
In-Reply-To: <dc84827e-6bac-7a01-f998-609cfe9a33ec@prevas.dk>
References: <20190528131701.23912-1-rasmus.villemoes@prevas.dk>
 <20190528134458.GE18059@lunn.ch>
 <dc84827e-6bac-7a01-f998-609cfe9a33ec@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rasmus, Andrew,

On Wed, 29 May 2019 06:42:53 +0000, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> On 28/05/2019 15.44, Andrew Lunn wrote:
> > On Tue, May 28, 2019 at 01:17:10PM +0000, Rasmus Villemoes wrote:
> >> Currently, the upper half of a 4-byte STATS_TYPE_PORT statistic ends
> >> up in bits 47:32 of the return value, instead of bits 31:16 as they
> >> should.
> >>
> >> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> > 
> > Hi Rasmus
> > 
> > Please include a Fixes tag, to indicate where the problem was
> > introduced. In this case, i think it was:
> > 
> > Fixes: 6e46e2d821bb ("net: dsa: mv88e6xxx: Fix u64 statistics")
> > 
> > And set the Subject to [PATCH net] to indicate this should be applied
> > to the net tree.
> 
> Will do.
> 
> >> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> >> index 370434bdbdab..317553d2cb21 100644
> >> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> >> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> >> @@ -785,7 +785,7 @@ static uint64_t _mv88e6xxx_get_ethtool_stat(struct mv88e6xxx_chip *chip,
> >>  			err = mv88e6xxx_port_read(chip, port, s->reg + 1, &reg);
> >>  			if (err)
> >>  				return U64_MAX;
> >> -			high = reg;
> >> +			low |= ((u32)reg) << 16;
> >>  		}
> >>  		break;
> >>  	case STATS_TYPE_BANK1:
> > 
> > What i don't like about this is how the function finishes:
> > 
> >        	}
> >         value = (((u64)high) << 32) | low;
> >         return value;
> > }
> > 
> > A better fix might be
> > 
> > -		break
> > +		value = (((u64)high) << 16 | low;
> > +		return value;
> 
> Why? It's odd to have the u32 "high" sometimes represent the high 32
> bits, sometimes the third 16 bits. It would make it harder to support an
> 8-byte STATS_TYPE_PORT statistic. I think the code is much cleaner if
> each case is just responsible for providing the upper/lower 32 bits,
> then have the common case combine them; . It's just that in the
> STATS_TYPE_BANK cases, the 32 bits are assembled from two 16 bit values
> by a helper (mv88e6xxx_g1_stats_read), while it is "open-coded" in the
> first case.

Here "low" and "high" are u32 and refer to the upper and lower halves
of the u64 returned value. For a 4-byte STATS_TYPE_PORT value, the
second read refers to the bits 31:16, thus belongs to (the upper half
of) the lower half of the 64-bit returned value, i.e. "low".

The current return value is correct, as well as your patch.


Thanks,
Vivien
