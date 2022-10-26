Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA83D60E3F8
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 17:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234354AbiJZPBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 11:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJZPBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 11:01:15 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2047F101CF;
        Wed, 26 Oct 2022 08:01:12 -0700 (PDT)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id C601A11DDB;
        Wed, 26 Oct 2022 18:01:11 +0300 (EEST)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 9092211DDA;
        Wed, 26 Oct 2022 18:01:10 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 654093C07E1;
        Wed, 26 Oct 2022 18:01:10 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 29QF19DQ097559;
        Wed, 26 Oct 2022 18:01:09 +0300
Date:   Wed, 26 Oct 2022 18:01:09 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Simon Horman <horms@verge.net.au>, stable@vger.kernel.org
Subject: Re: [PATCH] ipvs: use explicitly signed chars
In-Reply-To: <Y1lEebYfRwrtliDL@zx2c4.com>
Message-ID: <bb93406f-6935-deee-22e4-c4b4be55bc60@ssi.bg>
References: <20221026123216.1575440-1-Jason@zx2c4.com> <4cc36ff5-46fd-c2b3-3292-d6369337fec1@ssi.bg> <Y1lEebYfRwrtliDL@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Wed, 26 Oct 2022, Jason A. Donenfeld wrote:

> On Wed, Oct 26, 2022 at 05:20:03PM +0300, Julian Anastasov wrote:
> > 
> > 	Hello,
> > 
> > On Wed, 26 Oct 2022, Jason A. Donenfeld wrote:
> > 
> > > The `char` type with no explicit sign is sometimes signed and sometimes
> > > unsigned. This code will break on platforms such as arm, where char is
> > > unsigned. So mark it here as explicitly signed, so that the
> > > todrop_counter decrement and subsequent comparison is correct.
> > > 
> > > Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> > > Cc: Julian Anastasov <ja@ssi.bg>
> > > Cc: Simon Horman <horms@verge.net.au>
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > 
> > 	Looks good to me for -next, thanks!
> 
> This is actually net.git material, not net-next.git material,
> considering it fixes a bug on arm and many other archs, and is marked
> with a stable@ tag.

	OK. As algorithm is not SMP safe, the problem is
not just for the first 256 packets on these platforms.

Regards

--
Julian Anastasov <ja@ssi.bg>

