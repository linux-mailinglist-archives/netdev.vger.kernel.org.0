Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD7F563C0C
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 23:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiGAVsZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 1 Jul 2022 17:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiGAVsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 17:48:24 -0400
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 01 Jul 2022 14:48:22 PDT
Received: from x61w.mirbsd.org (2001-4dd7-276e-0-21f-3bff-fe0d-cbb1.ipv6dyn.netcologne.de [IPv6:2001:4dd7:276e:0:21f:3bff:fe0d:cbb1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90A02DC0
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 14:48:22 -0700 (PDT)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id 71D30244CE; Fri,  1 Jul 2022 23:41:39 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id 699162445B
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 23:41:39 +0200 (CEST)
Date:   Fri, 1 Jul 2022 23:41:39 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     netdev@vger.kernel.org
Subject: skb->protocol 0x300?!
Message-ID: <8b27b64f-1448-cc87-1e2b-c57b45e4b443@tarent.de>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_50,KHOP_HELO_FCRDNS,
        PLING_QUERY,SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I’m needing to introspect packets to get the TCP/UDP port and
am writing packet parsing code (as apparently there is no easy
API to use). So far, so well, but my code starts with this…

	switch (skb->protocol) {
	case htons(ETH_P_IP): {
…
	    }
	case htons(ETH_P_IPV6): {
…
	    }
	default:
		// debug log
	}

… to figure out whether it’s an IP packet in the first place.

Now I’m getting 0x300 in skb->protocol for what tcpdump -X makes
me believe is a fragmented IP packet.

Why? And where is that documented? What does 0x300 there even mean?
And how can I figure out properly if a packet is IP, Legacy IP, or
something else?

Thanks,
//mirabilos
-- 
Infrastrukturexperte • tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn • http://www.tarent.de/
Telephon +49 228 54881-393 • Fax: +49 228 54881-235
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg

                        ****************************************************
/⁀\ The UTF-8 Ribbon
╲ ╱ Campaign against      Mit dem tarent-Newsletter nichts mehr verpassen:
 ╳  HTML eMail! Also,     https://www.tarent.de/newsletter
╱ ╲ header encryption!
                        ****************************************************
