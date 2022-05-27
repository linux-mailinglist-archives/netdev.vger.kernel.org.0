Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA07A535DB9
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 11:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350733AbiE0J6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 05:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350728AbiE0J6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 05:58:43 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C854339D;
        Fri, 27 May 2022 02:58:38 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6FA8E5C015C;
        Fri, 27 May 2022 05:58:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 27 May 2022 05:58:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1653645515; x=1653731915; bh=EiD5ylETSiKx2sZ0AEuhqhGtVCfZ
        ZuZgoLENo4nmHjI=; b=nl1wqhKerxlTczMdRkjvSnPtwogU5s5fEPawnMJK9jUi
        +U9sQE+Xa1qD8B/YVmkLs+aD7AXrZF5/TcXXNqDyFR29gcywdBl6ohsY5JzqUoK4
        QjJ+Kr7VGpMSB0rSdfvt/gGkgIvHXdPIwpgtJEKihENGGJ9hHO0AcZMYWK0xF2zm
        +4UF50xRCHd0pMAppOt+J0yqGgj9uLz3FNZ02YlwodsgSlSILClZDP3Q19fBCZW0
        5jWVH2/Xffs9D0+eMxydw3bJPskA6uDhP82oHM/FBeEnpb9+TLlJRU7wy6tsluic
        JPgN/u76HcWDZe7U+kxV+HPMfhAUJE8fuvPN7EYU3g==
X-ME-Sender: <xms:yqCQYi5uVAePkXoWspOvnHh8L_xPLalSW9G1n64DafXVXC6yXvqMug>
    <xme:yqCQYr5ZTriITbWl1N-V4q5-33eXA3IbLWwpv7d1riob3tw0iqqX0lEqkJ_mufXTg
    rQs7CVUzS_D2-M>
X-ME-Received: <xmr:yqCQYhdChVRfZ3YHejad2KTBTfieOxfIkk5VrPNZ-GfoQWOpgJPofCBnAyXTnM8ORIF5-2G1ZF-jpScoCn3_Vd6RoNTqVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrjeelgddvudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeejgeeg
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:yqCQYvI5NdpEHQGa421oczRfs8oDG5kKWtCpLVA0NKpvWt-F5koyzw>
    <xmx:yqCQYmLcFD69B14v_s2Vn0FHsm1uIGUmjjTs4MWgDq1kc67F6vIjpw>
    <xmx:yqCQYgx-INT9hl_02YCP-cqFsfFY6MxkrIRA6wp2aNkIcFQNwZufvA>
    <xmx:y6CQYndoTV0A5gjPE9GQ_bQeERG3Or7GULDrCHVpljyeLiItw_ia0Q>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 May 2022 05:58:34 -0400 (EDT)
Date:   Fri, 27 May 2022 12:58:30 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
Message-ID: <YpCgxtJf9Qe7fTFd@shredder>
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <Yo+LAj1vnjq0p36q@shredder>
 <86sfov2w8k.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86sfov2w8k.fsf@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 27, 2022 at 10:52:27AM +0200, Hans Schultz wrote:
> On tor, maj 26, 2022 at 17:13, Ido Schimmel <idosch@idosch.org> wrote:
> > On Tue, May 24, 2022 at 05:21:41PM +0200, Hans Schultz wrote:
> >> Add an intermediate state for clients behind a locked port to allow for
> >> possible opening of the port for said clients. This feature corresponds
> >> to the Mac-Auth and MAC Authentication Bypass (MAB) named features. The
> >> latter defined by Cisco.
> >> Locked FDB entries will be limited in number, so as to prevent DOS
> >> attacks by spamming the port with random entries. The limit will be
> >> a per port limit as it is a port based feature and that the port flushes
> >> all FDB entries on link down.
> >
> > Why locked FDB entries need a special treatment compared to regular
> > entries? A port that has learning enabled can be spammed with random
> > source MACs just as well.
> >
> > The authorization daemon that is monitoring FDB notifications can have a
> > policy to shut down a port if the rate / number of locked entries is
> > above a given threshold.
> >
> > I don't think this kind of policy belongs in the kernel. If it resides
> > in user space, then the threshold can be adjusted. Currently it's hard
> > coded to 64 and I don't see how user space can change or monitor it.
> 
> In the Mac-Auth/MAB context, the locked port feature is really a form of
> CPU based learning, and on mv88e6xxx switchcores, this is facilitated by
> violation interrupts. Based on miss violation interrupts, the locked
> entries are then added to a list with a timer to remove the entries
> according to the bridge timeout.
> As this is very CPU intensive compared to normal operation, the
> assessment is that all this will jam up most devices if bombarded with
> random entries at link speed, and my estimate is that any userspace 
> daemon that listens to the ensuing fdb events will never get a chance
> to stop this flood and eventually the device will lock down/reset. To
> prevent this, the limit is introduced.
> 
> Ideally this limit could be adjustable from userspace, but in real
> use-cases a cap like 64 should be more than enough, as that corresponds
> to 64 possible devices behind a port that cannot authenticate by other
> means (printers etc.) than having their mac addresses white-listed.
> 
> The software bridge behavior was then just set to correspond to the
> offloaded behavior, but after correspondence with Nik, the software
> bridge locked entries limit will be removed.

As far as the bridge is concerned, locked entries are not really
different from regular learned entries in terms of processing and since
we don't have limits for regular entries I don't think we should have
limits for locked entries.

I do understand the problem you have in mv88e6xxx and I think it would
be wise to hard code a reasonable limit there. It can be adjusted over
time based on feedback and possibly exposed to user space.

Just to give you another data point about how this works in other
devices, I can say that at least in Spectrum this works a bit
differently. Packets that ingress via a locked port and incur an FDB
miss are trapped to the CPU where they should be injected into the Rx
path so that the bridge will create the 'locked' FDB entry and notify it
to user space. The packets are obviously rated limited as the CPU cannot
handle billions of packets per second, unlike the ASIC. The limit is not
per bridge port (or even per bridge), but instead global to the entire
device.
