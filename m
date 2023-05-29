Return-Path: <netdev+bounces-6039-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53475714838
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 12:51:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6FCF280E20
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 10:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 042841115;
	Mon, 29 May 2023 10:51:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA0B10E2
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 10:51:38 +0000 (UTC)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B98DC2;
	Mon, 29 May 2023 03:51:37 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-5149c76f4dbso1852933a12.1;
        Mon, 29 May 2023 03:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685357496; x=1687949496;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8LCe2EKUc/HUKv8Vdwd3IAxJsI6uVh4H8TlALy41nxg=;
        b=dnlxLcu8oG8H068277xPQWzNdEDRqJmbMvM5ZfwSxRkTiDCEeCtEtl3mj3KSwsfm9w
         NMIf/QkQGXI0cCFKAsMxpCRPixUQZMu/6w03AU0aVIFXwPRpLWl/9qP14Mc0hEdcWclf
         hOhNyUzNoKw/GKBJ4B7S+HUrfpdYeUGWxeGT+CABsYNsmOrOEV7FUKElHjLiVAHgudrM
         oW24eRCXgCqo7L0smmrqhqyo1yNdnoylRyMKcfqTB12SHOO3WLfuIUbjSqYLnyblBruy
         SIyKCV6x8ON5iqBR3G2popkaxixdIXoPLFRf9VUF7wOAA+jZIL3tInUy8YIyZ2mkg0S2
         iZPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685357496; x=1687949496;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8LCe2EKUc/HUKv8Vdwd3IAxJsI6uVh4H8TlALy41nxg=;
        b=Nxj6uxJO0OD/5M4lD+yODYLl0VHM5GJ1kXzIWTNoJi7hKkxyjrOqRN4yxf7jslt+1D
         PQfDLvALBJsvdRhRkQ7BV6UMgWO3aTDVZfhOF1t5BQanSbE+oBPqF19IY8j8jjkLn5u+
         vD7PSRSshxKFh4obmDt39n2ENrkLb6tc4n4XPPwxwStqgRkfDfnh1cuyk8yI58Dvg1BA
         /sIDScti+/d4mpkxr+cLvAPSsy+EdiIJGLlSBXj3a4NPHVPoFvLgLMIIGKMyMgOIrUFm
         ajB04mYoGatlOeX7lg8IeDTMNwALy2YHYEYTxB0tZbQZ0yzYo9Z+JlSDe7gYGiOF3/Rx
         AkPA==
X-Gm-Message-State: AC+VfDwMP5y85QaTNDaJv6V5JiVYS4UYMdoUnu/jTeV/9iLzV2jMwbdS
	euYrXvC8RZS+Uc7X6Fjhupk=
X-Google-Smtp-Source: ACHHUZ61VpXTU+I9Rd/KQgtSJUXweX6b1D99k1qn7ca3qHpBQXMp5VZ7g/3eSnOI6TRPtei4NaJk9Q==
X-Received: by 2002:a17:907:987:b0:96a:6723:da47 with SMTP id bf7-20020a170907098700b0096a6723da47mr9974841ejc.43.1685357495394;
        Mon, 29 May 2023 03:51:35 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id m13-20020a170906160d00b0095342bfb701sm5887645ejd.16.2023.05.29.03.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 03:51:35 -0700 (PDT)
Date: Mon, 29 May 2023 13:51:32 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Lukasz Majewski <lukma@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Duyck <alexander.duyck@gmail.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] dsa: marvell: Add support for mv88e6071 and 6020
 switches
Message-ID: <20230529105132.h673mnjddubl7und@skbuf>
References: <20230523142912.2086985-1-lukma@denx.de>
 <20230529110222.68887a31@wsk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529110222.68887a31@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Lukasz,

On Mon, May 29, 2023 at 11:02:22AM +0200, Lukasz Majewski wrote:
> Dear All,
> 
> > After the commit (SHA1: 7e9517375a14f44ee830ca1c3278076dd65fcc8f);
> > "net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220, 6250,
> > 6290" the error when mv88e6020 or mv88e6071 is used is not present
> > anymore.
> > 
> 
> Are there any more comments for this patch set?

Has your email client eaten these comments too?

https://lore.kernel.org/netdev/c39f4127-e1fe-4d38-83eb-f372ca2ebcd3@lunn.ch/
| On Wed, May 24, 2023 at 03:48:02PM +0200, Andrew Lunn wrote:
| > > > Vladimir indicates here that it is not known how to change the max MTU
| > > > for the MV88E6250. Where did you get the information from to implement
| > > > it?
| > > 
| > > Please refer to [1].
| > > 
| > > The mv88e6185_g1_set_max_frame_size() function can be reused (as
| > > registers' offsets and bits are the same for mv88e60{71|20}).
| > 
| > So you have the datasheet? You get the information to implement this
| > from the data sheet?
| > 
| >      Andrew

https://lore.kernel.org/netdev/ZG4E+wd03cKipsib@shell.armlinux.org.uk/
| On Wed, May 24, 2023 at 01:37:15PM +0100, Russell King (Oracle) wrote:
| > On Wed, May 24, 2023 at 02:17:43PM +0200, Lukasz Majewski wrote:
| > > Please refer to [1].
| > > 
| > > The mv88e6185_g1_set_max_frame_size() function can be reused (as
| > > registers' offsets and bits are the same for mv88e60{71|20}).
| > > 
| > > After using Vladimir's patch there is no need to add max_frame size
| > > field and related patches from v6 can be dropped.
| > 
| > However, you haven't responded to:
| > 
| > https://lore.kernel.org/all/ZGzP0qEjQkCFnXnr@shell.armlinux.org.uk/
| > 
| > to explain why what you're doing (adding this function) is safe.
| > 
| > Thanks.
| > 
| > -- 
| > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
| > FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

