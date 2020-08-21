Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F1024DE7C
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 19:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgHURcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 13:32:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgHURcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 13:32:20 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E894820702;
        Fri, 21 Aug 2020 17:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598031140;
        bh=O1LmwagaL9tB/qEvBdC+zdgHXxtjCloosICdyKLKJf4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jtfhHMotBq3o9L3lqhkmSSdpsPk+OOGu8CcDfRObqDZGGimXI/e6axpfiW88inHuC
         dKXStK8rRghUG1EB3MqHwaR3aGuWrGtN51nIBjdG/dGr/X4yC/cRvutlqNIOhinbly
         okM8CqH4gTQrDkBBRgHCIymXsJCgdHWNyANzvl5c=
Date:   Fri, 21 Aug 2020 10:32:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH v6 net-next 04/10] qed: implement devlink info request
Message-ID: <20200821103218.6d1cb211@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200820185204.652-5-irusskikh@marvell.com>
References: <20200820185204.652-1-irusskikh@marvell.com>
        <20200820185204.652-5-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Aug 2020 21:51:58 +0300 Igor Russkikh wrote:
> Here we return existing fw & mfw versions, we also fetch device's
> serial number:
> 
> ~$ sudo ~/iproute2/devlink/devlink  dev info
> pci/0000:01:00.1:
>   driver qed
>   board.serial_number REE1915E44552
>   versions:
>       running:
>         fw.app 8.42.2.0
>       stored:
>         fw.mgmt 8.52.10.0

Are you not able to report the running version of the stored firmware?
The two sections are used for checking if machine needs fw-activation
or reboot (i.e. if fw.mgmt in stored section does not match fw.mgmt in
running - there is a new FW to activate).

> MFW and FW are different firmwares on device.
> Management is a firmware responsible for link configuration and
> various control plane features. Its permanent and resides in NVM.
> 
> Running FW (or fastpath FW) is an embedded microprogram implementing
> all the packet processing, offloads, etc. This FW is being loaded
> on each start by the driver from FW binary blob.
> 
> The base device specific structure (qed_dev_info) was not directly
> available to the base driver before. Thus, here we create and store
> a private copy of this structure in qed_dev root object to
> access the data.

In general looks good:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
