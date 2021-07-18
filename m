Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571F43CC830
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 10:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhGRIk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 04:40:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:51370 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhGRIkz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 04:40:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10048"; a="207818867"
X-IronPort-AV: E=Sophos;i="5.84,249,1620716400"; 
   d="scan'208";a="207818867"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2021 01:37:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,249,1620716400"; 
   d="scan'208";a="498357210"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Jul 2021 01:37:57 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Sun, 18 Jul 2021 01:37:57 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Sun, 18 Jul 2021 01:37:57 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Sun, 18 Jul 2021 01:37:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJy+DfMbTVX5c9xXB6NaEODJmVKbMVb5u6iaNs9GfUCyQHJ98LMGhYfg/KuoQ3Dhq8Dv92enhT4GiQC2KTSsusDmmEM/aNItHzDMHbADuzuousmRyZcqz+MDos8IJoE2LSvFq00qCbiJNApaMCzbC4d5pYEzA2oBESZ0gntgiVyFkMsAFhpFnBBIej7IXCmB1VnQMAr6kOscRroqwfNqB65NDobunmk5FxXUBkBmj3MsDaer8hIFyLkRvg9O2GWsC9sYhgugkbSVQjJfSCUfRhycNWUwyS+8SyQWzms03Y6o9dPwdX4QHzMKKEUZ71shyP46veTM+P1HNUpdt1sFtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yPdq7p/YqPHbnfOIZIPNvQX3c95a7FWns5rUdW9DvD8=;
 b=ax4Fpyv2RJukyrBquz5UtLU5JseWOlfpl0u1A3EiAO24TSahXOLF7i1e0F9QolCWkVah0GWoxWfvBl4hPKFzMRh9ONAFTfln7dIhyionUgYG+ClYOWXtJ8C8qzMd5DnUi9jGNXqah7hDk+7qyL4rA4QpVYsj4rerp0X+AVYzTeXF3t12cLw6ZtH5ECeeqcU4ZQYahBMD2yZoSxhLVel/Yb1v5CUzCGwlHOK3lYt9efh0AUP/jSBBhVARHDiA136VhJjboR4Zq2lYT57pvYpu04jtAE1JggfFsqhOl9TjihMOHb6c4vEuvAdK3Wv24vygI7JCz6LiocVH97mdpdmYSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yPdq7p/YqPHbnfOIZIPNvQX3c95a7FWns5rUdW9DvD8=;
 b=QM1Or+9EboCQwyv6fQrQUcCQ3xVmor3xW/dw3IsFWNhG7ISYa1U4F13IIZyCoUi26lRuUs0aDwPn18zZyU1gbM2+Nqcwsv9YaZizDHPD4PA/a98MAZbggiiPacQ7M5h3Jlv5r0+/HmgK+RXjgto7Kaj6HW9umhVTiup0zeZ7Mbg=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:6e::10)
 by MWHPR11MB1392.namprd11.prod.outlook.com (2603:10b6:300:24::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Sun, 18 Jul
 2021 08:37:54 +0000
Received: from CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::b856:1bc7:d077:6e74]) by CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::b856:1bc7:d077:6e74%4]) with mapi id 15.20.4331.031; Sun, 18 Jul 2021
 08:37:54 +0000
Subject: Re: [Intel-wired-lan] [PATCH 2/3] e1000e: Make mei_me active when
 e1000e is in use
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        <alexander.usyskin@intel.com>
CC:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "AceLan Kao" <acelan.kao@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        <devora.fuxbrumer@intel.com>, <alexander.usyskin@intel.com>,
        "Edri, Michael" <michael.edri@intel.com>
References: <20210712133500.1126371-1-kai.heng.feng@canonical.com>
 <20210712133500.1126371-2-kai.heng.feng@canonical.com>
 <3947d70a-58d0-df93-24f1-1899fd567534@intel.com>
 <CAAd53p79BwxPGRECYGrpCQbSJz8NY2WrG+AJCuaj89XNqCy59Q@mail.gmail.com>
 <16e188d5-f06e-23dc-2f71-c935240dd3b4@intel.com>
 <CAAd53p5Pyk80c0FjmqF9cjicNF8t0eTC7Y3BP-rWqW3O53K1Mg@mail.gmail.com>
From:   Sasha Neftin <sasha.neftin@intel.com>
Message-ID: <711813a8-50a6-36da-5d84-cc3c4f64a654@intel.com>
Date:   Sun, 18 Jul 2021 11:37:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
In-Reply-To: <CAAd53p5Pyk80c0FjmqF9cjicNF8t0eTC7Y3BP-rWqW3O53K1Mg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0027.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::14) To CO1PR11MB4787.namprd11.prod.outlook.com
 (2603:10b6:303:6e::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.168] (84.108.64.141) by FR3P281CA0027.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1c::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.12 via Frontend Transport; Sun, 18 Jul 2021 08:37:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d22846e3-f94f-4c9d-4896-08d949c75615
