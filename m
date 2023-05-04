Return-Path: <netdev+bounces-467-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09B516F77DB
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 23:14:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9D75280E5B
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B572C12F;
	Thu,  4 May 2023 21:14:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DB8156C7
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 21:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A709FC4339C;
	Thu,  4 May 2023 21:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683234871;
	bh=8NOLMY9E+r15G2I3/A026Dyulc4ImiJHWUg6XcWgfyI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t4TWIVYHhtsEFfUJAzEg0w9Sb4loUXlSqj6vnRI5ivwjqgn22gaISAkzPrx0xbUc2
	 vp3PUkNCu655QWPNrm/W9BLGALHgTdLZUvW50At2dPuM7lXv3PDESbJIYbHAjlGLTc
	 gM37aQQU1sZ1F37k9ikvxCZXrkyde/9T5KmtspbpyOc/U1AUX117gdD58vwA9c9rGI
	 MefbSjBCU0+cLVxeWJcCUARbpPWV++sK46hlSEUd71h3SaD5SPQ/CVfcCAq2Ntk0EN
	 WxV547VbXuyf1PtHw+/sFecbt3DiCdp5HL7ErrKJpdwXu5ylNyeUtMeqswY2+IWRWA
	 ylO3BWa+oNK+g==
Date: Thu, 4 May 2023 14:14:30 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: brett.creeley@amd.com, netdev@vger.kernel.org, drivers@pensando.io
Subject: Re: [PATCH RFC net-next 0/2] pds_core: add switchdev and tc for
 vlan offload
Message-ID: <20230504141430.5eafa505@kernel.org>
In-Reply-To: <ad5bf0ee-9d93-e0c0-cb22-7b572b75d6a2@amd.com>
References: <20230427164546.31296-1-shannon.nelson@amd.com>
	<20230502164336.1e8974af@kernel.org>
	<ccfccde0-9753-1e54-75b0-f6f1d683d765@amd.com>
	<20230503182708.70f479d9@kernel.org>
	<ad5bf0ee-9d93-e0c0-cb22-7b572b75d6a2@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 May 2023 13:51:13 -0700 Shannon Nelson wrote:
> On 5/3/23 6:27 PM, Jakub Kicinski wrote:
> > You mean setting vlan encap via devlink?
> > I don't know why you'd do that. It will certainly aggravate me,
> > and I doubt anyone will care/support you.  
> 
> We're trying to solve what would seem to be a simple problem for our 
> customer: how to do basic vlan encap/decap on all traffic going in and 
> of a VF. 

Offload bridge.

If your customer doesn't want the bridge offload you can decide 
to ship an out of tree driver for them with whatever deprecated 
APIs you please.

> With no host PF traffic, the legacy ip-link and the newer 
> switchdev+tc solutions don't fit.  As this is VF port setup, and devlink 
> is meant for device setup, it would seem to fit in the devlink port 
> function model similar to the setting of the port hw_addr.  What am I 
> missing that makes this an unacceptable answer?
> 
> I understand you don't like this devlink port function suggestion, but 
> when I go back to negotiate with internal management, architects, etc, I 
> can get a lot further with them if I have a technical explanation of why 
> this is not acceptable.  So, at the risk of further aggravating you, can 
> I request a little more detail on why this is a bad idea?

The direction of the community was to use offload of standard networking
concepts like switching, routing and flow matching for probably a decade
now.

