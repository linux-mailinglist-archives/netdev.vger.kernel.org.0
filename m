Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB9739ABAE
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 22:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFCUOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 16:14:41 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:54866 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhFCUOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 16:14:40 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153K98OH141782;
        Thu, 3 Jun 2021 20:11:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=EzbIaADvFD7uc8vEJGwdT6z9IDFMtlnY18zZuVGI6Co=;
 b=nAgUjNuoL/aHGNAh2P8goeRVyvuOJQNbeW7JVpyZKOwlQZkTQiyP9db7njj9KpzPxYEz
 wItE0rqHPyN6+jwplfVq23F5uGnbNyg841ZMAmryktl08N34Bj4ybYYY4wSRLCAyf5k0
 z4+7zZUIywTym1RKTDN3o1JTR4moLXY796qmG5Syyv7nef/92UpyL4g1LJx6UB0bv77y
 JQ71oCo5KMb15hEiov6sGlf8p5d2+vWPLAr4wxvClkQw6G3WYp/yIMz5GzHr3ovju9kB
 bnYcbISzOLeJ+pZHJMauuSy8u7jLA1bGmzOzI5GHg+G/dFdXX+p1bHJbORyLHwPMtWSs Yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38ub4cvd89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 20:11:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153KA5o2020924;
        Thu, 3 Jun 2021 20:11:54 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3030.oracle.com with ESMTP id 38uaqyky4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 20:11:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hAQEjZccADZazKafFH+jRFLq5CT8qSQ3g1zo9pl4QhxU53CuPRzO+QqYGHsFcL5BlAtB8y3IHotJA/NIOUIlKSpi2XgJuOYbdHnfe05qhegBkPDQU+xPF33wKjZDbICGWWk8p52M/oZt4N2TE5oUL/OGGaXJzlASXm02FMnyUjWd4seITNWiSAeLLfebu/fyg6A/dmyV/O6KaHllbHUEWj4duW/aBTQRJMoWv4naZfNLFp4owHNrmWLLuvyJk4W93/f2LC9TF6fTVERQzSY8NPFTb1oHNSOKUsaJWtnNQY3h83B5QTq9CDuCaAyenvMNrHF9UGZrupPLczTq3Lw9cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EzbIaADvFD7uc8vEJGwdT6z9IDFMtlnY18zZuVGI6Co=;
 b=J5XjqSu2YitBrbNbjHGzYnJWEqc21v+s7dX9xNR5aI6D9lGqMbggfvtwyDiPDuSiNx04gr6vFydZh8DGIPWjdJtTkICHkVF1RO2dpmJ7x7cROou1J24Ldod9XT9+SWNOEwWR/8Qyxstduw+Mgz0W1HpvMP3TvW8OEj+MN9keIjxCvftuZ8u1Z8EwKt24mKHdkxy0U8XkqkPkQhrLxTNoPEtix2Iy1+LCYFL+xz1/QNRg0nfeVc66nwWkpqsUkLbD5Lbv/yk+dID8CdGQRvNQWPEH4vx6Y4D4NwDEZjX6f56ZcglWiNWKWXymhmtScWXP8pCEre/m2mujgwczX/xTDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EzbIaADvFD7uc8vEJGwdT6z9IDFMtlnY18zZuVGI6Co=;
 b=yl/FOAbVew8BMNo6k3rAtZAQijw64kmRFXWWd4MZC0f4s73uyckYNevg0boU+17WGCKVn/WOl178AFiTKXXUy3oEl5b0jl3t/hWoOMXez1kNk54jDsvqO3OtEJQAL8+9by65/j71kncvFqk2ev1KFTmoev4GlimPRD3/bNwiP00=
