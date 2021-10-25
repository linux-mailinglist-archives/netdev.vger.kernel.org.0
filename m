Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDA4439701
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 15:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbhJYNF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 09:05:27 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:59972 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233119AbhJYNF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 09:05:27 -0400
Received: from smtpclient.apple (p4ff9f2d2.dip0.t-ipconnect.de [79.249.242.210])
        by mail.holtmann.org (Postfix) with ESMTPSA id 12726CED17;
        Mon, 25 Oct 2021 15:03:03 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH v2] Bluetooth: cmtp: fix possible panic when
 cmtp_init_sockets() fails
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211025131012.2771062-1-wanghai38@huawei.com>
Date:   Mon, 25 Oct 2021 15:03:02 +0200
Cc:     Karsten Keil <isdn@linux-pingi.de>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        cascardo@canonical.com, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <0A1C459E-C477-431B-8338-3F281BBED207@holtmann.org>
References: <20211025131012.2771062-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wang,

> I got a kernel BUG report when doing fault injection test:
> 
> ------------[ cut here ]------------
> kernel BUG at lib/list_debug.c:45!
> ...
> RIP: 0010:__list_del_entry_valid.cold+0x12/0x4d
> ...
> Call Trace:
> proto_unregister+0x83/0x220
> cmtp_cleanup_sockets+0x37/0x40 [cmtp]
> cmtp_exit+0xe/0x1f [cmtp]
> do_syscall_64+0x35/0xb0
> entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> If cmtp_init_sockets() in cmtp_init() fails, cmtp_init() still returns
> success. This will cause a kernel bug when accessing uncreated ctmp
> related data when the module exits.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
> v1->v2: remove the temporary variable "err"
> net/bluetooth/cmtp/core.c | 4 +---
> 1 file changed, 1 insertion(+), 3 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

