Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0520565E26F
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 02:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjAEBVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 20:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjAEBVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 20:21:19 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25472009;
        Wed,  4 Jan 2023 17:21:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CiC/ecREwZHzv5DdqPUVRzjQBVBkYLIRxrICIJ2gFNclQSMKlx7d5AftXjb11XB+29bXRTO+PNZ69C9rXeWDs/kvjiRAkPAmsbcWsDOtp0+5p9nFjDNoG8sZMZ6tHU/drc/e1vc7O2mjNnaglboJKdrA/XGRZjluHQhgnId9zM1VKf3QEvYZyRImubFuydEMEuWq05GhDPxS+w4LYqwEouJ3HfuA5fFufXjeMCbR+2nRUiwmQQNiCSGjHGmYjW1IGiq2XvCxmDUYyvo3VDydCZOpnzQut/eTCpXcLfqyVzbE3fX8O5dYFHIeueVTCdIt2c96EWqnkx+ijmjV1wLBAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JQskZp85qdJjpQEJ0BKPw+RuSg+mJk2lJ6fc9hmNchs=;
 b=GMLOV6ovQxMocF3Lh11AcGfVW/MPso6ogxN+RJGUUEmyKpmeGsCwYnCFjB2xOhyeqovGcoBGT+lLW01gzeXeAFQzSuX5lquPX3sr4vjoYEfYipkuL2HSl5dxIe8nGUQ0a0fcFhSdH6jgkQi2NdhnlpmOWFAdNbpELl39RDNtTJO89qiA8y2Ik5fPBsxDZDjIusOgt70o4Ux/tpm4tv4f+hZUcN3J7aMOFv2hC6xra5Ym2c9y0z8bdDkQEUzC2cHMxzAbTXTZ2kaR99RN/FBfW7uTBQNzYlERN0nEE4RgszZc51uOamxPFNcTuOc/Zbx6+WWj/voQzNz/5rTzbcUMgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQskZp85qdJjpQEJ0BKPw+RuSg+mJk2lJ6fc9hmNchs=;
 b=n3Qz5M95jduH6KP1NqALGoqG0uUKwS6ETQNN6q74NT1StRAjBfoG39nqy3PWPzU0TELqEZM6MI+0J8OnPUnQzzkOJChf1veh4Gloxn4RTi1euuyQSDKXi8toD+AOZwWpN6jb61V3+v9B7/YtAaH6EzG2VjjuFkiJwcrjjGbmnVrXuuTLGg7vkDZTAzJkz/T+tEB9VHO4bIew0sf5ei5xseJ2h763kN0mmGKTHsd3hBRDI0z/PdMwb9JeEkKvC7PS1j4WgYCjjhfEluImDi2vXW37i7wEMa8GbrOvLr7R6F8Xgf6MiPvH2FLCB2HdKotD89y4Gtr43Zc//lz71vPxPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by BL0PR12MB4913.namprd12.prod.outlook.com (2603:10b6:208:1c7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 01:21:15 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::ecfb:a3ad:3efa:9df8]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::ecfb:a3ad:3efa:9df8%3]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 01:21:15 +0000
References: <20221216192012.13562-1-mike.kravetz@oracle.com>
 <Y6A6KqXObGKxvDrX@dhcp22.suse.cz> <Y6C6B08nTWusK3RI@monkey>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Michal Hocko <mhocko@suse.com>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Rik van Riel <riel@surriel.com>,
        Will Deacon <will@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Christian Brauner <brauner@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] mm: remove zap_page_range and change callers to use
 zap_vma_page_range
Date:   Thu, 05 Jan 2023 12:14:36 +1100
In-reply-to: <Y6C6B08nTWusK3RI@monkey>
Message-ID: <87bkndvks7.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0090.namprd05.prod.outlook.com
 (2603:10b6:a03:332::35) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|BL0PR12MB4913:EE_
