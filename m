Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF68B15DA02
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 15:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbgBNO6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 09:58:39 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:37432 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729241AbgBNO6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 09:58:38 -0500
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 3FA2ACECE6;
        Fri, 14 Feb 2020 16:08:00 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [Bluez PATCH v5] bluetooth: secure bluetooth stack from bluedump
 attack
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200214191609.Bluez.v5.1.Ia71869d2f3e19a76a6a352c61088a085a1d41ba6@changeid>
Date:   Fri, 14 Feb 2020 15:58:36 +0100
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <FCBA4B93-8249-4557-96C1-83060CFA8640@holtmann.org>
References: <20200214191609.Bluez.v5.1.Ia71869d2f3e19a76a6a352c61088a085a1d41ba6@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> Attack scenario:
> 1. A Chromebook (let's call this device A) is paired to a legitimate
>   Bluetooth classic device (e.g. a speaker) (let's call this device
>   B).
> 2. A malicious device (let's call this device C) pretends to be the
>   Bluetooth speaker by using the same BT address.
> 3. If device A is not currently connected to device B, device A will
>   be ready to accept connection from device B in the background
>   (technically, doing Page Scan).
> 4. Therefore, device C can initiate connection to device A
>   (because device A is doing Page Scan) and device A will accept the
>   connection because device A trusts device C's address which is the
>   same as device B's address.
> 5. Device C won't be able to communicate at any high level Bluetooth
>   profile with device A because device A enforces that device C is
>   encrypted with their common Link Key, which device C doesn't have.
>   But device C can initiate pairing with device A with just-works
>   model without requiring user interaction (there is only pairing
>   notification). After pairing, device A now trusts device C with a
>   new different link key, common between device A and C.
> 6. From now on, device A trusts device C, so device C can at anytime
>   connect to device A to do any kind of high-level hijacking, e.g.
>   speaker hijack or mouse/keyboard hijack.
> 
> Since we don't know whether the repairing is legitimate or not,
> leave the decision to user space if all the conditions below are met.
> - the pairing is initialized by peer
> - the authorization method is just-work
> - host already had the link key to the peer
> 
> Signed-off-by: Howard Chung <howardchung@google.com>
> ---
> 
> Changes in v5:
> - Rephrase the comment
> 
> Changes in v4:
> - optimise the check in smp.c.
> 
> Changes in v3:
> - Change confirm_hint from 2 to 1
> - Fix coding style (declaration order)
> 
> Changes in v2:
> - Remove the HCI_PERMIT_JUST_WORK_REPAIR debugfs option
> - Fix the added code in classic
> - Add a similar fix for LE
> 
> net/bluetooth/hci_event.c | 10 ++++++++++
> net/bluetooth/smp.c       | 19 +++++++++++++++++++
> 2 files changed, 29 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

