Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE483FB8AE
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 17:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237417AbhH3PDT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Aug 2021 11:03:19 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:46703 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237236AbhH3PDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 11:03:18 -0400
Received: from smtpclient.apple (p5b3d2185.dip0.t-ipconnect.de [91.61.33.133])
        by mail.holtmann.org (Postfix) with ESMTPSA id 44716CEC82;
        Mon, 30 Aug 2021 17:02:23 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH v5] Bluetooth: Keep MSFT ext info throughout a hci_dev's
 life cycle
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210819202819.v5.1.Id9bc5434114de07512661f002cdc0ada8b3d6d02@changeid>
Date:   Mon, 30 Aug 2021 17:02:22 +0200
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Archie Pusaka <apusaka@chromium.org>,
        "open list:BLUETOOTH SUBSYSTEM" <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6670BE33-A403-43AC-B422-C4F363BEBC9C@holtmann.org>
References: <20210819202819.v5.1.Id9bc5434114de07512661f002cdc0ada8b3d6d02@changeid>
To:     Manish Mandlik <mmandlik@google.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

> This moves msft_do_close() from hci_dev_do_close() to
> hci_unregister_dev() to avoid clearing MSFT extension info. This also
> re-reads MSFT info upon every msft_do_open() even if MSFT extension has
> been initialized.
> 
> The following test steps were performed.
> (1) boot the test device and verify the MSFT support debug log in syslog
> (2) restart bluetoothd and verify msft_do_close() doesn't get invoked
>    and msft_do_open re-reads the MSFT support.

so tell me how this can be correct. The msft_do_close does cleanup of instances. If we close the device via power down I would expect that these instances are cleared. Do they survive a HCI Reset command?

I think it would be better to introduce an additional msft_register / msft_unregister pair if this needs to be more complex.

Regards

Marcel

