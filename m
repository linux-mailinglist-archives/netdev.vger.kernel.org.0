Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90EDF433336
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbhJSKKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 06:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234794AbhJSKK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 06:10:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66D6B61027;
        Tue, 19 Oct 2021 10:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634638097;
        bh=v3ZgfjOMlT1nq1dQKvgKBrGgWcQCUILfdrmg6uPmvpY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kRCnsSUTGajo6V3B7idUl0NpnfV69oM4fxLin2YUeCg86JwacGX3KDYE4R8K94ZqR
         Ia2Blf9iSxqouv2XHrq4m8J/OF3EhS+TJcZj7cOMa9zne99dFTxHXenQCH5h/hO/bo
         tKNRcxRWXjGxcgOuZ4zk/pZUFYMwMn59XzxkHBwF6TrP+8NR89iLBvRuxWPiMrUka0
         R8CGDO6zHIHIbXQYxIfe5ksvbV62Ys9Fpt7exeADNG+j4cQPpNgGWHlOL4ChHnA03B
         d++LMS8uRkGUVvA8AquVstS+o2xopnPhPd2188CP3KkmaUoj3Gb60wiexkp0ih37rs
         wz+9N6oNAYMkg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mcm2R-0006k2-Sb; Tue, 19 Oct 2021 12:08:08 +0200
Date:   Tue, 19 Oct 2021 12:08:07 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     syzbot <syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] divide error in usbnet_start_xmit
Message-ID: <YW6ZB6/RePcZJai9@hovoldconsulting.com>
References: <000000000000046acd05ceac1a72@google.com>
 <c5a75b9b-bc2b-2bd8-f57c-833e6ca4c192@suse.com>
 <YW6On2cAm1qLoidn@hovoldconsulting.com>
 <db0817c7-a918-dbb6-d6ca-e69d14d0d134@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db0817c7-a918-dbb6-d6ca-e69d14d0d134@suse.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 12:04:31PM +0200, Oliver Neukum wrote:
> On 19.10.21 11:23, Johan Hovold wrote:
> 
> > Just bail out; what can you do with a 1-byte packet size? Also compare
> > usbnet_get_endpoints() where such endpoints are ignored.
> 
> OK. We'd accept a 1 now, though. Can you think of a sensible lower bound?

You can continue accepting 1 if you want, just reject zero and abort
probe.

Johan