X-MS-Office365-Filtering-Correlation-Id: feb7a98e-c59a-4bff-9c3f-08daeebb23d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ftSKaxtp4Fe0L98M+VwsC+7qeHjI4/mavGJXlF27OfSzLjLAzX20TENea1Uj0U7m6X+RGsPSdogPWPhxO6pzOAC4dt001uScq1gJTAITRfiQMKhioKw59f1qvULwSbbw4BIZ+b80sQwBNWR101dninY4/Gm/zfnEY+1JtycZarkAV65eGgfllGBoF14SVX58wlLVEjhjFAW4/iQILHs43GolcTKsKcGBCXPpqHj2cYGNhIj97ipg32eAwGg2gzRADS1gDgJsoYUl7efoCbHP4buP6FGnYfNawqZedlygnmrwj5oZyqokTA1L3SLxMfpSfRtqTUITdt+PYAjbOuQgbMMSae3sTIhN9tqQkfrI89pyr/EgLUxV3m5u9q3bR4sTXpnaCh+e9kqPtXgXCcAMa78Zs8zDuV8dioePVRI6TxA3g6b+VQOEdS5ElMfJwlo3phfjBQwhmngsyXR57X83RmSBMm5Q82WMLboJxmMTQC44gNDQr87zPX+eaM6fvi3bsZlXBjohm1pVQFX9M5kzeSTJuxaVgiOKV+tRulAe9sv3uITVP1OlnNj8HKVf0wKZlXwIHfD+6QZhITY4pyO/BZzPjc7TiOQwqmmzTkvRCd4dYzrsfFeM+7VVns3hO0NSZssVC4xVhzqGqsKepW8vhJ1IH+Tg08aCtXKpfWlYyYLSAee+npYdVBK3WJ6NPF6AKhBDm2GBLl0oCTAWZpEtog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199015)(2616005)(66574015)(83380400001)(86362001)(36756003)(38100700002)(2906002)(6916009)(54906003)(41300700001)(7416002)(5660300002)(4326008)(66556008)(8676002)(66946007)(8936002)(66476007)(316002)(26005)(186003)(53546011)(478600001)(6512007)(966005)(6486002)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YU5kRWdZWVhpdm45WTc0TldldmRiYlhnb3ZTK1JXTVdsWEZCQWk4K0ZEWE1L?=
 =?utf-8?B?d0xpeDJvSWV4TUFDbFMvS1d4ZFdIUkoxdnpiYkJ0NUxqaHdlb1gwQUpKRXFM?=
 =?utf-8?B?UjN6OC9MZ0RETWplUGNQOU4zR2RlazM1akFvRUd6UHpRUlJYMkpzZVpMamxt?=
 =?utf-8?B?WnVzRURIYmxmcnVWRlc3aG5YTzVhSmNFblpjeE5wUkh1ZVFHQmhHZ2JiUHZH?=
 =?utf-8?B?VlBpR0ttc3BTU0k2L00xM2RoV3VlWlVDVXFMeGlFZm51SjFZWWdQeVZVTko5?=
 =?utf-8?B?aTlOVHBYc3NnZjdCTllSU3M5amo0amk0VkJyRldqeEVqMnZ1akpyVnRzSXFR?=
 =?utf-8?B?d3ljUXVBMWhtbzRmTDRJUy9lR2JzYkwvM2htZXdla0NCRHpEYWVGVGlvOUR3?=
 =?utf-8?B?amliS0cyYTVzSjNLYjFwUnhHQ1BNdWNyVnZTcEg3OCtHeHBwNVVmNlVzRXdK?=
 =?utf-8?B?VEkzTmlveHZSTmE2QzdPNzdGd1VJMEw0enZmZCtEZGoyV1FDRnFGZk5ZLzJN?=
 =?utf-8?B?b1ppL1NHeXJjdWFHSHUyNXArbXd4Q1h5U09BdE5MSk1Ka3dvbzcwU2MwVE5v?=
 =?utf-8?B?eCt3ZWFHWCtzRDRmK084RGdhWk5Jb20xNmhmcjdJRDk3MmdqUkpuVGVlYk9V?=
 =?utf-8?B?MHJxTzBZWDh5OW5zSnJFUkQrZnNXbEhWeWphakxsZEJ5RXUrV2QyRG1GUkNY?=
 =?utf-8?B?SmFGMXRhUndScS80RW15YmlmUHpEVW1tZThBVUNoVFJjSlZQcGVMNzJvSGtr?=
 =?utf-8?B?b0tucVNVczhvbHVrR1F1NTVPY1dxVGhCdzExd3g0SnJKVDJsVGJqa1FtR0h5?=
 =?utf-8?B?cnd4WW56OE4zcjVVK09JQ3lFd1AxN01sdlhFU2N1eEVwSnZBdW1TOFZJbm5n?=
 =?utf-8?B?UXp6RC81MkN6dzkveDFCbWhDbDdnYUtmWENXYTl0SlIvbFZJZ0NhdDNKMlor?=
 =?utf-8?B?KzZ0dnZSVFpOSC9IUkR0MnNFZ05qK21jd2t3aVpBTkFLKzhXQ0tOS2JZNE96?=
 =?utf-8?B?ams2N1ZPZmNJZ3ZGQjlRajkrVDF1dEg1RjV3ZjRQQ21QSlIrYyt2QzRMUUhu?=
 =?utf-8?B?ekJjRmFvYkNhSk5yZml2Tk1Oa3RiT1pPN0svRTVSSkdPWC9PK09DeDhjVncz?=
 =?utf-8?B?YVp3ZThmdk1EMzZPK29ZdlRzZmY0S0ViSDlHbG5NZnBCem1CZUxHeDQ2WGZT?=
 =?utf-8?B?bmlldHNzeDNJUkExL0pteDdMdWJvU1EzbE8xVzlqS2NVa2o1ZjJRRkplajA3?=
 =?utf-8?B?NnJFbXRxM3dBR0FGTlNTOGI1Vld0KzNKZkdaM3dTbkdUUld0cWNpU012NnBV?=
 =?utf-8?B?VEhVSitlODhWcWlaODd6NVVvWSt5M1o1Q2wxZnd3ODY1L0pZY243cDhFd2FV?=
 =?utf-8?B?MTlZUzIyK2QxRkNnTEExT1JiWlI2WjR1RUhjSWJNN29wdFFEVHVtQW9HZzdV?=
 =?utf-8?B?OHIyejdGRzIvWmYvL2ZQM3h6RlRReXU0V0p2VHZ5QmlWaTZZdHg3YkxYekVh?=
 =?utf-8?B?Ung5Y0VGZnpZWXZPQXg3aVV1alNwOUFpeFptYXVYRU5EMnhNVGNKY09sTERZ?=
 =?utf-8?B?V0dnYnpIUCtEUjJNR0U5WUowczlqYUxRenBQL0puOWFjQk4zWEpiZmNZUjlQ?=
 =?utf-8?B?ODFIK05qQnVOL3d5Vmc4eUsxb1BSb3pYQzlodFhQME9PK0FDeloxekpDYkJ3?=
 =?utf-8?B?ZmNtcnpTTVhmSlVQTlVYWnlEV2FaTkNGNjY2V2F3ZHJsb2cvUkYyQndaanUw?=
 =?utf-8?B?NmJyMnFTRW9jaFQvbklsVmVLK2JrSTZOY2VldEE5d1hsZWQxUzVISmYzYTNH?=
 =?utf-8?B?KzgzYmVMaTRxWVBuanNBOFgzSXh2Z3BEZlFua3JUYWoxMmd6Q003OXZJUVNi?=
 =?utf-8?B?ZGNMV3NwTlNSU0xnNHVMTzh5VUlpalRxY3hrNFdxRFU5czRzZUtKV090ZWR4?=
 =?utf-8?B?Y1FKRDFwYXN3Ymo5UnYxOFJ6aHFUeUVkU0pscmZ5SzdoTzBDd0kvOFhHbVRu?=
 =?utf-8?B?VXl2OGhMQ1pkRnFPK0VlL1pGY3orOVg2UTBML2J6WlN1WktwZDZ0YXcwTVBZ?=
 =?utf-8?B?NncwSVRibkVPeWRnSXIrMUF4MFViWVJQNXY5MDFnWHFPQ3B3N2JETVlSaVgw?=
 =?utf-8?Q?GtsSAXoANVX8ukXZZUdVakW7p?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feb7a98e-c59a-4bff-9c3f-08daeebb23d0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 01:21:15.5702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NfPiGGIpTyBRdhKV3uOxQH9Lh9YyGg4y7iW9/NtRgYvCEBj/BzI7e4XNwy3Sdig+7DcWtUCaEXeLb+mFwxjZ5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4913
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Mike Kravetz <mike.kravetz@oracle.com> writes:

