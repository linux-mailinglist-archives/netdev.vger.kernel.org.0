Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1161731CF
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 08:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgB1HcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 02:32:14 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:45131 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgB1HcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 02:32:13 -0500
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id A3CF5CECF5;
        Fri, 28 Feb 2020 08:41:37 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH][next] Bluetooth: Replace zero-length array with
 flexible-array member
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200226230227.GA31639@embeddedor>
Date:   Fri, 28 Feb 2020 08:32:10 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <1E945B13-0BCB-4908-BA32-87DC0F982154@holtmann.org>
References: <20200226230227.GA31639@embeddedor>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gustavo,

> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>        int stuff;
>        struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
> 
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
> 
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
> 
> This issue was found with the help of Coccinelle.
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
> drivers/bluetooth/btqca.h        |  6 +++---
> drivers/bluetooth/btrtl.h        |  4 ++--
> include/net/bluetooth/hci.h      | 30 +++++++++++++++---------------
> include/net/bluetooth/hci_sock.h |  6 +++---
> include/net/bluetooth/l2cap.h    |  8 ++++----
> include/net/bluetooth/rfcomm.h   |  2 +-
> net/bluetooth/a2mp.h             | 10 +++++-----
> net/bluetooth/bnep/bnep.h        |  6 +++---
> 8 files changed, 36 insertions(+), 36 deletions(-)

Patch has been applied to bluetooth-next tree.

Regards

Marcel

