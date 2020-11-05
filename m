Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB6F2A8129
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 15:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730814AbgKEOog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 09:44:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730461AbgKEOof (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 09:44:35 -0500
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5713C2087D;
        Thu,  5 Nov 2020 14:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604587475;
        bh=ZVqIhH/BJHcjE/4QcXw9ADyFaBFiMDN7yz0PGvGZi2o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SdI4m+bR7lzqJXbTJFq5tKBW74MvONRo3xb9RNzGaHakNBY/FWJ+K0pAVZUioaeJ+
         dBuEEtN/i+JtPz6X6YJqZ4wYc6RNJSw0MNCzsNt8VnLJTRYOrBpjEeCHRbzDwfL4Xx
         ZpK8Xfwk+yJVAn0Br/2jpbzvl5f344al8KQmeJPo=
Date:   Thu, 5 Nov 2020 15:44:20 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Ben Whitten <ben.whitten@gmail.com>
Subject: Re: [PATCH RFC leds + net-next 4/7] leds: trigger: netdev: support
 HW offloading
Message-ID: <20201105154420.2108448d@kernel.org>
In-Reply-To: <20201030114435.20169-5-kabel@kernel.org>
References: <20201030114435.20169-1-kabel@kernel.org>
        <20201030114435.20169-5-kabel@kernel.org>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 12:44:32 +0100
Marek Beh=C3=BAn <kabel@kernel.org> wrote:

> +	if (!led_trigger_offload(led_cdev))
> +		return;
> +

The offload method has to read the settings, so this code (better: the
whole set_baseline_state function) has to be always called with the
mutex locked. (I am talking about the mutex which was a spinlock before
this patch.)

I will fix this in next version.

Marek
