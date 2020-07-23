Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A07D22B3DD
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 18:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729964AbgGWQok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 12:44:40 -0400
Received: from verein.lst.de ([213.95.11.211]:60887 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726621AbgGWQoi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 12:44:38 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8C74368AFE; Thu, 23 Jul 2020 18:44:32 +0200 (CEST)
Date:   Thu, 23 Jul 2020 18:44:32 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: Re: [PATCH 04/26] net: add a new sockptr_t type
Message-ID: <20200723164432.GA20917@lst.de>
References: <20200723060908.50081-1-hch@lst.de> <20200723060908.50081-5-hch@lst.de> <CANn89iJ3LKth-iWwh0+P3D3RqtDNv4AyXkkzhXr0oSEvE_JoRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJ3LKth-iWwh0+P3D3RqtDNv4AyXkkzhXr0oSEvE_JoRQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 09:40:27AM -0700, Eric Dumazet wrote:
> I am not sure why you chose sockptr_t   for something that really seems generic.
> 
> Or is it really meant to be exclusive to setsockopt() and/or getsockopt() ?
> 
> If the first user of this had been futex code, we would have used
> futexptr_t, I guess.

It was originally intended to be generic and called uptr_t, based
on me misunderstanding that Linus wanted a file operation for it,
which he absolutely didn't and hate with passion.  So the plan is to
only use it for setsockopt for now, although there are some arguments
for also using it in sendmsg/recvmsg.  There is no need to use it for
getsockopt.
