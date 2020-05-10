Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D477B1CC619
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 03:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgEJB7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 21:59:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51592 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgEJB7Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 21:59:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KYzPxGASe4Z0zeXFbNOdd6hDwlKRo9S7QXx2n38ToH8=; b=07eBrn+uX16ClMVxs7RG+7moEE
        cu86G4PVFlq45Z+OgIp3xqwvA4H85kE1Us2fP7Tcg1TgjDXU+kDXscLzOVjrIa56C3UCF+nRFdGYt
        WqI2QBN14ENsKfSDgKTV63xM8LgXHB5XLCbnvYz4C5IO4kkxZBgtgovle0hnskPAB31s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXbEM-001ZIw-ED; Sun, 10 May 2020 03:58:14 +0200
Date:   Sun, 10 May 2020 03:58:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] net: taint when the device driver firmware crashes
Message-ID: <20200510015814.GE362499@lunn.ch>
References: <20200509043552.8745-1-mcgrof@kernel.org>
 <1e097eb0-6132-f549-8069-d13b678183f5@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1e097eb0-6132-f549-8069-d13b678183f5@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 06:01:51PM -0700, Shannon Nelson wrote:
> On 5/8/20 9:35 PM, Luis Chamberlain wrote:
> > Device driver firmware can crash, and sometimes, this can leave your
> > system in a state which makes the device or subsystem completely
> > useless. Detecting this by inspecting /proc/sys/kernel/tainted instead
> > of scraping some magical words from the kernel log, which is driver
> > specific, is much easier. So instead this series provides a helper which
> > lets drivers annotate this and shows how to use this on networking
> > drivers.
> > 
> If the driver is able to detect that the device firmware has come back
> alive, through user intervention or whatever, should there be a way to
> "untaint" the kernel?  Or would you expect it to remain tainted?

Hi Shannon

In general, you don't want to be able to untained. Say a non-GPL
licenced module is loaded, which taints the kernel. It might then try
to untaint the kernel to hide its.

As for firmware, how much damage can the firmware do as it crashed? If
it is a DMA master, it could of splattered stuff through
memory. Restarting the firmware is not going to reverse the damage it
has done.

    Andrew
