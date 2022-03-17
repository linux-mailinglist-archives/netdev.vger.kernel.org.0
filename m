Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1004DC9A4
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 16:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbiCQPMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 11:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235651AbiCQPMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 11:12:09 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3AE104A74
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 08:10:53 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A02F45C0248;
        Thu, 17 Mar 2022 11:10:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 17 Mar 2022 11:10:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=UmOzO//VgaCsOCZvn
        SlXNtWZ4ThdzlWedz8inn3GitY=; b=Q379xlAJUBjFD6SO/Jq6qcGFXMRmSXWUF
        uBZnc1KjiScuIamR88Wfht1WDnYw6g2dPMijBzzxOEmuXKMYT5tpQOQmOTBETNnr
        0mbfZ/0tGMTnx0hbxhBxHSL+AL3MmJ81Cuy13/h9SfeQXYZMuQwUp2tyMkadmFb6
        LUbAVeuj/vzahgiQsjzRb7Szhzu5aDDnT0umLw7fH/LBPYo/A3NPpi6I6YBCBoHE
        eV9nmFSFAmaehYE5wdWvcZhNhtz1ssHh/lOZB8CZXRcNa4qZc7QozKa5hdVWaBJo
        rpIBbioclogmN+G78cSS3GvUCjauTY6HQoxUEME1Bb8zPmA6hkNfQ==
X-ME-Sender: <xms:fE8zYnF49dNd-ldLGGhwpthnlRqtwILvnx0qR2_ImPQ8SrGghCdQPA>
    <xme:fE8zYkXq2xcpP_KZXG3Q8KBPZ6J-fJoIcfu_jjqL6TXXlWjPUHml7pm5FEMWGwa4V
    Gu17dzoxRdlNQ0>
X-ME-Received: <xmr:fE8zYpIVGYIT4gwtSOy9NHoRkbOfOxmPQ6dHiwa_pnmIWV8xMM0lqQP9viyApyHxj3GYqIJS-oCMTnHcNErm16xcdgY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudefgedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpefgffekkeejvdetgeevuedtudejgfelgeeugffgjeeigeetkeduhfefjeejgfdt
    leenucffohhmrghinheplhifnhdrnhgvthenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:fE8zYlHHirE447wUEt5kSUxSdQizEe0hoPEaTz44NwuL2Rc69LWy8A>
    <xmx:fE8zYtVnGYBEaIBykUVMVy47zb4P_FX31lwFWr_YkI6G-Y9BISCuXw>
    <xmx:fE8zYgMwXU34zq-M7c7oQi8nRfVnRJHnpYXJYSBx2bv28Oj5wctcSg>
    <xmx:fE8zYqi6V1SEEqegd5ckrC63CyaK4QQ7dMjYsBW57Gi_cPj_HPaLbQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Mar 2022 11:10:51 -0400 (EDT)
Date:   Thu, 17 Mar 2022 17:10:49 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net] af_netlink: Fix shift out of bounds in group mask
 calculation
Message-ID: <YjNPeZrOxRjSgqF4@shredder>
References: <2bef6aabf201d1fc16cca139a744700cff9dcb04.1647527635.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bef6aabf201d1fc16cca139a744700cff9dcb04.1647527635.git.petrm@nvidia.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 03:53:06PM +0100, Petr Machata wrote:
> When a netlink message is received, netlink_recvmsg() fills in the address
> of the sender. One of the fields is the 32-bit bitfield nl_groups, which
> carries the multicast group on which the message was received. The least
> significant bit corresponds to group 1, and therefore the highest group
> that the field can represent is 32. Above that, the UB sanitizer flags the
> out-of-bounds shift attempts.
> 
> Which bits end up being set in such case is implementation defined, but
> it's either going to be a wrong non-zero value, or zero, which is at least
> not misleading. Make the latter choice deterministic by always setting to 0
> for higher-numbered multicast groups.
> 
> To get information about membership in groups >= 32, userspace is expected
> to use nl_pktinfo control messages[0], which are enabled by NETLINK_PKTINFO
> socket option.
> [0] https://lwn.net/Articles/147608/
> 
> The way to trigger this issue is e.g. through monitoring the BRVLAN group:
> 
> 	# bridge monitor vlan &
> 	# ip link add name br type bridge
> 
> Which produces the following citation:
> 
> 	UBSAN: shift-out-of-bounds in net/netlink/af_netlink.c:162:19
> 	shift exponent 32 is too large for 32-bit type 'int'
> 
> Fixes: f7fa9b10edbb ("[NETLINK]: Support dynamic number of multicast groups per netlink family")
> Signed-off-by: Petr Machata <petrm@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
