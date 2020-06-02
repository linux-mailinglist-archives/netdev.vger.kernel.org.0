Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA3A1EC153
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 19:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgFBRqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 13:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgFBRqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 13:46:32 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A16C05BD1E;
        Tue,  2 Jun 2020 10:46:31 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jgAzX-0023OX-8D; Tue, 02 Jun 2020 17:46:23 +0000
Date:   Tue, 2 Jun 2020 18:46:23 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200602174623.GO23230@ZenIV.linux.org.uk>
References: <20200602084257.134555-1-mst@redhat.com>
 <fc204429-7a6e-8214-a66f-bf2676018aae@redhat.com>
 <20200602163306.GM23230@ZenIV.linux.org.uk>
 <CAHk-=wjgg0bpD0qjYF=twJNXmRXYPjXqO1EFLL-mS8qUphe0AQ@mail.gmail.com>
 <20200602174430.GN23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602174430.GN23230@ZenIV.linux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 06:44:30PM +0100, Al Viro wrote:
> On Tue, Jun 02, 2020 at 10:18:09AM -0700, Linus Torvalds wrote:
> 
> 
> > You have exactly two cases:
> > 
> >  (a) the access_ok() would be right above the code and can't be missed
> > 
> >  (b) not
> 
>    (c) what you really want is not quite access_ok().
> 
> Again, that "not quite access_ok()" should be right next to STAC, and
> come from the same primitive - I'm not saying the current model is
> anywhere near sane.  We need a range-checking primitive right next
> to memory access; it's just that for KVM and vhost we might want
> a different check and, for things like s390 and sparc (mips as well,

things like vhost on s390 and sparc, that is.

> in some configs), potentially different part that would do the memory
> access itself as well.

