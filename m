Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3FA1ED54A
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 19:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgFCRu3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 3 Jun 2020 13:50:29 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:47845 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgFCRu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 13:50:29 -0400
Received: from marcel-macbook.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id 09C1DCED2F;
        Wed,  3 Jun 2020 20:00:15 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] Bluetooth: Terminate the link if pairing is cancelled
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CAGPPCLC_NkrrjiOT_LgmFV83rOgMab5e+M-S=zDHu_OMKD2-TA@mail.gmail.com>
Date:   Wed, 3 Jun 2020 19:50:26 +0200
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <61400662-2434-4D7F-B9D1-19CC698645DC@holtmann.org>
References: <20200414115512.1.I9dd050ead919f2cc3ef83d4e866de537c7799cf3@changeid>
 <DF70A2DA-9E5F-4524-8F20-2EC7CF70597F@holtmann.org>
 <CABBYNZ+1XLttkvoBzLR6iCguB2Atrr0+PA5isnD9Cg2af2TFKA@mail.gmail.com>
 <96B8EB2A-BDFB-49F5-B168-F8FD2991FC33@holtmann.org>
 <CAGPPCLC_NkrrjiOT_LgmFV83rOgMab5e+M-S=zDHu_OMKD2-TA@mail.gmail.com>
To:     Manish Mandlik <mmandlik@google.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

> Based on your feedback, in the BlueZ kernel, if we plan to track whether the link was created because of Pair Device action or not, we'll need to add a flag in struch hci_conn and update related functions/APIs. I was wondering if this would look like a clean fix or not. 
> 
> Another option could be disconnecting from BlueZ daemon while handling 'cancel pairing' user request. But the problem with this approach is that there is no way to request the kernel to send SMP failure PDU with the existing implementation.
> 
> Third option could be handling this in the chromium and requesting a disconnect when the user hits the cancel button. I believe Ubuntu/Android are taking a similar approach. However, on Android, if the 'cancel' button is selected on the pairing window, it shows 'pairing failed because of invalid passkey' message.
> 
> Bluetooth specification doesn't have any mention about how to handle the pairing cancel case. Based on the statistics we have for ChromeOS, over 60% pairing attempts are cancelled by users. Since the link is not terminated, the bluetooth keyboard keeps on requesting to enter a new passkey even if the user selects to cancel the pairing and there is no way to cancel the pairing process.
> 
> Can you please help me select the better approach to handle the pairing cancel case? Should we need to propose this to be addressed in the Bluetooth Specification as well?

are we sending Cancel Pairing correctly? If so and we only care about the cancel case, then I would just track if the connection was triggered by a pairing and then only cancel pairing terminate the connection.

Regards

Marcel