Authentication-Results: amazon.co.uk; dkim=none (message not signed)
 header.d=none;amazon.co.uk; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by MN2PR10MB4318.namprd10.prod.outlook.com (2603:10b6:208:1d8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Thu, 3 Jun
 2021 20:11:52 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::78a3:67d:a8ca:93cf]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::78a3:67d:a8ca:93cf%7]) with mapi id 15.20.4195.023; Thu, 3 Jun 2021
 20:11:52 +0000
Subject: Re: [PATCH v3 01/11] xen/manage: keep track of the on-going suspend
 mode
To:     Anchal Agarwal <anchalag@amazon.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>
References: <20200925222826.GA11755@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <cc738014-6a79-a5ae-cb2a-a02ff15b4582@oracle.com>
 <20200930212944.GA3138@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <8cd59d9c-36b1-21cf-e59f-40c5c20c65f8@oracle.com>
 <20210521052650.GA19056@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <0b1f0772-d1b1-0e59-8e99-368e54d40fbf@oracle.com>
 <20210526044038.GA16226@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <33380567-f86c-5d85-a79e-c1cd889f8ec2@oracle.com>
 <20210528215008.GA19622@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <1ff91b30-3963-728e-aefb-57944197bdde@oracle.com>
 <20210602193743.GA28861@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <2cb71322-9d3d-395e-293b-24888f5be759@oracle.com>
