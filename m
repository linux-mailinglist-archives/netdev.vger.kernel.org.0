Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3084D0A57
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 22:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242942AbiCGVzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 16:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243959AbiCGVzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 16:55:14 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00227E0A8;
        Mon,  7 Mar 2022 13:54:18 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nRLIy-0000vI-P4; Mon, 07 Mar 2022 22:54:12 +0100
Date:   Mon, 7 Mar 2022 22:54:12 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Tom Rix <trix@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
        kadlec@netfilter.org, davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: conditionally use ct and ctinfo
Message-ID: <20220307215412.GA1822@breakpoint.cc>
References: <20220305180853.696640-1-trix@redhat.com>
 <20220307124652.GB21350@breakpoint.cc>
 <b795685f-6cdb-5493-8280-75749ddb0f6f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b795685f-6cdb-5493-8280-75749ddb0f6f@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom Rix <trix@redhat.com> wrote:
> 
> On 3/7/22 4:46 AM, Florian Westphal wrote:
> > trix@redhat.com <trix@redhat.com> wrote:
> > > From: Tom Rix <trix@redhat.com>
> > > 
> > > The setting ct and ctinfo are controlled by
> > > CONF_NF_CONNTRACK.  So their use should also
> > > be controlled.
> > Any reason for this change?
> 
> Define and use are connected. Doing something to one without doing something
> to the other doesn't make sense.

We often rely on compiler to remove branches that always evaluate to
false, just like in this case.

> Could removing the CONF_NF_CONNTRACK be done for the define side ?

Doubt it.  Looking at git history it avoids build breakage.
