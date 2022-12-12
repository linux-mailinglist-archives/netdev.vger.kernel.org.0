Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D14C64A8CA
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 21:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbiLLUgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 15:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbiLLUg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 15:36:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AAE17A9E;
        Mon, 12 Dec 2022 12:36:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CED76B80DE1;
        Mon, 12 Dec 2022 20:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4747FC433EF;
        Mon, 12 Dec 2022 20:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670877385;
        bh=GFKX00KptgQkZO6x8ckoloLJoTdZ/QDMyw83O7wDEsY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C0v1YPWOiKRaAswtWfjJZaBQp9PBmMTpi6HZ6dQnEZ8lRRYZfQmlXD2huzEDPhQlz
         06RZ6vh05uUZfXjKDuIDvosh/OKKoI3/5hUTQvIZ46hVIVxQb0zS3lSpev8R8OxATm
         jNtrUsHczZPJBmMceX/OGC9GfWVtywibZwjcall5iXuhforf0be3/et0o6eIHeFuBs
         /F1dbuHda9a8c2+cl6VDSPuBsC31FT+mZ8J4wdSA0KmBK5wzhCjivhMabdoJwHSWfm
         4V8uuDLzvdXpJv5EXd3WsORTAiSYQ7ZvpbEP1XR0pej+4CUXd0xgN0yniKGGPkvtV4
         6C925Bw7i8FVQ==
Date:   Mon, 12 Dec 2022 12:36:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2022-12-09
Message-ID: <20221212123624.6c797838@kernel.org>
In-Reply-To: <20221210013456.1085082-1-luiz.dentz@gmail.com>
References: <20221210013456.1085082-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Dec 2022 17:34:56 -0800 Luiz Augusto von Dentz wrote:
> bluetooth-next pull request for net-next:
> 
>  - Add a new VID/PID 0489/e0f2 for MT7922
>  - Add Realtek RTL8852BE support ID 0x0cb8:0xc559
>  - Add a new PID/VID 13d3/3549 for RTL8822CU
>  - Add support for broadcom BCM43430A0 & BCM43430A1
>  - Add CONFIG_BT_HCIBTUSB_POLL_SYNC
>  - Add CONFIG_BT_LE_L2CAP_ECRED
>  - Add support for CYW4373A0
>  - Add support for RTL8723DS
>  - Add more device IDs for WCN6855
>  - Add Broadcom BCM4377 family PCIe Bluetooth

Hm, it's pulling in the commits we merged into net and which 
are already present in net-next but with a different hash/id.

With a small overlap which git can't figure out:

diff --cc drivers/bluetooth/btusb.c
index f05018988a17,2ad4efdd9e40..24a8ed3f0458
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@@ -2052,17 -2206,17 +2206,22 @@@ static int btusb_setup_csr(struct hci_d
                bt_dev_err(hdev, "CSR: Local version length mismatch");
                kfree_skb(skb);
                return -EIO;
        }
  
-       rp = (struct hci_rp_read_local_version *)skb->data;
+       bt_dev_info(hdev, "CSR: Setting up dongle with HCI ver=%u rev=%04x",
+                   rp->hci_ver, le16_to_cpu(rp->hci_rev));
+ 
+       bt_dev_info(hdev, "LMP ver=%u subver=%04x; manufacturer=%u",
+                   rp->lmp_ver, le16_to_cpu(rp->lmp_subver),
+                   le16_to_cpu(rp->manufacturer));
  
 +      bt_dev_info(hdev, "CSR: Setting up dongle with HCI ver=%u rev=%04x; LMP ver=%u subver=%04x; manufacturer=%u",
 +              le16_to_cpu(rp->hci_ver), le16_to_cpu(rp->hci_rev),
 +              le16_to_cpu(rp->lmp_ver), le16_to_cpu(rp->lmp_subver),
 +              le16_to_cpu(rp->manufacturer));
 +

Could you rebase on top of net-next and resend so that the commits
which are already applied disappear?
