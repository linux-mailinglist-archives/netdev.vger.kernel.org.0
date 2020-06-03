Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FB71EC83B
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 06:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgFCESz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 00:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgFCESz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 00:18:55 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FE9C05BD43;
        Tue,  2 Jun 2020 21:18:54 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jgKrZ-002J2w-RW; Wed, 03 Jun 2020 04:18:49 +0000
Date:   Wed, 3 Jun 2020 05:18:49 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200603041849.GT23230@ZenIV.linux.org.uk>
References: <20200602084257.134555-1-mst@redhat.com>
 <20200603014815.GR23230@ZenIV.linux.org.uk>
 <3358ae96-abb6-6be9-346a-0e971cb84dcd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3358ae96-abb6-6be9-346a-0e971cb84dcd@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 11:57:11AM +0800, Jason Wang wrote:

> > How widely do you hope to stretch the user_access areas, anyway?
> 
> 
> To have best performance for small packets like 64B, if possible, we want to
> disable STAC not only for the metadata access done by vhost accessors but
> also the data access via iov iterator.

If you want to try and convince Linus to go for that, make sure to Cc
me on that thread.  Always liked quality flame...

The same goes for interval tree lookups with uaccess allowed.  IOW, I _really_
doubt that it's a good idea.

> > Incidentally, who had come up with the name __vhost_get_user?
> > Makes for lovey WTF moment for readers - esp. in vhost_put_user()...
> 
> 
> I think the confusion comes since it does not accept userspace pointer (when
> IOTLB is enabled).
> 
> How about renaming it as vhost_read()/vhost_write() ?

Huh?

__vhost_get_user() is IOTLB remapping of userland pointer.  It does not access
userland memory.  Neither for read, nor for write.  It is used by vhost_get_user()
and vhost_put_user().

Why would you want to rename it into vhost_read _or_ vhost_write, and in any case,
how do you give one function two names?  IDGI...
