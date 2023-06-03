Return-Path: <netdev+bounces-7620-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56EB0720E04
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 08:00:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BD7F281B3B
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 06:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 285115C98;
	Sat,  3 Jun 2023 06:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132AB259A
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 06:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37246C433D2;
	Sat,  3 Jun 2023 06:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685772020;
	bh=Zc7F67BWlHMcKNJVZX9qvv2YUta8+zBiHy5CYfvugkA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=E1jmmT8OoCi6qcWXeyOEA9kxiGOw3N2sUvNS+PZR7qHgo11GwI/zZXuLbISXpGoMT
	 MxEZBPDw46mmcjUfFQzh0MuxbisFZv4LcrI31yqLrQZNjbjQ+J7JRM1CGmw7Ladvmq
	 +keXN6PqUC7zIlX9O5egUgcGKb+J128+4C418WvIl5J6GOxLFuKGp8UB0Ili93q2m6
	 lkOzNtNu2jws99D42Ak03o5pgtna1YKVVy6HcSW/Hz4QinnTGlwI6QZE3pYJD/8IK0
	 SuO+K7lw+gqj5HhncvFv20Ecpvt8LTbss5CwG2Xmgs+gIcyhCl1vkU7pOto7yByZgU
	 dzTp2/CcL5dYA==
Date: Fri, 2 Jun 2023 23:00:19 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Amritha Nambiar <amritha.nambiar@intel.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, sridhar.samudrala@intel.com
Subject: Re: [net-next/RFC PATCH v1 0/4] Introduce napi queues support
Message-ID: <20230602230019.78449c21@kernel.org>
In-Reply-To: <168564116688.7284.6877238631049679250.stgit@anambiarhost.jf.intel.com>
References: <168564116688.7284.6877238631049679250.stgit@anambiarhost.jf.intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 01 Jun 2023 10:42:20 -0700 Amritha Nambiar wrote:
> Introduce support for associating napi instances with
> corresponding RX and TX queue set. Add the capability
> to export napi information supported by the device.
> Extend the netdev_genl generic netlink family for netdev
> with napi data. The napi fields exposed are:
> - napi id
> - queue/queue-set (both RX and TX) associated with each
>   napi instance

Would you mind throwing in the IRQ vector number already?
Should be pretty easy to find the IRQ from NAPI, and it'd
make this code immediately very useful for IRQ pinning.

> Additional napi fields such as PID association for napi
> thread etc. can be supported in a follow-on patch set.
> 
> This series only supports 'get' ability for retrieving
> napi fields (specifically, napi ids and queue[s]). The 'set'
> ability for setting queue[s] associated with a napi instance
> via netdev-genl will be submitted as a separate patch series.