Date:   Thu, 3 Jun 2021 16:11:46 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
In-Reply-To: <20210602193743.GA28861@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [160.34.88.237]
X-ClientProxiedBy: SN6PR01CA0001.prod.exchangelabs.com (2603:10b6:805:b6::14)
 To BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.74.96.237] (160.34.88.237) by SN6PR01CA0001.prod.exchangelabs.com (2603:10b6:805:b6::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Thu, 3 Jun 2021 20:11:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60065c02-fa52-4d39-8512-08d926cbd37a
X-MS-TrafficTypeDiagnostic: MN2PR10MB4318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB431894FFD732E001F5E3CB598A3C9@MN2PR10MB4318.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UdR5/lG+KwGp6XcH4A8M2jHkvEPp0v/TCH4IBelX+jopcmHHv8DXNY3o3oI9OgMPNCJjLnJFuYrK0puSCu96ZjWrZoRtQAsxNDHy0z+kUFeJdLXXQ3gSfGcATMaJdYWe14RKZ5qUOZ+dXrip/CBYtzegjpaQ1nRtAeue9H+4/uFkBxdOABrNE3x1mRiKmR3j7uu2cOXcUcSM3Bw2cX+pLpelltThNIbaYnFgnAX4pY+V/R7KQOsiq7PovE8zljPMeYjodULn580nWYoVN9E6NPUNnUMlPfeIIdhPwry1Ez3GZrLYQh8RX0HXKr48s2VnCp2GP7VojXKySHJR0oTrPuZgF7mlKuQI+hhSgMnSCZoGu1dx+ETZGQ15pOdlPONKIj7bSJQIMfpOA+8/GqAOmatDu/5+aACOh6yrfiwDCm4RmttehcJG203QDcf7spZaG/nVEhSIR97jnJqfVpeCRfe8aY2G7YkTlP67XLuMJYzNuN9q8nB7H2LYum7AqhDdrXMtQna1L3j+ClpM7CBLbAN2PcHkilhLBA85P4sdxnD1Q/GanP3Tzc+pGHJ04pR0MCD2/nlCardhHcqXUXet/NwbUnfXnOOUPfgvsyouLGKzWK+Crn5pHSaQdoJj2608cbHNVCKb9uYiFlhTaKjUv+YPuSwTWg83iuIUYC7IbJs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(136003)(366004)(396003)(346002)(478600001)(7416002)(316002)(36756003)(66946007)(53546011)(16576012)(44832011)(31686004)(86362001)(2906002)(8936002)(16526019)(6666004)(186003)(4326008)(5660300002)(8676002)(6916009)(66556008)(26005)(66476007)(38100700002)(6486002)(31696002)(83380400001)(54906003)(956004)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OXgvaEU1UkZ0REpFQlhpUUlMbitUeWcrM0haZ29LRk9Za0lPbXJ1bEhBRHVz?=
 =?utf-8?B?V1ZtK3hTZC9SNTJXMnRjcWxmUVlmWmluVWZYS2RreTRhNHprN0tZMlV2elEx?=
 =?utf-8?B?QW1UbklFU2dLdUtFcE55ZmNkL29tQTMzdmxZdkpxcWxNTHpOcTJZTW9JUlFB?=
 =?utf-8?B?RW55MzB1aHR0ZHMzNklJVnBWb0ZvWFphTm9QRnRKY1FCRDBjUjhGcXhzWHBk?=
 =?utf-8?B?OTgxNWZDQ1lKSzVNWkpNV3dnMyt1VlJoVm9MQUdVdXZNVWh5TlNWUndTNzRj?=
 =?utf-8?B?clBuRU4vVFpFaWpEUG00NzdwZndSc3Bkc0ErcmlBVlIydklnSzVpZ3ZjZWtz?=
 =?utf-8?B?UkJKOEU4NXZiVU5WY2VCMWs0dElwYXIydjRaSlNPSVlPMlViMHpVb1ZJdG5C?=
 =?utf-8?B?R0RiRmhSTFJ5VHkxWDdmK2ZibmFRaElYUjYzUDFRTmhoeXo1dXFEbkJUdG04?=
 =?utf-8?B?MXJpaHNOZDNrTFYzYTRWcnFQWjlENlFSa05lUzVkV2NYRWFDeUhUeXdwZy94?=
 =?utf-8?B?eWlQSE5JNlBDdW5OQ09mN090M3Azb0hDYm5VZkVjWG1pNUI0RVVoT282QXRD?=
 =?utf-8?B?S2paS2ZVRU5qNnJHMHlEZ0pUcUlQWTVyK2J0dXFhcFV5eU1ZWEt0a0N6bVQ0?=
 =?utf-8?B?b214T2VqczY5MjB4aTRaMUpBRmRVcE9DZWg4YUdJOEx4U3FjNmRKdDJGZDVs?=
 =?utf-8?B?WVdqUFBCS0dDQ0VlT1VRKzZjRjExM21DWDUxVGNuTFU0LytWdWpzbWRDb25N?=
 =?utf-8?B?Wm1MVTF3dlFTeU52Z0RBSkpBWmxwWUo4VG4zVmZabkM4Vk9QVzQxTnFzbjZr?=
 =?utf-8?B?N0hwVjFvWWd0L0p2RG1YeDlxTEtFWXBGYzl6bkhOMGZ0OGhJTDYydmVuaU0v?=
 =?utf-8?B?SEo4VEdCYlllNi9QdmtBSVZ2WDIvdTBieTRjSDJUTExoL0lLS0dMRkFsQnZS?=
 =?utf-8?B?NE9WSWhTVStiWEJhaEZPc2hsbGhNdkFvLzFPZDh2QldTNzFxSXZ6MnY4MEgz?=
 =?utf-8?B?dkg0akdydEZOS00wNmt4dUtwOEM2MTNZNnpaYnZGNGNJMFN4ZzFFMTU1RjN4?=
 =?utf-8?B?NzFFZUlZRno4eHJIT1BpbFA4M2hSUEkwWWJBQzNFVSsyZjV4YWJVeDdmRVk2?=
 =?utf-8?B?RWQ4M0JvRkszRUNPdllNZXYxLzRvaFRVWENNWWtjMkhtTndRSHY2czR5VG1P?=
 =?utf-8?B?YlpaNXVyTkhRbHlNeE1iVTA4RGZhUkpMZ3NYRGxCblZSZjIySFRGTE1RLy8w?=
 =?utf-8?B?M0RYQ0ZzRlcxazNnRWxZeGx6QmtobWhSYlRBYk5kVzNYcHIza2tUTytEKzRK?=
 =?utf-8?B?c0MweG9zTWZldE5HaUVyUzFVeVBGWmhGbUhrbmY3Tk9mQjBvcE1RYXhDdEpq?=
 =?utf-8?B?dmFPKzJDNzNYNjdoOEJlZ1AzR0s3R3hpdFEweGJYNzdDOG9leU01c1ZUc25v?=
 =?utf-8?B?ZWlUZ1lvRjBtTjhycFpqRldIVitoRlRva0V4NFJvRTVFMC9DZ0d4c2lmbC9T?=
 =?utf-8?B?U3M1bUZLQ090UFRFQzhxVW8vdDlmcFJhSGM0enMvZ0V1dXJmNU1IZkk1eFIw?=
 =?utf-8?B?T1E2NkFhck1NM0ZjL3NRUThPNHZmVHZ2VEdSbGJiZUl2cVRiVHdRODRJM2V3?=
 =?utf-8?B?SC9MaGdCWTJjNVJZWFh1Z1hKeG5FQUtvQnVBeU1udEl5Rmg1ZU9zTU9wVk9K?=
 =?utf-8?B?WlZsZUY2Sk90SlBIUDdhZHdwbWJRdzdNTng5T0lxeTg4ZG5nTnBrM0xxN1p4?=
 =?utf-8?Q?ryW1Q1RtosiCIbXVLd1B4osWXm3COGyGguxAlr8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60065c02-fa52-4d39-8512-08d926cbd37a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 20:11:52.0453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VmtzoBFR7zBoFoDClJFpffv91j11nHxxY7Puxp9Qxx7e9L40cQ8X47un1L1vMhq4cnZNWNWwxvIXyj2Ey78Lod6q29Y2FOMEfBeuN5MDStE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4318
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030137
X-Proofpoint-GUID: XdOfLFfusTcYPM6RTxXcOxVnLMyrk-_F
X-Proofpoint-ORIG-GUID: XdOfLFfusTcYPM6RTxXcOxVnLMyrk-_F
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106030137
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/2/21 3:37 PM, Anchal Agarwal wrote:
> On Tue, Jun 01, 2021 at 10:18:36AM -0400, Boris Ostrovsky wrote:
>>
> The resume won't fail because in the image the xen_vcpu and xen_vcpu_info are
> same. These are the same values that got in there during saving of the
> hibernation image. So whatever xen_vcpu got as a value during boot time registration on resume is
> essentially lost once the jump into the saved kernel image happens. Interesting
> part is if KASLR is not enabled boot time vcpup mfn is same as in the image.


Do you start the your guest right after you've hibernated it? What happens if you create (and keep running) a few other guests in-between? mfn would likely be different then I'd think.


> Once you enable KASLR this value changes sometimes and whenever that happens
> resume gets stuck. Does that make sense?
>
> No it does not resume successfully if hypercall fails because I was trying to
> explicitly reset vcpu and invoke hypercall.
> I am just wondering why does restore logic fails to work here or probably I am
> missing a critical piece here.


If you are not using KASLR then xen_vcpu_info is at the same address every time you boot. So whatever you registered before hibernating stays the same when you boot second time and register again, and so successful comparison in xen_vcpu_setup() works. (Mostly by chance.)


But if KASLR is on then this comparison not failing should cause xen_vcpu pointer in the loaded image to become bogus because xen_vcpu is now registered for a different xen_vcpu_info address during boot.


>>> Another line of thought is something what kexec does to come around this problem
>>> is to abuse soft_reset and issue it during syscore_resume or may be before the image get loaded.
>>> I haven't experimented with that yet as I am assuming there has to be a way to re-register vcpus during resume.
>>
>> Right, that sounds like it should work.
>>
> You mean soft reset or re-register vcpu?


Doing something along the lines of a soft reset. It should allow you to re-register. Not sure how you can use it without Xen changes though. 



-boris

