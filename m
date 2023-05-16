Return-Path: <netdev+bounces-2861-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BCFCC7044F7
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:03:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5391280DC0
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 06:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEAC61D2B0;
	Tue, 16 May 2023 06:03:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA38E19E73
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 06:03:43 +0000 (UTC)
X-Greylist: delayed 799 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 May 2023 23:03:39 PDT
Received: from a27-27.smtp-out.us-west-2.amazonses.com (a27-27.smtp-out.us-west-2.amazonses.com [54.240.27.27])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AC2189;
	Mon, 15 May 2023 23:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=s25kmyuhzvo7troimxqpmtptpemzlc6l; d=exabit.dev; t=1684215801;
	h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:Mime-Version:Content-Type:Content-Transfer-Encoding;
	bh=74L/YZxtx3KSMNRkAtfGsObxFGNIU40Nx7IaCnAIASs=;
	b=Fb57bjgi9iNYj6jzCsbxCmfIYnohkIz4bYU+CxnrCz3xlA9U85k5fHpgnFot9onw
	nDwzmtdinp2fK+jgwTl2sti9Nw+UnYaKMRa4m7c2jPTqQz0z9FQQcKl2A/v3wTUBY/6
	Scen8C9NQN3GoscAahkrDpveghZ4aoxRjP5/pdMKwCMgXTm+4vGHudZXo2XvjRVBflN
	XvG8gf2NLHa5TK4Mo17O19wEcyitAgXd5zeg5bdCEG4WcUZHsJvk/wVJB5O9wughXU1
	bu2od+6vHf3aeShGniEYHiv0/TowMR/FwDBJkO/yDWcAQbk9vy0jPkn9t4+uSsW0JVN
	eTQuwa1NuA==
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1684215801;
	h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:Mime-Version:Content-Type:Content-Transfer-Encoding:Feedback-ID;
	bh=74L/YZxtx3KSMNRkAtfGsObxFGNIU40Nx7IaCnAIASs=;
	b=c8xFgWBiF4V2XwwMgG32ZlMFOZGSvEG7VbJzn0ETgqC7jc50j9omRhsrhcbWT/FZ
	r4GNlEpuPGfYKbPKHfeoI9TE1pd6ZhyQ7Cnk5IbwA7KiMtfTn/pZe7KTcsbtH5E8ZnC
	oxxoJgSGGKHtfxFNHH6tpQ5IqBuNDgrQnlzTnV+k=
Date: Tue, 16 May 2023 05:43:21 +0000
Message-ID: <010101882315a489-908f5965-2e67-497f-97f8-5c91bc928673-000000@us-west-2.amazonses.com>
To: andrew@lunn.ch
Cc: tomo@exabit.dev, rust-for-linux@vger.kernel.org,
 netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
 fujita.tomonori@gmail.com
Subject: Re: [PATCH 2/2] rust: add socket support
From: FUJITA Tomonori <tomo@exabit.dev>
In-Reply-To: <f22b24f8-f599-4eec-9535-bcca71138057@lunn.ch>
References: <20230515043353.2324288-1-tomo@exabit.dev>
	<010101881db03866-754b644c-682c-44be-8d8e-8376d34c77b3-000000@us-west-2.amazonses.com>
	<f22b24f8-f599-4eec-9535-bcca71138057@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Feedback-ID: 1.us-west-2.j0GTvY5MHQQ5Spu+i4ZGzzYI1gDE7m7iuMEacWMZbe8=:AmazonSES
X-SES-Outgoing: 2023.05.16-54.240.27.27
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 15 May 2023 16:14:56 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Mon, May 15, 2023 at 04:34:28AM +0000, FUJITA Tomonori wrote:
>> From: FUJITA Tomonori <fujita.tomonori@gmail.com>
>> 
>> minimum abstraction for networking.
> 
>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
>> ---
>>  rust/bindings/bindings_helper.h |   3 +
>>  rust/kernel/lib.rs              |   2 +
>>  rust/kernel/net.rs              | 174 ++++++++++++++++++++++++++++++++
> 
> The full networking API is huge. So trying to put it all into net.rs
> is unlikely to work in the long run. Maybe it would be better to name
> this file based on the tiny little bit of the network API you are
> writing an abstraction for?

Yeah, in the long run. I tried the simplest but if the maintainers
prefer that approach as the first step, I'll update the patch. how
about rust/net/socket.rs ?


> If i'm reading the code correctly, you are abstracting the in kernel
> socket API for only TCP over IPv4. Probably with time that will get
> extended to IPv6, and then UDP. So maybe call this net-kern-socket.rs?

Yes. It's thin abstraction, just wrapping socket APIs. So it's easy to
extend it for IPv6, non IP protocols, etc.

Thanks,

