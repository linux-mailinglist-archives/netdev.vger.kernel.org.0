Return-Path: <netdev+bounces-6431-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2D7F7163EA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:25:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 856F91C20C12
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 212FD23C7A;
	Tue, 30 May 2023 14:25:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F302106D
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA3EC433EF;
	Tue, 30 May 2023 14:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685456707;
	bh=+SYa9bhZBDTkyURy2GHBB/vLDr+xUSjpSqvR1WZibas=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f/juyAhcdNjjQ8aklB2nIws+qDmE0bsjg9H0H0+PjK5dDKw5piNsQu0LQFnle03Yl
	 pcEdusnAxxj9dHlTeNkV+iC98Vu5M74hvEWApcEMA+QTNmPyUZIbyQNfrc7e+xci+E
	 jWaEaqX0Nlrj7xc4/zFfss978JpHu7PUqK/OtbzKKIDg63TFtKyAGkSDzBY2haeDQP
	 jSf8irbEX8RfwIQAKd+HVI01bv762Tm27eBTHgv3KZIdZI+xepKeblQg24dCrvM9ar
	 s5SSwE/2T9R0JdfV+kzwUBrZ5UMu7+F3t/CWanLmj/4trn6WjhaqR6/OR7FFPM5Wwy
	 ITn/31eU7zXRQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
	(envelope-from <johan@kernel.org>)
	id 1q40Hd-0007sX-3Z; Tue, 30 May 2023 16:25:09 +0200
Date: Tue, 30 May 2023 16:25:09 +0200
From: Johan Hovold <johan@kernel.org>
To: Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: Matthias Kaehlcke <mka@chromium.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>
Subject: Re: [PATCH 0/2] Bluetooth: fix bdaddr quirks
Message-ID: <ZHYHRW-9BN4n4pPs@hovoldconsulting.com>
References: <20230424133542.14383-1-johan+linaro@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424133542.14383-1-johan+linaro@kernel.org>

On Mon, Apr 24, 2023 at 03:35:40PM +0200, Johan Hovold wrote:
> These patches fixes a couple of issues with the two bdaddr quirks:
> 
> The first one allows HCI_QUIRK_INVALID_BDADDR to be used with
> HCI_QUIRK_NON_PERSISTENT_SETUP.
> 
> The second patch restores the original semantics of the
> HCI_QUIRK_USE_BDADDR_PROPERTY so that the controller is marked as
> unconfigured when no device address is specified in the devicetree (as
> the quirk is documented to work).
> 
> This specifically makes sure that Qualcomm HCI controllers such as
> wcn6855 found on the Lenovo X13s are marked as unconfigured until user
> space has provided a valid address.
> 
> Long term, the HCI_QUIRK_USE_BDADDR_PROPERTY should probably be dropped
> in favour of HCI_QUIRK_INVALID_BDADDR and always checking the devicetree
> property.

> Johan Hovold (2):
>   Bluetooth: fix invalid-bdaddr quirk for non-persistent setup
>   Bluetooth: fix use-bdaddr-property quirk
> 
>  net/bluetooth/hci_sync.c | 30 +++++++++++-------------------
>  1 file changed, 11 insertions(+), 19 deletions(-)

Any further comments to this series, or can this one be merged for 6.5
now?

Johan

