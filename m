Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6699936A333
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 23:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbhDXVfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 17:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhDXVfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 17:35:10 -0400
X-Greylist: delayed 336 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 24 Apr 2021 14:34:31 PDT
Received: from daxilon.jbeekman.nl (jbeekman.nl [IPv6:2a01:7c8:aab4:5fb::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1265C061574
        for <netdev@vger.kernel.org>; Sat, 24 Apr 2021 14:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=jbeekman.nl
        ; s=main; h=Subject:Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:To:From:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2Sh2Vk3uL2c4anEi/1xNO79ck7ciYzo2ncPle6P3vVc=; b=WmVa/SprMIZsw+Q3S0h9j8KBKH
        4A3gmbt/KGM5//BEzxyc1CJHLH3bk+y1Y0y7dQUTPsUbzIVJc0+M5qTystki+RYcnfjmSTJWHTOmU
        7vmfZGaeU4GVhzcds0Xes0TjtYY9Th2BYyc7TzA04b9YBIf2b919M1WYJ0MZaIsLx/yfZuSJUwRPu
        0HHt2IbTbDQhy7QMuWpONDMJ+qm8ZFgPdJWH9U+IcH9xawegIF+5p9X9LDIU8pxqA1GOjUIKtSztM
        rkQL3lbmLcoQvbJaxzDt7XlFCnrJh1gsbh6EXqxcsqL4NPDNSranvM5aGdBWDrl2Om/qvC98bJCaB
        /8KGuPsw==;
Received: from ip-213-127-124-30.ip.prioritytelecom.net ([213.127.124.30] helo=[192.168.3.100])
        by daxilon.jbeekman.nl with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <kernel@jbeekman.nl>)
        id 1laPpd-0006gE-3Q
        for netdev@vger.kernel.org; Sat, 24 Apr 2021 23:28:53 +0200
From:   Jethro Beekman <kernel@jbeekman.nl>
To:     netdev@vger.kernel.org
Message-ID: <8685da8c-3502-34c7-c91f-db28a0a450d6@jbeekman.nl>
Date:   Sat, 24 Apr 2021 23:28:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 213.127.124.30
X-SA-Exim-Mail-From: kernel@jbeekman.nl
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on daxilon.jbeekman.nl
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Report: Content analysis details:   (-2.9 points, 5.0 required)
        pts rule name              description
        --- ---------------------- --------------------------------------------------
        -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
        -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
        [score: 0.0000]
        0.0 URIBL_BLOCKED          ADMINISTRATOR NOTICE: The query to URIBL was
        blocked.  See
        http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        for more information.
        [URIs: 8.in]
Subject: [PATCH iproute2-next] ip: Clarify MACVLAN private mode
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Traffic isn't really "disallowed" but rather some broadcast traffic is filtered.

Signed-off-by: Jethro Beekman <kernel@jbeekman.nl>
---
 man/man8/ip-link.8.in | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index fd67e611..a4abae5f 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -1366,10 +1366,12 @@ the following additional arguments are supported:
 .BR /dev/tapX " to be used just like a " tuntap " device."
 
 .B mode private
-- Do not allow communication between
+- Do not allow broadcast communication between
 .B macvlan
 instances on the same physical interface, even if the external switch supports
-hairpin mode.
+hairpin mode. Unicast traffic is transmitted over the physical interface as in
+.B vepa
+mode, but the lack of ARP responses may hamper communication.
 
 .B mode vepa
 - Virtual Ethernet Port Aggregator mode. Data from one
@@ -1394,7 +1396,7 @@ forces the underlying interface into promiscuous mode. Passing the
 using standard tools.
 
 .B mode source
-- allows one to set a list of allowed mac address, which is used to match
+- Allows one to set a list of allowed mac address, which is used to match
 against source mac address from received frames on underlying interface. This
 allows creating mac based VLAN associations, instead of standard port or tag
 based. The feature is useful to deploy 802.1x mac based behavior,
-- 
2.31.1

