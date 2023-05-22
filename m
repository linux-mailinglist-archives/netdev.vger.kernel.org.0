Return-Path: <netdev+bounces-4425-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E805E70CACD
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 22:21:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94A052810EA
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:21:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C16D8174C6;
	Mon, 22 May 2023 20:21:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AADF171CF
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779A8C433D2;
	Mon, 22 May 2023 20:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684786906;
	bh=Qs8Bno6XbgU5T5ehuLhM2YkCve6DbYxcrB9KbkAfx8E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kO7FGAHJ3nOoBDWyGgiHEyoAwhjHfdt7GZ0AqMUfAcn0w4BXGNag409IOgEcsk6iu
	 BHg3++7erV0GvoEBXLT+2vnh6sXCCMITU0s646DxQWZYIUpnZx0RtUmTOWLzF/3fnx
	 bOwqEfl3ZPwXtDsGZyZHrN6AeZumHJayvchpH89X3XkGlrLwl4VYUY60LvIqwozGT2
	 kssUyi7SPWSugx3iSKL8vdLq1G8aCNI1wQ5Z3R0DtpbyRDD9/qDKimlBGpZesXDFTj
	 iaQRJdd5nNIar09u+cwCIOroFCuRl7IAQZhr5orravXu4FH/GClmvirBs2q1lzpYK/
	 LsYcHZYTDT/qQ==
Date: Mon, 22 May 2023 13:21:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>,
 Vladimir Oltean <vladimir.oltean@nxp.com>, "Russell King (Oracle)"
 <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>, =?UTF-8?B?S8O2cnk=?=
 Maincent <kory.maincent@bootlin.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "glipus@gmail.com" <glipus@gmail.com>,
 "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
 "vadim.fedorenko@linux.dev" <vadim.fedorenko@linux.dev>,
 "gerhard@engleder-embedded.com" <gerhard@engleder-embedded.com>,
 "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
 "krzysztof.kozlowski+dt@linaro.org" <krzysztof.kozlowski+dt@linaro.org>,
 "robh+dt@kernel.org" <robh+dt@kernel.org>, "Keller, Jacob E"
 <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <20230522132144.018b375b@kernel.org>
In-Reply-To: <ZGvK0aBhluD0OxWp@hoboy.vegasvil.org>
References: <ZF1WS4a2bbUiTLA0@shell.armlinux.org.uk>
	<20230511210237.nmjmcex47xadx6eo@skbuf>
	<20230511150902.57d9a437@kernel.org>
	<20230511230717.hg7gtrq5ppvuzmcx@skbuf>
	<20230511161625.2e3f0161@kernel.org>
	<20230512102911.qnosuqnzwbmlupg6@skbuf>
	<20230512103852.64fd608b@kernel.org>
	<20230519132802.6f2v47zuz7omvazy@skbuf>
	<20230519132250.35ce4880@kernel.org>
	<SJ1PR11MB61800D87C61ADC94C57DB237B8439@SJ1PR11MB6180.namprd11.prod.outlook.com>
	<ZGvK0aBhluD0OxWp@hoboy.vegasvil.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 May 2023 13:04:33 -0700 Richard Cochran wrote:
> On Mon, May 22, 2023 at 03:56:36AM +0000, Zulkifli, Muhammad Husaini wrote:
> 
> > A controller may only support one HW Timestamp (PHY/Port) and one MAC Timestamp 
> > (DMA Timestamp) for packet timestamp activity. If a PTP packet has used the HW Timestamp (PHY/Port),   
> 
> This is wrong.
>
> The time stamping setting is global, at the device level, not at the
> socket.  And that is not going to change.  This series is about
> selecting between MAC/PHY time stamping globally, at the device level.

What constitutes a device?

I'd present the facts differently. This series selects which _device_
(MAC or PHY) is responsible for delivering timestamps for a given
netdev.

HW which supports different timestamping points with different
capabilities is commonplace, so an API in this vicinity should be
extended to support the configuration. Today it's configured via device
private flags, or some out-of-tree tooling, which helps nobody :|

