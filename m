Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E876A21CB
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjBXSvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjBXSvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:51:00 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B4B6A7A3
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:50:58 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pVd9l-0007qK-G2; Fri, 24 Feb 2023 19:50:57 +0100
Date:   Fri, 24 Feb 2023 19:50:57 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Satyavani Namala <vani.namala@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Issue with ipv6 icmp reply after dnat over ipsec
Message-ID: <20230224185057.GJ26596@breakpoint.cc>
References: <CAAycz1m+AszZCS-1eaKZiAAXRUVSEE4a_Z3X3j4Rjyvmce4zvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAycz1m+AszZCS-1eaKZiAAXRUVSEE4a_Z3X3j4Rjyvmce4zvA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Satyavani Namala <vani.namala@gmail.com> wrote:
> We are facing an issue while testing ICMP v6 (NAT) with ipsec tunnel,
> where ping was not working , as policy is not matching (returning with
> LINUX_MIB_XFRMINNOPOLS).
> 
> When we investigated and compared with IPv4 , it was found that,
> nf_reset is happening before xfrm6_policy_check in case of IPV6
> compared to IPV4 in which nf_reset is done after xfrm4_policy_check.
> 
> Due to nf_reset, skb->_nfct is  NULL and __xfrm_policy_check is returning error.

Looks like a bug, can you submit a fix?
