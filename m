Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDAB3DC993
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 06:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhHAEQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 00:16:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:60255 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhHAEQA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Aug 2021 00:16:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10062"; a="200460790"
X-IronPort-AV: E=Sophos;i="5.84,285,1620716400"; 
   d="scan'208";a="200460790"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2021 21:15:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,285,1620716400"; 
   d="scan'208";a="582992840"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 31 Jul 2021 21:15:52 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Sat, 31 Jul 2021 21:15:51 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Sat, 31 Jul 2021 21:15:51 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Sat, 31 Jul 2021 21:15:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Sat, 31 Jul 2021 21:15:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EueMc6BGVZOaHr9dBnZ2SKqq+02QZTfYeG7R5KHx8vfrrB720L6uPHsuy6dz/JL14Gr/QbL9+2EKhTx6dEKLgSS1CzOpS3toYFbSJGIRIiH54AkYe99MK2KjNOOMEURsoeIoqhr/RDNB98qmczSsVBo1Vqr3ZQYWOmw9uMoK0mlzntC5WjJ3+qFblwRq63OqNqivbwI1AHES0H85UNafvFvHsky5ZnmB+rEwHhbiF+3ZrE6qqkJVmjQcBv2WNQhPV7GNcm7OscE2cFZxefz4ZCTog4EBZyRQUqLVwdjsYEiGd2oEr/fphlxDsfh1BiwOAliixImFHX9mUcD4xUZ/Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6A0xE5aelmbM4y+5AxoLgFGoJhEiqYPLb62zoFuG74=;
 b=BEF+LXqX7U5hzMBcHCWMqzht5IJsvEO+wagrbh6RQryOklJQOxzYgsjWHKA57dqHVUjY9rCDdCrwYp6WveyKa3O1XPEyYniLg1xgsvSVkIdSsbdj/Aeb4rpz9ouABuvlMaWfgltVj8KTWC3oktkGohubG+HoWA+2pCjsqUEmGjW1IQtIZqGo+pDHglaPVnWakZn6IvfRpeCT9kGXoFwKQA05qOYUfBDhiD7fsVQDOf0R/qUe4r243K+5v20i5Kj5dX104KXqvTBkEOgKFrhqfGT4/Bfc1hdnodKAfiO1objeSXuOrCFxHwnFtlwkQrR0nmM4+TqheT/9XDCE/o6X7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6A0xE5aelmbM4y+5AxoLgFGoJhEiqYPLb62zoFuG74=;
 b=AQQPw9961ZKKvepBSSRehS7T1uh6FaVThH7txwocRxj/ecIHtAevsNKlf6Yq6PCbB4i3ertlP9vGK36mslK58dKQXWtUTGCAu+zGT05uSEZimNWn19r0J6JNc6yAnnUlsOtKk1xWYym25X8ByE7lvrUeQ3OJJ3GdmoxeqY458nQ=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:6e::10)
 by MWHPR11MB1357.namprd11.prod.outlook.com (2603:10b6:300:2b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Sun, 1 Aug
 2021 04:15:50 +0000
Received: from CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::b856:1bc7:d077:6e74]) by CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::b856:1bc7:d077:6e74%4]) with mapi id 15.20.4373.026; Sun, 1 Aug 2021
 04:15:50 +0000
Subject: Re: [PATCH 3/3] e1000e: Serialize TGP e1000e PM ops
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        AceLan Kao <acelan.kao@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        <alexander.usyskin@intel.com>
References: <20210712133500.1126371-1-kai.heng.feng@canonical.com>
 <20210712133500.1126371-3-kai.heng.feng@canonical.com>
 <CAAd53p5B5f5U_J1L+SpjZ46AFEr1kMqwgqnF2dYKvDwY2x3GzA@mail.gmail.com>
