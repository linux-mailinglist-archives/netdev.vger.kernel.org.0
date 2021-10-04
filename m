Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9294211E8
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 16:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235057AbhJDOuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 10:50:13 -0400
Received: from mx4.wp.pl ([212.77.101.11]:59793 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234744AbhJDOuN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 10:50:13 -0400
Received: (wp-smtpd smtp.wp.pl 17921 invoked from network); 4 Oct 2021 16:48:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1633358901; bh=mJTnMjfJmvIn1Zpqq4jdCdLeL3jnYqRReCvSseChmXc=;
          h=From:To:Cc:Subject;
          b=hOhn2Fp4JtJSjtZUM4aHv/LW3ZK9R4PynfMqzGxdJDXghrM1v9nqcrOdJYKPWgqa/
           BnpmtXl6NeOnvymiiBKlL2eeCauKfrG8hRvNyKgk2OPFL9GrgTn9Ly67NCZ5DdkgUA
           m+KzOkwxM85lLwqaGu69YTBhJoMN5vbA/qWHmGFI=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.1])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <andreas.huettel@ur.de>; 4 Oct 2021 16:48:21 +0200
Date:   Mon, 4 Oct 2021 07:48:14 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     "Andreas K. Huettel" <andreas.huettel@ur.de>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Sasha Neftin <sasha.neftin@intel.com>
Subject: Re: Intel I350 regression 5.10 -> 5.14 ("The NVM Checksum Is Not
 Valid")  [8086:1521]
Message-ID: <20211004074814.5900791a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1823864.tdWV9SEqCh@kailua>
References: <1823864.tdWV9SEqCh@kailua>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: af7271ebdfa632b73ad526844b541f54
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000004 [kWfW]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 04 Oct 2021 15:06:31 +0200 Andreas K. Huettel wrote:
> Dear all, 
> 
> I hope this is the right place to ask, if not please advise me where to go.

Adding intel-wired-lan@lists.osuosl.org and Sasha as well.

> I have a new Dell machine with both an Intel on-board ethernet controller 
> ([8086:15f9]) and an additional 2-port extension card ([8086:1521]). 
> 
> The second adaptor, a "DeLock PCIe 2xGBit", worked fine as far as I could 
> see with Linux 5.10.59, but fails to initialize with Linux 5.14.9.
> 
> dilfridge ~ # lspci -nn
> [...]
> 01:00.0 Ethernet controller [0200]: Intel Corporation I350 Gigabit Network Connection [8086:1521] (rev ff)
> 01:00.1 Ethernet controller [0200]: Intel Corporation I350 Gigabit Network Connection [8086:1521] (rev ff)
> [...]
> 
> dilfridge ~ # dmesg|grep igb
> [    2.069286] igb: Intel(R) Gigabit Ethernet Network Driver
> [    2.069288] igb: Copyright (c) 2007-2014 Intel Corporation.
> [    2.069305] igb 0000:01:00.0: can't change power state from D3cold to D0 (config space inaccessible)
> [    2.069624] igb 0000:01:00.0 0000:01:00.0 (uninitialized): PCIe link lost
> [    2.386659] igb 0000:01:00.0: PHY reset is blocked due to SOL/IDER session.
> [    4.115500] igb 0000:01:00.0: The NVM Checksum Is Not Valid
> [    4.133807] igb: probe of 0000:01:00.0 failed with error -5
> [    4.133820] igb 0000:01:00.1: can't change power state from D3cold to D0 (config space inaccessible)
> [    4.134072] igb 0000:01:00.1 0000:01:00.1 (uninitialized): PCIe link lost
> [    4.451602] igb 0000:01:00.1: PHY reset is blocked due to SOL/IDER session.
> [    6.180123] igb 0000:01:00.1: The NVM Checksum Is Not Valid
> [    6.188631] igb: probe of 0000:01:00.1 failed with error -5
> 
> Any advice on how to proceed? Willing to test patches and provide additional debug info.
