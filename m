Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B636324E8BA
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 18:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgHVQ1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 12:27:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726728AbgHVQ1m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Aug 2020 12:27:42 -0400
Received: from kicinski-fedora-PC1C0HJN (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 074BD2072D;
        Sat, 22 Aug 2020 16:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598113661;
        bh=KUcY6jUvQbqYukCvFE5e41HgnRDWj1Bb1E+AfJUz76A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K5Nh99z8CFb0NoIpL+8rMN7ytRP1Onuz6c13M4VJP6+HNzfAy1rQWYYJXPVUFKPEK
         7On4ce7f1Jyx5/ki4ilADCG8b9iUcCZftmwpXRKjfmwKYII4TUWw1bY1jXdpoCwJX8
         fG1vutgI4Kt9b6n0UrMf1SPq8TckOVF9yS9FiAa0=
Date:   Sat, 22 Aug 2020 09:27:39 -0700
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
Message-ID: <20200822092739.5ba0c099@kicinski-fedora-PC1C0HJN>
In-Reply-To: <90b68936-88cf-4d87-55b0-acf9955ef758@gmail.com>
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
        <20200821173715.2953b164@kicinski-fedora-PC1C0HJN>
        <90b68936-88cf-4d87-55b0-acf9955ef758@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Aug 2020 19:18:37 -0600 David Ahern wrote:
> On 8/21/20 6:37 PM, Jakub Kicinski wrote:
> >>> # cat /proc/net/tls_stat     
> >>
> >> I do not agree with adding files under /proc/net for this.  
> > 
> > Yeah it's not the best, with higher LoC a better solution should be
> > within reach.  
> 
> The duplicity here is mind-boggling. Tls stats from hardware is on par
> with Ido's *example* of vxlan stats from an ASIC. You agree that
> /proc/net files are wrong,

I didn't say /proc/net was wrong, I'm just trying to be agreeable.
Maybe I need to improve my command of the English language.

AFAIK /proc/net is where protocol stats are.

> but you did it anyway and now you want the
> next person to solve the problem you did not want to tackle but have
> strong opinions on.

I have no need and interest in vxlan stats.

> Ido has a history of thinking through problems and solutions in a proper
> Linux Way. netlink is the right API, and devlink was created for
> 'device' stuff versus 'netdev' stuff. Hence, I agree with this
> *framework* for extracting asic stats.

You seem to focus on less relevant points. I primarily care about the
statistics being defined and identified by Linux, not every vendor for
themselves.

No question about Ido's ability and contributions, but then again 
(from the cover letter):

> This a joint work [...] during a two-day company hackathon.
