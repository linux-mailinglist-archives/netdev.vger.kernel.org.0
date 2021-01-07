Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614E02EE6BC
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbhAGUWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:22:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbhAGUWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:22:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C8D423403;
        Thu,  7 Jan 2021 20:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610050882;
        bh=HJhN3b/z0PM/34cyTVmKIvS8MAZZPOWIBOy0WbFmxJY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ckicCLqyv24/NAVLKoBzSAqk8vuROgcxRg9i+5qNZTu/ZqXGdWiPHpGtAr7gqQ1zi
         MMl2YLQwnfurS98D+aIVGVenvJLzxyoLurH0o1S89agGywQiUhQ9uNklkjAaOnFOIp
         Xh5aquXcBNnYSVwzbaVmz7rj8edipntny9c72MJP0SJRPCLmYFjniWonrlrIkjDVFN
         u2+dDwTWjSW4qMCUBrpnsFXjbjxiOE+YhLrqDcoY8uVgyzZai++aJwCCBnDu8Z3egp
         vowEEdB7670tBqROk33q0SUtXvfCNLau8+NHNs2uI5OHEXD9l+5nYQLIc5Y3EiH1FU
         jpEZL89ODjpDg==
Date:   Thu, 7 Jan 2021 21:21:16 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20210107212116.44a2baea@kernel.org>
In-Reply-To: <20210107194549.GR1551@shell.armlinux.org.uk>
References: <20201230154755.14746-1-pali@kernel.org>
        <20210106153749.6748-1-pali@kernel.org>
        <20210106153749.6748-2-pali@kernel.org>
        <X/dCm1fK9jcjs4XT@lunn.ch>
        <20210107194549.GR1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jan 2021 19:45:49 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> I think you're not reading the code very well. It checks for bytes at
> offset 1..blocksize-1, blocksize+1..2*blocksize-1, etc are zero. It
> does _not_ check that byte 0 or the byte at N*blocksize is zero - these
> bytes are skipped. In other words, the first byte of each transfer can
> be any value. The other bytes of the _entire_ ID must be zero.

Wouldn't it be better, instead of checking if 1..blocksize-1 are zero,
to check whether reading byte by byte returns the same as reading 16
bytes whole?

Marek
