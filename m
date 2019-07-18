Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A479C6CBA4
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 11:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389453AbfGRJQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 05:16:26 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5885 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfGRJQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 05:16:25 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d3038e60000>; Thu, 18 Jul 2019 02:16:22 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 18 Jul 2019 02:16:24 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 18 Jul 2019 02:16:24 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 18 Jul
 2019 09:16:22 +0000
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <29dcc161-f7c8-026e-c3cc-5adb04df128c@nvidia.com>
 <BN8PR12MB32661E919A8DEBC7095BAA12D3C80@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <6a6bac84-1d29-2740-1636-d3adb26b6bcc@nvidia.com>
Date:   Thu, 18 Jul 2019 10:16:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <BN8PR12MB32661E919A8DEBC7095BAA12D3C80@BN8PR12MB3266.namprd12.prod.outlook.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563441382; bh=UBDBYe0xiPnNZ74u75kBQZUwZo4ZFBRzV7GqHtAk+fk=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=XcrP5o1PxtdUUz1qXpHkhMNzaV8bSChNtZMYT0uDV8m0MKu9ZEk24ssqQh2mfrOfg
         RSgP4hkKw4iUoi/dEpQge0mcAnMmuXX/rihVFAXg77kiaa9clb5wIKZOaVnW/rk9So
         jFzaT2aAzMdgwzRLHzNYjhD1sjPBiKN2BO7xjHBWQ3U/oQ6Brcz9Y82IlD2xdWdnIR
         cucRi5ZVTLiYtGuR9KWixMB8bDdLtJfnClHXCHr6lujxfhQ4gsRtOAJnKI/qMjLyHi
         LoCXUfe4/gRkNvShaTpVqmWg417ciLc24py02AeY0n6l1Qz59fhY9MNRa51moxDjGJ
         PeUXuf+3jqsNg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 18/07/2019 08:48, Jose Abreu wrote:
> From: Jon Hunter <jonathanh@nvidia.com>
> Date: Jul/17/2019, 19:58:53 (UTC+00:00)
> 
>> Let me know if you have any thoughts.
> 
> Can you try attached patch ?

Yes this did not help. I tried enabling the following but no more output
is seen.

CONFIG_DMA_API_DEBUG=y
CONFIG_DMA_API_DEBUG_SG=y

Have you tried using NFS on a board with this ethernet controller?

Cheers,
Jon

-- 
nvpublic
