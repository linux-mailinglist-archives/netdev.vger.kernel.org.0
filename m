Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7695498183
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 14:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbiAXNzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 08:55:48 -0500
Received: from kylie.crudebyte.com ([5.189.157.229]:46021 "EHLO
        kylie.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiAXNzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 08:55:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=HxlWWgQ8GauYiCKoZUa6/zar05u3k+mFM55UuvHV8R8=; b=FbGaJG6nni/T2SHQ9RYXN+Dmkq
        11rD81KTQk3r6dxr4KS5ykrf2+1HxJw7xa5FWVfddkJ/aq7RqHnzciAFzALnZwU60jbzn16Rjmxsd
        x3Kij3bGwAMtKz126RrncquKnLWgOmCNkv5L2XST4PDqPNzKnhnOJ/8i0RS1G97r4twBpVcpKPF1Q
        nTL7vHh10WgIx6slrzzcX6SXASwa2ckR8ouYz2t/xrGXBsYraHziOFyjjBtrf6d68YGIA3tMLOUBs
        KLsLRhU+JG17NYEl0fAPNbG4Q/T3LHelkh4ycx9jMrh3sb8G6KEVr5L7RU8q/09G2jm3S1qMgUEI9
        eyTxRO0cvJ2/uBbG4ayOyJqv9THZSuVbIuVK65qXD0gtnbtc2rZLymCOuE10KCrs1ny5u9RUM5yTX
        OlZEINTKOhW4/cirbM7YXhjz6056q3k3QfaQjgtxVFh4GC49gXls9itCfLf4xrBLWNBx9Lx6Eaor0
        Vu5U3uZOLd6fd/Vu+qiDM9wucyXGKdJb8gHaCy24lV6iaTXWzl3jliT+FM1XfnSe3r6b6aIyiI5/3
        B1/nrAlEz/bVSoKxHxJPB7h4S9JAbT1sD+ar9REDQCEpDtWI2Vtpnqq5ezGubDOUiMOihispVFL7D
        9bKo3cKgVL/Gc1dhEITdhi0lbf/tWSKu0ar76eF18=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Nikolay Kichukov <nikolay@oldum.net>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v4 00/12] remove msize limit in virtio transport
Date:   Mon, 24 Jan 2022 14:55:44 +0100
Message-ID: <5072414.NxdI05fPOR@silver>
In-Reply-To: <Ye6h8U/NJcx3ErHa@codewreck.org>
References: <cover.1640870037.git.linux_oss@crudebyte.com> <22204794.ZpPF1Y2lYg@silver> <Ye6h8U/NJcx3ErHa@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Montag, 24. Januar 2022 13:56:17 CET Dominique Martinet wrote:
> Christian Schoenebeck wrote on Mon, Jan 24, 2022 at 12:57:35PM +0100:
> > > We're just starting a new development cycle for 5.18 while 5.17 is
> > > stabilizing, so this mostly depends on the ability to check if a msize
> > > given in parameter is valid as described in the first "STILL TO DO"
> > > point listed in the cover letter.
> > 
> > I will ping the Redhat guys on the open virtio spec issue this week. If
> > you
> > want I can CC you Dominique on the discussion regarding the virtio spec
> > changes. It's a somewhat dry topic though.
> 
> I don't have much expertise on virtio stuff so don't think I'll bring
> much to the discussion, but always happy to fill my inbox :)
> It's always good to keep an eye on things at least.

Ok, I'll then CC you from now on at the virtio spec front, if it gets too 
noisy just raise your hand.

> > > I personally would be happy considering this series for this cycle with
> > > just a max msize of 4MB-8k and leave that further bump for later if
> > > we're sure qemu will handle it.
> > 
> > I haven't actually checked whether there was any old QEMU version that did
> > not support exceeding the virtio queue size. So it might be possible that
> > a very ancient QEMU version might error out if msize > (128 * 4096 =
> > 512k).
> Even if the spec gets implemented we need the default msize to work for
> reasonably older versions of qemu (at least a few years e.g. supported
> versions of debian/rhel can go quite a while back), and ideally have a
> somewhat sensible error if we go above some max...

Once the virtio spec changes are accepted and implemented, that would not be 
an issue at all, virtio changes are always made with backward compatibility in 
mind. The plan is to negotiate that new virtio feature on virtio subsystem 
level, if either side does not support the new virtio feature (either too old 
QEMU or too old kernel), then msize would automatically be limited to the old 
virtio size/behaviour (a.k.a. virtio "queue size") and with QEMU as 9p server 
that would be max. msize 500k.

Therefore I suggest just waiting for the virtio spec changes to be complete 
and implemented. People who care about performance should then just use an 
updated kernel *and* updated QEMU version to achieve msize > 500k. IMO, no 
need to risk breaking some old kernel/QEMU combination if nobody asked for it 
anyway, and if somebody does, then we could still add some kind of
--force-at-your-own-risk switch later on.

> > Besides QEMU, what other 9p server implementations are actually out there,
> > and how would they behave on this? A test on their side would definitely
> > be a good idea.
> 
> 9p virtio would only be qemu as far as I know.
> 
> For tcp/fd there are a few:
>  - https://github.com/chaos/diod (also supports rdma iirc, I don't have
> any hardware for rdma tests anymore though)
>  - https://github.com/nfs-ganesha/nfs-ganesha (also rdma)
>  - I was pointed at https://github.com/lionkov/go9p in a recent bug
> report
>  - http://repo.cat-v.org/libixp/ is also a server implementation I
> haven't tested with the linux client in a while but iirc it used to work
> 
> 
> I normally run some tests with qemu (virtio) and ganesha (tcp) before
> pushing to my linux-next branch, so we hopefully don't make too many
> assumptions that are specific to a server

Good to know, thanks!

> > > We're still seeing a boost for that and the smaller buffers for small
> > > messages will benefit all transport types, so that would get in in
> > > roughly two months for 5.18-rc1, then another two months for 5.18 to
> > > actually be released and start hitting production code.
> > > 
> > > 
> > > I'm not sure when exactly but I'll run some tests with it as well and
> > > redo a proper code review within the next few weeks, so we can get this
> > > in -next for a little while before the merge window.
> > 
> > Especially the buffer size reduction patches needs a proper review. Those
> > changes can be tricky. So far I have not encountered any issues with tests
> > at least. OTOH these patches could be pushed through separately already,
> > no matter what the decision regarding the virtio issue will be.
> 
> Yes, I've had a first look and it's quite different from what I'd have
> done, but it didn't look bad and I just wanted to spend a bit more time
> on it.
> On a very high level I'm not fond of the logical duplication brought by
> deciding the size in a different function (duplicates format strings for
> checks and brings in a huge case with all formats) when we already have
> one function per call which could take the size decision directly
> without going through the format varargs, but it's not like the protocol
> has evolved over the past ten years so it's not really a problem -- I
> just need to get down to it and check it all matches up.

Yeah I know, the advantage though is that this separate function/switch-case 
approach merges many message types. So it is actually less code. And I tried 
to automate code sanity with various BUG_ON() calls to prevent them from 
accidentally drifting with future changes.

> I also agree it's totally orthogonal to the virtio size extension so if
> you want to wait for the new virtio standard I'll focus on this part
> first.

IMO it would make sense to give these message size reduction patches priority 
for now, as long as the virtio spec changes are incomplete.

One more thing: so far I have just concentrated on behavioural aspects and 
testing. What I completed neglected so far was code style. If you want I can 
send a v5 this week with code style (and only code style) being fixed if that 
helps you to keep diff-noise low for your review.

Best regards,
Christian Schoenebeck


