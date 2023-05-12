Return-Path: <netdev+bounces-2074-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2AA970033D
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:02:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B203F1C2112D
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B59AA93A;
	Fri, 12 May 2023 09:02:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F75EDA
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:02:28 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFB5100FD;
	Fri, 12 May 2023 02:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Mggnu95n/RU6DeRgS9ZUs2b/avyHGbZvVWNqilcNijI=; b=MDA2vJcmlGYWbAYVWlbKScMTRY
	vF42WVOhOikWSi9jWbuFHQ1JtHvU+8G0TGE1XfkmCbjSEXOLHOVHrIJ0VnEFagkOI1H6/No9N+j4O
	bWS5qIDeN9+7jVQqNBdeLLEQV9cJTPdrn4oc3QMb1vAo1q3WAOb/RI8dV//oqci/88ItYS0mRLrbH
	+M7Lf+sPQWMHsM3p8dndw1zrdtj6CtRmEQiaKmgMd2CouTyywvldb1/ivBWaaqPCMiFY/9Knc1vbG
	PprqPQeiksn1ahH0l/mpmcEBqq2Fmy6SrZeBdJJkTGwCi3hUQyxwK6WBxkmKQ1Fn44mlmFlEfHbeg
	WP/aYyOQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35578)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pxOfA-00081X-H1; Fri, 12 May 2023 10:02:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pxOf7-0004vy-PP; Fri, 12 May 2023 10:02:05 +0100
Date: Fri, 12 May 2023 10:02:05 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Yan Wang <rk.code@outlook.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] net: mdiobus: Add a function to deassert reset
Message-ID: <ZF4AjX6csKkVJzht@shell.armlinux.org.uk>
References: <KL1PR01MB54486A247214CC72CAB5A433E6759@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <KL1PR01MB54486A247214CC72CAB5A433E6759@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 03:08:53PM +0800, Yan Wang wrote:
> +	gpiod_set_value_cansleep(reset, gpiod_is_active_low(reset));
> +	fsleep(reset_assert_delay);
> +	gpiod_set_value_cansleep(reset, !gpiod_is_active_low(reset));

Andrew, one of the phylib maintainers and thus is responsible for code
in the area you are touching. Andrew has complained about the above
which asserts and then deasserts reset on two occasions now, explained
why it is wrong, but still the code persists in doing this.

I am going to add my voice as another phylib maintainer to this and say
NO to this code, for the exact same reasons that Andrew has given.

You now have two people responsible for the code in question telling
you that this is the wrong approach.

Until this is addressed in some way, it is pointless you posting
another version of this patch.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

