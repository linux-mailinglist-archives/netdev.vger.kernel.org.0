Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 595DB195FB
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 02:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfEJAR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 20:17:28 -0400
Received: from [66.55.73.32] ([66.55.73.32]:51484 "EHLO
        ushosting.nmnhosting.com" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1726694AbfEJAR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 20:17:27 -0400
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id B6DC82DC0070;
        Thu,  9 May 2019 20:17:22 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1557447443;
        bh=rJY0+D6TdRtTv0MtwykFJbYOSu46lpL7vkuRS2Zg75k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FgHPIPlYLmuLNtrMoQ1JdXOJBzIramXRU528FDdwgmUbYDUSurbrKOmk66MlGYzGl
         0ruDR9MsmWn6Wa1JGtiiUa7MDmH9NnRiXxafLrfVNihMUrJYoUiQlr9ZF1I4HIM0PV
         bZ9W5c9BAYVyzA9PfwGf5o+hGD2hYyBjKLixvrQ1vno4Whs2Nw5LmAFMtjJBE96JB5
         3A/TpZPKlUH/LZ9QviX5sPNxejvENaMBIYUal2Z2Hup4BijYTYYiF1F+eWLEYbhMu2
         YBrAElUv44shUa1aHwy6Pfl3sYtAppFsneNmta4kToubNSSN/EMWCAgt+GOmMNuiZU
         dScx2/r4DfVPHVsLyA/C0IlAGJW5xx1NFqr3GJcu3u2ljmH/j2VABFWX8mKiViOjya
         UMzCeSKOTZj7GhaZKQ4wNLMdnnGeX0xRzwZxBPPwQPpa98wFjqGa4P4+HDIkphprBS
         cLR2rNyVdb5sI8TuETSE/d/sK5ExHhfuWol5Jk5PXVNE/IO16n6e0dCf3bBoCa8bTw
         zs4jlO1owv47NzN5dYrbV7R3mEfn3Wk/R8zsonqePsZtnUOe/9EZUeGRp5ITrVsRIK
         bdLoMtcOXzpm23UAwIN2Fr4caFvxOuuMjHxqg9nDMraA52HHWsxcudXZEv+JQvxYxU
         WRl4Hh/Ieej3f+hWeieXK7mA=
Received: from adsilva.ozlabs.ibm.com (static-82-10.transact.net.au [122.99.82.10] (may be forged))
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x4A0GhJ3030327
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 10 May 2019 10:17:01 +1000 (AEST)
        (envelope-from alastair@d-silva.org)
Message-ID: <80e51facb280e96018a4220adf8efa6fac823a94.camel@d-silva.org>
Subject: Re: [PATCH v2 3/7] lib/hexdump.c: Optionally suppress lines of
 repeated bytes
From:   "Alastair D'Silva" <alastair@d-silva.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-fbdev@vger.kernel.org,
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Daniel Vetter <daniel@ffwll.ch>, netdev@vger.kernel.org,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Date:   Fri, 10 May 2019 10:16:42 +1000
In-Reply-To: <dc093079-43a0-0a45-f5dd-88b20702fd93@infradead.org>
References: <20190508070148.23130-1-alastair@au1.ibm.com>
         <20190508070148.23130-4-alastair@au1.ibm.com>
         <dc093079-43a0-0a45-f5dd-88b20702fd93@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1 (3.32.1-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Fri, 10 May 2019 10:17:17 +1000 (AEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-05-08 at 17:58 -0700, Randy Dunlap wrote:
> On 5/8/19 12:01 AM, Alastair D'Silva wrote:
> > From: Alastair D'Silva <alastair@d-silva.org>
> > 
> > Some buffers may only be partially filled with useful data, while
> > the rest
> > is padded (typically with 0x00 or 0xff).
> > 
> > This patch introduces a flag to allow the supression of lines of
> > repeated
> > bytes, which are replaced with '** Skipped %u bytes of value 0x%x
> > **'
> > 
> > An inline wrapper function is provided for backwards compatibility
> > with
> > existing code, which maintains the original behaviour.
> > 
> > Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> > ---
> >  include/linux/printk.h | 25 +++++++++---
> >  lib/hexdump.c          | 91 ++++++++++++++++++++++++++++++++++++
> > ------
> >  2 files changed, 99 insertions(+), 17 deletions(-)
> > 
> 
> Hi,
> Did you do "make htmldocs" or something similar on this?
> 
> > diff --git a/lib/hexdump.c b/lib/hexdump.c
> > index 3943507bc0e9..d61a1e4f19fa 100644
> > --- a/lib/hexdump.c
> > +++ b/lib/hexdump.c
> > @@ -212,8 +212,44 @@ int hex_dump_to_buffer(const void *buf, size_t
> > len, int rowsize, int groupsize,
> >  EXPORT_SYMBOL(hex_dump_to_buffer);
> >  
> >  #ifdef CONFIG_PRINTK
> > +
> > +/**
> > + * Check if a buffer contains only a single byte value
> > + * @buf: pointer to the buffer
> > + * @len: the size of the buffer in bytes
> > + * @val: outputs the value if if the bytes are identical
> 
> Does this work without a function name?
> Documentation/doc-guide/kernel-doc.rst says the general format is:
> 
>   /**
>    * function_name() - Brief description of function.
>    * @arg1: Describe the first argument.
>    * @arg2: Describe the second argument.
>    *        One can provide multiple line descriptions
>    *        for arguments.
>    *
> 
> > + */
> >  /**
> > - * print_hex_dump - print a text hex dump to syslog for a binary
> > blob of data
> > + * print_hex_dump_ext: dump a binary blob of data to syslog in
> > hexadecimal
> 
> Also not in the general documented format.
> 

Thanks Randy, I'll address these.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva    
Twitter: @EvilDeece
blog: http://alastair.d-silva.org


