Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1377580AD9
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 07:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237549AbiGZFg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 01:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiGZFg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 01:36:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193B724BC1;
        Mon, 25 Jul 2022 22:36:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0872B811C3;
        Tue, 26 Jul 2022 05:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6285C341C0;
        Tue, 26 Jul 2022 05:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658813813;
        bh=swMWmdHL2Ht/begBedL2i8axCFmjIsGE43WtSM3VEwc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UFQoBr1ZlYmecGiK08zByV8yHS1PrBIFvHrLq3eaE6ZcIvCrdQshW8q60qhf0ND6A
         5GmUgHLcPaX01nMT8soeeS2qoIQpwXJ2CPw/p45NwN3XrYud2OuBQYfuxVDCVZm0C7
         m6vlnp0yseYGE+GAplwq3wNgwz/hp3edrmuRqooqjsBN4p77LbokNk3XhCx+uNdw1v
         ffsFYXTGYcHjETLEwsapuH20gHCi26g96eiVacrzPwT+XOX1NXUdKi2kfv0wyTXHyL
         +FcIunqL7h6hWyEsaaEphZjzYGmaB3JZJxAKwPBTkTINb48/zDiPXftOwhB1v9trL3
         yNpMCDLt551yg==
Date:   Tue, 26 Jul 2022 08:36:48 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@ziepe.ca,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        linux-rdma@vger.kernel.org,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>
Subject: Re: [PATCH 2/2] RDMA/bnxt_re: Use auxiliary driver interface
Message-ID: <Yt99cG7ZMGe1XhlL@unreal>
References: <20220724231458.93830-1-ajit.khaparde@broadcom.com>
 <20220724231458.93830-3-ajit.khaparde@broadcom.com>
 <Yt6JV0Vs7nSnI8KB@unreal>
 <CACZ4nhvkTtPjrtKnFuxo+m0TJdBB6S3Tdu1sx+UDS2bT3Y2XZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACZ4nhvkTtPjrtKnFuxo+m0TJdBB6S3Tdu1sx+UDS2bT3Y2XZg@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 09:58:30PM -0700, Ajit Khaparde wrote:
> On Mon, Jul 25, 2022 at 5:15 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Sun, Jul 24, 2022 at 04:14:58PM -0700, Ajit Khaparde wrote:
> > > Use auxiliary driver interface for driver load, unload ROCE driver.
> > > The driver does not need to register the interface using the netdev
> > > notifier anymore. Removed the bnxt_re_dev_list which is not needed.
> > > Currently probe, remove and shutdown ops have been implemented for
> > > the auxiliary device.
> > >
> > > BUG: DCSG01157556
> > > Change-Id: Ice54f076c1c4fc26d4ee7e77a5dcd1ca21cf4cd0
> >
> > Please remove the lines above.
> Apologies for missing that.
> 
> >
> > > Signed-off-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
> > > ---
> > >  drivers/infiniband/hw/bnxt_re/bnxt_re.h       |   9 +-
> > >  drivers/infiniband/hw/bnxt_re/main.c          | 405 +++++++-----------
> > >  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  64 ---
> > >  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c |  65 +++
> > >  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |   3 +
> > >  5 files changed, 232 insertions(+), 314 deletions(-)
> >
> > <...>
> >
> > > +static DEFINE_IDA(bnxt_aux_dev_ids);
> > > +
> > >  static int bnxt_register_dev(struct bnxt_en_dev *edev, unsigned int ulp_id,
> > >                            struct bnxt_ulp_ops *ulp_ops, void *handle)
> >
> > I would expect that almost all code in bnxt_ulp.c will go after this change.
> I agree. My plan was to get these QA tested, initial Aux Bus changes
> in this release with a follow on series to clean this up further.
> Does that sound reasonable?

No, please prepare complete series and we will review it.
There is much harder to do it when the change is partial.

Thanks

> Thanks for the feedback.
> 
> Thanks
> Ajit
> 
> >
> > Thanks


