Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7D92454BE
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgHOWmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728262AbgHOWmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 18:42:23 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E37AC061786;
        Sat, 15 Aug 2020 15:42:22 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k74sM-00GVHV-SI; Sat, 15 Aug 2020 22:42:11 +0000
Date:   Sat, 15 Aug 2020 23:42:10 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Pascal Bouchareine <kalou@tfz.net>
Cc:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/2] mm: add GFP mask param to strndup_user
Message-ID: <20200815224210.GA1236603@ZenIV.linux.org.uk>
References: <20200815182344.7469-1-kalou@tfz.net>
 <20200815182344.7469-2-kalou@tfz.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200815182344.7469-2-kalou@tfz.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 15, 2020 at 11:23:43AM -0700, Pascal Bouchareine wrote:
> Let caller specify allocation.
> Preserve existing calls with GFP_USER.

Bloody bad idea, unless you slap a BUG_ON(flags & GFP_ATOMIC) on it,
to make sure nobody tries _that_.  Note that copying from userland
is an inherently blocking operation, and this interface invites
just that.

What do you need that flag for, anyway?
