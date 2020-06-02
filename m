Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14D31EC14A
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 19:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgFBRoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 13:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgFBRoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 13:44:37 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FA6C05BD1E;
        Tue,  2 Jun 2020 10:44:36 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jgAxi-0023MS-U1; Tue, 02 Jun 2020 17:44:31 +0000
Date:   Tue, 2 Jun 2020 18:44:30 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200602174430.GN23230@ZenIV.linux.org.uk>
References: <20200602084257.134555-1-mst@redhat.com>
 <fc204429-7a6e-8214-a66f-bf2676018aae@redhat.com>
 <20200602163306.GM23230@ZenIV.linux.org.uk>
 <CAHk-=wjgg0bpD0qjYF=twJNXmRXYPjXqO1EFLL-mS8qUphe0AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjgg0bpD0qjYF=twJNXmRXYPjXqO1EFLL-mS8qUphe0AQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 10:18:09AM -0700, Linus Torvalds wrote:


> You have exactly two cases:
> 
>  (a) the access_ok() would be right above the code and can't be missed
> 
>  (b) not

   (c) what you really want is not quite access_ok().

Again, that "not quite access_ok()" should be right next to STAC, and
come from the same primitive - I'm not saying the current model is
anywhere near sane.  We need a range-checking primitive right next
to memory access; it's just that for KVM and vhost we might want
a different check and, for things like s390 and sparc (mips as well,
in some configs), potentially different part that would do the memory
access itself as well.
