Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4600C681393
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 15:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237805AbjA3OmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 09:42:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235759AbjA3OmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 09:42:24 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF581D93F
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 06:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=TfM2ehciCxuDO9aZadC7nXm35RgVlS2hj1lG/OodgEA=; b=CN
        9B5xjb1mqY24du+h1I3aTrwTx+w+0w72kKnqll5haG9KKpgaLwrKDR9wE1D6gnsAxz6243PrbJByz
        lGzL2dAb8TpBcu1hE1+zeHBCLqKSI0ILn51/EVsfLPhEJxIyud58mVhndF4lgxyVJ5kD5tL/vivdR
        v+1Z7rz/Y2mT1yA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pMVMI-003aDs-5a; Mon, 30 Jan 2023 15:42:10 +0100
Date:   Mon, 30 Jan 2023 15:42:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
Message-ID: <Y9fXQo1kmIXfs7eS@lunn.ch>
References: <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch>
 <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
 <63d747d91add9_3367c208f1@john.notmuch>
 <Y9eYNsklxkm8CkyP@nanopsycho>
 <87pmawxny5.fsf@toke.dk>
 <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jamal

I'm mostly sat watching and eating popcorn, and i have little
knowledge in the area.

> Jiri, i think one of the concerns you have is that there is no way to
> generalize the different hardware by using a single abstraction since
> all hardware may have different architectures (eg whether using RMT vs
> DRMT, a mesh processing xbar, TCAM, SRAM, host DRAM,  etc) which may
> necessitate doing things like underlying table reordering, merging,
> sorting etc. The consensus is that it is the vendor driver that is
> responsible for “transforming” P4 abstractions into whatever your
> hardware does.

What is the complexity involved in this 'transformation'? Are we
talking about putting a P4 'compiler' into each driver, each vendor
having there own compiler? Performing an upcall into user space with a
P4 blob and asking the vendor tool to give us back a blob for the
hardware? Or is it relatively simple, a few hundred lines of code,
simple transformations?

As far as i know, all offloading done so far in the network stack has
been purely in kernel. We transform a kernel representation of
networking state into something the hardware understands and pass it
to the hardware. That means, except for bugs, what happens in SW
should be the same as what happens in HW, just faster. But there have
been mention of P4 extensions. Stuff that the SW P4 implementation
cannot do, but the hardware can, and vendors appear to think such
extensions are part of their magic sauce. How will that work? Is the
'compiler' supposed to recognise plain P4 equivalent of these
extensions and replace it with those extensions?

I suppose what i'm trying to get at, is are we going to enforce the SW
and HW equivalence by doing the transformation in kernel, or could we
be heading towards in userspace we take our P4 and compile it with one
toolchain for the SW path, another toolchain for the HW path, and we
have no guarantee that the resulting blobs actually came from the same
sources and are supposed to be equivalent? And that then makes the SW
path somewhat pointless?

     Andrew
