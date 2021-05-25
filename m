Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8311A390C24
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 00:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbhEYW0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 18:26:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46240 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbhEYW0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 18:26:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PMACHV127272;
        Tue, 25 May 2021 22:23:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=J8Tz9xArRZ/Kbo65Z1kBBvQ1yqDyan8L6k8VI6YD/XQ=;
 b=nT6AwjEud8byQRdb2QlfzVMPej7rHVTlcLEsyzm4MOpmjnld1X2O8P8tN1S7z7BfvQ2f
 FyvhXX/gS+X3V0sf6RSbkDn3928xYCNCh1Awpzf4Efw8QvxF9Dv3CAOrVCwUFdv1rmmr
 A27bL2VVh9Zo1vOFqndBHFn1swZ5v+516+44WQVKrY84jbqtT/DByjAqMVp1kpKSe5S7
 XQM/UDqc1lJYdX7FtLsee44dRqqSo6RTXAVLfMUyuxcEHCR807Pkip20q6cE9klzarHC
 CskkfB3s9+CbJQCug96h9A2rS1a4x+0AyZTY/c/lUaf44z0OaAUZwI3R7OY3pTjvq0GA GA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 38rne4306q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 22:23:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PMA4nW154683;
        Tue, 25 May 2021 22:23:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3030.oracle.com with ESMTP id 38pr0c67b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 22:23:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxtDnDzY+GDYoJb6r912+uAniYtBKA2DRlYQ0Xcw3BRVnKo8SsqV22UvUwaoMHf+ozei/3dX/8pa1BxZQiAQmn0Shnte2rOiDXNpV4fjyX3z6hZ+YYXDmb8kd4jBta9kzxospbOM64+Ft1Ku/IB2YJATcqQdwdEuda2hpMm8EG1jUJX9DTHJmnSLn+YTXMHJoRbyASDiisyxc3JDNpPi1rR3kCdoo17OoJg0rJhx3T0vVrAJLyw35H9vI8CP1MesWgnYg49va3+y2NCunjwn7KDAEhL/6xxi4gr8wiF1hQ33sHFM1AUeFzb7/aiCRtuU0R9lGQ8gU2KMcjPXT8RTGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J8Tz9xArRZ/Kbo65Z1kBBvQ1yqDyan8L6k8VI6YD/XQ=;
 b=iS2opyuI0vQT+fgSrVAxbEWmUyJ3gUURVolc50Q0KwGnD7TjogYO/xZRrqUu0M9WuSPfsf9Ysyy/qF7m/NLtZ1Pf+aIXnGAloERiNzLbStw4zNJbg9jebuRFk6VIMRok8Yc+353sC20uwbt5/BeKuDsV1zRuvyhu726bSTe+o79Pd8l29KBU7KJLpYxWgbnUu+8htODpvSxWml7raq6XrRZE/z+vQ0XUAdy22iR48QogrYNUzvUarhpqTxQdJktyT0mbj6/yydeusqouImRdqcz+dGvp4R/x1u/r0cT0eRxAY22gMohhth7omE8vz64Yu+IO3BllO7+zaoOS1l5aag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J8Tz9xArRZ/Kbo65Z1kBBvQ1yqDyan8L6k8VI6YD/XQ=;
 b=S2JPFhKEQ7TkKjw7A5QNf8dVcAPtANEG2X75Cx9R/E99ndCaX1NqxFOPf1UqgKq2z6n7pjLaSdKLd5R9K9qdGn6BYHmcW/t8D0DL392NLwn+l2qoyVo1zC8/4J+IjclhXZotbqwkYHPiUTugqtQqcjEJLLYnyx7p46a0fpGYez8=
Authentication-Results: amazon.com; dkim=none (message not signed)
 header.d=none;amazon.com; dmarc=none action=none header.from=oracle.com;
