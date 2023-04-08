Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5726DB7E7
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 03:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjDHBBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 21:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDHBBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 21:01:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAF2E1BB;
        Fri,  7 Apr 2023 18:01:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 060A56541E;
        Sat,  8 Apr 2023 01:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7AFC4339B;
        Sat,  8 Apr 2023 01:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680915710;
        bh=gcSlr0CIOmJ02VidgdW32DQyhRayuccBI+i0cNpKHis=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gBCPer/ess3XRcujoGPcuezud/xtWezbBNdpdyfAn6mrD2z2blA2PFPhfUgWC3IK+
         IXPlzbOs3j3Pavor5adn0jSmofxhNCbZB7mlwvmb7Ryu0cixxiD/nJKaVEhC1tONE7
         zGe3Wx2IhamnpzYVFHJBAE5DXR5Kez2dOYsFBkPgALFW8cXsci2LydKyLvzCvRvyvp
         HTKe7vzVPpNz/+hEZCzb5CKi5VQI6fihLzQhdH+iC24LYAjCKJfaA5u0ZPUntEuCeB
         pskv7vxlbOCyyKcSRZB97PZf7cnOrhRVme7ByuBOvnNY7mskaunxMqmGUqm0UxQ7nF
         WcUBI5Ldpdznw==
Date:   Fri, 7 Apr 2023 18:01:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v4 net-next 6/9] net/sched: mqprio: allow per-TC user
 input of FP adminStatus
Message-ID: <20230407180148.281307c3@kernel.org>
In-Reply-To: <20230407215252.x3lwkhfp4u6vptxl@skbuf>
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
        <20230403103440.2895683-7-vladimir.oltean@nxp.com>
        <CAM0EoMn9iwTBUW-OaK2sDtTS-PO2_nGLuvGmrqY5n8HYEdt7XQ@mail.gmail.com>
        <20230407164103.vstxn2fmswno3ker@skbuf>
        <CAM0EoM=go4RNohHpt6Z9wFk0AU81gJY3puBTUOC6F0xMocJouQ@mail.gmail.com>
        <20230407193056.3rklegrgmn2yecuu@skbuf>
        <CAM0EoM=miaB=xjp1vyPSfxLO3dBmBq4Loo7Mb=RZ5KuxHrwQaA@mail.gmail.com>
        <20230407215252.x3lwkhfp4u6vptxl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 8 Apr 2023 00:52:52 +0300 Vladimir Oltean wrote:
> On Fri, Apr 07, 2023 at 05:40:20PM -0400, Jamal Hadi Salim wrote:
> > Yes, it is minor (and usually minor things generate the most emails;->).
> > I may be misunderstanding what you mean by "doesnt justify exporting
> > something to UAPI"  - those definitions are part of uapi and are
> > already being exported.  
> 
> In my proposed patch set there isn't any TC_FP_MAX. I'm saying it
> doesn't help user space, and so, it just pollutes the name space of C
> programs with no good reason.

+1  we tend to sprinkle MAX and UNSPEC into every enum

> > No, no, it is a matter of taste and opinion. You may have noticed,
> > trivial stuff like this gets the most comments and reviews normally(we
> > just spent like 4-5 emails on this?). Poteto/potato: IOW, if i was to
> > do it i would have used a u16 or u32 because i feel it would be more
> > readable. I would have used NLA_U8 because i felt it is more fitting
> > and i would have used a max value because it would save me one line in
> > a patch in the future. I think weve spent enough electrons on this - I
> > defer to you.  
> 
> Ok, I won't change preemptible_tcs from unsigned long to u32.
> Things like for_each_set_bit() take unsigned long, and so, I got used
> to using that consistently for small bitfield types.
> 
> If there's a second opinion stating that I should prefer the smallest
> netlink attribute type that fits the estimated data, then I'll transition
> from NLA_U32 to NLA_U8. Otherwise, I won't :) since I would need to
> change iproute2 too, and I'd have to re-test more thoroughly to make
> sure I don't introduce stupid bugs.

And here also agreed. We should have a patchwork check for new uses of
NLA_*{8,16} if you ask me :S  NLA_FLAG or NLA_U32, anything in between
needs a strong justification.  Until Alex L posts the variable size
ints, then NLA_FLAG or NLA_UINT ;)
