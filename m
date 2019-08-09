Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9741D88001
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 18:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437187AbfHIQaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 12:30:18 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39778 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437155AbfHIQaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 12:30:18 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1hw7mN-00030f-Cm; Fri, 09 Aug 2019 12:30:11 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by localhost.localdomain (8.15.2/8.14.6) with ESMTP id x79GNcSv008107;
        Fri, 9 Aug 2019 12:23:38 -0400
Received: (from linville@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id x79GNaQx008106;
        Fri, 9 Aug 2019 12:23:36 -0400
Date:   Fri, 9 Aug 2019 12:23:36 -0400
From:   "John W. Linville" <linville@tuxdriver.com>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, linville@redhat.com, cphealy@gmail.com
Subject: Re: [PATCH ethtool] ethtool: dump nested registers
Message-ID: <20190809162336.GB8016@tuxdriver.com>
References: <20190802193455.17126-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802193455.17126-1-vivien.didelot@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 03:34:54PM -0400, Vivien Didelot wrote:
> Usually kernel drivers set the regs->len value to the same length as
> info->regdump_len, which was used for the allocation. In case where
> regs->len is smaller than the allocated info->regdump_len length,
> we may assume that the dump contains a nested set of registers.
> 
> This becomes handy for kernel drivers to expose registers of an
> underlying network conduit unfortunately not exposed to userspace,
> as found in network switching equipment for example.
> 
> This patch adds support for recursing into the dump operation if there
> is enough room for a nested ethtool_drvinfo structure containing a
> valid driver name, followed by a ethtool_regs structure like this:
> 
>     0      regs->len                        info->regdump_len
>     v              v                                        v
>     +--------------+-----------------+--------------+-- - --+
>     | ethtool_regs | ethtool_drvinfo | ethtool_regs |       |
>     +--------------+-----------------+--------------+-- - --+
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

I wasn't sure what to do with this one, given the disucssion that
followed. But since Dave merged "net: dsa: dump CPU port regs through
master" for net-next, I went ahead and queued this one for the next
release. If that was the wrong thing to do, speak-up now!

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
