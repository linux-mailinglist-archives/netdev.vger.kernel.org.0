Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDA55E6A69
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 20:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbiIVSJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 14:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbiIVSJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 14:09:13 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1130610758E
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 11:09:12 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id t4so3381774wmj.5
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 11:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date;
        bh=MT55qMkXffaxT9P1GmtZh6zoVTupLtblScwaO0OZiLM=;
        b=hq9LXvYb4SgIiEFJx2D24Q0Nhq2MLaMjYZHQaBI3oSMV7FYRMh+yy6spQQfVYG5YEC
         ukRT42PT8qTIj4pnKgMNpW5MaJFJakX1VNuRh+ie4o4sXIAPt7mL0XefaTr4fU7zLiQn
         kgLHJIUYE8Ub+m5laBF7X7Dg+OX16um4T+k0/udsoiEIpoxjJq0G3do2HVN/atPg+zIf
         6L3haRaSNr3KYbn+ls2WubXEae85/b1ua5iuWuGbcHJ+6t9DmcIiXwkaPXQv2J+LFIKH
         e2oQglKL7aZljcla8wgFYiLA0Asb/+AN2mfZRCM2yL/fzUnmMrQP73UI+Nx26pZZPFj4
         t5mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=MT55qMkXffaxT9P1GmtZh6zoVTupLtblScwaO0OZiLM=;
        b=dnmfxSQVPmVn4+hj7WXUmniTK+URXr71ccetfUzX0DCny+6Mv03pcDiAYgXxLAnSBC
         Yd7HjlMPvVYY71qfDXT+5RAiSYIrTU3XdXrGV6wglUkp6KNGGt6DAAjjathQ2W2/ST8M
         94gTUT1S6eyrNVkXc54Wt5WFcatyK6V3V5FlB0DZzvixHwOb5wLgF5vazPHxxzbSRKu2
         XuX6ppTq3nxcGuiAlk0fWMUUCIBKVwUIHvzRGmF0337QAkYMNgHy3NeYRxaE6hGuy6Hu
         uY3wfroScPRRuwrXE7Jh0F+7e/rCeRwAooqImJCBI5WbO1E0CSnH/dReTuaViuf33BSv
         ZSxQ==
X-Gm-Message-State: ACrzQf1JOFXljzwd3yESVEsd4k4ZFPiwexRRjBckPaVnG7thgYiF4Ov5
        iFd4TuFu/P/SYCGNnJoYGVJS1HkBri8=
X-Google-Smtp-Source: AMsMyM6W1cA74rioah3xdt3fj1qnVrzrkdD+a+/jW+qdH5KtpPudo9a/HJgedjs8FJnKc7dnxg5tjg==
X-Received: by 2002:a05:600c:c7:b0:3b4:88ec:f980 with SMTP id u7-20020a05600c00c700b003b488ecf980mr3410554wmm.92.1663870150211;
        Thu, 22 Sep 2022 11:09:10 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.gmail.com with ESMTPSA id c8-20020a5d4148000000b0022af865810esm5664885wrq.75.2022.09.22.11.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 11:09:09 -0700 (PDT)
Message-ID: <632ca4c5.5d0a0220.34eef.f0aa@mx.google.com>
X-Google-Original-Message-ID: <Yyykwl8Qvqgz/6Dk@Ansuel-xps.>
Date:   Thu, 22 Sep 2022 20:09:06 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, mattias.forsblad@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH rfc v2 00/10] DSA: Move parts of inband signalling into
 the DSA
References: <20220922175821.4184622-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922175821.4184622-1-andrew@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 07:58:11PM +0200, Andrew Lunn wrote:
> This is an RFC patchset.
> 
> Mattias Forsblad proposal for adding some core helpers to DSA for
> inband signalling is going in a good direction, but there are a couple
> of things which i think can be better. This patchset offs an
> alternative to
> 
> patch 2/7: net: dsa: Add convenience functions for frame handling
> 
> and
> 
> patch 7/7 net: dsa: qca8k: Use new convenience functions
> 
> This patchset takes the abstraction further, putting more into the
> core. It also makes the qca8k fully use the abstraction unlike 7/7.
> 
> The end result has a slightly different structure, in that there is a
> struct dsa_inband of which qca8k has two instances of this. Doing this
> avoids the custom completion code. If qca8k can have multiple parallel
> request/replies in flight, it seems likely other devices can as well,
> so this should be part of the abstraction.
> 
> Since i don't have the qck8 hardware, i hope that lots of small
> patches make the review work easier, and finding the introduced bugs
> is quicker.
> 
> The MIB handling of the qc8k is somewhat odd. It would be nice to work
> on that further and try to make it better fit the model used
> here. That work can be done later, and probably is more invasive than
> the step by step approach taken here.
> 
> Another aim has been to make it easy to merge Mattias mv88e6xxx
> patches with this patchset. The basic API is the same, so i think it
> should be possible.
> 
> These are compile tested only....
> 
> This version addresses all the comments on the previous version except
> for:
> 
> Making the inband data structure short lived, allocated per request.
> This needs some more though.

Considering a low power system this can be problematic. Tagging already
cause perf regression, allocating the struct on top of the skb
allocation can cause even more perf regression if inband is also used
for port state polling.

> 
> Siliently truncating the reply when it is bigger than the response
> buffer.

This can be problematic and also silent truncation is asking for bugs
IMHO. These kind of special packet handling are well defined so anything
that diverge from the implementation is probably a corrupted request.

> 
> Adding documentation to dsa.rst.
> 
> Also, it is not known if the crash reported in the last patch is fixed
> or not.

Will test this and refer back to the replated patch if the crash is
still there.

> 
> This code can also be found in
> 
> https://github.com/lunn/linux v6.0-rc4-net-next-inband
> 
> Andrew Lunn (10):
>   net: dsa: qca8k: Fix inconsistent use of jiffies vs milliseconds
>   net: dsa: qca8k: Move completion into DSA core
>   net: dsa: qca8K: Move queuing for request frame into the core
>   net: dsa: qca8k: dsa_inband_request: More normal return values
>   net: dsa: qca8k: Drop replies with wrong sequence numbers
>   net: dsa: qca8k: Move request sequence number handling into core
>   net: dsa: qca8k: Refactor sequence number mismatch to use error code
>   net: dsa: qca8k: Pass error code from reply decoder to requester
>   net: dsa: qca8k: Pass response buffer via dsa_rmu_request
>   net: dsa: qca8: Move inband mutex into DSA core
> 
>  drivers/net/dsa/qca/qca8k-8xxx.c | 237 ++++++++-----------------------
>  drivers/net/dsa/qca/qca8k.h      |   8 +-
>  include/net/dsa.h                |  33 +++++
>  net/dsa/dsa.c                    |  89 ++++++++++++
>  4 files changed, 183 insertions(+), 184 deletions(-)
> 
> -- 
> 2.37.2
> 

-- 
	Ansuel
