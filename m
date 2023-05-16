Return-Path: <netdev+bounces-3022-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A2A297050F0
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:37:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A033F1C20EBD
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A606D2771D;
	Tue, 16 May 2023 14:37:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C0434CD5
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 14:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81EEC433EF;
	Tue, 16 May 2023 14:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684247821;
	bh=kaxwbay1KRPiA3CRo5jUaEWJLpeBr+/aZlM+DLSaUYo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=G0DHTuaC70NNkxyZSp7tTGOHGqWuKyG+78cauyoTu1HTlHVl6kD51YMxdxWAqEZbI
	 /oVU9lafmotwQhg2XXHxZiZ3Vtg5AoVnPJeu3T6THYOU/lkLa9tb/620nMtowzp7RB
	 /lujoVNirbw2YIUpS3c2CG3IaSQS6SreS/oH9QvVC27MuOxDWQsan/VGYenl0Z/kgl
	 f+zRSTFHqaeooFWoC/siBNkFiR31EhPPrDb6vP/RsyzYxANuVTIiqKJjWnssqNWfDv
	 V4PS06uGcOI9jVnZ8BllUyuStB4QzV7Mg6qcFQX9UDuUIo+ClSwT3mRlxBld7q8G/f
	 pMC4fGPVisZBw==
Message-ID: <1182a9ae-8396-97d1-6708-b811ddd9d976@kernel.org>
Date: Tue, 16 May 2023 08:37:00 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 2/2] net/tcp: optimise io_uring zc ubuf
 refcounting
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>,
 Eric Dumazet <edumazet@google.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com
References: <cover.1684166247.git.asml.silence@gmail.com>
 <bdbbff06f20c100c00e59932ffecbd18ad699f57.1684166247.git.asml.silence@gmail.com>
 <99faed2d-8ea6-fc85-7f21-e15b24d041f1@kernel.org>
 <CANn89i+Bb7g9uDPVmomNDJivK7CZBYD1UXryxq2VEU77sajqEg@mail.gmail.com>
 <d7edb614-3758-1df6-91b8-a0cb601137a4@kernel.org>
 <ee609e87-0515-c1f8-8b27-78572c81b1b4@gmail.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <ee609e87-0515-c1f8-8b27-78572c81b1b4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/16/23 6:59 AM, Pavel Begunkov wrote:
> 
> 
>> The one in net_zcopy_put can be removed with the above change. It's
>> other caller is net_zcopy_put_abort which has already checked uarg is
>> set.
> 
> Ah yes, do you want me to fold it in?
> 

no preference.


