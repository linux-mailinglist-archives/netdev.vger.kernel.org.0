Return-Path: <netdev+bounces-7621-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58F4C720E07
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 08:06:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F23FC281B3F
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 06:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 441CD5C9B;
	Sat,  3 Jun 2023 06:06:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E961FD5
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 06:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93898C433D2;
	Sat,  3 Jun 2023 06:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685772396;
	bh=so+d+pskbg6xgUzujz3I9pz9YanKD/4wfzCTeB4BJiY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZdZne02w5j51czzmrQppZrRsW7AYJrkfZBLPOdSZTcX1YnVA0URBCN/9HoZd3HB1X
	 W26+jF7YIFO8lQ8gHkyBkgWBohQzs+L1sDnxIEz/V5Yxu8dQHJtIjbi+erU+trFP+c
	 UWXHmAdsvOcyGQi2gsAxGB/hHtfU8KZMDmlgCzNf8e+wHvkz2TXhNmQ7n6lCbp3gcS
	 agDexoBK89eYepZz7MiNvIaEKNlejM2E/nxJC1kSwu2n+ZliqTX+eUPnchYjExAe0/
	 MSGFepXI59hDN95kucPO1NZOK2UPwMD9J6Mrm/sa3H2EpbT2y+aCAUwZuZQEayJywn
	 y3TviwGRoOuPQ==
Date: Fri, 2 Jun 2023 23:06:35 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Amritha Nambiar <amritha.nambiar@intel.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, sridhar.samudrala@intel.com
Subject: Re: [net-next/RFC PATCH v1 1/4] net: Introduce new napi fields for
 rx/tx queues
Message-ID: <20230602230635.773b8f87@kernel.org>
In-Reply-To: <168564134580.7284.16867711571036004706.stgit@anambiarhost.jf.intel.com>
References: <168564116688.7284.6877238631049679250.stgit@anambiarhost.jf.intel.com>
	<168564134580.7284.16867711571036004706.stgit@anambiarhost.jf.intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 01 Jun 2023 10:42:25 -0700 Amritha Nambiar wrote:
> Introduce new napi fields 'napi_rxq_list' and 'napi_txq_list'
> for rx and tx queue set associated with the napi and
> initialize them. Handle their removal as well.
> 
> This enables a mapping of each napi instance with the
> queue/queue-set on the corresponding irq line.

Wouldn't it be easier to store the NAPI instance pointer in the queue?
That way we don't have to allocate memory.