Received: from CH0PR10MB5020.namprd10.prod.outlook.com (2603:10b6:610:c0::22)
 by CH0PR10MB5147.namprd10.prod.outlook.com (2603:10b6:610:c2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Tue, 25 May
 2021 22:23:42 +0000
Received: from CH0PR10MB5020.namprd10.prod.outlook.com
 ([fe80::6cb6:faf9:b596:3b9a]) by CH0PR10MB5020.namprd10.prod.outlook.com
 ([fe80::6cb6:faf9:b596:3b9a%7]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 22:23:42 +0000
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
        Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com,
        David <dwmw@amazon.co.uk>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        aams@amazon.com
References: <5f1e4772-7bd9-e6c0-3fe6-eef98bb72bd8@oracle.com>
 <20200921215447.GA28503@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <e3e447e5-2f7a-82a2-31c8-10c2ffcbfb2c@oracle.com>
 <20200922231736.GA24215@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200925190423.GA31885@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <274ddc57-5c98-5003-c850-411eed1aea4c@oracle.com>
 <20200925222826.GA11755@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <cc738014-6a79-a5ae-cb2a-a02ff15b4582@oracle.com>
 <20200930212944.GA3138@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <8cd59d9c-36b1-21cf-e59f-40c5c20c65f8@oracle.com>
 <20210521052650.GA19056@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <0b1f0772-d1b1-0e59-8e99-368e54d40fbf@oracle.com>
Date:   Tue, 25 May 2021 18:23:35 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
In-Reply-To: <20210521052650.GA19056@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [138.3.201.24]
X-ClientProxiedBy: SN4PR0801CA0016.namprd08.prod.outlook.com
 (2603:10b6:803:29::26) To CH0PR10MB5020.namprd10.prod.outlook.com
 (2603:10b6:610:c0::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.74.96.88] (138.3.201.24) by SN4PR0801CA0016.namprd08.prod.outlook.com (2603:10b6:803:29::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 25 May 2021 22:23:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a0e154d-1c51-485b-99b0-08d91fcbc079
X-MS-TrafficTypeDiagnostic: CH0PR10MB5147:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH0PR10MB5147C266742B68A582A728FC8A259@CH0PR10MB5147.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rowv2lsYuAeV2l5mN3E2pAgnk8lpIaPIxUozimH9ekGa5GctrUJS+QDPZfkQFuxtmOFtOtVP0bP7ZsI8hoVMyDVDnL3++o5z3zyu2pB2HwnV99OQCMLV8j1IQDxdV8qERwWH2wQ6lf28dm5WsJ/Rih5MKtRw0GrH+VLB0Tm8g67yva9GNyk9x1onCxoTIoT4XcFQubtU4J4doCHuJhywbhQofyc3YoHft5MAXs/dzzG5E+Jr9rjxLGAe/pntk54AgiVgfumm130VIKe6t0TH4oNhjT1VxQsSabRcJ+9yYSFvx8Y/owoxHOGBEYwtzzK418c5sczZ8a+kSsNgtyaWGJinKps3fa1IMiFYKgT1MF47eW6F8Lx3Fkpq3ao8LmZpDHNGKgrcimpPUZMbujDzP81lAgqsFqUTKv5mBRFCTmQOdNPeNg4u/GENWjjF4Usx/d4CilPehhzWsgc/W6eIAG3UySPWTMMtRvvybRs6QocFAOhnhkkMtY9egA+nvl4qbXpqCSwvz0eVyXbb3Q7RmoMutG23KCCMF4GKkA2JQuJgxHiaJFeDNKI/WpEGVdWBQ6MjC3XXo61MsAyQaLzU8KchHABBU29s450KXaJsWNr+m/XJWTeXS04FqHU3doY7/+bWqPuluy/K1xKLocWRQH7bm8LvixmA8VNfS4foYL/3+qkrzdhNN70veeusmCh9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5020.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(366004)(376002)(346002)(36756003)(66476007)(8936002)(86362001)(66946007)(478600001)(38100700002)(6916009)(8676002)(6486002)(66556008)(7416002)(44832011)(54906003)(956004)(316002)(2906002)(186003)(2616005)(5660300002)(31696002)(16526019)(31686004)(16576012)(4326008)(53546011)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dWxKdUtRdGNQcElqWEJOWXZQSzVWL1d6aVV4YjI4enZLYUxla2ZiVW9qdnhI?=
 =?utf-8?B?bzNWaWJSSG0xa2owdkZLVUV0Ykx5SHhCOWxUOTdZWDZqZU5kN1o2UDdtZWlx?=
 =?utf-8?B?RFRqWTdsaVZsWldyWlhTS0dIbzRJZDZEb29Zck5mSDV6aU5TeHBzYjJTMWgx?=
 =?utf-8?B?cVVRSEhtZEo1dHIvcXduMDcxdTlkR3N2RHdqdmJIeU1WOERCNmJxWHdhVWVB?=
 =?utf-8?B?cWlwRkZXdWpSWmVoMWV5QXFESUdFR20xZjN0WmkwSW1UajIwbGs4WU81ZE8z?=
 =?utf-8?B?WUhHTmR5aVVXaGVzcUhHN0RGRFI0bFdmYnJlTnpBYkVsMGF2VlVSa0ROQ3pH?=
 =?utf-8?B?ZjdnY0N4RkhHWFpyWFdsako3dDQzNkx6dVlveGVnOWlrdVNoc2h0OGdrTWh6?=
 =?utf-8?B?YUhIQllGS0ZJMUYvaDNhY2ZWcUV5T1R2RUwzbi9keE51cUVJMUg0RUJQWTJM?=
 =?utf-8?B?RUNVMXNoVUoxN1BnZXIza293cHI3TkxHd2NNQXNBQzIxZFZETFlNVW5sYjNm?=
 =?utf-8?B?QkdXaEN0QUs4d3hnczFSbGpML1cvb0RWdFI1K0RMNjhuMk9jQ0N6UDNaVHJB?=
 =?utf-8?B?bjdwOEtLSmQ2alRlR0liZ2VWVFNLTVMwK1Q4ek9scTExNGRGVXRFNFZOQkZO?=
 =?utf-8?B?Vmd4aFBtYUxrMnFzWWJLWmh2TTV6Z1ZoREtxaDBzbTZtTGMrZzRYcFBJR1NC?=
 =?utf-8?B?Mld3ZXhBb2lTSlRLUUdsTEUzNGg4c243TFFHTkk0Rzc0c1E1Q3RQaStBaEMr?=
 =?utf-8?B?QUlNOG5mVi9ZS2FRZ1c5UUhhZFlqa2l1Tk5JK0FGcndWblgxcDJiZE5vaE1y?=
 =?utf-8?B?Yll3a1l2VVQ4RHI3NHdYc3dFME9DZityWEw4aUV2ZlhBdldWREIvcDZhUjNU?=
 =?utf-8?B?Y0syM1VQVUF4ejBZNTBWQjZmZHduYi8wTjA4WE9ZbjBXZWRqZTdyT0RHZzFh?=
 =?utf-8?B?SmdaRzRJNnZpODNXQUxzVmoxbDlNZkZYd2FPSnd3MmZBaWRDK090bk1KejA0?=
 =?utf-8?B?RzlGQ0l3VUJnL0FCVnNHZkRlWHlrcldWdUJEWmZVWFAwV0NGa0tPNkRLUW5l?=
 =?utf-8?B?czJTNFkxcU15Z2JzNTlMSlNQVjIwcExzeml5K1hRUkJ6Q1EwRmw5YkNUazNO?=
 =?utf-8?B?UkkvRkN4WmR5Qi9hc3BYZGg1L2hHMElOYmRUUDZMajVjZUtOUU04R2V4cUk0?=
 =?utf-8?B?ZWVLSm1sd1FwLzNMa1Q4L2ZwOFg0Q3JhK0ZvdHBGODdsa01ONVJ4Qm41Q0hO?=
 =?utf-8?B?ZzRyK3YrTGgzTWRNTWthTXNHV1FnZWxrN0pLZUtuaS9zU2UyZlRKVkFSeDV4?=
 =?utf-8?B?cVI5eDA4ZktPdE8zcG15ckNxUmNxcUZLdFV3cnB4NHNoSTkvc2I4aTBhSEpQ?=
 =?utf-8?B?aXR5eEp3YmdxandnbnE4ekk1ZTJGS2xBR2MrQXNaeSsyUVhxSUM0RjBYR0NN?=
 =?utf-8?B?RnZFQ1ppeXRzZi9Nc2ZlZklUZlJCbEJSMzlhK0IzZk1XclVxOEVqR2lrQWdz?=
 =?utf-8?B?aE51eUtXZmFpdk45VUdjNjVFZUxhZm5CY1UxMHRrNUdWbi9XeHhFd1hId2Y5?=
 =?utf-8?B?a2V3S1NZaUxtbHVFYUs4alJCRW8yNXZUMUZXNGxjTDgvYWxjczZLa3JQcEJY?=
 =?utf-8?B?K2FzaUlic0p2NWJjQkN1Z0VpaDJ2eHBCQkpkeE9lcWlFQkRhZElpNUQ4WTVJ?=
 =?utf-8?B?YjJhcXc1cFFSN0dQNXFnMHVwZ2x2aFBPVCt0TitXVGlXeW5sN1M3NkhVWnJw?=
 =?utf-8?Q?iif8hnq/OiPu4QKdDPyr52oefA4heszcH9bLw2u?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a0e154d-1c51-485b-99b0-08d91fcbc079
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5020.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 22:23:42.2361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qmp8vwhJ1y5mlyw+9XHyzQDwFwynlVwqLAZMtFdQH/j1OHaP2ejPPiIKyBcNvUkcjF7pB87IPnz2UdhVo2ouyQpfuFkoUWo9taFx/W8O8yI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5147
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250138
X-Proofpoint-ORIG-GUID: TiUw2lT5LCPLgo7aW3qi6VWKkVOaj727
X-Proofpoint-GUID: TiUw2lT5LCPLgo7aW3qi6VWKkVOaj727
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250138
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/21/21 1:26 AM, Anchal Agarwal wrote:
>>> What I meant there wrt VCPU info was that VCPU info is not unregistered during hibernation,
>>> so Xen still remembers the old physical addresses for the VCPU information, created by the
>>> booting kernel. But since the hibernation kernel may have different physical
>>> addresses for VCPU info and if mismatch happens, it may cause issues with resume.
>>> During hibernation, the VCPU info register hypercall is not invoked again.
>>
>> I still don't think that's the cause but it's certainly worth having a look.
>>
> Hi Boris,
> Apologies for picking this up after last year. 
> I did some dive deep on the above statement and that is indeed the case that's happening. 
> I did some debugging around KASLR and hibernation using reboot mode.
> I observed in my debug prints that whenever vcpu_info* address for secondary vcpu assigned 
> in xen_vcpu_setup at boot is different than what is in the image, resume gets stuck for that vcpu
> in bringup_cpu(). That means we have different addresses for &per_cpu(xen_vcpu_info, cpu) at boot and after
> control jumps into the image. 
>
> I failed to get any prints after it got stuck in bringup_cpu() and
> I do not have an option to send a sysrq signal to the guest or rather get a kdump.


xenctx and xen-hvmctx might be helpful.


> This change is not observed in every hibernate-resume cycle. I am not sure if this is a bug or an 
> expected behavior. 
> Also, I am contemplating the idea that it may be a bug in xen code getting triggered only when
> KASLR is enabled but I do not have substantial data to prove that.
> Is this a coincidence that this always happens for 1st vcpu?
> Moreover, since hypervisor is not aware that guest is hibernated and it looks like a regular shutdown to dom0 during reboot mode,
> will re-registering vcpu_info for secondary vcpu's even plausible?


I think I am missing how this is supposed to work (maybe we've talked about this but it's been many months since then). You hibernate the guest and it writes the state to swap. The guest is then shut down? And what's next? How do you wake it up?


-boris



>  I could definitely use some advice to debug this further.
>
>  
> Some printk's from my debugging:
>
> At Boot:
>
> xen_vcpu_setup: xen_have_vcpu_info_placement=1 cpu=1, vcpup=0xffff9e548fa560e0, info.mfn=3996246 info.offset=224,
>
> Image Loads:
> It ends up in the condition:
>  xen_vcpu_setup()
>  {
>  ...
>  if (xen_hvm_domain()) {
>         if (per_cpu(xen_vcpu, cpu) == &per_cpu(xen_vcpu_info, cpu))
>                 return 0; 
>  }
>  ...
>  }
>
> xen_vcpu_setup: checking mfn on resume cpu=1, info.mfn=3934806 info.offset=224, &per_cpu(xen_vcpu_info, cpu)=0xffff9d7240a560e0
>
> This is tested on c4.2xlarge [8vcpu 15GB mem] instance with 5.10 kernel running
> in the guest.
>
> Thanks,
> Anchal.
>> -boris
>>
>>
