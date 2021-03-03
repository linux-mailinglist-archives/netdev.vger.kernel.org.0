Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FB032C4A3
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1450031AbhCDAPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:47 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:40213 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388526AbhCCVKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 16:10:49 -0500
Received: from marcel-macbook.holtmann.net (p4ff9fb90.dip0.t-ipconnect.de [79.249.251.144])
        by mail.holtmann.org (Postfix) with ESMTPSA id 58E05CED0A;
        Wed,  3 Mar 2021 22:17:37 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] Bluetooth: Allow scannable adv with extended MGMT APIs
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210303111505.1.I3108b046a478cb4f1b85aeb84edb0f127cff81a8@changeid>
Date:   Wed, 3 Mar 2021 22:10:02 +0100
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <EA8605ED-9E87-4A8F-BEE6-3B2720732278@holtmann.org>
References: <20210303111505.1.I3108b046a478cb4f1b85aeb84edb0f127cff81a8@changeid>
To:     Daniel Winkler <danielwinkler@google.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

> An issue was found, where if a bluetooth client requests a broadcast
> advertisement with scan response data, it will not be properly
> registered with the controller. This is because at the time that the
> hci_cp_le_set_scan_param structure is created, the scan response will
> not yet have been received since it comes in a second MGMT call. With
> empty scan response, the request defaults to a non-scannable PDU type.
> On some controllers, the subsequent scan response request will fail due
> to incorrect PDU type, and others will succeed and not use the scan
> response.
> 
> This fix allows the advertising parameters MGMT call to include a flag
> to let the kernel know whether a scan response will be coming, so that
> the correct PDU type is used in the first place. A bluetoothd change is
> also incoming to take advantage of it.
> 
> To test this, I created a broadcast advertisement with scan response
> data and registered it on the hatch chromebook. Without this change, the
> request fails, and with it will succeed.
> 
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> Signed-off-by: Daniel Winkler <danielwinkler@google.com>
> ---
> 
> include/net/bluetooth/mgmt.h | 1 +
> net/bluetooth/hci_request.c  | 3 ++-
> net/bluetooth/mgmt.c         | 1 +
> 3 files changed, 4 insertions(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

