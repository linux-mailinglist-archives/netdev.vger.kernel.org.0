Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61D7214BF3
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 13:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgGELQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 07:16:15 -0400
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:59008
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726454AbgGELQO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 07:16:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNmYkS7CY2U0uodYEfRFHTi1KqMMGabrJFqbrmnvZ9McuVS1y+yTiFzZo6fObMzu/h6X/G1TIY7/aUrl+5Fll/Ehu1Fu0H7/g379oXK6VusNEbYV2nK8mOyPjD+WeL6UgqGbJl/EYiFfTQYMG5oo1xz8qP81EhsszDg6qLRQeGAuPwcrVoA5jLAK/FrDQ7MtNXpRt+J+qxXc99VE+rlPQFW0rF/YwD1mJtdr412VE6rtZO75PzuUclF4HiSXKQSWDMsSUuLltnGpMr6ej13yAkNJ7yhcRYcCC6ngcR4OH3PgOcnRA++LEQdxVjSDwRJ7jGJAZvX/9e+oDcqeoiY/Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Rja0xHm48tUuZSu8Bq0C6Rsv+8CPE4LH/8cB8XCIEM=;
 b=nZRB+/Wbxm9xcPe5rpICuScz/YxL9iuKCEQgo7foSIcPK4/z01h+uwPWFbD49dawAKgz9yIKaaxXmOuGRVdBmJetAlHOZ9XcMhZcSM4e7eTzaYOstsnaYNw/qfd+FHAoe93i5ZxZ6mBPjIbkqexIv+LGWPCU+Pmd7qd/WHtFEe1gPHB4Dr2Ii8Xw8ML5TwOfrX4G+ZMQRpc3EPAovb6TiteBsITVYsWYdYcfpzWsHJB4lF5k8XDxFSFGVGloXyTXnts5qlARsnH+erp8c7dTcQuB3MkkzO09boSw/aGQURpAcY/VO4RpVoUS3SePA0/2A6mPdaX0uIBRBWwXgiSlcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Rja0xHm48tUuZSu8Bq0C6Rsv+8CPE4LH/8cB8XCIEM=;
 b=AXdZ46npxhu9mg1BmFbJg8MrUa93zSgOPx17qwZ606/OBZL+9M4id08FbC1zC5i1+wMD+latBQNeizPxbezq4tuXgG/HtILxAbg1AHlreTQVX5g3cdI+r9s/QupFyGN0HbOByZlostvhs89YNaQgowu8FsvkTd4zUzDQQzPa/ww=
Authentication-Results: chelsio.com; dkim=none (message not signed)
 header.d=none;chelsio.com; dmarc=none action=none header.from=mellanox.com;
