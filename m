Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16D7FB2677
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 22:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388913AbfIMUJR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 13 Sep 2019 16:09:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48752 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388418AbfIMUJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 16:09:17 -0400
Received: from localhost (93-63-141-166.ip28.fastwebnet.it [93.63.141.166])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B8E4D1539B194;
        Fri, 13 Sep 2019 13:09:15 -0700 (PDT)
Date:   Fri, 13 Sep 2019 21:09:14 +0100 (WEST)
Message-Id: <20190913.210914.459044600119292225.davem@davemloft.net>
To:     bjorn@mork.no
Cc:     netdev@vger.kernel.org, oliver@neukum.org,
        linux-usb@vger.kernel.org, larsm17@gmail.com
Subject: Re: [PATCH net,stable] cdc_ether: fix rndis support for Mediatek
 based smartphones
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190912084200.6359-1-bjorn@mork.no>
References: <20190912084200.6359-1-bjorn@mork.no>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Sep 2019 13:09:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>
Date: Thu, 12 Sep 2019 10:42:00 +0200

> A Mediatek based smartphone owner reports problems with USB
> tethering in Linux.  The verbose USB listing shows a rndis_host
> interface pair (e0/01/03 + 10/00/00), but the driver fails to
> bind with
> 
> [  355.960428] usb 1-4: bad CDC descriptors
> 
> The problem is a failsafe test intended to filter out ACM serial
> functions using the same 02/02/ff class/subclass/protocol as RNDIS.
> The serial functions are recognized by their non-zero bmCapabilities.
> 
> No RNDIS function with non-zero bmCapabilities were known at the time
> this failsafe was added. But it turns out that some Wireless class
> RNDIS functions are using the bmCapabilities field. These functions
> are uniquely identified as RNDIS by their class/subclass/protocol, so
> the failing test can safely be disabled.  The same applies to the two
> types of Misc class RNDIS functions.
> 
> Applying the failsafe to Communication class functions only retains
> the original functionality, and fixes the problem for the Mediatek based
> smartphone.
> 
> Tow examples of CDC functional descriptors with non-zero bmCapabilities
> from Wireless class RNDIS functions are:
 ...
> The Mediatek example is believed to apply to most smartphones with
> Mediatek firmware.  The ZTE example is most likely also part of a larger
> family of devices/firmwares.
> 
> Suggested-by: Lars Melin <larsm17@gmail.com>
> Signed-off-by: Bjørn Mork <bjorn@mork.no>

Applied and queued up for -stable, thanks.
