Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C886F3251F7
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 16:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbhBYPIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 10:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhBYPH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 10:07:59 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8DFC061574;
        Thu, 25 Feb 2021 07:07:18 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id cf12so6475045edb.8;
        Thu, 25 Feb 2021 07:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YgxLc2VG0JMjh1Dl8fUDGfSl2t2Z+y7NC8ABSzmQifU=;
        b=KloisOeB8GPOIWBl6G0fPjmDjFufNuhPjrnOyAcs+tMJUr6Y8KCoiCeSOfQYbMLpZm
         /jJ8dOrFUVoFKlH3eVUX5o95a0Ms3x2CmS5DX3sb0joEK1OUhH5s+tbzNis/SBp5vmKA
         uCDqy79/GMqDtXyhCKTzIdVbC4cSFCKFTxU1wdwDA1S1TRR2OxQo+uzS7VnLLr2Hu+nb
         1n12FBNg60gLDk77QhNUnBMggvVY7S5CyK35lHxB+bjS7AGh1BBH2COETVk0svcKPZJr
         HvKyjGrnoR/HmwuygotUOSLvdMGXEL0q0bZLCUqh6bWkLdO++kT9hfvpKyQBV9zTDNDl
         HNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YgxLc2VG0JMjh1Dl8fUDGfSl2t2Z+y7NC8ABSzmQifU=;
        b=BSfbmEZ0CcnAQBKsD27yG9q15pnyp4EJ5UKNr2HS9veRmpZ1Kbn3Ev8+77HDaj740F
         p24VsFH/dzENijub0rqKLXwXY/PdRAICCRD7aN6ULAQyqpOEj4dmWJxKzVISYBmzGlCj
         FxOmjnu9Fswz1sbIR1mcTqZ9JsdZ77HQznuSCh5ANGrnEQsmQ85R2D38S8M8XPGJwxbH
         en5CI8g8l/VzozIokLZ8CL2v+PPxXhNg6iaCiRpH7tPeXGg/UFH63mKJan/c588JVJd+
         jV8TBemAGOJlcrWPsgwHZVTy1GU14v25Xx9aE8zIfNLcLQsln9ynDhl8QlcL3tMtYIUS
         TqmQ==
X-Gm-Message-State: AOAM533SVOYKLDU5ayme1RQ/uEOr/e926XsqBuNloDBK6JyghVYmtvti
        tiIAFjkndRNIECyclqW7CAw=
X-Google-Smtp-Source: ABdhPJz7xyEym0TYTTVCSMFIhVRmTUPLs4pJk7uPnmUm2/5lFqwPvnLbd/tU98vHwzNoBNoCLORqIQ==
X-Received: by 2002:a05:6402:3590:: with SMTP id y16mr3397814edc.21.1614265637737;
        Thu, 25 Feb 2021 07:07:17 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id y8sm3441663edd.97.2021.02.25.07.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 07:07:17 -0800 (PST)
Date:   Thu, 25 Feb 2021 17:07:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] net: dsa: tag_ocelot_8021q: fix driver dependency
Message-ID: <20210225150715.2udnpgu3rs6v72wg@skbuf>
References: <20210225143910.3964364-1-arnd@kernel.org>
 <20210225143910.3964364-2-arnd@kernel.org>
 <20210225144341.xgm65mqxuijoxplv@skbuf>
 <CAK8P3a0W3_SvWyvWZnMU=QoqCDe5btL3O7PHUX8EnZVbifA4Fg@mail.gmail.com>
 <CAK8P3a1gQgtWznnqKDdJJK2Vxf25Yb_Q09tX0UvcfopKN+x0jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1gQgtWznnqKDdJJK2Vxf25Yb_Q09tX0UvcfopKN+x0jw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 03:49:08PM +0100, Arnd Bergmann wrote:
> On Thu, Feb 25, 2021 at 3:47 PM Arnd Bergmann <arnd@kernel.org> wrote:
> > On Thu, Feb 25, 2021 at 3:43 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > > On Thu, Feb 25, 2021 at 03:38:32PM +0100, Arnd Bergmann wrote:
> > > > From: Arnd Bergmann <arnd@arndb.de>
> > > >
> > > > When the ocelot driver code is in a library, the dsa tag
> 
> I see the problem now, I should have written 'loadable module', not 'library'.
> Let me know if I should resend with a fixed changelog text.

Ah, ok, things clicked into place now that you said 'module'.
So basically, your patch is the standard Kconfig incantation for 'if the
ocelot switch lib is built as module, build the tagger as module too',
plus some extra handling to allow NET_DSA_TAG_OCELOT_8021Q to still be y
or m when COMPILE_TEST is enabled, but it will be compiled in a
reduced-functionality mode, without MSCC_OCELOT_SWITCH_LIB, therefore
without PTP.

Do I get things right? Sorry, Kconfig is a very strange language.
