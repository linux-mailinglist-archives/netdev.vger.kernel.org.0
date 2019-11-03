Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98531ED3F5
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 18:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbfKCRN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 12:13:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:54540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727444AbfKCRN1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Nov 2019 12:13:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F35120848;
        Sun,  3 Nov 2019 17:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572801206;
        bh=1f8uqX2M3g4e8ajbRWXxGgjt5VZyz4HsWLqzRg8UxC8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=diUW5bwnXwDv0EaVWoRkouwwU+DHIHaJ0WEJF3KaeoA40jZb5mtcybcBEzJOCdBup
         08VLIoBPIrKhOhvvLA+YH3NtAJJikRqR1xypdfnNjIQ5S2gs2Um8qD4wEo74nMWmpf
         BXOMfC6kDROQaNqnaig5Y0TO4HDqClQhM3OfVjzk=
Date:   Sun, 3 Nov 2019 18:13:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] debugfs: Add and use debugfs_create_xul()
Message-ID: <20191103171324.GA700462@kroah.com>
References: <20191025094130.26033-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025094130.26033-1-geert+renesas@glider.be>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 11:41:23AM +0200, Geert Uytterhoeven wrote:
>         Hi all,
> 
> The existing debugfs_create_ulong() function supports objects of
> type "unsigned long", which are 32-bit or 64-bit depending on the
> platform, in decimal form.  To format objects in hexadecimal, various
> debugfs_create_x*() functions exist, but all of them take fixed-size
> types. 
>   
> To work around this, some drivers call one of debugfs_create_x{32,64}(),
> depending on the size of unsigned long.
> Other drivers just cast the value pointer to "u32 *" or "u64 *",
> introducing portability bugs or data leaks in the process.
>  
> Hence this patch series adds a debugfs helper for "unsigned long"
> objects in hexadecimal format, and converts drivers to make use of it.
> It also contains two cleanups removing superfluous casts, which I added
> to this series to avoid conflicts.
>  
> Changes compared to v1[1]:
>   - Add kerneldoc,
>   - Update Documentation/filesystems/debugfs.txt,
>   - Add Acked-by.
> 
> Dependencies:
>   - The first patch now depends on "Documentation: debugfs: Document
>     debugfs helper for unsigned long values"[2], which Jon said he
>     applied to his tree.

I did not take patches 2 or 3 as I need acks from those subsystem
maintainers to do so.

But I did take all the others.

thanks,

greg k-h
