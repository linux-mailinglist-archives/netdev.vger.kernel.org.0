Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F08090474
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 17:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbfHPPOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 11:14:16 -0400
Received: from elvis.franken.de ([193.175.24.41]:35094 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727388AbfHPPOP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 11:14:15 -0400
X-Greylist: delayed 2654 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Aug 2019 11:14:14 EDT
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1hydEn-0007f5-00; Fri, 16 Aug 2019 16:29:53 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 00486C25F1; Fri, 16 Aug 2019 16:09:42 +0200 (CEST)
Date:   Fri, 16 Aug 2019 16:09:42 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v4 3/9] nvmem: core: add nvmem_device_find
Message-ID: <20190816140942.GA15050@alpha.franken.de>
References: <20190809103235.16338-1-tbogendoerfer@suse.de>
 <20190809103235.16338-4-tbogendoerfer@suse.de>
 <8d18de64-9234-fcba-aa3d-b46789eb62a5@linaro.org>
 <20190814134616.b4dab3c0aa6ac913d78edb6a@suse.de>
 <31d680ee-ddb3-8536-c915-576222d263e1@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31d680ee-ddb3-8536-c915-576222d263e1@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 01:52:49PM +0100, Srinivas Kandagatla wrote:
> On 14/08/2019 12:46, Thomas Bogendoerfer wrote:
> >On Tue, 13 Aug 2019 10:40:34 +0100
> >Srinivas Kandagatla <srinivas.kandagatla@linaro.org> wrote:
> >>On 09/08/2019 11:32, Thomas Bogendoerfer wrote:
> >>>nvmem_device_find provides a way to search for nvmem devices with
> >>>the help of a match function simlair to bus_find_device.
> >>>
> >>>Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> >>>---
> >>>   drivers/nvmem/core.c           | 62 ++++++++++++++++++++++--------------------
> >>>   include/linux/nvmem-consumer.h |  9 ++++++
> >>>   2 files changed, 41 insertions(+), 30 deletions(-)
> >>
> >>Have you considered using nvmem_register_notifier() ?
> >
> >yes, that was the first idea. But then I realized I need to build up
> >a private database of information already present in nvmem bus. So I
> >looked for a way to retrieve it from there. Unfortunately I couldn't
> >use bus_find_device directly, because nvmem_bus_type and struct nvmem_device
> >is hidden. So I refactured the lookup code and added a more universal
> >lookup function, which fits my needs and should be usable for more.
> I see your point.
> 
> overall the patch as it is look good, but recently we added more generic
> lookups for DT node, looks like part of your patch is un-doing generic
> device name lookup.
> 
> DT node match lookup is in https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/log/?h=generic_lookup_helpers

these patches are not in Linus tree, yet. I guess they will show up
in 5.4. No idea how to deal with it right now, do you ?

> Other missing bit is adding this api to documentation in
> ./Documentation/driver-api/nvmem.rst

ok, will do.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
