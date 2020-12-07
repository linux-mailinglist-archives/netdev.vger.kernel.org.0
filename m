Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4948D2D1E43
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 00:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgLGXWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 18:22:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgLGXWI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 18:22:08 -0500
Date:   Mon, 7 Dec 2020 15:21:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607383287;
        bh=SRNlGZC4K9HTW83j1nzXO6TnJE2kKMynAi+x8p3G47Y=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=NhV+70CLfixGuSRLjO9geWAiNruyrCqnDFSk9BgRi+S03/M2sX9/2LjXluMiPCtB4
         QcYfJu/UrXjcnd//WJGzV/X/kjcwHj1r8g8n6iXWEfzq1li1QGsc4+ULqeGQyevPsv
         Xv+KuKmLatduIABOYZl8Nc0sYCS18if4OAsfEcGFVsm/q+61Z/Q3Ivr/CSOR7RtbMJ
         hEp41SbTZcqYCQiMtDNPgxPQfSU8fzGpfJsjpYhV1AdNB3TytDyZ7WS4MXwVe5xhFv
         QsYwzztY+SmHNnRqmqmsvJs/zNoQwWowD25bBPUzFMVoS9Qjp1Hok9pRAeUp9PGAKO
         WEhvIZiHkrFGQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v1 1/9] ethtool: Add support for configuring
 frame preemption
Message-ID: <20201207152126.6f3d1808@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <87eek11d23.fsf@intel.com>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
        <20201202045325.3254757-2-vinicius.gomes@intel.com>
        <20201205094325.790b187f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <87eek11d23.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 07 Dec 2020 14:11:48 -0800 Vinicius Costa Gomes wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> >> + * @min_frag_size_mult: Minimum size for all non-final fragment size,
> >> + * expressed in terms of X in '(1 + X)*64 + 4'  
> >
> > Is this way of expressing the min frag size from the standard?
> >  
> 
> The standard has this: "A 2-bit integer value indicating, in units of 64
> octets, the minimum number of octets over 64 octets required in
> non-final fragments by the receiver" from IEEE 802.3br-2016, Table
> 79-7a.

Thanks! Let's drop the _mult suffix and add a mention of this
controlling the addFragSize variable from the standard. Perhaps 
it should in fact be called add_frag_size (with an explanation 
that the "additional" means "above the 64B" which are required in
Ethernet, and which are accounted for by the "1" in the 1 + X formula)?
