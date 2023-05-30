Return-Path: <netdev+bounces-6277-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 742487157D7
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:02:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 160FC1C20B84
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 08:02:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69F9F125DA;
	Tue, 30 May 2023 08:02:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C19A125C4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:02:02 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762C7A8
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685433721; x=1716969721;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XkDnCkZNz58YuZx28XBiYswNlrmkkiuTTE2FYZ29pmI=;
  b=tAwEwp1fdlyCCstmWg+gUF/WavlxaS1AfFGDtL50vut5ElaLJkgo1jw1
   2b2JLgY/fDJgYgjRKOGguV2FAZJaxq5t643r9OZLR1sttdS8JjokxbIP4
   AZSjFFDTdIN0/Sgp8x4re8Yyi2zZdbE1wgxC2fhzDI9wz7nWRQnbSufq4
   KJKq6pqlklvwne4Q1mRHkw9kxhAwth8sU0Cm5jQ3KWFKSgpUOIJ6QazH6
   3tvu4Aq9ogA4LVqFfl3pY0/7blIefoX/kFCPZ+gC5jvxuHGtWO0nl31Up
   H+hIj/z19J/GONtU96V70no9JaxUMJ0uUSr9WU8G9LSl6R7psuJOOolTp
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,203,1681196400"; 
   d="scan'208";a="213672300"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 May 2023 01:02:00 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 30 May 2023 01:01:58 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 30 May 2023 01:01:56 -0700
Date: Tue, 30 May 2023 08:01:52 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: Petr Machata <petrm@nvidia.com>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v2 2/8] dcb: app: modify dcb-app print
 functions for dcb-rewr reuse
Message-ID: <ZHWtcJiVlUmfLrE1@DEN-LT-70577>
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
 <20230510-dcb-rewr-v2-2-9f38e688117e@microchip.com>
 <87leh75aek.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87leh75aek.fsf@nvidia.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

 > > Where dcb-app requires protocol to be the printed key, dcb-rewr requires
> > it to be the priority. Adapt existing dcb-app print functions for this.
> >
> > dcb_app_print_filtered() has been modified, to take two callbacks; one
> > for printing the entire string (pid and prio), and one for the pid type
> > (dec, hex, dscp, pcp). This saves us for making one dedicated function
> > for each pid type for both app and rewr.
> >
> > dcb_app_print_key_*() functions have been renamed to
> > dcb_app_print_pid_*() to align with new situation. Also, none of them
> > will print the colon anymore.
> >
> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> 
> There are about four patches included in this one patch: the %d->%u
> change, the colon shenanigans, the renaming, and prototype change of
> dcb_app_print_filtered().
> 
> I think the code is OK, but I would appreciate splitting into a patch
> per feature.

Sure I can split those changes up.



