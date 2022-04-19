Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCEA6507AA5
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 22:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356658AbiDSUJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 16:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355603AbiDSUJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 16:09:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969EB38798;
        Tue, 19 Apr 2022 13:06:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4238CB81BE5;
        Tue, 19 Apr 2022 20:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0727C385A7;
        Tue, 19 Apr 2022 20:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650398787;
        bh=4+lTB5YmUjN+zF2yL00arevxemxnjWYzr3VBboPIBu4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=sqwqTu7PvFwEJxCvnz1nOX1kl6fvoSMq11rmkgo+1zwATi3M0b6sDoijk7leRI3to
         dELkCT0y8ekge9c6ORcBaer0wR0f+aOYGq1X41dhYjvfmFDUIkuEvppvsOL/OexIjE
         8lyD5qQYroidDoztCRMk1d9Twuk24O0272lI7fvRAEJU/+xPauG3jBT9dmtusRFBex
         c051cbOfKbidbKPDR5cf2ehnheH2bu9T5x4jUPClflhjPFqnI5AYjarsdBfv77Cqh2
         +GIHZZUrSxRtXDtKhjzNSt7qzOKJDMZ4z0fY9nD+wLIfAy4GIGBJXoUYnN7G4Syaa5
         0vodi6rfal54w==
Message-ID: <1941bfc8-fa2a-16f6-a70b-df3b7d963dd7@kernel.org>
Date:   Tue, 19 Apr 2022 14:06:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH nf v2 2/2] netfilter: Use l3mdev flow key when re-routing
 mangled packets
Content-Language: en-US
To:     Martin Willi <martin@strongswan.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <20220419134701.153090-1-martin@strongswan.org>
 <20220419134701.153090-3-martin@strongswan.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220419134701.153090-3-martin@strongswan.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/19/22 7:47 AM, Martin Willi wrote:
> Commit 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif
> reset for port devices") introduces a flow key specific for layer 3
> domains, such as a VRF master device. This allows for explicit VRF domain
> selection instead of abusing the oif flow key.
> 
> Update ip[6]_route_me_harder() to make use of that new key when re-routing
> mangled packets within VRFs instead of setting the flow oif, making it
> consistent with other users.
> 
> Signed-off-by: Martin Willi <martin@strongswan.org>
> ---
>  net/ipv4/netfilter.c | 3 +--
>  net/ipv6/netfilter.c | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
>

This one will go to -next

Reviewed-by: David Ahern <dsahern@kernel.org>


