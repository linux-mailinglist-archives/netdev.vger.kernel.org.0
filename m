Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52343186F48
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 16:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732116AbgCPPv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 11:51:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731989AbgCPPvZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 11:51:25 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD4EA2071C;
        Mon, 16 Mar 2020 15:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584373885;
        bh=smYlIIlYR5FV3SifVHQI+MBbv/xwX8LecTo18P0xOfY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ICscU/9IsUDyRnvuS0ebSl0/HD0xCUkCBtlOPvFr6ovjChwH81Gyz6hIPmNAE51dF
         keL5Er7uv/qmx/F85nUGV7zfjwgiFy6ySXiOA807h+MO9hxashewgNyLcmd1RZRc9Z
         udeSSEHS05e0nb4Lp2G7rWBlAMYC7XeU7nMj6F6M=
Date:   Mon, 16 Mar 2020 15:51:19 +0000
From:   Will Deacon <will@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>,
        ardb@kernel.org, davem@davemloft.net, guohanjun@huawei.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        mingo@kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Subject: Re: WARNING: refcount bug in sctp_wfree
Message-ID: <20200316155119.GB13004@willie-the-truck>
References: <00000000000088452f05a07621d2@google.com>
 <000000000000cc985b05a07ce36f@google.com>
 <202003100900.1E2E399@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202003100900.1E2E399@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 09:01:18AM -0700, Kees Cook wrote:
> On Tue, Mar 10, 2020 at 02:39:01AM -0700, syzbot wrote:
> > syzbot has bisected this bug to:
> > 
> > commit fb041bb7c0a918b95c6889fc965cdc4a75b4c0ca
> > Author: Will Deacon <will@kernel.org>
> > Date:   Thu Nov 21 11:59:00 2019 +0000
> > 
> >     locking/refcount: Consolidate implementations of refcount_t
> 
> I suspect this is just bisecting to here because it made the refcount
> checks more strict?

Yes, this is the commit that enables full refcount checking for all
architectures unconditionally, so it's the canary in the coalmine rather
than the source of the problem.

Will
