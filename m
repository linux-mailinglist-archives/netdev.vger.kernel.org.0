Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807B91C6F90
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgEFLoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726843AbgEFLoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:44:20 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52DCC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 04:44:19 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id s8so1804490wrt.9
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 04:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8X+uswMd3Ue41z8ou11oNKd0muZNoaKFdUHY8+P2zA8=;
        b=pA8bF/viTyvxTFfWwDe62ORMxBpZwxRyoaNvh0DaqixnFVatYVlpFeJVk2zaS828Py
         w2MO0YC2wO3Ad/r7g25UoLd3yN7GWuX5fN22APFAeYytIpF39+Rt91LI/9QtGYfsbwuY
         HeMA5+lE63kpDSWBHTcDLFkX7wX/O4iJXSIKSnsa4/MsjcQ00ilVeeztjXry3wwpTYwr
         FoZ9amn6i74jlkaqabfz0wEPFJPilwFWX2E2mPL31IPfJdPiMWja7LS9XcJJqTxILCYE
         BfJI/S3RVAuCYL4HYTBEfPw/Iov2sCxf6HpUr2bPpUcUCMwcMuJd2D5raPlDXptnWkuu
         F6KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8X+uswMd3Ue41z8ou11oNKd0muZNoaKFdUHY8+P2zA8=;
        b=SeD6Q5J8dBfgR51SblgMizUy5HWhwnpl/YaOOIwex1/SW/bvGHEWDYA8nlJcf17qam
         tncfb1CB8sc8xMFRHlPU8Jvzfzzbl5vzSPSAnJPgLAcQlKXNHQOoh5BlWF6ChWw6JeGG
         K8rk5+M9ZMvaW6jQfjhXJqdIJnYcA7e3MitgN5AfMubXyanUgN4versyF6l7S8YS/6N8
         HEN4NB6zU86XVRv/0boq7jW3N2m41+gPvcPLHi6KKYwfdKI7JMiBH8o7PTwdHR1H6FLB
         BX0EgQvoY59yeTGrgmi3nZAqsweC89VlyvYWJnq3s/2DjHhS2orF4LlQQcrSvA/YtLyA
         XdHA==
X-Gm-Message-State: AGi0PuZTnCiYX68T8UCjOz+yDi2FOMJSrf3yHl1heS4c3RvXSVpIm667
        IbtxArZzx4M1AWA2LM77nOOJew==
X-Google-Smtp-Source: APiQypKSH2zWEu3df/nXmoqoqU6Yjt7bs4z5pBruM/kPIqVj56zCXFoeTlVuko8f6BFcxRbVCpuRRQ==
X-Received: by 2002:adf:91e4:: with SMTP id 91mr9143007wri.356.1588765458658;
        Wed, 06 May 2020 04:44:18 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z1sm2657647wmf.15.2020.05.06.04.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 04:44:18 -0700 (PDT)
Date:   Wed, 6 May 2020 13:44:17 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net,v2] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
Message-ID: <20200506114417.GB2269@nanopsycho.orion>
References: <20200505174736.29414-1-pablo@netfilter.org>
 <20200505114010.132abebd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200505193145.GA9789@salvia>
 <20200505124343.27897ad6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200505214321.GA13591@salvia>
 <20200505162942.393ed266@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <e8de6def-8232-598a-6724-e790296a251b@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8de6def-8232-598a-6724-e790296a251b@solarflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, May 06, 2020 at 01:33:27PM CEST, ecree@solarflare.com wrote:
>On 06/05/2020 00:29, Jakub Kicinski wrote:
>> IIRC we went from the pure bitfield implementation (which was my
>> preference) to one where 0 means disabled.
>>
>> Unfortunately we ended up with a convoluted API where drivers have to
>> check for magic 0 or 'any' values.
>Yeah, I said something dumb a couple of threads ago and combined the
> good idea (a DISABLED bit) with the bad idea (0 as magic DONT_CARE
> value), sorry for leading Pablo on a bit of a wild goose chase there.
>(It has some slightly nice properties if you're trying to write out-of-
> tree drivers that work with multiple kernel versions, but that's never
> a good argument for anything, especially when it requires a bunch of
> extra code in the in-tree drivers to handle it.)
>
>> On Tue, 5 May 2020 23:43:21 +0200 Pablo Neira Ayuso wrote:
>>> And what is the semantic for 0 (no bit set) in the kernel in your
>>> proposal?
>It's illegal, the kernel never does it, and if it ever does then the
> correct response from drivers is to say "None of the things I can
> support (including DISABLED) were in the bitmask, so -EOPNOTSUPP".
>Which is what drivers written in the natural way will do, for free.
>
>>> Jiri mentioned there will be more bits coming soon. How will you
>>> extend this model (all bit set on for DONT_CARE) if new bits with
>>> specific semantics are showing up?
>If those bits are additive (e.g. a new type like IMMEDIATE and

They are additive.


> DISABLED), then all-bits-on works fine.  If they're orthogonal flags,
> ideally there should be two bits, one for "flag OFF is acceptable"
> and one for "flag ON is acceptable", that way 0b11 still means don't
> care.  And 0b00 gets EOPNOTSUPP regardless of the rest of the bits.
>
>>> Combining ANY | DISABLED is non-sense, it should be rejected.
>It's not nonsense; it means what it says ("I accept any of the modes
> (which enable stats); I also accept disabled stats").
>
>-ed
