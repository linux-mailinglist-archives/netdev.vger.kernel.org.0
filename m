Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15FB420EED4
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 08:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730535AbgF3GvN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Jun 2020 02:51:13 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:41810 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730386AbgF3GvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 02:51:12 -0400
Received: from marcel-macpro.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id A78F9CECE2;
        Tue, 30 Jun 2020 09:01:05 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v1] Bluetooth: Fix kernel oops triggered by
 hci_adv_monitors_clear()
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200629201441.v1.1.I162e3c6c4f4d963250c37733c3428329110c5989@changeid>
Date:   Tue, 30 Jun 2020 08:51:10 +0200
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Pavel Machek <pavel@ucw.cz>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <968D6753-8ACB-4298-91A4-F2C9438EAC06@holtmann.org>
References: <20200629201441.v1.1.I162e3c6c4f4d963250c37733c3428329110c5989@changeid>
To:     Miao-chen Chou <mcchou@chromium.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Miao-chen,

> This fixes the kernel oops by removing unnecessary background scan
> update from hci_adv_monitors_clear() which shouldn't invoke any work
> queue.
> 
> The following test was performed.
> - Run "rmmod btusb" and verify that no kernel oops is triggered.
> 
> Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> ---
> 
> net/bluetooth/hci_core.c | 2 --
> 1 file changed, 2 deletions(-)
> 
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 5577cf9e2c7cd..77615161c7d72 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -3005,8 +3005,6 @@ void hci_adv_monitors_clear(struct hci_dev *hdev)
> 		hci_free_adv_monitor(monitor);
> 
> 	idr_destroy(&hdev->adv_monitors_idr);
> -
> -	hci_update_background_scan(hdev);
> }

I am happy to apply this as well, but I also applied another patch re-arranging the workqueue destroy handling. Can you check which prefer or if we should include both patches.

Regards

Marcel

