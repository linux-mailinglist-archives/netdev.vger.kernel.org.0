Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C629F3E15B2
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 15:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240819AbhHENbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 09:31:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231162AbhHENbR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 09:31:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B55F60D07;
        Thu,  5 Aug 2021 13:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628170263;
        bh=JgZfnGslfqp/znxG0wr4ON7p64h3QH4jX6hdzhwkSy8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e2j4Jzm/+ngWy+h13j3kNnu5YPHrXRAClhE0rE7QeGSs8XQIDzV0ZhdsZNwuo9n0I
         c114gVNx3acfTmS1+KlxdxAsYs3810FBDa8+5cKE2PWjifIn2rNbzFzGE7OXLqWuUU
         as/a6FRc/f3oApFBn4wf/x10U+h91YSvFSD8pNSuMpw5Y6HkDCP+jvHbRJzEXtfpyK
         RxI33YR3HHOcLw7SLjhwKse7XmJ73ZULsylMm1DM0MROWTicZhgsRk26NdI4T4XCf5
         j98kMTzIohJViS0Nge2YeI+7zpK30VAjZajBrIYRmPvOYdP8GECU+FJAZ8Hr15TQC0
         Q7U4td/WzHHbg==
Date:   Thu, 5 Aug 2021 06:31:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
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
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        Petr Vorel <petr.vorel@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 03/21] ethtool, stats: introduce standard XDP
 statistics
Message-ID: <20210805063100.0c376dda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210805111826.252-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
        <20210803163641.3743-4-alexandr.lobakin@intel.com>
        <20210803134900.578b4c37@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ec0aefbc987575d1979f9102d331bd3e8f809824.camel@kernel.org>
        <20210804053650.22aa8a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210804155327.337-1-alexandr.lobakin@intel.com>
        <20210804095716.35387fcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210805111826.252-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  5 Aug 2021 13:18:26 +0200 Alexander Lobakin wrote:
>  - encourage driver developers to use this new API when they want to
>    provide any XDP stats, not the Ethtool stats which are already
>    overburdened and mix HW, SW and whatnot in most of the complex
>    drivers.

On the question of adding the stats in general I'd still ask for 
(a) performance analysis or (b) to start with just the exception 
stats which I'd think should be uncontroversial.
