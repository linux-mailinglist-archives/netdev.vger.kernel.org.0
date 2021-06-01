Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC68839754C
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbhFAOV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:21:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60592 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbhFAOVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 10:21:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 151E9nPV070385;
        Tue, 1 Jun 2021 14:18:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=iq2IoC+rAI5TZaWS2GJdPAbjYc8YtZgDLuwhYcoU5ZM=;
 b=Q27+2miE3VP5CE3bsn3MVjrzS13oYM38oxdXA7ZP4yHcnd4pviDQLZ777Q1WhJ/xtAl3
 n/dbQIAzxoy0EpMHvw72guPAFNtOaMhjOfY5QI6D8Al4M0tu2NSaNWCiJzIe1K/Oyg0B
 hIAJFoR/zc0s2Yzi1pXa0EJXzOjZmnPLjFcJKPwXDLOdvvdfKu7NBvBLalZMAWPhez7j
 EJzuLDOcQgjT92QjVHex3ye/3Kz0NaUgtrHQshNXZq7MYQ4c2d9zjsp3zFbknliip1xq
 lXAHYDN3bDdGN/YYbsr3GFdAvljlN9sV/gqQBpffHMsPjFPMzdDVqKspkdKBZZxP1U1v aQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38ue8pdn0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 14:18:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 151EBFZJ194638;
        Tue, 1 Jun 2021 14:18:46 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by aserp3020.oracle.com with ESMTP id 38ude91kh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 14:18:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hrWlft7/ZmgTDCj2a04vWtm6K1efUr0NQGy2C7yHLOx90mxzziI4C/J3hQmndGs2nnCoai84igTY02DM50P3+d8/badr/Yuj0xSq+iJovSR1ysI/ll+mjUWAJzhn6KgqnA3Vd9rRJT0/cAsV9affSHYGOXW+Ut6gXJc9lwnWA00mBIna9Z8JbLTCPSwyf9C3+MCsTEAuP+4OWbKvXWng2COH7CaCb/I98pyG4VT69/3UyqMOYxzJ0viW/3fZiet+aTvU1ZMXgvuRW5t6uE2eNNePaicBRXIJEx2r2Eh8x4t6nFqdEKCf4DK38XyVeHFfqV8d7sYrT16BJNcIYbuqrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iq2IoC+rAI5TZaWS2GJdPAbjYc8YtZgDLuwhYcoU5ZM=;
 b=Y7kKGoixJj/8zgXMgpG61S6VKDz3mOGzbl9kD1R51cAKuoAltdJoPbyu3zs4JcgkuxCEs3/lx3kciMqUyvairKFvQCAOqDDqpvsXZF4SpLoara0ejZhNEREH18t9EUrMycPojNVnWqs127j96g2pLsIxSmpQUXrGHgpdJh84UyWd7mOWct+ZyUOl5qTP3M6BMuF3OKz5iV/kDWJYFPIOLg0v6vZaSSVmwCnasm/b7Hh0n/5/d9YDfSexTQwcJ1r70w8lEwdwqvqSuvs6DRcXMqx7LiyCT6DW1UKSJXqMAnXdLPJzqVMYOEKo9HOgWD1/8S/zFqGsfV3i++oYtRs9Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iq2IoC+rAI5TZaWS2GJdPAbjYc8YtZgDLuwhYcoU5ZM=;
 b=wixhrfWmVvDiyzkCuhI3Q90mtcuSOhUkP2NaXthB31IlmrUW+3CvSFJ/z/ZkayGbBEFMWhBxg3DhOwWh/dEfuXMdoGajexRmr8T+aGHXWku8NQ4BBXnK3HnmdhuCH3yJJRL2Msb2Dj5G+Nl34qXqAABhrJV8ZF+dzOZcmaVGpcc=
Authentication-Results: amazon.co.uk; dkim=none (message not signed)
 header.d=none;amazon.co.uk; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by MN2PR10MB4271.namprd10.prod.outlook.com (2603:10b6:208:199::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Tue, 1 Jun
 2021 14:18:42 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::78a3:67d:a8ca:93cf]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::78a3:67d:a8ca:93cf%7]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 14:18:42 +0000
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
        dwmw@amazon.co.uk
References: <20200925190423.GA31885@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <274ddc57-5c98-5003-c850-411eed1aea4c@oracle.com>
 <20200925222826.GA11755@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <cc738014-6a79-a5ae-cb2a-a02ff15b4582@oracle.com>
 <20200930212944.GA3138@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <8cd59d9c-36b1-21cf-e59f-40c5c20c65f8@oracle.com>
 <20210521052650.GA19056@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <0b1f0772-d1b1-0e59-8e99-368e54d40fbf@oracle.com>
 <20210526044038.GA16226@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <33380567-f86c-5d85-a79e-c1cd889f8ec2@oracle.com>
 <20210528215008.GA19622@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <1ff91b30-3963-728e-aefb-57944197bdde@oracle.com>
