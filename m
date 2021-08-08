Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F0A3E37D4
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 03:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhHHBnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 21:43:13 -0400
Received: from mail.rptsys.com ([23.155.224.45]:47251 "EHLO mail.rptsys.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229882AbhHHBnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 21:43:12 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Aug 2021 21:43:12 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 7D22A37B2DEADA
        for <netdev@vger.kernel.org>; Sat,  7 Aug 2021 20:37:18 -0500 (CDT)
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id AIJctrmIy4YZ for <netdev@vger.kernel.org>;
        Sat,  7 Aug 2021 20:37:18 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 1DDEC37B2DEAD7
        for <netdev@vger.kernel.org>; Sat,  7 Aug 2021 20:37:18 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com 1DDEC37B2DEAD7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
        t=1628386638; bh=WQwGdnnYpacKkiSibt0tjmsihZbZCKdrp7heRC+Le3s=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=pugyeQNLhTQePFWTnRzysG0x3ckje1JAyOVIFtDyHy+Lu8NKTmlfWYsi0S8ub9WjJ
         r7gXkZ+G6UnFeMUijVRZvjkEm4UQn4/po+MAqHZXBmLSkOjFV+v6OVov82qLUh+pF4
         ZfcUO12qiKTz5A4b71xjbR4G8usHHiMPuSTzo2pM=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id SBCDXE_Ocy-N for <netdev@vger.kernel.org>;
        Sat,  7 Aug 2021 20:37:17 -0500 (CDT)
Received: from vali.starlink.edu (unknown [192.168.3.2])
        by mail.rptsys.com (Postfix) with ESMTP id E983137B2DEAD4
        for <netdev@vger.kernel.org>; Sat,  7 Aug 2021 20:37:17 -0500 (CDT)
Date:   Sat, 7 Aug 2021 20:37:17 -0500 (CDT)
From:   Timothy Pearson <tpearson@raptorengineering.com>
To:     netdev@vger.kernel.org
Message-ID: <1361477129.691401.1628386637818.JavaMail.zimbra@raptorengineeringinc.com>
Subject: Very slow macsec transfers on OpenPOWER hardware
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC83 (Linux)/8.5.0_GA_3042)
Thread-Index: tZJc0/GNcMYowbTaaxPE9MwS/MNKJw==
Thread-Topic: Very slow macsec transfers on OpenPOWER hardware
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm seeing an extreme performance issue with macsec on OpenPOWER (ppc64le) hardware, both with and without encryption.  The base systems are identical POWER9-based hosts with Intel 10Gbe Ethernet adapters; the base link validates at 9.9Gbps but the macsec link maxes out at around 250Mbps without encryption and only 170Mbps with encryption.

Ordinarily I'd suspect a cipher module isn't loaded, but the results without encryption seem to point somewhere else.  In both cases the softirq load is extremely high (100% pegged on one CPU core).

Any debugging tips are appreciated -- I can't imagine a 100-fold performance reduction over the native link is correct. ;)

Thanks!
