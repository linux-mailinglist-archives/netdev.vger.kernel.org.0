Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FF1496E20
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 22:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbiAVVjW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 22 Jan 2022 16:39:22 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:37835 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiAVVjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 16:39:22 -0500
Received: from smtpclient.apple (p4fefca45.dip0.t-ipconnect.de [79.239.202.69])
        by mail.holtmann.org (Postfix) with ESMTPSA id 89D17CED30;
        Sat, 22 Jan 2022 22:39:20 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.40.0.1.81\))
Subject: Re: [PATCH] Bluetooth: msft: fix null pointer deref on
 msft_monitor_device_evt
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20220122082751.285478-1-soenke.huster@eknoes.de>
Date:   Sat, 22 Jan 2022 22:39:19 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <5EE35A0B-5B1F-4ABA-986F-15F73A81141C@holtmann.org>
References: <20220122082751.285478-1-soenke.huster@eknoes.de>
To:     Soenke Huster <soenke.huster@eknoes.de>
X-Mailer: Apple Mail (2.3693.40.0.1.81)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Soenke,

> msft_find_handle_data returns NULL if it can't find the handle.
> Therefore, handle_data must be checked, otherwise a null pointer
> is dereferenced.
> 
> Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
> ---
> net/bluetooth/msft.c | 3 +++
> 1 file changed, 3 insertions(+)
> 
> diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
> index 484540855863..d2cf92e834f7 100644
> --- a/net/bluetooth/msft.c
> +++ b/net/bluetooth/msft.c
> @@ -705,6 +705,9 @@ static void msft_monitor_device_evt(struct hci_dev *hdev, struct sk_buff *skb)
> 
> 	handle_data = msft_find_handle_data(hdev, ev->monitor_handle, false);
> 

scrap this empty line. The check can got right after the assignment.

> +	if (!handle_data)
> +		return;
> +
> 	switch (ev->addr_type) {
> 	case ADDR_LE_DEV_PUBLIC:
> 		addr_type = BDADDR_LE_PUBLIC;

Regards

Marcel

