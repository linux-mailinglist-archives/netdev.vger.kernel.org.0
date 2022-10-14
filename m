Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04AAF5FF085
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 16:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiJNOp1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Oct 2022 10:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiJNOpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 10:45:25 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BD73B477
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 07:45:23 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-LF5WmHK5N2S2w89TmK54Aw-1; Fri, 14 Oct 2022 10:45:20 -0400
X-MC-Unique: LF5WmHK5N2S2w89TmK54Aw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0376038012DD;
        Fri, 14 Oct 2022 14:45:20 +0000 (UTC)
Received: from hog (unknown [10.39.192.237])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8487A1043DDC;
        Fri, 14 Oct 2022 14:45:17 +0000 (UTC)
Date:   Fri, 14 Oct 2022 16:44:52 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: Re: [PATCH net 0/5] macsec: offload-related fixes
Message-ID: <Y0l15J6AVN75k+wO@hog>
References: <cover.1665416630.git.sd@queasysnail.net>
 <Y0j+E+n/RggT05km@unreal>
 <Y0kTMXzY3l4ncegR@hog>
 <Y0lCHaGTQjsNvzVN@unreal>
MIME-Version: 1.0
In-Reply-To: <Y0lCHaGTQjsNvzVN@unreal>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-10-14, 14:03:57 +0300, Leon Romanovsky wrote:
> On Fri, Oct 14, 2022 at 09:43:45AM +0200, Sabrina Dubroca wrote:
> > 2022-10-14, 09:13:39 +0300, Leon Romanovsky wrote:
> > > On Thu, Oct 13, 2022 at 04:15:38PM +0200, Sabrina Dubroca wrote:
> > > > I'm working on a dummy offload for macsec on netdevsim. It just has a
> > > > small SecY and RXSC table so I can trigger failures easily on the
> > > > ndo_* side. It has exposed a couple of issues.
> > > > 
> > > > The first patch will cause some performance degradation, but in the
> > > > current state it's not possible to offload macsec to lower devices
> > > > that also support ipsec offload. 
> > > 
> > > Please don't, IPsec offload is available and undergoing review.
> > > https://lore.kernel.org/netdev/cover.1662295929.git.leonro@nvidia.com/
> > > 
> > > This is whole series (XFRM + driver) for IPsec full offload.
> > > https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=xfrm-next
> > 
> > Yes, and that's not upstream yet. 
> 
> For this conversation, you can assume what that series is merged.
> It is not merged due to request to change how we store XFRM policies
> in XFRM core code.
> 
> > That patchset is also doing nothing to address the issue I'm refering
> > to here, where xfrm_api_check rejects the macsec device because it has
> > the NETIF_F_HW_ESP flag (passed from the lower device) and no xfrmdev_ops.
> 
> Of course, why do you think that IPsec series should address MACsec bugs?

I don't. That's why I really don't understand how the "full offload"
series is relevant for this patchset.

-- 
Sabrina

