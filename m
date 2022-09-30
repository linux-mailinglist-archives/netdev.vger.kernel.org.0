Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575775F0EB4
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 17:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiI3PVA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 30 Sep 2022 11:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiI3PU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 11:20:59 -0400
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4401711D605;
        Fri, 30 Sep 2022 08:20:56 -0700 (PDT)
Received: from omf08.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay10.hostedemail.com (Postfix) with ESMTP id CE709C064E;
        Fri, 30 Sep 2022 15:20:54 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf08.hostedemail.com (Postfix) with ESMTPA id 7554720029;
        Fri, 30 Sep 2022 15:20:48 +0000 (UTC)
Message-ID: <e9a52823ea98a0e4a23c38e83d7872faed8c1d6c.camel@perches.com>
Subject: Re: [PATCH] net: prestera: acl: Add check for kmemdup
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     pabeni@redhat.com, davem@davemloft.net, tchornyi@marvell.com,
        edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Volodymyr Mytnyk <vmytnyk@marvell.com>
Date:   Fri, 30 Sep 2022 08:20:47 -0700
In-Reply-To: <20220930072952.2d337b3a@kernel.org>
References: <20220930050317.32706-1-jiasheng@iscas.ac.cn>
         <20220930072952.2d337b3a@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Stat-Signature: 94yo7dddwnorg3saaa4etcwumhedqht4
X-Rspamd-Server: rspamout06
X-Rspamd-Queue-Id: 7554720029
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        KHOP_HELO_FCRDNS,SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18fCQZXNZYWzufsmUpi5ZRVblyBKPoVJXA=
X-HE-Tag: 1664551248-829077
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-09-30 at 07:29 -0700, Jakub Kicinski wrote:
> On Fri, 30 Sep 2022 13:03:17 +0800 Jiasheng Jiang wrote:
> > Actually, I used get_maintainer scripts and the results is as follow:
> > "./scripts/get_maintainer.pl -f drivers/net/ethernet/marvell/prestera/prestera_acl.c"
> > Taras Chornyi <tchornyi@marvell.com> (supporter:MARVELL PRESTERA ETHERNET SWITCH DRIVER)
> > "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING DRIVERS)
> > Eric Dumazet <edumazet@google.com> (maintainer:NETWORKING DRIVERS)
> > Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING DRIVERS)
> > Paolo Abeni <pabeni@redhat.com> (maintainer:NETWORKING DRIVERS)
> > netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
> > linux-kernel@vger.kernel.org (open list)
> > 
> > Therefore, I submitted my patch to the above addresses.
> > 
> > And this time I checked the fixes commit, and found that it has two
> > authors:
> > Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>

IMO: If Volodymyr wants to be a maintainer here, he should put
his email as an entry in the MAINTAINERS file for the subsystem.

> > Maybe there is a problem of the script that misses one.

I don't think so.  Maybe you have more evidence...

> > Anyway, I have already submitted the same patch and added
> > "vmytnyk@marvell.com" this time.
> 
> Ha! So you do indeed use it in a way I wasn't expecting :S
> Thanks for the explanation.
> 
> Joe, would you be okay to add a "big fat warning" to get_maintainer
> when people try to use the -f flag?

No, not really.  -f isn't required when the file is in git anyway.

> Maybe we can also change the message
> that's displayed when the script is run without arguments to not
> mention -f?

I think that's a poor idea as frequently the script isn't used
on patches but simply to identify the maintainers of a particular
file or subsystem.

> We're getting quite a few fixes which don't CC author, I'm guessing
> Jiasheng's approach may be a common one.

There's no great way to identify "author" or "original submitter"
and frequently the "original submitter" isn't a maintainer anyway.

