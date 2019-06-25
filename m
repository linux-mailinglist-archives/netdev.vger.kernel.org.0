Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50FCB522B7
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 07:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbfFYFRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 01:17:51 -0400
Received: from smtprelay0192.hostedemail.com ([216.40.44.192]:53847 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726422AbfFYFRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 01:17:50 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 9E83B837F24C;
        Tue, 25 Jun 2019 05:17:48 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 
X-HE-Tag: spade50_7d8321185044f
X-Filterd-Recvd-Size: 3418
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Tue, 25 Jun 2019 05:17:42 +0000 (UTC)
Message-ID: <45177fdaff2bf2a2538e34dab175488d2ba9a46c.camel@perches.com>
Subject: Re: [PATCH v4 4/7] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
From:   Joe Perches <joe@perches.com>
To:     Alastair D'Silva <alastair@d-silva.org>
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
Date:   Mon, 24 Jun 2019 22:17:40 -0700
In-Reply-To: <746098160c4ff6527d573d2af23c403b6d4e5b80.camel@d-silva.org>
References: <20190625031726.12173-1-alastair@au1.ibm.com>
         <20190625031726.12173-5-alastair@au1.ibm.com>
         <3340b520a57e00a483eae170be97316c8d18c22c.camel@perches.com>
         <746098160c4ff6527d573d2af23c403b6d4e5b80.camel@d-silva.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-06-25 at 15:06 +1000, Alastair D'Silva wrote:
> On Mon, 2019-06-24 at 22:01 -0700, Joe Perches wrote:
> > On Tue, 2019-06-25 at 13:17 +1000, Alastair D'Silva wrote:
> > > From: Alastair D'Silva <alastair@d-silva.org>
> > > 
> > > In order to support additional features, rename hex_dump_to_buffer
> > > to
> > > hex_dump_to_buffer_ext, and replace the ascii bool parameter with
> > > flags.
> > []
> > > diff --git a/drivers/gpu/drm/i915/intel_engine_cs.c
> > > b/drivers/gpu/drm/i915/intel_engine_cs.c
> > []
> > > @@ -1338,9 +1338,8 @@ static void hexdump(struct drm_printer *m,
> > > const void *buf, size_t len)
> > >  		}
> > >  
> > >  		WARN_ON_ONCE(hex_dump_to_buffer(buf + pos, len - pos,
> > > -						rowsize, sizeof(u32),
> > > -						line, sizeof(line),
> > > -						false) >=
> > > sizeof(line));
> > > +						rowsize, sizeof(u32),
> > > line,
> > > +						sizeof(line)) >=
> > > sizeof(line));
> > 
> > Huh?  Why do this?
[]
> The change actions Jani's suggestion:
> https://lkml.org/lkml/2019/6/20/343

I think you need to read this change again.


