Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E07DD31FE8
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 18:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfFAQUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 12:20:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbfFAQUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 12:20:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C05842768D;
        Sat,  1 Jun 2019 16:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559406009;
        bh=kunCWeTycOmy9TLLHVnQa/oWK5UyHy4K/bFS9zHk1Qw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l+cjig3LN5W1sHK1uM8ZUZgjejYsqVrhCI47kldCOZZi8iTRMAKj0qvMAiLDDfs1Z
         V4YnNmUoxij7X1AFo5ewCqGtePYxWHXdpoozR8fMFN0Rh5efOUqVhlzEXJud+kOrIR
         jExiLyHfh1MngKgEKISRBjws3IxX0sZ5r6BkYk1c=
Date:   Sat, 1 Jun 2019 02:32:44 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Lorenzo Colitti <lorenzo@google.com>, astrachan@google.com,
        liuhangbin@gmail.com, Linux NetDev <netdev@vger.kernel.org>,
        mateusz.bajorski@nokia.com, dsa@cumulusnetworks.com
Subject: Re: [PATCH net] fib_rules: return 0 directly if an exactly same rule
 exists when NLM_F_EXCL not supplied
Message-ID: <20190601093244.GB1783@kroah.com>
References: <20190507091118.24324-1-liuhangbin@gmail.com>
 <20190508.093541.1274244477886053907.davem@davemloft.net>
 <CAHo-OozeC3o9avh5kgKpXq1koRH0fVtNRaM9mb=vduYRNX0T7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHo-OozeC3o9avh5kgKpXq1koRH0fVtNRaM9mb=vduYRNX0T7g@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 06:43:42PM -0700, Maciej Żenczykowski wrote:
> FYI, this userspace visible change in behaviour breaks Android.
> 
> We rely on being able to add a rule and either have a dup be created
> (in which case we'll remove it later) or have it fail with EEXIST (in
> which case we won't remove it later).
> 
> Returning 0 makes atomically changing a rule difficult.
> 
> Please revert.

That's crazy, but makes sense in an odd way :)

And it explains why my "fix up of the patch" also breaks things, both
patches need to be reverted in the stable trees.  Do you need me to make
a patch to revert this in Linus's tree now, or can you do that?  Just
asking for an existing commit to be reverted is usually a bit harder as
that's not most maintainer's workflow (I know it's not mine.)

thanks,

gre gk-h
