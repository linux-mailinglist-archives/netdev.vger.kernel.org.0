Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 669BB4C484
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 02:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730879AbfFTAfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 20:35:21 -0400
Received: from smtprelay0056.hostedemail.com ([216.40.44.56]:44337 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726072AbfFTAfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 20:35:20 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 4743D18032D42;
        Thu, 20 Jun 2019 00:35:19 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 
X-HE-Tag: slope21_83935d3c81a36
X-Filterd-Recvd-Size: 3615
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Thu, 20 Jun 2019 00:35:03 +0000 (UTC)
Message-ID: <d8316be322f33ea67640ff83f2248fe433078407.camel@perches.com>
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
Date:   Wed, 19 Jun 2019 17:35:01 -0700
In-Reply-To: <c68cb819257f251cbb66f8998a95c31cebe2d72e.camel@d-silva.org>
References: <20190617020430.8708-1-alastair@au1.ibm.com>
         <9a000734375c0801fc16b71f4be1235f9b857772.camel@perches.com>
         <c68cb819257f251cbb66f8998a95c31cebe2d72e.camel@d-silva.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-06-20 at 09:15 +1000, Alastair D'Silva wrote:
> On Wed, 2019-06-19 at 09:31 -0700, Joe Perches wrote:
> > On Mon, 2019-06-17 at 12:04 +1000, Alastair D'Silva wrote:
> > > From: Alastair D'Silva <alastair@d-silva.org>
> > > 
> > > Apologies for the large CC list, it's a heads up for those
> > > responsible
> > > for subsystems where a prototype change in generic code causes a
> > > change
> > > in those subsystems.
> > > 
> > > This series enhances hexdump.
> > 
> > Still not a fan of these patches.
> 
> I'm afraid there's not too much action I can take on that, I'm happy to
> address specific issues though.
> 
> > > These improve the readability of the dumped data in certain
> > > situations
> > > (eg. wide terminals are available, many lines of empty bytes exist,
> > > etc).

I think it's generally overkill for the desired uses.

> > Changing hexdump's last argument from bool to int is odd.
> > 
> 
> Think of it as replacing a single boolean with many booleans.

I understand it.  It's odd.

I would rather not have a mixture of true, false, and apparently
random collections of bitfields like 0xd or 0b1011 or their
equivalent or'd defines.


> There's only a handful of consumers, I don't think there is a value-add 
> in creating more wrappers vs updating the existing callers.

Perhaps more reason not to modify the existing api.


