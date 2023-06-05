Return-Path: <netdev+bounces-8235-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FD5872335B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 00:53:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19F4B28138C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4557F271E1;
	Mon,  5 Jun 2023 22:52:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3230037F
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 22:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F3CC433EF;
	Mon,  5 Jun 2023 22:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686005574;
	bh=lGKgyNKbwjXLG9qFsdRb2PATlAJNewYPfCSTMtDr49s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oXbKtwDxFha3xgJ7uED3XooVNK5Ltj7ey+QWJMSq0lYPwvVkJQZbP4un0/9JmeRRi
	 RLUaz4FB9qK7fio9AI3W7O92J8v9mQNbliY7WjklPfGQl+2i+lHhvxyYdJcVHlgVp0
	 xeo/4owOSwupOKHBuGZIRGizSn+G8BlKb8ybrtAladYl9usfqVmZl8STvXVSunj+UI
	 vosgfndjILf4+BaQFlyFvqH8/rIfTsmbYroSIuOWO9s1uhexiNoGQ2U/rDsEqdeR8M
	 whzuvBfeamu8Zajx2/oM1KQV8OtkIxVRRu/5KQ/mf4IEBvzIe3eMGxgvGtN4PVFQmk
	 whSLBSwiRNLqw==
Date: Mon, 5 Jun 2023 15:52:53 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>, Paolo Abeni
 <pabeni@redhat.com>, netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net 1/2] rfs: annotate lockless accesses to
 sk->sk_rxhash
Message-ID: <20230605155253.1cedfdb0@kernel.org>
In-Reply-To: <20230602163141.2115187-2-edumazet@google.com>
References: <20230602163141.2115187-1-edumazet@google.com>
	<20230602163141.2115187-2-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  2 Jun 2023 16:31:40 +0000 Eric Dumazet wrote:
> +		if (sk->sk_state == TCP_ESTABLISHED) {
> +			/* This READ_ONCE() is paired with the WRITE_ONCE()
> +			 * from sock_rps_save_rxhash() and sock_rps_reset_rxhash().
> +			 */
> +			sock_rps_record_flow_hash(READ_ONCE(sk->sk_rxhash));
> +			}

Hi Eric, the series got "changes requested", a bit unclear why, 
I'm guessing it's because it lacks Fixes tags.

I also noticed that the closing bracket above looks misaligned.

Would you mind reposting? If you prefer not to add Fixes tag
a mention that it's intentional in the cover letter is enough.

