Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAAB2DEB30
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 22:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgLRVkF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Dec 2020 16:40:05 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:32840 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgLRVkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 16:40:05 -0500
Received: from marcel-macbook.holtmann.net (p4fefcdf9.dip0.t-ipconnect.de [79.239.205.249])
        by mail.holtmann.org (Postfix) with ESMTPSA id D4C92CED31;
        Fri, 18 Dec 2020 22:46:39 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: [PATCH v2 1/4] Bluetooth: Keep MSFT ext info throughout a
 hci_dev's life cycle
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201217145149.v2.1.Id9bc5434114de07512661f002cdc0ada8b3d6d02@changeid>
Date:   Fri, 18 Dec 2020 22:39:22 +0100
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Archie Pusaka <apusaka@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7B6FEB99-5102-4A67-986C-4A5DEFDE2166@holtmann.org>
References: <20201217145149.v2.1.Id9bc5434114de07512661f002cdc0ada8b3d6d02@changeid>
To:     Miao-chen Chou <mcchou@chromium.org>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Miao-chen,

> This moves msft_do_close() from hci_dev_do_close() to
> hci_unregister_dev() to avoid clearing MSFT extension info. This also
> avoids retrieving MSFT info upon every msft_do_open() if MSFT extension
> has been initialized.

what is the actual benefit of this?

It is fundamentally one extra HCI command and that one does no harm. You are trying to outsmart the hdev->setup vs the !hdev->setup case. I don’t think this is a good idea.

So unless I see a real argument why we want to do this, I am leaving this patch out. And on a side note, I named these function exactly this way so they are symmetric with hci_dev_do_{open,close}.

Regards

Marcel

