Return-Path: <netdev+bounces-7297-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED72A71F90C
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 05:55:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DCC42819C9
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 03:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F1A15D2;
	Fri,  2 Jun 2023 03:55:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BB815B2
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 03:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294BAC4339B;
	Fri,  2 Jun 2023 03:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685678117;
	bh=kI04ZkH+BzYwYs9FYiuQ/YFLh8XzX/9DQJKt9M8ioBk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oF83FIxk7iwby0mbikd8M5T5WQh2OYbmlGz3kmcdILr9kvcJfRl7TW58bjz8JI8Dp
	 FvdMeQkchbEnJLd2YEamxZVP0m1/d/UqQVyhMTfs9KssRi6sj1jyNNBhh08FGJyyy7
	 POYK3YnN7gSCTY9bQrcyuCsU5pdd/cd8svLyKRZDsj4rRehjsh2ACV7p2xinn25VYr
	 EiWVCGjmuD4ZH3zs+/27G4k9UFsEtugwro5mxVYeIRWxUMdbU6ABz5H83dB11FMo0d
	 rA0Vuk/lkO3llOwCA5cYNGrq3+DtFUqlQJY/KyuLkDk/wqKpk5nTNDTQbik9OFdL1d
	 duxBZ8dBrFnOQ==
Date: Thu, 1 Jun 2023 20:55:16 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
 pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
 sasha.neftin@intel.com, richardcochran@gmail.com, Vladimir Oltean
 <vladimir.oltean@nxp.com>, Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net 2/4] igc: Check if hardware TX timestamping is
 enabled earlier
Message-ID: <20230601205516.7322d9e3@kernel.org>
In-Reply-To: <87353aubds.fsf@intel.com>
References: <20230530174928.2516291-1-anthony.l.nguyen@intel.com>
	<20230530174928.2516291-3-anthony.l.nguyen@intel.com>
	<20230531231029.36822957@kernel.org>
	<87353aubds.fsf@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 01 Jun 2023 14:21:35 -0700 Vinicius Costa Gomes wrote:
> > AFAICT the cancel / cleanup path is not synchronized (I mean for
> > accesses to adapter->tstamp_config) so this looks racy to me :(
> 
> As far as I can see, the racy behavior wasn't introduced here, can I
> propose the fix as a follow up patch? Or do you prefer that I re-spin
> this series?

I think respin would be better, you're rejigging the synchronization
here, who knows if you won't have to rejig differently to cover this
case.

