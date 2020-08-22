Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7851D24E42D
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 02:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgHVAhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 20:37:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgHVAhT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 20:37:19 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 030B72072D;
        Sat, 22 Aug 2020 00:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598056638;
        bh=1l/sa+Xka3m6RIxwDV25ezDu08+V9MT1LtFKB+Q7F4Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eGsHPjnT6CwKYRTFpOFF7UdkjM8uu+hTmlEc1m5HU9L2LAPmkNN9ERJ+SrI5Krk3Q
         69NaPbfrydlO7UQNG4mL8FIph60otuf6HXiKhZ8TQ6NwNpjhTbJk989bhgxqkAqhYX
         V7d8+jVSjbnrnC5m90EU93G79hg6Uf1yjQR3TKJE=
Date:   Fri, 21 Aug 2020 17:37:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        tariqt@nvidia.com, ayal@nvidia.com, mkubecek@suse.cz,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/6] devlink: Add device metric support
Message-ID: <20200821173715.2953b164@kicinski-fedora-PC1C0HJN>
In-Reply-To: <1e5cdd45-d66f-e8e0-ceb7-bf0f6f653a1c@gmail.com>
References: <20200817125059.193242-1-idosch@idosch.org>
        <20200818172419.5b86801b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <58a0356d-3e15-f805-ae52-dc44f265661d@gmail.com>
        <20200818203501.5c51e61a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <55e40430-a52f-f77b-0d1e-ef79386a0a53@gmail.com>
        <20200819091843.33ddd113@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <e4fd9b1c-5f7c-d560-9da0-362ddf93165c@gmail.com>
        <20200819110725.6e8744ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d0c24aad-b7f3-7fd9-0b34-c695686e3a86@gmail.com>
        <20200820090942.55dc3182@kicinski-fedora-PC1C0HJN>
        <20200821103021.GA331448@shredder>
        <20200821095303.75e6327b@kicinski-fedora-PC1C0HJN>
        <6030824c-02f9-8103-dae4-d336624fe425@gmail.com>
        <20200821165052.6790a7ba@kicinski-fedora-PC1C0HJN>
        <1e5cdd45-d66f-e8e0-ceb7-bf0f6f653a1c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Aug 2020 17:59:57 -0600 David Ahern wrote:
> On 8/21/20 5:50 PM, Jakub Kicinski wrote:
> > On Fri, 21 Aug 2020 13:12:59 -0600 David Ahern wrote:  
> >> I am not following what you are proposing as a solution. You do not like
> >> Ido's idea of stats going through devlink, but you are not being clear
> >> on what you think is a better way.
> >>
> >> You say vxlan stats belong in the vxlan driver, but the stats do not
> >> have to be reported on particular netdevs. How then do h/w stats get
> >> exposed via vxlan code?  
> > 
> > No strong preference, for TLS I've done:  
> 
> But you clearly *do* have a strong preference.

I'm answering your question.

The question is "How then do h/w stats get exposed via vxlan code?"

Please note that the question includes "via vxlan code".

So no, I have no preference as long as it's "via vxlan code", and not
directly from the driver with a vendor-invented name.

> > # cat /proc/net/tls_stat   
> 
> I do not agree with adding files under /proc/net for this.

Yeah it's not the best, with higher LoC a better solution should be
within reach.

> > TlsCurrTxSw                     	0
> > TlsCurrRxSw                     	0
> > TlsCurrTxDevice                 	0
> > TlsCurrRxDevice                 	0
> > TlsTxSw                         	0
> > TlsRxSw                         	0
> > TlsTxDevice                     	0
> > TlsRxDevice                     	0
> > TlsDecryptError                 	0
> > TlsRxDeviceResync               	0
> > 
> > We can add something over netlink, I opted for simplicity since global
> > stats don't have to scale with number of interfaces. 
> 
> IMHO, netlink is the right "channel" to move data from kernel to
> userspace, and opting in to *specific* stats is a must have feature.
> 
> I think devlink is the right framework given that the stats are device
> based but not specific to any particular netdev instance. 

I'd be careful with the "not specific to any particular netdev
instance". A perfect API would be flexible when it comes to scoping :)

> Further, this
> allows discrimination of hardware stats from software stats which if
> tied to vxlan as a protocol and somehow pulled from the vxan driver
> those would be combined into one (at least how my mind is thinking of this).

Right, for tls the stats which have "Device" in the name are hardware.
But netlink will have better ways of separating the two.

> ####
> 
> Let's say the direction is for these specific stats (as opposed to the
> general problem that Ido and others are considering) to be pulled from
> the vxlan driver. How does that driver get access to hardware stats?
> vxlan is a protocol and not tied to devices. How should the connection
> be made?

Drivers which offload VxLAN already have a dependency on it, right?
They can just registers to it and get queried on dump. Or if we want
scoping we can piggyback on whatever object stats are scoped to.

*If* we scope on HW objects do we need to worry about some user some
day wanting to have stats per vxlan netdev and per HW instance?
