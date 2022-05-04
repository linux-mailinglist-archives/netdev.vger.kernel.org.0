Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D390519CC2
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 12:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347625AbiEDKUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 06:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiEDKUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 06:20:47 -0400
X-Greylist: delayed 657 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 04 May 2022 03:17:09 PDT
Received: from mail.aperture-lab.de (mail.aperture-lab.de [IPv6:2a01:4f8:c2c:665b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0CA1EACB;
        Wed,  4 May 2022 03:17:09 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E10F54116B;
        Wed,  4 May 2022 12:06:02 +0200 (CEST)
Date:   Wed, 4 May 2022 12:06:00 +0200
From:   Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     Kevin Mitchell <kevmitch@arista.com>
Cc:     Matthias Schiffer <mschiffer@universe-factory.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, gal@nvidia.com,
        bridge@lists.linux-foundation.org, Florian Westphal <fw@strlen.de>,
        linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Bridge] [PATCH v2 0/1] UDP traceroute packets with no checksum
Message-ID: <YnJQCIKgriI3kjFc@sellars>
References: <20220405235117.269511-1-kevmitch@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220405235117.269511-1-kevmitch@arista.com>
X-Last-TLS-Session-Version: TLSv1.3
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 04:51:15PM -0700, Kevin Mitchell via Bridge wrote:
> This is v2 of https://lkml.org/lkml/2022/1/14/1060
> 
> That patch was discovered to cause problems with UDP tunnels as
> described here:
> 
> https://lore.kernel.org/netdev/7eed8111-42d7-63e1-d289-346a596fc933@nvidia.com/
> 
> This version addresses the issue by instead explicitly handling zero UDP
> checksum in the nf_reject_verify_csum() helper function.
> 
> Unlike the previous patch, this one only allows zero UDP checksum in
> IPv4. I discovered that the non-netfilter IPv6 path would indeed drop
> zero UDP checksum packets, so it's probably best to remain consistent.

Are you sure that a UDP zero checksum is not working for IPv6
packets? We are using it here without any issues with VXLAN
tunnels.

Yes, the original RFC did not allow UDP zero checksums in IPv6
packets, but I believe this has changed:

https://www.rfc-editor.org/rfc/rfc6936
(https://www.ietf.org/archive/id/draft-ietf-6man-udpzero-01.html)

Regards, Linus
