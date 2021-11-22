Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E192458D3D
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 12:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238045AbhKVLVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 06:21:55 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:33133 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231383AbhKVLVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 06:21:48 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id B64BB58089D;
        Mon, 22 Nov 2021 06:18:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 22 Nov 2021 06:18:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=j
        Zx7ZHV5Y1G0jViLyedWy2bbOuG/smcqOJ6s3fTz2vc=; b=ZjazofhpvywEsbJCc
        coX/xg6nT8JDmBjJv2xoEzqD7QG3cotcsLWOozcJ+Vq8/gt2LgDY9+3P8Tc//GM0
        JVrUedEd64PhRkSxboLTfi9WPDw6i/0A/HZqGfsuB8E5D5G2maCq8H98TiKOXhfO
        ExV9cxkzrf1xuCvZi+YJRLk/VlxOElRrRhpXqDVgwkNlfNEuifxlkGk4mWqy44UN
        Ppr/r4V+JaCjwkH9t/pvDirrQJWRLv/StOoJNzWWqgA196F7Mxo5b87CXpXuhoxF
        FMff1QD8c0MdF8n7s5SXf7DIMDayTkW17TPa78OmRogXAy9KFqhTwj/WaDuJGXsB
        +rf1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=jZx7ZHV5Y1G0jViLyedWy2bbOuG/smcqOJ6s3fTz2
        vc=; b=nnJvUS170LGlrr/hdPDKBGSkmkHzaiALTiL3O76BGEcRCLZzQqN27ZwKj
        W2lpbMAS07UtEC9x1sldN+xm+2zvaxWWa09ErAiaPVDtFmNKt1LwliJsCcuIUqBE
        nwBuIUPFzk4NVvjcR3zA3a7xLrGoZqUmwV+sxixje0N2dZDQX+WfZOcUXg7RUM0z
        RyVCEXu8JYJMxWsrRuROkSizXnDTX3UKGwpC2daauQAw7nKm9l8I3HerXkGVw8V0
        LXqtq+CurexyN0A1mCKkViLi0HfYGnnNbIA2wLntsQ7mV2bvW/Q0Rg/j4xViVCF0
        DvIe9Dck8Qpcdo/tnLoXX8S4Apj7Q==
X-ME-Sender: <xms:kHybYV-Ok_k4Ju5WVdKsNNrJ4lFa8WQJpLj-Q8_QI9rdw5suS5jQMg>
    <xme:kHybYZsUR7_QZAfatl9XWTHocjY78dhpQy3WWnn6wo7fMbkO5liUCsxZLDKi-xIdI
    m5T0mWubnOJyw>
X-ME-Received: <xmr:kHybYTBgC65veiqdP8YB9EEn42V4VNwd7rXL6yEI9jhVNYIvA2yu7Fogyhd5tvnz6ByICnpQX-yQfBCsW8pZtLyShilLOvPw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeggddviecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpedvfffgue
    eiuefhheevheetgfehvdefgeekfeevueejfeeftdetudetiefhheffvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:kHybYZeAZuQR33Q7ofKKpMIeURsox4QwkgH9aCzm5JOTHZEd-rynfQ>
    <xmx:kHybYaMupBAHN7CFssDDlyUXTg_X2QNFq-ekUJemXRPH1allNLPYtw>
    <xmx:kHybYbnp-HBFmBKsCfKV0wsD_OL7_3x2OTd1_iZdS3J197Ln9uvOwg>
    <xmx:kHybYWm0sgJJ25AJGVesGoOwgneg0uwB7BzokoTqTtWlkUmdcRyotQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Nov 2021 06:18:40 -0500 (EST)
Date:   Mon, 22 Nov 2021 12:18:37 +0100
From:   Greg KH <greg@kroah.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     patchwork-bot+netdevbpf@kernel.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        stable <stable@vger.kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: Re: [PATCH net] tun: fix bonding active backup with arp monitoring
Message-ID: <YZt8jXTBI+1bt/zq@kroah.com>
References: <20211112075603.6450-1-nicolas.dichtel@6wind.com>
 <163698180894.15087.10819422346391173910.git-patchwork-notify@kernel.org>
 <37db0bc8-d3e0-7155-5f08-fe8b5abd21ed@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <37db0bc8-d3e0-7155-5f08-fe8b5abd21ed@6wind.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 06:26:17PM +0100, Nicolas Dichtel wrote:
> Le 15/11/2021 à 14:10, patchwork-bot+netdevbpf@kernel.org a écrit :
> > Hello:
> > 
> > This patch was applied to netdev/net.git (master)
> > by David S. Miller <davem@davemloft.net>:
> > 
> > On Fri, 12 Nov 2021 08:56:03 +0100 you wrote:
> >> As stated in the bonding doc, trans_start must be set manually for drivers
> >> using NETIF_F_LLTX:
> >>  Drivers that use NETIF_F_LLTX flag must also update
> >>  netdev_queue->trans_start. If they do not, then the ARP monitor will
> >>  immediately fail any slaves using that driver, and those slaves will stay
> >>  down.
> >>
> >> [...]
> > 
> > Here is the summary with links:
> >   - [net] tun: fix bonding active backup with arp monitoring
> >     https://git.kernel.org/netdev/net/c/a31d27fbed5d
> > 
> > You are awesome, thank you!
> > 
> May I ask for a backport to stable of this patch?
> 
> It's now in Linus tree: a31d27fbed5d ("tun: fix bonding active backup with arp
> monitoring"):
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a31d27fbed5d
> 
> I didn't put a Fixes tag in the original submission because the bug is there
> before git ages.
> Maybe "Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")" would have been a better choice.

Now queued up, thanks.

greg k-h
