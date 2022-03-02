Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891214CAE88
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbiCBTVk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Mar 2022 14:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiCBTVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:21:40 -0500
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 508F76D970;
        Wed,  2 Mar 2022 11:20:56 -0800 (PST)
Received: from smtpclient.apple (p5b3d2910.dip0.t-ipconnect.de [91.61.41.16])
        by mail.holtmann.org (Postfix) with ESMTPSA id 7696CCED12;
        Wed,  2 Mar 2022 20:20:55 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.60.0.1.1\))
Subject: Re: [PATCH v2] bluetooth: hci_event: don't print an error on vendor
 events
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20220302183515.448334-1-caleb.connolly@linaro.org>
Date:   Wed, 2 Mar 2022 20:20:55 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <21F7790B-8849-4131-AF09-4E622B1A9E9D@holtmann.org>
References: <20220302183515.448334-1-caleb.connolly@linaro.org>
To:     Caleb Connolly <caleb.connolly@linaro.org>
X-Mailer: Apple Mail (2.3693.60.0.1.1)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Caleb,

> Since commit 3e54c5890c87 ("Bluetooth: hci_event: Use of a function table to handle HCI events"),
> some devices see warnings being printed for vendor events, e.g.
> 
> [   75.806141] Bluetooth: hci0: setting up wcn399x
> [   75.948311] Bluetooth: hci0: unexpected event 0xff length: 14 > 0
> [   75.955552] Bluetooth: hci0: QCA Product ID   :0x0000000a
> [   75.961369] Bluetooth: hci0: QCA SOC Version  :0x40010214
> [   75.967417] Bluetooth: hci0: QCA ROM Version  :0x00000201
> [   75.973363] Bluetooth: hci0: QCA Patch Version:0x00000001
> [   76.000289] Bluetooth: hci0: QCA controller version 0x02140201
> [   76.006727] Bluetooth: hci0: QCA Downloading qca/crbtfw21.tlv
> [   76.986850] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.013574] Bluetooth: hci0: QCA Downloading qca/oneplus6/crnv21.bin
> [   77.024302] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.032681] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.040674] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.049251] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.057997] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.066320] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.075065] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.083073] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.091250] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.099417] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.110166] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.118672] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.127449] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.137190] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.146192] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.154242] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.163183] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.171202] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.179364] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.187259] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
> [   77.198451] Bluetooth: hci0: QCA setup on UART is completed
> 
> Avoid printing the event length warning for vendor events, this reverts
> to the previous behaviour where such warnings weren't printed.
> 
> Fixes: 3e54c5890c87 ("Bluetooth: hci_event: Use of a function table to handle HCI events")
> Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
> ---
> Changes since v1:
> * Don't return early! Vendor events still get parsed despite the
>   warning. I should have looked a little more closely at that...
> ---
> net/bluetooth/hci_event.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

patch has been applied to bluetooth-stable tree.

Regards

Marcel

