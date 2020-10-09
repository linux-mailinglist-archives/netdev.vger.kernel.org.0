Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE2E288585
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 10:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732928AbgJIIsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 04:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730726AbgJIIsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 04:48:14 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84542C0613D2;
        Fri,  9 Oct 2020 01:48:14 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQo4R-002AJo-EB; Fri, 09 Oct 2020 10:48:11 +0200
Message-ID: <01fcaf4985f57d97ac03fc0b7deb2c225a2fbca1.camel@sipsolutions.net>
Subject: Re: [CRAZY-RFF] debugfs: track open files and release on remove
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, nstange@suse.de, ap420073@gmail.com,
        David.Laight@aculab.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, rafael@kernel.org
Date:   Fri, 09 Oct 2020 10:48:09 +0200
In-Reply-To: <20201009084729.GA406522@kroah.com>
References: <87v9fkgf4i.fsf@suse.de>
         <20201009095306.0d87c3aa13db.Ib3a7019bff15bb6308f6d259473a1648312a4680@changeid>
         <20201009080355.GA398994@kroah.com>
         <be61c6a38d0f6ca1aa0bc3f0cb45bbb216a12982.camel@sipsolutions.net>
         <20201009081624.GA401030@kroah.com>
         <1ec056cf3ec0953d2d1abaa05e37e89b29c7cc63.camel@sipsolutions.net>
         <20201009084729.GA406522@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-09 at 10:47 +0200, Greg KH wrote:

> > I think adding the .owner everywhere would be good, and perhaps we can
> > somehow put a check somewhere like
> > 
> > 	WARN_ON(is_module_address((unsigned long)fops) && !fops->owner);
> > 
> > to prevent the issue in the future?
> 
> That will fail for all of the debugfs_create_* operations, as there is
> only one set of file operations for all of the different files created
> with these calls.

Why would it fail? Those have their fops in the core debugfs code, which
might have a .owner assigned but is probably built-in anyway?

> Which, now that I remember it, is why we went down the proxy "solution"
> in the first place :(

Not sure I understand. That was related more to (arbitrary) files having
to be disappeared rather than anything else?

johannes

