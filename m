Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC914CBDE8
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 13:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbiCCMi3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Mar 2022 07:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbiCCMi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 07:38:28 -0500
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D71542559E;
        Thu,  3 Mar 2022 04:37:39 -0800 (PST)
Received: from smtpclient.apple (p5b3d2910.dip0.t-ipconnect.de [91.61.41.16])
        by mail.holtmann.org (Postfix) with ESMTPSA id A504ECED23;
        Thu,  3 Mar 2022 13:37:38 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.60.0.1.1\))
Subject: Re: [PATCH v2] bluetooth: hci_event: don't print an error on vendor
 events
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CABBYNZJPN6o-v2OpAXND0+UfwB3AQL2=r6CDQ0S8PktWZqijMw@mail.gmail.com>
Date:   Thu, 3 Mar 2022 13:37:38 +0100
Cc:     Caleb Connolly <caleb.connolly@linaro.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <E6952D0A-FFF7-409E-8779-F82FC4DE9252@holtmann.org>
References: <20220302183515.448334-1-caleb.connolly@linaro.org>
 <21F7790B-8849-4131-AF09-4E622B1A9E9D@holtmann.org>
 <CABBYNZJPN6o-v2OpAXND0+UfwB3AQL2=r6CDQ0S8PktWZqijMw@mail.gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
X-Mailer: Apple Mail (2.3693.60.0.1.1)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

>>> Since commit 3e54c5890c87 ("Bluetooth: hci_event: Use of a function table to handle HCI events"),
>>> some devices see warnings being printed for vendor events, e.g.
>>> 
>>> [   75.806141] Bluetooth: hci0: setting up wcn399x
>>> [   75.948311] Bluetooth: hci0: unexpected event 0xff length: 14 > 0
>>> [   75.955552] Bluetooth: hci0: QCA Product ID   :0x0000000a
>>> [   75.961369] Bluetooth: hci0: QCA SOC Version  :0x40010214
>>> [   75.967417] Bluetooth: hci0: QCA ROM Version  :0x00000201
>>> [   75.973363] Bluetooth: hci0: QCA Patch Version:0x00000001
>>> [   76.000289] Bluetooth: hci0: QCA controller version 0x02140201
>>> [   76.006727] Bluetooth: hci0: QCA Downloading qca/crbtfw21.tlv
>>> [   76.986850] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.013574] Bluetooth: hci0: QCA Downloading qca/oneplus6/crnv21.bin
>>> [   77.024302] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.032681] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.040674] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.049251] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.057997] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.066320] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.075065] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.083073] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.091250] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.099417] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.110166] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.118672] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.127449] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.137190] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.146192] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.154242] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.163183] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.171202] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.179364] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.187259] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
>>> [   77.198451] Bluetooth: hci0: QCA setup on UART is completed
>>> 
>>> Avoid printing the event length warning for vendor events, this reverts
>>> to the previous behaviour where such warnings weren't printed.
>>> 
>>> Fixes: 3e54c5890c87 ("Bluetooth: hci_event: Use of a function table to handle HCI events")
>>> Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
>>> ---
>>> Changes since v1:
>>> * Don't return early! Vendor events still get parsed despite the
>>>  warning. I should have looked a little more closely at that...
>>> ---
>>> net/bluetooth/hci_event.c | 2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> patch has been applied to bluetooth-stable tree.
>> 
> I believe a proper fix has already been pushed to bluetooth-next:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/commit/?id=314d8cd2787418c5ac6b02035c344644f47b292b
> 
> HCI_EV_VENDOR shall be assumed to be variable length and that also
> uses bt_dev_warn_ratelimited to avoid spamming the logs in case it
> still fails.

ok, I reverted the patch and lets this go via net-next tree then. Stable can pick this up if it really becomes a larger problem.

Regards

Marcel

