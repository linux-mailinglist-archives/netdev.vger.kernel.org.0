Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B9F29317B
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 00:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgJSWtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 18:49:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727232AbgJSWtf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 18:49:35 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C130521D7F;
        Mon, 19 Oct 2020 22:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603147775;
        bh=GnyHczwsjFvwbRd7zeD5yWtyscXCEccH/boasc+sCu0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BFUanBW0uRJNW5cIIrOFw8uPjcGCIZzagXaO/EL6/mD+jmBRyMet3mbGHET8a8yRW
         NhvW5zC0o4Pevqzar54SFoA+vcCN216Fm9eP9gEaAAbAdgIp5WWb9Zm1Wv6QOiFzHU
         uy/rjbQu63fie669teAsS2Zp0c2AzhrHv2tlGtNg=
Date:   Mon, 19 Oct 2020 15:49:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH net] drivers/net/wan/hdlc: In hdlc_rcv, check to make
 sure dev is an HDLC device
Message-ID: <20201019154933.424b1fac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJht_EMNza4ChbhnCvEKQkYs14SpcjdajnDA6okr9actVzQp9Q@mail.gmail.com>
References: <20201019104942.364914-1-xie.he.0141@gmail.com>
        <20201019142226.4503ed65@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAJht_EMNza4ChbhnCvEKQkYs14SpcjdajnDA6okr9actVzQp9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 15:36:14 -0700 Xie He wrote:
> On Mon, Oct 19, 2020 at 2:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Looks correct to me. I spotted there is also IFF_WAN_HDLC added by
> > 7cdc15f5f9db ("WAN: Generic HDLC now uses IFF_WAN_HDLC private flag.")
> > would using that flag also be correct and cleaner potentially?
> >
> > Up to you, just wanted to make sure you considered it.  
> 
> Oh, Yes! I see IFF_WAN_HDLC is set for all HDLC devices. I also
> searched through the kernel code and see no other uses of
> IFF_WAN_HDLC. So I think we can use IFF_WAN_HDLC to reliably check if
> a device is an HDLC device. This should be cleaner than checking
> ndo_start_xmit.
> 
> Thanks! I'll change this patch to use IFF_WAN_HDLC.

Cool! FWIW when you resend you can also trim the subject to just say:

net: hdlc: In hdlc_rcv, check to make sure dev is an HDLC device

There's no need for the full file path.
