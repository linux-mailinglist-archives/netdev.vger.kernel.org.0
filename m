Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 318B7609C6F
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 10:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiJXI0h convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 24 Oct 2022 04:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiJXI03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 04:26:29 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6232AE27
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 01:25:05 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-XRnOUDHJMp-kWfrPAMZqzQ-1; Mon, 24 Oct 2022 04:25:01 -0400
X-MC-Unique: XRnOUDHJMp-kWfrPAMZqzQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1E64811E67;
        Mon, 24 Oct 2022 08:25:00 +0000 (UTC)
Received: from hog (unknown [10.39.192.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E834053AA;
        Mon, 24 Oct 2022 08:24:59 +0000 (UTC)
Date:   Mon, 24 Oct 2022 10:24:28 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: Re: [PATCH net 0/5] macsec: offload-related fixes
Message-ID: <Y1ZLvNE3W9Ph+qqJ@hog>
References: <cover.1665416630.git.sd@queasysnail.net>
 <Y0j+E+n/RggT05km@unreal>
 <Y0kTMXzY3l4ncegR@hog>
 <Y0lCHaGTQjsNvzVN@unreal>
 <166575623691.3451.2587099917911763555@kwain>
 <Y05HeGnTKBY0RVI4@unreal>
 <Y1FTFOsZxELhvWT4@hog>
 <Y1Ty2LlrdrhVvLYA@unreal>
MIME-Version: 1.0
In-Reply-To: <Y1Ty2LlrdrhVvLYA@unreal>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

2022-10-23, 10:52:56 +0300, Leon Romanovsky wrote:
> On Thu, Oct 20, 2022 at 03:54:28PM +0200, Sabrina Dubroca wrote:
> > 2022-10-18, 09:28:08 +0300, Leon Romanovsky wrote:
> > > On Fri, Oct 14, 2022 at 04:03:56PM +0200, Antoine Tenart wrote:
> > > > Quoting Leon Romanovsky (2022-10-14 13:03:57)
> > > > > On Fri, Oct 14, 2022 at 09:43:45AM +0200, Sabrina Dubroca wrote:
> > > > > > 2022-10-14, 09:13:39 +0300, Leon Romanovsky wrote:
> > > > > > > On Thu, Oct 13, 2022 at 04:15:38PM +0200, Sabrina Dubroca wrote:
> 
> <...>
> 
> > > > - With the revert: IPsec and MACsec can be offloaded to the lower dev.
> > > >   Some features might not propagate to the MACsec dev, which won't allow
> > > >   some performance optimizations in the MACsec data path.
> > > 
> > > My concern is related to this sentence: "it's not possible to offload macsec
> > > to lower devices that also support ipsec offload", because our devices support
> > > both macsec and IPsec offloads at the same time.
> > > 
> > > I don't want to see anything (even in commit messages) that assumes that IPsec
> > > offload doesn't exist.
> > 
> > I don't understand what you're saying here. Patch #1 from this series
> > is exactly about the macsec device acknowledging that ipsec offload
> > exists. The rest of the patches is strictly macsec stuff and says
> > nothing about ipsec. Can you point out where, in this series, I'm
> > claiming that ipsec offload doesn't exist?
> 
> All this conversation is about one sentence, which I cited above - "it's not possible
> to offload macsec to lower devices that also support ipsec offload". From the comments,
> I think that you wanted to say "macsec offload is not working due to performance
> optimization, where IPsec offload feature flag was exposed from lower device." Did I get
> it correctly, now?

Yes. "In the current state" (that I wrote in front of the sentence you
quoted) refers to the changes introduced by commit c850240b6c41. The
details are present in the commit message for patch 1.

Do you object to the revert, if I rephrase the justification, and then
re-add the features that make sense in net-next?

-- 
Sabrina

