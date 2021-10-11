Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06EB1428712
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 08:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhJKG4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 02:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbhJKG4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 02:56:40 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CEFC061570;
        Sun, 10 Oct 2021 23:54:40 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 2694AC026; Mon, 11 Oct 2021 08:54:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1633935278; bh=Q1XTrDK/BGDzKbFG2dhkm+kOk216JpX5sdw/shtNSHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p7VOLUjlRkextHPaWBWa/XwOyDowqLLVTFQd+U1fAS6xSwCiFA7+i8s/00UK0Gdgj
         ubruoKaMj6Tf43FQ7LmxZ91yizpCxOEN4qnzOX2uAfSBiyLqpXES2rgQvNm2O+sbRq
         1r0vTOHE7JP4ZZEr6a5Li2T2kd9OIBjgPgWIDurpjhMWymDPfRs8Vg/5SIuRv7aIvn
         g1CItaQQGbrUVOw+FLZDE6i0YlIQ/w5nezaUZZ2Y52gQ62nHIVmi8yAn9J9G/5Im+S
         HWn8Y50uVc6S/F5JC66mzsuH005eVNdew3TO9wz1TAljMVVJCp2P3vI0fnSJOLbzl+
         8cn+fx3KOwqnQ==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id E74C1C01F;
        Mon, 11 Oct 2021 08:54:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1633935277; bh=Q1XTrDK/BGDzKbFG2dhkm+kOk216JpX5sdw/shtNSHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vxZie6Il7PBWA/8/3k5PO8RyJLY/2/wefoagBL2AmYP/VTjV79tFiipXxOpO+2aM6
         VDyT+Ue4rMk2pZ/5C7sq3Mo5CLqqmFtBw4SyFcZb05SBBUtD/PBEyEwPpDLOjV75vu
         YYN67GfHLfzLWknJ9QfitbZvapIyq/q3Az5bZbULMG1udrWc4BSKwq+EXHkWaM4IS4
         njNdyVzzz2iqBUCU7mIBDpX+oMmXAS1cBOLe3gTlCiY/kwwzw2Nmo1VbcB+Z41pPjD
         /44JElbQ0NyzP+lnYjHdyJqiWYNiAkd7ALuc5cZ32EpllbOSnG1hapv5E6KB2NKAiK
         5lxWBc+axfzHA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id f827bec5;
        Mon, 11 Oct 2021 06:54:30 +0000 (UTC)
Date:   Mon, 11 Oct 2021 15:54:15 +0900
From:   asmadeus@codewreck.org
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+06472778c97ed94af66d@syzkaller.appspotmail.com>,
        davem@davemloft.net, ericvh@gmail.com, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [syzbot] KMSAN: uninit-value in p9pdu_readf
Message-ID: <YWPfl8FFI5uKX499@codewreck.org>
References: <000000000000baddc805cdf928c3@google.com>
 <YWKmBWfBS3oshQ/z@codewreck.org>
 <CACT4Y+bqD=EkkQB6hm+FVWVraDBChnRgqViLTqvmVrVM=1gH+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACT4Y+bqD=EkkQB6hm+FVWVraDBChnRgqViLTqvmVrVM=1gH+w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the reply,

Dmitry Vyukov wrote on Mon, Oct 11, 2021 at 07:56:05AM +0200:
> > would be 'len' in p9pdu_vreadf, which has to be set as far as I can understand:
> > > uint16_t len;
> > >
> > > errcode = p9pdu_readf(pdu, proto_version,
> > >                                 "w", &len);
> > > if (errcode)
> > >         break;
> > >
> > > *sptr = kmalloc(len + 1, GFP_NOFS);
> >
> > with relevant part of p9pdu_readf being:
> > > case 'w':{
> > >                int16_t *val = va_arg(ap, int16_t *);
> > >                __le16 le_val;
> > >                if (pdu_read(pdu, &le_val, sizeof(le_val))) {
> > >                        errcode = -EFAULT;
> > >                        break;
> > >                }
> > >                *val = le16_to_cpu(le_val);
> > >        }
> > > ...
> > > return errcode;
> >
> > e.g. either len or errcode should be set...
> >
> > But:
> > > Local variable ----ecode@p9_check_errors created at:
> > >  p9_check_errors+0x68/0xb90 net/9p/client.c:506
> > >  p9_client_rpc+0xd90/0x1410 net/9p/client.c:801
> >
> > is something totally different, p9_client_rpc happens before the
> > p9pdu_readf call in p9_client_stat, and ecode is local to
> > p9_check_errors, I don't see how it could get that far.
> >
> > Note that inspecting p9_check_errors manually, there is a case where
> > ecode is returned (indirectly through err = -ecode) without being
> > initialized,
> 
> Does this connect both stacks? So the uinit is ecode, is it used in
> p9pdu_vreadf? If yes, then that's what KMSAN reported.

Hm...
Assuming that's the uninit, it'd have been propagated as the return
value as req = p9_client_rpc; passed the IS_ERR(req) check as not an
error, then passed to p9pdu_readf(&req->rc (later 'pdu')...)
That would then try to read some undefined address in pdu_read() as
memcpy(data, &pdu->sdata[pdu->offset], len)
and returning another undefined value as
sizeof(__le16) - min(pdu->size - pdu->offset, __le16)

Here magic should happen that makes this neither a success (would set
*val e.g. len in the kmalloc line that complains) or an error (would set
errcode e.g. p9pdu_vreadf() would return before reaching that line)

I guess with undefineds anything can happen and this is a valid link?


I would have assumed kmsan checks would fail sooner but I don't see what
else it could be.


> > so I will send a patch for that at least, but I have no
> > idea if that is what has been reported and it should be trivial to
> > reproduce so I do not see why syzbot does not have a reproducer -- it
> > retries running the last program that triggered the error before sending
> > the report, right?
> 
> Yes.

Ok, I guess there are conditions on the undefined value to reach this
check down the road, even if the undefined return itself should be
always reproducible.

Either way Pavel Skripkin reached the same conclusion as me at roughly
the same time so I'll just go with it.

-- 
Dominique
