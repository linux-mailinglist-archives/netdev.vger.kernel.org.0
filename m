Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2444A4230
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359215AbiAaLLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377537AbiAaLKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:10:10 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A344BC061714;
        Mon, 31 Jan 2022 03:07:53 -0800 (PST)
Date:   Mon, 31 Jan 2022 12:07:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643627272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wZ2f6mxJtMd++5Aml5rgNLLSnjcWCv443/ajj7HSqQo=;
        b=H7sx3pRzJHs2iSgUDPf/9+DKJAQHt0np+pCaCdI+Ffi232MTfpVtlOijisw4TtgPa3KVaT
        bNORJUrty8/GGtFI1qKf1WVuvW4Ci3Ly0dfhBMIYtmaQWjHck7DDl2soXrVFPn5VDlduyn
        oGD7LifyA365+7K8lYlyf/gateZqhErFd7NrEDXuN39w904LIrV7coW/7bBcWc7mkU8vHi
        JwHBiqMFl2mUvs5bLgAZY+LglkvJs+um0fXck7OxYIX8xGzAZt0cgFaWAYOBVSewL39uW2
        +dgVGYthpNPJLJUVA6VakYI3XwoZoHJP2Gcu52wyLvOn6mdZx9L9rh8cc8su5Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643627272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wZ2f6mxJtMd++5Aml5rgNLLSnjcWCv443/ajj7HSqQo=;
        b=kzgTFt+D+034T01mnmcXciv1jHrUGkWJ38AFDFX50eklm0gwKWXdMojKgeBSU+4Rw+9DPy
        5ED8sSRdw15wHbBQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Wolfram Sang <wsa@kernel.org>, greybus-dev@lists.linaro.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Michael Below <below@judiz.de>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: Re: [PATCH 2/7] i2c: core: Use generic_handle_irq_safe() in
 i2c_handle_smbus_host_notify().
Message-ID: <YffDBiITSRQQXnVh@linutronix.de>
References: <20220127113303.3012207-1-bigeasy@linutronix.de>
 <20220127113303.3012207-3-bigeasy@linutronix.de>
 <YfLSNNDVtAFx1P9u@shikoro>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YfLSNNDVtAFx1P9u@shikoro>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-27 18:11:16 [+0100], Wolfram Sang wrote:
> 
> I guess you want this to go together with patch 1, so:
> 
> Acked-by: Wolfram Sang <wsa@kernel.org>
> 
> I agree with adding the kernel bugzilla entry at least:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=202453
> 
> Probably the others which Oleksandr metioned, too.

No, they are not relevant because none of them can be reproduced on a
v5.12+ kernel or any of <v5.12 stable maintained trees.

They triggered in the past only with the `threadirqs' option on the
commandline and this has been fixed by commit
   81e2073c175b8 ("genirq: Disable interrupts for force threaded handlers")

Sebastian
