Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266A135E699
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 20:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbhDMSlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 14:41:10 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:56536 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhDMSlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 14:41:09 -0400
Received: from marcel-macbook.holtmann.net (p5b3d235a.dip0.t-ipconnect.de [91.61.35.90])
        by mail.holtmann.org (Postfix) with ESMTPSA id 20EA6CECCC;
        Tue, 13 Apr 2021 20:48:30 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] net: bluetooth: cmtp: fix file refcount when
 cmtp_attach_device fails
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210413162103.435467-1-cascardo@canonical.com>
Date:   Tue, 13 Apr 2021 20:40:45 +0200
Cc:     "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, isdn@linux-pingi.de,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Content-Transfer-Encoding: 7bit
Message-Id: <0E9D2620-A821-410F-9DED-4465568F6701@holtmann.org>
References: <20210413162103.435467-1-cascardo@canonical.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thadeu,

> When cmtp_attach_device fails, cmtp_add_connection returns the error value
> which leads to the caller to doing fput through sockfd_put. But
> cmtp_session kthread, which is stopped in this path will also call fput,
> leading to a potential refcount underflow or a use-after-free.
> 
> Add a refcount before we signal the kthread to stop. The kthread will try
> to grab the cmtp_session_sem mutex before doing the fput, which is held
> when get_file is called, so there should be no races there.
> 
> Reported-by: Ryota Shiga
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> ---
> net/bluetooth/cmtp/core.c | 5 +++++
> 1 file changed, 5 insertions(+)

Patch has been applied to bluetooth-next tree.

Regards

Marcel

