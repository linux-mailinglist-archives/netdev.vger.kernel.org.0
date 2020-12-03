Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EAF2CD5C2
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 13:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbgLCMrx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Dec 2020 07:47:53 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:53060 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgLCMrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 07:47:52 -0500
Received: from marcel-macbook.holtmann.net (unknown [37.83.193.87])
        by mail.holtmann.org (Postfix) with ESMTPSA id 03DFBCECFB;
        Thu,  3 Dec 2020 13:54:19 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.21\))
Subject: Re: [PATCH v6 0/5] Bluetooth: Add new MGMT interface for advertising
 add
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201130225744.3793244-1-danielwinkler@google.com>
Date:   Thu, 3 Dec 2020 13:47:02 +0100
Cc:     BlueZ development <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7F86588C-4CB8-43C7-A6D0-25C9BF722C56@holtmann.org>
References: <20201130225744.3793244-1-danielwinkler@google.com>
To:     Daniel Winkler <danielwinkler@google.com>
X-Mailer: Apple Mail (2.3654.20.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

> This patch series defines the new two-call MGMT interface for adding
> new advertising instances. Similarly to the hci advertising commands, a
> mgmt call to set parameters is expected to be first, followed by a mgmt
> call to set advertising data/scan response. The members of the
> parameters request are optional; the caller defines a "params" bitfield
> in the structure that indicates which parameters were intentionally set,
> and others are set to defaults.
> 
> The main feature here is the introduction of min/max parameters and tx
> power that can be requested by the client. Min/max parameters will be
> used both with and without extended advertising support, and tx power
> will be used with extended advertising support. After a call to set
> advertising parameters, the selected transmission power will be
> propagated in the reponse to alert userspace to the actual power used.
> 
> Additionally, to inform userspace of the controller LE Tx power
> capabilities for the client's benefit, this series also changes the
> security info MGMT command to more flexibly contain other capabilities,
> such as LE min and max tx power.
> 
> All changes have been tested on hatch (extended advertising) and kukui
> (no extended advertising) chromebooks with manual testing verifying
> correctness of parameters/data in btmon traces, and our automated test
> suite of 25 single- and multi-advertising usage scenarios.
> 
> A separate patch series will add support in bluetoothd. Thanks in
> advance for your feedback!
> 
> Daniel Winkler
> 
> 
> Changes in v6:
> - Only populate LE tx power range if controller reports it
> 
> Changes in v5:
> - Ensure data/scan rsp length is returned for non-ext adv
> 
> Changes in v4:
> - Add remaining data and scan response length to MGMT params response
> - Moving optional params into 'flags' field of MGMT command
> - Combine LE tx range into a single EIR field for MGMT capabilities cmd
> 
> Changes in v3:
> - Adding selected tx power to adv params mgmt response, removing event
> - Re-using security info MGMT command to carry controller capabilities
> 
> Changes in v2:
> - Fixed sparse error in Capabilities MGMT command
> 
> Daniel Winkler (5):
>  Bluetooth: Add helper to set adv data
>  Bluetooth: Break add adv into two mgmt commands
>  Bluetooth: Use intervals and tx power from mgmt cmds
>  Bluetooth: Query LE tx power on startup
>  Bluetooth: Change MGMT security info CMD to be more generic
> 
> include/net/bluetooth/hci.h      |   7 +
> include/net/bluetooth/hci_core.h |  12 +-
> include/net/bluetooth/mgmt.h     |  49 +++-
> net/bluetooth/hci_core.c         |  47 +++-
> net/bluetooth/hci_event.c        |  19 ++
> net/bluetooth/hci_request.c      |  29 ++-
> net/bluetooth/mgmt.c             | 430 +++++++++++++++++++++++++++++--
> 7 files changed, 548 insertions(+), 45 deletions(-)

I am having problem with patch 3/5 which does not apply cleanly against bluetooth-next. Can you please fix it and re-send. Thanks.

Regards

Marcel

