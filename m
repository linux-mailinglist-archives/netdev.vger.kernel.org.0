Return-Path: <netdev+bounces-4760-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D329E70E206
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 18:46:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D41E1C20D85
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD55D20689;
	Tue, 23 May 2023 16:46:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086FC1F933
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 16:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420CDC433D2;
	Tue, 23 May 2023 16:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684860367;
	bh=frZYjDQKin2OHTgUDD9pxdXKaV6vGksRhCcsFtba5x4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=H8SfP/1BV7zbPUtsX6lI0G0fNnb1MZitP4ubj+awDqBrFHMpMSz2TribsuvaMA3hM
	 e/iuchNE906qqEzi12NJg2q2qNsjX/b9oB/CzvhmuFkTCMhoV/sY4zhTmq1tr866b9
	 k/fRX88Huy3s20ikowigjysvgkzvtCyBUi6DVA+MjfdLnVM9nr1te2U5gk0fHRIDZH
	 wOJS9i41FMYjizitrnHb1MsvjWX+53PagC6EKTJlVtfMyQe4w/0r6IuGwDiqGwsZPS
	 fGI9khOKXUd6zxx1577oULe81ZEcIqCCM2kwErfPln4q+CbyTNrcZfEYy5reMNg69S
	 8riVqD/CwqA0g==
Date: Tue, 23 May 2023 09:46:06 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: edumazet@google.com, syzbot
 <syzbot+c2775460db0e1c70018e@syzkaller.appspotmail.com>,
 netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 davem@davemloft.net, linux-kernel@vger.kernel.org, pabeni@redhat.com,
 wireguard@lists.zx2c4.com, jann@thejh.net
Subject: Re: [syzbot] [wireguard?] KASAN: slab-use-after-free Write in
 enqueue_timer
Message-ID: <20230523094606.6f4f8f4f@kernel.org>
In-Reply-To: <ZGzmWtd7itw6oFsI@zx2c4.com>
References: <000000000000c0b11d05fa917fe3@google.com>
	<ZGzfzEs-vJcZAySI@zx2c4.com>
	<20230523090512.19ca60b6@kernel.org>
	<ZGzmWtd7itw6oFsI@zx2c4.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 May 2023 18:14:18 +0200 Jason A. Donenfeld wrote:
> So, IOW, not a wireguard bug, right?

What's slightly concerning is that there aren't any other timers
leading to

  KASAN: slab-use-after-free Write in enqueue_timer

:( If WG was just an innocent bystander there should be, right?

