Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC39342C104
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 15:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbhJMNMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 09:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbhJMNMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 09:12:23 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59F4C061746;
        Wed, 13 Oct 2021 06:10:20 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q5so2273632pgr.7;
        Wed, 13 Oct 2021 06:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=K3jX64Vx9BFqq3VVaJ5pyleIomfl6tS4Fp54nVW8q20=;
        b=al7uDPRjrT5GxPBzfuAYGQy7Wa3YoQ5S9r1RoMtljDgwXb63e6GT4tZLbFpzMAJ8jL
         KcekHyjZ7/Sf2VQ17vR982tNUZ3AzxxNM7SGO250EVx7WLKedGGVvHUhQeuG8jB2v6vy
         LN8UJwoSXZEWjBYi+HpjlKig0RSadCRDH0lUr/Brahq1gpu+Y7kpxJrYvexmQXt9MhWI
         BmCOCBdeyHkpMugB0UBAVfxGBi+Z9GwjtVdL3jAc7Pl7lmdhtA7JdfU4CwjfmzDFFMcw
         Cyxk2K4v58bTcBCat7mjSHgSfuF52/RP4XrzoSJg4RCMkAjMOaSD3GuCAlrrsDJQSJVV
         T3Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=K3jX64Vx9BFqq3VVaJ5pyleIomfl6tS4Fp54nVW8q20=;
        b=FHf65rShEAX84k9LdYjK1gV6GC7hCwpiH9sHi20EtO/Qeg8IQvt5d7Zj4WWNoLayOq
         FXbfmqaAXg/V7fszHOj7bf2CNFtLnm+cMwb6lObWOSAHSDqJVRJvjc1hsmP9SRtVlpbV
         PqiWOIFV41cYPKCYmGNUIDPLRGlgzvXgJmtdo3RZO1gAVB/lcBcAHxGFW0ujWOTcyB6R
         28RKTunTIUfeDxNWA5P+D9iKXVAjre+gD3bHK+Bl2BqxKkyFp+tbhU2zWrQs4w5d3xMU
         LTySlT8XSNVlmsHsl4zp5haS+EODHFWcW0hlWY7QAn+raWsA/UMfIgt96aQmL9HRQJia
         +G4Q==
X-Gm-Message-State: AOAM533L5NwCRg6NQ5+YcnFxnxXOkkxJLcjbUQ5f8LXVYHTsrh79rWG1
        Nthj3TgDW8XQjgma/5mbfxw=
X-Google-Smtp-Source: ABdhPJwkvEIeYGREEL+9Hytlp18erBbgAwOVMDQkNFD/khkPbutqxeI3QGYh80rElWs+PFZGh6/eBA==
X-Received: by 2002:a63:131f:: with SMTP id i31mr27735079pgl.207.1634130620135;
        Wed, 13 Oct 2021 06:10:20 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id p13sm5789341pjb.44.2021.10.13.06.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 06:10:19 -0700 (PDT)
Date:   Wed, 13 Oct 2021 06:10:17 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Sebastien Laveze <sebastien.laveze@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, yannick.vignon@oss.nxp.com,
        rui.sousa@oss.nxp.com
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
Message-ID: <20211013131017.GA20400@hoboy.vegasvil.org>
References: <20210927202304.GC11172@hoboy.vegasvil.org>
 <98a91f5889b346f7a3b347bebb9aab56bddfd6dc.camel@oss.nxp.com>
 <20210928133100.GB28632@hoboy.vegasvil.org>
 <0941a4ea73c496ab68b24df929dcdef07637c2cd.camel@oss.nxp.com>
 <20210930143527.GA14158@hoboy.vegasvil.org>
 <fea51ae9423c07e674402047851dd712ff1733bb.camel@oss.nxp.com>
 <20211007201927.GA9326@hoboy.vegasvil.org>
 <768227b1f347cb1573efb1b5f6c642e2654666ba.camel@oss.nxp.com>
 <20211011125815.GC14317@hoboy.vegasvil.org>
 <ca7dd5d4143537cfb2028d96d1c266f326e43b08.camel@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca7dd5d4143537cfb2028d96d1c266f326e43b08.camel@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 11:56:00AM +0200, Sebastien Laveze wrote:
> My proposal includes handling PHC offset entirely in software. There is
> no way (and we agree on this :)) to change the PHC offset without
> impacting children virtual clocks.

That means no control over the phase of the output signals.  Super.
 
> Done in software, an offset adjustment has no impact at all on virtual
> clocks (since it can always be done atomically, not RMW).
> 
> So with, no hardware clock phase adjustment and limited frequency
> adjustments, 

But you can't make the end users respect that.  In many cases in the
wild, the GM offset changes suddenly for various reasons, and then the
clients slew at max adjustment.  So there is no expectation of
"limited frequency adjustments."

Thanks,
Richard


> we believe it can be made fully transparent to virtual
> clocks. And that would improve the current limitation of no adjustment
> all, and would unblock the support of features like Qbv for devices
> with a single clock.
> 
> Thanks,
> Sebastien
> 
