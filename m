Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4A75648DA
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 19:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbiGCR5V convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 3 Jul 2022 13:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiGCR5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 13:57:19 -0400
X-Greylist: delayed 368 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 03 Jul 2022 10:57:15 PDT
Received: from x61w.mirbsd.org (xdsl-89-0-39-51.nc.de [89.0.39.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A595FA9
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 10:57:15 -0700 (PDT)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id 9A38E2544E; Sun,  3 Jul 2022 19:51:02 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id 904B42516A
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 19:51:02 +0200 (CEST)
Date:   Sun, 3 Jul 2022 19:51:02 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     netdev@vger.kernel.org
Subject: [solved] Re: skb->protocol 0x300?!
In-Reply-To: <8b27b64f-1448-cc87-1e2b-c57b45e4b443@tarent.de>
Message-ID: <b9abff38-54af-6773-9a8c-77d847837388@tarent.de>
References: <8b27b64f-1448-cc87-1e2b-c57b45e4b443@tarent.de>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_20,KHOP_HELO_FCRDNS,
        PLING_QUERY,RCVD_IN_PBL,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  3.3 RCVD_IN_PBL RBL: Received via a relay in Spamhaus PBL
        *      [89.0.39.51 listed in zen.spamhaus.org]
        * -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
        *      [score: 0.0633]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.7 SPF_SOFTFAIL SPF: sender does not match SPF record (softfail)
        *  0.1 PLING_QUERY Subject has exclamation mark and question mark
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  1.0 RDNS_DYNAMIC Delivered to internal network by host with
        *      dynamic-looking rDNS
        *  0.0 KHOP_HELO_FCRDNS Relay HELO differs from its IP's reverse DNS
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 Jul 2022, Thorsten Glaser wrote:

> Now I’m getting 0x300 in skb->protocol for what tcpdump -X makes
> me believe is a fragmented IP packet.

I also get it for unfragmented packets, and the kernel source does
not ever set it, which got me on the right track for searching.

Turns out that the buster-backports kernel has the fix already:
https://lore.kernel.org/netdev/20190318053952.115180-1-komachi.yoshiki@lab.ntt.co.jp/t/
describes my problem, and booting into 5.10 instead of 4.19 gives
me the correct skb->protocol value.

bye,
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
