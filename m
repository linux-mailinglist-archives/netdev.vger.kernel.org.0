Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93869198389
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 20:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgC3SlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 14:41:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40794 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgC3SlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 14:41:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4859015C5CEC6;
        Mon, 30 Mar 2020 11:41:05 -0700 (PDT)
Date:   Mon, 30 Mar 2020 11:41:04 -0700 (PDT)
Message-Id: <20200330.114104.1458740005557474727.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/8] ionic support for firmware upgrade
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200328031448.50794-1-snelson@pensando.io>
References: <20200328031448.50794-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 11:41:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Fri, 27 Mar 2020 20:14:40 -0700

> The Pensando Distributed Services Card can get firmware upgrades from
> the off-host centralized management suite, and can be upgraded without a
> host reboot or driver reload.  This patchset sets up the support for fw
> upgrade in the Linux driver.
> 
> When the upgrade begins, the DSC first brings the link down, then stops
> the firmware.  The driver will notice this and quiesce itself by stopping
> the queues and releasing DMA resources, then monitoring for firmware to
> start back up.  When the upgrade is finished the firmware is restarted
> and link is brought up, and the driver rebuilds the queues and restarts
> traffic flow.
> 
> First we separate the Link state from the netdev state, then reorganize a
> few things to prepare for partial tear-down of the queues.  Next we fix
> up the state machine so that we take the Tx and Rx queues down and back
> up when we get LINK_DOWN and LINK_UP events.  Lastly, we add handling of
> the FW reset itself by tearing down the lif internals and rebuilding them
> with the new FW setup.
> 
> v2: This changes the design from (ab)using the full .ndo_stop and
>     .ndo_open routines to getting a better separation between the
>     alloc and the init functions so that we can keep our resource
>     allocations as long as possible.

Series applied, thank you.
