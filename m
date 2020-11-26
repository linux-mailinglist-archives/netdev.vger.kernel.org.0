Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11622C5391
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 13:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388180AbgKZMFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 07:05:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:59274 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729740AbgKZMFz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 07:05:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1606392353; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qfe6Fs+qhO9jkLkAXjlgRjsXiH9JcsA0AFbXAJ90WYU=;
        b=HtRRPq+iqZCFIU/piB/7B6nprx9jcmLASW+mTIeaAN1nYVwaaGP599c4Wm95mZHNi2tTl5
        qJCc27UmpT36o8yQoYqt3nl+5LhRjlthTqm8Drku4WonAlv6gv4akupshiRDu/JSnmYoOs
        RTFuPRmGF/wQZrRJ952XCf9AOLmG+po=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CD3ABAC22;
        Thu, 26 Nov 2020 12:05:53 +0000 (UTC)
Message-ID: <b8adbaa04c984cd49448e4f82b16393e3b8d7930.camel@suse.com>
Subject: Re: cdc_ncm kernel log spam with trendnet 2.5G USB adapter
From:   Oliver Neukum <oneukum@suse.com>
To:     Roland Dreier <roland@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Date:   Thu, 26 Nov 2020 13:05:31 +0100
In-Reply-To: <CAG4TOxPXerpdxxyTbo+BFxBAvDHNFg38hf0zz5eigBJokhLWvA@mail.gmail.com>
References: <CAG4TOxPXerpdxxyTbo+BFxBAvDHNFg38hf0zz5eigBJokhLWvA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Montag, den 16.11.2020, 09:23 -0800 schrieb Roland Dreier:
> Hi, I recently got a 2.5G USB adapter, and although it works fine, the
> driver continually spams the kernel log with messages like
> 
> [127662.025647] cdc_ncm 4-1:2.0 enx3c8cf8f942e0: network connection: connected
> [127662.057680] cdc_ncm 4-1:2.0 enx3c8cf8f942e0: 2500 mbit/s downlink
> 2500 mbit/s uplink
> [127662.089794] cdc_ncm 4-1:2.0 enx3c8cf8f942e0: network connection: connected
> [127662.121831] cdc_ncm 4-1:2.0 enx3c8cf8f942e0: 2500 mbit/s downlink
> 2500 mbit/s uplink
> [127662.153858] cdc_ncm 4-1:2.0 enx3c8cf8f942e0: network connection: connected
> ...
> 
> Looking at the code in cdc_ncm.c it seems the device is just sending
> USB_CDC_NOTIFY_NETWORK_CONNECTION and USB_CDC_NOTIFY_SPEED_CHANGE urbs
> over and over, and the driver logs every single one.
> 
> Should we add code to the driver to keep track of what the last event
> was and only log if the state has really change?

Hi,

in theory I suppose we could do that, but it would be kind of stupid.
Events like these should be reported to higher layers and not logged at
all.

	Regards
		Oliver