X-MS-TrafficTypeDiagnostic: MWHPR11MB1392:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB13927FC9167FDE1ECAF917B697E09@MWHPR11MB1392.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rAx29KQEpKJJ1JF39pzz9DQrq45wpDpQLCHj/fsifGBDSiGosau92pJ2QYKlqUnjMgv84KrRxGw3a5a9+WTOx8BEUDMjL+s7l9eazzhd9r52B66GBO7rFZX9EUMjqVfr9bFAhRJFnTPWSGBLmDdqNXjESErRQA8GaJjoSizlTnOPEAH0on0VVs/s5vxw4vXdkNinCS+qoQsuo0ZmtV9fW5zeeopCTAVm+o8jh5RH1fSjwu3q9tkCXW7mOhxIxktg/kyHWkoWH3tYLU7M0eLUy+Td03cdpAzpXr29gZUqdkZ6NfRo2jmoiZ9i53/jG9HPOia77TFW90094S3aYiMpiFgU/rEN+uQqWZNefVQhBNM7oCfH9eG7S2Wh+p7NgEChyTZZHwlHUTZXXXjoi/7qF+pzQwG7OadxSO6E72x4j6372OCiUmWko0GK5575XgeBsJuswGnuF/dDNrOBSr/iQ/cF5KU3ThQ8Fco3AC4VV44DYQ+4lt2rabGfuNs8NTJF+17Nx1WZT7epe2+Usku+agLPZXTWjYkjDraf37p2Em7wh3L5H4Zf7tK2MKV4aLRJqtMhRTXeEXuc2MaxMKiHUbfCTbDrLtMdyuFfujRiajfx8xk+KbpjF6Gn+240OMT0+xUbsDvA7Vx8V5r0Tb/syL+hrTQCixo0X+01E5kKB6S5JFwwoVi8htATLMzB0YeKV50fHJIQ66kdN3zSKk/wTkT6NshqVbZm6xYEM5tPkNY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4787.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(366004)(39860400002)(136003)(54906003)(6486002)(38100700002)(6636002)(956004)(2616005)(26005)(478600001)(186003)(44832011)(2906002)(5660300002)(53546011)(6666004)(31686004)(86362001)(36756003)(31696002)(4326008)(66476007)(83380400001)(110136005)(66946007)(66556008)(107886003)(16576012)(8936002)(8676002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEpqOS9QbVg0NWVDV3lNckh1TENnQmh0YjdjNWNCOEduWFZZTGZFMm5XV204?=
 =?utf-8?B?cHloN3ZXQkltb1dYcDA5ckUzajA2R2NtZ0YveHFFRkR4V3Q2bjNFN2pXUG5h?=
 =?utf-8?B?L084VXM0OUtZN2JUYjJBMUxYRnA3Y3RITWIraWh2ZEw5RVIrOFQrb0Y4NXRW?=
 =?utf-8?B?RDVQTHZvTEZBNFc2akQ0N1EwYUMrYVk5SUpzRDYrekJjY29lclJINnN6V1E2?=
 =?utf-8?B?czVXSkpNdUFsWGU5b0dJaGR1WVZDZFMydW5JdEVZRGFremNWY3diWEdKQ1hh?=
 =?utf-8?B?NWowT0NXMUpTRThIaXY0M3ZIekcrS2pMTTRvT0dSbmlKaXpsVlgrTjNBeFB3?=
 =?utf-8?B?MHdDY0ZPSjFIQXF2cHdvR2FBa2lGZ1Qzcnp1WWx1MUJyTVcvRGRVWHp6V2xU?=
 =?utf-8?B?Zy9VTFVoRDZkMFZSbE9uTFVYMzNQdkdzZzB6M25EZ2ZhOWFrYWFiRnprd3FJ?=
 =?utf-8?B?eDkyVlZyT1hHZUlKUURrdDRnOW5vNFl3QUtZRWNhRXJBV1p3dmk5enRwNzJn?=
 =?utf-8?B?UWsyTjR5RnhvNzN3ZCtUN09aLzkxcXFYNzZHY0d4SUNTakVyY3VlWjlmRXY2?=
 =?utf-8?B?ZjBsMUF4VFluK3dBQnJ5MHhHK0JVUm11aGh5S1NZeGlZTlphUURSbTMvRGpo?=
 =?utf-8?B?ME0xend5Wm1FemNna1VScExjeUZZbzNPL2RxNkpKK3pZcWlyUTMzN1BON3JY?=
 =?utf-8?B?WDlCMGpBVTNFdkliUWhQL3cxM1o5aHc4WkhGQ3l5Vk5GRWJXbWdwMFhYeXBw?=
 =?utf-8?B?c0MrVjBVOFVFNUtjR2lBaVc5S2kyTHNZM09qUUI4dHFVNFZBNGNYd1NCYWJ0?=
 =?utf-8?B?dHBYWFRsRFFjb1RhRnhXSmlyTHYzTWNKWk4wMTBXdnhXdlhIbldYR2dGSEN2?=
 =?utf-8?B?YnRob3N1OG5UVjR6cjNtMGwrb1hyaW1lYVBCR21MRmtvRFFhdDlqY2ZodWZn?=
 =?utf-8?B?SDFoUG9lb2JxNldhdjVZUGJidHZPV1liYlpxS2k4QzM3eUN6dE8zNTFXanNF?=
 =?utf-8?B?QUF1WUloZjd3c0NwOUY5ZUw4eDY4YXJBd0cvZzRHOTAyT2tsMklWdmoxdXhK?=
 =?utf-8?B?aWttaUtJejkycXhtS1BtMVdEM3ZKL3BSQUxSNXpFZnRLTFVWSHEwaU1TOVV2?=
 =?utf-8?B?M3YwREhpVWtyVGpnNjAvdFplVU5lSEdWUEkzRVAzK3gzVHh2MXl6d3F5NWh4?=
 =?utf-8?B?Zk55U05sOTRKSU1PNnMvRlVQNTBOZncvdkhkYktoK0NVeFphT3VXN29Yemlk?=
 =?utf-8?B?ZWdFb1EwcnRIY21KTjFIT2l1OXRGSkhDS294Ymk2NEZNR0dReTNLWTdjaHl0?=
 =?utf-8?B?elZ0U3JLZmp3RXJRNVp1YnRWR3VDZ3ROVE1nQ2FKT2dWTHo0MjBManpwZG5B?=
 =?utf-8?B?b09PRjNHNGtEd1ZtUmk2MVR5cEhzNWlvY0gzODhJVElSWkw5S0p6MCtvT0Jl?=
 =?utf-8?B?ZkJEQnRRdGFuSXJMcHY0STZrWWhHQ1ZFWUJHazdLc2V6ZHJyRVgyQzJ6V1l2?=
 =?utf-8?B?Y0tRTld1Z1F4UmlqUEZGOGVZNks0eGd2eVV1QlVkbWw0UkM1RlZCWk1pU2dS?=
 =?utf-8?B?VDZzMFliU04yckVydm1qdzdSYW11NE5WZ25URDY2dGNCdkxjaGc3SEF4amxl?=
 =?utf-8?B?bTZoNnZHOHFycWU1V0tsd3VCRWF1Vlo5MzJNMHYxVmdaOC9FcytPa1ZZTk1S?=
 =?utf-8?B?QVFzb0dNYk0xeHAvRmpXSDNCTk5MdmNnS2tLSVI3dDhZZytHaFJCN0JMaTVI?=
 =?utf-8?Q?88tNHM3Dsa2uE1iQ1lgX+YJlSoge9QvET6fHl9t?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d22846e3-f94f-4c9d-4896-08d949c75615
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4787.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2021 08:37:54.2455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VbqDSldA0oANs6jKWmZUrqnq8LViqWprE9tk1DcCvJstWQx/aL8WAaGPQQrUqOI6mJyJ+lnyRitIpStd4nYdvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1392
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/14/2021 12:52, Kai-Heng Feng wrote:
> On Wed, Jul 14, 2021 at 5:06 PM Ruinskiy, Dima <dima.ruinskiy@intel.com> wrote:
>>
>> On 14/07/2021 9:28, Kai-Heng Feng wrote:
>>>> I do not know how MEI driver affect 1Gbe driver - so, I would suggest to
>>>> involve our CSME engineer (alexander.usyskin@intel.com) and try to
>>>> investigate this problem.
>>>> Does this problem observed on Dell systems? As I heard no reproduction
>>>> on Intel's RVP platform.
>>>> Another question: does disable mei_me runpm solve your problem?
>>>
>>> Yes, disabling runpm on mei_me can workaround the issue, and that's
>>> essentially what this patch does by adding DL_FLAG_PM_RUNTIME |
>>> DL_FLAG_RPM_ACTIVE flag.
>>>
>>> Kai-Heng
>> Hi, Kai-Heng,
>>
>> If the goal of the patch is to essentially disable runpm on mei_me, then
>> why is the patch touching code in the e1000e driver?
> 
> We can put the workaround in e1000e, mei_me or as PCI quirk.
> But since the bug itself manifests in e1000e, I think it's more
> appropriate to put it here.
> 
> To be more specific, it doesn't disable runtime suspend on mei_me, it
> makes mei_me the power supplier of e1000e.
> So when e1000e can be runtime suspended (i.e. no link partner), mei_me
> can also get runtime suspended too.
>>
>> I agree with Sasha Neftin; it seems like the wrong location, and the
>> wrong way to do it, even if it currently works. We need to understand
>> what causes runpm of mei_me to adversely affect LAN Rx, and for this we
>> need the involvement of mei_me owners.
> 
> I think it's the right location, however I totally agree with your
> other arguments.
> There are many users already affected by this bug, so if a proper fix
> isn't available for now, the temporary workaround can help here.
Hello Kai-Heng,
The temporary workaround without root cause is vague. Please, let's work 
with the manageability FW engineer (alexander.usyskin@intel.com) and 
understand the root cause.
Also, here is interfere with runpm flow of CSME - we must their inputs.
sasha
> 
> Kai-Heng
> 
>>
>> --Dima
>> ---------------------------------------------------------------------
>> Intel Israel (74) Limited
>>
>> This e-mail and any attachments may contain confidential material for
>> the sole use of the intended recipient(s). Any review or distribution
>> by others is strictly prohibited. If you are not the intended
>> recipient, please contact the sender and delete all copies.