Date:   Tue, 1 Jun 2021 10:18:36 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
In-Reply-To: <20210528215008.GA19622@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [138.3.201.57]
X-ClientProxiedBy: SN1PR12CA0112.namprd12.prod.outlook.com
 (2603:10b6:802:21::47) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.74.100.249] (138.3.201.57) by SN1PR12CA0112.namprd12.prod.outlook.com (2603:10b6:802:21::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 14:18:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0787eed-b926-4449-61a2-08d9250828dc
X-MS-TrafficTypeDiagnostic: MN2PR10MB4271:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB4271CED78E24752F001BC1F58A3E9@MN2PR10MB4271.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bpGZM8FgifKtDDDUGAr2VKfUdL2YimEgKMnFxZAT0VOZsNyGHUzJqxEmqksWCkuv7kkA73Ti/W9ekqmhE6V9TJvolhFUUE0BsOlVuH7ZEKw3hqy0S4kSqY3PoEBr4nKRiKrD+pldUrZ5ybtSbhqFB773KUjTPzFosnjXnRBKAJT1Mc8PUgpMG06dWiL5RijIVezJBXR3wJ4Y1Xppr/dfsZ0O66nzJ2ef12pVF5s5TfJfmo4vOEm9QHMfq1rQmohsELEWInHaatSZKiSlGH99QM32msdjG0b2OTlENsZ12Xtzjpetoq/wsjWCz9MS1+PlGTJZ4rJ9cwjNp7qcMWkQPMI77VlSqidrE1l9hER7UZJMCXl3VaUhEvplOXxxf0eSypoHUai+lVeh8Xiz8g776d7E/a+33Zq5ruj/ci/SgaEOizNUpa9NfNEnDEHRrFFrCbEUYyY4KDSqd05Uk1KBpFEO1Hn5uh2V5enYjiozNMGq/b6nFRXT6OWgwiHrt21zX9UHwYYVA1Tu6eui+9Ah4lZ4ICPwNMwZDfOHBNYUZxlshuSzEHEAAXDw/5KEZyscjcRPfVKvlycq8rDopHeTPUfYLhuA5JLO7iPXd1739rcxzCLJheHc8Yc99xe66yJ00SQsRSlDq4kINDq51Su3H9uyQescB+u7ZBrMwCizDVPU2WCsow7lYrJLeDZ7DFvG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39860400002)(136003)(366004)(5660300002)(186003)(16526019)(6916009)(316002)(54906003)(38100700002)(36756003)(6666004)(6486002)(31686004)(7416002)(8676002)(8936002)(4326008)(86362001)(44832011)(83380400001)(2616005)(956004)(53546011)(66556008)(66476007)(66946007)(2906002)(31696002)(26005)(478600001)(16576012)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UDhrR1plR3FoZis2UTVUSnRVbzZIYzJONWNhZ3BCYU9mUThJVVdXQlNkZG5w?=
 =?utf-8?B?TG5WcnhBMFJsWEtWSm5tcS9wL2FkeGQ5NWNROXA4dmdjRTQ4UVVkcmlXNEZG?=
 =?utf-8?B?aUdpaVgrbEJWQWh0Z0h4OHRwT2FHT21LdFBFSFAwWFlOYU9wR3JhOS83OU9U?=
 =?utf-8?B?NG1MOWNaQkpVM2lpUjF0d3hCTXBMdXo0MjlvYkRFbjFMYVVVbVppWEdDUXFv?=
 =?utf-8?B?SW8rRzEwenRDamFaQmFXK01rblJJNGVxanNkTURIUmxqNTNPOXRNaDhOQnBs?=
 =?utf-8?B?cEFsZC8ydjRVUjh6eFZ0clgxeGVDZmVYZ2FoM0o1bE1sRjFhdXJ2UDd4YnRK?=
 =?utf-8?B?Mzc4QnYvakJVaktNSUo0VFBvblB6bEJiMUI4d2o0MTlMRml0UEo4eHZDbFJs?=
 =?utf-8?B?aFpOb2h0M1h1WTlobmhNQ3hJb0YvZTE4MUR5VHRGREFPVGsxTzkvNldUZGdJ?=
 =?utf-8?B?Ykk2dWMxMkxoWmJKYmQzZWNZS2hBbHd1L2U4WGNzSE14YkZldDlMeUd2ZTgv?=
 =?utf-8?B?NjFSTzN0dGVUMDhqUUJFZzBla3lBd2tydXQ5SzA4aWJLU25SaVpXTitWNUtO?=
 =?utf-8?B?LzhxVXFPdDlsOHZadllkTlczTTlaVk5jU0NEaEZ6VlI4Y1Q5MUkxNWR5ZGZW?=
 =?utf-8?B?L2drQjRpWHBDeUxuc3E0c1I3WkkrTXZkSWlYeGM5Zk9uZXdPUUpJdWFMSFlQ?=
 =?utf-8?B?dUpmQmt6L29ocUNULytLUHFjV0IyNk9XaVhMRFloS0U0NXkyWnhoYVk5OU92?=
 =?utf-8?B?MTVOL1p5TC9LUHg4QVpySzlGZ21tNjBoRE5INWtTYS8wSUk2TkVLR1FRblp6?=
 =?utf-8?B?NW5NM2l2MG5rcERJWFZiUkhTTjhVeEFaRWdDQUpvK2VNV1k5YUZuSkJLMjYw?=
 =?utf-8?B?ZDY3SXA2VklsOWF1RldETklnZkFqSkE4ZHptMndEdEp5Sjd3OGNiempSWFVZ?=
 =?utf-8?B?SzZFSlU1aDFYWjA0THZhWDFnR1RXU3NOMUJiRVhEZlNvTDZjaEgrak5Ob3g4?=
 =?utf-8?B?Q0drckU1YzhlQmZIaTlJa1g1UmV3YzFkNWFwWmMyYVUvVFNHazJYRG9LcFBU?=
 =?utf-8?B?ckJWSzVuRVd1WitHc2hpeUVtQm11b251UGVOOThPNXFxcU4rOVdFbThRSnFZ?=
 =?utf-8?B?bkdaKzhld05rblIrZGtuaW5ibVI2TUxKamtuZ3BDclRtUHFHRWRRWmRYcHE0?=
 =?utf-8?B?M25YZ0l4N0tVWjNVSUJvcHRFTG9mSm9Db2k1Mk9lZzQ2Z0hQTjlyb21USEth?=
 =?utf-8?B?Q0NuaE5jMFQvWmVpUTVlNUVjUFd1cjZ5bjhJM3VOaWh2ZG5GZ1VnQzhsRGJF?=
 =?utf-8?B?ZE0yanZzUUErc3lTK1pGSXRUVWI3V291OTFESFNWY0J4SnZCOGxUeWo3c0xI?=
 =?utf-8?B?OEp4dnljYVhHNFZhUE5Xb0VKU1krYW1GVE9MVEN4OWo3OFU2NXMzaFBWb3VT?=
 =?utf-8?B?ZUJzT1pSQnJneGEvaXVJQ2JWdUJ2SFNWcEltRitCcVlWSVpON1poK05vaEIy?=
 =?utf-8?B?aGNhWDRXbS9wM3BmT1RLMWhGTVFZZllCZzQxWTZoblc0d1V6NU5oanYwakVv?=
 =?utf-8?B?SmU0RVNTbmVPNUVBMG05UUx3azBlUU82OFZ3TDZKbk9QMnlZa3VOajRmNGlL?=
 =?utf-8?B?QmQ2UzVScEpZa0s0Rk9LejJJU3E4NUxHSHQwa3J3OE9lakhyUjdEOHlnSjJz?=
 =?utf-8?B?YXREbkhtcTExWGNjWmZoaGNtT1RTeGJPK2lSbklzaUhVNEtmMTlZL1NnMSs3?=
 =?utf-8?Q?uyF892CDBSzcSqyoaj/UVcjv/7E7WLOZmBUjmKx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0787eed-b926-4449-61a2-08d9250828dc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 14:18:42.7801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UQH8FOlBKmK9nVnr00riM+pbxqXDNFASFBn8fuRRIxnTkk+YZX9ZGVeC8gMVaiacoJm4HfQiR71KMRWTQFIGAdnqiALr7IVrbLaOP6eMrE8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4271
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106010097
X-Proofpoint-GUID: t1GTqF7qu9OyNqOxgVQ_J0d9c5GNRPTH
X-Proofpoint-ORIG-GUID: t1GTqF7qu9OyNqOxgVQ_J0d9c5GNRPTH
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106010097
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/28/21 5:50 PM, Anchal Agarwal wrote:

> That only fails during boot but not after the control jumps into the image. The
> non boot cpus are brought offline(freeze_secondary_cpus) and then online via cpu hotplug path. In that case xen_vcpu_setup doesn't invokes the hypercall again.


OK, that makes sense --- by that time VCPUs have already been registered. What I don't understand though is why resume doesn't fail every time --- xen_vcpu and xen_vcpu_info should be different practically always, shouldn't they? Do you observe successful resumes when the hypercall fails?


>
> Another line of thought is something what kexec does to come around this problem
> is to abuse soft_reset and issue it during syscore_resume or may be before the image get loaded.
> I haven't experimented with that yet as I am assuming there has to be a way to re-register vcpus during resume.


Right, that sounds like it should work.


-boris


