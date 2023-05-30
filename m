Return-Path: <netdev+bounces-6426-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7D877163D5
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:22:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CCD71C20B03
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:22:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D7D823C66;
	Tue, 30 May 2023 14:22:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3365921076
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEE8C4339C;
	Tue, 30 May 2023 14:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685456529;
	bh=k700hgbiU2x5v71H9KHKEiPJRC2HKKRUZbC/XC2nTNM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RQJ+edKK9vPos0wVd2D7Ef/BPog8efISHA8NkA697qyRU/yLVFgd2aEExM/wYh60/
	 /NE53C/NmCt+mdkOF9cmriwPSJRosIvPIjx71tuKUyL29P55idt7KB0g3QN4AJt9Og
	 +SHI/K2YqQOROccEoRLwpqGX4qQvhDYZNln4YCqSyvTH5497i6oBYP+jTGSrpKH0ds
	 Koow4LSFejvhNTTp2EODkAhGPRfS9TJEpEmI6+hHRmswqM1qhfev+mgJtykdWkjsjb
	 0XcqMYiPqembqFubXole0hEQ6rmDWV7IxWSuYyGr7+KRB7I0UUhCjb+goCvM4XYGxj
	 Mo/xF6ZkJNF+Q==
Received: from johan by xi.lan with local (Exim 4.94.2)
	(envelope-from <johan@kernel.org>)
	id 1q40El-0007rF-BZ; Tue, 30 May 2023 16:22:11 +0200
Date: Tue, 30 May 2023 16:22:11 +0200
From: Johan Hovold <johan@kernel.org>
To: Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>
Subject: Re: [PATCH 0/2] Bluetooth: fix debugfs registration
Message-ID: <ZHYGkxX-Z6deSgAH@hovoldconsulting.com>
References: <20230424124852.12625-1-johan+linaro@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424124852.12625-1-johan+linaro@kernel.org>

On Mon, Apr 24, 2023 at 02:48:50PM +0200, Johan Hovold wrote:
> The HCI controller debugfs interface is created during setup or when a
> controller is configured, but there is nothing preventing a controller
> from being configured multiple times (e.g. by setting the device
> address), which results in a host of errors in the logs:
> 
> 	debugfs: File 'features' in directory 'hci0' already present!
> 	debugfs: File 'manufacturer' in directory 'hci0' already present!
> 	debugfs: File 'hci_version' in directory 'hci0' already present!
> 	...
> 	debugfs: File 'quirk_simultaneous_discovery' in directory 'hci0' already present!
> 
> The Qualcomm driver suffers from a related problem for controllers with
> non-persistent setup.
>
> 
> Johan Hovold (2):
>   Bluetooth: fix debugfs registration
>   Bluetooth: hci_qca: fix debugfs registration
> 
>  drivers/bluetooth/hci_qca.c | 6 +++++-
>  include/net/bluetooth/hci.h | 1 +
>  net/bluetooth/hci_sync.c    | 3 +++
>  3 files changed, 9 insertions(+), 1 deletion(-)

Are there any more comments to this series or can we can get this merged
for 6.5?

I hope this is not blocked on the bogus checkpatch warning the robot
posted?

Johan

