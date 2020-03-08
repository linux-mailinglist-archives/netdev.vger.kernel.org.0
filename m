Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4D817D2A3
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 09:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgCHI2v convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 8 Mar 2020 04:28:51 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:60270 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgCHI2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 04:28:50 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id B9FE9CED15;
        Sun,  8 Mar 2020 09:38:16 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [RFC PATCH v4 1/5] Bluetooth: Add mgmt op set_wake_capable
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200303170610.RFC.v4.1.I797e2f4cb824299043e771f3ab9cef86ee09f4db@changeid>
Date:   Sun, 8 Mar 2020 09:28:48 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alain Michaud <alainm@chromium.org>,
        linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <417309A5-3C77-4EC3-BEA9-B0136C64625C@holtmann.org>
References: <20200304010650.259961-1-abhishekpandit@chromium.org>
 <20200303170610.RFC.v4.1.I797e2f4cb824299043e771f3ab9cef86ee09f4db@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> When the system is suspended, only some connected Bluetooth devices
> cause user input that should wake the system (mostly HID devices). Add
> a list to keep track of devices that can wake the system and add
> a management API to let userspace tell the kernel whether a device is
> wake capable or not. For LE devices, the wakeable property is added to
> the connection parameter and can only be modified after calling
> add_device.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> 
> Changes in v4: None
> Changes in v3:
> * Added wakeable property to le_conn_param
> * Use wakeable list for BR/EDR and wakeable property for LE
> 
> Changes in v2: None
> 
> include/net/bluetooth/hci_core.h |  2 ++
> include/net/bluetooth/mgmt.h     |  7 +++++
> net/bluetooth/hci_core.c         |  1 +
> net/bluetooth/mgmt.c             | 51 ++++++++++++++++++++++++++++++++
> 4 files changed, 61 insertions(+)
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index dcc0dc6e2624..9d9ada5bc9d4 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -394,6 +394,7 @@ struct hci_dev {
> 	struct list_head	mgmt_pending;
> 	struct list_head	blacklist;
> 	struct list_head	whitelist;
> +	struct list_head	wakeable;
> 	struct list_head	uuids;
> 	struct list_head	link_keys;
> 	struct list_head	long_term_keys;
> @@ -575,6 +576,7 @@ struct hci_conn_params {
> 
> 	struct hci_conn *conn;
> 	bool explicit_connect;
> +	bool wakeable;
> };

I do not want to commit to the mgmt API just yet. So I would prefer that the two changes above go into the respective BR/EDR and LE patches to enable this feature. And that the mgmt command comes last in this series. Then I can start applying the initial patches and we just have to discuss on how we want to expose this for blueoothd to use.

Regards

Marcel

