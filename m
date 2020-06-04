Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7263C1EE71D
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 16:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgFDO7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 10:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729082AbgFDO7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 10:59:32 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61B6C08C5C0;
        Thu,  4 Jun 2020 07:59:31 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jgrL2-0033fO-LT; Thu, 04 Jun 2020 14:59:24 +0000
Date:   Thu, 4 Jun 2020 15:59:24 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200604145924.GF23230@ZenIV.linux.org.uk>
References: <20200602084257.134555-1-mst@redhat.com>
 <20200603014815.GR23230@ZenIV.linux.org.uk>
 <20200603011810-mutt-send-email-mst@kernel.org>
 <20200603165205.GU23230@ZenIV.linux.org.uk>
 <ec086f7b-be01-5ffd-6fc3-f865d26b0daf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec086f7b-be01-5ffd-6fc3-f865d26b0daf@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 02:10:27PM +0800, Jason Wang wrote:

> > > get_user(flags, desc->flags)
> > > smp_rmb()
> > > if (flags & VALID)
> > > copy_from_user(&adesc, desc, sizeof adesc);
> > > 
> > > this would be a good candidate I think.
> > Perhaps, once we get stac/clac out of raw_copy_from_user() (coming cycle,
> > probably).  BTW, how large is the structure and how is it aligned?
> 
> 
> Each descriptor is 16 bytes, and 16 bytes aligned.

Won't it be cheaper to grap the entire thing unconditionally?  And what does
that rmb order, while we are at it - won't all coherency work in terms of
entire cachelines anyway?

Confused...
