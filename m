Return-Path: <netdev+bounces-2673-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B9A2702F5B
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:15:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB6101C20B91
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B18AFD52B;
	Mon, 15 May 2023 14:15:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A681DC8CE
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 14:15:00 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11AF19B0;
	Mon, 15 May 2023 07:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=TJRlSPOnx9ii8Kt9hBjPHaiwxx3O1eu4ohGE4HeKKXc=; b=hdDoNo+TQguN63TdoZIaPhs9VJ
	IGBOWWflrw4xhBeHcCrd02GIfGDiVRJOLI2cw7LSHbhW45tn7ikjqdQkGz5kXXNQD+gGXpytwWMkT
	Lfl887HRTmMZI2kUGRahT9tiUlcJ+bwLKYke+MH2+loRsR0yoVvl7VEFjLeIPiL80FJs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pyYyW-00CtoW-Nm; Mon, 15 May 2023 16:14:56 +0200
Date: Mon, 15 May 2023 16:14:56 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: FUJITA Tomonori <tomo@exabit.dev>
Cc: rust-for-linux@vger.kernel.org, netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	FUJITA Tomonori <fujita.tomonori@gmail.com>
Subject: Re: [PATCH 2/2] rust: add socket support
Message-ID: <f22b24f8-f599-4eec-9535-bcca71138057@lunn.ch>
References: <20230515043353.2324288-1-tomo@exabit.dev>
 <010101881db03866-754b644c-682c-44be-8d8e-8376d34c77b3-000000@us-west-2.amazonses.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <010101881db03866-754b644c-682c-44be-8d8e-8376d34c77b3-000000@us-west-2.amazonses.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 04:34:28AM +0000, FUJITA Tomonori wrote:
> From: FUJITA Tomonori <fujita.tomonori@gmail.com>
> 
> minimum abstraction for networking.

> Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
> ---
>  rust/bindings/bindings_helper.h |   3 +
>  rust/kernel/lib.rs              |   2 +
>  rust/kernel/net.rs              | 174 ++++++++++++++++++++++++++++++++

The full networking API is huge. So trying to put it all into net.rs
is unlikely to work in the long run. Maybe it would be better to name
this file based on the tiny little bit of the network API you are
writing an abstraction for?

If i'm reading the code correctly, you are abstracting the in kernel
socket API for only TCP over IPv4. Probably with time that will get
extended to IPv6, and then UDP. So maybe call this net-kern-socket.rs?

	 Andrew

