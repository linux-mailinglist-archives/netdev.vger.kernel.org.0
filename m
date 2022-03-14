Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F694D881D
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 16:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242231AbiCNPdp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Mar 2022 11:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233435AbiCNPdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 11:33:45 -0400
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 448931BE9B;
        Mon, 14 Mar 2022 08:32:34 -0700 (PDT)
Received: from smtpclient.apple (p5b3d2183.dip0.t-ipconnect.de [91.61.33.131])
        by mail.holtmann.org (Postfix) with ESMTPSA id 65347CECC5;
        Mon, 14 Mar 2022 16:32:33 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.60.0.1.1\))
Subject: Re: [PATCH] Bluetooth: hci_event: Remove excessive bluetooth warning
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20220312164550.1810665-1-mike@fireburn.co.uk>
Date:   Mon, 14 Mar 2022 16:32:32 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <61E2F921-2006-4E9A-AAFF-47371CBC5FCD@holtmann.org>
References: <20220312164550.1810665-1-mike@fireburn.co.uk>
To:     Mike Lothian <mike@fireburn.co.uk>
X-Mailer: Apple Mail (2.3693.60.0.1.1)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mike,

> Fixes: 3e54c5890c87a ("Bluetooth: hci_event: Use of a function table to handle HCI events")
> Signed-off-by: Mike Lothian <mike@fireburn.co.uk>
> ---
> net/bluetooth/hci_event.c | 8 --------
> 1 file changed, 8 deletions(-)
> 
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index fc30f4c03d29..aa57fccd2e47 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -6818,14 +6818,6 @@ static void hci_event_func(struct hci_dev *hdev, u8 event, struct sk_buff *skb,
> 		return;
> 	}
> 
> -	/* Just warn if the length is over max_len size it still be
> -	 * possible to partially parse the event so leave to callback to
> -	 * decide if that is acceptable.
> -	 */
> -	if (skb->len > ev->max_len)
> -		bt_dev_warn(hdev, "unexpected event 0x%2.2x length: %u > %u",
> -			    event, skb->len, ev->max_len);
> -

which event type is this? You need to have a commit message giving details. I am also pretty sure that this is broken hardware and we can go for ratelimited version, but the warning is justified if the hardware is stupid. If our table is wrong, we fix the table, but not just silence an unpleasant warning.

Regards

Marcel

