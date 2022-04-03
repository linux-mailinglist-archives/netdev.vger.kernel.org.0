Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDC24F0976
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 14:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236325AbiDCMkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 08:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbiDCMkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 08:40:12 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A065369DC
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 05:38:18 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id B8E14C021; Sun,  3 Apr 2022 14:38:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1648989496; bh=14x/o31XF+hFpAYq9fTGzk2MDqsFhtWX55WYqE25E1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S/GpHEC8WKXIiLuGa2p+YAJGhDOyKk1dcOKPj9tg5jpGysq4R4wAnmIGLDWBaPJhH
         WjI9R7rrhjESOn7uf5knwAkHb0TEXRPXbEg18X+e/+hShIgjKEJ8z63Pit3Ag8M8WS
         uyao1/JALGjToof3e/VzYJRp9DwBNcTk9QqTLIJ831tabMN1CqU3BmYYU+OdnEvPJm
         MKwF+IBxnox4sjuZX+6l2mDI4pZQbWSsGtvZ16HV94aYHnF11YVFXWQsC6Y1pn3lQE
         YBKF17QNL525xTZNE8cRsxnM6ptzF5D+/oPt3tPa6+/JfcKrLstV8BEu/08dwAGI46
         J/jPGwkcy2EKA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 3FDEEC009;
        Sun,  3 Apr 2022 14:38:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1648989495; bh=14x/o31XF+hFpAYq9fTGzk2MDqsFhtWX55WYqE25E1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cIyFg8jarIQGtbhQlFmpExci4A64a6JwCSMyoStzU8Qh+IQ2Ww4LmHhlP8t6cU0lA
         JiLWalJRxi3/U0BWKgroj13SnuxZ7SRIlpbK28Dl5iPwOSKH9Loulme620K8TuRNXp
         lYybuOgeviKx/I1MxYqLxMA0MQbrfONszpiwJN5vleNJUxIVqepSWaHvB30mdTEhIw
         6pQ+S8ZC7hZWGSVZTsSaXcDlJY8OZP2L3O3a5Rf7/iKRfXg5YY8sTzotdrxQD1V/HS
         wtaRu7Hk/du97HKFO1BEPbSG5DR7J2DmxVtiVR3nGSx3c3Kcd8e8sJCZcvSo1QpI1g
         dCaCeN/aStUZA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 467446ff;
        Sun, 3 Apr 2022 12:38:10 +0000 (UTC)
Date:   Sun, 3 Apr 2022 21:37:55 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [PATCH v4 12/12] net/9p: allocate appropriate reduced message
 buffers
Message-ID: <YkmVI6pqTuMD8dVi@codewreck.org>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
 <8c305df4646b65218978fc6474aa0f5f29b216a0.1640870037.git.linux_oss@crudebyte.com>
 <YkhYMFf63qnEhDd0@codewreck.org>
 <1953222.pKi1t3aLRd@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1953222.pKi1t3aLRd@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Sun, Apr 03, 2022 at 01:29:53PM +0200:
> So maybe I should just exclude the 9p RDMA transport from this 9p message size 
> reduction change in v5 until somebody had a chance to test this change with 
> RDMA.

Yes, I'm pretty certain it won't work so we'll want to exclude it unless
we can extend the RDMA protocol to address buffers.

From my understanding, RDMA comes with two type of primitives:
 - recv/send that 9p exlusively uses, which is just a pool of buffers
registered to the NIC and get filled on a first-come-first-serve basis
(I'm not sure if it's a first-fit, or if message will be truncated, or
if it'll error out if the message doesn't fit... But basically given
that's what we use for 9p we have no way of guaranteeing that a read
reply will be filled in the big buffer allocated for it and not
something else)

If we're lucky the algorithm used is smallest-fit first, but it doesn't
look like it:
---
The order of the Receive Request consumptions in a Receive Queue is by
the order that they were posted to it.
When you have a SRQ, you cannot predict which Receive Request will be
consumed by which QP, so all the Receive Requests in that SRQ should be
able to contain the incoming message (in terms of length).
--- https://www.rdmamojo.com/2013/02/02/ibv_post_recv/ (in a comment)


 - read/write, which can be addressed e.g. the remote end can specify a
cookie along with address/size and directly operate on remote memory
(hence the "remote direct memory access" name). There are also some cool
stuff that can be done like atomic compare and swap or arithmetic
operations on remote memory which doesn't really concern us.

Using read/writes like NFS over RDMA does would resolve the problem and
allow what they call "direct data placement", which is reading or
writing directly from the page cache or user buffer as a real zero copy
operation, but it requires the cookie/address to be sent and client to
act on it so it's a real transport-specific protocol change, but given
the low number of users I think that's something that could be
considered if someone wants to work on it.

Until then we'll be safer with that bit disabled...

> Which makes me wonder, what is that exact hardware, hypervisor, OS that 
> supports 9p & RDMA?

I've used it with mellanox infiniband cards in the past. These support
SRIOV virtual functions so are quite practical for VMs, could let it do
the work with a single machine and no cable.

I'm pretty sure it'd work with any recent server hardware that supports
RoCE (I -think- it's getting more common?), or with emulation ~10 years
ago I got it to run with softiwarp which has been merged in the kernel
(siw) since so that might be the easiest way to run it now.

Server-side, both diod and nfs-ganesha support 9p over RDMA, I haven't
used diod recently but ganesha ought to work.


> On the long-term I can imagine to add RDMA transport support on QEMU 9p side. 

What would you expect it to be used for?

> There is already RDMA code in QEMU, however it is only used for migration by 
> QEMU so far I think.

Yes, looking at it a bit there's live migration over RDMA (I tested it
at my previous job), some handling for gluster+rdma, and a
paravirtualized RDMA device (pvrdma).
the docs for it says it works with soft-roce so it would also probably
work for tests (I'm not sure what difference there is between rxe and
siw), but at this point you've just setup virtualized rdma on the host
anyway...

I'll try to get something setup for tests on my end as well, it's
definitely something I had on my todo...
-- 
Dominique
