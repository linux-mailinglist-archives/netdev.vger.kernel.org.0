Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0DD255FFF
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 19:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgH1Rsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 13:48:37 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:47816 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725814AbgH1Rsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 13:48:36 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id BB6752005B;
        Fri, 28 Aug 2020 17:48:34 +0000 (UTC)
Received: from us4-mdac16-34.at1.mdlocal (unknown [10.110.49.218])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B979E8009B;
        Fri, 28 Aug 2020 17:48:34 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.106])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6859140076;
        Fri, 28 Aug 2020 17:48:34 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2A29FB40068;
        Fri, 28 Aug 2020 17:48:34 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 28 Aug
 2020 18:48:29 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 0/4] sfc: clean up some W=1 build warnings
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <57fd4501-4f13-37ee-d7f0-cda8b369bba6@solarflare.com>
Date:   Fri, 28 Aug 2020 18:48:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25630.005
X-TM-AS-Result: No-2.396700-8.000000-10
X-TMASE-MatchedRID: F4ugVhuTF/DRW3Cua5jztbmQWToO0X1/kaLYW/MsPMDIPbn2oQhptbBZ
        szSz1qei9E3EiE5BCINK5Bi1rXyCWNyfZGXkO0jdolVO7uyOCDV/qILR82ilmQ+XMlIFkG/VYZ+
        0/nP/xMZR7L1K15mNqFUuyEp7hNpvjyK/VqbtGFzykdOisNw8ygEPJrYlsf/6Yy6fApvL8BcKHk
        UYQmViAdzCc5Cd/lP1hbopPwYOhROvvxILmKK/HIMbH85DUZXy3QfwsVk0UbvqwGfCk7KUs37Jt
        BFoER9L2iziEvQ2GqnrnCF2Hf+ZarmT3znsCiYAaj2XqXuBXMWOsAl5el5tJ1T2ualXHW/Lnu3E
        +zyqLjwegUhkogLiolrMCKBXF1d6I2VNggMWJCP4LggrmsRgvTwNB+BE7PnlftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.396700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25630.005
X-MDID: 1598636914-3v0AFSKT_erU
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A collection of minor fixes to issues flagged up by W=1.
After this series, the only remaining warnings in the sfc driver are
 some 'member missing in kerneldoc' warnings from ptp.c.
Tested by building on x86_64 and running 'ethtool -p' on an EF10 NIC;
 there was no error, but I couldn't observe the actual LED as I'm
 working remotely.

[ Incidentally, ethtool_phys_id()'s behaviour on an error return
  looks strange — if I'm reading it right, it will break out of the
  inner loop but not the outer one, and eventually return the rc
  from the last run of the inner loop.  Is this intended? ]

Edward Cree (4):
  sfc: fix W=1 warnings in efx_farch_handle_rx_not_ok
  sfc: fix unused-but-set-variable warning in
    efx_farch_filter_remove_safe
  sfc: fix kernel-doc on struct efx_loopback_state
  sfc: return errors from efx_mcdi_set_id_led, and de-indirect

 drivers/net/ethernet/sfc/ef10.c       | 2 --
 drivers/net/ethernet/sfc/ethtool.c    | 3 +--
 drivers/net/ethernet/sfc/farch.c      | 9 ++-------
 drivers/net/ethernet/sfc/mcdi.c       | 6 ++----
 drivers/net/ethernet/sfc/mcdi.h       | 2 +-
 drivers/net/ethernet/sfc/net_driver.h | 2 --
 drivers/net/ethernet/sfc/selftest.c   | 2 +-
 drivers/net/ethernet/sfc/siena.c      | 1 -
 8 files changed, 7 insertions(+), 20 deletions(-)

