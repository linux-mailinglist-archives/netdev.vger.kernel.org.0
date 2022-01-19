Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF084940EF
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 20:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242121AbiASTeD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Jan 2022 14:34:03 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:59948 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241682AbiASTeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 14:34:00 -0500
Received: from smtpclient.apple (p4fefca45.dip0.t-ipconnect.de [79.239.202.69])
        by mail.holtmann.org (Postfix) with ESMTPSA id 285FACECE1;
        Wed, 19 Jan 2022 20:33:59 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.40.0.1.81\))
Subject: Re: [PATCH] net/bluetooth: remove unneeded err variable
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20220118075033.925388-1-chi.minghao@zte.com.cn>
Date:   Wed, 19 Jan 2022 20:33:58 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Content-Transfer-Encoding: 8BIT
Message-Id: <91565226-5134-45FC-A68F-0E98854227AC@holtmann.org>
References: <20220118075033.925388-1-chi.minghao@zte.com.cn>
To:     cgel.zte@gmail.com
X-Mailer: Apple Mail (2.3693.40.0.1.81)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Minghao,

> Return value from mgmt_cmd_complete() directly instead
> of taking this in another redundant variable.

the Bluetooth subsystem uses Bluetooth: as subject prefix.

> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
> ---
> net/bluetooth/mgmt.c | 5 +----
> 1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index 37087cf7dc5a..d0804648da32 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -8601,7 +8601,6 @@ static int get_adv_size_info(struct sock *sk, struct hci_dev *hdev,
> 	struct mgmt_cp_get_adv_size_info *cp = data;
> 	struct mgmt_rp_get_adv_size_info rp;
> 	u32 flags, supported_flags;
> -	int err;
> 
> 	bt_dev_dbg(hdev, "sock %p", sk);
> 
> @@ -8628,10 +8627,8 @@ static int get_adv_size_info(struct sock *sk, struct hci_dev *hdev,
> 	rp.max_adv_data_len = tlv_data_max_len(hdev, flags, true);
> 	rp.max_scan_rsp_len = tlv_data_max_len(hdev, flags, false);
> 
> -	err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_GET_ADV_SIZE_INFO,
> +	return mgmt_cmd_complete(sk, hdev->id, MGMT_OP_GET_ADV_SIZE_INFO,
> 				MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
> -
> -	return err;
> }

You also have a coding style error here in your indentation.

Regards

Marcel

