Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74A2E49567
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbfFQWr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:47:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40474 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfFQWr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 18:47:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oWCvapawJTmHWfTi4W/xQzd/vam+JtASkBkdfBDmQPA=; b=n2EkBbCtepqSck3LcKcBk9ucLP
        OopaIKVxH7Ft5pKUkNM6axeXE0K/dN0KlZBFHBkuZUjcuBojBVwA6eyj3zIf/SrSJ0AXP+ap36Tfr
        X0WYpzcQ34E0H9clamwWKVPA2G5AqZgtlebPbdol2VZl3hzV0WHHKTyO/DPw8RjqxrUZIc7QdVFKM
        vHCGFyYLYGCxZF9eADucfOb8FK17P9rwh5jOCnBGSKiVmNRqoUfswvbapl0LJeUcbgsSotAmzefsG
        BuQwk3FdoCSOiq6Zwz2/pJMld3yRBwfY9eWtfMYCawPt2uqyoLPRXHwia2hme5jMcDzrgP6F97p9i
        1TAbXIzA==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=midway.dunlab)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hd0P6-0004pi-Aw; Mon, 17 Jun 2019 22:47:08 +0000
Subject: Re: [PATCH v3 2/7] lib/hexdump.c: Relax rowsize checks in
 hex_dump_to_buffer
To:     Alastair D'Silva <alastair@au1.ibm.com>, alastair@d-silva.org
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
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
References: <20190617020430.8708-1-alastair@au1.ibm.com>
 <20190617020430.8708-3-alastair@au1.ibm.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <94413756-c927-a4ca-dd59-47e3cc87d58d@infradead.org>
Date:   Mon, 17 Jun 2019 15:47:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190617020430.8708-3-alastair@au1.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
Just a comment style nit below...

On 6/16/19 7:04 PM, Alastair D'Silva wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
> 
> This patch removes the hardcoded row limits and allows for
> other lengths. These lengths must still be a multiple of
> groupsize.
> 
> This allows structs that are not 16/32 bytes to display on
> a single line.
> 
> This patch also expands the self-tests to test row sizes
> up to 64 bytes (though they can now be arbitrarily long).
> 
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> ---
>  lib/hexdump.c      | 48 ++++++++++++++++++++++++++++--------------
>  lib/test_hexdump.c | 52 ++++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 75 insertions(+), 25 deletions(-)
> 
> diff --git a/lib/hexdump.c b/lib/hexdump.c
> index 81b70ed37209..3943507bc0e9 100644
> --- a/lib/hexdump.c
> +++ b/lib/hexdump.c

> @@ -246,17 +248,29 @@ void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
>  {
>  	const u8 *ptr = buf;
>  	int i, linelen, remaining = len;
> -	unsigned char linebuf[32 * 3 + 2 + 32 + 1];
> +	unsigned char *linebuf;
> +	unsigned int linebuf_len;
>  
> -	if (rowsize != 16 && rowsize != 32)
> -		rowsize = 16;
> +	if (rowsize % groupsize)
> +		rowsize -= rowsize % groupsize;
> +
> +	/* Worst case line length:
> +	 * 2 hex chars + space per byte in, 2 spaces, 1 char per byte in, NULL
> +	 */

According to Documentation/process/coding-style.rst:

The preferred style for long (multi-line) comments is:

.. code-block:: c

	/*
	 * This is the preferred style for multi-line
	 * comments in the Linux kernel source code.
	 * Please use it consistently.
	 *
	 * Description:  A column of asterisks on the left side,
	 * with beginning and ending almost-blank lines.
	 */


except in networking software.


> +	linebuf_len = rowsize * 3 + 2 + rowsize + 1;
> +	linebuf = kzalloc(linebuf_len, GFP_KERNEL);
> +	if (!linebuf) {
> +		printk("%s%shexdump: Could not alloc %u bytes for buffer\n",
> +			level, prefix_str, linebuf_len);
> +		return;
> +	}


-- 
~Randy
