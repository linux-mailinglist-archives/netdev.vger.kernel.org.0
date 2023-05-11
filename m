Return-Path: <netdev+bounces-1868-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F90A6FF5E6
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:27:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D5FE281735
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:26:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F5DF63B;
	Thu, 11 May 2023 15:26:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D392629
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F4EC433D2;
	Thu, 11 May 2023 15:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683818815;
	bh=+7QZL904BwNTluSbT6if/okhWOSRPnmftg11VAD2xDo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AwJPvKdeQ/qOhlz8YnKglbSmyFnTBjI7CB5q7FzWN+mvNRm4N3P30F2UfnADhhJRS
	 iwOUcLAR3LNlFH5U0IAz2G/pMcS5fk1Sgmmv53176KUpUpqN/7Wwt121Hfw/of3e8Q
	 W8CK04fSZUAQWJsljL/ADCV+IevNDFV/5XJXZygQgSFL3INYYodZyoEVNdi5hEsQwO
	 lbiEQXv6xevyJvoXuCbogi6eToMRUcM+1sF6UdgcG+UAUp9IZrrdKLWcAGTXAtCcDJ
	 2uUS+Go9tvDCzk3RFhldV/FjFNsr/9FC9EJ75CNQFExOt7NqnQ2U8be84ztcNRSsUI
	 y4BOWzybO+Cjg==
Date: Thu, 11 May 2023 08:26:54 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc: Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>,
 Jonathan Lemon <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
 "Olech, Milena" <milena.olech@intel.com>, "Michalik, Michal"
 <michal.michalik@intel.com>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
 <mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, Vadim Fedorenko
 <vadim.fedorenko@linux.dev>
Subject: Re: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Message-ID: <20230511082654.44883ebe@kernel.org>
In-Reply-To: <MN2PR11MB466446F5594B3D90C7927E719B749@MN2PR11MB4664.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
	<20230428002009.2948020-2-vadfed@meta.com>
	<ZFOe1sMFtAOwSXuO@nanopsycho>
	<MN2PR11MB466446F5594B3D90C7927E719B749@MN2PR11MB4664.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 May 2023 07:38:04 +0000 Kubalewski, Arkadiusz wrote:
> >>+  -
> >>+    type: enum
> >>+    name: event
> >>+    doc: events of dpll generic netlink family
> >>+    entries:
> >>+      -
> >>+        name: unspec
> >>+        doc: invalid event type
> >>+      -
> >>+        name: device-create
> >>+        doc: dpll device created
> >>+      -
> >>+        name: device-delete
> >>+        doc: dpll device deleted
> >>+      -
> >>+        name: device-change  
> >
> >Please have a separate create/delete/change values for pins.
> >  
> 
> Makes sense, but details, pin creation doesn't occur from uAPI perspective,
> as the pins itself are not visible to the user. They are visible after they
> are registered with a device, thus we would have to do something like:
> - pin-register
> - pin-unregister
> - pin-change
> 
> Does it make sense?

I missed this, notifications should be declared under operations.

Please look at netdev.yaml for an example.

I thought about implementing this model where events are separate
explicitly but I think it's an unnecessary complication.

