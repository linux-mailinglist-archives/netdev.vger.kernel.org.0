Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154763936EA
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 22:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235853AbhE0UQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 16:16:36 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:35264 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235819AbhE0UQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 16:16:35 -0400
Received: from smtpclient.apple (p4fefc9d6.dip0.t-ipconnect.de [79.239.201.214])
        by mail.holtmann.org (Postfix) with ESMTPSA id D0E9ECECC9;
        Thu, 27 May 2021 22:22:55 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH v2] Bluetooth: fix the erroneous flush_work() order
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210525123902.189012-1-gregkh@linuxfoundation.org>
Date:   Thu, 27 May 2021 22:14:59 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linma <linma@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Hao Xiong <mart1n@zju.edu.cn>, stable <stable@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <BF0493D4-AB96-44D3-8229-9EA6D084D260@holtmann.org>
References: <20210525123902.189012-1-gregkh@linuxfoundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

> In the cleanup routine for failed initialization of HCI device,
> the flush_work(&hdev->rx_work) need to be finished before the
> flush_work(&hdev->cmd_work). Otherwise, the hci_rx_work() can
> possibly invoke new cmd_work and cause a bug, like double free,
> in late processings.
> 
> This was assigned CVE-2021-3564.
> 
> This patch reorder the flush_work() to fix this bug.
> 
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: Johan Hedberg <johan.hedberg@gmail.com>
> Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-bluetooth@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Lin Ma <linma@zju.edu.cn>
> Signed-off-by: Hao Xiong <mart1n@zju.edu.cn>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> net/bluetooth/hci_core.c | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)

patch has been applied to bluetooth-stable tree.

Regards

Marcel

