Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCC82C74FA
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388527AbgK1Vtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730619AbgK0TwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 14:52:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902C7C08ED7E;
        Fri, 27 Nov 2020 11:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=zh33VXt2kD9yseJRxvL3v4GkB6ZavkT8ap7D2dRM1n8=; b=Kxodjbz5/uSV3yCNi49zqnvc9d
        3raTqFO3DiDczmMVk1/JjntTXeZ/X77jY563rcj7pjhEu1BJGTUKoPczByUNK/PIs51HKBFkx07ZX
        9CTkD5y1ChxR2ODhz1KXEEeJQWSeUrD5ourjvkNfwGkX8dNq2AC94Qtp1eaBSfdM8+dJJ5QyXu9t0
        HO1kFuDTP3fu+Swwwy3nCaiSC8J0IrbHiExcFLV2Vvdp3CYFs0c3WAfl8Tg6TdkNt0mfJwcUmYy0u
        jKfb7/97qOSSdbg8dXfAD0KGuolv1NIuONfs7jvm5+ypn+Wq94EbneCCQgBNsNe85jUvdbRspjEpk
        aZWL6cMw==;
Received: from [2602:306:c5a2:a380:9e7b:efff:fe40:2b26]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kijaQ-0005cI-6b; Fri, 27 Nov 2020 19:39:18 +0000
Subject: Re: [PATCH 2/2] powerpc/ps3: make system bus's remove and shutdown
 callbacks return void
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, alsa-devel@alsa-project.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
References: <20201126165950.2554997-1-u.kleine-koenig@pengutronix.de>
 <20201126165950.2554997-2-u.kleine-koenig@pengutronix.de>
From:   Geoff Levand <geoff@infradead.org>
Message-ID: <d3705daf-f48c-20a8-e3a8-a2f121099a16@infradead.org>
Date:   Fri, 27 Nov 2020 11:39:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201126165950.2554997-2-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26/20 8:59 AM, Uwe Kleine-König wrote:
> The driver core ignores the return value of struct device_driver::remove
> because there is only little that can be done. For the shutdown callback
> it's ps3_system_bus_shutdown() which ignores the return value.
> 
> To simplify the quest to make struct device_driver::remove return void,
> let struct ps3_system_bus_driver::remove return void, too. All users
> already unconditionally return 0, this commit makes it obvious that
> returning an error code is a bad idea and ensures future users behave
> accordingly.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Seems OK with v5.9 on PS3.

Tested by: Geoff Levand <geoff@infradead.org>

