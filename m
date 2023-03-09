Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152AC6B26A3
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 15:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbjCIOUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 09:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbjCIOUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 09:20:13 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BC1C3611;
        Thu,  9 Mar 2023 06:20:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RzwfqulSR6LQJyBkeXslQ4DS5+HthEKOP+IwN/pL3MC6McNj6EpVXzjDwzrgkC8uEuIvwEU8ZnW2u2w+TlXDuBHAj+nvdmP7aSDSJpgd2woVapMrl1epkb/kBZ/6c88iFbA4EqpC7GRXYgptIaOy71crnJhb0gauo1A6UtbxtQE5vN0onApO5NK/QSE3JUQ3XMxz5jU4N2svAq/li5QIf4ZUMqaZeNZ0BLuFM7iBPDxuiVw/V1G6HfyVMDIkx18+hhnV/6fGV+a05LKdKmLiuYVigYmO3mo1QCf6nt3TUU/8vLFqRxoGvzmKj6YHgk4HevL8oTF7osHgCaG6UZ41dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mTJ1TmMBkmMeELwnKimg6YgQSTzCpa0bEpAiKq4G1qA=;
 b=W1E3VqaC8x1/AKpc+hjxD3uCiA+gC0KhD/tXJ7R2+BxIuIh/rVaSvC2j+BAedrA8jWW0fwcsgMKU4/lCYwL2Dg16GbR2ypJRFjXHQFYF2cr5sA37irXVfvDiolQLEHY1GjaQof2Fng4W6VlTU7lIi4ZyJ9nzvxIhj1vJPpSYXr2Q9rc3go2KnlDbZilBqoN2cNFbhzCfcA9dfJXV18KNh1UR/Wo8mSy1lOx3NGJ+ccI2iayv4V4DYhhzqVUUzXXNVKq198Lzp2pef8/jrak3OIwNF01cYdXplI+b1e282J0TXrgQkD3jiTBOc7+t6fRIL/w0EJhRu2N7S1d3LSyR+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mTJ1TmMBkmMeELwnKimg6YgQSTzCpa0bEpAiKq4G1qA=;
 b=ciAcetUdXTqaUTOo8K2vx+xb9TkKDyRwnC0Piq7Dai2G2PvPm2AjGve3d1CHb/M8twVzCmB5rwWyBWD66s4CeAReLfR941xItehcOBPW7VT4K2Q4fSy6lvYHuzEehxYMII7S8TimC3cNahYlDc0SQZNA+4NuiZfPg/NqLrFZ8xI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SJ0PR12MB5503.namprd12.prod.outlook.com (2603:10b6:a03:37f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Thu, 9 Mar
 2023 14:20:02 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60%4]) with mapi id 15.20.6178.017; Thu, 9 Mar 2023
 14:20:02 +0000
Message-ID: <a4fc8686-f82d-370e-309f-d6d3fc0568e8@amd.com>
Date:   Thu, 9 Mar 2023 08:19:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>,
        David Woodhouse <dwmw2@infradead.org>,
        =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "jane.chu@oracle.com" <jane.chu@oracle.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
References: <Y/aTmL5Y8DtOJu9w@google.com> <Y/aYQlQzRSEH5II/@zn.tnic>
 <Y/adN3GQJTdDPmS8@google.com> <Y/ammgkyo3QVon+A@zn.tnic>
 <Y/a/lzOwqMjOUaYZ@google.com> <Y/dDvTMrCm4GFsvv@zn.tnic>
 <BYAPR21MB1688F68888213E5395396DD9D7AB9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <255249f2-47af-07b7-d9d9-9edfdd108348@intel.com>
 <20230306215104.GEZAZgSPa4qBBu9lRd@fat_crate.local>
 <a23a36ccb8e1ad05e12a4c4192cdd98267591556.camel@infradead.org>
 <20230309115937.GAZAnKKRef99EwOu/S@fat_crate.local>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230309115937.GAZAnKKRef99EwOu/S@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:806:21::22) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SJ0PR12MB5503:EE_
