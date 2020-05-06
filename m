Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15DD1C6EEC
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgEFLJa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 May 2020 07:09:30 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:56688 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbgEFLJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:09:30 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 93695CED03;
        Wed,  6 May 2020 13:19:09 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] Bluetooth: Terminate the link if pairing is cancelled
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CABBYNZ+1XLttkvoBzLR6iCguB2Atrr0+PA5isnD9Cg2af2TFKA@mail.gmail.com>
Date:   Wed, 6 May 2020 13:09:27 +0200
Cc:     Manish Mandlik <mmandlik@google.com>,
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
Message-Id: <96B8EB2A-BDFB-49F5-B168-F8FD2991FC33@holtmann.org>
References: <20200414115512.1.I9dd050ead919f2cc3ef83d4e866de537c7799cf3@changeid>
 <DF70A2DA-9E5F-4524-8F20-2EC7CF70597F@holtmann.org>
 <CABBYNZ+1XLttkvoBzLR6iCguB2Atrr0+PA5isnD9Cg2af2TFKA@mail.gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

>>> If user decides to cancel ongoing pairing process (e.g. by clicking
>>> the cancel button on the pairing/passkey window), abort any ongoing
>>> pairing and then terminate the link.
>>> 
>>> Signed-off-by: Manish Mandlik <mmandlik@google.com>
>>> ---
>>> Hello Linux-Bluetooth,
>>> 
>>> This patch aborts any ongoing pairing and then terminates the link
>>> by calling hci_abort_conn() in cancel_pair_device() function.
>>> 
>>> However, I'm not very sure if hci_abort_conn() should be called here
>>> in cancel_pair_device() or in smp for example to terminate the link
>>> after it had sent the pairing failed PDU.
>>> 
> 
> Id recommend leaving the hci_abort_conn out since that is a policy
> decision the userspace should be in charge to decide if the link
> should be disconnected or not.

eventually the link will disconnect anyway if we have no users. However maybe we should try to track if we created the link because Pair Device action. If created the link, then aborting the pairing should disconnect the link right away. Otherwise we can leave it around.

Regards

Marcel

