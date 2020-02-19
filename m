Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39F1D164E92
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 20:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgBSTLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 14:11:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46502 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgBSTLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 14:11:32 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7971015ADF486;
        Wed, 19 Feb 2020 11:11:31 -0800 (PST)
Date:   Wed, 19 Feb 2020 11:11:30 -0800 (PST)
Message-Id: <20200219.111130.5189327548859835.davem@davemloft.net>
To:     digetx@gmail.com
Cc:     sameo@linux.intel.com, david@ixit.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] nfc: pn544: Fix occasional HW initialization failure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200219150122.31524-1-digetx@gmail.com>
References: <20200219150122.31524-1-digetx@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 11:11:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>
Date: Wed, 19 Feb 2020 18:01:22 +0300

> The PN544 driver checks the "enable" polarity during of driver's probe and
> it's doing that by turning ON and OFF NFC with different polarities until
> enabling succeeds. It takes some time for the hardware to power-down, and
> thus, to deassert the IRQ that is raised by turning ON the hardware.
> Since the delay after last power-down of the polarity-checking process is
> missed in the code, the interrupt may trigger immediately after installing
> the IRQ handler (right after the checking is done), which results in IRQ
> handler trying to touch the disabled HW and ends with marking NFC as
> 'DEAD' during of the driver's probe:
> 
>   pn544_hci_i2c 1-002a: NFC: nfc_en polarity : active high
>   pn544_hci_i2c 1-002a: NFC: invalid len byte
>   shdlc: llc_shdlc_recv_frame: NULL Frame -> link is dead
> 
> This patch fixes the occasional NFC initialization failure on Nexus 7
> device.
> 
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>

Applied and queued up for -stable, thanks.
