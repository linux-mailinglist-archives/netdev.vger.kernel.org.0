Return-Path: <netdev+bounces-8583-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60526724A24
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:24:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95E58281009
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE97E1ED5E;
	Tue,  6 Jun 2023 17:24:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C92B1ED51
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 17:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51ECDC433D2;
	Tue,  6 Jun 2023 17:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686072271;
	bh=jHiAYO0LMlzHnPL3qmuxjmdrGwM+TYEuiPxNKoRMvxA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nnWnSspZTxktI6l8pKaUqDWp96yJYYgosdmgr8XR3vVoKCcfhtrqcLmvukbpRb0N9
	 wKMusD8zXwH2NfJpMotBWfDHbLiBdikgoMFcmzjx32Ic49aGNxchB0Ui7BK0a8lCNw
	 qFct98uIzimMnYYB0wajAgA3BwjxsZmBcxK3byfaFRHWdm4F/Tna/0StISVMva6BwL
	 WYaEEbn9B/KLDRx0DCoGeAg1YY8tfX9ufmZmPpavXLAlyQnl5urzqb4WNKXy2gBL/4
	 tFIQpC+i47x6nRigrKkve7uHCDqNkj3cTL6i6TM/OehJOwtQLKQ5Og2j72F/Ud7grU
	 qHQqRanYmjAcw==
Date: Tue, 6 Jun 2023 10:24:30 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Piotr Gardocki
 <piotrx.gardocki@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
 <pabeni@redhat.com>, <edumazet@google.com>, <netdev@vger.kernel.org>,
 Michal Swiatkowski <michal.swiatkowski@linux.intel.com>, Rafal Romanowski
 <rafal.romanowski@intel.com>, <aleksander.lobakin@intel.com>
Subject: Re: [PATCH net-next 1/3] iavf: add check for current MAC address in
 set_mac callback
Message-ID: <20230606102430.294dee2f@kernel.org>
In-Reply-To: <ZH8Ik3XyOzd28ao2@boxer>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
	<20230602171302.745492-2-anthony.l.nguyen@intel.com>
	<ZH4xXCGWI31FB/pD@boxer>
	<e7f7d9f7-315d-91a8-0dc3-55beb76fab1c@intel.com>
	<ZH8Ik3XyOzd28ao2@boxer>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 6 Jun 2023 12:21:07 +0200 Maciej Fijalkowski wrote:
> > > couldn't this be checked the layer above then? and pulled out of drivers?
> > 
> > Probably it could, but I can't tell for all drivers if such request should
> > always be ignored. I'm not aware of all possible use cases for this callback
> > to be called and I can imagine designs where such request should be
> > always handled.  
> 
> if you can imagine a case where such request should be handled then i'm
> all ears. it feels like this is in an optimization where everyone could
> benefit from (no expert in this scope though), but yeah this callback went
> into the wild and it's implemented all over the place.

+1, FWIW, this is a net-next change, let's try to put it in the core
unless we see a clear enough reason not to.

