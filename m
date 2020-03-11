Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 744D2181BBA
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 15:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729925AbgCKOu7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 11 Mar 2020 10:50:59 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:56256 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729844AbgCKOu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 10:50:59 -0400
Received: from [172.20.10.2] (x59cc8a78.dyn.telefonica.de [89.204.138.120])
        by mail.holtmann.org (Postfix) with ESMTPSA id 7DF0DCECDF;
        Wed, 11 Mar 2020 16:00:25 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [Bluez PATCH v1] Bluetooth: L2CAP: handle l2cap config request
 during open state
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200310180642.Bluez.v1.1.I50b301a0464eb68e3d62721bf59e11ed2617c415@changeid>
Date:   Wed, 11 Mar 2020 15:50:56 +0100
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <BBDABF4D-E4CC-49D7-ADCF-6913B2DE9FF0@holtmann.org>
References: <20200310180642.Bluez.v1.1.I50b301a0464eb68e3d62721bf59e11ed2617c415@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> According to Core Spec Version 5.2 | Vol 3, Part A 6.1.5,
> the incoming L2CAP_ConfigReq should be handled during
> OPEN state.
> 
> Signed-off-by: Howard Chung <howardchung@google.com>
> 
> ---
> 
> net/bluetooth/l2cap_core.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index 697c0f7f2c1a..5e6e35ab44dd 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -4300,7 +4300,8 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
> 		return 0;
> 	}
> 
> -	if (chan->state != BT_CONFIG && chan->state != BT_CONNECT2) {
> +	if (chan->state != BT_CONFIG && chan->state != BT_CONNECT2 &&
> +	    chan->state != BT_CONNECTED) {
> 		cmd_reject_invalid_cid(conn, cmd->ident, chan->scid,
> 				       chan->dcid);
> 		goto unlock;

Any chance you can add a btmon trace excerpt for this to the commit message. It would be good to have the before and after here included.

Regards

Marcel

