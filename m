Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021882A11BE
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 00:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgJ3XqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 19:46:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgJ3XqJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 19:46:09 -0400
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1388C208B6;
        Fri, 30 Oct 2020 23:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604101569;
        bh=ZfF4RTtFvziN1B/oL/EJPYQE9v7+IqqByCucjDK5Mwc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Aw6BqvbF8qTCx4t2/v92dqtd/Fz9gsGVCD0bo4nRqtK/VnIAVismWlLDHnseLrVPT
         GMUEbG+7da2H+82H+x3JwiAJdF1WkIq4ZiqDyp6kIgUih6q3GjRRANJBZYOVWGad9z
         E1U5YxvsnzYSurwDpznQ0n4qVKbbbgX6YPUstUTQ=
Date:   Sat, 31 Oct 2020 00:45:56 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Whitten <ben.whitten@gmail.com>
Subject: Re: [PATCH RFC leds + net-next 2/7] leds: trigger: netdev: simplify
 the driver by using bit field members
Message-ID: <20201031004556.32c61a9d@kernel.org>
In-Reply-To: <64419e33-ffcd-4082-01bd-3370dae86b4b@gmail.com>
References: <20201030114435.20169-1-kabel@kernel.org>
        <20201030114435.20169-3-kabel@kernel.org>
        <64419e33-ffcd-4082-01bd-3370dae86b4b@gmail.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 23:37:52 +0100
Jacek Anaszewski <jacek.anaszewski@gmail.com> wrote:

> Hi Marek,
> 
> Bitops are guaranteed to be atomic and this was done for a reason.

Hmm okay...
Sooo, netdev_trig_work cannot be executed at the same time as the
link/linkup/rx/tx changing stuff from netdev_trig_notify,
interval_store or netdev_led_attr_store, because all these functions
ensure cancelation of netdev_trig_work by calling
cancel_delayed_work_sync. Doesn't this somehow prevent the need for
memory barriers provided by atomic bitops?

BTW Jacek what do you think about the other patches?

Marek
