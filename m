Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CBC23E7CD
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 09:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgHGHV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 03:21:27 -0400
Received: from verein.lst.de ([213.95.11.211]:52859 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGHV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 03:21:26 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A67A168D0F; Fri,  7 Aug 2020 09:21:20 +0200 (CEST)
Date:   Fri, 7 Aug 2020 09:21:20 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: Re: [PATCH 25/26] net: pass a sockptr_t into ->setsockopt
Message-ID: <20200807072120.GB2086@lst.de>
References: <20200723060908.50081-1-hch@lst.de> <20200723060908.50081-26-hch@lst.de> <6357942b-0b6e-1901-7dce-e308c9fac347@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6357942b-0b6e-1901-7dce-e308c9fac347@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 06, 2020 at 03:21:25PM -0700, Eric Dumazet wrote:
> converting get_user(...)   to  copy_from_sockptr(...) really assumed the optlen
> has been validated to be >= sizeof(int) earlier.
> 
> Which is not always the case, for example here.

Yes.  And besides the bpfilter mess the main reason I even had to add
the sockptr vs just copying optlen in the high-level socket code.

Please take a look at the patch in the other thread to just revert to
the "dumb" version everywhere.
