Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22DE27B505
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgI1TKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:10:55 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:60492 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726281AbgI1TKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 15:10:55 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Sep 2020 15:10:54 EDT
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D1A29211349;
        Mon, 28 Sep 2020 19:03:55 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 49A01200EC;
        Mon, 28 Sep 2020 19:03:55 +0000 (UTC)
Received: from us4-mdac16-6.at1.mdlocal (unknown [10.110.49.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 459F0600AA;
        Mon, 28 Sep 2020 19:03:55 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.32])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BB73C220084;
        Mon, 28 Sep 2020 19:03:54 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 46E2E28007B;
        Mon, 28 Sep 2020 19:03:53 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 28 Sep
 2020 20:03:31 +0100
Subject: Re: [patch 15/35] net: sfc: Replace in_interrupt() usage.
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        "Matthew Wilcox" <willy@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        <linux-doc@vger.kernel.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        <intel-wired-lan@lists.osuosl.org>,
        "Shannon Nelson" <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Jon Mason <jdmason@kudzu.us>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        "Hante Meuleman" <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Intel Linux Wireless" <linuxwifi@intel.com>,
        Jouni Malinen <j@w1.fi>,
        "Amitkumar Karwar" <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        <libertas-dev@lists.infradead.org>,
        Pascal Terjan <pterjan@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>
References: <20200927194846.045411263@linutronix.de>
 <20200927194921.344476620@linutronix.de>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <168a1f9e-cba4-69a8-9b29-5c121295e960@solarflare.com>
Date:   Mon, 28 Sep 2020 20:03:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200927194921.344476620@linutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25674.003
X-TM-AS-Result: No-3.392600-8.000000-10
X-TMASE-MatchedRID: scwq2vQP8OHoSitJVour/fZvT2zYoYOwC/ExpXrHizwZwGrh4y4izL88
        DvjRvF4AxVy/bbd+rAzlMoALbl7BxnAe/yBs2gz+SJA7ysb1rf4KJM4okvH5XoVCSVIDsC6o8FS
        rkmy6/FJuCEgimCyJQyMYmr0rrl/pgl5Rdh8uTQGz5GTUpcs/m3Fa/hQHt1A1+S5C/08hWc0UBy
        nKnmzE5ngVNbMoKNzVH0rosakDCyyvvxILmKK/HIMbH85DUZXyYxU/PH+vZxv6C0ePs7A07Y6HM
        5rqDwqtN237Af2aNF37I73RKjILsWlTLDIPbPGsLoghHcIpC2/UZWTGDxA33ihvJVwuK5sjeBCY
        ZbP6cf5T86emsjutggfap7ehBz6Q4vn0zMfSmjYrbLOj1GuP3A+hgLflG6KEo9QjuF9BKnnfMd6
        s6DDccQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.392600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25674.003
X-MDID: 1601319835-I9D2g4yYYeDH
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/09/2020 20:49, Thomas Gleixner wrote:
> Note, that the fixes tag is empty as it is unclear which of the commits to
> blame.
Seems like it should be
Fixes: f00bf2305cab("sfc: don't update stats on VF when called in atomic context")
 since that adds the in_interrupt() check and the code concerned
 doesn't seemto have changed a great deal since.

Anyway, this fix looks correct, and you can have my
Acked-by: Edward Cree <ecree@solarflare.com>
 but I thinkit might be cleaner to avoid having to have this unused
 can_sleep argument on all the NICs that don't need it, by instead
 adding an update_stats_atomic() member to struct efx_nic_type, which
 could be set to the same as update_stats() for everything except
 EF10 VFs which would just do the call to efx_update_sw_stats().
I'll send an rfc patch embodying the above shortly...

-ed
