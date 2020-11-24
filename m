Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB70C2C31BA
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 21:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbgKXUJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 15:09:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:51310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726433AbgKXUJB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 15:09:01 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF86C2067D;
        Tue, 24 Nov 2020 20:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606248541;
        bh=xRlZ6dmBUu08TU3vy5/5TLMN9Zw/P7z3PuKFEkz4xo4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wval/qzPSXW6OSsfuN6Xd41KgrSoPNwlRmo39HOyYBB9ZoczERldwsjycKv49ubUu
         mPZmEFLfEppIKPijPbMRNPPr91Guf0HgQ/D4LdgrxWq9oeXujMY43N3We47xhiQuRX
         bFPUmZuI8ZHE//FIi2wpDKDtXJTXHkfXL1ZiOAm8=
Date:   Tue, 24 Nov 2020 12:08:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 00/17] rxrpc: Prelude to gssapi support
Message-ID: <20201124120859.10037dd6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
References: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 20:10:04 +0000 David Howells wrote:
> Here are some patches that do some reorganisation of the security class
> handling in rxrpc to allow implementation of the RxGK security class that
> will allow AF_RXRPC to use GSSAPI-negotiated tokens and better crypto.  The
> RxGK security class is not included in this patchset.
> 
> It does the following things:
> 
>  (1) Add a keyrings patch to provide the original key description, as
>      provided to add_key(), to the payload preparser so that it can
>      interpret the content on that basis.  Unfortunately, the rxrpc_s key
>      type wasn't written to interpret its payload as anything other than a
>      string of bytes comprising a key, but for RxGK, more information is
>      required as multiple Kerberos enctypes are supported.
> 
>  (2) Remove the rxk5 security class key parsing.  The rxk5 class never got
>      rolled out in OpenAFS and got replaced with rxgk.
> 
>  (3) Support the creation of rxrpc keys with multiple tokens of different
>      types.  If some types are not supported, the ENOPKG error is
>      suppressed if at least one other token's type is supported.
> 
>  (4) Punt the handling of server keys (rxrpc_s type) to the appropriate
>      security class.
> 
>  (5) Organise the security bits in the rxrpc_connection struct into a
>      union to make it easier to override for other classes.
> 
>  (6) Move some bits from core code into rxkad that won't be appropriate to
>      rxgk.

Pulled into net-next, thank you!
