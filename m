Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEDF22FA3
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 11:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731625AbfETJEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 05:04:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727301AbfETJEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 05:04:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2691320644;
        Mon, 20 May 2019 09:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558343071;
        bh=1v1nuxcWvVkGGL35WWUJOcGwdr8fXibrkPbcNDFvVL0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NPOwRyQ8bLcCg+3pJW3uPJDmS6TfkstyMWu4M4AsILKZ5dCJOQpzgR72fm0961qvy
         6Jy3L8eYoqKg6hXPwXh5j81CL1iGbTQzL32NPTzcdcCO04U6Qa+pBVeziWzm1OOf4j
         LqSm+oD69YCYQBlyT7SJhf5gKeMcTJfHB/K6r4YI=
Date:   Mon, 20 May 2019 11:04:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Haller <thaller@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 4.9 41/51] fib_rules: return 0 directly if an exactly
 same rule exists when NLM_F_EXCL not supplied
Message-ID: <20190520090429.GA25812@kroah.com>
References: <20190515090616.669619870@linuxfoundation.org>
 <20190515090628.066392616@linuxfoundation.org>
 <20190519154348.GA113991@archlinux-epyc>
 <a36e3204-b52d-0bf0-f956-654189a18156@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36e3204-b52d-0bf0-f956-654189a18156@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 19, 2019 at 06:29:19PM -0600, David Ahern wrote:
> On 5/19/19 9:43 AM, Nathan Chancellor wrote:
> > Hi all,
> > 
> > This commit is causing issues on Android devices when Wi-Fi and mobile
> > data are both enabled. The device will do a soft reboot consistently.
> > So far, I've had reports on the Pixel 3 XL, OnePlus 6, Pocophone, and
> > Note 9 and I can reproduce on my OnePlus 6.
> > 
> > Sorry for taking so long to report this, I just figured out how to
> > reproduce it today and I didn't want to report it without that.
> > 
> > Attached is a full dmesg and the relevant snippet from Android's logcat.
> > 
> > Let me know what I can do to help debug,
> > Nathan
> > 
> 
> It's a backport problem. err needs to be reset to 0 before the goto.

Ah, I see it, let me go queue up a fix for this.

thanks,

greg k-h
