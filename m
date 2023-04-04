Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C486D6F34
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 23:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235705AbjDDVoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 17:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236274AbjDDVom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 17:44:42 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD8610CA
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 14:44:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mPsX+vZBFbV/Lb1sweyvUWRgSEju5WTspOggRn8co6Fcf6rDLACHjm9/rknXoE9mUPS5bU7Coc5LHC8CjcWlND01uyzyHd9UWLKBfoUXC/u6ZvtyvnPziagQ2UGPjPo0ub4mCyDioSwsb6rP7e+pbwd+S5VcHZVvIDN0FsRsVKD4iCJsGQRDFmB7WvNepuLNAtDrPI3S+P7Gte/kKh1I+cezP0FhjwEeuN4JagpmmfzZSnExcVMQzSBIem/KTpRju6RSqAQtD40wnj/YEmronQa2G4WxGDhGjFrFIWXXjg/cRJvYeFAC0y8zpmK/IidcPm57JkFiLbc49UMC64WEqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2LdCBgswflwoErbPZV2hqzmaG9IVY3TDfcvnT5RC1V4=;
 b=AWCH0SUxU+dlVCgW9sfvmLKYwkbDjKyg2iMQaGn0kbkf8aWvctBh7fD1iLFDTGTLd3OKxAWZGBq3li8iQKtjpRjOCkkt15gJqy+mSuVvQP4qMTSGwXtv1cT0htj/sxwoVhI2Q74Ls5exI/C8HHuGeFFG58JbKK/0voTlkE+6xM2oP2ZELSi99OZ2/swrMksFnodB2uKn7uz+XfIflhNUrl8Kc2RTXaaxX12XnwGm7Z+LInu/CdBSI52ziywSt3hhfTKH/UhlCqGlHfE8d76ls18zjm54QyxZ6HIe2RWPeQw6HZqLXkfcqb6J/sOgNodA/1fN16hY/pgiB/nQnsrxZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2LdCBgswflwoErbPZV2hqzmaG9IVY3TDfcvnT5RC1V4=;
 b=Bom7jMZn+Oxz4o25RxjoLssQzSM2qT+iGb3J3M6RAarbhktctqHFOOKYTCE3kMJSCtTmO+PA34JOeDMlTSF8ZAersjuS1g8H1A+QHT8FwPEMuyYcZ5VHsmKRw6JZURhtep+Ife8QacE4zlljmPlFweL7TWviADzYyl+DvW4QLnE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH8PR12MB6914.namprd12.prod.outlook.com (2603:10b6:510:1cb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Tue, 4 Apr
 2023 21:44:38 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6254.033; Tue, 4 Apr 2023
 21:44:38 +0000
Message-ID: <a44770b2-ff3e-a88e-03c4-e7818b33333d@amd.com>
Date:   Tue, 4 Apr 2023 14:44:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v8 net-next 10/14] pds_core: add auxiliary_bus devices
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
References: <20230330234628.14627-1-shannon.nelson@amd.com>
 <20230330234628.14627-11-shannon.nelson@amd.com>
 <20230401182701.GA831478@unreal>
 <fc39973a-3f57-87d0-ff46-15a09e9b5f58@amd.com> <20230403061808.GA7387@unreal>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230403061808.GA7387@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::19) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH8PR12MB6914:EE_
