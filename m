Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F021EC006
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 18:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgFBQav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 12:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgFBQav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 12:30:51 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85261C05BD1E;
        Tue,  2 Jun 2020 09:30:50 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jg9oO-0021bx-FW; Tue, 02 Jun 2020 16:30:48 +0000
Date:   Tue, 2 Jun 2020 17:30:48 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200602163048.GL23230@ZenIV.linux.org.uk>
References: <20200602084257.134555-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602084257.134555-1-mst@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 04:45:05AM -0400, Michael S. Tsirkin wrote:
> So vhost needs to poke at userspace *a lot* in a quick succession.  It
> is thus benefitial to enable userspace access, do our thing, then
> disable. Except access_ok has already been pre-validated with all the
> relevant nospec checks, so we don't need that.  Add an API to allow
> userspace access after access_ok and barrier_nospec are done.

This is the wrong way to do it, and this API is certain to be abused
elsewhere.  NAK - we need to sort out vhost-related problems, but
this is not an acceptable solution.  Sorry.