> On 12/19/22 13:06, Michal Hocko wrote:
>> On Fri 16-12-22 11:20:12, Mike Kravetz wrote:
>> > zap_page_range was originally designed to unmap pages within an addres=
s
>> > range that could span multiple vmas.  While working on [1], it was
>> > discovered that all callers of zap_page_range pass a range entirely wi=
thin
>> > a single vma.  In addition, the mmu notification call within zap_page
>> > range does not correctly handle ranges that span multiple vmas as call=
s
>> > should be vma specific.
>>=20
>> Could you spend a sentence or two explaining what is wrong here?
>
> Hmmmm?  My assumption was that the range passed to mmu_notifier_range_ini=
t()
> was supposed to be within the specified vma.  When looking into the notif=
ier
> routines, I could not find any documentation about the usage of the vma w=
ithin
> the mmu_notifier_range structure.  It was introduced with commit bf198b2b=
34bf
> "mm/mmu_notifier: pass down vma and reasons why mmu notifier is happening=
".
> However, I do not see this being used today.
>
> Of course, I could be missing something, so adding J=C3=A9r=C3=B4me.

The only use for mmu_notifier_range->vma I can find is in
mmu_notifier_range_update_to_read_only() which was introduced in
c6d23413f81b ("mm/mmu_notifier: mmu_notifier_range_update_to_read_only()
helper"). However there are no users of that symbol so I think we can
remove it along with the mmu_notifier_range->vma field.

I will put togeather a patch to do that.

>>=20
>> > Instead of fixing zap_page_range, change all callers to use the new
>> > routine zap_vma_page_range.  zap_vma_page_range is just a wrapper arou=
nd
>> > zap_page_range_single passing in NULL zap details.  The name is also
>> > more in line with other exported routines that operate within a vma.
>> > We can then remove zap_page_range.
>>=20
>> I would stick with zap_page_range_single rather than adding a new
>> wrapper but nothing really critical.
>
> I am fine with doing that as well.  My only reason for the wrapper is tha=
t all=20
> callers outside mm/memory.c would pass in NULL zap details.
>
>>=20
>> > Also, change madvise_dontneed_single_vma to use this new routine.
>> >=20
>> > [1] https://lore.kernel.org/linux-mm/20221114235507.294320-2-mike.krav=
etz@oracle.com/
>> > Suggested-by: Peter Xu <peterx@redhat.com>
>> > Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
>>=20
>> Other than that LGTM
>> Acked-by: Michal Hocko <mhocko@suse.com>
>>=20
>> Thanks!
>
> Thanks for taking a look.

