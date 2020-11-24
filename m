Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE0F2C1EFE
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 08:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbgKXHjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 02:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730064AbgKXHjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 02:39:54 -0500
X-Greylist: delayed 502 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 23 Nov 2020 23:39:53 PST
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB82C0613CF;
        Mon, 23 Nov 2020 23:39:53 -0800 (PST)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id A9BAD100BA619;
        Tue, 24 Nov 2020 08:31:25 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id DEDA867C55; Tue, 24 Nov 2020 08:31:26 +0100 (CET)
Date:   Tue, 24 Nov 2020 08:31:26 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Laura =?iso-8859-1?Q?Garc=EDa_Li=E9bana?= <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
Message-ID: <20201124073126.GA4856@wunner.de>
References: <e8aecc2b-80cb-8ee5-8efe-7ae5c4eafc70@iogearbox.net>
 <CAF90-Whc3HL9x-7TJ7m3tZp10RNmQxFD=wdQUJLCaUajL2RqXg@mail.gmail.com>
 <8e991436-cb1c-1306-51ac-bb582bfaa8a7@iogearbox.net>
 <CAF90-Wh=wzjNtFWRv9bzn=-Dkg-Qc9G_cnyoq0jSypxQQgg3uA@mail.gmail.com>
 <29b888f5-5e8e-73fe-18db-6c5dd57c6b4f@iogearbox.net>
 <20201011082657.GB15225@wunner.de>
 <20201121185922.GA23266@salvia>
 <CAADnVQK8qHwdZrqMzQ+4Q9Cg589xLX5zTve92ZKN_zftJg_WHw@mail.gmail.com>
 <20201122110145.GB26512@salvia>
 <20201124033422.gvwhvsjmwt3b3irx@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124033422.gvwhvsjmwt3b3irx@ast-mbp>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 07:34:22PM -0800, Alexei Starovoitov wrote:
> It's a missing hook for out-of-tree module. That's why it stinks so much.

As I've said before, the motivation for these patches has pivoted away
from the original use case (which was indeed an out-of-tree module by
a company for which I no longer work):

https://lore.kernel.org/netdev/20200905052403.GA10306@wunner.de/

When first submitting this series I also posted a patch to use the nft
egress hook from userspace for filtering and mangling.  It seems Zevenet
is actively using that:

https://lore.kernel.org/netdev/CAF90-Wi4W1U4FSYqyBTqe7sANbdO6=zgr-u+YY+X-gvNmOgc6A@mail.gmail.com/


> So please consider augmenting your nft k8s solution with a tiny bit of bpf.
> bpf can add a new helper to call into nf_hook_slow().

The out-of-tree module had nothing to do with k8s, it was for industrial
fieldbus communication.  But again, I no longer work for that company.
We're talking about a hook that's used by userspace, not by an out-of-tree
module.


> If it was not driven by
> out-of-tree kernel module I wouldn't have any problem with it.

Good!  Thank you.  Let me update and repost the patches then.

Lukas