X-MS-Office365-Filtering-Correlation-Id: 58664c71-ba4e-4bb6-dd3e-08db20a95f3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: id/F0342VzqulFp0e2M+RSd0T8VQIoOgdHqW9HScEs207JvgJwFjSj6HfMs9usJIYSuSzAooco6GFMmExMu6MMEcNMG1rsNQJ7TtVl9FYexhWginfmfXzwLJus2x408GcX4izO8B0poalJqalPlrJJXmshHuq5d9FMKN6poF3LautftH++mmFucmsx2JRZi2ckoCYhuS6XZzmpogkhL5iNtvVyKSNU2Vov42//vhcQnwqm8WC1ikpIR3fGpCxllAPsHwGoK5z2nfRHQgI1C7N3qtJ6UgJI1tRY04jhgFCAOrAx5lnw8ZALpXgw5E88/simqBq62e1XUayUIYQ1I4xLrxffcR5N+JcgECv+cZ31vmyr4xA/q1kkFiBPmFMJu9Rb2UgnJLyAeBcHnYM+fwBGMavGlNNQ7iTHf/8qmpPXPBaLU/c5LIkw+XwyjFDqWTBAiGnMs0hZJrY6Bunl8hQnMM9Ni72gnLxZYPApF8ytKE9noaSAY/YFoHj9+skuddp9DOpSoaToqnYq2znnyoq3UXP6Vsht0FEJq1znVwhUAxj6HaYi1EtndeEx2rW62x56jSVUFOYasX1Ph+TlccCJf+Vj4zzs9/H/gpbldCNKpEN1kngUkWaAAEIgAgq54PrnJaoMlqNbK5RHbDD6MDRMK0xfaaaMHC1dObCo91tHIE84IFniSLDoPo6QtUb1i7Y3JDZDvMEJSjzEO3Li4quqA3o6Q9hqmpOfBNtKTg6AI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(451199018)(31696002)(86362001)(66946007)(41300700001)(5660300002)(36756003)(66476007)(8676002)(8936002)(7406005)(7416002)(4326008)(38100700002)(66556008)(186003)(26005)(53546011)(2616005)(66574015)(478600001)(2906002)(966005)(316002)(54906003)(6506007)(6512007)(6666004)(110136005)(6486002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVhJSlh5RHBhamVrRHM1SElUQlRzbFgxeE5hNXNIdFc3dC9Dd29naHpmeE80?=
 =?utf-8?B?T0pHemY1ZzJWdThYWlNGb3ZycWh0VVNaSndjYTNxYXM5OHVlTjNFL09aWTZ2?=
 =?utf-8?B?bFFpT1pSb2xTd1lPbWo0QWhBSCtOSnVuWVRUeVYrbyszM0thNnAyM1FKV2Fh?=
 =?utf-8?B?MG5OTzIxSDNabk4vVWlhekNXVWVvd3BQdVhiaENDaThFZzN5SHlRWk8zNldx?=
 =?utf-8?B?YkFPTURab2tjU2tHbTVzdjl3SllLNTZ6Q2U4VXhQKzZveEZ1eElpSmpNc1d2?=
 =?utf-8?B?QXhZMTRZaitWL2hOaFkxWStoaURtRjRNQ3FjZTJ6dkZyZmdlbXprOXhPNFE4?=
 =?utf-8?B?UjhYYnJEWXhUaUFWTkErMEwwb2dYMkZyS2tibTQ1VjQ1VkFFRmJUQzFzbWFv?=
 =?utf-8?B?NkMwUzU2WUdtb3E4Sm8wYTdUcE1LekFTdVlGQ3RiVnVPZUwzTmUwSDVySzgw?=
 =?utf-8?B?QlpsWisvWTZEYUF2cXZXdmJWRU1idDkvWitVc0tXNkwzcFdVNXN5OGZuRDVH?=
 =?utf-8?B?TWtOMXc4SktCYXRxQmFJS2hiTkU3cGVzQWNRL3FEQVorVndqRUYrN1NBcUV0?=
 =?utf-8?B?QXllOThTbENGc3ZSYmJDNkhLNmlWRU9qeEY4ZkZtN0kvQWdCVXJLbVhvTzgw?=
 =?utf-8?B?TTVTU3ZzcjdSNVJpS3pkN0hyM09VejlaRU01WXNvbHZ4eTNRdGNWZDNBQXNj?=
 =?utf-8?B?NmJZVHd4OHRFalN1N2FFWkkrRnhmeTN0TXVYRHVaZ1JxWXBuTnRSY0lOQXMy?=
 =?utf-8?B?VlFNdEltR1d5MUljcU5OWUJ1QjFFa3NmbGJwQ2ozRkRyWTdBcForUGF6YmFF?=
 =?utf-8?B?ZGp6c2FCTjNDYVJ4Z3paemJVM0cyNmRjK01CcGNBR0xRbVV2K3g4NU00bDhC?=
 =?utf-8?B?SGdMSktYSUg1R2ZPRDY4YnNqVTBIL1UxVzc0eVE4dGIvY1dyOG1rL01YRzNM?=
 =?utf-8?B?Z0lla3FxUnh0YkdKRDV4OVZIakNDMGs0ZzRDZzVtbjhoUFBYS2IwVk1PLzZ5?=
 =?utf-8?B?b0ZEckw5VXRPYXd4T3JZT2dvRlN3WTgyL2llM20zZmxkcFRpOXNiR1liU1N0?=
 =?utf-8?B?eG5xRmtIbFUxbHdtbnlFTDBwUmNzZU5VbHp3TzllMGcxK05sYnJLVDEzcyt6?=
 =?utf-8?B?OUpiSGVXLzYyRngwcWtnUUhheWd4dVBNRDRMd3RvSk80WTlSc0JnS09GdlBv?=
 =?utf-8?B?WDYzYit0N01iWnRiMkFVdVFJK2ZIU0I3Zngzdk8yUTBMZm5pUWdUckxWTUxH?=
 =?utf-8?B?U0ZvMEYraFdnL08vYlFYRE1LVE5Uc2ZiRUM3UTk1SXRQa0wzaUtRQS9NdlA2?=
 =?utf-8?B?Sks1VnZzd3d3bS9KTHpSck0vbFdDSjF3Rk9aUnNBQXdvVndsTzV1NGZUY1lK?=
 =?utf-8?B?cjdqU3F4TjZGUUw3cDJ5QlhuYnV5SzhSeHdlMlJoY3hnU041MTFGV0VQd1Vz?=
 =?utf-8?B?MVBNaTZ4RkxWeVFSMFhCOXIxK1hKd3M3UnEvaWZlSnhJbUtqZDY4djgzYUVW?=
 =?utf-8?B?VlhxdVdrYTNEaEgrTXA0ejdaOU9GWjB0NkloVU0weEErb2ljN3JCd3FpbDJE?=
 =?utf-8?B?MjdHTFprOVBiTjBXMnZjYTg0bXEwUFZKSWlrWE1sZnlwUWYzbGNvL0xvbVh5?=
 =?utf-8?B?ak80L2J5b01VVnFPMXprYUhxTERaSW5HVTZUZ2pOTDZJemZVR2tXUTZmd2h2?=
 =?utf-8?B?Z1lOQjhtTWV0UnkyREVzcWZUR3QxZkI5RHBoWVVNMG1SZk0wNzJzeHNZbnBs?=
 =?utf-8?B?eC9pSWQvdlZHYWJpRVA4elhQMnNCY0JWYmhFQUNNaWlxbkZZQW00cWlieisr?=
 =?utf-8?B?bXhlL2lOSEp5VXNlT3RVV3Vvd0llOCtHcTFyMG1NeTFFSmpaN09UUkF4VVhK?=
 =?utf-8?B?a3VvSUkzQzF5ajZPT2JDU0VheE95Z3FVUDk1TktjL1BaZGZtNTFjZGNVYUpU?=
 =?utf-8?B?TzJzSzJtL2RFbGtKQTl1K2x2aDg2SzNjMlRZWXN1MUtQNkl4OHdXRVhSYzBP?=
 =?utf-8?B?UTlOYkNlUGNZRDBIQ2xMRjZtWU8yejlKbC9CRWZLR2JNYjQ1SExVMzZWYlI3?=
 =?utf-8?B?eWJZT3BUeFd6cGNNZk5NRC9nWCtHdG0ycEtMU0FYZHNRUXlGNHlFdWdRUFJQ?=
 =?utf-8?Q?+KlRC+6FGGhvI+rSB32JQIBzm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58664c71-ba4e-4bb6-dd3e-08db20a95f3f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 14:20:02.4995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nmvd3ZHvJj9MRvirekZbVNCThb4ZN1c0UkC2bJLL6ppds7Ks//xTEu1p+HUq1haDNd8fw+hNe7h2ChzZ+SueXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5503
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/23 05:59, Borislav Petkov wrote:
> First of all,
> 
> thanks for proactively pointing that out instead of simply using what's
> there and we get to find out later, only by chance.
> 
> Much appreciated. :-)
> 
> On Thu, Mar 09, 2023 at 11:12:10AM +0000, David Woodhouse wrote:
>>> Right, I think we're ok with the following basic rules:
>>>
>>> - pure arch/x86/ code should use the x86_platform function pointers to
>>>    query hypervisor capabilities/peculiarities
>>>
>>> - cc_platform_has() should be used in generic/driver code as it
>>>    abstracts away the underlying platform better. IOW, querying
>>>    x86_platform.... in generic, platform-agnostic driver code looks weird to
>>>    say the least
>>>
>>> The hope is that those two should be enough to support most guest types
>>> and not let the zoo get too much out of hand...
>>>
>>> Thx.
>>
>> In
>> https://lore.kernel.org/all/20230308171328.1562857-13-usama.arif@bytedance.com/
>> I added an sev_es_active() helper for x86 code.
>>
>> Is that consistent with the vision here, or should I do something different?
> 
> So looking at sev_es_init_vc_handling() where we set that key, I'm
> *thinking* that key can be removed now and the code should check
> 
>    cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT)
> 
> instead.
> 
> Because if some of the checks in that function below fail, the guest
> will terminate anyway.
> 
> Jörg, Tom?

I believe Joerg added that key for performance reasons, since it is used 
on the exception path and can avoid all the calls to cc_platform_has(). I 
think that key should stay.

Maybe David can introduce an CC_ATTR_GUEST_SEV_ES attribute that returns 
true if the guest is an ES or SNP guest. Or do we introduce a 
CC_ATTR_PARALLEL_BOOT attribute that returns true for any SEV guest.

Then the "if cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT) && !has_sev_es" 
check in arch/x86/kernel/smpboot.c can be removed and the following check 
can become if (x2apic_mode || cc_platform_has(CC_ATTR_PARALLEL_BOOT))

Not sure how that affects a TDX guest, though.

Thanks,
Tom

> 
