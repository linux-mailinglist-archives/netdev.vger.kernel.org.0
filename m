Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4457E51020F
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 17:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245409AbiDZPlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 11:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343792AbiDZPlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 11:41:52 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEB45AA62;
        Tue, 26 Apr 2022 08:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=fj9TPZPeaJ77hv7VnUDtPRvcWeH3nXnlDCA0r5MVNDQ=; b=fYGzlnHRfohR0LgdCqIxKi6XB+
        sXWizY+2kwiDVxGyfR9tf1NNEwFuxDDVKb/tnxWUVNOP3Iq8MjzMo4+E3KzgL04Sp7+65OF3L3siu
        riide0hOA1paUQpUC01oD5Imje2rYcpN8U+r/mcuobLPEFPymfeE9XGkCWwHDwpMXASZO1454oOov
        bgj1jpmihJNELx8L10AnLflNJ3cqmdD1gZN5xQPxWyiBX9Cu7M//u1eDiQyYIR+hwloWd8yxHYXc7
        iTYnWSrVgKQOv4nOS4vrLWZapThmInl3RFaith8laO3E3rHhDVeLUjIf2qEYeHfbqJqcIbXn1BllL
        J4cdBWFiPtpoUrEhtICMIOGhHZeNdbYwMWS9UV9FNDyucUxUTgZ7QJveU2zoe7kr/ReEk9hfGiwl4
        WZ/9Xql5IBavt3ILNBhTzaiOTqslV9+VbArcK5qO6DYg+YewBiWPdml+uZWgkfaPVXb9RTPm0mRWx
        B3OFRY5AZ6IkuhkgXGxb89Cps4KYIlW96DSLfXePm7a3hEE+bUXWe8AKXQVgaXszOGwaVnSUGrcrw
        ZEAxRR/Z9mizubTC9f59aHi3zaupBPwr3Sfb0FracV0Qr4y3CTn4mp5Nztw5Yy3vPbbGIF7zTlInT
        hYLl47/2IfeVQ5wDdBnweVyGEschux4btBdqBzrrA=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     David Howells <dhowells@redhat.com>
Cc:     asmadeus@codewreck.org, David Kahurani <k.kahurani@gmail.com>,
        davem@davemloft.net, ericvh@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        Greg Kurz <groug@kaod.org>
Subject: Re: 9p EBADF with cache enabled (Was: 9p fs-cache tests/benchmark (was: 9p
 fscache Duplicate cookie detected))
Date:   Tue, 26 Apr 2022 17:38:30 +0200
Message-ID: <1817722.O6u07f4CCs@silver>
In-Reply-To: <3174158.1650895816@warthog.procyon.org.uk>
References: <YmKp68xvZEjBFell@codewreck.org> <1817268.LulUJvKFVv@silver>
 <3174158.1650895816@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Montag, 25. April 2022 16:10:16 CEST David Howells wrote:
> There may be a quick and dirty workaround.  I think the problem is that
> unless the O_APPEND read starts at the beginning of a page, netfs is going
> to enforce a read.  Does the attached patch fix the problem?  (note that
> it's untested)

Patch doesn't apply for me on master:

checking file fs/9p/vfs_addr.c
Hunk #1 FAILED at 291.
1 out of 1 hunk FAILED
checking file fs/netfs/buffered_read.c
Hunk #1 FAILED at 364.
1 out of 1 hunk FAILED
checking file fs/netfs/internal.h
checking file fs/netfs/stats.c
Hunk #2 FAILED at 38.
1 out of 2 hunks FAILED

commit d615b5416f8a1afeb82d13b238f8152c572d59c0 (HEAD -> master, origin/master, origin/HEAD)
Merge: 0fc74d820a01 4d8ec9120819
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Apr 25 10:53:56 2022 -0700

What was is based on?

> Also, can you get the contents of /proc/fs/fscache/stats from after
> reproducing the problem?

FS-Cache statistics
Cookies: n=684 v=1 vcol=0 voom=0
Acquire: n=689 ok=689 oom=0
LRU    : n=0 exp=0 rmv=0 drp=0 at=0
Invals : n=0
Updates: n=2095 rsz=0 rsn=0
Relinqs: n=5 rtr=0 drop=5
NoSpace: nwr=0 ncr=0 cull=0
IO     : rd=0 wr=0
RdHelp : RA=974 RP=0 WB=13323 WBZ=2072 rr=0 sr=0
RdHelp : ZR=13854 sh=0 sk=2072
RdHelp : DL=14297 ds=14297 df=13322 di=0
RdHelp : RD=0 rs=0 rf=0
RdHelp : WR=0 ws=0 wf=0

Best regards,
Christian Schoenebeck


