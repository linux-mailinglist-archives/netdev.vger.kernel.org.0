Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E873910299
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 00:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfD3WsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 18:48:22 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:50377 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726086AbfD3WsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 18:48:21 -0400
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Apr 2019 18:48:21 EDT
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id D71741474F;
        Tue, 30 Apr 2019 18:38:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 30 Apr 2019 18:38:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tobin.cc; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=Shvvh6bYkVynmPVjaxxYGOnJjtN
        JnW6pe8SSFGB+9gs=; b=E7Py6SObItEMXdwpDk49INqD+0vHqT/Vbw/krJ6zjUs
        U9X5tnXLt00rRAIuulfe4Yp8EoSQbcN1o6+Cmn8UXQdaC8gc/3gal55BXsCdmma1
        dSLUKFpziZQmp48uoHxsOo+g2ynGtMl1/nwY5tkLpFzrspxpRmabbpyXp75nX/+j
        ER3kwznjUMbm0JefHnms5bBDE5zGYfccsZt1ee8TgpfUr7hbavVVYwedINXr9nH9
        mZJcB/pPsUi9j4aRbk/EqDoCHpwz+MxX2VWm0hLFUrdjiLujK6WbwlYD7wpTxned
        dpE36f/KvLwdmT+71oWbqXbY/zLb/8S/WyljpSV7tQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Shvvh6
        bYkVynmPVjaxxYGOnJjtNJnW6pe8SSFGB+9gs=; b=lT4vftptI4eKVotuLn6OCs
        WoBZwAw4Uz1TUGD7KlPqeIddftZSfzTx9O/OaYfEEN2mYrXmSVBsw50f2U+JvKYe
        Uj0Rk7oqLoSgoezEv7ww8nTXgpRtvRfAZk3GGh++BJ8Uaq8VmPhiHHeCcngKRayP
        ifmsCxojpuABDhL3IRXLsHPe8fqdggpxDVATJXwrqXtDfAcoe2Fm0PsaIKWO001g
        0zXCpaKuUdA8fe7h/fdZP7FZc4zi59OJ10OzIQczMsaYbe4XfLlvZBV2W3Kahi3p
        5b/PR5ILdpj23iUD8alj4RvaPDdnG8e+uQhCQ4ZK/1PQ9acrXfZvcmOyM5jItltw
        ==
X-ME-Sender: <xms:fs7IXL61kTmkx1T9LjrBThP45xlTZQWdl2rB-BUXve_4JFQIgpBGzw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieeigddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdeftddmnecujfgurhepfffhvffukfhfgggtuggjofgfsehttdertdfo
    redvnecuhfhrohhmpedfvfhosghinhcuvedrucfjrghrughinhhgfdcuoehmvgesthhosg
    hinhdrtggtqeenucfkphepuddvuddrgeegrddvtdegrddvfeehnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehmvgesthhosghinhdrtggtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:fs7IXHcfIdGnp86k4kWzuvRqaK7hkNPGB_rpLVcLvayDKZ84bSVLOQ>
    <xmx:fs7IXEKt9hWqUmrFoh322Um06JgI2Nai9C67EBtd9OAeY1fZQLg4ZA>
    <xmx:fs7IXFljeKCvwGnOuUvtwqLdtjG3hczDSf1rlW4bu78LK9hBKRs6CQ>
    <xmx:f87IXJX92_jjmtkSP-vL6EMahcL73jhWnVYpOf4rf6Uv1A9ujdME_w>
Received: from localhost (ppp121-44-204-235.bras1.syd2.internode.on.net [121.44.204.235])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5C1B6E4547;
        Tue, 30 Apr 2019 18:38:53 -0400 (EDT)
Date:   Wed, 1 May 2019 08:38:07 +1000
From:   "Tobin C. Harding" <me@tobin.cc>
To:     "Tobin C. Harding" <tobin@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tyler Hicks <tyhicks@canonical.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wang Hai <wanghai26@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] bridge: Fix error path for kobject_init_and_add()
Message-ID: <20190430223807.GE9454@eros.localdomain>
References: <20190430002817.10785-1-tobin@kernel.org>
 <20190430002817.10785-2-tobin@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430002817.10785-2-tobin@kernel.org>
X-Mailer: Mutt 1.11.4 (2019-03-13)
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 10:28:15AM +1000, Tobin C. Harding wrote:

[snip]

Please do not consider this series for merge.  There is a bit of
confusion here.

There are a few of theses patches live on various LKML lists.  Have to
consolidate all the knowledge.  When I _actually_ know how to use
kobject correctly I'll re-spin.

Thanks for your patience.

	Tobin
