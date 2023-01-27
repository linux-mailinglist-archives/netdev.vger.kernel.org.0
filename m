Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAFD67EC48
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 18:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235122AbjA0RSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 12:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234344AbjA0RSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 12:18:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AA236456
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 09:18:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B73E061D54
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F89C433D2;
        Fri, 27 Jan 2023 17:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674839897;
        bh=2+Eqsg4iAmC/sGpfxRwsyaO6aw/FLQ74Lv6oVyX8STQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TbXCiBAWwhPvVHo2dmi992T09LLpRfAuXBF/x0SD6E79ztg+N99ihFCLJ0OonaXd7
         ZEUoTpDTKoIXCsUxPOIr4qqrHzyh7ADtG2CiW3LbeVfOfY32Nr5m4H6BrQpSBPNfaE
         k2N63SO95UnNjZ+7qBjZ21PWi6P1ZyeiY93lmt9iR45FUG1YwEWAHqKVqPB8Aft3R7
         /xI8ofkjBG7KDbmoOcA10pZWsbFrAugmuwvKpaJbD0Ycrvkb793aidkWQsjGglQk/5
         y2+UtSUtIKzwrxpNqB+MwexgAdDQmoBFqovnpMQ8PU7R68t398C0q6E0MVR5LjROx+
         atYwUWq34rXMg==
Date:   Fri, 27 Jan 2023 09:18:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com,
        deb.chatterjee@intel.com, anjali.singhai@intel.com,
        namrata.limaye@intel.com, khalidm@nvidia.com, tom@sipanda.io,
        pratyush@sipanda.io, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com, stefanc@marvell.com,
        seong.kim@amd.com, mattyk@nvidia.com, dan.daly@intel.com,
        john.andy.fingerhut@intel.com
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
Message-ID: <20230127091815.3e066e43@kernel.org>
In-Reply-To: <CAM0EoMnHcR9jFVtLt+L1FPRY5BK7_NgH3gsOZxQrXzEkaR1HYQ@mail.gmail.com>
References: <20230124170346.316866-1-jhs@mojatatu.com>
        <20230126153022.23bea5f2@kernel.org>
        <CAM0EoMnHcR9jFVtLt+L1FPRY5BK7_NgH3gsOZxQrXzEkaR1HYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Jan 2023 08:33:39 -0500 Jamal Hadi Salim wrote:
> On Thu, Jan 26, 2023 at 6:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 24 Jan 2023 12:03:46 -0500 Jamal Hadi Salim wrote:  
> > > There have been many discussions and meetings since about 2015 in regards to
> > > P4 over TC and now that the market has chosen P4 as the datapath specification
> > > lingua franca  
> >
> > Which market?  
> 
> Network programmability involving hardware  - where at minimal the
> specification of the datapath is in P4 and
> often the implementation is. For samples of specification using P4
> (that are public) see for example MS Azure:
> https://github.com/sonic-net/DASH/tree/main/dash-pipeline

That's an IPU thing?

> If you are a vendor and want to sell a NIC in that space, the spec you
> get is in P4.

s/NIC/IPU/ ?

> Your underlying hardware
> doesnt have to be P4 native, but at minimal the abstraction (as we are
> trying to provide with P4TC) has to be
> able to consume the P4 specification.

P4 is certainly an option, especially for specs, but I haven't seen much
adoption myself.
What's the benefit / use case?

> For implementations where P4 is in use, there are many - some public
> others not, sample space:
> https://cloud.google.com/blog/products/gcp/google-cloud-using-p4runtime-to-build-smart-networks

Hyper-scaler proprietary.

> There are NICs and switches which are P4 native in the market.

Link to docs?

> IOW, there is beacoup $ investment in this space that makes it worth pursuing.

Pursuing $ is good! But the community IMO should maximize
a different function.

> TC is the kernel offload mechanism that has gathered deployment
> experience over many years - hence P4TC.

I don't wanna argue. I thought it'd be more fair towards you if I made
my lack of conviction known, rather than sit quiet and ignore it since
it's just an RFC.
