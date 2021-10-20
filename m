Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77314344A0
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 07:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhJTFY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 01:24:58 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:40436 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230005AbhJTFY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 01:24:57 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K5IgSI017313;
        Wed, 20 Oct 2021 05:22:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=M3zj3HR38ju4gp1SZHrNW/BA6M77hV0CkGIcQsrcsK0=;
 b=crGWu1huM+TIIna967vieg/UKP8sGSVESCR3YhUBXa3FYNlpHcQkTohcggmHzoMgisrt
 BDo9k5kHMlnrMdT237+b69G9trrewnowx5GbJDefq1qPOoPVBXenf0WgQBslSJOq004m
 xbVJtUPvNg8ISxYEQcTVt6Oty2WivXABfu/7c6eEFkQMRMJxMkIxA9t6zgsoyRcZoHAB
 RgtE/txvhI3kRZVTetucI2FH6DDF5y5Js81cTcc0x7kzPkVDyuvbEuCj7Q3IHogRi7pD
 t+qUWTJEdngwGnedgTr4z4e64aQkq8713KbmmrUvd+OrFciUV0MLUTyXnkDc6nky9M0d RQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bt6pg874p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 05:22:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XlJxjXDggoOeYSjSXblPsAW2NJWbMuDwFMhWN8P04u8AXsfeItCTEwkE/uqqauFo69XiUihuhwNQ2cYKA6YBqxVl3PYGrNKiuwZ+vMYew1EurRpXN1satJU4kxoOklAg0uyP+Gff2DBPvAdY5ZPGivnqjb9vFEqrwV4doelsSLhhtMljiCXtvbQ3gyooT/SAIRB45e8v8M5bQiE9p3dWGmEYcR5UJfnyCqGwAZ1ZD77dy4VlziG7OOlw8feJifq4XbocGyjAa6hVbNhr61norf0lyAjWDMN31OlF24vqaEEjUC07vCyMgeiQAiMISIXwStczW5EpBBQv12s/5YmUiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M3zj3HR38ju4gp1SZHrNW/BA6M77hV0CkGIcQsrcsK0=;
 b=U/vIYeK1kpAwXuUw7GMGdTPy63mqZzMGkHKlmNlrPzaC7FX1bVodB2e8lVrh8ZoF8EtsG14ZNIDO+5pE7gcL+Zon2aRCBUCiW4rU8b8o4bP554e9l6e0/xJy18fsQcQbDXo5odekQPIES+BYi0h17WsnqsQ998ZUJ3VyvvuOwVYIq1OVfAXJJJP0juAUPj6ehGbodbohe0DWe2+4zEdgkmaG0FLqSTkof/v9BDyg7Q9uTMRFLqjO33iVUTZG7gkuTezVE0CPX2fLWn6iZJllhG0XKxFCXIcu2oYEn2ulSFjUjEYleLfeCw69VSUU5X7FtXPll0clJbg+0J/f9e0tVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from PH7PR11MB5819.namprd11.prod.outlook.com (2603:10b6:510:13b::9)
 by PH0PR11MB4854.namprd11.prod.outlook.com (2603:10b6:510:35::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Wed, 20 Oct
 2021 05:22:15 +0000
Received: from PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c]) by PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c%6]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 05:22:15 +0000
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
To:     Ming Lei <ming.lei@redhat.com>,
        =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Roman Gushchin <guro@fb.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
 <YW04Gqqm3lDisRTc@T590> <8fdcaded-474e-139b-a9bc-5ab6f91fbd4f@windriver.com>
 <YW1vuXh4C4tX9ZHP@T590> <a84aedfe-6ecf-7f48-505e-a11acfd6204c@windriver.com>
 <YW78AohHqgqM9Cuw@blackbook> <YW98RTBdzqin+9Ko@T590>
From:   Quanyang Wang <quanyang.wang@windriver.com>
Message-ID: <7a21a20d-eb12-e491-4e69-4e043b3b6d8d@windriver.com>
Date:   Wed, 20 Oct 2021 13:22:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YW98RTBdzqin+9Ko@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK2PR06CA0006.apcprd06.prod.outlook.com
 (2603:1096:202:2e::18) To PH7PR11MB5819.namprd11.prod.outlook.com
 (2603:10b6:510:13b::9)
