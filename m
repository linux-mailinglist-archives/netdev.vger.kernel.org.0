Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8D75E6C87
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 22:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbiIVUAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 16:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbiIVUAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 16:00:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C963410D65D;
        Thu, 22 Sep 2022 12:59:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0562D6115C;
        Thu, 22 Sep 2022 19:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93D5C433D6;
        Thu, 22 Sep 2022 19:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663876750;
        bh=8JkOYZR01lEo18px3jH97GFzQcOf/gCjHG8IRSVX1fU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XqD4FqSFIjqiAe81OoGf1PfmzuoB+cr3bVp1YYPbi5L7/NcHt9anCQ67kDQQCCJ0O
         ryrAXvo7W1bx18KmSkfb49iKDOjlxsUJ2MKc2l/see7ALYK2Oikc7CNnrZyUdcIpQr
         eu5wEeYyzJ9PquSp/IiVSpHz4za5WmoKO1q4Zd2adv8bA2kv9+hqHLOaXp5EeHSMMR
         BQFAgqM8xIv7SXj6A8Ff/aTfCCYLpqbBnRhFRPsBXU0H8GARpX9yraG3KX9mDd6YEy
         15V9wdyQCzgn70Hg+aD8dg88ZYT/R18FrRnh/wh1eAxJ388FbYhffAck14JVroy3gT
         kqy3+K9synnAg==
Date:   Thu, 22 Sep 2022 12:59:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Benjamin Poirier <bpoirier@nvidia.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        MPTCP Upstream <mptcp@lists.linux.dev>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220922125908.28efd4b4@kernel.org>
In-Reply-To: <2b4722a2-04cd-5e8f-ee09-c01c55aee7a7@tessares.net>
References: <20220921110437.5b7dbd82@canb.auug.org.au>
        <2b4722a2-04cd-5e8f-ee09-c01c55aee7a7@tessares.net>
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

On Wed, 21 Sep 2022 11:18:17 +0200 Matthieu Baerts wrote:
> Hi Stephen,
> 
> On 21/09/2022 03:04, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next merge of the net-next tree got a conflict in:
> > 
> >   tools/testing/selftests/drivers/net/bonding/Makefile
> > 
> > between commit:
> > 
> >   bbb774d921e2 ("net: Add tests for bonding and team address list management")
> > 
> > from the net tree and commit:
> > 
> >   152e8ec77640 ("selftests/bonding: add a test for bonding lladdr target")
> > 
> > from the net-next tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary.  
> Thank you for sharing this fix (and all the others!).
> 
> I also had this conflict on my side[1] and I resolved it differently,
> more like what is done in the -net tree I think, please see the patch
> attached to this email.
> 
> I guess I should probably use your version. It is just I saw it after
> having resolved the conflict on my side :)
> I will check later how the network maintainers will resolve this
> conflict and update my tree if needed.

I took this opportunity to sort 'em:

- TEST_PROGS := bond-break-lacpdu-tx.sh
- TEST_PROGS += bond-lladdr-target.sh
 -TEST_PROGS := bond-break-lacpdu-tx.sh \
 -            dev_addr_lists.sh \
 -            bond-arp-interval-causes-panic.sh
++TEST_PROGS := \
++      bond-arp-interval-causes-panic.sh \
++      bond-break-lacpdu-tx.sh \
++      dev_addr_lists.sh
+ 
+ TEST_FILES := lag_lib.sh

Here's to hoping there are no more bond selftests before final..
