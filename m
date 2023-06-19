Return-Path: <netdev+bounces-12081-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74AF1735EBC
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 22:48:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A68D91C20357
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 20:48:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DAA95234;
	Mon, 19 Jun 2023 20:48:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA3FDF6B
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 20:48:44 +0000 (UTC)
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCD010D0;
	Mon, 19 Jun 2023 13:48:21 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-311099fac92so4577862f8f.0;
        Mon, 19 Jun 2023 13:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687207700; x=1689799700;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=eG/q3bTcWJveMElwbHmeYU1bo7tO0X8xnhpRm1N5g14=;
        b=Huie7AkoX9OHjyqyj8+wbnfiluB8hE+LGKpoCwfRw2gjDi+73SggGwkl4V4lzXrq1c
         hmC7jFpkdBFpfEKVZiQ+mY0DaNEX90T4M21iFfRLvv8m76tgWvsAc1jOQ63DsORma5Po
         kLIxU5CrZAi6epZXe5+zWpbK8atFrmkoyEWHIrN1+PPhJKZ+kRENYcVHAwisB8yiGVnu
         +M5bjFuBfeIVdCjPSFIiIipypmYlr9sAZ6gx7jN5OTJh+Nv4R0x3VeEmqPvisTNn+cRM
         9WDlmhQMVpeQ4d9DQVXYyhR6eGFUWuqH+L6Xr7IlTAhjU+RIv7/F8Yzu15XkDJw4gdMC
         jJFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687207700; x=1689799700;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eG/q3bTcWJveMElwbHmeYU1bo7tO0X8xnhpRm1N5g14=;
        b=Cqx2vK9RVLoGW8yzB5z8OYd+yRdmPYczcx8xdFDszocioniY07fQWk80UmLuD7ecA9
         ysarwA3Yp6bOinn7x+MzHo1/bIdWlurcTuvspeF7FZvg51Vk+eT8HsWy7W+ZexDsLDCu
         gsxtS8WPPPbBqkYmPi2ddtKwVrGYui725hoSoTon1+9rVVMCBNprHVGHcG/42jFyYTKi
         UBqlKjpgmvnks0H4O+mmTzl1BHBTOWpYxn+e9ct2xKIWaHmg818ItiMZCGxXo5qPb699
         5yzK4keOSt2sAHTH47Dkd/IcLTetAZzJTZTnf9C6E5RzfZMfSUWUFNqaM97arS0lcwEH
         tCGw==
X-Gm-Message-State: AC+VfDw08H5ufVk5U5UN0SC2AepxrKqPPT+qDW9NP0+0E9Kl4joWdKpl
	oerq404at0Wqj5ix6mTfISQ=
X-Google-Smtp-Source: ACHHUZ6kBE6BjYmWKc4YmkTEYlMYrDS5l2tXUetkuCWW+M4SwSxjVvZly4xBTwOeLiy4LP/RivkCIA==
X-Received: by 2002:adf:e848:0:b0:30a:eac4:26a0 with SMTP id d8-20020adfe848000000b0030aeac426a0mr8952293wrn.18.1687207699809;
        Mon, 19 Jun 2023 13:48:19 -0700 (PDT)
Received: from Ansuel-xps. (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.gmail.com with ESMTPSA id n15-20020a5d4c4f000000b003111025ec67sm430542wrt.25.2023.06.19.13.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 13:48:19 -0700 (PDT)
Message-ID: <6490bf13.5d0a0220.f1a5a.2c4a@mx.google.com>
X-Google-Original-Message-ID: <ZJC/DyLpLry69PLB@Ansuel-xps.>
Date: Mon, 19 Jun 2023 22:48:15 +0200
From: Christian Marangi <ansuelsmth@gmail.com>
To: Simon Horman <simon.horman@corigine.com>
Cc: Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Yang Li <yang.lee@linux.alibaba.com>, linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v4 0/3] leds: trigger: netdev: add additional
 modes
References: <20230617115355.22868-1-ansuelsmth@gmail.com>
 <ZJC6GaZO7DgdMmIv@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJC6GaZO7DgdMmIv@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 10:27:05PM +0200, Simon Horman wrote:
> On Sat, Jun 17, 2023 at 01:53:52PM +0200, Christian Marangi wrote:
> > This is a continue of [1]. It was decided to take a more gradual
> > approach to implement LEDs support for switch and phy starting with
> > basic support and then implementing the hw control part when we have all
> > the prereq done.
> > 
> > This should be the final part for the netdev trigger.
> > I added net-next tag and added netdev mailing list since I was informed
> > that this should be merged with netdev branch.
> > 
> > We collect some info around and we found a good set of modes that are
> > common in almost all the PHY and Switch.
> > 
> > These modes are:
> > - Modes for dedicated link speed(10, 100, 1000 mbps). Additional mode
> >   can be added later following this example.
> > - Modes for half and full duplex.
> > 
> > The original idea was to add hw control only modes.
> > While the concept makes sense in practice it would results in lots of 
> > additional code and extra check to make sure we are setting correct modes.
> > 
> > With the suggestion from Andrew it was pointed out that using the ethtool
> > APIs we can actually get the current link speed and duplex and this
> > effectively removed the problem of having hw control only modes since we
> > can fallback to software.
> > 
> > Since these modes are supported by software, we can skip providing an
> > user for this in the LED driver to support hw control for these new modes
> > (that will come right after this is merged) and prevent this to be another
> > multi subsystem series.
> > 
> > For link speed and duplex we use ethtool APIs.
> > 
> > To call ethtool APIs, rtnl lock is needed but this can be skipped on
> > handling netdev events as the lock is already held.
> > 
> > [1] https://lore.kernel.org/lkml/20230216013230.22978-1-ansuelsmth@gmail.com/
> 
> Hi Christian,
> 
> I am sorry if I am missing something obvious here,
> but this series does not appear to apply on top of net-next.
> 
> Please consider rebasing and reposting.
> 
> As you probably know, you can include the reviewed-by tags
> provided by Andrew for this posting, unless there are
> substantial changes.
> 
> -- 
> pw-bot: changes-requested
> 

Hi, sorry for the mistake. I just sent v5 and added the additional
Review-by tag.

-- 
	Ansuel

