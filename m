Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21CA4478F6
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 06:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfFQEHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 00:07:45 -0400
Received: from ushosting.nmnhosting.com ([66.55.73.32]:44232 "EHLO
        ushosting.nmnhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfFQEHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 00:07:44 -0400
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id E75102DC007F;
        Mon, 17 Jun 2019 00:07:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1560744460;
        bh=fcIJWb9zFrSz2UB8a7mxef1I4k9iDutEwQyvrCEDLlQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WCFaSA53OEIg+og8L/naQbQPlaTsOoXPKsvTwtmXP2Vk09oVK0XuS5AD3x5/CqLrM
         G0GIng39m1v0lZ4sKpUf3T99/+YBxM9RX44WLALuhESqgh+r5BAShy10176lEQBE3q
         DQvd2fgD6zwuDb2r3HtAMEKvNfyGEklzY4KUQ+U+VxMilUgRO+yfLfvjALw1DuedIj
         U07cuyKZx46E0NJINEB5+8FVHhYvvSWxSY7sKWAoGvSBG/TJ18P0TuXGu+r+H6bH0e
         aXUQ8ilJHofP52ff/zDalxsvFnS/I19R0WtGSyZHeql8nV+rZAy3ckW9tGr7DubBUl
         qpbsJvQK16Hb/jOSoEHhPkG1VKXuLKMb1qy/wzkUplRpkQy3lck+ggy2ukzRhUgkqh
         N1Q6mMJi30A9PGd1HWpWuLWkLg4LedcJItJ961IWPw6XnamogZOK4OajearEtq6Wug
         Q7fZpUvUrqSKSyRRBPeipKEoLRw/YY+95nWqf7l5GKHjuTC0GylNVU3e6c29Aa3j+X
         5pRuwG5Xw/zIJlIzmObseyKrpDD4TC7M/3O2j/4ernSmXnXxPfSq1dRv9DqHM2oKIk
         cA8ovQOzGfvEiJha5fCrgByfWUnR6D8Ngp3/azplb/9QJOs0SiH1pg9yh8F/C3rFek
         9RkRnoy0sArwZ3E9Df8kzHf0=
Received: from adsilva.ozlabs.ibm.com (static-82-10.transact.net.au [122.99.82.10] (may be forged))
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x5H47CvI055927
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 17 Jun 2019 14:07:28 +1000 (AEST)
        (envelope-from alastair@d-silva.org)
Message-ID: <da2ff58290c4b6f08eb5ac25c288bdd03b5688f7.camel@d-silva.org>
Subject: Re: [PATCH v3 3/7] lib/hexdump.c: Optionally suppress lines of
 repeated bytes
From:   "Alastair D'Silva" <alastair@d-silva.org>
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Benson Leung <bleung@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Andrew Morton <akpm@linux-foundation.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org
Date:   Mon, 17 Jun 2019 14:07:12 +1000
In-Reply-To: <20190617020430.8708-4-alastair@au1.ibm.com>
References: <20190617020430.8708-1-alastair@au1.ibm.com>
         <20190617020430.8708-4-alastair@au1.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Mon, 17 Jun 2019 14:07:35 +1000 (AEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-06-17 at 12:04 +1000, Alastair D'Silva wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
> 
> Some buffers may only be partially filled with useful data, while the
> rest
> is padded (typically with 0x00 or 0xff).
> 
> This patch introduces a flag to allow the supression of lines of
> repeated
> bytes, which are replaced with '** Skipped %u bytes of value 0x%x **'
> 
> An inline wrapper function is provided for backwards compatibility
> with
> existing code, which maintains the original behaviour.
> 
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> ---
>  include/linux/printk.h | 25 +++++++++---
>  lib/hexdump.c          | 91 ++++++++++++++++++++++++++++++++++++--
> ----
>  2 files changed, 99 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/printk.h b/include/linux/printk.h
> index cefd374c47b1..d7754799cfe0 100644
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -481,13 +481,18 @@ enum {
>  	DUMP_PREFIX_ADDRESS,
>  	DUMP_PREFIX_OFFSET
>  };
> +
>  extern int hex_dump_to_buffer(const void *buf, size_t len, int
> rowsize,
>  			      int groupsize, char *linebuf, size_t
> linebuflen,
>  			      bool ascii);
> +
> +#define HEXDUMP_ASCII			BIT(0)
> +#define HEXDUMP_SUPPRESS_REPEATED	BIT(1)
> +

This is missing the include of linux/bits.h, I'll fix this in the next
version.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva    
Twitter: @EvilDeece
blog: http://alastair.d-silva.org


