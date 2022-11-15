Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD1862A217
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 20:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiKOTm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 14:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiKOTm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 14:42:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907E811445
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 11:42:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2873FB81A1C
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 19:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44698C433C1;
        Tue, 15 Nov 2022 19:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668541342;
        bh=DzfdQkLnjva3DUAciFdQ9TidcFWs5QLfaxq6TKGHPj8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JL4YSlpnWes7alxXT7nQqMWTM5+DPcd3k34osJQJMsSKsBQ5WmIstbTm1AN+zK3fr
         IsItTkq0yi3webNsFnWy2liv4fglxZ4pmvjEacMU3jATGXiaVFfm+8r/CQvaMsmKsE
         gaOaz0Y9URJ28rwlmRAc/KJ0VWWv/3o2N11l5qfnvXk4Gpi7n2x7pm6BXZhwfIlj9M
         copRG2GxrvBIpGnFVQzmlQtchP5iaUmKLvBdFQqQqRHZtnO3sjMIXknWzjAR4w3gFh
         nMtYXgbFCThw2s+E1XsOvdcaw86m7V71Lfl+6wKhcnolZEtYFfRHxDkr35KyGSvN0z
         8F7VpBVmzoIYQ==
Date:   Tue, 15 Nov 2022 11:42:17 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCH net-next 0/5] net: eliminate the duplicate code in the ct
 nat functions of ovs and tc
Message-ID: <Y3PrmfDzDUHnPuBD@x130.lan>
References: <cover.1668527318.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <cover.1668527318.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Nov 10:50, Xin Long wrote:
>The changes in the patchset:
>
>  "net: add helper support in tc act_ct for ovs offloading"
>
>had moved some common ct code used by both OVS and TC into netfilter.
>
>There are still some big functions pretty similar defined and used in
>each of OVS and TC. It is not good to maintain such similar code in 2
>places. This patchset is to extract the functions for NAT processing
>from OVS and TC to netfilter.
>
>To make this change clear and safe, this patchset gets the common code
>out of OVS and TC step by step: The patch 1-4 make some minor changes
>in OVS and TC to make the NAT code of them completely the same, then
>the patch 5 moves the common code to the netfilter and exports one
>function called by each of OVS and TC.
>

not super expert on TC or OVS, but LGTM.

Reviewed-by: Saeed Mahameed <saeed@kernel.org>

