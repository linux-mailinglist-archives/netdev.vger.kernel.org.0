Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A30842337C
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 00:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236843AbhJEW35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 18:29:57 -0400
Received: from mga14.intel.com ([192.55.52.115]:17681 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236585AbhJEW34 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 18:29:56 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10128"; a="226185534"
X-IronPort-AV: E=Sophos;i="5.85,349,1624345200"; 
   d="scan'208";a="226185534"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2021 15:27:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,349,1624345200"; 
   d="scan'208";a="439691187"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga003.jf.intel.com with ESMTP; 05 Oct 2021 15:27:55 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 5 Oct 2021 15:27:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 5 Oct 2021 15:27:54 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 5 Oct 2021 15:27:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AnRliGqZuk08QzckjzryEVdjger/GFHCJWk5UaOdz1sVMxI+iPr+LskR715+3whvREo6wY5YtlcEn4xPPXy2n31RUPZVsUsCOVNZfO6LqIQi1L+Q0/5mtlK7WlmlQz8tToDFrerJXJLeFD8b0VpO03Ch6zmn+GoYG6Z52b6/kt+dfN4Gb1+lnjSebBc1VLuernHTzl+JhGKhR8kVjof2jVaLlOe61ctZLy8mzL5uCrvePeFVoqbAPxCi12CLCr8idAFUOL48m592vk7LBS8y3b+x1gXRj3sxzT7prcTABRGHU3SWDsP8XxFi0AFS7s3btunPQhguHoZ4kytNk5A3bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+ZXqJ1H6B1PnwW6L4/iYnzcQQ4XkQPbqt0SshdY9NU=;
 b=PolLmbEIWOAuCPyCW5q5euN6XNPdWWooNFtoQcJwWHgjA7qNHveHYnfV/m9x3tr5zv8px04bkZsRSxFzc9/TA2yIY/UGmA8ZMv/eFhymMdrpNEGl6poPH7qg9/E/Sl/uIXaztzLAyhWQ6NF5XNcRBuE0DpyvgDdAcgh8DqzjOCS7eFhW93u38m8OBeCs8cRVhkyK5GJ7FENRVCKSPXa0c3Sgw7H+7jy6ghiCTk/YrHOcQcGOEadJEFXkDOZtxJ4u/KpfGrH39PShlxrGbfYdcCh/c2cvxZjoDQ/arD7SCyVYzGERynyih3djW9eKB7z+VXZdZAdNez5NMVZIEuSiLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+ZXqJ1H6B1PnwW6L4/iYnzcQQ4XkQPbqt0SshdY9NU=;
 b=YqDw5zfbUvD3brroQArMqySOYqvnz8CqXQabuDsvnwbSHFCM/HYM5cbkhAHBbg1vXGxuxsjz9BppDisQ44LCkIAI100NGmwAm6dXARVrbm/X0aBghPv/xTm+NVHJrONqYt88Ei3ljWvNaJOlF+yp48invseOcpgN0rKmBF/bpto=
Authentication-Results: wp.pl; dkim=none (message not signed)
 header.d=none;wp.pl; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MWHPR11MB1982.namprd11.prod.outlook.com (2603:10b6:300:10f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 5 Oct
 2021 22:27:53 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::f49e:f942:1fe9:cbe4]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::f49e:f942:1fe9:cbe4%7]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 22:27:52 +0000
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     "Andreas K. Huettel" <andreas.huettel@ur.de>,
        Paul Menzel <pmenzel@molgen.mpg.de>
CC:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        "Jakub Kicinski" <kubakici@wp.pl>
References: <1823864.tdWV9SEqCh@kailua>
 <20211004074814.5900791a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <35dfc9e8-431c-362d-450e-4c6ac1e55434@molgen.mpg.de>
 <2944777.ktpJ11cQ8Q@pinacolada>
Subject: Re: [EXT] Re: [Intel-wired-lan] Intel I350 regression 5.10 -> 5.14
 ("The NVM Checksum Is Not Valid") [8086:1521]
Message-ID: <c75203e9-0ef4-20bd-87a5-ad0846863886@intel.com>
Date:   Tue, 5 Oct 2021 15:27:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <2944777.ktpJ11cQ8Q@pinacolada>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR17CA0085.namprd17.prod.outlook.com
 (2603:10b6:300:c2::23) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
