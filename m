Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A00B1F420D
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 19:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731698AbgFIRTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 13:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729551AbgFIRTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 13:19:46 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB72EC05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 10:19:45 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id j1so10194125pfe.4
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 10:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pS3fXxlqQZ1qpuPBeNYDB/9xxIJhEcPh7OngVI7wDQM=;
        b=LqHOcWuaretR3F7j6V1cZg3Pe+dpy0Uucy+WLGNPBzxuUK+GR+f4ut+G6xbh0LURpd
         O1UA4aPP4qREUSmh9IWCn0ckBp2l9czR5ryTYPGYNeyddQ2pKIuP3T7ZuCriqrxTBXY6
         mb4WY1gHj1MNX4S7C9ldXj5VzqtIYzIU6xvOFch9/jzXbYwqIVupOg7sIf4oi+MXFYfM
         yEccXskW7tkw54JxFhTZvYESrno7n1ufHuVkbPq/rklcFioiA0pKWsu042fwJzmQ5o6M
         1kZxDUaLeUSMUXd3LF2rqPwSWlSbf+eZ9ebCLb2b6WZ5rmVQkPp18x8tcCoDs49KE4WE
         INyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pS3fXxlqQZ1qpuPBeNYDB/9xxIJhEcPh7OngVI7wDQM=;
        b=CQVq3HVa5tXJqdFn4hi/owETx4dDp20yjlikRRZ9ziypJcF9cy4SL9BmCyIQkOfXPG
         ElctET9SUTD17PeeJrcTLsd/YLW8TsUJXDw2vieGEpslMrs9LpIpnR1hvGeasZy8VfYI
         qZBX6ZtOblCy833XQu4EBtiV2qqIFdWcxu31k1Fr9/910osSltGSET0aUz4/t6VTZxeI
         D2mIAgTb617MRjNMEeZF4OwprqVtnwOPIuVyVcg6y6rUiULd8Fxjly9NofL8ZcVyQNSU
         dPFnGy1V2gqbty0Fd1deOn1Wg3FIdWhGTruU38GlLM/JfFvZoXSgppm/TJiuu5j38wSB
         VJkg==
X-Gm-Message-State: AOAM5307YmkZG9fHxogSxz85H+QymNml08QwHFp2KGDRm+cpYXEc7Dyg
        iWRwqvAhY8oHCIMlbUTjFp5rmw==
X-Google-Smtp-Source: ABdhPJzUWQw08dzF+hQyYORg3Kzta5U3cP3gTCT2NcJJzsUgAa6pwkXSNLsSb6HZi1DU032775KyKA==
X-Received: by 2002:a05:6a00:1494:: with SMTP id v20mr26724761pfu.150.1591723185179;
        Tue, 09 Jun 2020 10:19:45 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id i37sm1935829pgl.68.2020.06.09.10.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 10:19:44 -0700 (PDT)
Date:   Tue, 9 Jun 2020 10:19:35 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Miller <davem@davemloft.net>
Cc:     o.rempel@pengutronix.de, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, corbet@lwn.net,
        mkubecek@suse.cz, linville@tuxdriver.com, david@protonic.nl,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux@armlinux.org.uk, mkl@pengutronix.de,
        marex@denx.de, christian.herber@nxp.com, amitc@mellanox.com,
        petrm@mellanox.com
Subject: Re: [PATCH ethtool v1] netlink: add master/slave configuration
 support
Message-ID: <20200609101935.5716b3bd@hermes.lan>
In-Reply-To: <20200607.164532.964293508393444353.davem@davemloft.net>
References: <20200526091025.25243-1-o.rempel@pengutronix.de>
        <20200607153019.3c8d6650@hermes.lan>
        <20200607.164532.964293508393444353.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 07 Jun 2020 16:45:32 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Hemminger <stephen@networkplumber.org>
> Date: Sun, 7 Jun 2020 15:30:19 -0700
> 
> > Open source projects have been working hard to remove the terms master and slave
> > in API's and documentation. Apparently, Linux hasn't gotten the message.
> > It would make sense not to introduce new instances.  
> 
> Would you also be against, for example, the use of the terminology
> expressing the "death" of allocated registers in a compiler backend,
> for example?
> 
> How far do you plan take this resistence of terminology when it
> clearly has a well defined usage and meaning in a specific technical
> realm which is entirely disconnected to what the terms might imply,
> meaning wise, in other realms?
> 
> And if you are going to say not to use this terminology, you must
> suggest a reasonable (and I do mean _reasonable_) well understood
> and _specific_ replacement.
> 
> Thank you.

How many times have you or Linus argued about variable naming.
Yes, words do matter and convey a lot of implied connotation and meaning.

Most projects and standards bodies are taking a stance on fixing the
language. The IETF is has proposed making changes as well.

There are a very specific set of trigger words and terms that
should be fixed. Most of these terms do have better alternatives.

A common example is that master/slave is unclear and would be clearer
as primary/secondary or active/backup or controller/worker.

Most of networking is based on standards. When the standards wording changes
(and it will happen soon); then Linux should also change the wording in the
source, api and documentation.


See:


[0] - <https://www.cs.cmu.edu/~mjw/Language/NonSexist/vuw.non-sexist-language-guidelines.txt>, <https://twitter.com/justkelly_ok/status/933011085594066944>
[1] - <https://github.com/django/django/pull/2692>
[2] - <https://bugs.python.org/issue34605>
[3] - <https://github.com/rust-lang-deprecated/rust-buildbot/issues/2>, <https://github.com/rust-community/foss-events-planner/issues/58>
[4] - <https://twitter.com/ISCdotORG/status/942815837299253248>
[5] - <https://gitlab.gnome.org/GNOME/geary/issues/324>
[6] - https://mail.gnome.org/archives/desktop-devel-list/2019-April/msg00049.html
[7] - https://www.ietf.org/archive/id/draft-knodel-terminology-01.txt
