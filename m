Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427448D271
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 13:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbfHNLqT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Aug 2019 07:46:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:43796 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725800AbfHNLqS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 07:46:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EFF61AF5B;
        Wed, 14 Aug 2019 11:46:16 +0000 (UTC)
Date:   Wed, 14 Aug 2019 13:46:16 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
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
Message-Id: <20190814134616.b4dab3c0aa6ac913d78edb6a@suse.de>
In-Reply-To: <8d18de64-9234-fcba-aa3d-b46789eb62a5@linaro.org>
References: <20190809103235.16338-1-tbogendoerfer@suse.de>
        <20190809103235.16338-4-tbogendoerfer@suse.de>
        <8d18de64-9234-fcba-aa3d-b46789eb62a5@linaro.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Aug 2019 10:40:34 +0100
Srinivas Kandagatla <srinivas.kandagatla@linaro.org> wrote:

> 
> 
> On 09/08/2019 11:32, Thomas Bogendoerfer wrote:
> > nvmem_device_find provides a way to search for nvmem devices with
> > the help of a match function simlair to bus_find_device.
> > 
> > Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> > ---
> >   drivers/nvmem/core.c           | 62 ++++++++++++++++++++++--------------------
> >   include/linux/nvmem-consumer.h |  9 ++++++
> >   2 files changed, 41 insertions(+), 30 deletions(-)
> 
> Have you considered using nvmem_register_notifier() ?

yes, that was the first idea. But then I realized I need to build up
a private database of information already present in nvmem bus. So I
looked for a way to retrieve it from there. Unfortunately I couldn't
use bus_find_device directly, because nvmem_bus_type and struct nvmem_device
is hidden. So I refactured the lookup code and added a more universal
lookup function, which fits my needs and should be usable for more.

Thomas.

-- 
SUSE Linux GmbH
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
