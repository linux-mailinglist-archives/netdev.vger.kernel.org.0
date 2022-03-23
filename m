Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74FD4E57C3
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 18:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343749AbiCWRqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 13:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236472AbiCWRqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 13:46:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0576E558
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 10:44:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F351260F55
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 17:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD26C340ED;
        Wed, 23 Mar 2022 17:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648057487;
        bh=LrFz7aT4EGyFDlS03wM6ARE/JlF083HQCM5JMhEzkL8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KIs0499BO/79LC0RrkEGyWeFZbK8L+3aku3go47SREMHzbSMBmmU/gq7M2rAelQu2
         b43O+Kl1VGieHCpbxAd7kKbsd8alYkOeRk2heRiDImUfU8UmTroel9KfLLSLp+kbHa
         6PiPZp9vtZ4nH/9YMU/0vCGMYNLzCx9+dZXwewgsd3n2eckcJoclQjJpaD3AT8SWTm
         vSB81XovyzKiZ+2N+4SueYa1a8bzvBSgCeuUIfrTErt1wKogsPXwe9ahLagSrhPBdo
         NOg9mTWfk8rh9jWyXKQXbQ4WJoJpZLEq2GpQcuIuN3hzX/5TL8Jkt+u2dy+jkOM5vb
         wNqimN3sYQqqQ==
Date:   Wed, 23 Mar 2022 10:44:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        zhang kai <zhangkaiheb@126.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH net-next 0/5] flower: match on the number of vlan tags
Message-ID: <20220323104445.03a54654@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220323105602.30072-1-boris.sukholitko@broadcom.com>
References: <20220323105602.30072-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Mar 2022 12:55:57 +0200 Boris Sukholitko wrote:
> Our customers in the fiber telecom world have network configurations
> where they would like to control their traffic according to the number
> of tags appearing in the packet.
> 
> For example, TR247 GPON conformance test suite specification mostly
> talks about untagged, single, double tagged packets and gives lax
> guidelines on the vlan protocol vs. number of vlan tags.
> 
> This is different from the common IT networks where 802.1Q and 802.1ad
> protocols are usually describe single and double tagged packet. GPON
> configurations that we work with have arbitrary mix the above protocols
> and number of vlan tags in the packet.
> 
> The following patch series implement number of vlans flower filter. They
> add num_of_vlans flower filter as an alternative to vlan ethtype protocol
> matching. The end result is that the following command becomes possible:
> 
> tc filter add dev eth1 ingress flower \
>   num_of_vlans 1 vlan_prio 5 action drop

# Form letter - net-next is closed

We have already sent the networking pull request for 5.18
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.18-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
