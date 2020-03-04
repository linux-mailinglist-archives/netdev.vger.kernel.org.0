Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8A2B179B7F
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 23:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388425AbgCDWEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 17:04:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46574 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728955AbgCDWEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 17:04:13 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C288715AD58E7;
        Wed,  4 Mar 2020 14:04:12 -0800 (PST)
Date:   Wed, 04 Mar 2020 14:04:10 -0800 (PST)
Message-Id: <20200304.140410.731261448085906331.davem@davemloft.net>
To:     vithampi@vmware.com
Cc:     richardcochran@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Pv-drivers@vmware.com,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        thellstrom@vmware.com, jgross@suse.com
Subject: Re: [PATCH RESEND] ptp: add VMware virtual PTP clock driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200228053230.GA457139@sc2-cpbu2-b0737.eng.vmware.com>
References: <20200228053230.GA457139@sc2-cpbu2-b0737.eng.vmware.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Mar 2020 14:04:13 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivek Thampi <vithampi@vmware.com>
Date: Fri, 28 Feb 2020 05:32:46 +0000

> Add a PTP clock driver called ptp_vmw, for guests running on VMware ESXi
> hypervisor. The driver attaches to a VMware virtual device called
> "precision clock" that provides a mechanism for querying host system time.
> Similar to existing virtual PTP clock drivers (e.g. ptp_kvm), ptp_vmw
> utilizes the kernel's PTP hardware clock API to implement a clock device
> that can be used as a reference in Chrony for synchronizing guest time with
> host.
> 
> The driver is only applicable to x86 guests running in VMware virtual
> machines with precision clock virtual device present. It uses a VMware
> specific hypercall mechanism to read time from the device.
> 
> Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
> Signed-off-by: Vivek Thampi <vithampi@vmware.com>
> ---
>  Based on feedback, resending patch to include a broader audience.

If it's just providing a read of an accurate timesource, I think it's kinda
pointless to provide a full PTP driver for it.
