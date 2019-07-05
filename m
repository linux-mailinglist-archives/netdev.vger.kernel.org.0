Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A0360225
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfGEI2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:28:02 -0400
Received: from mslow2.mail.gandi.net ([217.70.178.242]:41502 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbfGEI2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 04:28:01 -0400
Received: from relay12.mail.gandi.net (unknown [217.70.178.232])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id EF4683AA84A;
        Fri,  5 Jul 2019 07:49:46 +0000 (UTC)
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id E77E2200004;
        Fri,  5 Jul 2019 07:49:37 +0000 (UTC)
Date:   Fri, 5 Jul 2019 09:49:37 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        David Miller <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org,
        Network Development <netdev@vger.kernel.org>,
        linux-mips@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: Re: [PATCH net-next 8/8] net: mscc: PTP Hardware Clock (PHC) support
Message-ID: <20190705074937.GB3926@kwain>
References: <20190701100327.6425-1-antoine.tenart@bootlin.com>
 <20190701100327.6425-9-antoine.tenart@bootlin.com>
 <CA+FuTSecj3FYGd5xnybgNFH7ndceLu9Orsa9O4RFp0U5bpNy7w@mail.gmail.com>
 <028ded20-61d1-4ac4-46fd-4a97faeac56a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <028ded20-61d1-4ac4-46fd-4a97faeac56a@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Eric,

On Mon, Jul 01, 2019 at 05:54:41PM +0200, Eric Dumazet wrote:
> On 7/1/19 8:12 AM, Willem de Bruijn wrote:
> > On Mon, Jul 1, 2019 at 6:05 AM Antoine Tenart
> > <antoine.tenart@bootlin.com> wrote:
> >>
> >>  void ocelot_deinit(struct ocelot *ocelot)
> >>  {
> >> +       struct ocelot_port *port;
> >> +       struct ocelot_skb *entry;
> >> +       struct list_head *pos;
> >> +       int i;
> >> +
> >>         destroy_workqueue(ocelot->stats_queue);
> >>         mutex_destroy(&ocelot->stats_lock);
> >>         ocelot_ace_deinit();
> >> +
> >> +       for (i = 0; i < ocelot->num_phys_ports; i++) {
> >> +               port = ocelot->ports[i];
> >> +
> >> +               list_for_each(pos, &port->skbs) {
> >> +                       entry = list_entry(pos, struct ocelot_skb, head);
> >> +
> >> +                       list_del(pos);
> > 
> > list_for_each_safe
> 
> Also entry->skb seems to be leaked ?
> 
> dev_kfree_skb_any(entry->skb) seems to be needed

That's right, thanks for spotting this!

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
