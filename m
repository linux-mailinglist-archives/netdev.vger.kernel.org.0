Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1934427F428
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbgI3VY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:24:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgI3VY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 17:24:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D7322072E;
        Wed, 30 Sep 2020 21:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601501068;
        bh=zP7URT6N/ADqJP2ihoxzR6Q8eYoKf4TshxRKqj4Xp/Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=16u54P6urjqiX6zotC1Cs/M485Zw1YVLT7DJ8xDReyj2IEU2y+N8nTd/M6NpQBW10
         ZibVrRZOfZFi6IdXlNrVbcDCQPh/mP/gVRQjuh4sM3H/NruzDSJTiqLXxj0K0v5Lgb
         bH6LEO//tVH0VoqAUF0DmacpJcCmu6oCEwvqDPys=
Date:   Wed, 30 Sep 2020 14:24:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next v3 4/4] gve: Add support for raw addressing in
 the tx path
Message-ID: <20200930142427.44cf05b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAL9ddJeQARACr6bSrdod-gEacKLqnYz3=kfkY+ogfkXVo_EnBw@mail.gmail.com>
References: <20200924010104.3196839-1-awogbemila@google.com>
        <20200924010104.3196839-5-awogbemila@google.com>
        <20200924155103.7b1dda5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAL9ddJeQARACr6bSrdod-gEacKLqnYz3=kfkY+ogfkXVo_EnBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 09:09:57 -0700 David Awogbemila wrote:
> > > +             len -= hlen;
> > > +             addr += hlen;
> > > +             seg_desc = &tx->desc[(tx->req + 1) & tx->mask];
> > > +             seg_idx_bias = 2;
> > > +             gve_tx_fill_seg_desc(seg_desc, skb, is_gso, len, addr);
> > > +     } else {
> > > +             seg_idx_bias = 1;
> > > +             gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso, l4_hdr_offset,
> > > +                                  1 + payload_nfrags, hlen, addr);  
> >
> > and this look identical. You can probably move it before the if.  
> 
> Thanks, I need to make sure I understand: you're referring to the call
> to gve_tx_fill_pkt_desc? if so, the calls look the same but
> payload_nfrags is different in the if and else cases, perhaps I could
> move it after the else? but I'm not sure if that helps.

Fair, you can leave it as is.
