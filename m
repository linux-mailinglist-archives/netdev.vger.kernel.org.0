Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F05ACA3F97
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 23:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbfH3VSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 17:18:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42116 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbfH3VSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 17:18:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1934A154FEC6C;
        Fri, 30 Aug 2019 14:18:13 -0700 (PDT)
Date:   Fri, 30 Aug 2019 14:18:12 -0700 (PDT)
Message-Id: <20190830.141812.1556491500124919572.davem@davemloft.net>
To:     tiwai@suse.de
Cc:     mlindner@marvell.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, swm@swm1.com
Subject: Re: [PATCH] sky2: Disable MSI on yet another ASUS boards (P6Xxxx)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <s5hsgpkmtsj.wl-tiwai@suse.de>
References: <20190828063119.22248-1-tiwai@suse.de>
        <20190828.160937.1788181909547435040.davem@davemloft.net>
        <s5hsgpkmtsj.wl-tiwai@suse.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 14:18:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>
Date: Thu, 29 Aug 2019 07:20:44 +0200

> On Thu, 29 Aug 2019 01:09:37 +0200,
> David Miller wrote:
>> 
>> From: Takashi Iwai <tiwai@suse.de>
>> Date: Wed, 28 Aug 2019 08:31:19 +0200
>> 
>> > A similar workaround for the suspend/resume problem is needed for yet
>> > another ASUS machines, P6X models.  Like the previous fix, the BIOS
>> > doesn't provide the standard DMI_SYS_* entry, so again DMI_BOARD_*
>> > entries are used instead.
>> > 
>> > Reported-and-tested-by: SteveM <swm@swm1.com>
>> > Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> 
>> Applied, but this is getting suspicious.
>> 
>> It looks like MSI generally is not restored properly on resume on these
>> boards, so maybe there simply needs to be a generic PCI quirk for that?
> 
> Yes, I wondered that, too.
> But, e.g. HD-audio should use MSI on Intel platforms, and if the
> problem were generic, it must suffer from the same issue, and I
> haven't heard of such, so far.  So it's likely specific to some
> limited devices, as it seems.

There must be some state of MSI state on the sky2 chip that is restored by
most BIOS/chipsets but not this one.

Some part of PCI config space or something.