MIME-Version: 1.0
Received: from [128.224.162.199] (60.247.85.82) by HK2PR06CA0006.apcprd06.prod.outlook.com (2603:1096:202:2e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Wed, 20 Oct 2021 05:22:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9413d2d-568f-4167-69fe-08d9938993da
X-MS-TrafficTypeDiagnostic: PH0PR11MB4854:
X-Microsoft-Antispam-PRVS: <PH0PR11MB48542D655748045B16E9F9AEF0BE9@PH0PR11MB4854.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I+Q3uuIp9PKA5incH1pEWGHR80wZFEkHvhK644d39Uo9E+3lU+WxCop0YAj2m+pHCWwDjtI2WSFByrOjnVxBDpya/lVkF2ObJqtTKbESCl7iPh3AKutxCtUbRRbDlXJhYgLOhLzsFa6aO2Vg/zT686GCRjxVIGNdsMHBbpddoJf1Nh2uYn31nB1T2ahLZcZrXYHSA0F5AB9OTO01q8vb6IGUi/STErDxL24GeuGa8HNQ5MUOnstRtBZrpe3FbJuetPYKWlSmpc3lJew5tog3LhCH20gJ+eS+lv6PJO1HiuqGuCj0Bt8P97deFrik9DNiFUdPjJcrzSL7Dz2z2/HaKr7xY/bUKWMS7sj4kWki1aTDnbPo55BIk5inGm8rMc9YkjZwhfm0QvuBdmbNZqitibLElwu/amXs78zpRR/iHjthLWMptuTBtFbsff9mX/uDPovq+cIQ/T/lwPGiihij56vz3st8sZ7zo+8omQtcGh5uJVRx+8oJKVeuK4cWI2DMNzDnvdBzKt0cjXeLMybt/+nUFFvTq8LkH5iar1eNHojweNT7S4K1WKzyo6mE/1olFos7SFOfJd2N+R1CDYYxJm7mJHfiXCwF+PrMXleqCeMe68UJw/5zc6Fzji4NYmPog6e11SxI+s1ckGRaHoDXADuK4qJVPX53OBBX+5Cdsfk7Z2Jc1lc4uvkF8P71EpTGs0LsWcmcqnihfUJ0kBF441jZRyqf4xJ6Tf3ldSBbSpG7vbrHcYW3LmVI1d7x+64TNI19T/660gbIqf12N/j6GauZy1zC3m8BGXG0nr1CFSw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5819.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(7416002)(6666004)(53546011)(316002)(38350700002)(31696002)(16576012)(110136005)(54906003)(5660300002)(38100700002)(52116002)(2906002)(44832011)(8936002)(66946007)(31686004)(956004)(508600001)(86362001)(66476007)(2616005)(6486002)(186003)(26005)(6706004)(8676002)(4326008)(66556008)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVpmNGM0M2wvbDB4YitYV2g1MVRlQWxWSlJPSTViM3FyOEdEWmZFeTd6ODRQ?=
 =?utf-8?B?R203SmlJaTZmcW9pV21UNE16WXlYZnI1TUh6dk0vKy9kNW9CcmN1NUNrSGg1?=
 =?utf-8?B?SkhsU2VaTkh4bmpGczNqd2NIMnVPV3BZRWtOdS95c1oveWFhTXlQYXg0eW91?=
 =?utf-8?B?M3hxM0ZjNDhYRW0zbFRDRXMwRzdSNVk3YnFkTlQxbEQvSEdIMDIxYk0zdC9a?=
 =?utf-8?B?V1BiOWg1YnpkcnFzQkRNdmMvNDNFSVpQNW51N2V0emk5QkNtb2ZweW5DdEIv?=
 =?utf-8?B?aVJMSEF3ek0zQUlYWHY3WWZUM3pXd1FaaXhLZmFGZy9yZUtGY1VWeElyVnIr?=
 =?utf-8?B?SlVNNFNqWDcyQ1pBaXVBN3N5c3NvblQraWZGdm1KeG95WU81TnFqMWxTNW9O?=
 =?utf-8?B?R3BBbkxKdFlkd25GWXdPdkhNUkkyYitBeXVneHlCMHo3bHVtVll0OEo3UkQ2?=
 =?utf-8?B?WTdvTG1nR1A5QTlaaWFYanh4eHp0ODIrWXd4Zm9ZRUE2V1pWU1Zpamx1YmpT?=
 =?utf-8?B?c1lQYlh0TTRvRnliQ3p2bWVmK21oZjg3UnFSWkQvV2FWcWY1cmJLeUZlcE81?=
 =?utf-8?B?VEFBMGh0RUlIbkxzV2tJMmJSZithK0w0ekJDVEY2OE11eEhtWUc2aEFJVGVa?=
 =?utf-8?B?QzdSY3BwT3FKWFRHcmJCT1g4eGl2clZrK2I4ME9mM0hYMDViMkVZMUwybDVK?=
 =?utf-8?B?VEpYdmFmSjFGcE4wNXpucmVUTW5HNWJlVEREMkdPdDBGWFpmcFFkTlhHbnhv?=
 =?utf-8?B?THhySTVNQWh2ZC9PVjZSQzhjSHNiOVZiYjgvZUJHNTBPQ0JhR3AwTmZGbjB2?=
 =?utf-8?B?d21lbEtleGU4YTc5Q2pKWkpKOExCQSs4S0czRVZ0YlNtaWp1M01CYkM3Nnlw?=
 =?utf-8?B?dUFDOUNNeEt6Vkl2ZjFwb2hCa0p3bFplS1d3T0FsNTFuckFPTjM2cmF0d3hq?=
 =?utf-8?B?T0lVVGE5UW9iVDdqUXdCM2Z2N2tiaXZRdDUrZEVlNENWaHp1dUlYVkxtWVh1?=
 =?utf-8?B?bHo4Z1hVOWRqc0dnbW9jT1dtMEV6K0QrWlZveFZtenV5dmZvcWY2WkxCclNL?=
 =?utf-8?B?K2kva3VzcmFEMlo2T2JZWFpnWXNjQmMrV2RoVVo3RTQ2WjRYN3JkOVdjYTNK?=
 =?utf-8?B?RDFZRnowZitCVlg5dERWUlhPMHkvMGg3QlZTTXBHdHZlYWVhb0JEZm9xVkxV?=
 =?utf-8?B?YUdrTXN6aGpsL3NoQmpsK1JJRHRpRDFSQ1orelgxOHdoSFRuaS9IZ3JYNWZK?=
 =?utf-8?B?UlZPSXZ1WkdLeFV2Nnh1NW40VnFhdVBoajdkclhXVG45MnhsSXV4eEFwaDho?=
 =?utf-8?B?VE1pRXZxVlFPU3lUUktRQkRadXFmWW0vTHV1WnZLb01jNTRXcXpwaEVTQnhH?=
 =?utf-8?B?MlBOWGtLTjNlbDNaY3lJZU5xSDBnRU4xZklrMW5EQTQ2UDk5LzJJbDBBbnpj?=
 =?utf-8?B?K3p5azhVSzhGT1VRY0hOeDg2WUQyL2FGcFIyMis0cFpRNzNSblNLeVZGcVU5?=
 =?utf-8?B?NmdUcEVkQStTV0xTaUdKMU9lK21kdlpEY09pZ0daVjl4K2JPZ3MvR0VQUFZr?=
 =?utf-8?B?RzJJR0plbGc1T01uMGpBQVFSaVptejRHVEc3MVlFSm43TnVpMUNieCtnaThi?=
 =?utf-8?B?RUk1SXpxdTZQV0FvL01Wdk1NUVhkdGh6RXVqclBmWlZ4V1dTRlR5a3UzVytJ?=
 =?utf-8?B?d2JJS0V6VjkwVHN3UWZWT1FsTWNla1BGWTdXc0dIV1prNUZlYWVrU3NVZ0Iz?=
 =?utf-8?B?b3Z4QzJtVW9pSEU0bmFjc0hkVVZCOVg5YmlqSVRBUjlFdDFJUi9kMXRkdWRU?=
 =?utf-8?B?emEzbjNJMmFWK1BEWXpneWtOSm55SUNPUG5VeThRUnRDcUFSaytLcWtiUnBW?=
 =?utf-8?B?U09VcldIUk5VdEVMdTVOUExuV3Y3T3VNVTRDcGN6Q21nZ0ZZZlNnOHhKeEJq?=
 =?utf-8?Q?ArcOFLSIcCsjgfaAAlrd/4vpCYIUu86n?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9413d2d-568f-4167-69fe-08d9938993da
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5819.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 05:22:15.2492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: quanyang.wang@windriver.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4854
X-Proofpoint-GUID: M3j9pFuZwwfb_6i5xzJn-giQYN7vy4zD
X-Proofpoint-ORIG-GUID: M3j9pFuZwwfb_6i5xzJn-giQYN7vy4zD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_01,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 adultscore=0 impostorscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=603 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110200027
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ming,

On 10/20/21 10:17 AM, Ming Lei wrote:
> On Tue, Oct 19, 2021 at 07:10:26PM +0200, Michal Koutný wrote:
>> Hi.
>>
>> On Tue, Oct 19, 2021 at 06:41:14PM +0800, Quanyang Wang <quanyang.wang@windriver.com> wrote:
>>> So I add 2 "Fixes tags" here to indicate that 2 commits introduce two
>>> different issues.
>>
>> AFAIU, both the changes are needed to cause the leak, a single patch
>> alone won't cause the issue. Is that correct? (Perhaps not as I realize,
>> see below.)
>>
>> But on second thought, the problem is the missing percpu_ref_exit() in
>> the (root) cgroup release path and percpu counter would allocate the
>> percpu_count_ptr anyway, so 4bfc0bb2c60e is only making the leak more
>> visible. Is this correct?
>>
>> I agree the commit 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of
>> percpu_ref in fast path") alone did nothing wrong.
> 
> If only precpu_ref data is leaked, it is fine to add "Fixes: 2b0d3d3e4fcf",
> I thought cgroup_bpf_release() needs to release more for root cgroup, but
> looks not true.
For now, I can only observe that precpu_ref data is leaked when running 
ltp testsuite.
Thanks,
Quanyang
> 
> 
> Thanks,
> Ming
> 
