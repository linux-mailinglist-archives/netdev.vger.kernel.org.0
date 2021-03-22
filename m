Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F393446E9
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 15:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhCVOQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 10:16:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhCVOQG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 10:16:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5343F6196C;
        Mon, 22 Mar 2021 14:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616422566;
        bh=1fKgyeYVl0YYfrA/uXu1vWP9qkb3DsOxrdvd8EqUZ8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LgMtFZ+reDWcLnsq8NzV6JvsNSwKyMPT0ayuq4Wrov0chkbVm4noZX6f4GxbZ7NpS
         njkjBsFUBd+3NA3I1ISMznkpAvFZdbSmIdyT05FQjRUnSVYEVJJGNR1M0dPCNMpiXd
         HNYOZqpRBuwm3a5IynPuu2Db5pUcGeGN9ncZ1D2wuunbokvpgmZO6AlUHqudo3pzyI
         HsoBGIJHn+iaxTFYXDejnrmETAFdUupTXkO2RBVqEM+YnX/4Lq1tpsSbRVrgzb0a3Q
         vbbzNlGXDWoDgBuiB7PfXKp+Cxt1HTa7+jVMb2eS1Y28eRBeEiFz4wLnxgX9vwINUD
         bJhV+vGN9WV9Q==
Date:   Mon, 22 Mar 2021 16:16:02 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/2] net: ipa: fix validation
Message-ID: <YFimooGgT1pIRe/G@unreal>
References: <20210320141729.1956732-1-elder@linaro.org>
 <f1b719d3-c7f2-1815-9cfe-19ea23944cce@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1b719d3-c7f2-1815-9cfe-19ea23944cce@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 08:22:20AM -0500, Alex Elder wrote:
> On 3/20/21 9:17 AM, Alex Elder wrote:
> > There is sanity checking code in the IPA driver that's meant to be
> > enabled only during development.  This allows the driver to make
> > certain assumptions, but not have to verify those assumptions are
> > true at (operational) runtime.  This code is built conditional on
> > IPA_VALIDATION, set (if desired) inside the IPA makefile.
> > 
> > Unfortunately, this validation code has some errors.  First, there
> > are some mismatched arguments supplied to some dev_err() calls in
> > ipa_cmd_table_valid() and ipa_cmd_header_valid(), and these are
> > exposed if validation is enabled.  Second, the tag that enables
> > this conditional code isn't used consistently (it's IPA_VALIDATE
> > in some spots and IPA_VALIDATION in others).
> > 
> > This series fixes those two problems with the conditional validation
> > code.
> 
> After much back-and-forth with Leon Romanovsky:
> 
> 	--> I retract this series <--
> 
> I will include these patches in a future series that will
> do cleanup of this validation code more completely.

Thanks a lot.

> 
> Thanks.
> 
> 					-Alex
> 
> > Version 2 removes the two patches that introduced ipa_assert().  It
> > also modifies the description in the first patch so that it mentions
> > the changes made to ipa_cmd_table_valid().
> > 
> > 					-Alex
> > 
> > Alex Elder (2):
> >    net: ipa: fix init header command validation
> >    net: ipa: fix IPA validation
> > 
> >   drivers/net/ipa/Makefile       |  2 +-
> >   drivers/net/ipa/gsi_trans.c    |  8 ++---
> >   drivers/net/ipa/ipa_cmd.c      | 54 ++++++++++++++++++++++------------
> >   drivers/net/ipa/ipa_cmd.h      |  6 ++--
> >   drivers/net/ipa/ipa_endpoint.c |  6 ++--
> >   drivers/net/ipa/ipa_main.c     |  6 ++--
> >   drivers/net/ipa/ipa_mem.c      |  6 ++--
> >   drivers/net/ipa/ipa_table.c    |  6 ++--
> >   drivers/net/ipa/ipa_table.h    |  6 ++--
> >   9 files changed, 58 insertions(+), 42 deletions(-)
> > 
> 
