Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704A941345D
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 15:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbhIUNiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 09:38:23 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:39163 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233011AbhIUNiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 09:38:17 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 0A5552B011EA;
        Tue, 21 Sep 2021 09:36:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 21 Sep 2021 09:36:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=lKxLHh
        UqsgxPtzaPsQjSQ9FkHSNCCx7h6WzPiI38knc=; b=rOR1L7+co5Fc2ifL7EMIOg
        aOAeq2qPw1hv20cDirpcoz6qJmgof23dwz3ZkCdTYK4DW+b6Ft96fKfw78KgRLzJ
        uwRR/WX9MbkvZ8EDskI6qvE08X5/OIyJ1wkM3M6FqCOLjOGRbhGGQTCwwNwtA+zx
        fyjKo2M5anfybLUjAkhxOZR9+50G83+R/KGk3phKPw1qMHg4BB3lzpSsyflyHpHD
        frnk9aN9kV2dtsR/GySZrwYvcdPdRi1cbpUSRh6KSlHGDnM5bGh7GS7cTa1r7ili
        ztLcTyCgk+A7lJ+jdQCWbU9/4MgRkLv/M5bTEKmg6dGL/wQNSaLHLVdVKCHC+Hwg
        ==
X-ME-Sender: <xms:7d9JYZkWMG8hsrO_6ZkRXU0P5JQ2nwFGErnmms7_KcfueeaMinLAgQ>
    <xme:7d9JYU0xyVZxS75AZnvNjyPvU4Jisv6SSJlycJBTPDyvwESHz02hUrhMV48DALhVw
    ecyDhxZ8vW7zkc>
X-ME-Received: <xmr:7d9JYfqDUeaGBcTK2VoW6bjyFHd0CdYUZyPXbC1iXVEbZOLo0PSNzNcWfDxtvB2XkQiCOIWVXy8_N5gM8b_1EIv-03x_Bg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeigedgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeejhedufeelkeefveekieeiieeffeetjeeigeduveeikedvteeileekgffhgfel
    vdenucffohhmrghinhepmhgvlhhlrghnohigrdgtohhmnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhr
    gh
X-ME-Proxy: <xmx:7d9JYZk5owgeEI0YZTjz81J81swNz46JP_BF24Ng4clhodLfUmWZKg>
    <xmx:7d9JYX3Ajla1-j5BDOwkto8789ZHWnffuFlvMmmmk5qlKVPJOM8OJQ>
    <xmx:7d9JYYvf2nXhyyJ7BUTuNKlEQNoiHBPU687wZaKXgjvcyCdKixoNxA>
    <xmx:799JYQvr40t1RWoWoT3dbzv5qvtZ1S8vKtVHq95-AL0IX_U2JJpjSul2GGQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Sep 2021 09:36:44 -0400 (EDT)
Date:   Tue, 21 Sep 2021 16:36:41 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Michal Kubecek <mkubecek@suse.cz>,
        Saeed Mahameed <saeed@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Message-ID: <YUnf6V5F/hAslHnJ@shredder>
References: <PH0PR11MB4951623918C9BA8769C10E50EAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210906113925.1ce63ac7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB49511F2017F48BBAAB2A065CEAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210906180124.33ff49ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB495152B03F32A5A17EDB2F6CEAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210907075509.0b3cb353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB49512C265E090FC8741D8510EAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210907124730.33852895@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB495169997552152891A69B57EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210908092115.191fdc28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210908092115.191fdc28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 08, 2021 at 09:21:15AM -0700, Jakub Kicinski wrote:
> Mumble, mumble. Ido, Florian - any devices within your purview which
> would support SyncE?

So it's public info that Connect-X has it:
https://www.mellanox.com/files/doc-2020/pb-connectx-6-dx-en-card.pdf

Given the nature of SyncE, I think you can extrapolate from that about
other devices :)

Anyway, Petr and I started discussing this with the colleagues defining
the HW/SW interfaces and we will help with the review to make sure we
end up with a uAPI that works across multiple implementations.
