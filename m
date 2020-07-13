Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEFA21D7B6
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 16:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbgGMOBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 10:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729695AbgGMOBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 10:01:22 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEF9C061755;
        Mon, 13 Jul 2020 07:01:22 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id i14so6030034pfu.13;
        Mon, 13 Jul 2020 07:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cCXKJLHZKOo9WepEq5/xoL1jF7eCdGbwLR/OdmMlRgE=;
        b=UcZcvj6tdkMVOyI3IFIQG/8vSKdQqFGSaN+JmaVwOF9GbrNpDl52u97EGTC6WttrCB
         +uq4lGa7Ki8pWAqvg/EdWy7KqgMrlKQb9DCYCLI4okUb/lbc0AbiuAYzQZyWERS/Ckhy
         3bA943nAcgAIsMRA48e1dvIRLkAF//62qJ44RIuEj9mEbYNQu/+REF5b4paeoqxnWzsR
         JU4I1Qr4GfVS0ABjiDG+geZ+1TySNVXkqMCwta91/jegJF/Qo3NHN25Rpf/QJZgo8aRD
         FPpraNnOvK59kpPviG/wb9PTg4tt56zP1uY5XGqWGzYJzZTI5ADqEqk5TATkUz0ZUOJW
         IdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cCXKJLHZKOo9WepEq5/xoL1jF7eCdGbwLR/OdmMlRgE=;
        b=XEm0ssD7Bz3C7mCOhEE50wSF+TLY3bDYUqKA8BdWsDZIW+wFJmYxroaA7jq6uUZDiQ
         7ona2cXC34rWsduehv7fsX6dmViaFNMC9o+38PbPqScctVBooMg/ZaQii0hzkKjbVxDm
         lp3dbOBdImfret99P4PTJeIy7q/YyeKiGHqTWjazdMH1jVmPVNmCM4B5qLXpPzGPpwL7
         tRdAGplN0JvGm2+lsxcFvCCXvcWicjinLbiTQI8cB3M1xJkQQW2A38l+1qSKWJwJ7M4A
         WUisQhY9FMV2VCrnRnGUMRsGRcOqB/F+YTtO4o/vQ8Ytqx5YAsUYOieU8f7MgCr+JAz/
         3ahQ==
X-Gm-Message-State: AOAM533/juXgaFY0L55WjPmdXLifoZ9cwyL7BdAGm94MNHV3mVzadMtR
        m3wlIwcZ3acQtJXlzEEwoZCn7rKF
X-Google-Smtp-Source: ABdhPJxqegTpxm4H1FI4lALz8ckkFIs7OKoYhLjveV0eADTl4m+2jIxGOwdCniuKxIKUeAb3ineT9w==
X-Received: by 2002:a63:7c4d:: with SMTP id l13mr69353235pgn.12.1594648881800;
        Mon, 13 Jul 2020 07:01:21 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id r2sm14185798pfh.106.2020.07.13.07.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 07:01:20 -0700 (PDT)
Date:   Mon, 13 Jul 2020 07:01:12 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v1 4/8] net: dsa: hellcreek: Add support for hardware
 timestamping
Message-ID: <20200713140112.GB27934@hoboy>
References: <20200710113611.3398-1-kurt@linutronix.de>
 <20200710113611.3398-5-kurt@linutronix.de>
 <20200713095700.rd4u4t6thkzfnlll@skbuf>
 <87k0z7n0m9.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0z7n0m9.fsf@kurt>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 12:57:34PM +0200, Kurt Kanzenbach wrote:
> Hi Vladimir,
> 
> On Mon Jul 13 2020, Vladimir Oltean wrote:
> >> +/* Get a pointer to the PTP header in this skb */
> >> +static u8 *parse_ptp_header(struct sk_buff *skb, unsigned int type)
> >
> > Maybe this and the function from mv88e6xxx could share the same
> > implementation somehow.
> 
> Actually both functions are identical. Should it be moved to the ptp
> core, maybe? Then, all drivers could use that. I guess we should also
> define a PTP offset for the reserved field which is accessed in
> hellcreek_get_reserved_field() just with 16 instead of a proper macro
> constant.

I support re-factoring the code that parses the PTP header.  Last time
I looked, each driver needed slightly different fields, and I didn't
see an easy way to accommodate them all.

> > I would like to get some clarification on whether "SKBTX_IN_PROGRESS"
> > should be set in shtx->tx_flags or not. On one hand, it's asking for
> > trouble, on the other hand, it's kind of required for proper compliance
> > to API pre-SO_TIMESTAMPING...
> 
> Hm. We actually oriented our code on the mv88e6xxx time stamping code base.

Where in mv88e6xxx does the driver set SKBTX_IN_PROGRESS?

I don't think it makes sense for DSA drivers to set this bit, as it
serves no purpose in the DSA context.

Thanks,
Richard
