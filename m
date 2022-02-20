Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B204BCDF5
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243525AbiBTJSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 04:18:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241708AbiBTJSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 04:18:54 -0500
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7082433A28;
        Sun, 20 Feb 2022 01:18:33 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id BCBDB5805C1;
        Sun, 20 Feb 2022 04:18:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 20 Feb 2022 04:18:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8YmlWNGsIRtVtoKHI
        ISw4bcjX7NWo7BrkPWPL8sPzOM=; b=O8QN/sSGleDt1HvNr2/Y+K9PT6s0BDSKR
        mcCNBALC+aTs44bOc3VLq3C+OY9+gi9DF6h8Us3C8O/EBjqatncIrQTALhyDCjBM
        G1j58Lpr6W+KNPWF5mbAC4nXS48jxi7b+iURc9jimwi6DF7KJkDd3CAZF/JLWGVy
        hzM/cRTGj/Vl2L19xsfLBM+XmoiS7aojOZO1dR4mG463ql+FSSQ1u1jJJ+hDhVke
        Ltiyn9ivIW/OxDeYTsDRjeLuqIXsYZck2YMoUKqz9kpekH/pvw/FxaDwXkVPhcUy
        UlW8c68jsSAjnDKKPkGbi9rNM3Pxy0sGkBa8V9SqyR4p8GP6HNeBQ==
X-ME-Sender: <xms:ZwcSYskNpiQAvPw582fP5xyDnDHElLRcseIwJlAfqGU59KAvc-wLQw>
    <xme:ZwcSYr2QWBZvWRaUHih388Iuz4HUkEo_IasFOQ9fZhdBMrq_v63il5-OaPmonxO51
    lRwvih6yUBZP4o>
X-ME-Received: <xmr:ZwcSYqrGW2GK7ol2Dqykx7LzDOezgIRzkLy35bueuD9PJb505T2089Nv7G3welxOpco6Wq4uDwl9YkQRtNapvErs_sk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeeggddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ZwcSYom-K74dmZyJf0Fv68mJObSMJZnDnenymLme2dvyhQHLelxoVQ>
    <xmx:ZwcSYq36XvY7FP5VX-XAJYY3Ocwla1MnoYP1lahQ6bus1w_dRld4pQ>
    <xmx:ZwcSYvvFCtqAQnsFy2LFdYrJD_wuSCMjnwsrLYzFdRWTzF-C-EM3qg>
    <xmx:aAcSYj4zI9coJB66x72rmHm-NE55Wr1IHX3xUAkjvnd7XXpFUZKr8w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 20 Feb 2022 04:18:31 -0500 (EST)
Date:   Sun, 20 Feb 2022 11:18:28 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/5] net: bridge: Add support for bridge port
 in locked mode
Message-ID: <YhIHZBXodzr6bk0c@shredder>
References: <20220218155148.2329797-1-schultz.hans+netdev@gmail.com>
 <20220218155148.2329797-2-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218155148.2329797-2-schultz.hans+netdev@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 04:51:44PM +0100, Hans Schultz wrote:
> In a 802.1X scenario, clients connected to a bridge port shall not
> be allowed to have traffic forwarded until fully authenticated.
> A static fdb entry of the clients MAC address for the bridge port
> unlocks the client and allows bidirectional communication.
> 
> This scenario is facilitated with setting the bridge port in locked
> mode, which is also supported by various switchcore chipsets.
> 
> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>

With Nik's comment fixed:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