From:   Sasha Neftin <sasha.neftin@intel.com>
Message-ID: <5be1929b-89b7-f24d-27bc-f07a59916c0b@intel.com>
Date:   Sun, 1 Aug 2021 07:15:41 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
In-Reply-To: <CAAd53p5B5f5U_J1L+SpjZ46AFEr1kMqwgqnF2dYKvDwY2x3GzA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MR2P264CA0112.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:33::28) To CO1PR11MB4787.namprd11.prod.outlook.com
 (2603:10b6:303:6e::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.168] (84.108.64.141) by MR2P264CA0112.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:33::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Sun, 1 Aug 2021 04:15:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c7b47a9-0322-411e-eed9-08d954a30b98
X-MS-TrafficTypeDiagnostic: MWHPR11MB1357:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB13579F2A3BA8E13294D1DB7597EE9@MWHPR11MB1357.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:207;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aT6bnaHRmyf4SJUTJjs3kwSSHDFavUG7tup1SCJ3SPaJbvjGz7WL22stu1l3fi5XuTrUIzvCHgNxrVO2b8AcxeZdrD2PxFJLe5R3EWGTFAd9bU7XxomY1w/orpW0xJBoSUJaMysSbgZd6+WMz0Hy0kTwsajhmsQ1tP8KjReyGvHDJO3xOXG7YaciZGYSuOgA0FJDbc8wP03TJpm24VqBsAAXX7jWHKs0ejDW5l/19QFYUxP3Isa16do4CSmE8sKweHGXQjHlzkox8JtUlEybAKGUaHzlMeN92PxxJk3rhUPQRFA3WxXzuRHItVrL3Dn+GrWSgxEQvZLCky+c0NKY6RRLqDafh8Cu8hwvvnsyqL+VX1mDg3qt/JSbnge8SDx7RZduHqv/d7AVUdHZX8gS2owv12lLOXfrDBfjlCVx0WSU8z9l/TNkWhDGB0G+Q1OSZ36RFAy/U/py/BzMEB5DxqKgFtJwAKBNS/QSrty7b5YSEZwkJgDVpUo/vAjUGJRH6eYyNz4pA1JQ2FMgLlZtxoWv1t+uYGoaMEm5sun3YY0DbndUQegyjwmdyqs3ETFIwVVtwkB1p00t3RFpXmGTxvJ+bQB5xXiPhdDvz9ip+0kAv94+uhw9wNIDpdr00uE1KLCxEtADF9QFyqKwvYB7Jr7Qs0OEzA051UcynnetRniTOcnyLjpMGy3UYw3e6r9zsOYoK5isIWtQDMmGV1dKUShNJRNChE/mPPsX7hJjy471HiLoIeM1khRdzsaifgMAnylBXzvF1m2m4o/gBIqfbR9/zZUAy+t6czOmozeI/JivdJ/nIFWrTlhNGKLlq/eo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4787.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(4326008)(38100700002)(107886003)(6486002)(956004)(2616005)(6916009)(31686004)(66476007)(8936002)(66946007)(66556008)(8676002)(36756003)(478600001)(53546011)(316002)(5660300002)(54906003)(31696002)(26005)(966005)(83380400001)(44832011)(6666004)(2906002)(16576012)(186003)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3BITnVoUkZPcHB4UHRwaEM4OGJqOGlXSm9QM0hDQ0YzbWUzVUNQS0k1T1I1?=
 =?utf-8?B?b2owSnRZUjcyUVBNODNBNVA4aERHTUJqU1hGazJuMWVPU0pFc2JOQ1JpMnBt?=
 =?utf-8?B?SXZjaHU5c1l4ekkreUxPSGlaVSsyeW9iVnVhSVdWblBkZ3hJMG1NTzZmNllE?=
 =?utf-8?B?QSt2TysrMmRVVmIzTGFLTW04dC9naTFldEd6VE12ZG8rVmNBTTJIOE5HcEdp?=
 =?utf-8?B?a2gzdWJ0bXhFMTZiMTdzL3M1WFFOcm1yZFhKem44SFpNa2ZDMHcwYy9lY0pB?=
 =?utf-8?B?U2wyK2xNVXREbkRZV0RqbkZVbDN0TTNkMmJoL0gxTFd1ZythTUdnV3lRWGZO?=
 =?utf-8?B?dVNPTS9NdzdvaWVWVjZmVmxGWE1tMTlLUDRiSEViNzhTTXpVZXhFM0l4b1lw?=
 =?utf-8?B?Z2FKanNROUxzZ2ZiaXVFRlJzaUVyVDlLMEpXalJDSi9RUzBCdWpSelJkQXdz?=
 =?utf-8?B?UitBdHcrcHNHMlI1ZDZkcjRrNG5CdVp6WFNWcEczS21oMTBIQUU2akE5djVl?=
 =?utf-8?B?UnMwcTJ2dnQzOWx0c0hRQWJKU3lUTlZGMDNBekxYRFd0WnpjMUNBZ2Jmdjhs?=
 =?utf-8?B?UWRGb0RLbkoxbWZzRlNKNWFoYk9lMG45QmtMcFpnT2pJZXdBVGtWbVhyU01I?=
 =?utf-8?B?RnRTSVNRSzlBNFJ5NGZVN2ZxYWNkWUk4TERXZkQ1eXRJam1vOVFDS2RIa29B?=
 =?utf-8?B?WG5VVG50WFpjcnhiaStGQ3pvRUJieE9NN1JLTWVWR3VsVUYyTTJsaFhXRnQ4?=
 =?utf-8?B?SEtxcHYwZFVycUlpWWFiZnliUS9KL1RrSkhWS0MwWDYwSXZ4S2twYUtNbzBG?=
 =?utf-8?B?ZEJvcFpYSDVnbTllRkh0cWRxV3g2Q05WL1RUL3I0cWhBVk0vR2p1WDFlU25w?=
 =?utf-8?B?WFYwdzRCSTF5amIzcDliZURKZ0c3WlRRY3FGQjYzelhOd1JIMEttbENiZDBr?=
 =?utf-8?B?T2VVeElaUDB3cnNyL25Kck9WMk1WY1k0Nllzc3BKR0MxYnlxT0EzWVNKVURo?=
 =?utf-8?B?cXQ3aVFHbkRVWlhpak1JekpvcUorOEk1M0hDUTFvL0l5c3Uyd1dPSzFCbGNG?=
 =?utf-8?B?M0FrR3o4VnBlK3g0Q2dWYnlIRDJVTE5TVjh0d0RDeFJudm9aQnhyYmV3cXE4?=
 =?utf-8?B?QS8xK0lXQ2oreHRGNWVWdVZpVkVoRGU1VXZyaE9qRzY4VFRKa2MxcUJkNkh0?=
 =?utf-8?B?MEdwcnRBelJ3M2RBRzkrSDczMWtXVnV3VklBaExTVXhSR3cxNkhBa2pJdElH?=
 =?utf-8?B?YmNWN1ZyTHgwZXRKcVFqWjFiTmtvVE9aK1R1ajZhM1dhZGVJTlZsTG5Wb2p0?=
 =?utf-8?B?eTY0U1FkRDN3NHZQMUR3L3l4V0FBREJyaW9tUWRkaENnTmFhYXhzTFI3SFNP?=
 =?utf-8?B?TEdsaWN6YmlLTHdTbWcxYXJYUDZtQU56NFIySlJobXorem1DQWtiTW9CdXRZ?=
 =?utf-8?B?Uk5oUy9PM3ZSbGQyeThrZG1KcFl0Nzg5VW5TRWFJczZmWWN3MG9EQ09NaDQ2?=
 =?utf-8?B?WEk3MTVxMkR1Q1grMGJkUGxhNzdtU2FTSEVYY3lGekx4VmIxWHVjYVR5anBO?=
 =?utf-8?B?eVMrYzdrM0xaQmE2ZXBZOXNIaEFnN1Raek56WDdtWTdkK3JVUXpTZGlYa3Fh?=
 =?utf-8?B?MkoranVDTDhVUFErM2U1N296ODF0a0wrQVl6S2tIeEJaMC9ickpNamZLWEt1?=
 =?utf-8?B?bWdPbnRPNUZMMm1Id1E3VmQwdURHYkRoRXhncEM3dDFxOU43N294emNyZ1Bv?=
 =?utf-8?Q?JacZYyUkFOZYr4wmbTfr2ALm0VqbKQC1fZMTegR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c7b47a9-0322-411e-eed9-08d954a30b98
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4787.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2021 04:15:50.2342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +041eyyB1lV7DIKZ2gJ0b/1qGEnGprKkSFSdlfOVpt+9DTY9DoIgyxRIyWvxUj2DvtvAEdksCTk6WUFtt/1t2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1357
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/2021 09:53, Kai-Heng Feng wrote:
> Hi Sasha,
> 
> On Mon, Jul 12, 2021 at 9:35 PM Kai-Heng Feng
> <kai.heng.feng@canonical.com> wrote:
>>
>> On TGL systems, PCI_COMMAND may randomly flip to 0 on system resume.
>> This is devastating to drivers that use pci_set_master(), like NVMe and
>> xHCI, to enable DMA in their resume routine, as pci_set_master() can
>> inadvertently disable PCI_COMMAND_IO and PCI_COMMAND_MEMORY, making
>> resources inaccessible.
>>
>> The issue is reproducible on all kernel releases, but the situation is
>> exacerbated by commit 6cecf02e77ab ("Revert "e1000e: disable s0ix entry
>> and exit flows for ME systems"").
>>
>> Seems like ME can do many things to other PCI devices until it's finally out of
>> ULP polling. So ensure e1000e PM ops are serialized by enforcing suspend/resume
>> order to workaround the issue.
>>
>> Of course this will make system suspend and resume a bit slower, but we
>> probably need to settle on this workaround until ME is fully supported.
>>
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=212039
>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> 
> Series "e1000e: Add handshake with the CSME to support s0ix" doesn't
> fix the issue, so this patch is still needed.
Hello Kai-Heng,
This problem is still under investigation by the ME team. Let's wait for 
their response.
Series "e1000e: Add handshake with the CSME to support s0ix" - support 
only s0ix flow on AMT/CSME none provisioned systems and not related to 
this problem.
> 
> Kai-Heng
> 
>> ---
>>   drivers/net/ethernet/intel/e1000e/netdev.c | 14 +++++++++++++-
>>   1 file changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
>> index e63445a8ce12..0244d3dd90a3 100644
>> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
>> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
>> @@ -7319,7 +7319,8 @@ static const struct net_device_ops e1000e_netdev_ops = {
>>
>>   static void e1000e_create_device_links(struct pci_dev *pdev)
>>   {
>> -       struct pci_dev *tgp_mei_me;
>> +       struct pci_bus *bus = pdev->bus;
>> +       struct pci_dev *tgp_mei_me, *p;
>>
>>          /* Find TGP mei_me devices and make e1000e power depend on mei_me */
>>          tgp_mei_me = pci_get_device(PCI_VENDOR_ID_INTEL, 0xa0e0, NULL);
>> @@ -7335,6 +7336,17 @@ static void e1000e_create_device_links(struct pci_dev *pdev)
>>                  pci_info(pdev, "System and runtime PM depends on %s\n",
>>                           pci_name(tgp_mei_me));
>>
>> +       /* Find other devices in the SoC and make them depend on e1000e */
>> +       list_for_each_entry(p, &bus->devices, bus_list) {
>> +               if (&p->dev == &pdev->dev || &p->dev == &tgp_mei_me->dev)
>> +                       continue;
>> +
>> +               if (device_link_add(&p->dev, &pdev->dev,
>> +                                   DL_FLAG_AUTOREMOVE_SUPPLIER))
>> +                       pci_info(p, "System PM depends on %s\n",
>> +                                pci_name(pdev));
>> +       }
>> +
>>          pci_dev_put(tgp_mei_me);
>>   }
>>
>> --
>> 2.31.1
>>
sasha