Received: from DBBPR05MB6299.eurprd05.prod.outlook.com (2603:10a6:10:d1::21)
 by DB7PR05MB5788.eurprd05.prod.outlook.com (2603:10a6:10:88::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23; Sun, 5 Jul
 2020 11:15:59 +0000
Received: from DBBPR05MB6299.eurprd05.prod.outlook.com
 ([fe80::a406:4c1a:8fd0:d148]) by DBBPR05MB6299.eurprd05.prod.outlook.com
 ([fe80::a406:4c1a:8fd0:d148%4]) with mapi id 15.20.3153.029; Sun, 5 Jul 2020
 11:15:59 +0000
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
To:     Ding Tianhong <dingtianhong@huawei.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>, linux-pci@vger.kernel.org,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Casey Leedom <leedom@chelsio.com>
References: <ca121a18-8c11-5830-9840-51f353c3ddd2@mellanox.com>
 <20200629193316.GA3283437@bjorn-Precision-5520>
 <20200629195759.GA255688@otc-nc-03>
 <edad6af6-c7b9-c6ae-9002-71a92bcd81ee@huawei.com>
From:   Aya Levin <ayal@mellanox.com>
Message-ID: <c7b933f6-5cf6-7b25-0e2d-0c147d4413b7@mellanox.com>
Date:   Sun, 5 Jul 2020 14:15:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <edad6af6-c7b9-c6ae-9002-71a92bcd81ee@huawei.com>
Content-Type: multipart/mixed;
 boundary="------------529B64CB102D136515C537B8"
Content-Language: en-US
X-ClientProxiedBy: AM0PR04CA0031.eurprd04.prod.outlook.com
 (2603:10a6:208:122::44) To DBBPR05MB6299.eurprd05.prod.outlook.com
 (2603:10a6:10:d1::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.11] (37.142.4.236) by AM0PR04CA0031.eurprd04.prod.outlook.com (2603:10a6:208:122::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22 via Frontend Transport; Sun, 5 Jul 2020 11:15:57 +0000
X-Originating-IP: [37.142.4.236]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6c794662-686e-4047-4ef0-08d820d4cb68
X-MS-TrafficTypeDiagnostic: DB7PR05MB5788:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR05MB57886DAEF85B14DB82B70453B0680@DB7PR05MB5788.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 045584D28C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O+NN0TATTrs0OfFwP4dqW3R8sBuwUmFjeg5+9t7uSIK7J+DzAUcU3A05qreAGgxt2A/6Fx/Ol7paFBorak1YKGr3QRBvGybGftVHorsJT97hsCVPjRok/scARnz0OgH7VD/OgsX79Vd7vDWqNRDEMFTI+4fA2ANWTGRerGauTFR+9y1XgsZoccIevyXj4KKh/bdMlmgtdqBXw8qQwU/uOhVaU2liOWNWQ8s+9HnnHckPSQrDsKBB5dOXsv5Wxo12FUhE1PAIJT1bL4NhE4QViXMHtMymwla/VEHMoF0ZmPha0/+OjaFVSVOhM2IOsgDoeW+6nJ31McBANlfwV6xJt8IV0iU97SbozjSpSVd4yfnJMsdk0XHY6ANOSd94YEol+vRcSJ0z6Z19mth7AAOwlP3Sk0Xxoh3B3EWEKJ6i8oo1jHBrOvPOxMJr6+R1UapMWN4ugUNgOliONvoYVs58lw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR05MB6299.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(52116002)(33964004)(53546011)(26005)(6486002)(186003)(16526019)(478600001)(966005)(83380400001)(4326008)(31686004)(8676002)(8936002)(2906002)(66616009)(16576012)(7416002)(21480400003)(316002)(110136005)(54906003)(31696002)(956004)(66946007)(66556008)(235185007)(5660300002)(2616005)(36756003)(66476007)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mDKfjrxYlMuP2Ru7Nu5qj2aMyMsiX8hPptSfxXJgBmrZKUYi9Mpkq6UdSUfIGWeIRAscx7jz/KLpUSkkm1UEWl1gRoJoBeU2cCWaeaLMV8HiG1v/tZ4JHXQDYXU6FIO6ZPb/gGRxC8iRp2hCjN/4bNXldehfSfK28mYSWmlPyDLU4TQedMr8WLY18JRdrXYep7M5eWDPwO9x6kkEpxkeMdBV+FUny/doUk19/6Cl93MWQk1tG788EFM5ahtj8Q5IxAsyRRELBKjdRAIyCYi4K2IFaOICdr7ACskYHdafOTTqSobqgL1ofRLUgcjkq6ZlRLz28e1FuFTODyoa/XEphiud5ehG3FQt4QR4bLZUwTJri79Rb0gYG7pHp3bPLOnLuQaRJpQDUJXZogjZdw5UVE+LEMMv1Mqg6cryqNEkJejhPcx+IAR7NcRw3goGybU+w61VndtjeBI59OInf9MbUeg6O13J/Bsa7jf1FOIaDGY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c794662-686e-4047-4ef0-08d820d4cb68
X-MS-Exchange-CrossTenant-AuthSource: DBBPR05MB6299.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2020 11:15:59.5009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fceDiWhc2KTITqWSMFztM9GKUNeBO9wTTtyvtMfhFfMwNJY/fPSyjpUnLx7FFk+t5qnpZKpwXq3Eta2AuSbhTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB5788
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------529B64CB102D136515C537B8
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit


On 6/30/2020 10:32 AM, Ding Tianhong wrote:
> 
> 
> ÔÚ 2020/6/30 3:57, Raj, Ashok Ð´µÀ:
>> Hi Bjorn
>>
>>
>> On Mon, Jun 29, 2020 at 02:33:16PM -0500, Bjorn Helgaas wrote:
>>> [+cc Ashok, Ding, Casey]
>>>
>>> On Mon, Jun 29, 2020 at 12:32:44PM +0300, Aya Levin wrote:
>>>> I wanted to turn on RO on the ETH driver based on
>>>> pcie_relaxed_ordering_enabled().
>>>>  From my experiments I see that pcie_relaxed_ordering_enabled() return true
>>>> on Intel(R) Xeon(R) CPU E5-2650 v3 @ 2.30GHz. This CPU is from Haswell
>>>> series which is known to have bug in RO implementation. In this case, I
>>>> expected pcie_relaxed_ordering_enabled() to return false, shouldn't it?
>>>
>>> Is there an erratum for this?  How do we know this device has a bug
>>> in relaxed ordering?
>>
>> https://software.intel.com/content/www/us/en/develop/download/intel-64-and-ia-32-architectures-optimization-reference-manual.html
>>
>> For some reason they weren't documented in the errata, but under
>> Optimization manual :-)
>>
>> Table 3-7. Intel Processor CPU RP Device IDs for Processors Optimizing PCIe
>> Performance
>> Processor CPU RP Device IDs
>> Intel Xeon processors based on Broadwell microarchitecture 6F01H-6F0EH
>> Intel Xeon processors based on Haswell microarchitecture 2F01H-2F0EH
>>
>> These are the two that were listed in the manual. drivers/pci/quirks.c also
>> has an eloborate list of root ports where relaxed_ordering is disabled. Did
>> you check if its not already covered here?
>>
>> Send lspci if its not already covered by this table.

Attached lspci -vm output
>>
> 
> Looks like the chip series is not in the errta list, but it is really difficult to distinguish and test.

Does Intel plan to send a fixing patch that will go to -stable?
> 
>>
>>>
>>>> In addition, we are worried about future bugs in new CPUs which may result
>>>> in performance degradation while using RO, as long as the function
>>>> pcie_relaxed_ordering_enabled() will return true for these CPUs.
>>>
>>> I'm worried about this too.  I do not want to add a Device ID to the
>>> quirk_relaxedordering_disable() list for every new Intel CPU.  That's
>>> a huge hassle and creates a real problem for old kernels running on
>>> those new CPUs, because things might work "most of the time" but not
>>> always.

Please advise how to move forward
>>
>> I'll check when this is fixed, i was told newer ones should work properly.
>> But I'll confirm.

Any updates?
This is important information to proceed
>>
> 
> Maybe prevent the Relax Ordering for all Intel CPUs is a better soluton, looks like
> it will not break anything.

Should I provide this patch?

Aya.
> 
> Ding
>>
>> .
>>
> 

--------------529B64CB102D136515C537B8
Content-Type: text/plain; charset=UTF-8;
 name="lspci_vm.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lspci_vm.txt"

00:00.0 0600: 8086:2f00 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [90] Express Root Port (Slot-), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Capabilities: [144] Vendor Specific Information: ID=0004 Rev=1 Len=03c <?>
	Capabilities: [1d0] Vendor Specific Information: ID=0003 Rev=1 Len=00a <?>
	Capabilities: [280] Vendor Specific Information: ID=0005 Rev=3 Len=018 <?>
	Capabilities: [300] Vendor Specific Information: ID=0008 Rev=0 Len=038 <?>

00:01.0 0604: 8086:2f02 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: 93c00000-93dfffff
	Capabilities: [40] Subsystem: 8086:0000
	Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
	Capabilities: [90] Express Root Port (Slot-), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Capabilities: [110] Access Control Services
	Capabilities: [148] Advanced Error Reporting
	Capabilities: [1d0] Vendor Specific Information: ID=0003 Rev=1 Len=00a <?>
	Capabilities: [250] #19
	Capabilities: [280] Vendor Specific Information: ID=0005 Rev=3 Len=018 <?>
	Capabilities: [300] Vendor Specific Information: ID=0008 Rev=0 Len=038 <?>
	Kernel driver in use: pcieport

00:02.0 0604: 8086:2f04 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	Memory behind bridge: 93f00000-947fffff
	Prefetchable memory behind bridge: 0000000090000000-0000000091ffffff
	Capabilities: [40] Subsystem: 8086:0000
	Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
	Capabilities: [90] Express Root Port (Slot+), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Capabilities: [110] Access Control Services
	Capabilities: [148] Advanced Error Reporting
	Capabilities: [1d0] Vendor Specific Information: ID=0003 Rev=1 Len=00a <?>
	Capabilities: [250] #19
	Capabilities: [280] Vendor Specific Information: ID=0005 Rev=3 Len=018 <?>
	Capabilities: [300] Vendor Specific Information: ID=0008 Rev=0 Len=038 <?>
	Kernel driver in use: pcieport

00:03.0 0604: 8086:2f08 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	Memory behind bridge: 94800000-948fffff
	Prefetchable memory behind bridge: 0000000093a00000-0000000093afffff
	Capabilities: [40] Subsystem: 8086:0000
	Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
	Capabilities: [90] Express Root Port (Slot-), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Capabilities: [110] Access Control Services
	Capabilities: [148] Advanced Error Reporting
	Capabilities: [1d0] Vendor Specific Information: ID=0003 Rev=1 Len=00a <?>
	Capabilities: [250] #19
	Capabilities: [280] Vendor Specific Information: ID=0005 Rev=3 Len=018 <?>
	Capabilities: [300] Vendor Specific Information: ID=0008 Rev=0 Len=038 <?>
	Kernel driver in use: pcieport

00:03.1 0604: 8086:2f09 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	Memory behind bridge: 94900000-949fffff
	Prefetchable memory behind bridge: 0000000093b00000-0000000093bfffff
	Capabilities: [40] Subsystem: 8086:0000
	Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
	Capabilities: [90] Express Root Port (Slot-), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Capabilities: [110] Access Control Services
	Capabilities: [148] Advanced Error Reporting
	Capabilities: [1d0] Vendor Specific Information: ID=0003 Rev=1 Len=00a <?>
	Capabilities: [250] #19
	Capabilities: [280] Vendor Specific Information: ID=0005 Rev=3 Len=018 <?>
	Capabilities: [300] Vendor Specific Information: ID=0008 Rev=0 Len=038 <?>
	Kernel driver in use: pcieport

00:03.2 0604: 8086:2f0a (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	Memory behind bridge: 94a00000-95bfffff
	Prefetchable memory behind bridge: 0000033ffc000000-0000033fffffffff
	Capabilities: [40] Subsystem: 8086:0000
	Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
	Capabilities: [90] Express Root Port (Slot+), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Capabilities: [110] Access Control Services
	Capabilities: [148] Advanced Error Reporting
	Capabilities: [1d0] Vendor Specific Information: ID=0003 Rev=1 Len=00a <?>
	Capabilities: [250] #19
	Capabilities: [280] Vendor Specific Information: ID=0005 Rev=3 Len=018 <?>
	Capabilities: [300] Vendor Specific Information: ID=0008 Rev=0 Len=038 <?>
	Kernel driver in use: pcieport

00:05.0 0880: 8086:2f28 (rev 02)
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:05.1 0880: 8086:2f29 (rev 02)
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [100] Vendor Specific Information: ID=0006 Rev=1 Len=010 <?>
	Capabilities: [110] Vendor Specific Information: ID=0006 Rev=1 Len=010 <?>
	Capabilities: [120] Vendor Specific Information: ID=0006 Rev=1 Len=010 <?>
	Capabilities: [130] Vendor Specific Information: ID=0006 Rev=1 Len=010 <?>

00:05.2 0880: 8086:2f2a (rev 02)
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:05.4 0800: 8086:2f2c (rev 02) (prog-if 20 [IO(X)-APIC])
	Subsystem: 8086:0000
	Flags: bus master, fast devsel, latency 0
	Memory at 93e08000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3

00:05.6 1101: 8086:2f39 (rev 02)
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
	Kernel driver in use: hswep_uncore

00:06.0 0880: 8086:2f10 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Vendor Specific Information: ID=0001 Rev=0 Len=0b8 <?>

00:06.1 0880: 8086:2f11 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Vendor Specific Information: ID=0001 Rev=0 Len=0b8 <?>

00:06.2 0880: 8086:2f12 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:06.3 0880: 8086:2f13 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Vendor Specific Information: ID=0001 Rev=0 Len=0b8 <?>

00:06.4 0880: 8086:2f14 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:06.5 0880: 8086:2f15 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:06.6 0880: 8086:2f16 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:06.7 0880: 8086:2f17 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:07.0 0880: 8086:2f18 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Vendor Specific Information: ID=0001 Rev=0 Len=0b8 <?>

00:07.1 0880: 8086:2f19 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:07.2 0880: 8086:2f1a (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:07.3 0880: 8086:2f1b (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:07.4 0880: 8086:2f1c (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:11.0 ff00: 8086:8d7c (rev 05)
	Subsystem: 1028:0600
	Flags: bus master, fast devsel, latency 0
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [80] Power Management version 3

00:11.4 0106: 8086:8d62 (rev 05) (prog-if 01 [AHCI 1.0])
	Subsystem: 1028:0600
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 80
	I/O ports at 3078 [size=8]
	I/O ports at 308c [size=4]
	I/O ports at 3070 [size=8]
	I/O ports at 3088 [size=4]
	I/O ports at 3040 [size=32]
	Memory at 93e02000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [70] Power Management version 3
	Capabilities: [a8] SATA HBA v1.0
	Kernel driver in use: ahci

00:16.0 0780: 8086:8d3a (rev 05)
	Subsystem: 1028:0600
	Flags: bus master, fast devsel, latency 0, IRQ 255
	Memory at 93e07000 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
	Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+

00:16.1 0780: 8086:8d3b (rev 05)
	Subsystem: 1028:0600
	Flags: bus master, fast devsel, latency 0, IRQ 255
	Memory at 93e06000 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
	Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+

00:1a.0 0c03: 8086:8d2d (rev 05) (prog-if 20 [EHCI])
	Subsystem: 1028:0600
	Flags: bus master, medium devsel, latency 0, IRQ 18
	Memory at 93e04000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
	Kernel driver in use: ehci-pci

00:1c.0 0604: 8086:8d10 (rev d5) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	Capabilities: [40] Express Root Port (Slot-), MSI 00
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: 1028:0600
	Capabilities: [a0] Power Management version 3
	Kernel driver in use: pcieport

00:1c.7 0604: 8086:8d1e (rev d5) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=07, subordinate=0b, sec-latency=0
	Memory behind bridge: 93000000-939fffff
	Prefetchable memory behind bridge: 0000000092000000-0000000092ffffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: 1028:0600
	Capabilities: [a0] Power Management version 3
	Capabilities: [100] Advanced Error Reporting
	Kernel driver in use: pcieport

00:1d.0 0c03: 8086:8d26 (rev 05) (prog-if 20 [EHCI])
	Subsystem: 1028:0600
	Flags: bus master, medium devsel, latency 0, IRQ 18
	Memory at 93e03000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
	Kernel driver in use: ehci-pci

00:1f.0 0601: 8086:8d44 (rev 05)
	Subsystem: 1028:0600
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel driver in use: lpc_ich

00:1f.2 0106: 8086:8d02 (rev 05) (prog-if 01 [AHCI 1.0])
	Subsystem: 1028:0600
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 81
	I/O ports at 3068 [size=8]
	I/O ports at 3084 [size=4]
	I/O ports at 3060 [size=8]
	I/O ports at 3080 [size=4]
	I/O ports at 3020 [size=32]
	Memory at 93e01000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [70] Power Management version 3
	Capabilities: [a8] SATA HBA v1.0
	Kernel driver in use: ahci

01:00.0 0200: 14e4:165f
	Subsystem: 1028:1f5b
	Flags: bus master, fast devsel, latency 0, IRQ 82
	Memory at 93b30000 (64-bit, prefetchable) [size=64K]
	Memory at 93b40000 (64-bit, prefetchable) [size=64K]
	Memory at 93b50000 (64-bit, prefetchable) [size=64K]
	Expansion ROM at 94900000 [disabled] [size=256K]
	Capabilities: [48] Power Management version 3
	Capabilities: [50] Vital Product Data
	Capabilities: [58] MSI: Enable- Count=1/8 Maskable- 64bit+
	Capabilities: [a0] MSI-X: Enable+ Count=17 Masked-
	Capabilities: [ac] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [13c] Device Serial Number 00-00-b0-83-fe-cf-d4-05
	Capabilities: [150] Power Budgeting <?>
	Capabilities: [160] Virtual Channel
	Kernel driver in use: tg3

01:00.1 0200: 14e4:165f
	Subsystem: 1028:1f5b
	Flags: bus master, fast devsel, latency 0, IRQ 83
	Memory at 93b00000 (64-bit, prefetchable) [size=64K]
	Memory at 93b10000 (64-bit, prefetchable) [size=64K]
	Memory at 93b20000 (64-bit, prefetchable) [size=64K]
	Expansion ROM at 94940000 [disabled] [size=256K]
	Capabilities: [48] Power Management version 3
	Capabilities: [50] Vital Product Data
	Capabilities: [58] MSI: Enable- Count=1/8 Maskable- 64bit+
	Capabilities: [a0] MSI-X: Enable- Count=17 Masked-
	Capabilities: [ac] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [13c] Device Serial Number 00-00-b0-83-fe-cf-d4-06
	Capabilities: [150] Power Budgeting <?>
	Capabilities: [160] Virtual Channel
	Kernel driver in use: tg3

02:00.0 0200: 14e4:165f
	Subsystem: 1028:1f5b
	Flags: bus master, fast devsel, latency 0, IRQ 84
	Memory at 93a30000 (64-bit, prefetchable) [size=64K]
	Memory at 93a40000 (64-bit, prefetchable) [size=64K]
	Memory at 93a50000 (64-bit, prefetchable) [size=64K]
	Expansion ROM at 94800000 [disabled] [size=256K]
	Capabilities: [48] Power Management version 3
	Capabilities: [50] Vital Product Data
	Capabilities: [58] MSI: Enable- Count=1/8 Maskable- 64bit+
	Capabilities: [a0] MSI-X: Enable- Count=17 Masked-
	Capabilities: [ac] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [13c] Device Serial Number 00-00-b0-83-fe-cf-d4-07
	Capabilities: [150] Power Budgeting <?>
	Capabilities: [160] Virtual Channel
	Kernel driver in use: tg3

02:00.1 0200: 14e4:165f
	Subsystem: 1028:1f5b
	Flags: bus master, fast devsel, latency 0, IRQ 85
	Memory at 93a00000 (64-bit, prefetchable) [size=64K]
	Memory at 93a10000 (64-bit, prefetchable) [size=64K]
	Memory at 93a20000 (64-bit, prefetchable) [size=64K]
	Expansion ROM at 94840000 [disabled] [size=256K]
	Capabilities: [48] Power Management version 3
	Capabilities: [50] Vital Product Data
	Capabilities: [58] MSI: Enable- Count=1/8 Maskable- 64bit+
	Capabilities: [a0] MSI-X: Enable- Count=17 Masked-
	Capabilities: [ac] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [13c] Device Serial Number 00-00-b0-83-fe-cf-d4-08
	Capabilities: [150] Power Budgeting <?>
	Capabilities: [160] Virtual Channel
	Kernel driver in use: tg3

03:00.0 0104: 1000:005d (rev 02)
	Subsystem: 1028:1f49
	Flags: bus master, fast devsel, latency 0, IRQ 37
	I/O ports at 2000 [size=256]
	Memory at 93d00000 (64-bit, non-prefetchable) [size=64K]
	Memory at 93c00000 (64-bit, non-prefetchable) [size=1M]
	Expansion ROM at <ignored> [disabled]
	Capabilities: [50] Power Management version 3
	Capabilities: [68] Express Endpoint, MSI 00
	Capabilities: [d0] Vital Product Data
	Capabilities: [a8] MSI: Enable- Count=1/1 Maskable+ 64bit+
	Capabilities: [c0] MSI-X: Enable+ Count=97 Masked-
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [1e0] #19
	Capabilities: [1c0] Power Budgeting <?>
	Capabilities: [190] #16
	Capabilities: [148] Alternative Routing-ID Interpretation (ARI)
	Kernel driver in use: megaraid_sas

04:00.0 0200: 15b3:101d
	Subsystem: 15b3:0047
	Flags: bus master, fast devsel, latency 0, IRQ 91
	Memory at 90000000 (64-bit, prefetchable) [size=32M]
	Expansion ROM at 93f00000 [disabled] [size=1M]
	Capabilities: [60] Express Endpoint, MSI 00
	Capabilities: [48] Vital Product Data
	Capabilities: [9c] MSI-X: Enable+ Count=64 Masked-
	Capabilities: [c0] Vendor Specific Information: Len=18 <?>
	Capabilities: [40] Power Management version 3
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
	Capabilities: [180] Single Root I/O Virtualization (SR-IOV)
	Capabilities: [1c0] #19
	Capabilities: [320] #27
	Capabilities: [370] #26
	Capabilities: [420] #25
	Kernel driver in use: mlx5_core

05:00.0 0200: 15b3:1017
	Subsystem: 15b3:0020
	Flags: bus master, fast devsel, latency 0, IRQ 133
	Memory at 33ffe000000 (64-bit, prefetchable) [size=32M]
	Expansion ROM at 94a00000 [disabled] [size=1M]
	Capabilities: [60] Express Endpoint, MSI 00
	Capabilities: [48] Vital Product Data
	Capabilities: [9c] MSI-X: Enable+ Count=64 Masked-
	Capabilities: [c0] Vendor Specific Information: Len=18 <?>
	Capabilities: [40] Power Management version 3
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
	Capabilities: [180] Single Root I/O Virtualization (SR-IOV)
	Capabilities: [1c0] #19
	Capabilities: [230] Access Control Services
	Kernel driver in use: mlx5_core

05:00.1 0200: 15b3:1017
	Subsystem: 15b3:0020
	Flags: bus master, fast devsel, latency 0, IRQ 83
	Memory at 33ffc000000 (64-bit, prefetchable) [size=32M]
	Expansion ROM at 95300000 [disabled] [size=1M]
	Capabilities: [60] Express Endpoint, MSI 00
	Capabilities: [48] Vital Product Data
	Capabilities: [9c] MSI-X: Enable+ Count=64 Masked-
	Capabilities: [c0] Vendor Specific Information: Len=18 <?>
	Capabilities: [40] Power Management version 3
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
	Capabilities: [180] Single Root I/O Virtualization (SR-IOV)
	Capabilities: [230] Access Control Services
	Kernel driver in use: mlx5_core

07:00.0 0604: 1912:001d (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	BIST result: 00
	Bus: primary=07, secondary=08, subordinate=0b, sec-latency=0
	Memory behind bridge: 93000000-939fffff
	Prefetchable memory behind bridge: 0000000092000000-0000000092ffffff
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Upstream Port, MSI 00
	Capabilities: [b0] Subsystem: 1912:001d
	Capabilities: [100] Advanced Error Reporting
	Kernel driver in use: pcieport

08:00.0 0604: 1912:001d (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	BIST result: 00
	Bus: primary=08, secondary=09, subordinate=0a, sec-latency=0
	Memory behind bridge: 93000000-938fffff
	Prefetchable memory behind bridge: 0000000092000000-0000000092ffffff
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Downstream Port (Slot-), MSI 00
	Capabilities: [b0] Subsystem: 1912:001d
	Capabilities: [100] Advanced Error Reporting
	Kernel driver in use: pcieport

09:00.0 0604: 1912:001a (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	BIST result: 00
	Bus: primary=09, secondary=0a, subordinate=0a, sec-latency=0
	Memory behind bridge: 93000000-938fffff
	Prefetchable memory behind bridge: 0000000092000000-0000000092ffffff
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express PCI-Express to PCI/PCI-X Bridge, MSI 00
	Capabilities: [b0] Subsystem: 1912:001a
	Capabilities: [100] Advanced Error Reporting

0a:00.0 0300: 102b:0534 (rev 01) (prog-if 00 [VGA controller])
	Subsystem: 1028:0600
	Flags: bus master, medium devsel, latency 0, IRQ 19
	Memory at 92000000 (32-bit, prefetchable) [size=16M]
	Memory at 93800000 (32-bit, non-prefetchable) [size=16K]
	Memory at 93000000 (32-bit, non-prefetchable) [size=8M]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [dc] Power Management version 1
	Kernel driver in use: mgag200

7f:08.0 0880: 8086:2f80 (rev 02)
	Subsystem: 8086:2f80
	Flags: fast devsel

7f:08.2 1101: 8086:2f32 (rev 02)
	Subsystem: 8086:2f32
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

7f:08.3 0880: 8086:2f83 (rev 02)
	Subsystem: 8086:2f83
	Flags: fast devsel

7f:08.5 0880: 8086:2f85 (rev 02)
	Subsystem: 8086:2f85
	Flags: fast devsel

7f:08.6 0880: 8086:2f86 (rev 02)
	Subsystem: 8086:2f86
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

7f:08.7 0880: 8086:2f87 (rev 02)
	Subsystem: 8086:2f87
	Flags: fast devsel

7f:09.0 0880: 8086:2f90 (rev 02)
	Subsystem: 8086:2f90
	Flags: fast devsel

7f:09.2 1101: 8086:2f33 (rev 02)
	Subsystem: 8086:2f33
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

7f:09.3 0880: 8086:2f93 (rev 02)
	Subsystem: 8086:2f93
	Flags: fast devsel

7f:09.5 0880: 8086:2f95 (rev 02)
	Subsystem: 8086:2f95
	Flags: fast devsel

7f:09.6 0880: 8086:2f96 (rev 02)
	Subsystem: 8086:2f96
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

7f:0b.0 0880: 8086:2f81 (rev 02)
	Subsystem: 8086:2f81
	Flags: fast devsel

7f:0b.1 1101: 8086:2f36 (rev 02)
	Subsystem: 8086:2f36
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

7f:0b.2 1101: 8086:2f37 (rev 02)
	Subsystem: 8086:2f37
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

7f:0b.4 0880: 8086:2f41 (rev 02)
	Subsystem: 8086:2f41
	Flags: fast devsel

7f:0b.5 1101: 8086:2f3e (rev 02)
	Subsystem: 8086:2f3e
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

7f:0b.6 1101: 8086:2f3f (rev 02)
	Subsystem: 8086:2f3f
	Flags: fast devsel

7f:0c.0 0880: 8086:2fe0 (rev 02)
	Subsystem: 8086:2fe0
	Flags: fast devsel

7f:0c.1 0880: 8086:2fe1 (rev 02)
	Subsystem: 8086:2fe1
	Flags: fast devsel

7f:0c.2 0880: 8086:2fe2 (rev 02)
	Subsystem: 8086:2fe2
	Flags: fast devsel

7f:0c.3 0880: 8086:2fe3 (rev 02)
	Subsystem: 8086:2fe3
	Flags: fast devsel

7f:0c.4 0880: 8086:2fe4 (rev 02)
	Subsystem: 8086:2fe4
	Flags: fast devsel

7f:0c.5 0880: 8086:2fe5 (rev 02)
	Subsystem: 8086:2fe5
	Flags: fast devsel

7f:0c.6 0880: 8086:2fe6 (rev 02)
	Subsystem: 8086:2fe6
	Flags: fast devsel

7f:0c.7 0880: 8086:2fe7 (rev 02)
	Subsystem: 8086:2fe7
	Flags: fast devsel

7f:0d.0 0880: 8086:2fe8 (rev 02)
	Subsystem: 8086:2fe8
	Flags: fast devsel

7f:0d.1 0880: 8086:2fe9 (rev 02)
	Subsystem: 8086:2fe9
	Flags: fast devsel

7f:0f.0 0880: 8086:2ff8 (rev 02)
	Flags: fast devsel

7f:0f.1 0880: 8086:2ff9 (rev 02)
	Flags: fast devsel

7f:0f.2 0880: 8086:2ffa (rev 02)
	Flags: fast devsel

7f:0f.3 0880: 8086:2ffb (rev 02)
	Flags: fast devsel

7f:0f.4 0880: 8086:2ffc (rev 02)
	Subsystem: 8086:2fe0
	Flags: fast devsel

7f:0f.5 0880: 8086:2ffd (rev 02)
	Subsystem: 8086:2fe0
	Flags: fast devsel

7f:0f.6 0880: 8086:2ffe (rev 02)
	Subsystem: 8086:2fe0
	Flags: fast devsel

7f:10.0 0880: 8086:2f1d (rev 02)
	Subsystem: 8086:2f1d
	Flags: fast devsel

7f:10.1 1101: 8086:2f34 (rev 02)
	Subsystem: 8086:2f34
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

7f:10.5 0880: 8086:2f1e (rev 02)
	Subsystem: 8086:2f1e
	Flags: fast devsel

7f:10.6 1101: 8086:2f7d (rev 02)
	Subsystem: 8086:2f7d
	Flags: fast devsel

7f:10.7 0880: 8086:2f1f (rev 02)
	Subsystem: 8086:2f1f
	Flags: fast devsel

7f:12.0 0880: 8086:2fa0 (rev 02)
	Subsystem: 8086:2fa0
	Flags: fast devsel
	Kernel driver in use: sbridge_edac

7f:12.1 1101: 8086:2f30 (rev 02)
	Subsystem: 8086:2f30
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

7f:12.2 0880: 8086:2f70 (rev 02)
	Subsystem: 8086:2f70
	Flags: fast devsel

7f:12.4 0880: 8086:2f60 (rev 02)
	Subsystem: 8086:2f60
	Flags: fast devsel

7f:12.5 1101: 8086:2f38 (rev 02)
	Subsystem: 8086:2f38
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

7f:12.6 0880: 8086:2f78 (rev 02)
	Subsystem: 8086:2f78
	Flags: fast devsel

7f:13.0 0880: 8086:2fa8 (rev 02)
	Subsystem: 8086:2fa8
	Flags: fast devsel

7f:13.1 0880: 8086:2f71 (rev 02)
	Subsystem: 8086:2f71
	Flags: fast devsel

7f:13.2 0880: 8086:2faa (rev 02)
	Subsystem: 8086:2faa
	Flags: fast devsel

7f:13.3 0880: 8086:2fab (rev 02)
	Subsystem: 8086:2fab
	Flags: fast devsel

7f:13.4 0880: 8086:2fac (rev 02)
	Subsystem: 8086:2fac
	Flags: fast devsel

7f:13.5 0880: 8086:2fad (rev 02)
	Subsystem: 8086:2fad
	Flags: fast devsel

7f:13.6 0880: 8086:2fae (rev 02)
	Flags: fast devsel

7f:13.7 0880: 8086:2faf (rev 02)
	Flags: fast devsel

7f:14.0 0880: 8086:2fb0 (rev 02)
	Subsystem: 8086:2fb0
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

7f:14.1 0880: 8086:2fb1 (rev 02)
	Subsystem: 8086:2fb1
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

7f:14.2 0880: 8086:2fb2 (rev 02)
	Subsystem: 8086:2fb2
	Flags: fast devsel

7f:14.3 0880: 8086:2fb3 (rev 02)
	Subsystem: 8086:2fb3
	Flags: fast devsel

7f:14.4 0880: 8086:2fbc (rev 02)
	Flags: fast devsel

7f:14.5 0880: 8086:2fbd (rev 02)
	Flags: fast devsel

7f:14.6 0880: 8086:2fbe (rev 02)
	Flags: fast devsel

7f:14.7 0880: 8086:2fbf (rev 02)
	Flags: fast devsel

7f:15.0 0880: 8086:2fb4 (rev 02)
	Subsystem: 8086:2fb4
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

7f:15.1 0880: 8086:2fb5 (rev 02)
	Subsystem: 8086:2fb5
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

7f:15.2 0880: 8086:2fb6 (rev 02)
	Subsystem: 8086:2fb6
	Flags: fast devsel

7f:15.3 0880: 8086:2fb7 (rev 02)
	Subsystem: 8086:2fb7
	Flags: fast devsel

7f:16.0 0880: 8086:2f68 (rev 02)
	Subsystem: 8086:2f68
	Flags: fast devsel

7f:16.1 0880: 8086:2f79 (rev 02)
	Subsystem: 8086:2f79
	Flags: fast devsel

7f:16.2 0880: 8086:2f6a (rev 02)
	Subsystem: 8086:2f6a
	Flags: fast devsel

7f:16.3 0880: 8086:2f6b (rev 02)
	Subsystem: 8086:2f6b
	Flags: fast devsel

7f:16.4 0880: 8086:2f6c (rev 02)
	Subsystem: 8086:2f6c
	Flags: fast devsel

7f:16.5 0880: 8086:2f6d (rev 02)
	Subsystem: 8086:2f6d
	Flags: fast devsel

7f:16.6 0880: 8086:2f6e (rev 02)
	Flags: fast devsel

7f:16.7 0880: 8086:2f6f (rev 02)
	Flags: fast devsel

7f:17.0 0880: 8086:2fd0 (rev 02)
	Subsystem: 8086:2fd0
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

7f:17.1 0880: 8086:2fd1 (rev 02)
	Subsystem: 8086:2fd1
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

7f:17.2 0880: 8086:2fd2 (rev 02)
	Subsystem: 8086:2fd2
	Flags: fast devsel

7f:17.3 0880: 8086:2fd3 (rev 02)
	Subsystem: 8086:2fd3
	Flags: fast devsel

7f:17.4 0880: 8086:2fb8 (rev 02)
	Flags: fast devsel

7f:17.5 0880: 8086:2fb9 (rev 02)
	Flags: fast devsel

7f:17.6 0880: 8086:2fba (rev 02)
	Flags: fast devsel

7f:17.7 0880: 8086:2fbb (rev 02)
	Flags: fast devsel

7f:18.0 0880: 8086:2fd4 (rev 02)
	Subsystem: 8086:2fd4
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

7f:18.1 0880: 8086:2fd5 (rev 02)
	Subsystem: 8086:2fd5
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

7f:18.2 0880: 8086:2fd6 (rev 02)
	Subsystem: 8086:2fd6
	Flags: fast devsel

7f:18.3 0880: 8086:2fd7 (rev 02)
	Subsystem: 8086:2fd7
	Flags: fast devsel

7f:1e.0 0880: 8086:2f98 (rev 02)
	Subsystem: 8086:2f98
	Flags: fast devsel

7f:1e.1 0880: 8086:2f99 (rev 02)
	Subsystem: 8086:2f99
	Flags: fast devsel

7f:1e.2 0880: 8086:2f9a (rev 02)
	Subsystem: 8086:2f9a
	Flags: fast devsel

7f:1e.3 0880: 8086:2fc0 (rev 02)
	Subsystem: 8086:2fc0
	Flags: fast devsel
	I/O ports at <ignored> [disabled]
	Kernel driver in use: hswep_uncore

7f:1e.4 0880: 8086:2f9c (rev 02)
	Subsystem: 8086:2f9c
	Flags: fast devsel

7f:1f.0 0880: 8086:2f88 (rev 02)
	Flags: fast devsel

7f:1f.2 0880: 8086:2f8a (rev 02)
	Flags: fast devsel

80:01.0 0604: 8086:2f02 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=80, secondary=81, subordinate=81, sec-latency=0
	Capabilities: [40] Subsystem: 8086:0000
	Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
	Capabilities: [90] Express Root Port (Slot+), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Capabilities: [110] Access Control Services
	Capabilities: [148] Advanced Error Reporting
	Capabilities: [1d0] Vendor Specific Information: ID=0003 Rev=1 Len=00a <?>
	Capabilities: [250] #19
	Capabilities: [280] Vendor Specific Information: ID=0005 Rev=3 Len=018 <?>
	Capabilities: [300] Vendor Specific Information: ID=0008 Rev=0 Len=038 <?>
	Kernel driver in use: pcieport

80:02.0 0604: 8086:2f04 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=80, secondary=82, subordinate=82, sec-latency=0
	Memory behind bridge: c8100000-c90fffff
	Prefetchable memory behind bridge: 0000037ffc000000-0000037fffffffff
	Capabilities: [40] Subsystem: 8086:0000
	Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
	Capabilities: [90] Express Root Port (Slot+), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Capabilities: [110] Access Control Services
	Capabilities: [148] Advanced Error Reporting
	Capabilities: [1d0] Vendor Specific Information: ID=0003 Rev=1 Len=00a <?>
	Capabilities: [250] #19
	Capabilities: [280] Vendor Specific Information: ID=0005 Rev=3 Len=018 <?>
	Capabilities: [300] Vendor Specific Information: ID=0008 Rev=0 Len=038 <?>
	Kernel driver in use: pcieport

80:03.0 0604: 8086:2f08 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=80, secondary=83, subordinate=83, sec-latency=0
	Capabilities: [40] Subsystem: 8086:0000
	Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
	Capabilities: [90] Express Root Port (Slot+), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Capabilities: [110] Access Control Services
	Capabilities: [148] Advanced Error Reporting
	Capabilities: [1d0] Vendor Specific Information: ID=0003 Rev=1 Len=00a <?>
	Capabilities: [250] #19
	Capabilities: [280] Vendor Specific Information: ID=0005 Rev=3 Len=018 <?>
	Capabilities: [300] Vendor Specific Information: ID=0008 Rev=0 Len=038 <?>
	Kernel driver in use: pcieport

80:03.2 0604: 8086:2f0a (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=80, secondary=84, subordinate=84, sec-latency=0
	Capabilities: [40] Subsystem: 8086:0000
	Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
	Capabilities: [90] Express Root Port (Slot+), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Capabilities: [110] Access Control Services
	Capabilities: [148] Advanced Error Reporting
	Capabilities: [1d0] Vendor Specific Information: ID=0003 Rev=1 Len=00a <?>
	Capabilities: [250] #19
	Capabilities: [280] Vendor Specific Information: ID=0005 Rev=3 Len=018 <?>
	Capabilities: [300] Vendor Specific Information: ID=0008 Rev=0 Len=038 <?>
	Kernel driver in use: pcieport

80:05.0 0880: 8086:2f28 (rev 02)
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

80:05.1 0880: 8086:2f29 (rev 02)
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [100] Vendor Specific Information: ID=0006 Rev=1 Len=010 <?>
	Capabilities: [110] Vendor Specific Information: ID=0006 Rev=1 Len=010 <?>
	Capabilities: [120] Vendor Specific Information: ID=0006 Rev=1 Len=010 <?>
	Capabilities: [130] Vendor Specific Information: ID=0006 Rev=1 Len=010 <?>

80:05.2 0880: 8086:2f2a (rev 02)
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

80:05.4 0800: 8086:2f2c (rev 02) (prog-if 20 [IO(X)-APIC])
	Subsystem: 8086:0000
	Flags: bus master, fast devsel, latency 0
	Memory at c8000000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3

80:05.6 1101: 8086:2f39 (rev 02)
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
	Kernel driver in use: hswep_uncore

80:06.0 0880: 8086:2f10 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Vendor Specific Information: ID=0001 Rev=0 Len=0b8 <?>

80:06.1 0880: 8086:2f11 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Vendor Specific Information: ID=0001 Rev=0 Len=0b8 <?>

80:06.2 0880: 8086:2f12 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

80:06.3 0880: 8086:2f13 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Vendor Specific Information: ID=0001 Rev=0 Len=0b8 <?>

80:06.4 0880: 8086:2f14 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

80:06.5 0880: 8086:2f15 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

80:06.6 0880: 8086:2f16 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

80:06.7 0880: 8086:2f17 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

80:07.0 0880: 8086:2f18 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Vendor Specific Information: ID=0001 Rev=0 Len=0b8 <?>

80:07.1 0880: 8086:2f19 (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

80:07.2 0880: 8086:2f1a (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

80:07.3 0880: 8086:2f1b (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

80:07.4 0880: 8086:2f1c (rev 02)
	Subsystem: 8086:0000
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

82:00.0 0200: 15b3:101d
	Subsystem: 15b3:0043
	Flags: bus master, fast devsel, latency 0, IRQ 216
	Memory at 37ffe000000 (64-bit, prefetchable) [size=32M]
	Capabilities: [60] Express Endpoint, MSI 00
	Capabilities: [48] Vital Product Data
	Capabilities: [9c] MSI-X: Enable+ Count=64 Masked-
	Capabilities: [c0] Vendor Specific Information: Len=18 <?>
	Capabilities: [40] Power Management version 3
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
	Capabilities: [180] Single Root I/O Virtualization (SR-IOV)
	Capabilities: [1c0] #19
	Capabilities: [230] Access Control Services
	Capabilities: [320] #27
	Capabilities: [370] #26
	Capabilities: [420] #25
	Kernel driver in use: mlx5_core

82:00.1 0200: 15b3:101d
	Subsystem: 15b3:0043
	Flags: bus master, fast devsel, latency 0, IRQ 258
	Memory at 37ffc000000 (64-bit, prefetchable) [size=32M]
	Capabilities: [60] Express Endpoint, MSI 00
	Capabilities: [48] Vital Product Data
	Capabilities: [9c] MSI-X: Enable+ Count=64 Masked-
	Capabilities: [c0] Vendor Specific Information: Len=18 <?>
	Capabilities: [40] Power Management version 3
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
	Capabilities: [180] Single Root I/O Virtualization (SR-IOV)
	Capabilities: [230] Access Control Services
	Capabilities: [420] #25
	Kernel driver in use: mlx5_core

ff:08.0 0880: 8086:2f80 (rev 02)
	Subsystem: 8086:2f80
	Flags: fast devsel

ff:08.2 1101: 8086:2f32 (rev 02)
	Subsystem: 8086:2f32
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

ff:08.3 0880: 8086:2f83 (rev 02)
	Subsystem: 8086:2f83
	Flags: fast devsel

ff:08.5 0880: 8086:2f85 (rev 02)
	Subsystem: 8086:2f85
	Flags: fast devsel

ff:08.6 0880: 8086:2f86 (rev 02)
	Subsystem: 8086:2f86
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

ff:08.7 0880: 8086:2f87 (rev 02)
	Subsystem: 8086:2f87
	Flags: fast devsel

ff:09.0 0880: 8086:2f90 (rev 02)
	Subsystem: 8086:2f90
	Flags: fast devsel

ff:09.2 1101: 8086:2f33 (rev 02)
	Subsystem: 8086:2f33
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

ff:09.3 0880: 8086:2f93 (rev 02)
	Subsystem: 8086:2f93
	Flags: fast devsel

ff:09.5 0880: 8086:2f95 (rev 02)
	Subsystem: 8086:2f95
	Flags: fast devsel

ff:09.6 0880: 8086:2f96 (rev 02)
	Subsystem: 8086:2f96
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

ff:0b.0 0880: 8086:2f81 (rev 02)
	Subsystem: 8086:2f81
	Flags: fast devsel

ff:0b.1 1101: 8086:2f36 (rev 02)
	Subsystem: 8086:2f36
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

ff:0b.2 1101: 8086:2f37 (rev 02)
	Subsystem: 8086:2f37
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

ff:0b.4 0880: 8086:2f41 (rev 02)
	Subsystem: 8086:2f41
	Flags: fast devsel

ff:0b.5 1101: 8086:2f3e (rev 02)
	Subsystem: 8086:2f3e
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

ff:0b.6 1101: 8086:2f3f (rev 02)
	Subsystem: 8086:2f3f
	Flags: fast devsel

ff:0c.0 0880: 8086:2fe0 (rev 02)
	Subsystem: 8086:2fe0
	Flags: fast devsel

ff:0c.1 0880: 8086:2fe1 (rev 02)
	Subsystem: 8086:2fe1
	Flags: fast devsel

ff:0c.2 0880: 8086:2fe2 (rev 02)
	Subsystem: 8086:2fe2
	Flags: fast devsel

ff:0c.3 0880: 8086:2fe3 (rev 02)
	Subsystem: 8086:2fe3
	Flags: fast devsel

ff:0c.4 0880: 8086:2fe4 (rev 02)
	Subsystem: 8086:2fe4
	Flags: fast devsel

ff:0c.5 0880: 8086:2fe5 (rev 02)
	Subsystem: 8086:2fe5
	Flags: fast devsel

ff:0c.6 0880: 8086:2fe6 (rev 02)
	Subsystem: 8086:2fe6
	Flags: fast devsel

ff:0c.7 0880: 8086:2fe7 (rev 02)
	Subsystem: 8086:2fe7
	Flags: fast devsel

ff:0d.0 0880: 8086:2fe8 (rev 02)
	Subsystem: 8086:2fe8
	Flags: fast devsel

ff:0d.1 0880: 8086:2fe9 (rev 02)
	Subsystem: 8086:2fe9
	Flags: fast devsel

ff:0f.0 0880: 8086:2ff8 (rev 02)
	Flags: fast devsel

ff:0f.1 0880: 8086:2ff9 (rev 02)
	Flags: fast devsel

ff:0f.2 0880: 8086:2ffa (rev 02)
	Flags: fast devsel

ff:0f.3 0880: 8086:2ffb (rev 02)
	Flags: fast devsel

ff:0f.4 0880: 8086:2ffc (rev 02)
	Subsystem: 8086:2fe0
	Flags: fast devsel

ff:0f.5 0880: 8086:2ffd (rev 02)
	Subsystem: 8086:2fe0
	Flags: fast devsel

ff:0f.6 0880: 8086:2ffe (rev 02)
	Subsystem: 8086:2fe0
	Flags: fast devsel

ff:10.0 0880: 8086:2f1d (rev 02)
	Subsystem: 8086:2f1d
	Flags: fast devsel

ff:10.1 1101: 8086:2f34 (rev 02)
	Subsystem: 8086:2f34
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

ff:10.5 0880: 8086:2f1e (rev 02)
	Subsystem: 8086:2f1e
	Flags: fast devsel

ff:10.6 1101: 8086:2f7d (rev 02)
	Subsystem: 8086:2f7d
	Flags: fast devsel

ff:10.7 0880: 8086:2f1f (rev 02)
	Subsystem: 8086:2f1f
	Flags: fast devsel

ff:12.0 0880: 8086:2fa0 (rev 02)
	Subsystem: 8086:2fa0
	Flags: fast devsel

ff:12.1 1101: 8086:2f30 (rev 02)
	Subsystem: 8086:2f30
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

ff:12.2 0880: 8086:2f70 (rev 02)
	Subsystem: 8086:2f70
	Flags: fast devsel

ff:12.4 0880: 8086:2f60 (rev 02)
	Subsystem: 8086:2f60
	Flags: fast devsel

ff:12.5 1101: 8086:2f38 (rev 02)
	Subsystem: 8086:2f38
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

ff:12.6 0880: 8086:2f78 (rev 02)
	Subsystem: 8086:2f78
	Flags: fast devsel

ff:13.0 0880: 8086:2fa8 (rev 02)
	Subsystem: 8086:2fa8
	Flags: fast devsel

ff:13.1 0880: 8086:2f71 (rev 02)
	Subsystem: 8086:2f71
	Flags: fast devsel

ff:13.2 0880: 8086:2faa (rev 02)
	Subsystem: 8086:2faa
	Flags: fast devsel

ff:13.3 0880: 8086:2fab (rev 02)
	Subsystem: 8086:2fab
	Flags: fast devsel

ff:13.4 0880: 8086:2fac (rev 02)
	Subsystem: 8086:2fac
	Flags: fast devsel

ff:13.5 0880: 8086:2fad (rev 02)
	Subsystem: 8086:2fad
	Flags: fast devsel

ff:13.6 0880: 8086:2fae (rev 02)
	Flags: fast devsel

ff:13.7 0880: 8086:2faf (rev 02)
	Flags: fast devsel

ff:14.0 0880: 8086:2fb0 (rev 02)
	Subsystem: 8086:2fb0
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

ff:14.1 0880: 8086:2fb1 (rev 02)
	Subsystem: 8086:2fb1
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

ff:14.2 0880: 8086:2fb2 (rev 02)
	Subsystem: 8086:2fb2
	Flags: fast devsel

ff:14.3 0880: 8086:2fb3 (rev 02)
	Subsystem: 8086:2fb3
	Flags: fast devsel

ff:14.4 0880: 8086:2fbc (rev 02)
	Flags: fast devsel

ff:14.5 0880: 8086:2fbd (rev 02)
	Flags: fast devsel

ff:14.6 0880: 8086:2fbe (rev 02)
	Flags: fast devsel

ff:14.7 0880: 8086:2fbf (rev 02)
	Flags: fast devsel

ff:15.0 0880: 8086:2fb4 (rev 02)
	Subsystem: 8086:2fb4
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

ff:15.1 0880: 8086:2fb5 (rev 02)
	Subsystem: 8086:2fb5
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

ff:15.2 0880: 8086:2fb6 (rev 02)
	Subsystem: 8086:2fb6
	Flags: fast devsel

ff:15.3 0880: 8086:2fb7 (rev 02)
	Subsystem: 8086:2fb7
	Flags: fast devsel

ff:16.0 0880: 8086:2f68 (rev 02)
	Subsystem: 8086:2f68
	Flags: fast devsel

ff:16.1 0880: 8086:2f79 (rev 02)
	Subsystem: 8086:2f79
	Flags: fast devsel

ff:16.2 0880: 8086:2f6a (rev 02)
	Subsystem: 8086:2f6a
	Flags: fast devsel

ff:16.3 0880: 8086:2f6b (rev 02)
	Subsystem: 8086:2f6b
	Flags: fast devsel

ff:16.4 0880: 8086:2f6c (rev 02)
	Subsystem: 8086:2f6c
	Flags: fast devsel

ff:16.5 0880: 8086:2f6d (rev 02)
	Subsystem: 8086:2f6d
	Flags: fast devsel

ff:16.6 0880: 8086:2f6e (rev 02)
	Flags: fast devsel

ff:16.7 0880: 8086:2f6f (rev 02)
	Flags: fast devsel

ff:17.0 0880: 8086:2fd0 (rev 02)
	Subsystem: 8086:2fd0
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

ff:17.1 0880: 8086:2fd1 (rev 02)
	Subsystem: 8086:2fd1
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

ff:17.2 0880: 8086:2fd2 (rev 02)
	Subsystem: 8086:2fd2
	Flags: fast devsel

ff:17.3 0880: 8086:2fd3 (rev 02)
	Subsystem: 8086:2fd3
	Flags: fast devsel

ff:17.4 0880: 8086:2fb8 (rev 02)
	Flags: fast devsel

ff:17.5 0880: 8086:2fb9 (rev 02)
	Flags: fast devsel

ff:17.6 0880: 8086:2fba (rev 02)
	Flags: fast devsel

ff:17.7 0880: 8086:2fbb (rev 02)
	Flags: fast devsel

ff:18.0 0880: 8086:2fd4 (rev 02)
	Subsystem: 8086:2fd4
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

ff:18.1 0880: 8086:2fd5 (rev 02)
	Subsystem: 8086:2fd5
	Flags: fast devsel
	Kernel driver in use: hswep_uncore

ff:18.2 0880: 8086:2fd6 (rev 02)
	Subsystem: 8086:2fd6
	Flags: fast devsel

ff:18.3 0880: 8086:2fd7 (rev 02)
	Subsystem: 8086:2fd7
	Flags: fast devsel

ff:1e.0 0880: 8086:2f98 (rev 02)
	Subsystem: 8086:2f98
	Flags: fast devsel

ff:1e.1 0880: 8086:2f99 (rev 02)
	Subsystem: 8086:2f99
	Flags: fast devsel

ff:1e.2 0880: 8086:2f9a (rev 02)
	Subsystem: 8086:2f9a
	Flags: fast devsel

ff:1e.3 0880: 8086:2fc0 (rev 02)
	Subsystem: 8086:2fc0
	Flags: fast devsel
	I/O ports at <ignored> [disabled]
	Kernel driver in use: hswep_uncore

ff:1e.4 0880: 8086:2f9c (rev 02)
	Subsystem: 8086:2f9c
	Flags: fast devsel

ff:1f.0 0880: 8086:2f88 (rev 02)
	Flags: fast devsel

ff:1f.2 0880: 8086:2f8a (rev 02)
	Flags: fast devsel


--------------529B64CB102D136515C537B8--
