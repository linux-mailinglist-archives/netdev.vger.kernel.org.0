Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCDFC7793F
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 16:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387688AbfG0O23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 10:28:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60712 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfG0O22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 10:28:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uPLxeQEML9BteCF9NpSVLzSpnjjPSerWnrHdU6tpQi8=; b=lcjtjiE/zo1MfKIvCqYD0Rm4A
        Tjo59aKrhmE86YzzffsdiUUQfTbqiBcFrffSCTkmgxa6jgxEtpLRyftKmsp575II0bbBht098KTb9
        zZG9+zfVqT0X8D44G+Uwmqi5RaJeyzhu89KZRByGJkzZbuUoNpilgWdNtBosok0ekLhAWOrJzE30a
        5LVpX8E5mF2+oPPJxGWAQbDWEjv3VrTQfVJSOgkKFPs/r2ewDoYxH4ME+4zQuV84wPBrN1l4iySjb
        U6kD14SVghMiHtFZjPXVH4BKhXrQtcqSXSeUEH/BGAqBxK7JIyIQfhv8cXdxRNjRHpqWQpJrDhGh9
        Es+dW6JBA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hrNgQ-0008Mr-Ht; Sat, 27 Jul 2019 14:28:26 +0000
Date:   Sat, 27 Jul 2019 07:28:26 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, aaro.koskinen@iki.fi,
        arnd@arndb.de
Subject: Re: [PATCH 2/2] staging/octeon: Allow test build on !MIPS
Message-ID: <20190727142826.GA12889@bombadil.infradead.org>
References: <20190726174425.6845-1-willy@infradead.org>
 <20190726174425.6845-3-willy@infradead.org>
 <20190727105706.GB458@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190727105706.GB458@kroah.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 27, 2019 at 12:57:06PM +0200, Greg KH wrote:
> No real objection from me, having this driver able to be built on
> non-mips systems would be great.
> 
> But wow, that stubs.h file is huge, you really need all of that?
> There's no way to include the files from the mips "core" directly
> instead for some of it?

I don't know.  I went the route of copying each structure/enum wholesale
as I came across it in the build log rather than taking only the pieces
of it that I needed.  My time versus a few hundred lines of source?

I think that a more wholesale restructuring of this driver would be
helpful; there are a number of structures that are only used in the
driver and not in the arch code, and those could then be removed from
the stubs file.  But I have no long term investment in this driver;
it just annoyed me to not be able to build it.

> If not, that's fine, and all of this can go through net-next:
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
