Return-Path: <netdev+bounces-311-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B26BD6F700D
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 18:44:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 473C0280DCF
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 16:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33FE38BF1;
	Thu,  4 May 2023 16:44:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFB67E7
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 16:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5892CC4339B;
	Thu,  4 May 2023 16:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683218665;
	bh=haYp7VgJzha3yepuce6nOBH29JZMVuR7ZF4rJFfyvsM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CTujDwIPvT53VCYYjBR1yrAahnxPnieD6gg5gwbsvnWJh2KzEWZPAzqovoN6snLbw
	 0ukaj8vI9zx8nYD95Lb+6Ot24Ug8xNxXUqb0H7H9DvQAF4wuJb+HxAvPTcRRPbuUnh
	 PstkfVdnRNpdfdGRDnVMkXaFQAB5+VDxoMHtrhRTKUjhFA3m3OxTGNTgARJOOlWRR6
	 pQgD0gT9kYIrgMM+pOpg3cAva+SkX3MzgZcCtpW89Bncczu3lSmzYIqU8BuGm3e64X
	 JlL4m1pdtPc4a6Tk1pas4FiHj/XaobnX5rEXnP0ujthaEw5HiJ1W7jB1mWuCBWYh6u
	 sSjgsjwYyD0jg==
Date: Thu, 4 May 2023 09:44:24 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Martin Wetterwald <martin@wetterwald.eu>
Cc: davem@davemloft.net, dsahern@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: ipconfig: Allow DNS to be overwritten by
 DHCPACK
Message-ID: <20230504094424.0458973d@kernel.org>
In-Reply-To: <CAFERDQ3hgA490w2zWmiDQu-HfA-DLWWkL4s8z4iZAPwPZvw=LA@mail.gmail.com>
References: <CAFERDQ1yq=jBGu8e2qJeoNFYmKt4jeB835efsYMxGLbLf4cfbQ@mail.gmail.com>
	<20230503195112.23adbe7b@kernel.org>
	<CAFERDQ3hgA490w2zWmiDQu-HfA-DLWWkL4s8z4iZAPwPZvw=LA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 May 2023 10:00:04 +0200 Martin Wetterwald wrote:
> +#ifdef IPCONFIG_DHCP
> +            if (ic_nameservers[i] == NONE ||
> +                ic_nameservers_fallback)
> +#else
>              if (ic_nameservers[i] == NONE)
> +#endif

FWIW I'd vote to move the variable out of the #ifdef and avoid the hairy
code, it's just 4 bytes.

