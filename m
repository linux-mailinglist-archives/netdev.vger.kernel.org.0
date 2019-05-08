Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 534B4174C2
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 11:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfEHJOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 05:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbfEHJOY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 05:14:24 -0400
Received: from localhost (unknown [84.241.196.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC7AE20656;
        Wed,  8 May 2019 09:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557306863;
        bh=zepv94OHfkba3xbpvBTN7GO3YZ8l+U6nzIqdU9DMmB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wa4AAzW6bKcVh7iubvvk3GvJcvX9eh9Ton6QrU6XEE4kYPzzMrW5IHFBOY1vybSPG
         /wtvTtJVfunzm6H4nT5HQc0T+zSmcxhBr+uYF1athP68gTxTE8SNNLlVwcpysi2lYW
         IFxa5soU7yPrrlENXIMWDlxa1//6jkZdyOT5fL7A=
Date:   Wed, 8 May 2019 11:14:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alastair D'Silva <alastair@au1.ibm.com>
Cc:     alastair@d-silva.org, linux-fbdev@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        David Airlie <airlied@linux.ie>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org,
        linux-scsi@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>,
        ath10k@lists.infradead.org, intel-gfx@lists.freedesktop.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        linux-fsdevel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Benson Leung <bleung@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Daniel Vetter <daniel@ffwll.ch>, netdev@vger.kernel.org,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 4/7] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
Message-ID: <20190508091419.GA1615@kroah.com>
References: <20190508070148.23130-1-alastair@au1.ibm.com>
 <20190508070148.23130-5-alastair@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508070148.23130-5-alastair@au1.ibm.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 05:01:44PM +1000, Alastair D'Silva wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
> 
> In order to support additional features in hex_dump_to_buffer, replace
> the ascii bool parameter with flags.
> 
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> ---
>  drivers/gpu/drm/i915/intel_engine_cs.c            |  2 +-
>  drivers/isdn/hardware/mISDN/mISDNisar.c           |  6 ++++--
>  drivers/mailbox/mailbox-test.c                    |  2 +-
>  drivers/net/ethernet/amd/xgbe/xgbe-drv.c          |  2 +-
>  drivers/net/ethernet/synopsys/dwc-xlgmac-common.c |  2 +-
>  drivers/net/wireless/ath/ath10k/debug.c           |  3 ++-
>  drivers/net/wireless/intel/iwlegacy/3945-mac.c    |  2 +-
>  drivers/platform/chrome/wilco_ec/debugfs.c        |  2 +-
>  drivers/scsi/scsi_logging.c                       |  8 +++-----
>  drivers/staging/fbtft/fbtft-core.c                |  2 +-
>  fs/seq_file.c                                     |  3 ++-
>  include/linux/printk.h                            |  8 ++++----
>  lib/hexdump.c                                     | 15 ++++++++-------
>  lib/test_hexdump.c                                |  5 +++--
>  14 files changed, 33 insertions(+), 29 deletions(-)

For staging stuff:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
