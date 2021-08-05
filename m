Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C7F3E0C5B
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 04:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238273AbhHECO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 22:14:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232116AbhHECO1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 22:14:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F0D3610A2;
        Thu,  5 Aug 2021 02:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628129653;
        bh=ruO3OGybwjUYEOC1l6aUYucPLG2j5dr64XYovWP1ozQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eoPBa1AOAkiXYM7PuuIeO9K68FSjkbdj7lSxIJXWjWz8OfGV3OmshO4MvwK5es7VC
         d1fWBqnjglC32oq8epjv3ay61rujlm6WXKBTz6WfwonUCkln+FVfdEw1yDopkn7Q8u
         drVxNWY2UO6jjQYVzkOd3wfl1CTqM9RnugC4T0ILZiGDLgDUXrISgYqJoB4C+jQKV8
         vfXS3mQZGEImZ+nr/eH7s6Vz5LIiiz5eyoHWimOxJ8nRzkb2HKRFqzd2XIX7sWdQZA
         5pigBX0fNcXphutXg3yjMgZsVmwe+Y8mwgUYpDZp63pw3FG3e4biuUwvL8ozI/E0aE
         AgzIDC8Lgn/3A==
Message-ID: <fd2121df712574a240cd56060a138a5686e81b94.camel@kernel.org>
Subject: Re: [PATCH net-next 03/21] ethtool, stats: introduce standard XDP
 statistics
From:   Saeed Mahameed <saeed@kernel.org>
To:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Shay Agroskin <shayagr@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        Petr Vorel <petr.vorel@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Date:   Wed, 04 Aug 2021 19:14:09 -0700
In-Reply-To: <4b2358e1-a802-b0ab-129d-1432f49c46ec@gmail.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
         <20210803163641.3743-4-alexandr.lobakin@intel.com>
         <20210803134900.578b4c37@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <ec0aefbc987575d1979f9102d331bd3e8f809824.camel@kernel.org>
         <20210804053650.22aa8a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <43e91ce1-0f82-5820-7cac-b42461a0311a@gmail.com>
         <20210804094432.08d0fa86@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <d21933cb-9d24-9bdd-cf18-e5077796ddf7@gmail.com>
         <11091d33ff7803257e38ee921e4ba9597acfccfc.camel@kernel.org>
         <4b2358e1-a802-b0ab-129d-1432f49c46ec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-08-04 at 18:43 -0600, David Ahern wrote:
> On 8/4/21 12:27 PM, Saeed Mahameed wrote:
> > 
> > > I just ran some quick tests with my setup and measured about 1.2%
> > > worst
> > 
> > 1.2% is a lot ! what was the test ? what is the change ?
> 
> I did say "quick test ... not exhaustive" and it was definitely
> eyeballing a pps change over a small time window.
> 
> If multiple counters are bumped 20-25 million times a second (e.g.
> XDP
> drop case), how measurable is it? I was just trying to ballpark the
> overhead - 1%, 5%, more? If it is <~ 1% then there is no performance
> argument in which case let's do the right thing for users - export
> via
> existing APIs.

from experience I don't believe it can be more than 1% and yes on
existing APIs !