X-MS-Office365-Filtering-Correlation-Id: aaf8a4ee-77af-4fb1-5464-08db3555ca27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8SU2g83/ghKeH9h7ORlWBFI44l2GOVcaY2KlP5m6F7KxrU6j2DWcPCU0rqnyvKRltWJP1DLt7ykNh7jJZtjLzlziSGzLIeOuJWIKJdDtmypkdACQVuSGNG2nBa0WKIlPug7rhqXjb8c6e2sSn8ZP+/0/guGp9myORtVpgql9MkeGT49Uc2V2WqHqfqAVnPF06feZouFbMV3vK3XEz1RbFUUMzRLCRBAe4y87V2ICUQyhEM1xbCf7n3U0t8Rz2H20rCIC1V6SzGTzREkbP5VfCcAA2ddjmbpdTF8ebd5ZUgxzRArVqLfDtNxhy9f4rS3g+RYk2UfS/dXMt1LKfD4IwPMp6rceLtv8y968ef5N3oEqiECqs9EmycVpk2mhhBqQdzgRsUxs/ciuiWwWASYwezvwF4/YlTYyBBuuznOtDv32G8FU3SRrXnTZd1O/xDsJaL3ILPS+9H464DQB1TJPzIum5ohtkxwcqPfr6LoQdKBw0ta60cOx2WL0l0TNPs2ciJgVCDuz/ktxOh78tdrvYbeLq2dOkvEvO0e5j6hu6ZzCKMyilSXGV2XCyzVkFkbq9wNv0iN48BmOb54ORMU8gIJuuisCxFxz42O0Nsm4/Uro4EnnwceNAzt8IvElVttSfJVXFZnWYKMHbFJ0rOn+n3HPPSiNfJLVNvFryfrYOsA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199021)(31686004)(66899021)(6666004)(4326008)(6916009)(41300700001)(6486002)(316002)(66946007)(66476007)(66556008)(36756003)(86362001)(31696002)(478600001)(8676002)(83380400001)(26005)(6506007)(2616005)(5660300002)(8936002)(2906002)(44832011)(53546011)(186003)(6512007)(38100700002)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWFCUmllMnlxOWdqYVp0czVPYVZGc055Qmx2WmZvRzFuMjl5RVNSMjk5TnBB?=
 =?utf-8?B?SnUyZXR2WldtMnR4MnBvQmtnKzN0MzR4ZFZnRHhhSkxBeXRITDJsMzQ3Z2pn?=
 =?utf-8?B?VHZyVDJ4bGdnNmdTcU5nYVd2enVMbDJyRDVsREZOMjAvRkxQb29MaVhFYjVE?=
 =?utf-8?B?TEZzSG54amdvL0RmSkgvaWVpbzV5SlBZa3B0a3YzKzcxSTA5OFN2am1iVHJy?=
 =?utf-8?B?Z0xUS2lxeDM1SkdONURvbXkreWZZamlHSFNyNHdYTWprQm5EWEtZUzAyeUVp?=
 =?utf-8?B?OUhvVGdHKzBRYjc2TG1QcTdLRHovcVhCdjYyVjZrS1gzdGIzYkhyRE5qbHJT?=
 =?utf-8?B?aHkwalVvQU5lQVYxQnBlaVd1a0RXL3J3MkQ5WkdDWUlZM1pZenJpNVZxSXNJ?=
 =?utf-8?B?M0krT3YwdTI5YlM5TWhIYUxGSllIVVliY1ZTVEtFUWk4TTRmUzBtaHA3bkFm?=
 =?utf-8?B?bG1hR3QyS1g2bnNVUk1ES1UvOS8rdUxzWjlFR283T0NneE9LeUMzYmRqMlhu?=
 =?utf-8?B?bm9lMkt0QkhKRGpVWERkYnVvdEFHQnVlbzVuWUU3SFk1Ry9wYnl4ZURqR2hX?=
 =?utf-8?B?MkMyYUV3STZXWndJOW44MjBlcFZsN0RzS1FuVmNPZ0xtV09MRE83N0IvUWVk?=
 =?utf-8?B?QWpSMy9qazcyOG1WNWZzc1BZYzVuZ3FYdlo4L2d6a1VHK2llalRQdlBMZnFn?=
 =?utf-8?B?cVpZdm00NkJOZ1JBdTVmUUlrREYrQXRyempxcE1qa2pORlJoWFVzeXhYOCs0?=
 =?utf-8?B?YllnTVAxa2YrRnl4aG51RnFqWm44U281TVVNRmFkem11bWtDd0tvSi9wNVRa?=
 =?utf-8?B?NmlnZjZBa1dUdDRIdWJkUFhGRkdsOWdaSXVGaXBHTzdJeW4rZHNaakMvTHZH?=
 =?utf-8?B?MWVmeHNwU2NQYlNyT3NJUGFHOUpBWjcydXlWbUQwM01USmdXUzVMeG93UitH?=
 =?utf-8?B?MHZpbzFvdWt0SERwdU1mNmx3OFJyUUFNUHhvRW5XUmFnaHFWZ0V6ZlhJSTlK?=
 =?utf-8?B?L3l1ZS9sdmIrRUVYYmZBSXJvZkc1UEVXTGRRVmcrWXFyb0MrZVYyQnpKaGFU?=
 =?utf-8?B?SGViVWJCTkRNNWFxMjllMVhpZWFJNjlTYWtpbmpoZDBWamZxeDZUWG52NGt6?=
 =?utf-8?B?T0x6NDVvMlVvaTBlN1NGU0FoNjVFb0RRREpnZXcxSTNZUmhoVXlkYk9lQ3dV?=
 =?utf-8?B?QlZTV0Z1amlhNXR4ZGFpM01XWUduaThTckExRmZiZXV2N01hTkNKMXlPL0FZ?=
 =?utf-8?B?dlRHWUpRNnJUaG9VdTJseDhCa3pFN2dwQW11MDJJUUZxd052cC9mMTVKWEoy?=
 =?utf-8?B?QWY4MWRzQnlCcllRb0g3WVI3NzFVeUM0TWhaSHVrYlpmc3JHVXlWeHR5cGVS?=
 =?utf-8?B?Y1RSenNRckQ4NElyMHlaTktNOUFQTEtWQy9qeHZteHY3c3F3bEl4TlpkU2pj?=
 =?utf-8?B?SURaczBzSXE0dEZrM2g4djhQNVN1Z3o2WWhTVTNkbnpEY3dkTWhHMjNmZU1B?=
 =?utf-8?B?Wkk5aHl0WXNvbndLV3p6T0gvV25iY0hXZWppbWhYRWlaY1U2WSs4RGJCbjho?=
 =?utf-8?B?S1k2eElFM1pmYmdMQjBGS0F0NDU5SlBSdElES1Q1NGNqenBOdG8wcXUwVmt1?=
 =?utf-8?B?M3RCSFQzMld6akJLZFRYYzBobWgvK0J6T1lHUUhNT2NSWmRwS3FtM2FyODVw?=
 =?utf-8?B?dmFQdTFnM1F6UWdDNlZSM2k0YXBpK0hvSTg2cCtsUExxNTFNTURLTUprV1Yr?=
 =?utf-8?B?eEVhZTU0QXZLcXZSTzEvT1BoY3FwcW94dnQrSUhQb2lkWm5sdGYxenIrWWhj?=
 =?utf-8?B?WjRBTlk2UmYxQmFjUnltU2YwTUU3SncxWkxmQWFKdytjZjU2TXJjY3NPd2h4?=
 =?utf-8?B?YnovaDIwWVQxYjcyanNUVTAwTmV0cWo5cFdrM1g2dXEzZGZKajQ2b05EUS8w?=
 =?utf-8?B?VTNGVWZRMTVBSVF1YWsxNytNei94OURaVWcxRnpod1NMdUdVUERWR1FacDA4?=
 =?utf-8?B?MUhETnMxNmxQNzhwQTFCNEc1U2FZelB2ZkdBWXlyRGJnS1FWcW1rUE5TK0xo?=
 =?utf-8?B?bkJLZ2NqZVdxZU5BQ3F0MHhaQjE0ZGQzVWhJL2p2SXFOejNIY1l3a3JEK1Jw?=
 =?utf-8?Q?bL1K0HBlMIBz0akzOoMU33tPV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf8a4ee-77af-4fb1-5464-08db3555ca27
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 21:44:38.4725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dkj8MYmBmaRwGZIGdPtWJIFFsaMEbymL2Di0fmXrRAY0kd3S4fZm6gQETQAYO6gnMaalinSX+tDzV3JiXh07HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6914
X-Spam-Status: No, score=-1.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/2/23 11:18 PM, Leon Romanovsky wrote:
> 
> On Sat, Apr 01, 2023 at 01:15:03PM -0700, Shannon Nelson wrote:
>> On 4/1/23 11:27 AM, Leon Romanovsky wrote:
>>>
>>> On Thu, Mar 30, 2023 at 04:46:24PM -0700, Shannon Nelson wrote:
>>>> An auxiliary_bus device is created for each vDPA type VF at VF probe
>>>> and destroyed at VF remove.  The VFs are always removed on PF remove, so
>>>> there should be no issues with VFs trying to access missing PF structures.
>>>>
>>>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>>>> ---
>>>>    drivers/net/ethernet/amd/pds_core/Makefile |   1 +
>>>>    drivers/net/ethernet/amd/pds_core/auxbus.c | 142 +++++++++++++++++++++
>>>>    drivers/net/ethernet/amd/pds_core/core.h   |   6 +
>>>>    drivers/net/ethernet/amd/pds_core/main.c   |  36 +++++-
>>>>    include/linux/pds/pds_auxbus.h             |  16 +++
>>>>    include/linux/pds/pds_common.h             |   1 +
>>>>    6 files changed, 200 insertions(+), 2 deletions(-)
>>>>    create mode 100644 drivers/net/ethernet/amd/pds_core/auxbus.c
>>>>    create mode 100644 include/linux/pds/pds_auxbus.h
>>>
>>> I feel that this auxbus usage is still not correct.
>>>
>>> The idea of auxiliary devices is to partition physical device (for
>>> example PCI device) to different sub-devices, where every sub-device
>>> belongs to different sub-system. It is not intended to create per-VF
>>> devices.
>>>
>>> In your case, you should create XXX vDPA auxiliary devices which are
>>> connected in one-to-one scheme to their PCI VF counterpart.
>>
>> I don't understand - first I read
>>      "It is not intended to create per-VF devices"
>> and then
>>      "you should create XXX vDPA auxiliary devices which are
>>      connected in one-to-one scheme to their PCI VF counterpart."
>> These seem at first to be directly contradictory statements, so maybe I'm
>> missing some nuance.
> 
> It is not, as I'm looking in the code and don't expect to see the code
> like this. It gives me a sense that auxdevice is not created properly
> as nothing shouldn't be happen from these checks.
> 
> +       if (pf->state) {
> +               dev_warn(vf->dev, "%s: PF in a transition state (%lu)\n",
> +                        __func__, pf->state);
> +               err = -EBUSY;
> +       } else if (!pf->vfs) {
> +               dev_warn(vf->dev, "%s: PF vfs array not ready\n",
> +                        __func__);
> +               err = -ENOTTY;
> +       } else if (vf->vf_id >= pf->num_vfs) {
> +               dev_warn(vf->dev, "%s: vfid %d out of range\n",
> +                        __func__, vf->vf_id);
> +               err = -ERANGE;
> +       } else if (pf->vfs[vf->vf_id].padev) {
> +               dev_warn(vf->dev, "%s: vfid %d already running\n",
> +                        __func__, vf->vf_id);
> +               err = -ENODEV;
> +       }
> 
>>
>> We have a PF device that has an adminq, VF devices that don't have an
>> adminq, and the adminq is needed for some basic setup before the rest of the
>> vDPA driver can use the VF.  To access the PF's adminq we set up an
>> auxiliary device per feature in each VF - but currently only offer one
>> feature (vDPA) and no sub-devices yet.  We're trying to plan for the future.
> 
> It looks like premature effort to me.
> 
>>
>> Is it that we only have one feature per VF so far is what is causing the
>> discomfort?
> 
> This whole patch is not easy for me.

Yes, those are extraneous checks left from testing the new driver 
organization.  They are no longer needed, and can come out in the next 
round.

In addition to spreading out the pds_core.rst creation across the 
patchset and adding more to the commit descriptions, I'll see if there 
are some other nips and tucks I can do to possibly make the patchset 
more palatable.

sln