Received: from [192.168.1.214] (50.39.107.76) by MWHPR17CA0085.namprd17.prod.outlook.com (2603:10b6:300:c2::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Tue, 5 Oct 2021 22:27:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 126adc91-39af-4c7e-c5c9-08d9884f5f07
X-MS-TrafficTypeDiagnostic: MWHPR11MB1982:
X-Microsoft-Antispam-PRVS: <MWHPR11MB198240F9A1E409C8B33CFBDD97AF9@MWHPR11MB1982.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ezNGgWAx7HjFXG+MkZDQsPhwxnsZTfi7Rk3BP7WhzdIq5T6f2XA+EVbr8dqjdrS+APKgfP/l95b3gYeJG631rl43DUVcPZIMW9MZejNQ/XrNbeJVpEKawEx1qFjoYRI98yXBpfDmueyYQjaCuXccdeolNYbLzuyzWMljx/R/DkTU+5k36oA4A/ZE6CCgx5JjIFfYnHT1B51lYMuR/qn1NPZkin1Prh4Yugln/FDtIvLBYvessY/2l1sR/OpefZGXmDAVWvONmrwagY4Ij8dc02bGYmmQq4ipHhJJKzFBPUe5XnjfAvtBj+njZDzhlowC5KZSYaOeSNfcZdOdw6c+wnPL7ZAv3HutXG0h9GJwY194THSyUqYpHbd2DGDyV0R4CJ5oTyfDQGxKLnxId78jgQyOz3mczhgQ8I2zjey/GQvVB1nFep/nWu0iiVEPRlToVUQIrwR8Egc7/H51iV8G1CvUicBsuKbRcsbqSUHaTXBYXdn0/ZLMZdbMq5Heg9ShUw+kFJ1+Cnnce6MC3cnvpb8DxBG2swIt6rGs5PtS0NtAwaJQzBtRH6truccgGUh4Y5O1yvDayR/DzgyMkY9oQcTBLlY3VF0pBkbHrzQxYnlztoOUH/2kReWWCB6oqKGUSR7RBXq4uoDDDyh9h2S9nQ2htMtgb7Ko9nfA/AGE/C9alKkZXsQ6jqMteklbRTHJZoVwJkBes0hM9UoduyD4FUMsO4AFeFBH82oFFV3vAiYBFsG81MNDzSyDq/v4hso9B2mpIAv0Kzeoq5AjbPfOL4Maqu4AWfWPCvMpAM9/6oqu2JTi0O7bOCa4zBzNjuLq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(16576012)(2906002)(508600001)(31696002)(966005)(66946007)(45080400002)(66476007)(4326008)(26005)(316002)(8676002)(66556008)(44832011)(186003)(956004)(110136005)(83380400001)(53546011)(86362001)(6486002)(2616005)(5660300002)(31686004)(8936002)(36756003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHZKRU0xQm5QR0VNUURMT1oya2RBNlovOWxSNzJ3VW1pTTIyMDQvdDNqOFlL?=
 =?utf-8?B?TjJKUkIyRVFXcklkeEp0YUtsbHFiak81R2orMUlIdzk5RElITUtDU3VLVHpC?=
 =?utf-8?B?SHpHemcwaW5wOVo1dHFyVHBKTUEwTFR3RENCQjFobFFiYzljUHl4aThnY1V3?=
 =?utf-8?B?bGV3TSs4Y0xaTzF4R1lOTEFMUXdBYml6Z21uYVdQMndFa1c0WG5sZDV5ZFBT?=
 =?utf-8?B?aXdPNk5TbGEvV09kQTkrQmwrcUFqZ2dwOTRFZmJKayt5TkdwSnhZTzduYkVh?=
 =?utf-8?B?SVFUQ3ZCTmNyQzlFUVVnSzNvNmYvSGFoK3JSMGpQTVI5T21iazA5MTFIRWFS?=
 =?utf-8?B?K3lVaGxZSXpKM1hxbCsrU3lXbHlOU01KRFl6d1NyZW82MmZnUDFuNDJBcTBu?=
 =?utf-8?B?bTJkekFiTjdVREgzWHArdVQ1RDV1VTZDKzJqZGpvdEttSGhmK2d5SUVFZGlP?=
 =?utf-8?B?alY2cldKSEszQ0duOGhqVW9sTDRmR0hOdEk3eVVpVDkwR0JGSEdKQTZ5NERo?=
 =?utf-8?B?a3MrQ3BCRjgvczE4MnZoMmlQbUF6VDIwaytqcnhwUlg0Y3RXYjZUQU1ZUzlw?=
 =?utf-8?B?Ti9jSStJUkZObktVV1N2UkZpZEt5Ym5lKzU3cUJaTkZBRDlEbmlOM0UrcHBj?=
 =?utf-8?B?Z3JRcTRvYUNtcUpOOVpDL3VsNFRhTHR2eWdTeTZRK3VwTHRRZ0o5ZWpaZ0o4?=
 =?utf-8?B?TlBETXEvbjYxYU1URCtTSTd5TnVaSUp3SnQ1ZW1UZjNubzZhb1RMV2d1bjV3?=
 =?utf-8?B?SldFWm5tUXh2aENaUFYva0FZWWJBbldWNU5obTR1blJILzVPcDRiWXFFemNK?=
 =?utf-8?B?MUlRL1lxeFdVVkNJSDVhVHpMUXBHRElXcUJmRkpBWUs1UVA1MlZIYjZmaDFR?=
 =?utf-8?B?UlRoNTNzN2UxNVVwSHc4TkZ0ekZKLzNLNTM3TUQ3aUJXYlhqa2laTGVmVjdQ?=
 =?utf-8?B?Ritrbi84TEdGVkFtblZSTmZlVlRkVDJzVlk2YW9vOW9pMk5XTXlYMTJWUUdU?=
 =?utf-8?B?c3JkWXNwSStFK3ZONzA5V0kra1Z2Q3JTTTJpZTJ1dE9uM0tGcGJnb3lvMG5T?=
 =?utf-8?B?WW9ZUU1XaGFCTVlxTkdmMy9LMi81alJQU3l4MGVGQXpxNXhOMzQvSTVrdjdu?=
 =?utf-8?B?L1dkSjlaNUgvaFZ4Q25JU09TaUh4Mm5HYmo4THE3ZnhUMG9vM2JyZm84bXFa?=
 =?utf-8?B?ajFKMGFkRnpKMThua2o5SnRJK2Z2eDhVMW5mTzV2cWZHNWxNUkpQQSt2Mk9K?=
 =?utf-8?B?cXZVdXYweEZnRTVWb0F3c1ZFeDhCd1YvOHhXbDV4bVNaYjRhUmdrZ05LZHJ0?=
 =?utf-8?B?SzFxQ2R3WEJWdk5NMWFrUEtNUlEzOW1XV3p5ZlVLODZDY3pTV0xiTCtPNnMw?=
 =?utf-8?B?R3JaMWRXQTY5VXQ2ckxTYlJGdXVxaWlmcE5jMWptc3h1cGg2UG4vZDFZZ2xS?=
 =?utf-8?B?V3FTRUIrdWV5cGh4akplQUk5cG9qYldIZEpaN2NrYUUxUVBHUlIwNE5CV0dp?=
 =?utf-8?B?MkFVWkJiSWNPYnFBQkFlRDVQWnN2cnBEL3k5STA0SjVPc1pHMmV0cUdRVjI3?=
 =?utf-8?B?SHR6VHc3cDg2ZDlrMXFaVHBGMHRIRjUxREwxMENQbXdrSUJTbTR1ZjY4OHJL?=
 =?utf-8?B?aE0rM0VsdVM2dVRYYXdJUTR1MW51eCs1eVNlRi9rWVhGZVA2NnhVc2wwd2Fu?=
 =?utf-8?B?c3FyaGVNY0ZZZ3JwWmJnTUs3TTlWTFFWZEVoYTNjeVpEMTRXVTZnWTkwVEdM?=
 =?utf-8?Q?cZiEq3+venMwdcs8KF8tVKSAJhMWpCpAYuSEfht?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 126adc91-39af-4c7e-c5c9-08d9884f5f07
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 22:27:52.8879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LVKf8w2lmTXzkrkHwstjLSa9amEwv5Yafk36VApydt7UItiAMXwtAUJmzjozYwEFEhblXGDE4seINK9FZWfphwzo9X9pfihJ7kPpFyFNImM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1982
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/2021 6:43 AM, Andreas K. Huettel wrote:
>>
>> What messages are new compared to the working Linux 5.10.59?
>>
> 
> I've uploaded the full boot logs to https://dev.gentoo.org/~dilfridge/igb/
> (both in a version with and without timestamps, for easy diff).
> 
> * I can't see anything that immediately points to the igb device (like a PCI id etc.) before the module is loaded. 
> * The main difference between the logs is many unrelated (?) i915 warnings in 5.10.59 because of the nonfunctional graphics.
> 
> The messages easily identifiable are:
> 
> huettel@pinacolada ~/tmp $ cat kernel-messages-5.10.59.txt |grep igb
> Oct  5 15:11:18 dilfridge kernel: [    2.090675] igb: Intel(R) Gigabit Ethernet Network Driver
> Oct  5 15:11:18 dilfridge kernel: [    2.090676] igb: Copyright (c) 2007-2014 Intel Corporation.
> Oct  5 15:11:18 dilfridge kernel: [    2.090728] igb 0000:01:00.0: enabling device (0000 -> 0002)

This line is missing below, it indicates that the kernel couldn't or
didn't power up the PCIe for some reason. We're looking for something
like ACPI or PCI patches (possibly PCI-Power management) to be the
culprit here.


> Oct  5 15:11:18 dilfridge kernel: [    2.094438] Modules linked in: igb(+) i915(+) iosf_mbi acpi_pad efivarfs
> Oct  5 15:11:18 dilfridge kernel: [    2.097287] Modules linked in: igb(+) i915(+) iosf_mbi acpi_pad efivarfs
> Oct  5 15:11:18 dilfridge kernel: [    2.098492] Modules linked in: igb(+) i915(+) iosf_mbi acpi_pad efivarfs
> Oct  5 15:11:18 dilfridge kernel: [    2.098787] Modules linked in: igb(+) i915(+) iosf_mbi acpi_pad efivarfs
> Oct  5 15:11:18 dilfridge kernel: [    2.173386] igb 0000:01:00.0: added PHC on eth0
> Oct  5 15:11:18 dilfridge kernel: [    2.173391] igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
> Oct  5 15:11:18 dilfridge kernel: [    2.173395] igb 0000:01:00.0: eth0: (PCIe:5.0Gb/s:Width x4) 6c:b3:11:23:d4:4c
> Oct  5 15:11:18 dilfridge kernel: [    2.173991] igb 0000:01:00.0: eth0: PBA No: H47819-001
> Oct  5 15:11:18 dilfridge kernel: [    2.173994] igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
> Oct  5 15:11:18 dilfridge kernel: [    2.174199] igb 0000:01:00.1: enabling device (0000 -> 0002)
> Oct  5 15:11:18 dilfridge kernel: [    2.261029] igb 0000:01:00.1: added PHC on eth1
> Oct  5 15:11:18 dilfridge kernel: [    2.261034] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
> Oct  5 15:11:18 dilfridge kernel: [    2.261038] igb 0000:01:00.1: eth1: (PCIe:5.0Gb/s:Width x4) 6c:b3:11:23:d4:4d
> Oct  5 15:11:18 dilfridge kernel: [    2.261772] igb 0000:01:00.1: eth1: PBA No: H47819-001
> Oct  5 15:11:18 dilfridge kernel: [    2.261776] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
> Oct  5 15:11:18 dilfridge kernel: [    2.265376] igb 0000:01:00.1 enp1s0f1: renamed from eth1
> Oct  5 15:11:18 dilfridge kernel: [    2.282514] igb 0000:01:00.0 enp1s0f0: renamed from eth0
> Oct  5 15:11:31 dilfridge kernel: [   17.585202] igb 0000:01:00.0 enp1s0f0: igb: enp1s0f0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
> 
> huettel@pinacolada ~/tmp $ cat kernel-messages-5.14.9.txt |grep igb
> Oct  5 02:38:31 dilfridge kernel: [    2.108606] igb: Intel(R) Gigabit Ethernet Network Driver
> Oct  5 02:38:31 dilfridge kernel: [    2.108608] igb: Copyright (c) 2007-2014 Intel Corporation.
> Oct  5 02:38:31 dilfridge kernel: [    2.108622] igb 0000:01:00.0: can't change power state from D3cold to D0 (config space inaccessible)

This is really the only message that matters. It indicates the config
space is inaccessible, and from the system/kernel's perspective, the
device is unplugged or not responding, or in a PCIe power state.


> Oct  5 02:38:31 dilfridge kernel: [    2.108918] igb 0000:01:00.0 0000:01:00.0 (uninitialized): PCIe link lost
> Oct  5 02:38:31 dilfridge kernel: [    2.418724] igb 0000:01:00.0: PHY reset is blocked due to SOL/IDER session.
> Oct  5 02:38:31 dilfridge kernel: [    4.148163] igb 0000:01:00.0: The NVM Checksum Is Not Valid
> Oct  5 02:38:31 dilfridge kernel: [    4.154891] igb: probe of 0000:01:00.0 failed with error -5
> Oct  5 02:38:31 dilfridge kernel: [    4.154904] igb 0000:01:00.1: can't change power state from D3cold to D0 (config space inaccessible)
> Oct  5 02:38:31 dilfridge kernel: [    4.155146] igb 0000:01:00.1 0000:01:00.1 (uninitialized): PCIe link lost
> Oct  5 02:38:31 dilfridge kernel: [    4.466904] igb 0000:01:00.1: PHY reset is blocked due to SOL/IDER session.
> Oct  5 02:38:31 dilfridge kernel: [    6.195528] igb 0000:01:00.1: The NVM Checksum Is Not Valid
> Oct  5 02:38:31 dilfridge kernel: [    6.200863] igb: probe of 0000:01:00.1 failed with error -5
> 
> 
>>>> Any advice on how to proceed? Willing to test patches and provide additional debug info.
>>
>> Without any ideas about the issue, please bisect the issue to find the 
>> commit introducing the regression, so it can be reverted/fixed to not 
>> violate Linux’ no-regression policy.
> 
> I'll start going through kernel versions (and later revisions) end of the week.

Thank you for helping the community figure out what is up here. I don't
believe that it is a driver bug/change that broke things, but anything
is possible. :-) Given what I saw above I wonder if you should try to
boot with pci_aspm=off

The best option is a bisect using git, but it will help to narrow things
down to a couple different kernel versions if that is the only option
you have.
