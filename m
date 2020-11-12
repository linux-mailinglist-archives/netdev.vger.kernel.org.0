Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E1F2B0FC4
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 22:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgKLVHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 16:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgKLVHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 16:07:47 -0500
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885E6C0613D1;
        Thu, 12 Nov 2020 13:07:47 -0800 (PST)
Received: by fieldses.org (Postfix, from userid 2815)
        id 28F2D28E4; Thu, 12 Nov 2020 16:07:47 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 28F2D28E4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1605215267;
        bh=7ADdX0CSiasF4CPh88wUEz7Fb0yH1GWaL25j5PRyB7o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UROWECIT8W4Uv8vWUwPsAHSfhNM2y55mR1Et76KqqzAfHqfpBRUsxvCsGfkrArd3v
         4bO7sseqU4jYMDHKzAN2vcylEJpKLq0bhGI4/wbdo0yox6hsoyDIxUN6wS3HIvEBSW
         a5dF9pKKRIK7nBGaYNfLVYgZJGvEdXgfkcMqh77M=
Date:   Thu, 12 Nov 2020 16:07:47 -0500
From:   Bruce Fields <bfields@fieldses.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        linux-crypto@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-afs@lists.infradead.org
Subject: Re: [RFC][PATCH 00/18] crypto: Add generic Kerberos library
Message-ID: <20201112210747.GK9243@fieldses.org>
References: <22138FE2-9E79-4E24-99FC-74A35651B0C1@oracle.com>
 <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com>
 <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
 <2380561.1605195776@warthog.procyon.org.uk>
 <2422487.1605200046@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2422487.1605200046@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 04:54:06PM +0000, David Howells wrote:
> Chuck Lever <chuck.lever@oracle.com> wrote:
> 
> > Really? My understanding of the Linux kernel SUNRPC implementation is
> > that it uses asynchronous, even for small data items. Maybe I'm using
> > the terminology incorrectly.
> 
> Seems to be synchronous, at least in its use of skcipher:

Yes, it's all synchronous.  The only cases where we defer and revisit a
request is when we need to do upcalls to userspace.

(And those upcalls mostly come after we're done with unwrapping and
verifying a request, so now I'm sort of curious exactly what Chuck was
seeing.)

--b.
