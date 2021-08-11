Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00613E940C
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 16:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbhHKO4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 10:56:03 -0400
Received: from mga18.intel.com ([134.134.136.126]:48214 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232440AbhHKO4C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 10:56:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="202306173"
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="202306173"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 07:55:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="672898682"
Received: from mylly.fi.intel.com (HELO [10.237.72.75]) ([10.237.72.75])
  by fmsmga006.fm.intel.com with ESMTP; 11 Aug 2021 07:55:35 -0700
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
To:     Oleksij Rempel <linux@rempel-privat.de>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Regression with commit e532a096be0e ("net: usb: asix: ax88772: add
 phylib support")
Message-ID: <3904c728-1ea2-9c2b-ec11-296396fd2f7e@linux.intel.com>
Date:   Wed, 11 Aug 2021 17:55:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

Our ASIX USB ethernet adapter stopped working after v5.14-rc1. It 
doesn't get an IP from DHCP.

v5.13 works ok. v5.14-rc1 and today's head 761c6d7ec820 ("Merge tag 
'arc-5.14-rc6' of 
git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc") show the 
regression.

I bisected regression into e532a096be0e ("net: usb: asix: ax88772: add 
phylib support").

Here's the dmesg snippet from working and non-working cases:

OK:
[    6.115773] asix 1-8:1.0 eth0: register 'asix' at usb-0000:00:14.0-8, 
ASIX AX88772 USB 2.0 Ethernet, 00:10:60:31:d5:f8
[    8.595202] asix 1-8:1.0 eth0: link up, 100Mbps, full-duplex, lpa 0xC1E1

NOK:
[    6.511543] asix 1-8:1.0 eth0: register 'asix' at usb-0000:00:14.0-8, 
ASIX AX88772 USB 2.0 Ethernet, 00:10:60:31:d5:f8
[    8.518219] asix 1-8:1.0 eth0: Link is Down

lsusb -d 0b95:7720
Bus 001 Device 002: ID 0b95:7720 ASIX Electronics Corp. AX88772

Jarkko
