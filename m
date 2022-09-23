Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0356D5E7B9B
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 15:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbiIWNQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 09:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiIWNQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 09:16:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E944013C86A
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 06:16:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1405B80C7B
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13DEC433D7;
        Fri, 23 Sep 2022 13:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663939002;
        bh=B36MaMoH2SlTOnpa0i9dgMKBIYd5GO4gXjv44jPR/RE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T7BagpWKFCDKj5wdrLvrHNMcZEvOReQqZfDUeNO9F8ZnSYMz6CremzCFwQBXPVIMr
         /x/VcnjwEX4mpmvqNsawPa1MYzUMrfFXvgGb0F02FZQJy/Apsbhj/jb3cc2x+zCii1
         YUvsy/nr1jyctbrVZIrarabJWuzc+QBPwkKry7kdYLysZ2jbrZWs64TEUHdMMhjaxl
         AKa/e3pyjUr5b2RPd+hncV9V/LskOnkHPE6uLkoVdmPdcForVsIet/x0C1OWp5iwtY
         +hTE7t/xOXYr2Id1OCqWnLETjYGz2K3S9mNCN/Ev1bG2InnfkrW025NwUynpqWymgA
         Yt4voWf4Lf1Mw==
Date:   Fri, 23 Sep 2022 06:16:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <alexandr.lobakin@intel.com>, <dchumak@nvidia.com>,
        <maximmi@nvidia.com>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>, <jacob.e.keller@intel.com>,
        <jesse.brandeburg@intel.com>, <przemyslaw.kitszel@intel.com>
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api
 with queues and new parameters
Message-ID: <20220923061640.595db7ef@kernel.org>
In-Reply-To: <732253d6-69a4-e7ab-99a2-f310c0f22b12@intel.com>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
        <20220915134239.1935604-3-michal.wilczynski@intel.com>
        <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
        <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
        <20220921163354.47ca3c64@kernel.org>
        <477ea14d-118a-759f-e847-3ba93ae96ea8@intel.com>
        <20220922055040.7c869e9c@kernel.org>
        <9656fcda-0d63-06dc-0803-bc5f90ee44fd@intel.com>
        <20220922132945.7b449d9b@kernel.org>
        <732253d6-69a4-e7ab-99a2-f310c0f22b12@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Sep 2022 14:11:08 +0200 Wilczynski, Michal wrote:
> On 9/22/2022 10:29 PM, Jakub Kicinski wrote:
> > On Thu, 22 Sep 2022 15:45:55 +0200 Wilczynski, Michal wrote: =20
> >> On 9/22/2022 2:50 PM, Jakub Kicinski wrote: =20
>
> I'm not sure whether this is allowed on mailing list, but I'm attaching=20
> a text file  with an ASCII drawing representing a tree I've send
> previously as linear. Hope you'll find this easier to read.

That helps, thanks! So what I was saying was anything under the vport
layer should be configured by the policy local to the owner of the
function.

> >> We tried already tc-htb, and it doesn't work for a couple of reasons,
> >> even in this potential hybrid with devlink-rate. One of the problems
> >> with tc-htb offload is that it forces you to allocate a new
> >> queue, it doesn't allow for reassigning an existing queue to another
> >> scheduling node. This is our main use case.
> >>
> >> Here's a discussion about tc-htb:
> >> https://lore.kernel.org/netdev/20220704114513.2958937-1-michal.wilczyn=
ski@intel.com/ =20
> > This is a problem only for "SR-IOV case" or also for just the PF? =20
>=20
> The way tc-htb is coded it's NOT possible to reassign queues from one=20
> scheduling node to the other, this is a generic problem with this
> implementation, regardless of SR-IOV or PF. So even if we
> wanted to reassign queues only for PF's this wouldn't be possible.
> I feel like an example would help. So let's say I do this:
>=20
> tc qdisc replace dev ens785 root handle 1: htb offload
> tc class add dev ens785 parent 1: classid 1:2 htb rate 1000 ceil 2000
> tc class add dev ens785 parent 1:2 classid 1:3 htb rate 1000 ceil 2000
> tc class add dev ens785 parent 1:2 classid 1:4 htb rate 1000 ceil 2000
> tc class add dev ens785 parent 1:3 classid 1:5 htb rate 1000 ceil 2000
> tc class add dev ens785 parent 1:4 classid 1:6 htb rate 1000 ceil 2000
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1:=C2=A0=C2=A0=C2=A0 <-- root qdisc
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 1:2
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 / \
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 /=C2=A0=C2=A0 \
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 1:3=C2=A0=C2=A0 1:4
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0 |
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0 |
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 1:5=C2=A0=C2=A0 1:6
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0 |
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 QID=C2=A0=C2=A0 QID=C2=A0=C2=A0 <---- here we'll have PFIFO qdiscs
>=20
>=20
> At this point I would have two additional queues in the system, and
> the kernel would enqueue packets to those new queues according to 'tc
> flower' configuration.=20

TBH I don't know what you mean by "reassign queues from one=20
scheduling node to the other", sorry I don't know this code well.
Neither the offload nor HTB itself.

My uneducated anticipation of how HTB offload would work is that=20
queue 0 of the NIC is a catch all for leftovers and all other queues
get assigned leaf nodes.

> So theoretically we should create a new queue
> in a hardware and put it in a privileged position in the scheduling=20
> tree. And I would happily write it this
> way, but this is NOT what our customer want. He doesn't want any
> extra queues in the system, he just
> wants to make existing queues more privileged. And not just PF queues
> - he's mostly interested in VF queues.
> I'm not sure how to state use case more clearly.

The VF means controlling queue scheduling of another function
via the PF, right? Let's leave that out of the picture for now
so we don't have to worry about "architectural" concerns.

> >> So either I would have to invent a new offload type (?) for tc, or
> >> completely rewrite and
> >> probably break tc-htb that mellanox implemented.
> >> Also in our use case it's possible to create completely new
> >> branches from the root and
> >> reassigning queues there. This wouldn't be possible with the method
> >> you're proposing.
> >>
> >> So existing interface doesn't allow us to do what is required. =20
> > For some definition of "what is required" which was not really
> > disclosed clearly. Or I'm to slow to grasp. =20
>=20
> In most basic variant what we want is a way to make hardware queues
> more privileged, and modify hierarchy of nodes/queues freely. We
> don't want to create new queues, as required by tc-htb
> implementation. This is main reason why tc-htb and devlink-rate
> hybrid doesn't work for us.

Hm, when you say "privileged" do you mean higher quota or priority?
