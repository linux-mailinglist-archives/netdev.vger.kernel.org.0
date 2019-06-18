Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35C914967C
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 02:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfFRA5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 20:57:33 -0400
Received: from ushosting.nmnhosting.com ([66.55.73.32]:35430 "EHLO
        ushosting.nmnhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfFRA5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 20:57:33 -0400
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id 2797C2DC0096;
        Mon, 17 Jun 2019 20:57:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1560819452;
        bh=u7VpYNn8JpTLdyHPUljh2Z7wehVtDH+n9nHQNgN6N2A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jvSabEdrNHOl7NlBGL5YcdZQfi+fpB9BO+GaqBWlR/PP+V/1JX3MOC/vdfprE+d4q
         W0UTx/depws8/q6fCe4qsmxzaHqtVkUa+v+Mp2PYjaUrKq1XeKLKJ3TPmwKDKYb7Ix
         tm9Ggg2c204E7SWf1Kzm3b7UURvQRUF+YtE1qaFXWb7M1bSsECs2dxPGyAy4TwdTwu
         YrzjrIAdGWVZDKXuSQHyDOqmmePgS4sV2lw+tlA9IZJRT1DXVvYEFcSGBy5FTId/0l
         fqkDcrBYmDhMWn+3CZbnwx7qgnLFWM0LDHsbAyxHAnRZtM+pOmK0XpTf0aiYcsAURz
         JAHTKkLHxAgXWfC3qIJOHW9mN0wLp5AYzfNmMC3C5ks7bZYsWq3PGnPXMMgDkMzyop
         xeuPVBo2+37GGuWiHd1PVStu6wl0eKfSBJgyWJvhXbnAdDsbuqzYFH9Boz+O6C1oWT
         2Stkwa1MvSezs7en91awfFUNUzrvwbjOv/IZIK0ZFoGni+dz4kIbQSJzdLLHGKQkgV
         TVlkQn6TAJU90DRRiC92kuMldKfElutBjDwzhohJifPcEvF9T9IrE1SS4Zaz3ft2Rz
         ho6zF2/9j+ouJCRd5AcHglBo4L8CMDItufZhI5pCGZ7PhbKy0bPXekMmqRlgelk8er
         vDFIJF20+9ye5cMw79l/tHxg=
Received: from adsilva.ozlabs.ibm.com (static-82-10.transact.net.au [122.99.82.10] (may be forged))
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x5I0v17n063106
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 18 Jun 2019 10:57:17 +1000 (AEST)
        (envelope-from alastair@d-silva.org)
Message-ID: <b2651117ca8a55d94b7e14e273d25199515039c3.camel@d-silva.org>
Subject: Re: [PATCH v3 2/7] lib/hexdump.c: Relax rowsize checks in
 hex_dump_to_buffer
From:   "Alastair D'Silva" <alastair@d-silva.org>
To:     Randy Dunlap <rdunlap@infradead.org>
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
Date:   Tue, 18 Jun 2019 10:57:00 +1000
In-Reply-To: <94413756-c927-a4ca-dd59-47e3cc87d58d@infradead.org>
References: <20190617020430.8708-1-alastair@au1.ibm.com>
         <20190617020430.8708-3-alastair@au1.ibm.com>
         <94413756-c927-a4ca-dd59-47e3cc87d58d@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Tue, 18 Jun 2019 10:57:27 +1000 (AEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-06-17 at 15:47 -0700, Randy Dunlap wrote:
> Hi,
> Just a comment style nit below...
> 
> On 6/16/19 7:04 PM, Alastair D'Silva wrote:
> > From: Alastair D'Silva <alastair@d-silva.org>
> > 
> > This patch removes the hardcoded row limits and allows for
> > other lengths. These lengths must still be a multiple of
> > groupsize.
> > 
> > This allows structs that are not 16/32 bytes to display on
> > a single line.
> > 
> > This patch also expands the self-tests to test row sizes
> > up to 64 bytes (though they can now be arbitrarily long).
> > 
> > Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> > ---
> >  lib/hexdump.c      | 48 ++++++++++++++++++++++++++++--------------
> >  lib/test_hexdump.c | 52 ++++++++++++++++++++++++++++++++++++++--
> > ------
> >  2 files changed, 75 insertions(+), 25 deletions(-)
> > 
> > diff --git a/lib/hexdump.c b/lib/hexdump.c
> > index 81b70ed37209..3943507bc0e9 100644
> > --- a/lib/hexdump.c
> > +++ b/lib/hexdump.c
> > @@ -246,17 +248,29 @@ void print_hex_dump(const char *level, const
> > char *prefix_str, int prefix_type,
> >  {
> >  	const u8 *ptr = buf;
> >  	int i, linelen, remaining = len;
> > -	unsigned char linebuf[32 * 3 + 2 + 32 + 1];
> > +	unsigned char *linebuf;
> > +	unsigned int linebuf_len;
> >  
> > -	if (rowsize != 16 && rowsize != 32)
> > -		rowsize = 16;
> > +	if (rowsize % groupsize)
> > +		rowsize -= rowsize % groupsize;
> > +
> > +	/* Worst case line length:
> > +	 * 2 hex chars + space per byte in, 2 spaces, 1 char per byte
> > in, NULL
> > +	 */
> 
> According to Documentation/process/coding-style.rst:
> 
> The preferred style for long (multi-line) comments is:
> 
> .. code-block:: c
> 
> 	/*
> 	 * This is the preferred style for multi-line
> 	 * comments in the Linux kernel source code.
> 	 * Please use it consistently.
> 	 *
> 	 * Description:  A column of asterisks on the left side,
> 	 * with beginning and ending almost-blank lines.
> 	 */
> 

Thanks Randy, I'll address this.


-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva    
Twitter: @EvilDeece
blog: http://alastair.d-silva.org


