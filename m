Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE8748D50E
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 10:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbiAMJcg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Jan 2022 04:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiAMJcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 04:32:35 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18A7C06173F;
        Thu, 13 Jan 2022 01:32:34 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 046FC6005A;
        Thu, 13 Jan 2022 09:32:30 +0000 (UTC)
Date:   Thu, 13 Jan 2022 10:32:29 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Subject: Re: [wpan-next v2 01/27] net: mac802154: Split the set channel hook
 implementation
Message-ID: <20220113103229.64612657@xps13>
In-Reply-To: <CAB_54W7uEQ5RJZxKT2qimoT=pbu8NsUhbZWZRWg+QjXDoTPFuQ@mail.gmail.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
        <20220112173312.764660-2-miquel.raynal@bootlin.com>
        <CAB_54W7uEQ5RJZxKT2qimoT=pbu8NsUhbZWZRWg+QjXDoTPFuQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Wed, 12 Jan 2022 17:30:35 -0500:

> Hi,
> 
> On Wed, 12 Jan 2022 at 12:33, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > As it is currently designed, the set_channel() cfg802154 hook
> > implemented in the softMAC is doing a couple of checks before actually
> > performing the channel change. However, as we enhance the support for
> > automatically setting the symbol duration during channel changes, it
> > will also be needed to ensure that the corresponding channel as properly
> > be selected at probe time. In order to verify this, we will need to  
> 
> no, we don't set channels at probe time. We set the
> current_page/channel whatever the default is according to the hardware
> datasheet. I think this channel should be dropped and all drivers set
> the defaults before registering hw as what we do at e.g. at86rf230,
> see [0].

Is there a reason for refusing to call ->set_channel() at probe time?

Anyway, I'll put the symbol duration setting in the registration helper
and I will fix hwsim aside.

> 
> - Alex
> 
> [0] https://elixir.bootlin.com/linux/v5.16/source/drivers/net/ieee802154/at86rf230.c#L1553


Thanks,
Miquèl
