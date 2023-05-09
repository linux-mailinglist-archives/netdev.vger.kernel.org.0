Return-Path: <netdev+bounces-1201-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7519D6FC9F8
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:13:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A00621C20BE9
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:13:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F25F18000;
	Tue,  9 May 2023 15:13:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D767499;
	Tue,  9 May 2023 15:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF49C433EF;
	Tue,  9 May 2023 15:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683645189;
	bh=bLtUC33HA1fZIzmEzu+kmDHKIWCIxdBOaOWEX3VsXN8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IEvZqweO4GE5ERsu9bY7MAcpWfgbWZKqvqHxnCWwn6ZSTlJ5v7fIf8daobS+BOA1r
	 3XlQYcPppORQnL5ybjIxRlxw9PSzmGlpXE7HgZMZYrj0AvtTUG1/Ax5ksTf3vyxwIq
	 SGzHm3jL0NEC2UJnVa0C34YyVTxhtaZq92UF7eCczmBjHw1gtRcnBm5DhdaqDVV8/J
	 0ZFnP6FRNHy871n71n8LTDbIbpjiuuWu/NxnPgF3JILO8gGT85Bid4AhWtALVlgbaD
	 kJ0PW2/8AKzaEtNk3IRQ8o3NkD8RKiLuUr8mSAldMfK7p2BaSD6RKoARctNw3Zhgl+
	 2OJX4jaKCGxrw==
Date: Tue, 9 May 2023 08:13:08 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Max Gurtovoy <mgurtovoy@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
 linux-nvme@lists.infradead.org, Chuck Lever <chuck.lever@oracle.com>,
 kernel-tls-handshake@lists.linux.dev, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>
Subject: Re: [PATCH 07/17] net/tls: handle MSG_EOR for tls_sw TX flow
Message-ID: <20230509081308.4a531d4e@kernel.org>
In-Reply-To: <f3fe3fc4-b885-d981-9685-4b1a377db639@suse.de>
References: <20230419065714.52076-1-hare@suse.de>
	<20230419065714.52076-8-hare@suse.de>
	<fb934ee3-879f-f33f-efeb-945ccc9dc9a3@nvidia.com>
	<f3fe3fc4-b885-d981-9685-4b1a377db639@suse.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 9 May 2023 16:18:30 +0200 Hannes Reinecke wrote:
> > This seems like a nice optimization but seems not mandatory for the 
> > acceptance of TLS support in nvme/tcp.
> > 
> > I wonder if this can go to net/tls as a standalone patch ?
>
> Errm. Without this NVMe/TLS will not work as sendmsg/sendpage will
> bail out.
> So yes, surely it can be applied as a standalone patch, but that
> only makes sense if it will be applied _before_ the rest of the
> nvme/tls patches.
> 
> Not sure how best to coordinate this.

You should apply it on a branch based on -rc1 and then both us and
$appropriate-nvme-maintainer can pull it in.

