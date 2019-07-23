Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17B4E7159E
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 12:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbfGWKBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 06:01:31 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4715 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfGWKBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 06:01:31 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d36daf70000>; Tue, 23 Jul 2019 03:01:27 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 23 Jul 2019 03:01:30 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 23 Jul 2019 03:01:30 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 23 Jul
 2019 10:01:26 +0000
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
To:     Jose Abreu <Jose.Abreu@synopsys.com>, Lars Persson <lists@bofh.nu>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
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
 <20190722101830.GA24948@apalos>
 <CADnJP=thexf2sWcVVOLWw14rpteEj0RrfDdY8ER90MpbNN4-oA@mail.gmail.com>
 <BN8PR12MB326661846D53AAEE315A7434D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <11557fe0-0cba-cb49-0fb6-ad24792d4a53@nvidia.com>
 <BN8PR12MB3266664ECA192E02C06061EED3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BYAPR12MB3269A725AFDDA21E92946558D3C70@BYAPR12MB3269.namprd12.prod.outlook.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <ab14f31f-2045-b1be-d31f-2a81b8527dac@nvidia.com>
Date:   Tue, 23 Jul 2019 11:01:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <BYAPR12MB3269A725AFDDA21E92946558D3C70@BYAPR12MB3269.namprd12.prod.outlook.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563876087; bh=egy5lIg2QcRmIaxcvymArPwrBaGWeS0BY9hTg1rDFtQ=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=GWGBJFlVEnm2Ted4BVDkDxLiVC0T9dTzRx5z3HLyjd+XFZIxMB3+HMQ3V2n8TOFFe
         uv+KmlQFlVmL2mvbNG8Ts5rjNn/sR/iLxsKt7m6G7yAG67IcF63U5sG8kTPlI7rqWW
         O6BnQicD7myht1gWcsRTm6i0Is+yU77G11VyLoIaqpZCNn3VysXT8RVEmPXplSUnRB
         H5LJw3eRYSj9eXFoWgR/O9DwM4mePv0AijfUT5QOqPxOYZdBVSdWC4LYxWLqGLZP3a
         bMe1g2IPQChTtM0zpzKwaXNPhqeL0B45qyYBhM5Ob5f4kobU63l3/wQhxcMMyciKjo
         vAFvnmgMVO7QQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 23/07/2019 09:14, Jose Abreu wrote:
> From: Jose Abreu <joabreu@synopsys.com>
> Date: Jul/22/2019, 15:04:49 (UTC+00:00)
> 
>> From: Jon Hunter <jonathanh@nvidia.com>
>> Date: Jul/22/2019, 13:05:38 (UTC+00:00)
>>
>>>
>>> On 22/07/2019 12:39, Jose Abreu wrote:
>>>> From: Lars Persson <lists@bofh.nu>
>>>> Date: Jul/22/2019, 12:11:50 (UTC+00:00)
>>>>
>>>>> On Mon, Jul 22, 2019 at 12:18 PM Ilias Apalodimas
>>>>> <ilias.apalodimas@linaro.org> wrote:
>>>>>>
>>>>>> On Thu, Jul 18, 2019 at 07:48:04AM +0000, Jose Abreu wrote:
>>>>>>> From: Jon Hunter <jonathanh@nvidia.com>
>>>>>>> Date: Jul/17/2019, 19:58:53 (UTC+00:00)
>>>>>>>
>>>>>>>> Let me know if you have any thoughts.
>>>>>>>
>>>>>>> Can you try attached patch ?
>>>>>>>
>>>>>>
>>>>>> The log says  someone calls panic() right?
>>>>>> Can we trye and figure were that happens during the stmmac init phase?
>>>>>>
>>>>>
>>>>> The reason for the panic is hidden in this one line of the kernel logs:
>>>>> Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
>>>>>
>>>>> The init process is killed by SIGSEGV (signal 11 = 0xb).
>>>>>
>>>>> I would suggest you look for data corruption bugs in the RX path. If
>>>>> the code is fetched from the NFS mount then a corrupt RX buffer can
>>>>> trigger a crash in userspace.
>>>>>
>>>>> /Lars
>>>>
>>>>
>>>> Jon, I'm not familiar with ARM. Are the buffer addresses being allocated 
>>>> in a coherent region ? Can you try attached patch which adds full memory 
>>>> barrier before the sync ?
>>>
>>> TBH I am not sure about the buffer addresses either. The attached patch
>>> did not help. Same problem persists.
>>
>> OK. I'm just guessing now at this stage but can you disable SMP ?

I tried limiting the number of CPUs to one by setting 'maxcpus=0' on the
kernel command line. However, this did not help.

>> We have to narrow down if this is coherency issue but you said that 
>> booting without NFS and then mounting manually the share works ... So, 
>> can you share logs with same debug prints in this condition in order to 
>> compare ?
> 
> Jon, I have one ARM based board and I can't face your issue but I 
> noticed that my buffer addresses are being mapped using SWIOTLB. Can you 
> disable IOMMU support on your setup and let me know if the problem 
> persists ?

This appears to be a winner and by disabling the SMMU for the ethernet
controller and reverting commit 954a03be033c7cef80ddc232e7cbdb17df735663
this worked! So yes appears to be related to the SMMU being enabled. We
had to enable the SMMU for ethernet recently due to commit
954a03be033c7cef80ddc232e7cbdb17df735663.

Cheers
Jon

-- 
nvpublic
