Return-Path: <netdev+bounces-266-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75B706F695C
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 12:58:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5ED23280C88
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 10:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FBAE1866;
	Thu,  4 May 2023 10:58:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C341863
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 10:58:30 +0000 (UTC)
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F2B49FC;
	Thu,  4 May 2023 03:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=wPc+1lRKbuuh0qu/VajEPCBbvOr3RpZaWW8UHDepHkc=; b=Vvj0BwKde6+t0ZO80Mfm6u6rnf
	9KEC96O66zJwWfCn1viz5ae2MwDgqv4PWH2dcS5AjIT6pQ6kjAc5K7WRilrpF55gzBXDK2huXME2W
	Tsr61tZoN8ab1rYhkY4+UFbfnsdZaW5LTqMazogClEXAUDNEmDnDu38EghAvrrQqSWfZD5Jb+dUK5
	7Me+IThulsuoFydHuxU6HZTBvLab904xi46MLOMLwDfwFxOsSyLy3A6WY8Oa9tAQaIKZGtMg8AWwd
	j9vc92QFDsegoX0FoBuGT+tNJlGaF3wWq5yhJZAZO6+9A+U6wDrn7QnGhLj5QVAgtsRvzC2j7Lqqx
	cHJNDHOK6V08pjVpJ31ceSZ2yVFeM2D2hA9fCrA3eQgtK9jRv0DKtoYuAZg1hx4nYr0OOOPZU+OTB
	740XxMNpgS7FvFGvjvXkch2sBqNUckMRbi2a8z4rEP8f5aMJFTrPfQxfkcJb11V6sYTMFXPsEij/6
	I1Ebd8F//Nku4wwvONyPCYYw+8kS7FIWwz+abO1/nlfYYddBacbsYZRnKYE+3RS3bfsGPGyX5741m
	hIuOZizMVR4fk4se52QWYLHelV5a7nq0FuqGZpucXJKdOlJFT6Z9soEUX5DcktANdxPI7xwJw85lD
	0RkGqyONPAvUoVE2ax6+I7616t5F7ZttP+rahGesM=;
From: Christian Schoenebeck <linux_oss@crudebyte.com>
To: Eric Van Hensbergen <ericvh@kernel.org>,
 Latchesar Ionkov <lucho@ionkov.net>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Jason Andryuk <jandryuk@gmail.com>, "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, v9fs@lists.linux.dev,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] 9p: Remove INET dependency
Date: Thu, 04 May 2023 12:58:08 +0200
Message-ID: <4317357.pJ3umoczA4@silver>
In-Reply-To: <20230503141123.23290-1-jandryuk@gmail.com>
References: <20230503141123.23290-1-jandryuk@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wednesday, May 3, 2023 4:11:20 PM CEST Jason Andryuk wrote:
> 9pfs can run over assorted transports, so it doesn't have an INET
> dependency.  Drop it and remove the includes of linux/inet.h.
> 
> NET_9P_FD/trans_fd.o builds without INET or UNIX and is unusable over

s/unusable/usable/ ?

> plain file descriptors.  However, tcp and unix functionality is still
> built and would generate runtime failures if used.  Add imply INET and
> UNIX to NET_9P_FD, so functionality is enabled by default but can still
> be explicitly disabled.
> 
> This allows configuring 9pfs over Xen with INET and UNIX disabled.
> 
> Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
> ---
> v2
> Add imply INET and UNIX



