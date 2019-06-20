Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7481C4C52B
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 04:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731211AbfFTCAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 22:00:33 -0400
Received: from smtprelay0204.hostedemail.com ([216.40.44.204]:58509 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726370AbfFTCAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 22:00:32 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 61216100E86C2;
        Thu, 20 Jun 2019 02:00:30 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 
X-HE-Tag: tent82_3890fedb2856
X-Filterd-Recvd-Size: 4880
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Thu, 20 Jun 2019 02:00:24 +0000 (UTC)
Message-ID: <fcf57339aea60fb1744cea2a2593656c728c4ec4.camel@perches.com>
Subject: Re: [PATCH v3 0/7] Hexdump Enhancements
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
Date:   Wed, 19 Jun 2019 19:00:22 -0700
In-Reply-To: <9456ca2a4ae827635bb6d864e5095a9e51f2ac45.camel@d-silva.org>
References: <20190617020430.8708-1-alastair@au1.ibm.com>
         <9a000734375c0801fc16b71f4be1235f9b857772.camel@perches.com>
         <c68cb819257f251cbb66f8998a95c31cebe2d72e.camel@d-silva.org>
         <d8316be322f33ea67640ff83f2248fe433078407.camel@perches.com>
         <9456ca2a4ae827635bb6d864e5095a9e51f2ac45.camel@d-silva.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-06-20 at 11:14 +1000, Alastair D'Silva wrote:
> On Wed, 2019-06-19 at 17:35 -0700, Joe Perches wrote:
> > On Thu, 2019-06-20 at 09:15 +1000, Alastair D'Silva wrote:
> > > On Wed, 2019-06-19 at 09:31 -0700, Joe Perches wrote:
> > > > On Mon, 2019-06-17 at 12:04 +1000, Alastair D'Silva wrote:
> > > > > From: Alastair D'Silva <alastair@d-silva.org>
> > > > > 
> > > > > Apologies for the large CC list, it's a heads up for those
> > > > > responsible
> > > > > for subsystems where a prototype change in generic code causes
> > > > > a
> > > > > change
> > > > > in those subsystems.
> > > > > 
> > > > > This series enhances hexdump.
> > > > 
> > > > Still not a fan of these patches.
> > > 
> > > I'm afraid there's not too much action I can take on that, I'm
> > > happy to
> > > address specific issues though.
> > > 
> > > > > These improve the readability of the dumped data in certain
> > > > > situations
> > > > > (eg. wide terminals are available, many lines of empty bytes
> > > > > exist,
> > > > > etc).
> > 
> > I think it's generally overkill for the desired uses.
> 
> I understand where you're coming from, however, these patches make it a
> lot easier to work with large chucks of binary data. I think it makes
> more sense to have these patches upstream, even though committed code
> may not necessarily have all the features enabled, as it means that
> devs won't have to apply out-of-tree patches during development to make
> larger dumps manageable.
> 
> > > > Changing hexdump's last argument from bool to int is odd.
> > > > 
> > > 
> > > Think of it as replacing a single boolean with many booleans.
> > 
> > I understand it.  It's odd.
> > 
> > I would rather not have a mixture of true, false, and apparently
> > random collections of bitfields like 0xd or 0b1011 or their
> > equivalent or'd defines.
> > 
> 
> Where's the mixture? What would you propose instead?

create a hex_dump_to_buffer_ext with a new argument
and a new static inline for the old hex_dump_to_buffer
without modifying the argument list that calls
hex_dump_to_buffer with whatever added argument content
you need.

Something like:

static inline
int hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
		       int groupsize, char *linebuf, size_t linebuflen,
		       bool ascii)
{
	return hex_dump_to_buffer_ext(buf, len, rowsize, groupsize,
				      linebuf, linebuflen, ascii, 0);
}

and remove EXPORT_SYMBOL(hex_dump_to_buffer)
				      


