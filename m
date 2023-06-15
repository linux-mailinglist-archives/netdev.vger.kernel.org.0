Return-Path: <netdev+bounces-10989-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E006730EF8
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:02:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F826281666
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F900818;
	Thu, 15 Jun 2023 06:02:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70744ECD
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 06:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7429BC433C0;
	Thu, 15 Jun 2023 06:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686808961;
	bh=fE+EH/4fj3DJZDVn9ec0SNsTOWyotHaRxtT2lAgs+ZI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CGNr6G/zzyvYn6sOEvvyJP4hyUtej5y42IbPSwRd9kxmtdFmfIMJ3+BHXVmObmh0t
	 7Aqu5niW+4rpKNtdD33jsOr4sOn5gU5XLDKRiWmOqFH0A0ATXQTHGs1AxSxPWiOch8
	 6AUEVQIeAtlczmaQk5aVwbyCBE5Q6qCoEFA/o++WkLpuz5gUIC/Uls2QhRCOc6pILk
	 MZaC6Uqcrg14qsWfEY31VHkKbu1EX66LSpUwQjbG1JnwJml61For+8D4tcSqzZOaJi
	 Tx1a6js1sSJV2C8dLAlpBdKnHAc7Yvfp06zjcWcaPR83fsa+5tKTuNB6OXAMJ/ZVyg
	 L84i96kBx8Sqw==
Date: Wed, 14 Jun 2023 23:02:39 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>, Lior Nahmanson
 <liorna@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Hannes Frederic
 Sowa <hannes@stressinduktion.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
 lvc-project@linuxtesting.org
Subject: Re: [PATCH] net: macsec: fix double free of percpu stats
Message-ID: <20230614230239.02c388a8@kernel.org>
In-Reply-To: <ZIot16xcgb7l8wer@hog>
References: <20230613192220.159407-1-pchelkin@ispras.ru>
	<20230613200150.361bc462@kernel.org>
	<ZImx5pp98OSNnv4I@hog>
	<20230614090126.149049b1@kernel.org>
	<20230614201714.lgwpk4wyojribbyj@fpc>
	<ZIot16xcgb7l8wer@hog>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 23:15:03 +0200 Sabrina Dubroca wrote:
> It's been 7 years... your guess is about as good as mine :/
> 
> I wouldn't bother reshuffling the device creation code just to make
> the handling of rare failures a bit nicer.

Would you be willing to venture a review tag?

