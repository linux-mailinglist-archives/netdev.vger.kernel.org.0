Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F9E2075F0
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 16:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391232AbgFXOoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 10:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389836AbgFXOoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 10:44:12 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2292C061573;
        Wed, 24 Jun 2020 07:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MmxB8m2YTQX4GpqX+DS37OeRO131e4ndrA9Pl7MwAgc=; b=IOKw7hTcqP1QeelKxku2fGErUp
        y+gPHThYulPLcw9ZipHA3WEiY0WwtrldwMIjz3I7xFlS4UrXh0IrgE+Nr+g3IVn/C5NubV4TtA66n
        mLCdiZe84XJ5gE3144uUmasV1evosCnueCmLRk8e5igFHS/jiN+zd4BOILHYYRSu5tnwTTHYczGNM
        1jNp5/TmBH3r+Cd233b/d63zVr4Nez7dPM6LjZYPehQuohr79GeKnvEyrBvDcVSHQMeCupwKnSb4b
        k2SF0UgTWsWjSf1WxnC6wYcLs8KKkTGGpdaa+3jajs+y6awdDlv2/jH3uD+C53erVvC46axMeuEel
        iaiP6SWQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jo6cJ-0001Xw-5j; Wed, 24 Jun 2020 14:43:11 +0000
Date:   Wed, 24 Jun 2020 15:43:11 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     mcgrof@kernel.org, ast@kernel.org, axboe@kernel.dk,
        bfields@fieldses.org, bridge@lists.linux-foundation.org,
        chainsaw@gentoo.org, christian.brauner@ubuntu.com,
        chuck.lever@oracle.com, davem@davemloft.net, dhowells@redhat.com,
        gregkh@linuxfoundation.org, jarkko.sakkinen@linux.intel.com,
        jmorris@namei.org, josh@joshtriplett.org, keescook@chromium.org,
        keyrings@vger.kernel.org, kuba@kernel.org,
        lars.ellenberg@linbit.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, nikolay@cumulusnetworks.com,
        philipp.reisner@linbit.com, ravenexp@gmail.com,
        roopa@cumulusnetworks.com, serge@hallyn.com, slyfox@gentoo.org,
        viro@zeniv.linux.org.uk, yangtiezhu@loongson.cn,
        netdev@vger.kernel.org, markward@linux.ibm.com,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: linux-next: umh: fix processed error when UMH_WAIT_PROC is used
 seems to break linux bridge on s390x (bisected)
Message-ID: <20200624144311.GA5839@infradead.org>
References: <20200610154923.27510-5-mcgrof@kernel.org>
 <20200623141157.5409-1-borntraeger@de.ibm.com>
 <b7d658b9-606a-feb1-61f9-b58e3420d711@de.ibm.com>
 <3118dc0d-a3af-9337-c897-2380062a8644@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3118dc0d-a3af-9337-c897-2380062a8644@de.ibm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 01:11:54PM +0200, Christian Borntraeger wrote:
> Does anyone have an idea why "umh: fix processed error when UMH_WAIT_PROC is used" breaks the
> linux-bridge on s390?

Are we even sure this is s390 specific and doesn't happen on other
architectures with the same bridge setup?
