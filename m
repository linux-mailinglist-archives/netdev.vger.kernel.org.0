Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A491C4B2D3D
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 20:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239159AbiBKTBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 14:01:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbiBKTBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 14:01:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F055CE9
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 11:01:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEA5C61F18
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 19:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26CDC340E9;
        Fri, 11 Feb 2022 19:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644606062;
        bh=TtSm4x3vLT4OcPLZlPtwVTxTVpP77mmbPSssSdsOiX4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nqh7dOdKlQTIijcUsQZWIUCv0RWPyfbcMhjLva7IArMScncyeOnMfVxV6BAdM+G5c
         fYftiC9XoCbXeurWDc0Ak0gUds3JgKI9ApB+W2WdkkJWreFtclRcoP4uJG41kKrK4w
         6aThN7r+u87ysldxjF0zR6y5OaukYDbtdrzF5yoahU5XrUIor0Q8gLiv4xn2IvJFUU
         VCrGD1IeF06GGPfwrGbBn4WFle1c7B94AiA96d9eQ0+TfWA8cZhVUXaNV88+pfgn8A
         J6kroG+J/Ng4QZsV6J7Zj9nm8LcGLrqY8GzEQTSxpcD1JvphWbIniOrzDqaddrIhVE
         fIKuWj+zPEu4Q==
Date:   Fri, 11 Feb 2022 11:01:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, habetsm.xilinx@gmail.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] sfc: default config to 1 channel/core in
 local NUMA node only
Message-ID: <20220211110100.5580d1ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACT4ouepk83kxTGd6S3gVyFAjofofwQfxsmhe97vGP+twkoW1g@mail.gmail.com>
References: <20220128151922.1016841-1-ihuguet@redhat.com>
        <20220128151922.1016841-2-ihuguet@redhat.com>
        <20220128142728.0df3707e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACT4ouctx9+UP2BKicjk6LJSRcR2M_4yDhHmfDARcDuVj=_XAg@mail.gmail.com>
        <20220207085311.3f6d0d19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACT4oucCn2ixs8hCizGhvjLPOa90k3vEZEVbuY6nUF-M23B=yw@mail.gmail.com>
        <20220210082249.0e50668b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACT4ouepk83kxTGd6S3gVyFAjofofwQfxsmhe97vGP+twkoW1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Feb 2022 12:05:19 +0100 =C3=8D=C3=B1igo Huguet wrote:
> Totally. My comment was intended to be more like a question to see why
> we should or shouldn't consider NUMA nodes in
> netif_get_num_default_rss_queues. But now I understand your point
> better.
>=20
> However, would it make sense something like this for
> netif_get_num_default_rss_queues, or it would be a bit overkill?
> if the system has more than one NUMA node, allocate one queue per
> physical core in local NUMA node.
> else, allocate physical cores / 2

I don't have a strong opinion on the NUMA question, to be honest.
It gets complicated pretty quickly. If there is one NIC we may or=20
may not want to divide - for pure packet forwarding sure, best if
its done on the node with the NIC, but that assumes the other node=20
is idle or doing something else? How does it not need networking?

If each node has a separate NIC we should definitely divide. But
it's impossible to know the NIC count at the netdev level..

So my thinking was let's leave NUMA configurations to manual tuning.
If we don't do anything special for NUMA it's less likely someone will
tell us we did the wrong thing there :) But feel free to implement what
you suggested above.

One thing I'm not sure of is if anyone uses the early AMD chiplet CPUs=20
in a NUMA-per-chiplet mode? IIRC they had a mode like that. And that'd
potentially be problematic if we wanted to divide by number of nodes.
Maybe not as much if just dividing by 2.

> Another thing: this patch series appears in patchwork with state
> "Changes Requested", but no changes have been requested, actually. Can
> the state be changed so it has more visibility to get reviews?

I think resend would be best.
