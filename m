Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E4724E405
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 01:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgHUXu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 19:50:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbgHUXuz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 19:50:55 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 610DD2067C;
        Fri, 21 Aug 2020 23:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598053855;
        bh=WKufcLNK1OCzZmr8YIh76FbZHOAfrhsSl6wNgDu6vgc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0n+GK3NCF6uQAaezL4Ujc6KNT/625tvf0jDJ3pvgmFhM9xg9r5QW3Yxoc+bcFszdT
         jQC1ZHFjpdeJJrkQ06qTA8k3OvHi+0oxFzm0NmmgjlM/xAX2EKSg8vMNzZyo/bmeCe
         Lc2d6Qh4ON2lY34Vh5th5Kxep+jboo3gYMZUpeQE=
Date:   Fri, 21 Aug 2020 16:50:52 -0700
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
Message-ID: <20200821165052.6790a7ba@kicinski-fedora-PC1C0HJN>
In-Reply-To: <6030824c-02f9-8103-dae4-d336624fe425@gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Aug 2020 13:12:59 -0600 David Ahern wrote:
> On 8/21/20 10:53 AM, Jakub Kicinski wrote:
> > How many times do I have to say that I'm not arguing against the value
> > of the data? 
> > 
> > If you open up this interface either someone will police it, or it will
> > become a dumpster.  
> 
> I am not following what you are proposing as a solution. You do not like
> Ido's idea of stats going through devlink, but you are not being clear
> on what you think is a better way.
> 
> You say vxlan stats belong in the vxlan driver, but the stats do not
> have to be reported on particular netdevs. How then do h/w stats get
> exposed via vxlan code?

No strong preference, for TLS I've done:

# cat /proc/net/tls_stat 
TlsCurrTxSw                     	0
TlsCurrRxSw                     	0
TlsCurrTxDevice                 	0
TlsCurrRxDevice                 	0
TlsTxSw                         	0
TlsRxSw                         	0
TlsTxDevice                     	0
TlsRxDevice                     	0
TlsDecryptError                 	0
TlsRxDeviceResync               	0

We can add something over netlink, I opted for simplicity since global
stats don't have to scale with number of interfaces. 
