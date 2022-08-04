Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765FC58A319
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 00:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbiHDWLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 18:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiHDWLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 18:11:18 -0400
X-Greylist: delayed 101 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 04 Aug 2022 15:11:17 PDT
Received: from rin.romanrm.net (rin.romanrm.net [51.158.148.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350D113EA6
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 15:11:16 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by rin.romanrm.net (Postfix) with SMTP id 30B3F5A5
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 22:09:31 +0000 (UTC)
Date:   Fri, 5 Aug 2022 03:09:29 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     netdev@vger.kernel.org
Subject: [iproute2] Rightmost part IPv6 address masking?
Message-ID: <20220805030929.613f7bc7@nvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

ip6tables supports the little-known format to mask the rightmost part of an
IPv6 address:

# ip6tables -A FORWARD -d ::a:b:c:d/::ffff:ffff:ffff:ffff -j ACCEPT

would match any IP which ends with the specified sequence, i.e.:
*:*:*:*:a:b:c:d. This is really useful in cases where the ISP provides a
dynamic IPv6 prefix, or there are prefixes from multiple ISPs in a LAN.

However in iproute2 there is no such support for "ip rule": 

# ip -6 rule add from ::a:b:c:d/::ffff:ffff:ffff:ffff lookup main
Error: inet6 prefix is expected rather than "::a:b:c:d/::ffff:ffff:ffff:ffff".

I suppose the iproute2 developers might be reading this, so could you please
consider adding support for masks like these? Aside from that, would you
reckon there's a limitation which would prevent this kind of masks from
working on the kernels-side?

Or maybe anyone can suggest the proper way to specify this for "ip rule" which
is supported currently?

Thanks

-- 
With respect,
Roman
