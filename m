Return-Path: <netdev+bounces-5113-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BED570FAD0
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:52:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB47F2813D8
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8960C19BD0;
	Wed, 24 May 2023 15:52:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECFE19BC4
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:52:20 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F271D12E
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:52:18 -0700 (PDT)
Date: Wed, 24 May 2023 17:52:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1684943537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SfUoeZ9Z+KPrjkB/OsSbV7qe+H98ssPcHqDKlVHn/fc=;
	b=FfSUtYQHQGTAlhkbQ2RUbhclDNWRYOdf+UBhHXwKx3UrplGcaoNAKRM6UDqwwIncRfmU1u
	7RRI+6mKAvaWYisXv8xpHH/PDQOgC1YIUg8Dqmkso5UYx3A9pYuhKP2xCjazDrY/sc0a0+
	qvRXUeMD188/rIs3GpRQr6tSv+DLpW4hHIxxO7VxJb1BhdwgdAsU+oUfaCncQsDkK3mchE
	MwYVozpBPOs6d8Jn3tOjS3ahvXBpt/sFnbSVswnAViytzDcj8BXFScdRgsU9r2eA/TtEc7
	aIKcE2SFQ2CBqKOz3d/IZUClEPbIAS0bjy4980Me7Lu8NP6gTRHhWGb8NnJUmw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1684943537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SfUoeZ9Z+KPrjkB/OsSbV7qe+H98ssPcHqDKlVHn/fc=;
	b=dQCvmvsVI3t9h0XacIUQh1dkrk6/bC5ML/YmtD1cmBy8XvubHzzQhoN5/iDyiC4G1ELLe2
	1ZMKfotyX+A/4LBw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 1/2] net: Add sysfs files for threaded NAPI.
Message-ID: <20230524155216.3ktuEsod@linutronix.de>
References: <20230524111259.1323415-1-bigeasy@linutronix.de>
 <20230524111259.1323415-2-bigeasy@linutronix.de>
 <CANn89iLRALON8-Bp+0iN8qEfSas2QoAE0nPMTDHS97QQWS9gyg@mail.gmail.com>
 <ZG4iDxcQ7BIz0H33@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZG4iDxcQ7BIz0H33@nanopsycho>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023-05-24 16:41:19 [+0200], Jiri Pirko wrote:
> >How is interface rename handled ?
> 
> Well, having name of interface in sysfs dir/file name is silly, even if
> it would be handled correctly. Should not be there.

The name is there due to the fact that the driver is using it as the
IRQ-name and that is what I recycled here. So it matches what is seen at
the time in proc/interrupts.
Given that it relies on the IRQ-number we may just avoid using the
interrupt name for the folder and simply stick with the napi_id scheme.
The IRQ number should give information for proper mapping.

By providing an explicit name for the napi instance like TxRx-0 (without
the device name) we would have a stable name for a given configuration.
The napi_id while mostly stable is generated on the fly and depends on
device registration order.

Sebastian

