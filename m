Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76449417025
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 12:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245615AbhIXKP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 06:15:58 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:54405 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245423AbhIXKP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 06:15:57 -0400
Received: from smtpclient.apple (p5b3d2185.dip0.t-ipconnect.de [91.61.33.133])
        by mail.holtmann.org (Postfix) with ESMTPSA id 24611CECF2;
        Fri, 24 Sep 2021 12:14:23 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH v3] bluetooth: Fix Advertisement Monitor Suspend/Resume
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210921144640.v3.1.Ib31940aba2253e3f25cbca09a2d977d27170e163@changeid>
Date:   Fri, 24 Sep 2021 12:14:22 +0200
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Archie Pusaka <apusaka@google.com>,
        Miao-chen Chou <mcchou@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <9D93B868-B8DE-4C0E-B055-A2BB3B93528F@holtmann.org>
References: <20210921144640.v3.1.Ib31940aba2253e3f25cbca09a2d977d27170e163@changeid>
To:     Manish Mandlik <mmandlik@google.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

> During system suspend, advertisement monitoring is disabled by setting
> the HCI_VS_MSFT_LE_Set_Advertisement_Filter_Enable to False. This
> disables the monitoring during suspend, however, if the controller is
> monitoring a device, it sends HCI_VS_MSFT_LE_Monitor_Device_Event to
> indicate that the monitoring has been stopped for that particular
> device. This event may occur after suspend depending on the
> low_threshold_timeout and peer device advertisement frequency, which
> causes early wake up.
> 
> Right way to disable the monitoring for suspend is by removing all the
> monitors before suspend and re-monitor after resume to ensure no events
> are received during suspend. This patch fixes this suspend/resume issue.
> 
> Following tests are performed:
> - Add monitors before suspend and make sure DeviceFound gets triggered
> - Suspend the system and verify that all monitors are removed by kernel
>  but not Released by bluetoothd
> - Wake up and verify that all monitors are added again and DeviceFound
>  gets triggered
> 
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> Reviewed-by: Archie Pusaka <apusaka@google.com>
> Reviewed-by: Miao-chen Chou <mcchou@google.com>
> ---
> 
> Changes in v3:
> - Updated the msft_{suspend/resume} function names
> 
> Changes in v2:
> - Updated the Reviewd-by names
> 
> net/bluetooth/hci_request.c |  15 +++--
> net/bluetooth/msft.c        | 117 +++++++++++++++++++++++++++++++-----
> net/bluetooth/msft.h        |   5 ++
> 3 files changed, 116 insertions(+), 21 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

