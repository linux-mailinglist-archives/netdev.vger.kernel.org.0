Return-Path: <netdev+bounces-1424-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B90CF6FDBCA
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:36:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD8651C20B2D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7D7220B43;
	Wed, 10 May 2023 10:36:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A1BA5D
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 10:36:33 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDB13582
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 03:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=A2vCEQLnfXVbJ8RHsuKwTFO/IiTYnwEmsrLt/OwdfOc=; b=PikN+kSBsdcDV+QVSI/8qHw7R2
	jsRTVELohKwgUTcDT0uDd/3zPmyKrDI6NF967YwIbfoEGgkCbbiZynpG7y8ZIIwKqzOSDgvK4CtMX
	8lRh23F03ATAhy5fHVtmPsGuegqRfKw+IlCAj2ZAoi+QXeBj/UgdiZSMOgfBoCN7GsxFdjTgVMKI1
	PM1/aZcvjPtrSezGmYTKeC/pUgm5B7ENpNSV8v8tnBjPKjh/4tQQc8zxqDIOM13pNMH1K0Zpeu6Lv
	mz2qDF5vEhmhJrB40KDergW1u7WqUJohAbdiX0icoVDQaDpq8w4SJDIPh92knq4Y7ljjKLeq/KoxM
	lpOySbsw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37554)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pwhBM-0004lf-Fp; Wed, 10 May 2023 11:36:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pwhBK-0002ul-TM; Wed, 10 May 2023 11:36:26 +0100
Date: Wed, 10 May 2023 11:36:26 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH net-next 0/6] net: mvneta: reduce size of TSO header
 allocation
Message-ID: <ZFtzqnpP31RuAESr@shell.armlinux.org.uk>
References: <ZFtuhJOC03qpASt2@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFtuhJOC03qpASt2@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 11:14:28AM +0100, Russell King (Oracle) wrote:
> Hi,
> 
> With reference to
> https://forum.turris.cz/t/random-kernel-exceptions-on-hbl-tos-7-0/18865/
> https://github.com/openwrt/openwrt/pull/12375#issuecomment-1528842334

I seem to have forgotten Eric's r-b from the RFC posting, so as nothing
has changed, I'll add it here and hope patchwork picks it up:

Reviewed-by: Eric Dumazet <edumazet@google.com>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

